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