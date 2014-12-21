import math

def isPrime(n):
    if n <= 1: return False
    if n == 2: return True
    if n % 2 == 0: return False

    for t in range(3, int(math.sqrt(n)+1), 2):
        if n % t == 0: return False
    return True

print [n for n in range(100) if isPrime(n)]
