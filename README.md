SCRes - Finite Element Modelling of Superconducting Nanostructures
=====

Welcome to a finite element approach to solving the Time-Dependent Ginzburg-Landau equations by Lloyd Stein

# Setup - Local

### **MOOSE Instillation**

- This code requires that MOOSE be already built on the system at the same file level as this repo.
- If MOOSE is not already installed please install it, following the instructions outlined here: https://mooseframework.inl.gov/getting_started/installation/index.html

- Please ensure you have made MOOSE, and have run the tests to ensure it is built correctly.

### **Cloning the project**

 Clone this project to your device at the same level as MOOSE with:

```
https://github.com/gj19866/sc_res.git
```

### **Making the App**

The `SCRes` App should be setup, and ready to use. However to start running simulations you first need to make the `SCResApp`. 

To make the app, move inside the sc_res directory:
```
cd sc_res
```

Ensure your MOOSE venv is activated with: 
```
mamba activate moose
```

Then make the app by typing :
```
make -j4 
```
- N.B. 4 cores to is just a suggestion here, you can change this if desired.

**We are now setup and ready to run some simulations!**

# Setup - HPC

### **MOOSE Instillation**


This follows the setup instructions for use on the University of Bristol's Blue Pebble, https://www.bristol.ac.uk/acrc/high-performance-computing/.

If working on a different HPC contact the system administrator for a MOOSE build, following the instructions here: https://mooseframework.inl.gov/getting_started/installation/index.html

MOOSE should already be built on Blue Pebble.

Copy this version of MOOSE to your personal drive with:

```
scp -r ab12345@bp1-login01:/sw/apps/Moose/projects/moose ab12345@bp1-login01:/user/home/ab12345/projects 
```
 Change into your MOOSE directory:

```
cd ~/projects/moose
```

Activate the module with:
```
module add apps/moose/1.0
```
And then activate the venv with:
```
source activate moose
```

Then make the app by typing:
```
make -j4 
```
- N.B. 4 cores to is just a suggestion here, you can change this if desired. Be aware that this will be made on the login nodes, so be considerate of others.

Make sure it has passed all the tests when making.

### **Cloning the project**

Now to download the project. 

First change into a directory at the same level as your `moose` directory. 

```
cd ~/projects
```

Clone this project to the cluster at the same level as MOOSE with:

```
https://github.com/gj19866/sc_res.git
```

### **Making the App**

The `SCResApp` should be setup, and ready to use. However to start running simulations you first need to make the `SCResApp`. 

To make the app, move inside the sc_res directory:
```
cd sc_res
```

Ensure your MOOSE venv is activated with: 
```
source activate moose
```

Then make the app by typing :
```
make -j4 
```
- N.B. 4 cores to is just a suggestion here, you can change this if desired. Be aware that this will be made on the login nodes, so be considerate of others.

**We are now setup and ready to run some simulations!**



# Running Models - Local

The system is now setup to run simulations!

Select the input file you would like to run. When making the `SCResApp`, it will have made the executable `sc_res-opt`.

To run the file use the command:

```
./sc_res-opt -i ./Demo/File.i
```
Or to run in parallel use, the following command, where X is the number of processors desired:
```
mpiexec -n X ./sc_res-opt -i ./Demo/File.i
```

# Running Models - HPC

The system is now setup to run simulations!

Select the input file you would like to run. When making the `SCResApp`, it will have made the executable `sc_res-opt`.

To run a model, use a job script of this general form:

```
#!/bin/bash
#SBATCH --job-name=test_job
#SBATCH --partition=test
#SBATCH --account=YOUR_PROJECT_CODE
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=0-01:00:00
#SBATCH --mem=400M

module add apps/moose/1.0
source activate moose

srun --cpu-bind=cores --mpi=pmi2 /user/home/ab12345/projects/sc_res/sc_res-opt -i /user/home/ab12345/projects/sc_res/Demo/File.i
```
Run this job script as normal with:

```
sbatch XXX.sh
```

# Input File

This next section will discuss how to build and alter your own input files.

MOOSE input files in this code are built with the following blocks:
- Mesh
- Variables
- Kernels
- AuxVariables
- AuxKernels
- ICs
- BCs
- UserObjects
- Functions
- Materials
- Postprocessors
- Executioner
- Outputs

## **Meshes**

There are two different ways that meshes are implmented and used within this app:

- MOOSE's in built mesh generator.

- Custom `gmsh` meshes.

### MOOSE in built mesh function

```
[Mesh]
    [mymesh]
      type = GeneratedMeshGenerator
      dim = 2
      nx = 20
      ny = 10
      xmax = 20
      ymax = 10
    []
  []
```
This automaticly creates a rectangular mesh. The number of elements in each direction is described by `nx`, and `ny`; the lengths in each direction is described by `xmax`, and `ymax`.

### GMSH

You can also use your own custom meshes by using an external meshing software such as `gmsh`, https://gmsh.info/. 
This has the advantage of being able to create custom meshes easily. 

- Gmsh also exists on the cluster if you want to build meshes directly on the cluster.

```
[Mesh]
    [generated]
        type = FileMeshGenerator
        file = 'Example.msh'
    []
[]
```

## Variables

In MOOSE, variables are the things that are directly solved for. In this case this is $\psi_R$, $\psi_I$, and $\varphi$.

These are all First Order Lagrange variables in this case. As this is the default variable type, this does not need to be specified. 

The Diffuse variable is used to provide spatial variation in the material properties, and is discussed later.


## Kernels

The kernels act on the variables, and this is where the bulk of the physics really occours in the project.

The three main kernels are `eq66Re_2`, `eq66Im_2`, and `eq67`. There are also the kernels that act on the diffuse variable, to cause some spatial diffusion in the varying material property term to introduce some smoothing.


## AuxVariables
 
Aux variables are calculated from variables in MOOSE rather than solved for directly. There are auxvariables for both phase, $\chi$, and the magnitude of the order parameter, $|\psi|$.

## AuxKernels

Both auxkernels use `ParsedAux` to calculate the values.

## Initial Conditions

Initial conditions are required for all variables. 

$\varphi$
- The inital condition for $\varphi$ is that it is set to zero everywhere, which would be satisfied if there is now current passing through the surface.

$\psi_R$ and $\psi_I$
- As we start the material in the superconducting phase, the IC must hold that $|\psi|=1$. 