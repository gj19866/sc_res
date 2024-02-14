

#include "CurrentAux_MagArg.h"


registerMooseObject("SCResApp", CurrentAux_MagArg);

InputParameters
CurrentAux_MagArg::validParams()
{
  InputParameters params = VectorAuxKernel::validParams();
  params.addClassDescription(
      "Calculates the current.");
  params.addRequiredCoupledVar("Psi_Mag", "Psi Real Component");
    params.addRequiredCoupledVar("Phase", "Psi Imaginary Component");
      params.addRequiredCoupledVar("Phi", "Phi Value");
  return params;
}

CurrentAux_MagArg::CurrentAux_MagArg(const InputParameters & parameters)
  : VectorAuxKernel(parameters),
    _Psi_Mag(coupledValue("Psi_Mag")),
    _grad_Phase(coupledGradient("Phase")),
    _grad_Phi(coupledGradient("Phi"))
{
}

RealVectorValue
CurrentAux_MagArg::computeValue()
{
  RealVectorValue value;

  value = _Psi_Mag[_qp]*_Psi_Mag[_qp]*_grad_Phase[_qp] - _grad_Phi[_qp];

  return value;
}