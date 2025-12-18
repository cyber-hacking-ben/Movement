from fastapi import FastAPI
import subprocess
import tempfile
import os

# -------------------------------------------------------------------
# Create the FastAPI application
# This object represents our backend web service.
# Render runs this app using Uvicorn.
# -------------------------------------------------------------------
app = FastAPI(
    title="Move Compiler Service",
    description="A backend service that compiles Move smart contracts using the Movement CLI",
    version="1.0.0"
)

# -------------------------------------------------------------------
# Default Move.toml template
#
# Why this exists:
# - Move requires a package manifest (Move.toml) to compile
# - Many valid Move modules fail without address mappings
# - This template allows most user-submitted contracts to compile
#
# This is intentionally generic and safe.
# -------------------------------------------------------------------
MOVE_TOML = """\
[package]
name = "compiler_package"
version = "1.0.0"
upgrade_policy = "compatible"

[addresses]
# Standard Move & Aptos addresses
std = "0x1"
aptos_framework = "0x1"

# Default address for user modules
# Users can write: module hello::MyModule { ... }
hello = "0x42"

[dependencies]
MoveStdlib = { git = "https://github.com/move-language/move", subdir = "language/move-stdlib", rev = "main" }
AptosFramework = { git = "https://github.com/aptos-labs/aptos-core", subdir = "aptos-move/framework", rev = "main" }
"""

# -------------------------------------------------------------------
# POST /compile
#
# This endpoint accepts Move source code as a string,
# compiles it using the Movement CLI, and returns:
# - compiler output on success
# - structured error output on failure
#
# This is the core of the "compiler as a service".
# -------------------------------------------------------------------
@app.post("/compile")
def compile_move(code: str):
    """
    Compiles Move smart contract code and returns compiler output.

    Parameters:
        code (str): Raw Move source code sent by the client

    Returns:
        JSON object containing:
        - success: boolean
        - stdout OR error: compiler output
    """

    # ---------------------------------------------------------------
    # Create a temporary directory for this compilation run
    #
    # Why:
    # - Ensures isolation between requests
    # - Prevents file leakage or conflicts
    # - Automatically cleans up after compilation
    # ---------------------------------------------------------------
    with tempfile.TemporaryDirectory() as tmp:

        # Paths inside the temporary directory
        move_toml_path = os.path.join(tmp, "Move.toml")
        src_dir = os.path.join(tmp, "sources")

        # Create the "sources" directory required by Move
        os.mkdir(src_dir)

        # -----------------------------------------------------------
        # Write the Move.toml file
        # This tells the compiler how to resolve addresses
        # and which dependencies to use.
        # -----------------------------------------------------------
        with open(move_toml_path, "w") as f:
            f.write(MOVE_TOML)

        # -----------------------------------------------------------
        # Write the user's Move code to a source file
        # For now, all code is placed into a single module file.
        # -----------------------------------------------------------
        source_file = os.path.join(src_dir, "module.move")
        with open(source_file, "w") as f:
            f.write(code)

        # -----------------------------------------------------------
        # Run the Move compiler via the Movement CLI
        #
        # Equivalent to running:
        #   movement move build
        #
        # cwd=tmp ensures the command runs inside the temp project
        # capture_output=True allows us to return compiler logs
        # -----------------------------------------------------------
        try:
            result = subprocess.run(
                ["movement", "move", "build"],
                cwd=tmp,
                capture_output=True,
                text=True,
                timeout=60
            )

            # -------------------------------------------------------
            # If compilation fails, return the error output
            # This allows frontend tools to display useful diagnostics
            # -------------------------------------------------------
            if result.returncode != 0:
                return {
                    "success": False,
                    "error": result.stderr
                }

            # -------------------------------------------------------
            # If compilation succeeds, return the compiler output
            # In future versions, this can include bytecode, ABI, etc.
            # -------------------------------------------------------
            return {
                "success": True,
                "stdout": result.stdout
            }

        # -----------------------------------------------------------
        # Catch unexpected runtime errors (timeouts, IO issues, etc.)
        # -----------------------------------------------------------
        except Exception as e:
            return {
                "success": False,
                "error": str(e)
            }
