# configuration
# PROXY=https://devnet-gateway.elrond.com
# CHAIN_ID="D"

PROXY=https://devnet-gateway.elrond.com
CHAIN_ID="D"

# WALLET="./wallets/wallet/dev-wallet.pem"
WALLET="./wallet/wallet-owner.pem"

################################################

LOTTERY_OUTPUT_ESDT_TOKEN="SWTT-916204"
LOTTERY_OUTPUT_ESDT_TOKEN_HEX="0x$(echo -n ${LOTTERY_OUTPUT_ESDT_TOKEN} | xxd -p -u | tr -d '\n')"
DEFAULT_INPUT_AMOUNT=50000000000000000
RESULT_TYPES=1 5000000000 \
             0 75000000000000000 \
             1 4000000000 \
             0 50000000000000000 \
             1 3000000000 \
             1 2000000000 \
             0 25000000000000000 \
             1 6000000000 \

################################################

# TOKEN_ID="VITAL-bc0917"
# TOKEN_ID_HEX="0x$(echo -n ${TOKEN_ID} | xxd -p -u | tr -d '\n')"
# TOKEN_ID_ONLY_HEX="$(echo -n ${TOKEN_ID} | xxd -p -u | tr -d '\n')"

# MIN_STAKE_LIMIT=100000000000000       # 1000000 VITAL

# REWARD_APY=1400 # 14

# NEW_REWARD_APY=1400 # 14

# PAUSED=1

# STAKE="stake"
# STAKE_ONLY_HEX="$(echo -n ${STAKE} | xxd -p -u | tr -d '\n')"

# CALLER_ADDRESS="erd149axj8feledcw7zck5f3ecwrncgd0gemcr9q69yxqlk0zvnl5zvs065jqu"
# CALLER_ADDRESS_HEX="0x$(erdpy wallet bech32 --decode ${CALLER_ADDRESS})"

# NEW_ADDRESS="erd1r0s6ss90ktgtk6eytdskpkndl6ke4y75t0c8fq2mj7zumyncmtrsx9ud2u"
# NEW_ADDRESS_HEX="$(erdpy wallet bech32 --decode ${NEW_ADDRESS})"

# UPGRADE_ADDRESS="erd1qqqqqqqqqqqqqpgqc4gutf9tqmqqlxmepm5t2dz9fe9jcvhr7lnqln3djs"
# UPGRADE_ADDRESS_ONLY_HEX="$(erdpy wallet bech32 --decode ${UPGRADE_ADDRESS})"

################################################
ADDRESS=$(erdpy data load --key=address-devnet)
TRANSACTION=$(erdpy data load --key=deployTransaction-devnet)
################################################

deploy() {
    erdpy --verbose contract deploy \
    --project=${PROJECT} \
    --recall-nonce \
    --pem=${WALLET} \
    --gas-limit=50000000 \
    --arguments ${LOTTERY_OUTPUT_ESDT_TOKEN_HEX} ${DEFAULT_INPUT_AMOUNT} 1 5000000000 \
             0 75000000000000000 \
             1 4000000000 \
             0 50000000000000000 \
             1 3000000000 \
             1 2000000000 \
             0 25000000000000000 \
             1 6000000000 \
    --send \
    --metadata-payable  \
    --metadata-payable-by-sc \
    --outfile="deploy-devnet.interaction.json" \
    --proxy=${PROXY} \
    --chain=${CHAIN_ID} || return

    TRANSACTION=$(erdpy data parse --file="deploy-devnet.interaction.json" --expression="data['emittedTransactionHash']")
    ADDRESS=$(erdpy data parse --file="deploy-devnet.interaction.json" --expression="data['contractAddress']")

    erdpy data store --key=address-devnet --value=${ADDRESS}
    erdpy data store --key=deployTransaction-devnet --value=${TRANSACTION}

    echo ""
    echo "Smart contract address: ${ADDRESS}"
}