#include "eq66Re_Mag.h"
#include <cmath>

registerMooseObject("SCResApp", eq66Re_Mag);

InputParameters
eq66Re_Mag::validParams()
{
  InputParameters params = ADKernelValue::validParams();
  params.addClassDescription(
      "Kernel representing Re component of eq66 of bible. Variable is Psi_Im.");
  params.addCoupledVar("Psi_Re",
                       "Real component of Psi");
  params.addCoupledVar("a_field","Vector potential field");
  params.addParam<MaterialPropertyName>(
      "kappa", "kappa", "kappa");
  return params;
}

eq66Re_Mag::eq66Re_Mag(const InputParameters & parameters)
  : ADKernelValue(parameters),
    _Psi_Re(adCoupledValue("Psi_Re")),
    _a_field(adCoupledVectorValue("a_field")),
    _kappa(getADMaterialProperty<Real>("kappa"))
{
}

ADReal
eq66Re_Mag::precomputeQpResidual()
{

  ADReal part1 = (2 /(_kappa[_qp]*_kappa[_qp]))*_a_field[_qp] * _grad_u[_qp];

    ADReal part2 = (-1 /(_kappa[_qp]*_kappa[_qp]*_kappa[_qp]*_kappa[_qp]))*_Psi_Re[_qp]*_a_field[_qp]*_a_field[_qp];

  return (part1 + part2);
}
