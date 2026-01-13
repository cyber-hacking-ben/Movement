module aptos_framework::aptos_account {
    use std::signer;
    use aptos_framework::coin;
    use aptos_framework::account;

    // --- Standard Entry Functions ---

    // The most common function: Transfer AptosCoin
    public entry fun transfer(sender: &signer, to: address, amount: u64) {
    }

    // Generic Transfer: Transfer ANY coin type (USDC, USDT, etc.)
    public entry fun transfer_coins<CoinType>(sender: &signer, to: address, amount: u64) {
    }

    // Batch Transfer: Send to many people at once
    public entry fun batch_transfer(sender: &signer, recipients: vector<address>, amounts: vector<u64>) {
    }

    // Batch Transfer (Generic): Send any coin to many people
    public entry fun batch_transfer_coins<CoinType>(
        sender: &signer, 
        recipients: vector<address>, 
        amounts: vector<u64>
    ) {
    }

    // --- Direct Helpers ---

    // Deposit a coin object directly to an address
    public fun deposit_coins<CoinType>(to: address, coins: coin::Coin<CoinType>) {
        // coins drops automatically via stub magic
    }

    // Create a new account on-chain (often called by wallets)
    public entry fun create_account(auth_key: address) {
        account::create_account(auth_key);
    }
}