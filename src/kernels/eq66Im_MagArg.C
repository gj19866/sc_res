#include "eq66Im_MagArg.h"
#include <cmath>

registerMooseObject("SCResApp", eq66Im_MagArg);

InputParameters
eq66Im_MagArg::validParams()
{
  InputParameters params = ADKernel::validParams();
  params.addClassDescription(
      "Kernel representing Im component of eq66 of bible in Mag Arg form. Variable is Psi_Mag.");
  params.addCoupledVar("Phase",
                       "Phase component of Psi");
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

eq66Im_MagArg::eq66Im_MagArg(const InputParameters & parameters)
  : ADKernel(parameters),
    _Phase(adCoupledValue("Phase")),
    _grad_Phase(adCoupledGradient("Phase")),
    _Phase_dot(adCoupledDot("Phase")),
    _Phi(adCoupledValue("Phi")),
    _grad_Phi(adCoupledGradient("Phi")),
    _Diffuse(adCoupledValue("Diffuse")),
    _ucon(getADMaterialProperty<Real>("ucon")),
    _gamma(getADMaterialProperty<Real>("gamma"))
{
}

ADReal
eq66Im_MagArg::computeQpResidual()
{

  ADReal part1 = (_test[_i][_qp] * (-_ucon[_qp] * sqrt(1+ _gamma[_qp] * _gamma[_qp] * (_u[_qp] * _u[_qp] )) ) * (_Phase_dot[_qp] + _Phi[_qp])*_u[_qp]);

  ADReal part2 = (_grad_test[_i][_qp] * (- _u[_qp]*_grad_Phase[_qp]));

   ADReal part3 = (_test[_i][_qp] * ( _grad_u[_qp]*_grad_Phase[_qp]));

  ADReal part4 = ((_grad_test[_i][_qp] * (- _gamma[_qp] * _gamma[_qp] *  _u[_qp] * _grad_Phi[_qp]))) ;

  ADReal   part5 = (_test[_i][_qp] * (- _gamma[_qp] * _gamma[_qp] *  _grad_u[_qp] * _grad_Phi[_qp]));

  return part1 + part2 + part3 + part4 + part5;
}
