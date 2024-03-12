
#pragma once

#include "AuxKernel.h"

class CurrentAux : public VectorAuxKernel
{
public:
  static InputParameters validParams();

  CurrentAux(const InputParameters & parameters);

protected:
  virtual RealVectorValue computeValue() override;

private:

const VariableValue & _Psi_Re;
    const VariableValue & _Psi_Im;
  
    const VariableGradient & _grad_Psi_Re;
  const VariableGradient & _grad_Psi_Im;
  const VariableGradient & _grad_Phi;

};