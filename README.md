# QuadBtech_task
### basic blockchain simulation
A basic implementation of a blockchain system using Solidity smart contracts. This project demonstrates core blockchain concepts including block creation, mining with Proof of Work, chain validation, and tamper detection.

## Features

- ✨ Block creation and linking
- ⛏️ Proof of Work mining with adjustable difficulty
- 🔗 Chain validation and integrity checks
- 💰 Basic transaction handling
- 🔍 Tamper detection and demonstration
- ⚡ Gas-efficient storage implementation

## Getting Started

### Prerequisites

- Web browser
- Access to [Remix IDE](https://remix.ethereum.org/)

### Deployment Steps

1. Open [Remix IDE](https://remix.ethereum.org/)
2. Create a new file `BlockChain.sol`
3. Copy and paste the contract code
4. Compile the contract (Ctrl + S or click the Compile button)
5. Deploy using the "Deploy & Run Transactions" tab
   - Select "Injected Provider - MetaMask" for testnet deployment
   - Or use "Remix VM" for testing

## Interacting with the Contract

After deployment, you can interact with the contract using Remix's interface:

### Read Functions

1. **getBlockCount()**
   - Returns the total number of blocks in the chain
   - Initially returns 1 (genesis block)

2. **getBlock(uint256 _index)**
   - Input: Block index
   - Returns: Block details (index, timestamp, previousHash, currentHash, nonce)
   - Example: Try `getBlock(0)` to see genesis block

3. **validateChain()**
   - Returns: Boolean indicating if chain is valid
   - Should return `true` unless tampering has occurred

### Write Functions

1. **addBlock(address _to, uint256 _amount)**
   - Creates new block with transaction
   - Parameters:
     - `_to`: Recipient address
     - `_amount`: Transaction amount
   - Example: `addBlock("0x123...", 100)`

2. **tamperBlock(uint256 _index, uint256 _fakeAmount)**
   - Demonstrates tampering effects
   - Parameters:
     - `_index`: Block to tamper with
     - `_fakeAmount`: New fake amount
   - Use with validateChain() to see integrity checks

## Example Usage Scenario

1. Deploy contract
2. Note genesis block (index 0)
3. Add new block:
   ```solidity
   addBlock("0x123...", 100)
   ```
4. Verify chain:
   ```solidity
   validateChain() // Should return true
   ```
5. Tamper with block:
   ```solidity
   tamperBlock(1, 999)
   ```
6. Verify chain again:
   ```solidity
   validateChain() // Should return false
   ```
## Technical Details

### Proof of Work System

The contract implements a simple PoW where:
- Default difficulty is 2 (requires 2 leading zeros)
- Mining process finds hash meeting difficulty requirement
- Target calculation: `2 ** (256 - difficulty)`

### Chain Validation

Validates:
- Hash linking between blocks
- Block hash integrity
- Transaction consistency


## Security Considerations
This is for the task purpose and doesnt have much secure methods:
- Simple PoW implementation
- Limited validation checks

