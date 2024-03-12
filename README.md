SCRes - Finite Element Modelling of Superconducting Nanostructures
=====

Welcome to a finite element approach to solving the Time-Dependent Ginzburg-Landau equations by Lloyd Stein

# Table of Contents
- [Setup - Local](#setup---local)
  - [MOOSE Installation](#moose-installation)
  - [Cloning the Project](#cloning-the-project)
  - [Making the App](#making-the-app)
- [Setup - HPC](#setup---hpc)
  - [MOOSE Installation](#moose-installation-1)
  - [Cloning the Project](#cloning-the-project-1)
  - [Making the App](#making-the-app-1)
- [Running Models](#running-models)
  - [Running Models - Local](#running-models---local)
  - [Running Models - HPC](#running-models---hpc)
- [Input File](#input-file)
  - [Meshes](#meshes)
  - [Variables](#variables)
  - [Kernels](#kernels)
  - [AuxVariables](#auxvariables)
  - [AuxKernels](#auxkernels)
  - [Initial Conditions](#initial-conditions)
  - [Boundary Conditions - Normal BCs](#boundary-conditions---normal-bcs)
  - [Boundary Conditions - Superconducting BCs](#boundary-conditions---superconducting-bcs)
  - [Functions](#functions)
  - [Materials](#materials)
  - [Post Processors](#post-processors)
  - [Executioner](#executioner)
  - [Outputs](#outputs)
- [Demo Files](#demo-files)
- [Exodus Processing](#exodus-processing)
- [Contact Information](#contact-information)

# Setup - Local

### **MOOSE Instillation**

- This code requires that MOOSE be already built on the system at the same file level as this repo.
- If MOOSE is not already installed please install it, following the instructions outlined here: https://mooseframework.inl.gov/getting_started/installation/index.html

- Please ensure you have made MOOSE, and have run the tests to ensure it is built correctly.

### **Cloning the project**

 Clone this project to your device at the same level as MOOSE with:

```
git clone https://github.com/gj19866/sc_res.git
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


# Running Models
 
## Running Models - Local

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

## Running Models - HPC

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
This automatically creates a rectangular mesh. The number of elements in each direction is described by `nx`, and `ny`; the lengths in each direction is described by `xmax`, and `ymax`.

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
- The inital condition for $\varphi$ is that it is set to zero everywhere, which would be satisfied if there is no current passing through the surface.


$\psi_R$ and $\psi_I$
- As we start the material in the superconducting phase, the IC must hold that $|\psi|=1$. To prevent biassing the initial condition, random values of $\psi_R$ and $\psi_I$ are assigned, with the condition that $|\psi_R|^2 + |\psi_I|^2 = |\psi|^2=1$. This is done by using a python file to create values, which are then written to a `.csv` file called `Psi_csv.csv`, that can be read into MOOSE via the `PropertyReadFile` `UserObject`.

## Boundary Conditions - Normal BCs

This denotes the boundary conditions for the case where the plate is superconducting on the boundaries where current is not being added, and the plate is not superconducting on the boundaries where current is being added

### $\varphi$
- Non-current boundaries: 
Boundaries are `ADNeumannBC`, such that $\nabla \cdot \varphi = 0$

- Current adding/removing boundaries:
Boundaries are `FunctionNeumannBC`, with $\nabla \cdot \varphi = j_b$ on the current adding boundary, and $\nabla \cdot \varphi = -j_b$ on the current removing boundary. Note that charge must be conserved here. By using `FunctionNeumannBC` allows the current passed through the sample to be a function of time.


### $\psi_R$ and $\psi_I$

- On the non-current boundaries:
Boundaries are `ADNeumannBC`, such that $\nabla \cdot \psi_{R/I} = 0$.

- On the current adding/removing boundaries:
Boundaries are considered `ADDirichletBC`, with $\psi_{R/I} = 0$. This is because the current adding boundaries are non-superconducting, therefore the order parameter falls to zero here.

## Boundary Conditions - Superconducting BCs

This is still under development, and requires documentation.
The idea of this is that the boundaries where current is added will be considered superconducting rather then non-superconducting as above. This will be done by adding a super-current rather than a normal current. 


## Functions

There are several functions used in the programme. 

Psi_Re_Func and Psi_Im_Func
- These are used to read in the IC values from the csv file using the `PiecewiseConstantFromCSV`.

Phi_left and Phi_right
- These are used to set the current being added and removed via the used of `ParsedFunction`, so that the current can be written as a function of time. Note that so that current is conserved, Phi_left = - Phi_right.  


## Materials

### ucon
- The value of $u$ from the TDGLE.

### $\gamma$
- The value of $\gamma$ from the TDGLE

These were set as material properties so that they have the ability to be varied spatially. If it is decided that the ability to vary these values spatially, then these could be just set as variables instead, and this would remove the need to index over each quadrature point in the solve, thus increasing the speed of the solve slightly. 


## Post Processors

Post processors have been added to analyse the output of the solve. 

There are post processors added to points on the top and bottom boundaries, slightly offset from the current adding/removing boundaries to get the value of $\varphi$, using `PointValue`. The difference in the values across the sample can then be computed by another post processor to calculate an analog for the voltage across the sample, using `DifferencePostprocessor`.

There is a current post processor to look at the current added to the sample, using `FunctionValuePostprocessor`. 

The average value of $|\psi|$ is also calculated over the whole sample using `AverageNodalVariableValue`, so that the 'amount of superconductivity' left in the sample can be gauged.


## Executioner

The solve type is `Transient` as the solve varies in time. The number of non-linear, and linear iterations have been increased relative to the default due to the poor convergence due to having higher order terms being solved for in the kernels.

There is adaptive time step option that can be used/removed by keeping or hashing out the `TimeStepper` block.

Additional petsc options are in the Executioner block. These are quite complicated, fiddle with at your own risk!


## Outputs

Simple outputs block that outputs the results of the solve to an `exodus` file. There are also the options to print the non-linear and/or linear residuals of the solve to the terminal by switching `print_linear_residuals` and `print_nonlinear_residuals` to True. 


# Demo files

There are several demo files to show off the capabilities of the code base. 
These can be found in the Demo directory. 

Demo\NormalBC.i 
- This file has the 'Normal BCs' as mentioned above applied onto a rectangular plate. Material properties across the plate are constant. This should be the first input file studied when trying to understand the programme.

Demo\NormalBC_VarryingProperties.i
- This file is constructed in the same essence as the NormalBC.i file mentioned above, however there is a parameter added so that maximum value of of $|\psi|$ across the plate varies. This is to promote the formation of vortices.


Extra Demo files for various, non-trivial meshes, and for SupercondutingBCs will be added in the future.


# Exodus Processing

Exodus files are being processed with seacas. This will be documented later.

# Contact Information

If you have any questions about the programme, or require support when using it please do not hesitate to contact me via email, lloyd.steinfamily@gmail.com.