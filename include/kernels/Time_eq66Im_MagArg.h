

#pragma once

#include "ADTimeKernel.h"

/**
 *  Kernel representing the contribution of the PDE term $-L*v$, where $L$ is a
 *  reaction rate coefficient material property, $v$ is a scalar variable (nonlinear or coupled
 * auxvariable), and whose Jacobian contribution is calculated using automatic differentiation.
 */
class Time_eq66Im_MagArg : public ADTimeKernel
{
public:
  static InputParameters validParams();

  Time_eq66Im_MagArg(const InputParameters & parameters);

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

  const ADVariableValue & _Phi;
  const ADVariableGradient & _grad_Phi;

  
    const ADVariableValue & _Diffuse;

  



  /// Reaction rate material property
  const ADMaterialProperty<Real> & _ucon;
  const ADMaterialProperty<Real> & _gamma;
  
};