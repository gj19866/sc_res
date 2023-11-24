SCRes - Finite Element Modelling of Superconducting Nanostructures
=====

**Instillation**

- This code requires that MOOSE be already built on the system at the same file level as this repo.
- If MOOSE is not already installed please install it, following the instructions outlined here: https://mooseframework.inl.gov/getting_started/installation/index.html


**Clone**

Clone this github to your device

**Making the App**

Now inside the sc_res directory:
- Active you MOOSE venv with 
```
mamba activate moose
```
- Make the app by typing:

```
make -j4 
```
**Running Models**

The system is now setup to run simulations!

Select the input file you would like to run.

To run the file use the command:

```
./sc_res-opt -i ./Demo/File.i
```
Or to run on multiple processors use, the following command, where X is the number of processors desired:
```
mpiexec -n X ./sc_res-opt -i ./Demo/File.i
```

