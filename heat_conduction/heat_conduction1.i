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
      xmax = 2
      ymax = 1
    []
  []
  
  [Variables]
    [T]
      initial_condition = 300.0
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
      value = 300
      boundary = 'right'
    []
    [t_right]
      type = FunctionDirichletBC
      variable = T
      function = '500'
      boundary = 'left'
    []
  []
  
  [Executioner]
    type = Transient
    end_time = 100
    dt = 1
  []
  
  [VectorPostprocessors]
    [t_sampler]
      type = LineValueSampler
      variable = T
      start_point = '0 0.5 0'
      end_point = '2 0.5 0'
      num_points = 20
      sort_by = x
    []
  []
  
  [Outputs]
    exodus = true
    [csv]
      type = CSV
      file_base = therm_step03_out
      execute_on = final
    []
  []