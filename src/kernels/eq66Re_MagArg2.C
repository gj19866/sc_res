
#include "eq66Re_MagArg2.h"
#include <cmath>

registerMooseObject("SCResApp", eq66Re_MagArg2);

InputParameters
eq66Re_MagArg2::validParams()
{
  InputParameters params = ADKernel::validParams();
  params.addClassDescription(
      "Kernel representing real component of eq66 of bible in Mag Arg form. Variable is Phase.");
  params.addRequiredCoupledVar("Psi_Mag","Mag component of Psi");
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

eq66Re_MagArg2::eq66Re_MagArg2(const InputParameters & parameters)
  : ADKernel(parameters),
    _Psi_Mag(adCoupledValue("Psi_Mag")),
    _grad_Psi_Mag(adCoupledGradient("Psi_Mag")),
    _Psi_Mag_dot(adCoupledDot("Psi_Mag")), 
    _Phi(adCoupledValue("Phi")),
    _grad_Phi(adCoupledGradient("Phi")),
    _Diffuse(adCoupledValue("Diffuse")),
    _ucon(getADMaterialProperty<Real>("ucon")),
    _gamma(getADMaterialProperty<Real>("gamma"))
{
}

ADReal
eq66Re_MagArg2::computeQpResidual()
{

  ADReal part1 = (_test[_i][_qp] * (-_ucon[_qp] * sqrt(1+ _gamma[_qp] * _gamma[_qp] * (_Psi_Mag[_qp]*_Psi_Mag[_qp])) ) * (_Psi_Mag_dot[_qp] ));

  ADReal part2 = (_grad_test[_i][_qp] * (- _grad_Psi_Mag[_qp]));

  ADReal part3 = (_test[_i][_qp] * (_Diffuse[_qp] - (_Psi_Mag[_qp] * _Psi_Mag[_qp]) - ((_grad_u[_qp]/(1+_u[_qp]*_u[_qp])) *(_grad_u[_qp]/(1+_u[_qp]*_u[_qp])))) * _Psi_Mag[_qp]);


  return part1 + part2 + part3;

}