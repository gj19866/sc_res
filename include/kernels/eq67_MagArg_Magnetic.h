
#pragma once

#include "ADKernel.h"

/**
 *  Kernel representing the contribution of the PDE term $-L*v$, where $L$ is a
 *  reaction rate coefficient material property, $v$ is a scalar variable (nonlinear or coupled
 * auxvariable), and whose Jacobian contribution is calculated using automatic differentiation.
 */
class eq67_MagArg_Magnetic : public ADKernel
{
public:
  static InputParameters validParams();

  eq67_MagArg_Magnetic(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;
  

private:
  /**
   * Kernel variable (can be nonlinear or coupled variable)
   * (For constrained Allen-Cahn problems such as those in
   * phase field, v = lambda where lambda is the Lagrange
   * multiplier)
   */

  const ADVariableValue & _Psi_Mag;

  const ADVariableGradient & _grad_Psi_Mag;

  const ADVariableGradient & _grad_Phase;


  const ADVectorVariableValue & _A_field;



  /// Reaction rate material property

  
};