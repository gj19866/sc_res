#pragma once
#include "eq67_MagArg2.h"

registerMooseObject("SCResApp", eq67_MagArg2);

InputParameters
eq67_MagArg2::validParams()
{
  InputParameters params = ADKernel::validParams();
  params.addClassDescription(
      "Kernel representing eq67 of bible in Mag Arg form. Variable is Phi.");
  params.addRequiredCoupledVar("Psi_Mag","Mag component of Psi");
  params.addRequiredCoupledVar("arcPhase",
                       "arcPhase component of Psi");
  return params;
}

eq67_MagArg2::eq67_MagArg2(const InputParameters & parameters)
 : ADKernelGrad(parameters),
    _Psi_Mag(adCoupledValue("Psi_Mag")),
    _arcPhase(adCoupledValue("arcPhase")),
    _grad_arcPhase(adCoupledGradient("arcPhase"))
  {
  }

ADRealVectorValue
eq67_MagArg2::precomputeQpResidual()
{
  return -_grad_u[_qp] + _Psi_Mag[_qp]*_Psi_Mag[_qp]*_grad_arcPhase[_qp]/(1+ _arcPhase[_qp]*_arcPhase[_qp]);
}