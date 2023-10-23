
#
# Single block thermal input with time derivative term
# https://mooseframework.inl.gov/modules/heat_conduction/tutorials/introduction/therm_step03.html
#

csv_path = 'Psi_csv.csv'
# j_b = 0.1
t_step = 50
gamma = 0.1
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
      nx = 60
      ny = 60
      xmax = 60
      ymax = 60
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
        # value= 'if(t<${t_step}, 0, (t-50)*${j_b}/50)'
        # value= 'if(t<${t_step}, (50)*${j_b}/50, (0.01*t)*${j_b}/50)'
        value = 'if(t<0.3*${t_step}, 0.3, if(t<0.301*${t_step}, 0.301, if(t<0.302*${t_step}, 0.302, if(t<0.303*${t_step}, 0.303, if(t<0.304*${t_step}, 0.304, if(t<0.305*${t_step}, 0.305, if(t<0.306*${t_step}, 0.306, if(t<0.307*${t_step}, 0.307, if(t<0.308*${t_step}, 0.308, if(t<0.309*${t_step}, 0.309, if(t<0.31*${t_step}, 0.31, if(t<0.311*${t_step}, 0.311, if(t<0.312*${t_step}, 0.312, if(t<0.313*${t_step}, 0.313, if(t<0.314*${t_step}, 0.314, if(t<0.315*${t_step}, 0.315, if(t<0.316*${t_step}, 0.316, if(t<0.317*${t_step}, 0.317, if(t<0.318*${t_step}, 0.318, if(t<0.319*${t_step}, 0.319, if(t<0.32*${t_step}, 0.32, if(t<0.321*${t_step}, 0.321, if(t<0.322*${t_step}, 0.322, if(t<0.323*${t_step}, 0.323, if(t<0.324*${t_step}, 0.324, if(t<0.325*${t_step}, 0.325, if(t<0.326*${t_step}, 0.326, if(t<0.327*${t_step}, 0.327, if(t<0.328*${t_step}, 0.328, if(t<0.329*${t_step}, 0.329, if(t<0.32999999999999996*${t_step}, 0.32999999999999996, if(t<0.33099999999999996*${t_step}, 0.33099999999999996, if(t<0.33199999999999996*${t_step}, 0.33199999999999996, if(t<0.33299999999999996*${t_step}, 0.33299999999999996, if(t<0.33399999999999996*${t_step}, 0.33399999999999996, if(t<0.33499999999999996*${t_step}, 0.33499999999999996, if(t<0.33599999999999997*${t_step}, 0.33599999999999997, if(t<0.33699999999999997*${t_step}, 0.33699999999999997, if(t<0.33799999999999997*${t_step}, 0.33799999999999997, if(t<0.33899999999999997*${t_step}, 0.33899999999999997, if(t<0.33999999999999997*${t_step}, 0.33999999999999997, if(t<0.34099999999999997*${t_step}, 0.34099999999999997, if(t<0.34199999999999997*${t_step}, 0.34199999999999997, if(t<0.34299999999999997*${t_step}, 0.34299999999999997, if(t<0.344*${t_step}, 0.344, if(t<0.345*${t_step}, 0.345, if(t<0.346*${t_step}, 0.346, if(t<0.347*${t_step}, 0.347, if(t<0.348*${t_step}, 0.348, if(t<0.349*${t_step}, 0.349, 0.35 ))))))))))))))))))))))))))))))))))))))))))))))))))'
    []
    [Phi_right]
        type = ParsedFunction
        # value= 'if(t<${t_step}, 0, -(t-50)*${j_b}/50)'
        #  value= 'if(t<${t_step}, (-50)*${j_b}/50, -(0.01*t)*${j_b}/50)'
        value = 'if(t<0.3*${t_step}, -0.3, if(t<0.301*${t_step}, -0.301, if(t<0.302*${t_step}, -0.302, if(t<0.303*${t_step}, -0.303, if(t<0.304*${t_step}, -0.304, if(t<0.305*${t_step}, -0.305, if(t<0.306*${t_step}, -0.306, if(t<0.307*${t_step}, -0.307, if(t<0.308*${t_step}, -0.308, if(t<0.309*${t_step}, -0.309, if(t<0.31*${t_step}, -0.31, if(t<0.311*${t_step}, -0.311, if(t<0.312*${t_step}, -0.312, if(t<0.313*${t_step}, -0.313, if(t<0.314*${t_step}, -0.314, if(t<0.315*${t_step}, -0.315, if(t<0.316*${t_step}, -0.316, if(t<0.317*${t_step}, -0.317, if(t<0.318*${t_step}, -0.318, if(t<0.319*${t_step}, -0.319, if(t<0.32*${t_step}, -0.32, if(t<0.321*${t_step}, -0.321, if(t<0.322*${t_step}, -0.322, if(t<0.323*${t_step}, -0.323, if(t<0.324*${t_step}, -0.324, if(t<0.325*${t_step}, -0.325, if(t<0.326*${t_step}, -0.326, if(t<0.327*${t_step}, -0.327, if(t<0.328*${t_step}, -0.328, if(t<0.329*${t_step}, -0.329, if(t<0.32999999999999996*${t_step}, -0.32999999999999996, if(t<0.33099999999999996*${t_step}, -0.33099999999999996, if(t<0.33199999999999996*${t_step}, -0.33199999999999996, if(t<0.33299999999999996*${t_step}, -0.33299999999999996, if(t<0.33399999999999996*${t_step}, -0.33399999999999996, if(t<0.33499999999999996*${t_step}, -0.33499999999999996, if(t<0.33599999999999997*${t_step}, -0.33599999999999997, if(t<0.33699999999999997*${t_step}, -0.33699999999999997, if(t<0.33799999999999997*${t_step}, -0.33799999999999997, if(t<0.33899999999999997*${t_step}, -0.33899999999999997, if(t<0.33999999999999997*${t_step}, -0.33999999999999997, if(t<0.34099999999999997*${t_step}, -0.34099999999999997, if(t<0.34199999999999997*${t_step}, -0.34199999999999997, if(t<0.34299999999999997*${t_step}, -0.34299999999999997, if(t<0.344*${t_step}, -0.344, if(t<0.345*${t_step}, -0.345, if(t<0.346*${t_step}, -0.346, if(t<0.347*${t_step}, -0.347, if(t<0.348*${t_step}, -0.348, if(t<0.349*${t_step}, -0.349, 0.35 ))))))))))))))))))))))))))))))))))))))))))))))))))'
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
    point = '57.0 60.0 0.0'
[]
[ave_Phi_left_top]
    type = PointValue
    variable = Phi
    point = '3.0 60.0 0.0'
[]
[ave_Phi_right_bot]
    type = PointValue
    variable = Phi
    point = '57.0 0.0 0.0'
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
    scale_factor = 10
    []
[ave_Psi_Mag]
    type= AverageNodalVariableValue
    variable = Psi_Mag
[]
[]

[Executioner]
type = Transient
end_time = 2500
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