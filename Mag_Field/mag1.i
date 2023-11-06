
#
# Single block thermal input with time derivative term
# https://mooseframework.inl.gov/modules/heat_conduction/tutorials/introduction/therm_step03.html
#

csv_path = 'Psi_csv.csv'
j_b = 0.1
t_step = 50
gamma = 0.1
u = 5.78823864
kappa = 1
B = 1e-5

[Mesh]

    # [generated]
    #     type = FileMeshGenerator
        
    #     # file = 'notch.msh'
    #     file = 'hole_rect.msh'
    # []
    [generated]
      type = GeneratedMeshGenerator
      dim = 2
      nx = 20
      ny = 5
      xmax = 40
      ymax = 20
    []
  []
  
  [Variables]
    [Psi_Re]
    []
    [Psi_Im]
    []
    [Phi]
      initial_condition = 0
    []
  []

  [ICs]
    [Psi_Re]
        type = FunctionIC
        variable = Psi_Re
        function = Psi_Re_Func
    []
    [Psi_Im]
        type = FunctionIC
        variable = Psi_Im
        function = Psi_Im_Func
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
    [eq66Re_Mag]
      type = eq66Re_Mag
      variable = Psi_Im
      Psi_Re = Psi_Re
      kappa = kappa
      a_field = a_field
      []    
    [eq66Im]
      type = eq66Im
      variable = Psi_Re
      Psi_Im = Psi_Im
      Phi = Phi
      ucon = ucon
      gamma = gamma
    []
    [eq66Im_Mag]
      type = eq66Im_Mag
      variable = Psi_Re
      Psi_Im = Psi_Im
      kappa = kappa
      a_field = a_field
      []    
    [eq67]
      type = eq67
      variable = Phi
      Psi_Im = Psi_Im
      Psi_Re = Psi_Re
    []
    [eq67_Mag]
      type = eq67_Mag
      variable = Phi
      Psi_Im = Psi_Im
      Psi_Re = Psi_Re
      kappa = kappa
      a_field = a_field
    []
 []
  
[AuxVariables]
  [Phase]
  []
  [Psi_Mag]
  []
  [a_field]
    family = LAGRANGE_VEC
    order = FIRST
  []
[]

[AuxKernels]
  [Phase_kern]
    type = ParsedAux
    variable = Phase
    coupled_variables = 'Psi_Im Psi_Re'
    expression = 'atan2(Psi_Im, Psi_Re)'
  []
  [Psi_Mag_kern]
    type = ParsedAux
    variable = Psi_Mag
    coupled_variables = 'Psi_Im Psi_Re'
    expression = 'sqrt(Psi_Im*Psi_Im + Psi_Re*Psi_Re)'
  []
  [a_field_kern]
    type = VectorFunctionAux
    variable = a_field
    function = a_field_func
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[UserObjects]
    [reader_node]
        type = PropertyReadFile
        prop_file_name = ${csv_path}
        read_type = 'node'
        nprop = 2 # number of columns in CSV
    []
[]

[Functions]
      [Psi_Re_Func]
        type = PiecewiseConstantFromCSV
        read_prop_user_object = 'reader_node'
        read_type = 'node'
        column_number = '0'
        # execute_on = INITIAL
    []
    [Psi_Im_Func]
        type = PiecewiseConstantFromCSV
        read_prop_user_object = 'reader_node'
        read_type = 'node'
        column_number = '1'
    #   execute_on = INITIAL
    []
    [Phi_left]
        type = ParsedFunction
        value= 'if(t<${t_step}, 0, (t-50)*${j_b}/50)'
        # value= 'if(t<${t_step}, (50)*${j_b}/50, (t)*${j_b}/50)'
    []
    [Phi_right]
        type = ParsedFunction
        value= 'if(t<${t_step}, 0, -(t-50)*${j_b}/50)'
        #  value= 'if(t<${t_step}, (-50)*${j_b}/50, -(t)*${j_b}/50)'
    []
    [a_field_func]
      type = ParsedVectorFunction
      # expression_x = y*${B}*(1/(1+exp(100-t)))
      expression_y = -x*${B}*(1/(1+exp(100-t)))
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
[kappa]
  type = ADGenericConstantMaterial
  prop_names = 'kappa'
  prop_values = ${kappa}
[]
[]

[BCs]
[Psi_Re_y]
    type = ADNeumannBC
    variable = Psi_Re
    boundary = 'top bottom '
[]
[Psi_Im_y]
    type = ADNeumannBC
    variable = Psi_Im
    boundary = 'top bottom '
[]
[Phi_y]
    type = ADNeumannBC
    variable = Phi
    boundary = 'top bottom '
[]
[Psi_Re_x]
    type = ADDirichletBC
    variable = Psi_Re
    boundary = 'left right'
    value = 0
    []
    [Psi_Im_x]
    type = ADDirichletBC
    variable = Psi_Im
    boundary = 'left right'
    value = 0
    []
    [Phi_x_left]
    type = FunctionNeumannBC
    variable = Phi
    boundary = 'left'
    function = 'Phi_left'
    []
    [Phi_x_right]
    type = FunctionNeumannBC
    variable = Phi
    boundary = 'right'
    function = 'Phi_right'
    []
[]

# [Postprocessors]
# [ave_Phi_left_bot]
#     type = PointValue
#     variable = Phi
#     point = '3.0 0.0 0.0'
# []
# [ave_Phi_right_top]
#     type = PointValue
#     variable = Phi
#     point = '37.0 10.0 0.0'
# []
# [ave_Phi_left_top]
#     type = PointValue
#     variable = Phi
#     point = '3.0 10.0 0.0'
# []
# [ave_Phi_right_bot]
#     type = PointValue
#     variable = Phi
#     point = '37.0 0.0 0.0'
# []
# [Voltage1]
#     type = DifferencePostprocessor
#     value2 = ave_Phi_left_top
#     value1 = ave_Phi_right_bot

# []
# [Voltage2]
#     type = DifferencePostprocessor
#     value2 = ave_Phi_left_bot
#     value1 = ave_Phi_right_top

# []
# [Current]
#     type = FunctionValuePostprocessor
#     function = Phi_left
#     scale_factor = 34
#     []
# [ave_Psi_Mag]
#     type= AverageNodalVariableValue
#     variable = Psi_Mag
# []
# []

[Executioner]
type = Transient
end_time = 400
# end_time = 250
nl_max_its = 200
l_max_its = 50
# dt= 2
automatic_scaling = True 
# nl_abs_tol = 1e-9
[TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = 0.5
    cutback_factor_at_failure = 0.1
    percent_change = 0.1

    # dtmax = 5
  []
# line_search = 'none'

petsc_options_iname = '-snes_linesearch_damping'
petsc_options_value = '0.5'
[]

# [Debug]
# show_var_residual_norms = true
# []

[Outputs]
exodus = true
print_linear_residuals = False
print_nonlinear_residuals = True
[]