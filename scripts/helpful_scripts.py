from brownie import accounts, network, config, MockV3Aggregator
from web3 import Web3

FORKED_LOCAL_ENVIROMENTS = ["mainnet-fork", "mainnet-fork-dev"]
LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["development", "ganache-local"]

DECIMALS = 8
STARTING_PRICE = 200000000000

def get_account():
    if(network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS or network.show_active() in FORKED_LOCAL_ENVIROMENTS):
        # check if the network is a developmental account

        return accounts[0]
    else:
        return accounts.load("metamask-account-2")

def deploy_mocks():
    print(f"The active network is {network.show_active()}")
    print("Deploying Mocks...")
    # toWei adds 18 zeros
    if len(MockV3Aggregator) <= 0:

    # mockv3aggregator is just a list of all the mockv3aggregator you deploy
        mock_aggregator = MockV3Aggregator.deploy(DECIMALS, Web3.toWei(STARTING_PRICE, 'ether'), {"from": get_account()})
    print("Mocks Deployed!")
