#include "Time_eq66Im_MagArg_Magnetic.h"
#include <cmath>

registerMooseObject("SCResApp", Time_eq66Im_MagArg_Magnetic);

InputParameters
Time_eq66Im_MagArg_Magnetic::validParams()
{
  InputParameters params = ADTimeKernel::validParams();
  params.addClassDescription(
      "Kernel representing Im component of eq66 of bible in Mag Arg form with time deriv. Variable is Phase.");
  params.addCoupledVar("Psi_Mag",
                       "Mag component of Psi");
  params.addCoupledVar("Phi",
                       "Phi");
    params.addCoupledVar("Diffuse",
                       "Diffuse");
    params.addCoupledVar("A_field","Vector potential field");
  params.addParam<MaterialPropertyName>(
      "ucon", "ucon", "u from eq66");
  params.addParam<MaterialPropertyName>(
      "gamma", "gamma", "gamma from eq66");
  return params;
}

Time_eq66Im_MagArg_Magnetic::Time_eq66Im_MagArg_Magnetic(const InputParameters & parameters)
  : ADTimeKernel(parameters),
    _Psi_Mag(adCoupledValue("Psi_Mag")),
    _grad_Psi_Mag(adCoupledGradient("Psi_Mag")),
    _Phi(adCoupledValue("Phi")),
    _grad_Phi(adCoupledGradient("Phi")),
    _Diffuse(adCoupledValue("Diffuse")),
      _A_field(adCoupledVectorValue("A_field")),
    _ucon(getADMaterialProperty<Real>("ucon")),
    _gamma(getADMaterialProperty<Real>("gamma"))
{
}

ADReal
Time_eq66Im_MagArg_Magnetic::computeQpResidual()
{

  ADReal part1 = _test[_i][_qp] * (-1 * _ucon[_qp]* sqrt(1+_gamma[_qp]*_gamma[_qp]*_Psi_Mag[_qp]*_Psi_Mag[_qp])*(_u_dot[_qp] + _Phi[_qp])*_Psi_Mag[_qp]);

  ADReal part2 = _grad_test[_i][_qp] * (-1 * _Psi_Mag[_qp] * _grad_u[_qp]);

  ADReal part3 = _test[_i][_qp] * (_grad_u[_qp]*_grad_Psi_Mag[_qp]);

  ADReal part4 = _grad_test[_i][_qp] * (-1 *  _gamma[_qp]*_gamma[_qp]*_Psi_Mag[_qp]*_grad_Phi[_qp]);

  ADReal part5 = _test[_i][_qp] * (-1 *  _gamma[_qp]*_gamma[_qp]*_grad_Psi_Mag[_qp]*_grad_Phi[_qp]);

  ADReal MagPart = _test[_i][_qp] * ( -2 * _A_field[_qp]* _grad_Psi_Mag[_qp]);

  ADReal total = part1 + part2 + part3 + part4 + part5 + MagPart;

  return total;

}
