//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "eq66Im.h"
#include <cmath>

registerMooseObject("SCResApp", eq66Im);

InputParameters
eq66Im::validParams()
{
  InputParameters params = ADKernel::validParams();
  params.addClassDescription(
      "Kernel representing Im component of eq66 of bible. Variable is Psi_Re.");
  params.addCoupledVar("Psi_Im",
                       "Imaginary component of Psi");
  params.addCoupledVar("Phi",
                       "Phi");
  params.addParam<MaterialPropertyName>(
      "ucon", "ucon", "u from eq66");
  params.addParam<MaterialPropertyName>(
      "gamma", "gamma", "gamma from eq66");
  return params;
}

eq66Im::eq66Im(const InputParameters & parameters)
  : ADKernel(parameters),
    _Psi_Im(adCoupledValue("Psi_Im")),
    _grad_Psi_Im(adCoupledGradient("Psi_Im")),
    _Psi_dot(adCoupledDot("Psi_Im")),
    _Phi(adCoupledValue("Phi")),
    _grad_Phi(adCoupledGradient("Phi")),
    _ucon(getADMaterialProperty<Real>("ucon")),
    _gamma(getADMaterialProperty<Real>("gamma"))
{
}

ADReal
eq66Im::computeQpResidual()
{

//   double part1 = (_test[_i][_qp] * (-_ucon[_qp] * sqrt(1+ _gamma[_qp] * _gamma[_qp] * (_u[_qp] * _u[_qp] + _Psi_Im[_qp] * _Psi_Im[_qp])) ) * (_Psi_dot[_qp] + _Phi[_qp] * _u[_qp]));

//   double part2 = (_grad_test[_i][_qp] * (- _grad_Psi_Im[_qp]));

//   double part3 = (_grad_test[_i][_qp] * (- _gamma[_qp] * _gamma[_qp] *  _u[_qp] * _grad_Phi[_qp]));

//   double part4 = (_test[_i][_qp] * (1 - _u[_qp] * _u[_qp] - _Psi_Im[_qp] * _Psi_Im[_qp]) * _Psi_Im[_qp]);

  return  (_test[_i][_qp] * (-_ucon[_qp] * sqrt(1+ _gamma[_qp] * _gamma[_qp] * (_u[_qp] * _u[_qp] + _Psi_Im[_qp] * _Psi_Im[_qp])) ) * (_Psi_dot[_qp] + _Phi[_qp] * _u[_qp])) + (_grad_test[_i][_qp] * (- _grad_Psi_Im[_qp])) + (_grad_test[_i][_qp] * (- _gamma[_qp] * _gamma[_qp] *  _u[_qp] * _grad_Phi[_qp])) +  (_test[_i][_qp] * (1 - _u[_qp] * _u[_qp] - _Psi_Im[_qp] * _Psi_Im[_qp]) * _Psi_Im[_qp]);

}