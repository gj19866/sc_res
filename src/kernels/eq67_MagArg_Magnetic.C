#pragma once
#include "eq67_MagArg_Magnetic.h"

registerMooseObject("SCResApp", eq67_MagArg_Magnetic);

InputParameters
eq67_MagArg_Magnetic::validParams()
{
  InputParameters params = ADKernel::validParams();
  params.addClassDescription(
      "Kernel representing eq67 of bible in Mag Arg form. Variable is Phi.");
  params.addRequiredCoupledVar("Psi_Mag","Mag component of Psi");
  params.addRequiredCoupledVar("Phase",
                       "Phase component of Psi");
  params.addCoupledVar("A_field","Vector potential field");
  return params;
}

eq67_MagArg_Magnetic::eq67_MagArg_Magnetic(const InputParameters & parameters)
 : ADKernel(parameters),
    _Psi_Mag(adCoupledValue("Psi_Mag")),
    _grad_Psi_Mag(adCoupledGradient("Psi_Mag")),
    _grad_Phase(adCoupledGradient("Phase")),
    _A_field(adCoupledVectorValue("A_field"))
  {
  }

ADReal
eq67_MagArg_Magnetic::computeQpResidual()
{
  ADReal part1 = _grad_test[_i][_qp]*(-_grad_u[_qp] + _Psi_Mag[_qp]*_Psi_Mag[_qp]*_grad_Phase[_qp]);

  ADReal MagPart = _test[_i][_qp]*(2*_Psi_Mag[_qp]*_A_field[_qp]*_grad_Psi_Mag[_qp]) ;

  return part1 + MagPart;
}