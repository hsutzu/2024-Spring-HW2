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
Slippage in the context of Automated Market Makers (AMMs) refers to the difference between the expected price of a trade and the executed price.
This difference arises because the actual price of an asset in an AMM is determined by a mathematical formula based on the supply of each asset in the liquidity pool.
#### Addressing Slippage in Uniswap V2



## Problem 3
Please examine the mint function in the UniswapV2Pair contract. Upon initial liquidity minting, a minimum liquidity is subtracted. What is the rationale behind this design?

> Solution

## Problem 4
Investigate the minting function in the UniswapV2Pair contract. When depositing tokens (not for the first time), liquidity can only be obtained using a specific formula. What is the intention behind this?

> Solution

## Problem 5
What is a sandwich attack, and how might it impact you when initiating a swap?

> Solution

