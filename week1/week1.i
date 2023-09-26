
#
# Single block thermal input with time derivative term
# https://mooseframework.inl.gov/modules/heat_conduction/tutorials/introduction/therm_step03.html
#

[Mesh]
    [generated]
      type = GeneratedMeshGenerator
      dim = 2
      nx = 10
      ny = 10
      xmax = 1
      ymax = 1
    []
  []
  
  [Variables]
    [T]
      initial_condition = 0.0
    []
  []
  
  [Kernels]
    [heat_conduction]
      type = HeatConduction
      variable = T
    []
    [time_derivative]
      type = HeatConductionTimeDerivative
      variable = T
    []
  []
  
  [Materials]
    [thermal]
      type = HeatConductionMaterial
      thermal_conductivity = 45.0
      specific_heat = 0.5
    []
    [density]
      type = GenericConstantMaterial
      prop_names = 'density'
      prop_values = 8000.0
    []
  []
  
  [BCs]
    [t_left]
      type = DirichletBC
      variable = T
      value = 100
      boundary = 'left'
    []
    [t_right]
        type = DirichletBC
      value = 100
      variable = T
      boundary = 'right'
    []
  []
  
  [Executioner]
    type = Transient
    end_time = 40
    dt = 0.1
  []

  
  [Outputs]
    exodus = true
  []