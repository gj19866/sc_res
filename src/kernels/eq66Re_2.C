//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "eq66Re_2.h"
#include <cmath>

registerMooseObject("SCResApp", eq66Re_2);

InputParameters
eq66Re_2::validParams()
{
  InputParameters params = ADKernel::validParams();
  params.addClassDescription(
      "Kernel representing real component of eq66 of bible. Variable is Psi_Im.");
  params.addRequiredCoupledVar("Psi_Re","Real component of Psi");
  params.addRequiredCoupledVar("Phi",
                       "Phi");
params.addCoupledVar("Diffuse",
                       "Diffuse");
  params.addParam<MaterialPropertyName>(
      "ucon", "ucon", "u from eq66");
  params.addParam<MaterialPropertyName>(
      "gamma", "gamma", "gamma from eq66");
  return params;
}

eq66Re_2::eq66Re_2(const InputParameters & parameters)
  : ADKernel(parameters),
    _Psi_Re(adCoupledValue("Psi_Re")),
    _grad_Psi_Re(adCoupledGradient("Psi_Re")),
    _Psi_Re_dot(adCoupledDot("Psi_Re")), 
    _Phi(adCoupledValue("Phi")),
    _grad_Phi(adCoupledGradient("Phi")),
    _Diffuse(adCoupledValue("Diffuse")),
    _ucon(getADMaterialProperty<Real>("ucon")),
    _gamma(getADMaterialProperty<Real>("gamma"))
{
}

ADReal
eq66Re_2::computeQpResidual()
{

  ADReal part1 = (_test[_i][_qp] * (-_ucon[_qp] * sqrt(1+ _gamma[_qp] * _gamma[_qp] * (_Psi_Re[_qp] * _Psi_Re[_qp] + _u[_qp] * _u[_qp])) ) * (_Psi_Re_dot[_qp] - _Phi[_qp] * _u[_qp]));

  ADReal part2 = (_grad_test[_i][_qp] * (- _grad_Psi_Re[_qp]));

  ADReal part3 = ((_grad_test[_i][_qp] * (_gamma[_qp] * _gamma[_qp] *  _u[_qp] * _grad_Phi[_qp])) + (_test[_i][_qp]*(_gamma[_qp] * _gamma[_qp] *  _grad_u[_qp] * _grad_Phi[_qp])));

  ADReal part4 = (_test[_i][_qp] * (_Diffuse[_qp] - _Psi_Re[_qp] * _Psi_Re[_qp] - _u[_qp] * _u[_qp]) * _Psi_Re[_qp]);

  return part1 + part2 + part3 + part4;

}