import { expect } from "chai";
import { ethers } from "hardhat";

describe("Token", function () {
    describe("Deployment", function () {
        let token, tokenContract: any;
        beforeEach(async () => {
            const Token = await ethers.getContractFactory("Token");
            token = await Token.deploy("My First Token", "MFT");
            tokenContract = await token.deployed();
        });
        it('test token mint', async () => {
            const [owner, otherAccount] = await ethers.getSigners();
            const mintToken = await tokenContract.mint(owner.address, 1000);
            const totalSupply = await tokenContract.totalSupply();
            expect(tokenContract).to.not.eq(null);
            expect(mintToken.from).to.eq(owner.address);
            expect(mintToken.to).to.not.eq(null);
            expect(totalSupply).to.eq(1000);
        })

        it("should have correct name", async () => {
            const name = await tokenContract.name();
            expect(name).to.be.equal("My First Token");
        });

        it("should have correct symbol", async () => {
            expect(await tokenContract.symbol()).eq("MFT");
        });
    })
})