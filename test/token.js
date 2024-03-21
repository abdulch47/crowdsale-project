const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('Token Contract', () => {
  let Token;
  let token;
  let owner;
  let receiver1;
  let receiver2;
  let spender;
  

  before(async () => {

    // Deploy the contracts and set up test variables
    [owner, receiver1, receiver2, spender] = await ethers.getSigners();

    Token = await ethers.getContractFactory('Token');
    token = await Token.connect(owner).deploy();
  });

  // ******************Set and verify the immutable metadata for AST1.************************

  it('should verify immutable metadata for Token', async () => {
    // Arrange & Act
    const name = await token.name();
    const symbol = await token.symbol();
    const totalSupply = await token.totalSupply();

    // Assert
    expect(name).to.equal('Token');
    expect(symbol).to.equal('TT');
    console.log("Immutable Token Name:", name);
    console.log("Immutable Token symbol:", symbol);
    console.log("Total supply:", totalSupply.toString());
  });

  it('should transfer tokens', async () => {
    const initialBalance = await token.balanceOf(owner.address);
    const amount = 100;

    await token.transfer(receiver1.address, amount);

    const newBalanceOwner = await token.balanceOf(owner.address);
    const newBalanceReceiver = await token.balanceOf(receiver1.address);

    expect(newBalanceOwner).to.equal(initialBalance.sub(amount));
    expect(newBalanceReceiver).to.equal(amount);
  });
  
  it('should transfer tokens from one account to another', async () => {
    const initialBalance = await token.balanceOf(owner.address);
    const amount = 500;

    await token.approve(spender.address, amount);

    await token.connect(spender).transferFrom(owner.address, receiver2.address, amount);

    const receiverBalance = await token.balanceOf(receiver2.address);
    const spenderAllowance = await token.allowance(owner.address, spender.address);
    const newBalanceOwner = await token.balanceOf(owner.address);
    expect(newBalanceOwner).to.equal(initialBalance.sub(amount));
    expect(receiverBalance).to.equal(amount);
    expect(spenderAllowance).to.equal(0);
  });

  it('should approve spender to spend tokens', async () => {
    const amount = 1000;

    await token.approve(spender.address, amount);

    const allowance = await token.allowance(owner.address, spender.address);
    expect(allowance).to.equal(amount);
  });
 
});


describe('Crowdsale Contract', () => {
  let Crowdsale;
  let crowdsale;
  let owner;
  let token;
  let buyer;

  before(async () => {
    [owner, buyer] = await ethers.getSigners();

    // Deploying Token contract
    const Token = await ethers.getContractFactory('Token');
    token = await Token.deploy();

    // Deploying Crowdsale contract
    const Crowdsale = await ethers.getContractFactory('Crowdsale');
    crowdsale = await Crowdsale.deploy(token.address, 0, 3600, 200, 1000); // passing appropriate arguments for testing
  });

  // Test startSale function

  it('should log the start time and end time', async () => {
    const startTime = await crowdsale.startTimestamp();
    const endTime = await crowdsale.endTimestamp();

    console.log("Start Time:", new Date(startTime * 1000)); 
    console.log("End Time:", new Date(endTime * 1000)); 
  });

  it('should set cliffTime and vestingTime correctly', async () => {
    const expectedCliffTime = 200; 
    const expectedVestingTime = 1000; 

    const actualCliffTime = await crowdsale.cliffTime();
    const actualVestingTime = await crowdsale.vestingTime();

    expect(actualCliffTime).to.equal(expectedCliffTime);
    expect(actualVestingTime).to.equal(expectedVestingTime);
  });

  it('should start the sale', async () => {
    await crowdsale.startSale();
    const isSaleActive = await crowdsale.isSaleActive();
    expect(isSaleActive).to.equal(true);
  });

  it('should fund tokens into the contract', async () => {
    const initialBalance = await token.balanceOf(crowdsale.address);
    const amount = ethers.utils.parseUnits('1000000', 18);
    await token.approve(crowdsale.address, amount); // Approve token transfer

    await crowdsale.fundTokens(amount);
    const newBalance = await token.balanceOf(crowdsale.address);
    expect(newBalance).to.equal(initialBalance.add(amount));
  });

  it('it should log the price of tokens per ETH', async () =>{
    const price = await crowdsale.tokensPerETh();
    console.log("price", price.toString());
  })

  it('should buy tokens and log buyer balance', async () => {
    const ethAmount = ethers.utils.parseEther('0.001'); 
    const expectedTokenAmount = await crowdsale.checkTokens(ethAmount);
    const initialBalance = await crowdsale.balances(buyer.address);

    // Purchase tokens
    await crowdsale.connect(buyer).buyTokens({ value: ethAmount });

    const newBalance = await crowdsale.balances(buyer.address);

    console.log("Buyer's Balance:", newBalance.toString());

    expect(newBalance.sub(initialBalance)).to.equal(expectedTokenAmount);
  });

  it('should halt the sale', async () => {
    let isSaleActiveBefore = await crowdsale.isSaleActive();
    expect(isSaleActiveBefore).to.equal(true);

    // Halt the sale
    await crowdsale.haltSale();

    let isSaleActiveAfter = await crowdsale.isSaleActive();
    expect(isSaleActiveAfter).to.equal(false);
  });

  it('should restart the sale', async () => {
    await crowdsale.startSale();
    const isSaleActive = await crowdsale.isSaleActive();
    expect(isSaleActive).to.equal(true);
  });

  it('should return 0 if current time is before cliffTime', async () => {

    const releasableAmount = await crowdsale.releasableAmount(buyer.address);

    // Assert
    expect(releasableAmount).to.equal(0);
  });

  it('should release vested tokens to the buyer', async () => {

    await waffle.provider.send('evm_increaseTime', [1001]); 
    await waffle.provider.send('evm_mine'); 
     
    const expectedVestedAmount = await crowdsale.balances(buyer.address);

    // Release vested tokens
    await crowdsale.connect(buyer).releaseVestedTokens();

    const buyerBalance = await token.balanceOf(buyer.address);
    console.log("Buyer's Token Balance after release:", buyerBalance.toString());

    expect(buyerBalance).to.equal(expectedVestedAmount);
  });

});