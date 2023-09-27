//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "eq68.h"

registerMooseObject("SCResApp", eq68);

InputParameters
eq68::validParams()
{
  InputParameters params = ADVectorKernelValue::validParams();
  params.addClassDescription("Variable is current denisty j from eq68. j is a vector. ");
  params.addCoupledVar("Psi_Re",
                       "Real component of Psi");
  params.addCoupledVar("Psi_Im",
                       "Imaginary component of Psi");
  params.addCoupledVar("Phi",
                       "Phi");
  return params;
}

eq68::eq68(const InputParameters & parameters)
  : ADVectorKernelValue(parameters),
    _Psi_Re(adCoupledValue("Psi_Re")),
    _grad_Psi_Re(adCoupledGradient("Psi_Re")),
    _Psi_Im(adCoupledValue("Psi_Im")),
    _grad_Psi_Im(adCoupledGradient("Psi_Im")),
    _Phi(adCoupledValue("Phi")),
    _grad_Phi(adCoupledGradient("Phi"))
{
}

ADRealVectorValue
eq68::precomputeQpResidual()
{
  
 return   (((_u[_qp]) + (_grad_Phi[_qp]) - (_Psi_Re[_qp] * _grad_Psi_Im[_qp]) + (_Psi_Im[_qp] * _grad_Psi_Re[_qp])) ); 

}

