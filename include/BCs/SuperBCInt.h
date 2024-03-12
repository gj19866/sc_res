#pragma once

#include "ADIntegratedBC.h"

/// Implements a coupled Dirichlet BC where u = alpha * some_var on the boundary.
class SuperBCInt : public ADIntegratedBC
{
public:
  SuperBCInt(const InputParameters & parameters);

  static InputParameters validParams();

protected:
  virtual ADReal computeQpResidual() override;

  /// Multiplier on the boundary.
  Real _psi_MAG;
  /// reference to a user-specifiable coupled (independent) variable
  const ADVariableValue & _Psi_Im;
};