
#include "Time_eq66Re_MagArg.h"
#include <cmath>

registerMooseObject("SCResApp", Time_eq66Re_MagArg);

InputParameters
Time_eq66Re_MagArg::validParams()
{
  InputParameters params = ADTimeKernel::validParams();
  params.addClassDescription(
      "Kernel representing real component of eq66 of bible in Mag Arg form using time derivative approch. Variable is Psi_Mag");
  params.addRequiredCoupledVar("Phase","Phase component of Psi");
params.addCoupledVar("Diffuse",
                       "Diffuse");
  params.addParam<MaterialPropertyName>(
      "ucon", "ucon", "u from eq66");
  params.addParam<MaterialPropertyName>(
      "gamma", "gamma", "gamma from eq66");
  return params;
}

Time_eq66Re_MagArg::Time_eq66Re_MagArg(const InputParameters & parameters)
  : ADTimeKernel(parameters),
    _grad_Phase(adCoupledGradient("Phase")),
    _Diffuse(adCoupledValue("Diffuse")),
    _ucon(getADMaterialProperty<Real>("ucon")),
    _gamma(getADMaterialProperty<Real>("gamma"))
{
}

ADReal
Time_eq66Re_MagArg::computeQpResidual()
{
ADReal part1 = _test[_i][_qp]*(-1 * _ucon[_qp]* sqrt(1+_gamma[_qp]*_gamma[_qp]*_u[_qp]*_u[_qp]) * _u_dot[_qp] );

ADReal part2 = _grad_test[_i][_qp] * (-1 * _grad_u[_qp]);

ADReal part3 = _test[_i][_qp]*( (_Diffuse[_qp]-_u[_qp]*_u[_qp] - _grad_Phase[_qp]*_grad_Phase[_qp] )* _u[_qp]);

ADReal total = part1 + part2 + part3;

return total;
}