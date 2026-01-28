#!/usr/bin/env bash
#SBATCH -J build_sst
#SBATCH -N 1 --ntasks-per-node=8
#SBATCH --constraint=intel
#SBATCH --mem=12GB
#SBATCH -t 2:00:00
#SBATCH -o build_sst_log.out

cd $SLURM_SUBMIT_DIR

# Submit to SLURM to run on a compute node
# Build Python3, OpenMPI, SST-Core, and SST-Elements from source
# Run in Scratch dir
# No sudo required

#################
# make dir tree #
#################

mkdir -p sst_stack_dir/source_build/{python,openmpi,sst_core,sst_elements}_build

#####################################
# set application versions and URLs #
#####################################

PYTHON_VERSION=3.12.3
PYTHON_URL="https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz"

OMPI_VERSION=5.0.8
OMPI_URL="https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-${OMPI_VERSION}.tar.gz"

SST_VERSION=15.0.0
SST_CORE_URL="https://github.com/sstsimulator/sst-core/releases/download/v${SST_VERSION}_Final/sstcore-${SST_VERSION}.tar.gz"
SST_ELEMENTS_URL="https://github.com/sstsimulator/sst-elements/releases/download/v${SST_VERSION}_Final/sstelements-${SST_VERSION}.tar.gz"

#############################
# Build Python3 from source #
#############################

echo "changing directory to Python build dir"

cd $SLURM_SUBMIT_DIR/sst_stack_dir/source_build/python_build

echo "Now working in $PWD and will start Python3 source compilation"

wget $PYTHON_URL

tar -xzvf Python-${PYTHON_VERSION}.tgz

cd Python-${PYTHON_VERSION}

echo "Inside $PWD and will run configure step"

echo "--prefix flag will be set to $PWD"

./configure --prefix=$PWD --enable-optimizations --with-ensurepip=install

make -j$(nproc)

make install

export PATH=${SLURM_SUBMIT_DIR}/sst_stack_dir/source_build/python_build/Python-${PYTHON_VERSION}/bin:$PATH

#############################
# Build OpenMPI from source #
#############################

cd $SLURM_SUBMIT_DIR/sst_stack_dir/source_build/openmpi_build

echo "Now working in $PWD and will start OpenMPI source compilation"

wget $OMPI_URL

tar -xzvf openmpi-${OMPI_VERSION}.tar.gz

cd openmpi-${OMPI_VERSION}

echo "Inside $PWD and will run configure step"

./configure --prefix=$PWD --with-slurm --with-pmix --enable-mpirun-prefix-by-default

make -j$(nproc) all

make install

export PATH=${SLURM_SUBMIT_DIR}/sst_stack_dir/source_build/openmpi_build/openmpi-${OMPI_VERSION}/bin:$PATH
export LD_LIBRARY_PATH=${SLURM_SUBMIT_DIR}/sst_stack_dir/source_build/openmpi_build/openmpi-${OMPI_VERSION}/lib:$LD_LIBRARY_PATH

##############################
# Build SST-Core from source #
##############################

cd $SLURM_SUBMIT_DIR/sst_stack_dir/source_build/sst_core_build

echo "Now working in $PWD and will start SST-Core source compilation"

wget $SST_CORE_URL

tar -xzvf sstcore-${SST_VERSION}.tar.gz

cd sst-core

echo "Now working in $PWD and will start SST-Core source compilation"

./configure --prefix=$PWD CC=$(which gcc) CXX=$(which g++) MPICC=$(which mpicc) MPICXX=$(which mpicxx)

make -j$(nproc)

make install

export PATH=$SLURM_SUBMIT_DIR/sst_stack_dir/source_build/sst_core_build/sst-core/bin:$PATH

##################################
# Build SST-Elements from source #
##################################

cd $SLURM_SUBMIT_DIR/sst_stack_dir/source_build/sst_elements_build

echo "Now working in $PWD and will start SST-Elements source compilation"

wget $SST_ELEMENTS_URL

tar -xzvf sstelements-${SST_VERSION}.tar.gz

cd sst-elements

echo "Now working in $PWD and will start SST-Elements source compilation"

./configure --prefix=$PWD --with-sst-core=$SLURM_SUBMIT_DIR/sst_stack_dir/source_build/sst_core_build/sst-core

make -j$(nproc)

make install

export PATH=$SLURM_SUBMIT_DIR/sst_stack_dir/source_build/sst_elements_build/sst-elements/bin:$PATH

######################
# Run SST Test Suite #
######################

cd $SLURM_SUBMIT_DIR

sst-test-core > sst_test_core.log 2>&1