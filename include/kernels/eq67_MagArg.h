#pragma once

#include "ADKernelGrad.h"

class eq67_MagArg : public ADKernelGrad
{
public:
  static InputParameters validParams();

  eq67_MagArg(const InputParameters & parameters);

private:
 const ADVariableValue & _Psi_Mag;
  const ADVariableGradient & _grad_Phase;
 

protected:
  virtual ADRealVectorValue precomputeQpResidual() override;
};