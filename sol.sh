#!/bin/bash

# Define the suits and ranks
SUITS=("Hearts" "Diamonds" "Clubs" "Spades")
RANKS=("A" "2" "3" "4" "5" "6" "7" "8" "9" "10" "J" "Q" "K")

# Array to hold the deck of cards
DECK=()

# Function to initialize and shuffle the deck
initialize_deck() {
    DECK=()
    for suit in "${SUITS[@]}"; do
        for rank in "${RANKS[@]}"; do
            DECK+=("$rank of $suit")
        done
    done
    DECK=($(shuf -e "${DECK[@]}"))  # Shuffle the deck
}

# Deal cards into seven columns
deal_cards() {
    COLUMNS=( [] [] [] [] [] [] [] )
    for i in {0..6}; do
        for j in $(seq 0 "$i"); do
            COLUMNS[$i]+="${DECK[0]},"
            DECK=("${DECK[@]:1}")
        done
    done
}

# Display the board (columns with cards)
display_board() {
    echo "Solitaire Board"
    echo "---------------"
    for i in {0..6}; do
        echo -n "Column $((i+1)): "
        IFS=',' read -r -a cards <<< "${COLUMNS[$i]}"
        for card in "${cards[@]}"; do
            echo -n "$card "
        done
        echo ""
    done
    echo ""
}

# Function to move a card from one column to another
move_card() {
    read -rp "Enter source column (1-7): " src
    read -rp "Enter destination column (1-7): " dest
    src=$((src-1))
    dest=$((dest-1))

    # Get the last card in the source column
    IFS=',' read -r -a src_cards <<< "${COLUMNS[$src]}"
    last_card="${src_cards[-1]}"
    unset src_cards[-1]
    COLUMNS[$src]=$(IFS=','; echo "${src_cards[*]}")

    # Add the card to the destination column
    COLUMNS[$dest]+="${last_card},"
    echo "Moved $last_card from column $((src+1)) to column $((dest+1))."
}

# Main game loop
initialize_deck
deal_cards
while true; do
    display_board
    echo "Options:"
    echo "1. Move Card"
    echo "2. Exit"
    read -rp "Choose an option: " choice
    case $choice in
        1) move_card ;;
        2) echo "Exiting Solitaire."; break ;;
        *) echo "Invalid choice, please try again." ;;
    esac
    echo ""
done
