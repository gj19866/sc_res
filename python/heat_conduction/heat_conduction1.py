import numpy as np
import matplotlib.pyplot as plt


def crank_nicolson(u0, dx, dt, alpha, T):
    N = len(u0)
    M = int(T / dt)
    r = alpha * dt / (2 * dx ** 2)

    # Define the matrices A and B
    A = np.diag((1 + 2 * r) * np.ones(N))
    A += np.diag(-r * np.ones(N - 1), k=1)
    A += np.diag(-r * np.ones(N - 1), k=-1)
    B = np.diag((1 - 2 * r) * np.ones(N))
    B += np.diag(r * np.ones(N - 1), k=1)
    B += np.diag(r * np.ones(N - 1), k=-1)

    # Modify A and B for Dirichlet boundary conditions
    A[0, 0] = A[-1, -1] = 1
    A[0, 1] = A[-1, -2] = 0
    B[0, 0] = B[-1, -1] = 1
    B[0, 1] = B[-1, -2] = 0

    u = u0.copy()
    x = np.linspace(0, L, N)

    # Plot the initial condition
    plt.plot(x, u, label="t = 0")

    # Time stepping
    for n in range(1, M + 1):
        b = B @ u
        # Boundary condition at the left end
        b[0] = 500
        # Boundary condition at the right end
        b[-1] = 300

        u = np.linalg.solve(A, b)

        # Plot the solution every 10 timesteps
        if n % 10 == 0:
            plt.plot(x, u, label=f"t = {n * dt}")

    plt.xlabel('Position')
    plt.ylabel('Temperature (K)')
    plt.legend()
    plt.show()

    return u


# Example usage
L = 2  # Length of the bar
N = 10  # Number of spatial points
dx = L / (N - 1)
dt = 1  # Time step
T = 100  # Total time

thermal_conductivity = 45.0
specific_heat = 0.5
density = 8000
alpha = thermal_conductivity / (density * specific_heat)

u0 = 300 * np.ones(N)  # Initial condition: 300K throughout the bar

u = crank_nicolson(u0, dx, dt, alpha, T)
