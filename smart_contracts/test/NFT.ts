import { expect } from "chai";
import { ethers } from "hardhat";

describe.only("NFT", function () {
    describe("Deployment", () => {
        let nft, nftContract: any, ownerAddress: string, secondAccount: string, provider: any;

        beforeEach(async () => {
            const NFT = await ethers.getContractFactory("NFT");
            nft = await NFT.deploy();
            nftContract = await nft.deployed();
            const [owner, otherAccount] = await ethers.getSigners();
            ownerAddress = owner.address;
            secondAccount = otherAccount.address;
            provider = ethers.provider;
        });

        it("should have correct name", async () => {
            const name = await nftContract.name();
            expect(name).to.be.equal("My First Token");
        });

        it("should have correct symbol", async () => {
            expect(await nftContract.symbol()).eq("MFT");
        });

        it("mint token", async () => {
            const token = await nftContract.safeMint(secondAccount, "https://localhost:3000/data.json");
            let ownerBalance = await nftContract.balanceOf(secondAccount);
            let totalSupply = await nftContract.totalSupply();
            expect(token).to.be.not.equal(null);
            expect(ownerBalance).to.eq(1);
            expect(totalSupply).to.eq(1);
        })

        it("owner balance", async () => {
            let ownerBalance = await nftContract.balanceOf(secondAccount);
            let totalUserTokens = await nftContract.getOwnerTokens(secondAccount);
            expect(totalUserTokens.length).to.equal(ownerBalance);
        })
    })
})