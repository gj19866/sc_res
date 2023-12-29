#include "SuperBCInt.h"

registerMooseObject("SCResApp", SuperBCInt);

InputParameters
SuperBCInt::validParams()
{
  InputParameters params = ADIntegratedBC::validParams();

  // Specify input parameters that we want users to be able to set:
  params.addParam<Real>("psi_MAG", 1, "Mag of Psi on the boundary");
  params.addRequiredCoupledVar("Psi_Im", "Value on the boundary");
  return params;
}

SuperBCInt::SuperBCInt(const InputParameters & parameters)
  : ADIntegratedBC(parameters),
    // store the user-specified parameters from the input file...
    _psi_MAG(getParam<Real>("psi_MAG")),        // for the multiplier
    _Psi_Im(adCoupledValue("Psi_Im")) // for the coupled variable
{
}

ADReal
SuperBCInt::computeQpResidual()
{
  // For dirichlet BCS, u=BC at the boundary, so the residual includes _u and the desired BC value:
//   auto u_value = _u;
//   return _u[_qp]*_u[_qp] + _Psi_Im[_qp]*_Psi_Im[_qp] - (_psi_MAG);
return _test[_i][_qp]*(_u[_qp]*_u[_qp]  + _Psi_Im[_qp]*_Psi_Im[_qp] - (_psi_MAG));
}