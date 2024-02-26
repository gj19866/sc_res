#pragma once

#include "AuxKernel.h"

/**
 * Auxiliary kernel responsible for computing a component of the advection flux vector
 */
class AuxNormal : public AuxKernel
{
public:
  static InputParameters validParams();

  AuxNormal(const InputParameters & parameters);

protected:
  virtual Real computeValue();
  const MooseArray<Point> & _normals;

private:
  const VectorVariableValue & _A_field;


};