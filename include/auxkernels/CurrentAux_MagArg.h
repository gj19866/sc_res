
#pragma once

#include "AuxKernel.h"

class CurrentAux_MagArg : public VectorAuxKernel
{
public:
  static InputParameters validParams();

  CurrentAux_MagArg(const InputParameters & parameters);

protected:
  virtual RealVectorValue computeValue() override;

private:

const VariableValue & _Psi_Mag;

  const VariableGradient & _grad_Phase;
  const VariableGradient & _grad_Phi;

};