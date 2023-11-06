//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "eq67_Mag.h"

registerMooseObject("SCResApp", eq67_Mag);

InputParameters
eq67_Mag::validParams()
{
  InputParameters params = ADKernelValue::validParams();
  params.addClassDescription("Variable Phi from eq67. For mag field. ");
  params.addCoupledVar("Psi_Re",
                       "Real component of Psi");
  params.addCoupledVar("Psi_Im",
                       "Imaginary component of Psi");
    params.addCoupledVar("a_field","Vector potential field");
  params.addParam<MaterialPropertyName>(
      "kappa", "kappa", "kappa");
  return params;
}

eq67_Mag::eq67_Mag(const InputParameters & parameters)
  : ADKernelValue(parameters),
    _Psi_Re(adCoupledValue("Psi_Re")),
    _grad_Psi_Re(adCoupledGradient("Psi_Re")),
    _Psi_Im(adCoupledValue("Psi_Im")),
    _grad_Psi_Im(adCoupledGradient("Psi_Im")),
    _a_field(adCoupledVectorValue("a_field")),
    _kappa(getADMaterialProperty<Real>("kappa"))
{
}

ADReal
eq67_Mag::precomputeQpResidual()
{
  
 return   (2/(_kappa[_qp]*_kappa[_qp]))*_a_field[_qp]*(_Psi_Re[_qp]*_grad_Psi_Re[_qp] + _Psi_Im[_qp]*_grad_Psi_Im[_qp]); 

}

