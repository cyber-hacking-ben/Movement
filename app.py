from fastapi import FastAPI
from pydantic import BaseModel
import subprocess
import tempfile
import os
import base64
import glob # Need glob for file matching

from formatter import format_compiler_response

app = FastAPI(
    title="Move Compiler Service",
    description="Compiles Move smart contracts and exposes bytecode + metadata",
    version="1.0.0"
)

# -------------------------------------------------------------------
# Lightweight Move.toml
# -------------------------------------------------------------------
MOVE_TOML = """\
[package]
name = "compiler_package"
version = "1.0.0"
upgrade_policy = "compatible"
edition = "2024.beta"  <-- CRITICAL: Added this back

[addresses]
std = "0x1"
hello = "0x42"

[dependencies]
MoveStdlib = { local = "/frameworks/aptos-core/aptos-move/framework/move-stdlib" }
"""

class CompileRequest(BaseModel):
    code: str

@app.post("/compile")
def compile_move(request: CompileRequest):
    with tempfile.TemporaryDirectory() as tmp:
        sources_dir = os.path.join(tmp, "sources")
        os.mkdir(sources_dir)

        # Write Move.toml
        with open(os.path.join(tmp, "Move.toml"), "w") as f:
            f.write(MOVE_TOML)

        # Write source file
        with open(os.path.join(sources_dir, "module.move"), "w") as f:
            f.write(request.code)

        try:
            result = subprocess.run(
                ["movement", "move", "build"],
                cwd=tmp,
                capture_output=True,
                text=True,
                timeout=400
            )

            # -------------------------------
            # Compilation failed
            # -------------------------------
            if result.returncode != 0:
                return format_compiler_response({
                    "success": False,
                    "error": result.stderr or result.stdout
                })

            # -------------------------------
            # Compilation succeeded
            # -------------------------------
            build_dir = os.path.join(tmp, "build", "compiler_package")
            bytecode_dir = os.path.join(build_dir, "bytecode_modules")
            metadata_path = os.path.join(build_dir, "package-metadata.bcs")

            modules = []

            # Read all compiled .mv files
            if os.path.isdir(bytecode_dir):
                for file in os.listdir(bytecode_dir):
                    if file.endswith(".mv"):
                        with open(os.path.join(bytecode_dir, file), "rb") as f:
                            modules.append({
                                "name": file.replace(".mv", ""),
                                "bytecode_base64": base64.b64encode(f.read()).decode("utf-8")
                            })

            # Read package metadata (.bcs)
            package_metadata_bcs = None
            if os.path.exists(metadata_path):
                with open(metadata_path, "rb") as f:
                    package_metadata_bcs = base64.b64encode(f.read()).decode("utf-8")

            return format_compiler_response({
                "success": True,
                "modules": modules,
                "package_metadata_bcs": package_metadata_bcs,
                "compiler_stdout": result.stdout,
                "metadata": {
                    "module_count": len(modules),
                    "has_metadata": package_metadata_bcs is not None
                }
            })

        except Exception as e:
            return format_compiler_response({
                "success": False,
                "error": str(e)
            })