

#include "CurrentAux.h"


registerMooseObject("SCResApp", CurrentAux);

InputParameters
CurrentAux::validParams()
{
  InputParameters params = VectorAuxKernel::validParams();
  params.addClassDescription(
      "Calculates the current.");
  params.addRequiredCoupledVar("Psi_Re", "Psi Real Component");
    params.addRequiredCoupledVar("Psi_Im", "Psi Imaginary Component");
      params.addRequiredCoupledVar("Phi", "Phi Value");
  return params;
}

CurrentAux::CurrentAux(const InputParameters & parameters)
  : VectorAuxKernel(parameters),
    _Psi_Re(coupledValue("Psi_Re")),
    _Psi_Im(coupledValue("Psi_Im")),
    _grad_Psi_Re(coupledGradient("Psi_Re")),
    _grad_Psi_Im(coupledGradient("Psi_Im")),
    _grad_Phi(coupledGradient("Phi"))
{
}

RealVectorValue
CurrentAux::computeValue()
{
  RealVectorValue value;

  value = (_Psi_Re[_qp]*_grad_Psi_Im[_qp])-(_Psi_Im[_qp]*_grad_Psi_Re[_qp])-(_grad_Phi[_qp]);

  return value;
}