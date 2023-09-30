
#
# Single block thermal input with time derivative term
# https://mooseframework.inl.gov/modules/heat_conduction/tutorials/introduction/therm_step03.html
#

[Mesh]
    [generated]
      type = GeneratedMeshGenerator
      dim = 2
      nx = 20
      ny = 40
      xmax = 10
      ymax = 20
    []
  []
  
  [Variables]
    [Psi_Re]
    []
    [Psi_Im]
    []
    [Phi]
      initial_condition = 0.2
    []
    [j]
      family = LAGRANGE_VEC
    []
  []

  [ICs]
    [Psi_Re]
      type = RandomIC
      variable = Psi_Re
      seed = 158
      min = -1
    []
    [Psi_Im]
      type = RandomIC
      variable = Psi_Im
      seed = 13
      min = -1
    []
  []
  
  [Kernels]
    [eq66Re]
      type = eq66Re
      variable = Psi_Im
      Psi_Re = Psi_Re
      Phi = Phi
      ucon = ucon
      gamma = gamma
    []
    [eq66Im]
      type = eq66Im
      variable = Psi_Re
      Psi_Im = Psi_Im
      Phi = Phi
      ucon = ucon
      gamma = gamma
    []
    [eq67]
      type = eq67
      variable = Phi
      Psi_Im = Psi_Im
      Psi_Re = Psi_Re
    []
    [eq68]
      type = eq68
      variable = j
      Psi_Re = Psi_Re
      Psi_Im = Psi_Im
      Phi = Phi
    []
 []
  
[AuxVariables]
  [Phase]
  []
[]

[AuxKernels]
  [Phase_kern]
    type = ParsedAux
    variable = Phase
    coupled_variables = 'Psi_Im Psi_Re'
    expression = 'atan2(Psi_Im, Psi_Re)'
  []
[]
  [Materials]
    [ucon]
      type = ADGenericConstantMaterial
      prop_names = 'ucon'
      prop_values = '5.78823864'
    []
    [gamma]
      type = ADGenericConstantMaterial
      prop_names = 'gamma'
      prop_values = '6'
    []
  []
  
  [BCs]
    [Psi_Re_y]
      type = ADNeumannBC
      variable = Psi_Re
      boundary = 'top bottom'
    []
    [Psi_Im_y]
      type = ADNeumannBC
      variable = Psi_Im
      boundary = 'top bottom'
    []
    [Phi_y]
      type = ADNeumannBC
      variable = Phi
      boundary = 'top bottom'
    []
    [Periodic]
      [Psi_Re_x]
        variable = Psi_Re
        auto_direction = 'x'
      []
      [Psi_Im_x]
        variable = Psi_Im
        auto_direction = 'x'
      []
      [Phi_x]
        variable = Phi
        auto_direction = 'x'
      []
    []
    # [j_left]
    #   type = VectorDirichletBC
    #   variable = j
    #   values = '1 0 0'
    #   boundary = 'left right'
    # []
    [j_left]
      type = VectorFunctionDirichletBC
      variable = j
      function_x = 'if(t>10, (t-10)*0.1, 0)'
      # function_x = '0.1'
      boundary = 'left right'
    []
  []
  
  [Executioner]
    type = Transient
    end_time = 200
    nl_max_its = 10
    dt= 0.1
    # [TimeStepper]
    #   type = IterationAdaptiveDT
    #   # optimal_iterations = 10
    #   # linear_iteration_ratio = 1
    #   dt = 0.1
    # []
  []

  
  [Outputs]
    exodus = true
    print_linear_residuals = False
  []