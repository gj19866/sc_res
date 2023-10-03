**Project Bible** by *Lloyd Stein* to document intial workings, ideas, and finding. 

***Fundemental Eqs***

The bible has the 3 equations, corresponding to eqs.66-68:

1.1) $$ -u \sqrt{1+\gamma^2|\psi|^2}\left(\frac{\partial}{\partial t}+i \varphi\right) \psi+\nabla^2 \psi+i \gamma^2 \psi \nabla^2 \varphi+\left(1-|\psi|^2\right) \psi=0 $$

1.2) $$\nabla^2 \varphi=\frac{\bar{\psi} \nabla^2 \psi-\psi \nabla^2 \bar{\psi}}{2 i}$$

1.3) $$\underline{j}=\frac{\bar{\psi} \boldsymbol{\nabla} \psi-\psi \boldsymbol{\nabla} \bar{\psi}}{2 i}-\nabla \varphi$$


***Considering Complex $\psi$***

$\psi$ is complex, and thus for the solving of the problem using FE, it must be seperated into real and imaginary parts, so that $\psi = \psi_R + i\psi_I$.  

By considering real and imaginary parts seperately, you then arrive at this set of equations for variables $\psi_R$, $\psi_I$, $\Phi$, and $\underline{j}$:

2.1) $$0=-u \sqrt{1+\gamma^2\left(\psi_R^2+\psi_I^2\right)}\left(\frac{\partial}{\partial t} \psi_R-\varphi \psi_I\right)+\nabla^2 \psi_R-\gamma^2 \psi_I \nabla^2 \varphi+\left(1-\psi_R^2-\psi_I^2\right) \psi_R$$


2.2) $$0=-u \sqrt{1+\gamma^2\left(\psi_R^2+\psi_I^2\right)}\left(\frac{\partial}{\partial t} \psi_I+\varphi \psi_R\right)+\nabla^2 \psi_I+\gamma^2 \psi_R \nabla^2 \varphi+\left(1-\psi_R^2-\psi_I^2\right) \psi_I$$

2.3) $$0=\nabla^2 \varphi-\psi_R \nabla^2 \psi_I+\psi_I \nabla^2 \psi_R$$

2.4) $$0=\underline{j}+\nabla \varphi-\psi_R \nabla \psi_I+\psi_I \nabla \psi_R$$


***Geneating A Weak Form***

To do this I have written one kernel for each equation to solve them. 

The kernels of the weak forms of the equations are as follows, with test function $\mu$:

3.1) $$ \mu * \{-u \sqrt{1+ \gamma^2 * (\Psi_{R}^2 + \Psi_{I}^2) } * \left(\frac{\partial}{\partial t} \Psi_R-\varphi \Psi_I\right)\}  \\+ \nabla \mu * \{(- \nabla \Psi_R)\} \\+ \nabla \mu  * \{(\gamma^2  \Psi_{I}  \nabla \varphi)\} + \mu*\{\gamma^2  \nabla \Psi_{I}  \nabla \varphi\}\\+ \mu *\{(1 - \Psi_{R}^2 -\Psi_{I}^2) *\Psi_{R}\} = 0$$

3.2) $$\mu * \{-u \sqrt{1+ \gamma^2 * (\Psi_{R}^2 + \Psi_{I}^2) } * \left(\frac{\partial}{\partial t} \psi_I+\varphi \psi_R\right)\}  \\+ \nabla \mu * \{- \nabla \Psi_I\} \\+ \nabla \mu  * \{- \gamma^2  \Psi_{R}  \nabla \varphi\} + \mu*\{-
\gamma^2  \nabla \Psi_{R}  \nabla \varphi\}\\+ \mu *\{(1 - \Psi_{R}^2 -\Psi_{I}^2) *\Psi_{I}\} = 0$$

3.3) $$ \nabla \mu * \{- \nabla \varphi\} \\+ \nabla \mu * \{ \Psi_R \nabla \Psi_I\} + \mu*\{\nabla \Psi_R \nabla \Psi_I\}\\+ \nabla \mu * \{- \Psi_I \nabla \Psi_R\} + \mu*\{-\nabla \Psi_I \nabla \Psi_R\}= 0$$

3.4) $$\mu \{\underline{j}+\nabla \varphi -\psi_R \nabla \psi_I+\psi_I \nabla \psi_R \} = 0$$



