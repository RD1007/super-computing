# First run normally
# Then run GPU enabled


# import libraries
import numpy as np
import time

def runtests(n_simulations):

    # initialize variables
    n_points_circle = 0
    n_points_square = 0

    # create lists to store x and y values
    l_xs = []
    l_ys = []

    # loop n_simulations times
    for _ in range(n_simulations):
        
        # x is randomly drawn from a continuous uniform distritbuion
        x = np.random.uniform(-1, 1)
        # store x in the list
        l_xs.append(x)
        
        # y is randomly drawn from a continuous uniform distribution
        y = np.random.uniform(-1, 1)
        # store y in the list
        l_ys.append(y)
        
    # loop n_simulations times
    for i in range(n_simulations):
        
        # calculate the distance between the point and the origin
        dist_from_origin = l_xs[i] ** 2 + l_ys[i] ** 2
        
        # if the distance is smaller than or equal to 1, the point is in the circle
        if dist_from_origin <= 1:
            n_points_circle += 1
        
        # by definition of the uniform distribution, the point is in the square
        n_points_square += 1
        
    # estimate the value of pi
    pi = 4 * n_points_circle / n_points_square
    print(f"Tests: {n_simulations}\nResult: {pi}\n")

def main():
    start_time = time.perf_counter()

    # runtests(1000)
    # runtests(10000)
    # runtests(100000)
    # runtests(1000000)
    # runtests(10000000)
    # runtests(100000000) # 100 Mil, 3.5 mins
    runtests(1000000000) # 1 Billion

    end_time = time.perf_counter()

    elapsed_time = round(end_time - start_time, 2)
    if elapsed_time >= 60:
        minutes = int(elapsed_time // 60)
        seconds = round(elapsed_time % 60, 2)
        print(f"Time: {minutes} mins {seconds} sec")
    else:
        print(f"Time: {elapsed_time} seconds")


if __name__ == "__main__":
    main()