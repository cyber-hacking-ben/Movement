import re
from typing import Dict, Any

# Regex to capture Move compiler error blocks
ERROR_BLOCK_REGEX = re.compile(
    r'error: (?P<message>.*?)\n\s*┌─ (?P<file>.*?):(?P<line>\d+):(?P<col>\d+)\n.*?\n\s*│\s*(?P<code>.*?)\n',
    re.DOTALL
)

def _format_success(stdout: str, bytecode: Dict[str, str] | None, metadata: str | None) -> Dict[str, Any]:
    """
    Internal helper: formats a successful compilation output.
    """
    return {
        "success": True,
        "stdout": stdout,
        "bytecode": bytecode,
        "metadata": metadata
    }


def _format_errors(stderr: str) -> Dict[str, Any]:
    """
    Internal helper: formats compilation errors in a structured way.
    """
    errors = []

    for match in ERROR_BLOCK_REGEX.finditer(stderr):
        errors.append({
            "message": match.group("message").strip(),
            "file": match.group("file").strip(),
            "line": int(match.group("line")),
            "column": int(match.group("col")),
            "source_line": match.group("code").strip()
        })

    # Fallback if regex didn't match anything
    if not errors:
        errors.append({"message": stderr.strip()})

    return {
        "success": False,
        "errors": errors
    }


def format_compiler_response(
    success: bool,
    raw_stdout: str = "",
    raw_stderr: str = "",
    bytecode: Dict[str, str] | None = None,
    metadata: str | None = None
) -> Dict[str, Any]:
    """
    Formats compiler output into a frontend-safe structure.
    Exposes bytecode and package metadata for successful compilations.
    """
    if success:
        return _format_success(raw_stdout, bytecode, metadata)

    return _format_errors(raw_stderr)
