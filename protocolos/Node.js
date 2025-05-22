const { ethers } = require("hardhat");
const AWS = require("aws-sdk");

async function signWithHSM(txData) {
  const kms = new AWS.KMS({ region: "us-east-1" });
  const params = {
    KeyId: "alias/HSM-Key",
    Message: ethers.utils.arrayify(ethers.utils.keccak256(txData)),
    MessageType: "DIGEST",
    SigningAlgorithm: "ECDSA_SHA_256",
  };

  const signature = await kms.sign(params).promise();
  return signature.Signature;
}