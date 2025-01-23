// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBlockchain {
    struct Transaction {
        address from;
        address to;
        uint256 amount;
    }

    struct Block {
        uint256 index;
        uint256 timestamp;
        Transaction[] transactions;
        bytes32 previousHash;
        bytes32 currentHash;
        uint256 nonce;
    }

    Block[] public chain;
    uint256 public difficulty = 2; // Number of leading zeros required for PoW
    
    event BlockMined(uint256 indexed index, bytes32 hash);
    event ChainTampered(uint256 indexed index);

    constructor() {
        // Creates genesis block which is the first block when the contract is deployed
        Block storage genesis = chain.push();
        genesis.index = 0;
        genesis.timestamp = block.timestamp;
        genesis.previousHash = bytes32(0);
        genesis.currentHash = calculateGenesisHash();
        genesis.nonce = 0;
    }

    function calculateGenesisHash() private view returns (bytes32) {
        // @info This is not recommended when deploying on mainnet as this method of randomness has many 
        // vulnerabilities i am using this as this code is for task only and doesnt contain any real money
        return keccak256(abi.encodePacked(block.timestamp, bytes32(0)));
    }

    function addBlock(address _to, uint256 _amount) public {
        require(chain.length > 0, "Chain not initialized");
        
        // Create new block
        Block storage newBlock = chain.push();
        newBlock.index = chain.length - 1;
        newBlock.timestamp = block.timestamp;
        newBlock.previousHash = chain[chain.length - 2].currentHash;
        
        // Add transaction
        newBlock.transactions.push(Transaction({
            from: msg.sender,
            to: _to,
            amount: _amount
        }));

       // Mine the block to find valid hash and nonce
    (bytes32 hash, uint256 nonce) = mineBlock(newBlock);
    // Store the results of mining
    newBlock.currentHash = hash;
    newBlock.nonce = nonce;
    
    // Emit event to notify listeners of new block
    emit BlockMined(newBlock.index, newBlock.currentHash);
    }

    function mineBlock(Block storage _block) private view returns (bytes32, uint256) {
        bytes32 hash;
        uint256 nonce = 0;
        
        while (true) {
            hash = calculateHash(_block, nonce);
            // Check if hash meets difficulty requirement
            if (uint256(hash) < (2 ** (256 - difficulty))) {
                break;
            }
            nonce++;
        }
        
        return (hash, nonce);
    }
    // Function to calculate hash of block data with given nonce
    // Function to calculate hash of block data with given nonce
function calculateHash(Block storage _block, uint256 _nonce) private view returns (bytes32) {
    // Include transactions in hash calculation
    bytes memory transactionData;
    for(uint i = 0; i < _block.transactions.length; i++) {
        Transaction storage txn = _block.transactions[i];
        transactionData = abi.encodePacked(
            transactionData,
            txn.from,
            txn.to,
            txn.amount
        );
    }

    // Pack all block data together including transactions
    return keccak256(
        abi.encodePacked(
            _block.index,
            _block.timestamp,
            _block.previousHash,
            transactionData,  // Include transaction data
            _nonce
        )
    );
}

    function validateChain() public view returns (bool) {
        for (uint256 i = 1; i < chain.length; i++) {
            // Get references to current and previous blocks
            Block storage currentBlock = chain[i];
            Block storage previousBlock = chain[i - 1];

            // Verify hash linking
            if (currentBlock.previousHash != previousBlock.currentHash) {
                return false;
            }

            // Verify current block hash
            if (calculateHash(currentBlock, currentBlock.nonce) != currentBlock.currentHash) {
                return false;
            }
        }
        return true;
    }

    // Function to simulate tampering (for demonstration)
    function tamperBlock(uint256 _index, uint256 _fakeAmount) public {
  // Ensure block index is valid
    require(_index < chain.length, "Invalid block index");
    // Ensure block has at least one transaction
    require(chain[_index].transactions.length > 0, "No transactions to tamper");
        
        // Modify transaction amount in the specified block
        chain[_index].transactions[0].amount = _fakeAmount;
        // Emit event to log the tampering 
        emit ChainTampered(_index);
    }

    // Getter functions
    function getBlockCount() public view returns (uint256) {
        return chain.length;
    }

    function getBlock(uint256 _index) public view returns (
        uint256 index,
        uint256 timestamp,
        bytes32 previousHash,
        bytes32 currentHash,
        uint256 nonce
    ) {
        require(_index < chain.length, "Invalid block index");
        Block storage b = chain[_index];
        return (b.index, b.timestamp, b.previousHash, b.currentHash, b.nonce);
    }

    function getBlockTransaction(uint256 _blockIndex, uint256 _txIndex) public view returns (
        address from,
        address to,
        uint256 amount
    ) {
        require(_blockIndex < chain.length, "Invalid block index");
        require(_txIndex < chain[_blockIndex].transactions.length, "Invalid transaction index");
        
        Transaction storage txData = chain[_blockIndex].transactions[_txIndex];
        return (txData.from, txData.to, txData.amount);
    }
}