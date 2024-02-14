

#pragma once

#include "ADKernel.h"

class eq66Im_MagArg2 : public ADKernel
{
public:
  static InputParameters validParams();

  eq66Im_MagArg2(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;
  

private:
  /**
   * Kernel variable (can be nonlinear or coupled variable)
   * (For constrained Allen-Cahn problems such as those in
   * phase field, v = lambda where lambda is the Lagrange
   * multiplier)
   */
  const ADVariableValue & _arcPhase;
  const ADVariableGradient & _grad_arcPhase;

  const ADVariableValue & _Phi;
  const ADVariableGradient & _grad_Phi;

  const ADVariableValue & _arcPhase_dot;

  
    const ADVariableValue & _Diffuse;

  



  /// Reaction rate material property
  const ADMaterialProperty<Real> & _ucon;
  const ADMaterialProperty<Real> & _gamma;
  
};