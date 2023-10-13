
#
# Single block thermal input with time derivative term
# https://mooseframework.inl.gov/modules/heat_conduction/tutorials/introduction/therm_step03.html
#

csv_path = 'Psi_csv.csv'


[Mesh]
    [generated]
      type = GeneratedMeshGenerator
      dim = 2
      nx = 16
      ny = 128
      xmax = 8
      ymax = 64
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
    [j]
      family = LAGRANGE_VEC
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
  [Psi_Mag]
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
      prop_values = '0.1'
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
      # [j_periodic]
      #   variable = j
      #   auto_direction = 'x'
      # []
    []

    # [j_left]
    #   type = VectorFunctionDirichletBC
    #   variable = j
    #   function_x = '0.15'
    #   boundary = 'left'
    # []
    # [j_right]
    #   type = VectorFunctionDirichletBC
    #   variable = j
    #   function_x = '-0.15'
    #   boundary = 'right'
    # []
    [j_top]
      type = VectorFunctionDirichletBC
      variable = j
      # function_x = 'if(t>10, (t-10)*0.01, 0)'
      # function_y = 'if(t>16, 250, if(t>14, 50, if(t>12, 10, if(t>10, 2.5, if(t>8, 2, if(t>6, 0.5, if(t>4, 1, if(t>2, 0.15, 0))))))))'
      function_y = 'if(t>5, 0.6, 0)'
      boundary = 'top'
    []
    [j_bottom]
      type = VectorFunctionDirichletBC
      variable = j
      function_y = 'if(t>5, -0.6, 0)'
      boundary = 'bottom'
    []
  []
  
  [Executioner]
    type = Transient
    end_time = 2000
    nl_max_its = 200
    # l_max_its = 10
    dt= 2
    automatic_scaling = True 
    # [TimeStepper]
    #   type = IterationAdaptiveDT
    #   # optimal_iterations = 10
    #   # linear_iteration_ratio = 1
    #   dt = 0.01
    #   growth_factor= 1.2
    # #   maxdt = 1
    # []
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
  []