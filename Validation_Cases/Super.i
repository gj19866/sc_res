# Superconducting boundaries
# Uses Mag Arg form instead of real and imagainary when considering Psi
# Varying material properties

gamma = 2
u = 5.78823864
# j_b = 0.001

[Mesh]
  [generated]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 20
    ny = 10
    xmax = 20
    ymax = 10
  []
[]
  
[Variables]
  [Psi_Mag]
      initial_condition = 0.916515139
  []
  [Phase]
    # initial_condition = 0
  []
  [Phi]
    initial_condition = 0
  []
  [Diffuse]
    initial_condition = 1
    []
[]


  
[Kernels]
  [eq66Re_MagArg]
    type = Time_eq66Re_MagArg
    variable = Psi_Mag
    Phase = Phase
    ucon = ucon
    gamma = gamma
    Diffuse = Diffuse
  []
  [eq66Im_MagArg]
    type = Time_eq66Im_MagArg
    variable = Phase
    Psi_Mag = Psi_Mag 
    Phi = Phi
    ucon = ucon
    gamma = gamma
    Diffuse = Diffuse
  []
  [eq67_MagArg]
    type = eq67_MagArg
    variable = Phi
    Phase = Phase
    Psi_Mag = Psi_Mag
  []
  [Diffuse_kernel]
      type = FunctionDiffusion
      variable = Diffuse
      function = 'if(t<2.1, 1, 0)'
  []
  [Diffuse_timederive]
      type = TimeDerivative
      variable = Diffuse
  []
[]

 [AuxVariables]
  [total_current]
    family = MONOMIAL_VEC
    order = constant
    []
  []

[AuxKernels]
  [total_current]
    type = CurrentAux_MagArg
    variable = total_current
    Psi_Mag = Psi_Mag
    Phase =Phase
    Phi = Phi
  []  
[]

[ICs]
  [phase]
    type = FunctionIC
    variable = Phase
    function = Phase_Func
  []
[]

[Functions]
  [Phi_BC_value_left]
    type = ParsedFunction
    value = 0
  []
  [Phi_BC_value_right]
    type = ParsedFunction
    value = 0
  []

  [Phase_Func]
    type = ParsedFunction
    value = '0.4*x'
  []


[]

[Materials]
  [ucon]
      type = ADGenericConstantMaterial
      prop_names = 'ucon'
      prop_values = ${u}
  []
  [gamma]
      type = ADGenericConstantMaterial
      prop_names = 'gamma'
      prop_values = ${gamma}
  []
[]

[BCs]
  [Phi_x_left]
    type = ADDirichletBC
    variable = Phi
    boundary = 'left right'
    value = 0
  []
  [Phi_y]
    type = ADNeumannBC
    variable = Phi
    boundary = 'top bottom'
  []
  [Phase]
    type = ADNeumannBC
    variable = Phase
    boundary = 'top bottom'
  []
[Phase_left]
  type = ADDirichletBC
  variable = Phase
  value = 0
  boundary = 'left'
[]
[Phase_right]
  type = ADDirichletBC
  variable = Phase
  value = 8
  boundary = 'right'
[]

  [Psi_Mag_y]
      type = ADNeumannBC
      variable = Psi_Mag
      boundary = 'top bottom'
  []
  [Psi_Mag_x]
    type = ADDirichletBC
    variable = Psi_Mag
    boundary = 'left right'
    value = 0.916515139
  []
[]

[Executioner]
  type = Transient
  end_time = 500
  nl_max_its = 50
  l_max_its = 50
  # dt= 2
  automatic_scaling = True 
  nl_abs_tol = 1e-9
  [TimeStepper]
      type = SolutionTimeAdaptiveDT
      dt = 2
      cutback_factor_at_failure = 0.1
      percent_change = 0.5
    []
  # # line_search = 'none'

  petsc_options_iname = '-snes_linesearch_damping'
  petsc_options_value = '0.5'
[]

[Outputs]
exodus = true
print_linear_residuals = False
print_nonlinear_residuals = True
[]