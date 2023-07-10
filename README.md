# spider-protocol

## Description

The Spider Protocol is a decentralized, non-custodial social media platform built on the blockchain. Its purpose is to empower users to own and control their social graph while providing unique functionalities and interactions that go beyond traditional Web2 social media platforms. The protocol aims to create a more transparent and user-centric social media experience, where participants can form communities, publish content, interact with others, and monetize their contributions.

## Framework

### Components:
- Profile: Represents user profiles within the Spider Protocol. Each profile has a handle, an image URI, and tracks the number of publications made by the user.

- Publication: Represents different types of content published within the protocol, such as posts, comments. Publications have a content URI and may reference other publications.

### Workflow:
- Profile Creation: Users can create profiles by specifying a handle, image URI, and other optional information. Each profile receives a unique profile ID and an associated ERC-721 Spider Profile NFT.

- Publication Creation: Profile owners can publish different types of content, including posts, comments, and mirrors. Publications are stored on-chain and associated with the profile ID and publication ID.

- Commenting and Interacting: Users can comment on publications, pointing back to the original publication. The reference module controls the rules and restrictions for commenting and interacting with profiles.

## Development

- Setup Instructions:
  - Clone the project repository from GitHub.
  - Install the required dependencies.
  - Set up the environment file with necessary configuration parameters (.env.example).
  - Build and deploy the smart contracts to the desired network.
  - `forge script script/Spider.s.sol:SpiderDeployScript --broadcast --verify -vvvv`

## Testing
- UUPSProxy
  - Initialize
  - Upgrade
### profile
- ProfileCreatorWhitelist
  - profileCreatorWhitelist
  - notOperator ProfileCreatorWhitelist
- ProfileCreation
  - createProfileWithHandleOver
  - createProfileWithHandleEmpty
  - createProfileWithHandleContainCapital
  - createProfileWithHandleContainInvalid
  - createProfileWithImageUriInvalidLength
  - createProfileWithNotWhitelisted
  - createProfileWithExpectedId
  - createProfileWithExpectedNft
  - createProfileWithHandleContainSpecific
  - createProfileWithHandleDuplicateFail
  - createProfileForOther
- TODO

## Usage
- Using the Project: Users can interact with the Spider Protocol by creating profiles, publishing content, and commenting on posts. This can be done through interacting with the provided smart contract functions or using a user interface connected to the protocol.