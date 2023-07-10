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
    ```
      PRIVATE_KEY="PRIVATE KEY OF WALLTER YOU WANT HERE"
      ETHERSCAN_API_KEY="YOUR ETHERSCAN API KEY HERE"
      RCP_URL="YOUR RPC URL HERE"
    ```
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
Users can interact with the Spider Protocol by creating profiles, publishing content, and commenting on posts. This can be done through interacting with the provided smart contract functions or using a user interface connected to the protocol.

- Applying to Use the Protocol: Once registered with the protocol, the governor will whitelist your address, granting you permission to interact with the protocol.

- Creating Personal Information and Obtaining Profile NFT: To create your personal profile, you will call the createProfile function of the Spider protocol. Provide the required parameters such as the desired handle and image URI, and the function will create a profile associated with your address. As a result, you will receive a unique non-fungible token (NFT) that represents and binds to your profile. This profile NFT serves as proof of ownership and can be used for various interactions within the protocol.

- Creating a Post: To create a post, use the createPost function, passing the necessary parameters such as the profile ID and the content URI. The function will generate a new publication with the provided content and associate it with your profile.

- Posting a Comment: If you wish to post a comment on an existing publication, utilize the createComment function. Provide the required parameters such as the profile ID, the content URI, and the publication ID you wish to comment on. The function will create a new comment associated with your profile and link it to the specified publication.

- Retrieving Profile Information: To retrieve profile information, use functions getProfile. Provide the profile ID, and the function will return the corresponding profile data, including the handle, image URI, and other associated information.

- Accessing Publication Content: If you need to access the content of a specific publication, utilize functions like getContentURI or getPub and provide the profile ID and publication ID. These functions will retrieve the content URI or the complete publication struct, allowing you to retrieve the desired information.

## Upgradeability

The Spider Protocol has undergone a significant upgrade to implement the UUPS (Upgradeable Proxy) pattern for enhanced upgradability and maintainability. With the adoption of the UUPS proxy, the protocol is now governed by an upgradeable proxy contract, allowing for seamless upgrades and updates to the protocol's functionality.

The UUPS proxy pattern provides the flexibility to introduce new features, fix bugs, and address security concerns without disrupting the overall functionality. By separating the logic from the storage, the UUPS proxy allows for upgrades while preserving the existing data and state.