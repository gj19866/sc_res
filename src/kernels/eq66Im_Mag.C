#include "eq66Im_Mag.h"
#include <cmath>

registerMooseObject("SCResApp", eq66Im_Mag);

InputParameters
eq66Im_Mag::validParams()
{
  InputParameters params = ADKernelValue::validParams();
  params.addClassDescription(
      "Kernel representing Im component of eq66 of bible. Variable is Psi_Re.");
  params.addCoupledVar("Psi_Im",
                       "Imaginary component of Psi");
  params.addCoupledVar("a_field","Vector potential field");
  params.addParam<MaterialPropertyName>(
      "kappa", "kappa", "kappa");
  return params;
}

eq66Im_Mag::eq66Im_Mag(const InputParameters & parameters)
  : ADKernelValue(parameters),
    _Psi_Im(adCoupledValue("Psi_Im")),
    _a_field(adCoupledVectorValue("a_field")),
    _kappa(getADMaterialProperty<Real>("kappa"))
{
}

ADReal
eq66Im_Mag::precomputeQpResidual()
{

  ADReal part1 = (-2 /(_kappa[_qp]*_kappa[_qp]))*_a_field[_qp] * _grad_u[_qp];

    ADReal part2 = (-1 /(_kappa[_qp]*_kappa[_qp]*_kappa[_qp]*_kappa[_qp]))*_Psi_Im[_qp]*_a_field[_qp]*_a_field[_qp];

  return (part1 + part2);
}
