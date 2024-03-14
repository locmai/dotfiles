import time

def factorial(n):
    if n == 0:
        return 1
    else:
        return n * factorial(n-1)

start = time.time()
factorial(20)
end = time.time()
microseconds = (end - start) * 1_000_000_000
print("Time taken in Python: ", round(microseconds, 3), "ns")
