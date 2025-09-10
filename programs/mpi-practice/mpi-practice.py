from mpi4py import MPI
import platform

comm = MPI.COMM_WORLD # Communicator - "world" means the group of ALL processes, 0 .. P-1
pid = comm.Get_rank()
P = comm.Get_size()
host = platform.node()

print(f"Hello, I am {pid} out of {P} processes, running on {host}!")
# srun python mpi-practice.py 
