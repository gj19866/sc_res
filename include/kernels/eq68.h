//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "ADKernelValue.h"

/**
 *  Kernel representing the contribution of the PDE term $-L*v$, where $L$ is a
 *  reaction rate coefficient material property, $v$ is a scalar variable (nonlinear or coupled
 * auxvariable), and whose Jacobian contribution is calculated using automatic differentiation.
 */
class eq68 : public ADVectorKernelValue
{
public:
  static InputParameters validParams();

  eq68(const InputParameters & parameters);

protected:
  virtual ADRealVectorValue precomputeQpResidual() override;
  

private:
  /**


   * Kernel variable (can be nonlinear or coupled variable)
   * (For constrained Allen-Cahn problems such as those in
   * phase field, v = lambda where lambda is the Lagrange
   * multiplier)
   */
  const ADVariableValue & _Psi_Re;
  const ADVariableGradient & _grad_Psi_Re;

  const ADVariableValue & _Psi_Im;
  const ADVariableGradient & _grad_Psi_Im;

  const ADVariableValue & _Phi;
  const ADVariableGradient & _grad_Phi;

  
};