#pragma once

#include "ADKernelGrad.h"

class eq67_MagArg2 : public ADKernelGrad
{
public:
  static InputParameters validParams();

  eq67_MagArg2(const InputParameters & parameters);

private:
 const ADVariableValue & _Psi_Mag;
  const ADVariableValue & _arcPhase;
  const ADVariableGradient & _grad_arcPhase;
 

protected:
  virtual ADRealVectorValue precomputeQpResidual() override;
};