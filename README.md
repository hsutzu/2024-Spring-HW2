# 2024-Spring-HW2

Please complete the report problem below:

## Problem 1
Provide your profitable path, the amountIn, amountOut value for each swap, and your final reward (your tokenB balance).

> Solution  

My profitable path is tokenB->tokenA->tokenD->tokenC->tokenB.
swap1:  
amountIn: 5, amountOut: 5.666666666666667  
swap2:  
amountIn: 5.666666666666667, amountOut: 2.467741935483871  
swap3:  
amountIn: 2.467741935483871, amountOut: 5.117056856187291  
swap4:  
amountIn: 5.117056856187291, amountOut: 20.205429200293473  
  
final reward (tokenB balance): 20.205429200293473  
![image](https://github.com/hsutzu/2024-Spring-HW2/assets/87229781/60557705-3a49-41f8-837d-595723f51378)
## Problem 2
What is slippage in AMM, and how does Uniswap V2 address this issue? Please illustrate with a function as an example.

> Solution  

Slippage refers to the difference between the expected price of a trade and the price at which the trade is executed. In AMMs, slippage often occurs due to the constant product formula used to maintain liquidity pools' invariant.

#### Addressing Slippage in Uniswap V2
Uniswap V2, like its predecessor, utilizes a formula 
x×y=k where x and y represent the quantities of two different tokens in the liquidity pool, and k is a constant. When a trade is executed, it alters the balances of 
x and y, thus changing the price according to the curve defined by this equation.

To address slippage, Uniswap V2 allows users to specify a maximum slippage tolerance when placing a trade. This means trades will revert if the price slippage exceeds the user’s specified tolerance, preventing unexpected losses due to high slippage in volatile market conditions. This is especially important in large trades relative to the pool's size.


## Problem 3
Please examine the mint function in the UniswapV2Pair contract. Upon initial liquidity minting, a minimum liquidity is subtracted. What is the rationale behind this design?

> Solution    

In Uniswap V2, the first time liquidity is provided to a pool, a small amount of liquidity tokens (specifically, 1000 units) is permanently locked in the pool. This is subtracted from the initial mint of liquidity tokens. The primary rationale behind this design choice is to avoid divisibility issues and rounding errors with very small numbers, ensuring that the pool cannot be completely drained (which would break the 
x×y=k invariant). This minimal amount serves as a "buffer" for these technical concerns.

## Problem 4
Investigate the minting function in the UniswapV2Pair contract. When depositing tokens (not for the first time), liquidity can only be obtained using a specific formula. What is the intention behind this?

> Solution    

When liquidity is added to an existing pool in Uniswap V2 (i.e., not the first time), the amount of liquidity tokens minted for the depositor is determined by the formula:

### Function: Calculate Liquidity Minted

The amount of liquidity minted can be calculated using the following formula:

liquidity_minted=min( x amount0_deposited×total_liquidity/x, amount1_deposited×total_liquidit​/y)


Where x and y are the reserves of the two tokens in the pool before the deposit, and 
amount0_deposited amount0_deposited and amount1_deposited amount1_deposited are the amounts of the tokens being added. This formula ensures that the liquidity shares are issued proportionally to the depositor's contribution relative to the existing pool size, maintaining the invariant and fair distribution among liquidity providers.


## Problem 5
What is a sandwich attack, and how might it impact you when initiating a swap?

> Solution  

A sandwich attack is a type of front-running attack where a malicious trader will place a buy order right before a known upcoming transaction, only to sell it right after at a higher price due to the slippage caused by the victim's transaction. This affects traders on platforms like Uniswap because it can lead to worsened trade execution prices.

Victims of a sandwich attack often receive less output for their swap than anticipated as the attacker manipulates the market price between the two transactions. This is particularly detrimental in high-slippage environments or when large orders are placed without adequate slippage protection.

These insights help in understanding the underlying mechanics and potential vulnerabilities in using AMMs like Uniswap V2.
