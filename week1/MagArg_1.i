# First test of Mag Arg form

gamma = 0.1
u = 5.78823864
j_b = 0.01

[Mesh]
    [generated]
      type = GeneratedMeshGenerator
      dim = 2
      nx = 20
      ny = 20
      xmax = 10
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
  []
  
  [Kernels]
    [eq66Re_MagArg]
      type = eq66Re_MagArg
      variable = Phase
      Psi_Mag = Psi_Mag
      Phi = Phi
      ucon = ucon
      gamma = gamma
      Diffuse = Diffuse
    []
    [eq66Im_MagArg]
      type = eq66Im_MagArg
      variable = Psi_Mag
      Phase = Phase
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
        function = '0'
    []
    [Diffuse_timederive]
        type = TimeDerivative
        variable = Diffuse
    []
 []



[Functions]
    [Phase_Func]
        type = ParsedFunction
        value = ${j_b}*x
        # value = 0
    []
    [Phase_BC_value_left]
      type = ParsedFunction
      # value = '${j_b}'
      value = 0
  []
  [Phase_BC_value_right]
    type = ParsedFunction
    # value = '-${j_b}'
    value = 0
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
    boundary = 'top bottom left right'
[]

# [Psi_Mag_x]
#   type = ADDirichletBC
#   variable = Psi_Mag
#   boundary = 'left right'
#   value = 1

#  []

[Phi]
    type = ADNeumannBC
    variable = Phi
    boundary = 'top bottom'
[]
[Phi_left]
  type = ADNeumannBC
  variable = Phi
  boundary = 'left'
  value = 0.0
[]
[Phi_right]
  type = ADNeumannBC
  variable = Phi
  boundary = 'right'
  value = -0.0
[]
[]

[Executioner]
type = Transient
end_time = 400
nl_max_its = 50
# l_max_its = 10
dt= 2
automatic_scaling = True 
nl_abs_tol = 1e-9
# [TimeStepper]
#     type = SolutionTimeAdaptiveDT
#     dt = 2
#     cutback_factor_at_failure = 0.1
#     percent_change = 0.5
#   []
# # line_search = 'none'

petsc_options_iname = '-snes_linesearch_damping'
petsc_options_value = '0.5'
[]

[Debug]
show_var_residual_norms = true
[]

[Outputs]
exodus = true
print_linear_residuals = True
print_nonlinear_residuals = True
[]