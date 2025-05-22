# Secure DeFi Vault

Este proyecto implementa una bóveda (Vault) segura para Ethereum con un contrato inteligente en Solidity, pruebas automáticas con Hardhat y monitoreo de bloques en tiempo real usando Go.  
Incluye toda la configuración necesaria, ejemplos de código y los pasos para desplegar, probar y monitorear la bóveda.

---

## Índice

- [Contrato Vault (Solidity)](#contrato-vault-solidity)
- [Pruebas en Hardhat (TypeScript)](#pruebas-en-hardhat-typescript)
- [Monitoreo de bloques con Go](#monitoreo-de-bloques-con-go)
- [Variables de entorno](#variables-de-entorno)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Despliegue en Sepolia y Etherscan](#despliegue-en-sepolia-y-etherscan)
- [Comandos útiles](#comandos-útiles)
- [Dependencias principales](#dependencias-principales)
- [Futuras mejoras](#futuras-mejoras)
- [Autor](#autor)

---

## Contrato Vault (Solidity)

```solidity name=contratos/Vault.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault {
    mapping(address => uint256) public balances;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    function deposit() external payable {
        require(msg.value > 0, "Must send ETH");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }
}
```

---

## Pruebas en Hardhat (TypeScript)

Archivo: `test/Vault.test.ts`

```typescript name=test/Vault.test.ts
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Vault", () => {
  it("Should deposit and withdraw ETH", async () => {
    const Vault = await ethers.getContractFactory("Vault");
    const vault = await Vault.deploy();

    const [owner] = await ethers.getSigners();
    const amount = ethers.parseEther("1.0");

    await vault.deposit({ value: amount });
    expect(await vault.balances(owner.address)).to.equal(amount);

    await vault.withdraw(amount);
    expect(await vault.balances(owner.address)).to.equal(0n);
  });
});
```

**Ejecución de pruebas:**
```bash
npx hardhat test
```

---

## Monitoreo de bloques con Go

Archivo: `protocolos/Monitoreo.go`

```go name=protocolos/Monitoreo.go
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
```

**Ejecución del monitor:**
1. Asegúrate de tener tu `.env` en la raíz, por ejemplo:
   ```
   SEPOLIA_RPC_URL="wss://sepolia.infura.io/ws/v3/TU_API_KEY"
   ```
2. Instala las dependencias Go:
   ```bash
   go mod tidy
   ```
3. Ejecuta el monitor:
   ```bash
   go run protocolos/Monitoreo.go
   ```

---

## Variables de entorno

Ejemplo de archivo `.env`:

```
SEPOLIA_RPC_URL="wss://sepolia.infura.io/ws/v3/TU_API_KEY"
PRIVATE_KEY="tu_clave_privada"
ETHERSCAN_API_KEY="tu_api_key_etherscan"
```
> **¡No compartas tu archivo `.env` ni tus claves privadas!**

---

## Estructura del Proyecto

```
secure-defi-vault/
│
├── contratos/               # Smart contracts Solidity
│   └── Vault.sol
├── test/                    # Pruebas automáticas
│   └── Vault.test.ts
├── protocolos/              # Scripts y servicios Go
│   └── Monitoreo.go
├── .env                     # Variables de entorno sensibles
├── README.md
├── hardhat.config.ts        # Configuración Hardhat
├── package.json
├── go.mod / go.sum          # Configuración Go Modules
```

---

## Despliegue en Sepolia y Etherscan

El contrato fue desplegado en la red Sepolia.  
**Dirección del contrato Vault en Sepolia:**  
```
0x5B3d6d6dC8eD85a8e5B41eE7f3A77E8B8bA7aD7B
```
_Búscalo y verifícalo en [Etherscan Sepolia](https://sepolia.etherscan.io/address/0x5B3d6d6dC8eD85a8e5B41eE7f3A77E8B8bA7aD7B)_

---

## Comandos útiles

- **Pruebas Hardhat**
  ```bash
  npx hardhat test
  ```
- **Compilar contrato**
  ```bash
  npx hardhat compile
  ```
- **Desplegar contrato** (ejemplo, si tienes script de deploy)
  ```bash
  npx hardhat run scripts/deploy.ts --network sepolia
  ```
- **Ejecutar monitoreo Go**
  ```bash
  go run protocolos/Monitoreo.go
  ```

---

## Dependencias principales

- Solidity
- Hardhat
- ethers.js (v6)
- chai
- go-ethereum
- joho/godotenv

---

## Futuras mejoras

- Monitorear eventos específicos del contrato Vault desde Go.
- Dashboard web de monitoreo.
- Estrategias automáticas DeFi.

---

## Autor

- [L0rDB0t](https://github.com/L0rDB0t)
