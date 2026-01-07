# Backend Compiler Service
Here is the official, technical documentation for the Movement Compiler Backend. This is written for other developers, ensuring they understand the architecture, how to run it, and how to build the frontend against it.

##  Movement Compiler Service: Technical Documentation
### 1. System Overview
The Movement Compiler Service is a specialized, stateless backend designed to compile Move smart contracts in resource-constrained environments (specifically Render Free Tier with 512MB RAM).
Unlike standard Move compilers that load the entire 1.5GB+ Aptos Framework into memory, this service utilizes a Stubbed Framework Architecture. It compiles against lightweight "Interface Files" (stubs) rather than heavy implementation files, reducing memory footprint by ~90% while ensuring complete type safety and valid bytecode generation.
Key Features
OOM-Safe: Runs comfortably on <512MB RAM.
Stateless: No database; files are ephemeral (created in /tmp and deleted after compilation).
Production Ready: Returns standard .mv bytecode and .bcs metadata compatible with the Movement and Aptos blockchains.


### 2. Directory Structure & Prerequisites
To run this locally or deploy it, your local project MUST match this exact structure. The Dockerfile relies on copying the frameworks directory.

   /project-root
├── Dockerfile              # The optimized multi-stage build
├── app.py                  # FastAPI entry point
├── formatter.py            # Regex logic for parsing compiler errors
├── requirements.txt        # Python dependencies
└── frameworks/             # [CRITICAL] Local dependencies
    └── stubbed-aptos-framework/
        └── aptos-framework/
            ├── Move.toml
            └── sources/    # Contains coin.move, account.move, etc.
 

### 3. Local Development Guide
Running via Docker (Recommended)
Since the compiler relies on specific CLI binaries and path rewrites (sed), running raw Python locally is discouraged. Always use Docker.
#### 1. Build the Image
code Bash

   docker build -t movement-compiler .
 
#### 2. Run the Container
code Bash

   ##### Runs on port 8000
docker run -p 8000:8000 movement-compiler
 
#### 3. Verify Functionality
Run this curl command to test compilation of a basic contract:
code Bash

   curl -X POST http://localhost:8000/compile \
  -H "Content-Type: application/json" \
  -d '{
    "code": "module 0x1::test { public fun main() {} }"
  }'
 

### 4. API Reference
POST /compile
Accepts Move source code, compiles it, and returns Base64-encoded bytecode.
REQUEST BODY
code JSON

{
  "code": "module hello::counter { use std::signer; ... }",
  "sender_address": "0x1234..." // (Optional) Defaults to 0x1. Set this to the user's wallet address for deployment.
}

 
Response: Success
When compilation succeeds (returncode == 0):
code JSON

   {
  "type": "compile_success",
  "success": true,
  "modules": [
    {
      "name": "counter",
      "bytecode_base64": "oRzrCwcAAAoMAQAUAhQqAz41BHMGBXlq..." 
    }
  ],
  "package_metadata_bcs": "...", // Or null (if using lightweight stubs)
  "compiler_stdout": "...",
  "metadata": {
    "module_count": 1,
    "has_metadata": false
  }
}
 
Response: Failure
When compilation fails (Syntax errors, Type mismatches):
code JSON

   {
  "type": "compile_failed",
  "success": false,
  "error_count": 1,
  "errors": [
    {
      "message": "unexpected token",
      "file": "/tmp/tmp...", 
      "line": 5,
      "column": 12,
      "source_line": "let mut x = 0;"
    }
  ]
}
 

### 5. Frontend Integration Guide
The frontend is responsible for submitting code to this API and handling the deployment using a Wallet Adapter. The backend does not deploy code.
Calling the API (Next.js Example):
// inside your compile function
const res = await axios.post("https://movement-sqto.onrender.com/compile", {
  code: code,
  sender_address: walletAccount.address // <--- CRITICAL: Pass connected wallet address
});
#### A. Handling Successful Compilation
The frontend receives Base64 strings. The Blockchain RPC requires Uint8Array.
##### 1. Decode Helper:
code TypeScript

   consw Uint8Array(binaryString.length);
  for (let i = 0; i < binaryString.length; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }
  return bytes;
};
 
##### 2. Constructing the Transaction (Aptos SDK):
code TypeScript

   const handleDeploy = async (apiResponse: any) => {
  // 1. Decode Bytecode
  const moduleBytecodes = apiResponse.modules.map((m: any) => 
    decodeBase64(m.bytecode_base64)
  );

  // 2. Decode Metadata (Handle null case for stubs)
  // If package_metadata_bcs is null, send an empty array. 
  // The VM will reconstruct basic metadata.
  const metadataBytes = apiResponse.package_metadata_bcs 
    ? decodeBase64(apiResponse.package_metadata_bcs) 
    : new Uint8Array();

  // 3. Create Payload for 'code::publish_package_txn'
  const payload = {
    type: "entry_function_payload",
    function: "0x1::code::publish_package_txn",
    type_arguments: [],
    arguments: [
      metadataBytes,  // Arg 0
      moduleBytecodes // Arg 1
    ]
  };

  // 4. Sign & Submit via Wallet Adapter
  const response = await signAndSubmitTransaction(payload);
  console.log("Tx Hash:", response.hash);
};
 
