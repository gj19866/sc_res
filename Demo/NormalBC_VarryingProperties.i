# Normal BC on either side of a rectangular plate
# Material properties vary across the plate with a diffusion parameter
# Make sure the diffusion stop after the first time step!

csv_path = 'Psi_csv.csv'
j_b = 0.1
smooth = 1
t_step = 60
gamma = 0.1
u = 5.78823864


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
    [Psi_Re]
    []
    [Psi_Im]
    []
    [Phi]
      initial_condition = 0
    []
    [Diffuse]
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
    [Diffuse_IC]
      type = RandomIC
      variable = Diffuse
      max = 1.2
      min = 0.8
  []
  []
  
  [Kernels]
    [eq66Re]
      type = eq66Re_2
      variable = Psi_Im
      Psi_Re = Psi_Re
      Phi = Phi
      ucon = ucon
      gamma = gamma
      Diffuse = Diffuse
    []
    [eq66Im]
      type = eq66Im_2
      variable = Psi_Re
      Psi_Im = Psi_Im
      Phi = Phi
      ucon = ucon
      gamma = gamma
      Diffuse = Diffuse
    []
    [eq67]
      type = eq67
      variable = Phi
      Psi_Im = Psi_Im
      Psi_Re = Psi_Re
    []
    [Diffuse_kernel]
        type = FunctionDiffusion
        variable = Diffuse
        function = 'if(t<0.6, 5, 0)'
    []
    [Diffuse_timederive]
        type = TimeDerivative
        variable = Diffuse
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
    [Phi_left]
        type = ParsedFunction
        value = 'if(t<${t_step}*3/2, (${j_b}/(1+exp(-${smooth}*(t-${t_step})))), if(t<${t_step}*( 2+(1/2)), (${j_b}/(1+exp(-${smooth}*(t- 2* ${t_step}))))+(2-1) * ${j_b}, if(t<${t_step}*( 3+(1/2)), (${j_b}/(1+exp(-${smooth}*(t- 3* ${t_step}))))+(3-1) * ${j_b}, if(t<${t_step}*( 4+(1/2)), (${j_b}/(1+exp(-${smooth}*(t- 4* ${t_step}))))+(4-1) * ${j_b}, (${j_b}/(1+exp(-${smooth}*(t- 5* ${t_step}))))+(5-1) * ${j_b} ))))'
      []
    [Phi_right]
        type = ParsedFunction
        value = 'if(t<${t_step}*3/2, -(${j_b}/(1+exp(-${smooth}*(t-${t_step})))), if(t<${t_step}*( 2+(1/2)), -(${j_b}/(1+exp(-${smooth}*(t- 2* ${t_step}))))-(2-1) * ${j_b}, if(t<${t_step}*( 3+(1/2)), -(${j_b}/(1+exp(-${smooth}*(t- 3* ${t_step}))))-(3-1) * ${j_b}, if(t<${t_step}*( 4+(1/2)), -(${j_b}/(1+exp(-${smooth}*(t- 4* ${t_step}))))-(4-1) * ${j_b}, -(${j_b}/(1+exp(-${smooth}*(t- 5* ${t_step}))))+(5-1) * ${j_b} ))))'
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
    
    [Postprocessors]
    [ave_Phi_left_bot]
        type = PointValue
        variable = Phi
        point = '3.0 0.0 0.0'
    []
    [ave_Phi_right_top]
        type = PointValue
        variable = Phi
        point = '17 10.0 0.0'
    []
    [ave_Phi_left_top]
        type = PointValue
        variable = Phi
        point = '3.0 10.0 0.0'
    []
    [ave_Phi_right_bot]
        type = PointValue
        variable = Phi
        point = '17.0 0.0 0.0'
    []
    [Voltage1]
        type = DifferencePostprocessor
        value2 = ave_Phi_left_top
        value1 = ave_Phi_right_bot
    
    []
    [Voltage2]
        type = DifferencePostprocessor
        value2 = ave_Phi_left_bot
        value1 = ave_Phi_right_top
    
    []
    [Current]
        type = FunctionValuePostprocessor
        function = Phi_left
        scale_factor = 1
        []
    [ave_Psi_Mag]
        type= AverageNodalVariableValue
        variable = Psi_Mag
    []
    []
    
    [Executioner]
    type = Transient
    end_time = 500
    nl_max_its = 50
    l_max_its = 50
    # automatic_scaling = True 
    nl_abs_tol = 1e-9
    [TimeStepper]
        type = SolutionTimeAdaptiveDT
        dt = 0.5
        cutback_factor_at_failure = 0.1
        percent_change = 0.1
      []
    
    
    petsc_options_iname = '-snes_linesearch_damping'
    petsc_options_value = '0.5'
    []
    
    [Outputs]
    exodus = true
    print_linear_residuals = False
    print_nonlinear_residuals = False
    []