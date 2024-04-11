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

def find_arbitrage_path(current_token, target_token, current_amount, path, visited, best_path, liquidity):
    if current_token == target_token and current_amount > 20 and len(path) > 1:
        if not best_path[0] or current_amount > best_path[1]:
            best_path[0] = path.copy()
            best_path[1] = current_amount
        return
    for (token_from, token_to), (liquidity_from, liquidity_to) in liquidity.items():
        if token_from == current_token and (token_to not in visited):
            exchange_rate = liquidity_to / liquidity_from
            next_amount = current_amount * exchange_rate
            path.append((token_from, token_to, next_amount))
            visited.add(token_to)
            find_arbitrage_path(token_to, target_token, next_amount, path, visited, best_path, liquidity)
            visited.remove(token_to)
            path.pop()

def main(liquidity):
    best_path = [None, 0]
    find_arbitrage_path('tokenB', 'tokenB', 5, [], set(['tokenB']), best_path, liquidity)
    if best_path[0]:
        print(f"Arbitrage path found with {best_path[1]:.2f} units of tokenB: {best_path[0]}")
    else:
        print("No arbitrage path found that meets the criteria.")
        print(best_path)
# Add reversed pairs to liquidity for bidirectional search
extended_liquidity = liquidity.copy()
for pair, (liquidity_from, liquidity_to) in liquidity.items():
    reversed_pair = (pair[1], pair[0])
    extended_liquidity[reversed_pair] = (liquidity_to, liquidity_from)

main(extended_liquidity)
