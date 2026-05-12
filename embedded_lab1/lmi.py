import cvxpy as cp
import numpy as np

a_values = np.linspace(-10, 10, 2001) # values of a
stable_a = []

# loop for all values of a in the vector
for a in a_values:
    A1 = np.array([[0.9, a],
                   [0.0, 0.8]])

    A2 = np.array([[0.9, 0.0],
                   [a,   0.8]])
    
    P = cp.Variable((2,2), symmetric=True)

    eps = 1e-3

    # LMIs
    constraints = [
        P >> eps * np.eye(2),
        P - A1.T @ P @ A1 >> eps * np.eye(2),
        P - A2.T @ P @ A2 >> eps * np.eye(2),
    ]
        
    prob = cp.Problem(cp.Minimize(0), constraints)
    
    # try:    
    prob.solve()

    if prob.status == cp.OPTIMAL or prob.status == cp.OPTIMAL_INACCURATE:
        stable_a.append(a)
    # except:
    #     pass
    
    
    # try:
    #     prob.solve(solver=cp.SCS, verbose=False)
    #     if prob.status in [cp.OPTIMAL, cp.OPTIMAL_INACCURATE]:
    #         stable_a.append(a)
    # except:
    #     pass
        
        
if len(stable_a) > 0:
    print("Stable a values:", min(stable_a), "to", max(stable_a))
else:
    print("No feasible a found.")