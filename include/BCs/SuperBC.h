#pragma once

#include "ADNodalBC.h"

/// Implements a coupled Dirichlet BC where u = alpha * some_var on the boundary.
class SuperBC : public ADNodalBC
{
public:
  SuperBC(const InputParameters & parameters);

  static InputParameters validParams();

protected:
  virtual ADReal computeQpResidual() override;

private:
  /// Multiplier on the boundary.
  Real _psi_MAG;
  /// reference to a user-specifiable coupled (independent) variable
  const ADVariableValue & _Psi_Im;
};