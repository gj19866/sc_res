//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "eq67.h"
#include <cmath>

registerMooseObject("SCResApp", eq67);

InputParameters
eq67::validParams()
{
  InputParameters params = ADKernel::validParams();
  params.addClassDescription(
      "Kernel representing  eq67 of bible. Variable is Psi_Re.");
  params.addCoupledVar("Psi_Im",
                       "Imaginary component of Psi");
  params.addCoupledVar("Phi",
                       "Phi");
  return params;
}

eq67::eq67(const InputParameters & parameters)
  : ADKernel(parameters),
    _Psi_Im(adCoupledValue("Psi_Im")),
    _grad_Psi_Im(adCoupledGradient("Psi_Im")),
    _Phi(adCoupledValue("Phi")),
    _grad_Phi(adCoupledGradient("Phi"))
{
}

ADReal
eq67::computeQpResidual()
{

    // double part1 = (_grad_test[_i][_qp] * (-_grad_Phi[_qp]))
    
    // double part2 = (_grad_test[_i][_qp] * (_u[_qp] * _grad_Psi_Im[_qp]))  
    
    // double part3 = (_grad_test[_i][_qp] * ( - _Psi_Im[_qp] * _grad_u[_qp]))


  return   ((_grad_test[_i][_qp] * (-_grad_Phi[_qp])) + (_grad_test[_i][_qp] * (_u[_qp] * _grad_Psi_Im[_qp]))  +  (_grad_test[_i][_qp] * ( - _Psi_Im[_qp] * _grad_u[_qp])));
  

}