***Implementing into MOOSE***

As I have 4 variables, I have to pick a variable for each equation to solve for, so that each variable has at least one active kernel.
For ease of implementation 3.1 solves for $\psi_I$, 3.2 for $\psi_R$, 3.3 for $\Phi$, and 3.4 for $\underline{j}$.

The other variables in the equation need to be coupled in as `adCoupledValue` etc. 

When writing the return of the kernels for each of these equations are as follows:

4.1) With $u = \psi_I$: 
```
((_test[_i][_qp] * (-_ucon[_qp] * sqrt(1+ _gamma[_qp] * _gamma[_qp] * (_Psi_Re[_qp] * _Psi_Re[_qp] + _u[_qp] * _u[_qp])) ) * (_Psi_Re_dot[_qp] - _Phi[_qp] * _u[_qp])) + (_grad_test[_i][_qp] * (- _grad_Psi_Re[_qp])) + ((_grad_test[_i][_qp] * (_gamma[_qp] * _gamma[_qp] *  _u[_qp] * _grad_Phi[_qp])) + (_test[_i][_qp]*(_gamma[_qp] * _gamma[_qp] *  _grad_u[_qp] * _grad_Phi[_qp]))) + (_test[_i][_qp] * (1 - _Psi_Re[_qp] * _Psi_Re[_qp] - _u[_qp] * _u[_qp]) * _Psi_Re[_qp]))
```

4.2) With $u = \psi_R$: 
```
((_test[_i][_qp] * (-_ucon[_qp] * sqrt(1+ _gamma[_qp] * _gamma[_qp] * (_u[_qp] * _u[_qp] + _Psi_Im[_qp] * _Psi_Im[_qp])) ) * (_Psi_Im_dot[_qp] + _Phi[_qp] * _u[_qp])) + (_grad_test[_i][_qp] * (- _grad_Psi_Im[_qp])) + ((_grad_test[_i][_qp] * (- _gamma[_qp] * _gamma[_qp] *  _u[_qp] * _grad_Phi[_qp])) + (_test[_i][_qp]*(- _gamma[_qp] * _gamma[_qp] *_grad_u[_qp] * _grad_Phi[_qp]))) + (_test[_i][_qp] * (1 - _u[_qp] * _u[_qp] - _Psi_Im[_qp] * _Psi_Im[_qp]) * _Psi_Im[_qp]))
```

4.3) With $u = \varphi$: 
```
((_grad_test[_i][_qp] * (-_grad_u[_qp])) + ((_grad_test[_i][_qp] * (_Psi_Re[_qp] * _grad_Psi_Im[_qp])) + (_test[_i][_qp] * (_grad_Psi_Re[_qp] * _grad_Psi_Im[_qp]))) + ((_grad_test[_i][_qp] * ( - _Psi_Im[_qp] * _grad_u[_qp])) + (_test[_i][_qp] * ( - _grad_Psi_Im[_qp] * _grad_u[_qp]))))
```

4.4) With $u = \underline{j}$: 

N.B. This kernel is of type `ADVectorKernelValue`, and hence is automaticly multiplied by the test function: 
```
(((_u[_qp]) + (_grad_Phi[_qp]) - (_Psi_Re[_qp] * _grad_Psi_Im[_qp]) + (_Psi_Im[_qp] * _grad_Psi_Re[_qp])) )
```



These are integrated with some padding code as seen bellow in the example of the full `.C` file for the kernel for equation 3.2 is shown:

