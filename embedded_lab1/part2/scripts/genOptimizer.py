import numpy as np
import pandas as pd

from pymoo.algorithms.moo.nsga2 import NSGA2
from pymoo.operators.sampling.rnd import IntegerRandomSampling
from pymoo.operators.crossover.sbx import SBX
from pymoo.operators.mutation.pm import PM
from pymoo.operators.repair.rounding import RoundingRepair
from pymoo.optimize import minimize
from pymoo.termination.default import DefaultMultiObjectiveTermination

from pmodules.optimizationProblem import OptimizationProblem

# There are 4 input variables a) L1I cache size, b) L1D cache size, c) L2 cache size, and d) the loop unrolling factor
nVar = 4
# Define the upper and lower bounds for our input variables
xU = np.asarray([5, 5, 3, 4])
xL = np.asarray([0, 0, 0, 0])

# Define the optimization problem
problem = OptimizationProblem(
    nVar,
    xL,
    xU
)

# Define the exploration algorithm
population_size = 10
offsprings = 5
algorithm = NSGA2(
    pop_size = population_size,
    n_offsprings = offsprings,
    sampling = IntegerRandomSampling(),
    crossover = SBX(prob = 1.0, eta = 3.0, vtype = float, repair = RoundingRepair()),
    mutation = PM(prob = 1.0, eta = 3.0, vtype = float, repair = RoundingRepair()),
    eliminate_duplicates = True
)

# Define the termination criteria
termination = DefaultMultiObjectiveTermination(
    xtol = 1e-8,
    cvtol = 1e-6,
    ftol = 0.0025,
    period = 30,
    n_max_gen = 5,
    n_max_evals = 1000
)

# Execute the optimization algorithm
result = minimize(problem, algorithm, termination, seed=42, verbose=True, return_least_infeasible=True)

df = pd.DataFrame(columns = ['L1I_cache_size', 'L1D_cache_size', 'L2_cache_size', 'unrolling_factor', 'exec_time_cc', 'total_mem_kB'])

# Print results
print("\nPareto Optimal Configurations\n")

paretoOptimalConfigsNum = len(result.X)
for i in range(0, paretoOptimalConfigsNum):
    XList = list(result.X[i])
    FList = list(result.F[i])
    
    L1ICacheSizeKB = 2 * (2 ** XList[0])
    L1DCacheSizeKB = 2 * (2 ** XList[1])
    L2CacheSizeKB = 128 * (2 ** XList[2])
    unrollingFactor = 2 * (2 ** XList[3])
    loopExecutionTimeCC = FList[0]
    totalMemoryKB = FList[1]
    
    index = i + 1
    print(str(index) + ")", "L1I (KB) =", L1ICacheSizeKB, "L1D (KB) =", L1DCacheSizeKB, "L2 (KB) =", L2CacheSizeKB, "UF =", unrollingFactor, "config. results in Execution Time (CC) =", int(loopExecutionTimeCC), "and Total Memory (KB) =", int(totalMemoryKB))
    
    temp = {
    	'L1I_cache_size': str(L1ICacheSizeKB) + 'kB',
    	'L1D_cache_size': str(L1DCacheSizeKB) + 'kB',
    	'L2_cache_size': str(L2CacheSizeKB) + 'kB',
    	'unrolling_factor': str(unrollingFactor),
    	'exec_time_cc': str(int(loopExecutionTimeCC)),
    	'total_mem_kB': str(int(totalMemoryKB))
    }
    
    df.loc[len(df)] = temp
    
df.to_csv('genOptimizer_PO.csv', index = False)
    
