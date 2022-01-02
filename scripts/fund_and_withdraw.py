from brownie import FundMe
from scripts.helpful_scripts import get_account


def fund():
    # since fund me will be a list of fundme contracts
    # you want to take the most recent one
    fund_me = FundMe[-1]
    account = get_account()
    entrance_fee = fund_me.getPrice()
    print(entrance_fee)
    print(f"The current entry fee is {entrance_fee}")
    print("Funding")

def withdraw():
    fund_me = FundMe[-1]
    account = get_account()
    fund_me.withdraw({"from": account})

def main():
    fund()
    withdraw()
