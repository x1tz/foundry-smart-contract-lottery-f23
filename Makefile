-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil simulate-sepolia deploy-sepolia

FORGE ?= forge
SEPOLIA_ACCOUNT ?= default
# Sepolia uses Amsterdam gas pricing after the Glamsterdam upgrade.
# --slow waits for deployment to succeed before registering the consumer.
SEPOLIA_SCRIPT_ARGS = --rpc-url "$(SEPOLIA_RPC_URL)" --hardfork amsterdam --slow -vvvv

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo "Usage:"
	@echo "  make simulate-sepolia\n    Simulate the Sepolia deployment without sending transactions"
	@echo "  make deploy-sepolia\n    Deploy to Sepolia using the default keystore account"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install cyfrin/foundry-devops@0.2.2 && forge install smartcontractkit/chainlink-brownie-contracts@1.1.1 && forge install foundry-rs/forge-std@v1.8.2 && forge install transmissions11/solmate@v6

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := $(SEPOLIA_SCRIPT_ARGS) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY)
endif

deploy:
	@$(FORGE) script script/DeployRaffle.s.sol:DeployRaffle $(NETWORK_ARGS)

createSubscription:
	@$(FORGE) script script/Interactions.s.sol:CreateSubscription $(NETWORK_ARGS)

addConsumer:
	@$(FORGE) script script/Interactions.s.sol:AddConsumer $(NETWORK_ARGS)

fundSubscription:
	@$(FORGE) script script/Interactions.s.sol:FundSubscription $(NETWORK_ARGS)

simulate-sepolia:
	@$(FORGE) script script/DeployRaffle.s.sol:DeployRaffle $(SEPOLIA_SCRIPT_ARGS)

deploy-sepolia:
	@$(FORGE) script script/DeployRaffle.s.sol:DeployRaffle $(SEPOLIA_SCRIPT_ARGS) --account $(SEPOLIA_ACCOUNT) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY)

	
