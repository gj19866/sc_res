

#include "AuxNormal.h"
#include "Assembly.h"

registerMooseObject("SCResApp", AuxNormal);

InputParameters
AuxNormal::validParams()
{
  InputParameters params = AuxKernel::validParams();
  params.addCoupledVar("A_field","Vector potential field");
  params.addClassDescription("Compute components of normal of vector");

  return params;
}

AuxNormal::AuxNormal(const InputParameters & parameters)
  : AuxKernel(parameters),
    _normals(_assembly.normals()),
        _A_field(coupledVectorValue("A_field"))
{

}

Real
AuxNormal::computeValue()
{
    return _A_field[_qp] * _normals[_qp];
}