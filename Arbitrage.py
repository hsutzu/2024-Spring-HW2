liquidity = {
    ("tokenA", "tokenB"): (17, 10),
    ("tokenA", "tokenC"): (11, 7),
    ("tokenA", "tokenD"): (15, 9),
    ("tokenA", "tokenE"): (21, 5),
    ("tokenB", "tokenC"): (36, 4),
    ("tokenB", "tokenD"): (13, 6),
    ("tokenB", "tokenE"): (25, 3),
    ("tokenC", "tokenD"): (30, 12),
    ("tokenC", "tokenE"): (10, 8),
    ("tokenD", "tokenE"): (60, 25),
}

def get_exchange_rate(from_token, to_token):
    if (from_token, to_token) in liquidity:
        supply, demand = liquidity[(from_token, to_token)]
    elif (to_token, from_token) in liquidity:
        demand, supply = liquidity[(to_token, from_token)]
    else:
        return 0
    return demand / supply


def generate_paths(start_token, depth, current_path=[]):
    if depth == 0:
        return [current_path]
    paths = []
    for token in ["tokenA", "tokenB", "tokenC", "tokenD", "tokenE"]:
        if not current_path or token != current_path[-1]:  # Avoid immediate loops
            new_path = current_path + [token]
            paths.extend(generate_paths(start_token, depth-1, new_path))
    return paths

def evaluate_path(path, start_amount):
    amount = start_amount
    for i in range(len(path) - 1):
        amount = swap(path[i], path[i+1], amount)
        if amount == 0:
            return 0
    return amount



def swap(token_from, token_to, amount):
    if (token_from, token_to) in liquidity:
        reserve_from, reserve_to = liquidity[(token_from, token_to)]
    elif (token_to, token_from) in liquidity:
        reserve_to, reserve_from = liquidity[(token_to, token_from)]
    else:
        return 0  # No liquidity pool for this pair
    
    # Simplified exchange calculation without considering fees or slippage
    return amount * reserve_to / (reserve_from + amount)


def find_arbitrage(start_token, start_amount, max_depth):
    for depth in range(2, max_depth + 1):  # Start at 2 to ensure at least one swap back to B
        paths = generate_paths(start_token, depth, [start_token])
        for path in paths:
            if path[-1] == start_token:  # Ensure path ends with start_token
                final_amount = evaluate_path(path, start_amount)
                if final_amount > 20:
                    print(f"Arbitrage opportunity: path: {'->'.join(path)}, tokenB balance={final_amount:.6f}")
                    return  # Return on first found opportunity

# Let's try finding an arbitrage opportunity with a maximum path length of 5
find_arbitrage("tokenB", 5, 5)

