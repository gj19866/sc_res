#pragma once

#include "ADDirichletBCBase.h"

/// Implements a coupled Dirichlet BC where u = alpha * some_var on the boundary.
class SuperBC2 : public ADDirichletBCBase
{
public:
  SuperBC2(const InputParameters & parameters);

  static InputParameters validParams();

protected:
  virtual ADReal computeQpValue() override;

private:
  /// Multiplier on the boundary.
  Real _psi_MAG;
  /// reference to a user-specifiable coupled (independent) variable
  const ADVariableValue & _Psi_Im;
};