#include "eq66Im_2.h"
#include <cmath>

registerMooseObject("SCResApp", eq66Im_2);

InputParameters
eq66Im_2::validParams()
{
  InputParameters params = ADKernel::validParams();
  params.addClassDescription(
      "Kernel representing Im component of eq66 of bible. Variable is Psi_Re. Spatial variation in material properties.");
  params.addCoupledVar("Psi_Im",
                       "Imaginary component of Psi");
  params.addCoupledVar("Phi",
                       "Phi");
    params.addCoupledVar("Diffuse",
                       "Diffuse");
  params.addParam<MaterialPropertyName>(
      "ucon", "ucon", "u from eq66");
  params.addParam<MaterialPropertyName>(
      "gamma", "gamma", "gamma from eq66");
  return params;
}

eq66Im_2::eq66Im_2(const InputParameters & parameters)
  : ADKernel(parameters),
    _Psi_Im(adCoupledValue("Psi_Im")),
    _grad_Psi_Im(adCoupledGradient("Psi_Im")),
    _Psi_Im_dot(adCoupledDot("Psi_Im")),
    _Phi(adCoupledValue("Phi")),
    _grad_Phi(adCoupledGradient("Phi")),
    _Diffuse(adCoupledValue("Diffuse")),
    _ucon(getADMaterialProperty<Real>("ucon")),
    _gamma(getADMaterialProperty<Real>("gamma"))
{
}

ADReal
eq66Im_2::computeQpResidual()
{

  ADReal part1 = (_test[_i][_qp] * (-_ucon[_qp] * sqrt(1+ _gamma[_qp] * _gamma[_qp] * (_u[_qp] * _u[_qp] + _Psi_Im[_qp] * _Psi_Im[_qp])) ) * (_Psi_Im_dot[_qp] + _Phi[_qp] * _u[_qp]));

  ADReal part2 = (_grad_test[_i][_qp] * (- _grad_Psi_Im[_qp]));

  ADReal part3 = ((_grad_test[_i][_qp] * (- _gamma[_qp] * _gamma[_qp] *  _u[_qp] * _grad_Phi[_qp])) + (_test[_i][_qp]*(- _gamma[_qp] * _gamma[_qp] *_grad_u[_qp] * _grad_Phi[_qp])));

  ADReal   part4 = (_test[_i][_qp] * (_Diffuse[_qp] - _u[_qp] * _u[_qp] - _Psi_Im[_qp] * _Psi_Im[_qp]) * _Psi_Im[_qp]);

  return part1 + part2 + part3 + part4;
}
