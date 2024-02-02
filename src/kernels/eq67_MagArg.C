#pragma once
#include "eq67_MagArg.h"

registerMooseObject("SCResApp", eq67_MagArg);

InputParameters
eq67_MagArg::validParams()
{
  InputParameters params = ADKernel::validParams();
  params.addClassDescription(
      "Kernel representing eq67 of bible in Mag Arg form. Variable is Phi.");
  params.addRequiredCoupledVar("Psi_Mag","Mag component of Psi");
  params.addRequiredCoupledVar("Phase",
                       "Phase component of Psi");
  return params;
}

eq67_MagArg::eq67_MagArg(const InputParameters & parameters)
 : ADKernelGrad(parameters),
    _Psi_Mag(adCoupledValue("Psi_Mag")),
    _grad_Phase(adCoupledGradient("Phase"))
  {
  }

ADRealVectorValue
eq67_MagArg::precomputeQpResidual()
{
  return -_grad_u[_qp] + _Psi_Mag[_qp]*_Psi_Mag[_qp]*_grad_Phase[_qp];
}