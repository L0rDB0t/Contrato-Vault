package main

import (
	"context"
	"log"
	"os"

	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/joho/godotenv"
)

func main() {
	// Carga variables del .env
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	rpcUrl := os.Getenv("SEPOLIA_RPC_URL")
	client, err := ethclient.Dial(rpcUrl)
	if err != nil {
		log.Fatal(err)
	}

	headers := make(chan *types.Header)
	sub, err := client.SubscribeNewHead(context.Background(), headers)
	if err != nil {
		log.Fatal(err)
	}

	for {
		select {
		case err := <-sub.Err():
			log.Fatal(err)
		case header := <-headers:
			log.Println("New block:", header.Number.String())
		}
	}
}