#### B. Handling Compilation Errors
The formatter.py script parses the raw Rust CLI stderr into a structured JSON array.
UI Mapping: Map over the errors array.
Highligting: Use line and column to highlight syntax errors in the Code Editor (e.g., Monaco Editor or CodeMirror).
Message: Display message and source_line in a console output window.

### 6. Architecture & Maintenance Notes
Dynamic Address Injection
To ensure deployed bytecode belongs to the correct user, the backend performs Dynamic Compilation:
The API accepts a sender_address (e.g., 0xA1B2...).
It dynamically generates a Move.toml for that specific request, injecting the address into the hello named address.
The compiler bakes this address into the binary.
Result: The bytecode signature matches the user's wallet, allowing successful on-chain validation.
The Stubbed Framework Strategy
Location: /frameworks/stubbed-aptos-framework inside the container.
Logic: We replaced implementation files with "Ghost Files".
Real: public fun transfer(...) { <complex logic> }
Stub: public fun transfer(...) { abort 0 }


Why: The compiler only needs function signatures to verify type safety. It does not need the function body logic to generate bytecode for the user's module.
Adding New Functions
If a user tries to use a standard function (e.g., account::new_event_handle) and gets a "function not found" error, it means our stub is missing that signature.
Open frameworks/stubbed-aptos-framework/aptos-framework/sources/account.move.
Add the function signature (copy it from the official Aptos repo).
Set the body to { abort 0 }.
Rebuild and Deploy.
Move 2024 Support
Currently, Move.toml in app.py has # edition = "2024" commented out.
Current State: Supports standard Move 1.0 (compatible with Move 2 features like phantom types).
To Enable Move 2 (let mut): Uncomment that line in app.py. Note that strict Move 2 features might require updating the CLI binary in the Dockerfile if movement-move2-testnet becomes outdated.

### 7. Deployment (Render)
Build Command: (Handled by Docker)
Environment:
Docker Runtime.
Free Tier (512MB RAM and 0.1 CPU) is sufficient due to optimizations.


Caching: If you modify app.py or the frameworks folder, you must use "Clear Build Cache & Deploy" in Render to ensure the new files are copied into the image.

### 8. CLI Testing Guide (Linux/WSL)
You can verify the backend status and compilation logic directly from your terminal using curl.
Prerequisites
curl: Installed by default on most Linux distros.
jq (Optional): Highly recommended for formatting the JSON output.
Install: sudo apt-get install jq

#### A. Basic Sanity Check
Run this to confirm the server is reachable and the CLI is executable.
code Bash

   curl -s -X POST https://movement-sqto.onrender.com/compile \
  -H "Content-Type: application/json" \
  -d '{ "code": "module 0x1::sanity_check { public fun main() {} }" }' | jq
 
Expected Output:
code JSON

   {
  "type": "compile_success",
  "success": true,
  "modules": [ ... ],
  ...
}

#### Basic Sanity Check (With Address)
Run this to confirm the server accepts a sender address.
curl -s -X POST https://movement-sqto.onrender.com/compile \
  -H "Content-Type: application/json" \
  -d '{ 
    "code": "module hello::sanity_check { public fun main() {} }",
    "sender_address": "0xCAFE"
  }' | jq

#### B. Full Integration Test (Stub Verification)
This command tests the entire "Micro-Framework" by importing Coin, Table, Object, and ResourceAccount. Use this to prove to investors/devs that the lightweight architecture supports complex logic.
Copy and paste this entire block:
code Bash

   curl -s -X POST https://movement-sqto.onrender.com/compile \
  -H "Content-Type: application/json" \
  -d '{
    "code": "module hello::final_edge_case { use std::signer; use std::vector; use std::option::{Self, Option}; use std::string::String; use aptos_framework::coin::{Self, Coin}; use aptos_framework::table::{Self, Table}; use aptos_framework::timestamp; use aptos_framework::object::{Self, Object}; use aptos_framework::resource_account; struct TestCoin has drop {} struct Vault has key { balances: Table<String, Coin<TestCoin>>, last_touch: u64, backup: Option<Coin<TestCoin>>, objects: vector<Object<TestCoin>> } public entry fun init(admin: &signer) { let (res, _) = resource_account::create_resource_account(admin, b\"vault_seed\"); let t = table::new<String, Coin<TestCoin>>(); let o = option::none<Coin<TestCoin>>(); let v = vector::empty<Object<TestCoin>>(); move_to(&res, Vault { balances: t, last_touch: timestamp::now_seconds(), backup: o, objects: v }); } public fun touch(user: &signer, c: Coin<TestCoin>, key: String) acquires Vault { let addr = signer::address_of(user); let vault = borrow_global_mut<Vault>(addr); table::add(&mut vault.balances, key, c); vault.last_touch = timestamp::now_seconds(); } }"
  }' 
 
#### C. Troubleshooting Common Errors
Output / Error
Meaning
Fix
Connection refused
Server is down or local Docker isn't running.
Check Render dashboard or run docker ps.
"type": "raw_output"
The compiler crashed silently (OOM).
Ensure aptos-core was stripped in Dockerfile and edition is handled correctly.
"message": "unexpected token"
Move Syntax Error.
Check your code for typos (e.g., let mut in Move 1.0 mode).
"message": "unbound module"
Missing Import.
Ensure your Move code uses use aptos_framework::xxx;.

 