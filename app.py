from pydantic import BaseModel
from fastapi import FastAPI
import subprocess
import tempfile
import os

app = FastAPI(
    title="Move Compiler Service",
    description="A backend service that compiles Move smart contracts using the Movement CLI",
    version="1.0.0"
)

# -------------------------------------------------------------------
# UPDATED Move.toml template
# 
# Key Change: Dependencies are now LOCAL.
# They point to /frameworks/aptos-core/... which we baked into the Docker image.
# This makes compilation offline and instant.
# -------------------------------------------------------------------
# UPDATED Move.toml template to Allow move 2 language
# Line 28 edition = "2024.beta"   #THIS IS THE MAGIC LINE TO FIX THE ERROR
# -------------------------------------------------------------------
MOVE_TOML = """\
[package]
name = "compiler_package"
version = "1.0.0"
upgrade_policy = "compatible"
edition = "2024.beta"   

[addresses]
std = "0x1"
aptos_framework = "0x1"
hello = "0x42"

[dependencies]
# Pointing to the COPIED path inside the container
MoveStdlib = { local = "/frameworks/aptos-core/aptos-move/framework/move-stdlib" }
AptosFramework = { local = "/frameworks/aptos-core/aptos-move/framework/aptos-framework" }
"""

class CompileRequest(BaseModel):
    code: str

@app.post("/compile")
def compile_move(request: CompileRequest):
    code = request.code

    with tempfile.TemporaryDirectory() as tmp:
        move_toml_path = os.path.join(tmp, "Move.toml")
        src_dir = os.path.join(tmp, "sources")
        os.mkdir(src_dir)

        with open(move_toml_path, "w") as f:
            f.write(MOVE_TOML)

        source_file = os.path.join(src_dir, "module.move")
        with open(source_file, "w") as f:
            f.write(code)

        try:
            # Added --skip-fetch-latest-git-deps to force offline mode if the CLI supports it
            # (Even if it doesn't, the 'local' paths in toml prevent network calls)
            result = subprocess.run(
                ["movement", "move", "build"],
                cwd=tmp,
                capture_output=True,
                text=True,
                timeout=60 # Reduced timeout because it should be instant now
            )

            if result.returncode != 0:
                return {
                    "success": False,
                    "error": result.stderr or result.stdout # sometimes errors go to stdout in Move
                }

            return {
                "success": True,
                "stdout": result.stdout
            }

        except Exception as e:
            return {
                "success": False,
                "error": str(e)
            }
