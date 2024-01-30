
#
# Single block thermal input with time derivative term
# https://mooseframework.inl.gov/modules/heat_conduction/tutorials/introduction/therm_step03.html
#

csv_path = 'Psi_csv.csv'
# j_b = 0.1
# smooth = 1
# t_step = 30
gamma = 0.0
u = 5.78823864


[Mesh]

    # [generated]
    #     type = FileMeshGenerator
        
    #     file = 'notch.msh'
    #     # file = 'rect.msh'
    #     # file = 'double_notch.msh'
    #     # file = 'scs.msh'
    # []
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
    [Psi_Re]
      # initial_condition = 0
    []
    [Psi_Im]
      # initial_condition = 0
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
        # fuction = 1
    []
    [Psi_Im]
        type = FunctionIC
        variable = Psi_Im
        function = Psi_Im_Func
        # function = 1
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
 []
  
[AuxVariables]
  [Phase]
  []
  [Psi_Mag]
  []
  [total_current]
    family = MONOMIAL_VEC
    order = constant
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
  [total_current]
    type = CurrentAux 
    variable = total_current
    Psi_Re = Psi_Re
    Psi_Im = Psi_Im
    Phi = Phi
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
    #   [Psi_Re_Func]
    #     type = PiecewiseConstantFromCSV
    #     read_prop_user_object = 'reader_node'
    #     read_type = 'node'
    #     column_number = '0'
    #     # execute_on = INITIAL
    # []
    # [Psi_Im_Func]
    #     type = PiecewiseConstantFromCSV
    #     read_prop_user_object = 'reader_node'
    #     read_type = 'node'
    #     column_number = '1'
    # #   execute_on = INITIAL
    # []
    [Psi_Re_right]
        type= ParsedFunction
        value = 'sqrt(0.84)*cos(0.4*20)' #(1-a^2)*cos(a*x)
    []
    [Psi_Im_right]
        type= ParsedFunction
        value = 'sqrt(0.84)*sin(0.4*20)' #(1-a^2)*sin(a*x)
    []
    [Psi_Re_Func]
        type= ParsedFunction
        value = 'sqrt(0.84)*cos(0.4*x)' #(1-a^2)*cos(a*x)
    []
    [Psi_Im_Func]
        type= ParsedFunction
        value = 'sqrt(0.84)*sin(0.4*x)' #(1-a^2)*sin(a*x)
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
[Psi_Re_x_left]
    type = ADDirichletBC
    variable = Psi_Re
    boundary = 'left'
    value = 0.91651513899 # sqrt(1-a^2)*cos(0)
    []
    [Psi_Im_x_left]
    type = ADDirichletBC
    variable = Psi_Im
    boundary = 'left'
    value = 0 # sqrt(1-a^2)*sin(0)
    []

    [Psi_Re_x_right]
    type = ADFunctionDirichletBC
    variable = Psi_Re
    boundary = 'right'
    function = 'Psi_Re_right'
    []
    [Psi_Im_x_right]
    type = ADFunctionDirichletBC
    variable = Psi_Im
    boundary = 'right'
    function = 'Psi_Im_right'
    []
    [Phi]
        type = ADDirichletBC # Could this be Dirichelt/ neumann?
        variable= Phi
        value = 0
        boundary= 'left right'
    []
[]

[Postprocessors]
    [ave_Psi_Mag]
        type= AverageNodalVariableValue
        variable = Psi_Mag
    []
    []

[Executioner]
type = Transient
end_time = 10000
# end_time = 250
nl_max_its = 50
l_max_its = 50
# dt= 2
# automatic_scaling = True 
nl_abs_tol = 1e-9
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
print_nonlinear_residuals = False
[]