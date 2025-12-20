from fastapi import FastAPI
from pydantic import BaseModel
import subprocess
import tempfile
import os
import base64
import glob

app = FastAPI(
    title="Move Compiler Service",
    description="Compiles Move smart contracts and returns bytecode + package metadata",
    version="1.1.0"
)

# -------------------------------------------------------------------
# Lightweight Move.toml (MoveStdlib only)
# -------------------------------------------------------------------
MOVE_TOML = """\
[package]
name = "compiler_package"
version = "1.0.0"
upgrade_policy = "compatible"

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
    code = request.code

    with tempfile.TemporaryDirectory() as tmp:
        # -----------------------------
        # Write Move.toml
        # -----------------------------
        with open(os.path.join(tmp, "Move.toml"), "w") as f:
            f.write(MOVE_TOML)

        # -----------------------------
        # Write source file
        # -----------------------------
        src_dir = os.path.join(tmp, "sources")
        os.mkdir(src_dir)

        source_path = os.path.join(src_dir, "module.move")
        with open(source_path, "w") as f:
            f.write(code)

        # -----------------------------
        # Run compiler
        # -----------------------------
        try:
            result = subprocess.run(
                ["movement", "move", "build"],
                cwd=tmp,
                capture_output=True,
                text=True,
                timeout=400
            )
        except Exception as e:
            return {
                "success": False,
                "error": str(e)
            }

        # -----------------------------
        # Handle compilation failure
        # -----------------------------
        if result.returncode != 0:
            return {
                "success": False,
                "error": result.stderr or result.stdout
            }

        # -----------------------------
        # Extract bytecode (.mv files)
        # -----------------------------
        bytecode_dir = os.path.join(
            tmp,
            "build",
            "compiler_package",
            "bytecode_modules"
        )

        modules = []

        for mv_file in glob.glob(os.path.join(bytecode_dir, "*.mv")):
            with open(mv_file, "rb") as f:
                raw = f.read()

            modules.append({
                "module_name": os.path.basename(mv_file).replace(".mv", ""),
                "bytecode_base64": base64.b64encode(raw).decode("utf-8"),
                "size_bytes": len(raw)
            })

        # -----------------------------
        # Extract package metadata (.bcs)
        # -----------------------------
        metadata_path = os.path.join(
            tmp,
            "build",
            "compiler_package",
            "package-metadata.bcs"
        )

        package_metadata = None

        if os.path.exists(metadata_path):
            with open(metadata_path, "rb") as f:
                package_metadata = base64.b64encode(f.read()).decode("utf-8")

        # -----------------------------
        # Final response
        # -----------------------------
        return {
            "success": True,
            "modules": modules,
            "package_metadata_bcs": package_metadata,
            "compiler_stdout": result.stdout,
            "metadata": {
                "package_name": "compiler_package",
                "module_count": len(modules),
                "language": "Move",
                "framework": "MoveStdlib"
            }
        }

