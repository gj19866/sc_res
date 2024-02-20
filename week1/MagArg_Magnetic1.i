# First test of Mag Arg form

gamma = 2
u = 5.78823864
# j_b = 0.001
B = 0.01


[Mesh]
    [generated]
      type = GeneratedMeshGenerator
      dim = 2
      nx = 40
      ny = 10
      xmax = 40
      ymax = 10
    []
  []
  
  [Variables]
    [Psi_Mag]
        initial_condition = 1
    []
    [Phase]
    []
    [Phi]
      initial_condition = 0
    []
    [Diffuse]
      initial_condition = 1
      []
  []

  [ICs]
    [Phase]
        type = FunctionIC
        variable = Phase
        function = Phase_Func
    []
#     [Diffuse_IC]
#       type = RandomIC
#       variable = Diffuse
#       max = 1.8
#       min = 0.2
#   []
  []
  
  [Kernels]
    [eq66Re_MagArg]
      type = Time_eq66Re_MagArg_Magnetic
      variable = Psi_Mag
      Phase = Phase
      ucon = ucon
      gamma = gamma
      Diffuse = Diffuse
      A_field = A_field
    []
    [eq66Im_MagArg]
      type = Time_eq66Im_MagArg_Magnetic
      variable = Phase
      Psi_Mag = Psi_Mag 
      Phi = Phi
      ucon = ucon
      gamma = gamma
      Diffuse = Diffuse
      A_field = A_field
    []
    [eq67_MagArg]
      type = eq67_MagArg_Magnetic
      variable = Phi
      Phase = Phase
      Psi_Mag = Psi_Mag
      A_field = A_field
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

    [A_field]
        family = LAGRANGE_VEC
        order = FIRST
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
  [A_field_kern]
    type = VectorFunctionAux
    variable = A_field
    function = A_field_func
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[Functions]
    [Phase_Func]
        type = ParsedFunction
        # value = ${j_b}*x
        value = 0
    []
    [Phase_BC_value_left]
      type = ParsedFunction
      # value = '${j_b}*t'
      value = 0
  []
  [Phase_BC_value_right]
    type = ParsedFunction
    # value = '-${j_b}*t'
    value = 0
[]
[Phi_BC_value_left]
  type = ParsedFunction
#   value = '${j_b}*t + 0.3'
  value = 0
[]
[Phi_BC_value_right]
  type = ParsedFunction
#   value = '-${j_b}*t - 0.3'
  value = 0
[]
[A_field_func]
    type = ParsedVectorFunction
    # expression_x = y*${B}*(1/(1+exp(100-t)))
    expression_y = '-x*${B}'
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
        type = ADFunctionNeumannBC
        variable = Phi
        boundary = 'left '
        function = Phi_BC_value_left
        []
    [Phi_x_right]
        type = ADFunctionNeumannBC
        variable = Phi
        boundary = ' right'
        function = Phi_BC_value_right
        []

        [Phase_x_left]
          type = ADFunctionNeumannBC
          variable = Phase
          boundary = 'left '
          function = Phase_BC_value_left
          []
      [Phase_x_right]
          type = ADFunctionNeumannBC
          variable = Phase
          boundary = ' right'
          function = Phase_BC_value_right
          []      
        [Phase_y]
          type = ADNeumannBC
          variable = Phase
          boundary = 'top bottom'
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
  value = 1
 []

[Phi]
    type = ADNeumannBC
    variable = Phi
    boundary = 'top bottom'
[]
# [Phi_left]
#   type = ADDirichletBC
#   variable = Phi
#   boundary = 'left right'
#   value = 0.0
# []
# [Phi_right]
#   type = ADNeumannBC
#   variable = Phi
#   boundary = 'left right'
#   value = 0.0
# []
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

[Debug]
show_var_residual_norms = true
[]

[Outputs]
exodus = true
print_linear_residuals = False
print_nonlinear_residuals = True
[]