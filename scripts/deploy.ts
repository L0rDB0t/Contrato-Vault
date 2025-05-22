import { ethers } from "hardhat";

async function main() {
  const Vault = await ethers.getContractFactory("Vault");
  const vault = await Vault.deploy();
  // await vault.deployed(); // 🚫 Elimina esto en ethers v6
  console.log("Vault deployed to:", vault.target); // ✔️ Usa target para la dirección
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});