```
#include "eq66Im.h"
#include <cmath>

registerMooseObject("SCResApp", eq66Im);

InputParameters
eq66Im::validParams()
{
  InputParameters params = ADKernel::validParams();
  params.addClassDescription(
      "Kernel representing Im component of eq66 of bible. Variable is Psi_Re.");
  params.addCoupledVar("Psi_Im",
                       "Imaginary component of Psi");
  params.addCoupledVar("Phi",
                       "Phi");
  params.addParam<MaterialPropertyName>(
      "ucon", "ucon", "u from eq66");
  params.addParam<MaterialPropertyName>(
      "gamma", "gamma", "gamma from eq66");
  return params;
}

eq66Im::eq66Im(const InputParameters & parameters)
  : ADKernel(parameters),
    _Psi_Im(adCoupledValue("Psi_Im")),
    _grad_Psi_Im(adCoupledGradient("Psi_Im")),
    _Psi_Im_dot(adCoupledDot("Psi_Im")),
    _Phi(adCoupledValue("Phi")),
    _grad_Phi(adCoupledGradient("Phi")),
    _ucon(getADMaterialProperty<Real>("ucon")),
    _gamma(getADMaterialProperty<Real>("gamma"))
{
}

ADReal
eq66Im::computeQpResidual()
{

//    part1 = (_test[_i][_qp] * (-_ucon[_qp] * sqrt(1+ _gamma[_qp] * _gamma[_qp] * (_u[_qp] * _u[_qp] + _Psi_Im[_qp] * _Psi_Im[_qp])) ) * (_Psi_Im_dot[_qp] + _Phi[_qp] * _u[_qp]));

//    part2 = (_grad_test[_i][_qp] * (- _grad_Psi_Im[_qp]));

//    part3 = (_grad_test[_i][_qp] * (- _gamma[_qp] * _gamma[_qp] *  _u[_qp] * _grad_Phi[_qp]));

//    part4 = (_test[_i][_qp] * (1 - _u[_qp] * _u[_qp] - _Psi_Im[_qp] * _Psi_Im[_qp]) * _Psi_Im[_qp]);

  return  (_test[_i][_qp] * (-_ucon[_qp] * sqrt(1+ _gamma[_qp] * _gamma[_qp] * (_u[_qp] * _u[_qp] + _Psi_Im[_qp] * _Psi_Im[_qp])) ) * (_Psi_Im_dot[_qp] + _Phi[_qp] * _u[_qp])) + (_grad_test[_i][_qp] * (- _grad_Psi_Im[_qp])) + (_grad_test[_i][_qp] * (- _gamma[_qp] * _gamma[_qp] *  _u[_qp] * _grad_Phi[_qp])) +  (_test[_i][_qp] * (1 - _u[_qp] * _u[_qp] - _Psi_Im[_qp] * _Psi_Im[_qp]) * _Psi_Im[_qp]);

}
```

***Initial conditions***

$\Psi_R$ and $\Psi_I$ 

- $\Psi$ should have constant magnitude but random phase.
To do this when seperating into Real and Imaginary parts I have written a python script that randomly picks values of $\Psi_R$ and $\Psi_I$, and then normalises them so that $|\psi|^2 = \Psi_R^2 + \Psi_I^2 = 1$.
These are then written to a `.csv` which is then loaded in as a function in MOOSE, and then $\Psi_Re$ and $\Psi_Im$ are assigned IC values from this function. Note that values are assigned nodally.  

$\varphi$
- I do not know what IC is required for $\varphi$, however note that in first working examples the results do depend on the IC of $\varphi$.

$\underline{j}$
- $\underline{j}$ is set to $\underline{0}$.


***Boundary Conditions***

Need to confirm what BCs are required.

Currenlty all scalar fields, $\Psi_R$, $\Psi_I$, and $\varphi$ are periodic in the x-axis, by using the `Periodic` Actions system in MOOSE. In the y-axis they have a standard Neumann BC.

$\underline{j}$ I am still unsure about. Currently it is set to a `VectorFunctionDirichletBC`. Charge conservation needs to always be considered with $\underline{j}$.


***Model Outputs***
The model needs to ouput phase, $\chi$, and the voltage, $V$.

$\chi$
- $\chi$ is trivial to calculate, by creating an `AuxVariable` where $\chi = atan2(\Phi_I, \Phi_R)$. Note the $atan2$ function ranges from $(-\pi, \pi)$, rather than $(-\pi/2, \pi/2)$ as with the $atan$ function


$V$
- $V$ I still need to work out how to calculate, however it is likely to also encorperate use of the `AuxVariable` system as with $\chi$.

***Inital Findings and Comments***

I had an example, but realised I was missing some terms from the equations, due to making a mistake with the product rule.
The model with the incomplete kernels actually solved (obviously the results are inherently incorrect), but when the kernels were corrected the solve fails to converge. Sod's Law!

Runtime
- First indications are that runtime may be significantly higher than the previous python code. We will have to wait for the full model to confirm.

$\varphi$
- I dont fully understand what $\varphi$ actually is.

$\underline{j}$
- The implenation of $\underline{j}$ I feel is currenlty incorrect, and I will have to review it further.


