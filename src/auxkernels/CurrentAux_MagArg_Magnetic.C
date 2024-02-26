

#include "CurrentAux_MagArg_Magnetic.h"


registerMooseObject("SCResApp", CurrentAux_MagArg_Magnetic);

InputParameters
CurrentAux_MagArg_Magnetic::validParams()
{
  InputParameters params = VectorAuxKernel::validParams();
  params.addClassDescription(
      "Calculates the current.");
  params.addRequiredCoupledVar("Psi_Mag", "Psi Real Component");
    params.addRequiredCoupledVar("Phase", "Psi Imaginary Component");
      params.addRequiredCoupledVar("Phi", "Phi Value");
       params.addCoupledVar("A_field","Vector potential field");
  return params;
}

CurrentAux_MagArg_Magnetic::CurrentAux_MagArg_Magnetic(const InputParameters & parameters)
  : VectorAuxKernel(parameters),
    _Psi_Mag(coupledValue("Psi_Mag")),
    _grad_Phase(coupledGradient("Phase")),
    _grad_Phi(coupledGradient("Phi")),
     _A_field(coupledVectorValue("A_field"))
{
}

RealVectorValue
CurrentAux_MagArg_Magnetic::computeValue()
{
  RealVectorValue value;

  value = _Psi_Mag[_qp]*_Psi_Mag[_qp]*(_grad_Phase[_qp]-_A_field[_qp]) - _grad_Phi[_qp];

  return value;
}