# First test of Mag Arg form

gamma = 0.1
u = 5.78823864
j_b = 0.0000

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
    [arcPhase]
    []
    [Phi]
      initial_condition = 0
    []
    [Diffuse]
        initial_condition = 1
      []
  []

  [ICs]
    [arcPhase]
        type = FunctionIC
        variable = arcPhase
        function = arcPhase_Func
    []
  []
  
  [Kernels]
    [eq66Re_MagArg]
      type = eq66Re_MagArg2
      variable = arcPhase
      Psi_Mag = Psi_Mag
      Phi = Phi
      ucon = ucon
      gamma = gamma
      Diffuse = Diffuse
    []
    [eq66Im_MagArg]
      type = eq66Im_MagArg2
      variable = Psi_Mag
      arcPhase = arcPhase
      Phi = Phi
      ucon = ucon
      gamma = gamma
      Diffuse = Diffuse
    []
    [eq67_MagArg]
      type = eq67_MagArg2
      variable = Phi
      arcPhase = arcPhase
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
    [arcPhase_Func]
        type = ParsedFunction
        # value = ${j_b}*x
        value = 0
    []
    [arcPhase_BC_value_left]
      type = ParsedFunction
      value = '${j_b}*t'
  []
  [arcPhase_BC_value_right]
    type = ParsedFunction
    value = '${j_b}*t'
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
    [arcPhase_x_left]
        type = ADFunctionNeumannBC
        variable = arcPhase
        boundary = 'left '
        function = arcPhase_BC_value_left
        []
    [arcPhase_x_right]
        type = ADFunctionNeumannBC
        variable = arcPhase
        boundary = ' right'
        function = arcPhase_BC_value_right
        []
        [arcPhase_y]
          type = ADNeumannBC
          variable = arcPhase
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
    boundary = 'top bottom left right'
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