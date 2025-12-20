import re
from typing import Dict, Any, List

# ---------------------------------------------------------
# Regex Patterns
# ---------------------------------------------------------

# Matches Move compiler error headers
# Example:
# error: unexpected token
#   ┌─ /path/file.move:12:8
ERROR_BLOCK_REGEX = re.compile(
    r"error:\s*(?P<message>.*?)\n\s*┌─\s*(?P<file>.*?):(?P<line>\d+):(?P<column>\d+)",
    re.DOTALL
)

# Matches the code line + pointer that follows an error
# Example:
# │ let x = foo(
# │        ^^^^^
LINE_POINTER_REGEX = re.compile(
    r"│\s*(?P<code>.+?)\n\s*│\s*(?P<pointer>\^+)"
)

# Matches compiled module IDs in successful output
# Example:
# "0000000000000000000000000000000000000000000000000000000000000042::counter"
MODULE_ID_REGEX = re.compile(
    r'"([0-9a-fA-F]{64}::[a-zA-Z_][a-zA-Z0-9_]*)"'
)


# ---------------------------------------------------------
# Public Formatter Function
# ---------------------------------------------------------

def format_compiler_response(
    *,
    success: bool,
    raw_stdout: str = "",
    raw_stderr: str = "",
    bytecode: Dict[str, str] | None = None,
    metadata: str | None = None,
) -> Dict[str, Any]:
    """
    Formats compiler output into a frontend-safe structure.
    """

    if success:
        return _format_success(raw_stdout, bytecode, metadata)

    return _format_errors(raw_stderr or raw_stdout)


# ---------------------------------------------------------
# Success Formatter
# ---------------------------------------------------------

def _format_success(
    raw_stdout: str,
    bytecode: Dict[str, str] | None,
    metadata: str | None,
) -> Dict[str, Any]:
    modules = MODULE_ID_REGEX.findall(raw_stdout)

    return {
        "success": True,
        "modules": modules,
        "bytecode": bytecode or {},
        "package_metadata": metadata,
        "raw_output": raw_stdout.strip(),
    }


# ---------------------------------------------------------
# Error Formatter (Multi-error Safe)
# ---------------------------------------------------------

def _format_errors(raw_output: str) -> Dict[str, Any]:
    errors: List[Dict[str, Any]] = []

    for match in ERROR_BLOCK_REGEX.finditer(raw_output):
        error = {
            "message": match.group("message").strip(),
            "file": match.group("file"),
            "line": int(match.group("line")),
            "column": int(match.group("column")),
            "source_line": None,
            "pointer": None,
        }

        # 🔧 FIX: Search AFTER this error block
        pointer_match = LINE_POINTER_REGEX.search(raw_output, match.end())
        if pointer_match:
            error["source_line"] = pointer_match.group("code").rstrip()
            error["pointer"] = pointer_match.group("pointer")

        errors.append(error)

    # Fallback: if Move fails in a non-standard way
    if not errors:
        return {
            "success": False,
            "errors": [],
            "raw_error": raw_output.strip(),
        }

    return {
        "success": False,
        "errors": errors,
    }
