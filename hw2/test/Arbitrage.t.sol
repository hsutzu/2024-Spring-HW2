// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ISwapV2Router02} from "../src/Arbitrage.sol";

contract Token is ERC20 {
    constructor(string memory name, string memory symbol, uint256 initialMint) ERC20(name, symbol) {
        _mint(msg.sender, initialMint);
    }
}

contract Arbitrage is Test {
    Token tokenA;
    Token tokenB;
    Token tokenC;
    Token tokenD;
    Token tokenE;
    address owner = makeAddr("owner");
    address arbitrager = makeAddr("arbitrageMan");
    ISwapV2Router02 router = ISwapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    function _addLiquidity(address token0, address token1, uint256 token0Amount, uint256 token1Amount) internal {
        router.addLiquidity(
            token0,
            token1,
            token0Amount,
            token1Amount,
            token0Amount,
            token1Amount,
            owner,
            block.timestamp
        );
    }

    function setUp() public {
        vm.createSelectFork(vm.envString("RPC_URL"));
        vm.startPrank(owner);

        uint256 initialSupply = 100 ether;

        tokenA = new Token("tokenA", "A", initialSupply);
        tokenB = new Token("tokenB", "B", initialSupply);
        tokenC = new Token("tokenC", "C", initialSupply);
        tokenD = new Token("tokenD", "D", initialSupply);
        tokenE = new Token("tokenE", "E", initialSupply);

        tokenA.approve(address(router), initialSupply);
        tokenB.approve(address(router), initialSupply);
        tokenC.approve(address(router), initialSupply);
        tokenD.approve(address(router), initialSupply);
        tokenE.approve(address(router), initialSupply);

        _addLiquidity(address(tokenA), address(tokenB), 17 ether, 10 ether);
        _addLiquidity(address(tokenA), address(tokenC), 11 ether, 7 ether);
        _addLiquidity(address(tokenA), address(tokenD), 15 ether, 9 ether);
        _addLiquidity(address(tokenA), address(tokenE), 21 ether, 5 ether);
        _addLiquidity(address(tokenB), address(tokenC), 36 ether, 4 ether);
        _addLiquidity(address(tokenB), address(tokenD), 13 ether, 6 ether);
        _addLiquidity(address(tokenB), address(tokenE), 25 ether, 3 ether);
        _addLiquidity(address(tokenC), address(tokenD), 30 ether, 12 ether);
        _addLiquidity(address(tokenC), address(tokenE), 10 ether, 8 ether);
        _addLiquidity(address(tokenD), address(tokenE), 60 ether, 25 ether);

        tokenB.transfer(arbitrager, 5 ether);
        vm.stopPrank();
    }

    function testHack() public pure {
        console2.log("Happy Hacking!");
    }

    function testExploit() public {
        vm.startPrank(arbitrager);
        uint256 tokensBefore = tokenB.balanceOf(arbitrager);
        console.log("Before Arbitrage tokenB Balance: %s", tokensBefore);
        tokenB.approve(address(router), 5 ether);
        // address[] memory path = new address[](5);
        // path[0] = address(tokenB);
        // path[1] = address(tokenA);
        // path[2] = address(tokenD);
        //path[3] = address(tokenC);
        // path[4] = address(tokenB);

        // 执行交易
        //router.swapExactTokensForTokens(
        //    5 ether, // 使用的tokenB数量
        //    0,       // 接受的最小tokenB数量，根据实际情况调整
        //    path,    // 交换路径
        //    arbitrager, // 接收最终代币的地址
        //    block.timestamp + 300 // 交易的截止时间
        //);

        uint256 amountIn = 5 ether; // The amount of tokenB you're swapping
        uint256 slippageTolerance = 500; // Representing a 5% tolerance, adjust based on your risk appetite

        // Define the path for your swap
        address[] memory path = new address[](5);
        path[0] = address(tokenB);
        path[1] = address(tokenA);
        path[2] = address(tokenD);
        path[3] = address(tokenC); // Adjust based on your identified arbitrage path
        path[4] = address(tokenB);
        // First, get an estimate of the output amount
        uint256[] memory amountsOutEstimate = router.getAmountsOut(amountIn, path);

        // Apply slippage tolerance to calculate minimum amount out
        uint256 amountOutMin = amountsOutEstimate[amountsOutEstimate.length - 1] * (10000 - slippageTolerance) / 10000;

        // Perform the swap
        router.swapExactTokensForTokens(
            amountIn,
            amountOutMin, // Adjusted to include slippage tolerance
            path,
            address(this), // Assuming the contract itself will receive the output tokens
            block.timestamp + 300 // Deadline to prevent hanging transactions
        );

        uint256 tokensAfter = tokenB.balanceOf(arbitrager);
        assertGt(tokensAfter, 20 ether);
        console.log("After Arbitrage tokenB Balance: %s", tokensAfter);
    }
}
