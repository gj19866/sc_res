// #include "SuperBC2.h"
// #include <cmath>


// registerMooseObject("SCResApp", SuperBC2);

// InputParameters
// SuperBC2::validParams()
// {
//   InputParameters params = ADDirichletBCBase::validParams();

//   // Specify input parameters that we want users to be able to set:
//   params.addParam<Real>("psi_MAG", 1, "Mag of Psi on the boundary");
//   params.addRequiredCoupledVar("Psi_Im", "Value on the boundary");
//   return params;
// }

// SuperBC2::SuperBC2(const InputParameters & parameters)
//   : ADDirichletBCBase(parameters),
//     // store the user-specified parameters from the input file...
//     _psi_MAG(getParam<Real>("psi_MAG")),        // for the multiplier
//     _Psi_Im(adCoupledValue("Psi_Im")) // for the coupled variable
// {
// }

// ADReal
// SuperBC2::computeQpResidual()
// {
//   // For dirichlet BCS, u=BC at the boundary, so the residual includes _u and the desired BC value:

//   return _u[_qp]*_u[_qp] + _Psi_Im[_qp]*_Psi_Im[_qp] - (_psi_MAG);
// // return std::sqrt((_psi_MAG) - (_Psi_Im[_qp]*_Psi_Im[_qp]));

// }