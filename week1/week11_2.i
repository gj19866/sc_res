#Diffusion Inc
#
# Single block thermal input with time derivative term
# https://mooseframework.inl.gov/modules/heat_conduction/tutorials/introduction/therm_step03.html
#

csv_path = 'Psi_csv.csv'
# j_b = 0.01
# smooth = 1
# t_step = 500
gamma = 0.1
u = 5.78823864


[Mesh]

    [generated]
        type = FileMeshGenerator
        
        # file = 'notch.msh'
        # file = 'ratchet1.msh'
        # file = 'ratchet2.msh'
        file = 'scs.msh'
        # file = 'rect.msh'
        # file = 'double_notch.msh'
        # file = 'scs.msh'
    []
    # [generated]
    #   type = GeneratedMeshGenerator
    #   dim = 2
    #   nx = 20
    #   ny = 10
    #   xmax = 20
    #   ymax = 10
    # []
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
        # fuction = 1
    []
    [Psi_Im]
        type = FunctionIC
        variable = Psi_Im
        function = Psi_Im_Func
        # function = 1
    []
    [Diffuse_IC]
        type = RandomIC
        variable = Diffuse
        max = 1.2
        min = 0.8
    []
  #   [Const_Diffuse]
  #     type = ConstantIC
  #     variable = Diffuse
  #     value = 1
  # []
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
        function = 'if(t<0.5, 5, 0)'
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
        # value= 'if(t<${t_step}, 0, (t-50)*${j_b}/50)'
        # value= 'if(t<${t_step}, (50)*${j_b}/50, (0.01*t)*${j_b}/50)'
        # value = 'if(t<0.3*${t_step}, 0.3, if(t<0.301*${t_step}, 0.301, if(t<0.302*${t_step}, 0.302, if(t<0.303*${t_step}, 0.303, if(t<0.304*${t_step}, 0.304, if(t<0.305*${t_step}, 0.305, if(t<0.306*${t_step}, 0.306, if(t<0.307*${t_step}, 0.307, if(t<0.308*${t_step}, 0.308, if(t<0.309*${t_step}, 0.309, if(t<0.31*${t_step}, 0.31, if(t<0.311*${t_step}, 0.311, if(t<0.312*${t_step}, 0.312, if(t<0.313*${t_step}, 0.313, if(t<0.314*${t_step}, 0.314, if(t<0.315*${t_step}, 0.315, if(t<0.316*${t_step}, 0.316, if(t<0.317*${t_step}, 0.317, if(t<0.318*${t_step}, 0.318, if(t<0.319*${t_step}, 0.319, if(t<0.32*${t_step}, 0.32, if(t<0.321*${t_step}, 0.321, if(t<0.322*${t_step}, 0.322, if(t<0.323*${t_step}, 0.323, if(t<0.324*${t_step}, 0.324, if(t<0.325*${t_step}, 0.325, if(t<0.326*${t_step}, 0.326, if(t<0.327*${t_step}, 0.327, if(t<0.328*${t_step}, 0.328, if(t<0.329*${t_step}, 0.329, if(t<0.32999999999999996*${t_step}, 0.32999999999999996, if(t<0.33099999999999996*${t_step}, 0.33099999999999996, if(t<0.33199999999999996*${t_step}, 0.33199999999999996, if(t<0.33299999999999996*${t_step}, 0.33299999999999996, if(t<0.33399999999999996*${t_step}, 0.33399999999999996, if(t<0.33499999999999996*${t_step}, 0.33499999999999996, if(t<0.33599999999999997*${t_step}, 0.33599999999999997, if(t<0.33699999999999997*${t_step}, 0.33699999999999997, if(t<0.33799999999999997*${t_step}, 0.33799999999999997, if(t<0.33899999999999997*${t_step}, 0.33899999999999997, if(t<0.33999999999999997*${t_step}, 0.33999999999999997, if(t<0.34099999999999997*${t_step}, 0.34099999999999997, if(t<0.34199999999999997*${t_step}, 0.34199999999999997, if(t<0.34299999999999997*${t_step}, 0.34299999999999997, if(t<0.344*${t_step}, 0.344, if(t<0.345*${t_step}, 0.345, if(t<0.346*${t_step}, 0.346, if(t<0.347*${t_step}, 0.347, if(t<0.348*${t_step}, 0.348, if(t<0.349*${t_step}, 0.349, 0.35 ))))))))))))))))))))))))))))))))))))))))))))))))))'
        # value = 'if(t<0*${t_step}, 0.0, if(t<1*${t_step}, 0.0, if(t<2*${t_step}, 0.1, if(t<3*${t_step}, 0.2, if(t<4*${t_step}, 0.254, if(t<5*${t_step}, 0.255, if(t<6*${t_step}, 0.256, if(t<7*${t_step}, 0.257, if(t<8*${t_step}, 0.258, if(t<9*${t_step}, 0.259, if(t<10*${t_step}, 0.26, if(t<11*${t_step}, 0.261, if(t<12*${t_step}, 0.262, if(t<13*${t_step}, 0.263, if(t<14*${t_step}, 0.264, if(t<15*${t_step}, 0.265, if(t<16*${t_step}, 0.266, if(t<17*${t_step}, 0.267, if(t<18*${t_step}, 0.268, if(t<19*${t_step}, 0.269, if(t<20*${t_step}, 0.27, if(t<21*${t_step}, 0.271, if(t<22*${t_step}, 0.272, if(t<23*${t_step}, 0.273, if(t<24*${t_step}, 0.274, if(t<25*${t_step}, 0.275, if(t<26*${t_step}, 0.276, if(t<27*${t_step}, 0.277, if(t<28*${t_step}, 0.278, if(t<29*${t_step}, 0.279, if(t<30*${t_step}, 0.28, if(t<31*${t_step}, 0.281, if(t<32*${t_step}, 0.28200000000000003, if(t<33*${t_step}, 0.28300000000000003, if(t<34*${t_step}, 0.28400000000000003, if(t<35*${t_step}, 0.28500000000000003, if(t<36*${t_step}, 0.28600000000000003, if(t<37*${t_step}, 0.287, if(t<38*${t_step}, 0.288, if(t<39*${t_step}, 0.289, if(t<40*${t_step}, 0.29, if(t<41*${t_step}, 0.291, if(t<42*${t_step}, 0.292, if(t<43*${t_step}, 0.293, if(t<44*${t_step}, 0.294, if(t<45*${t_step}, 0.295, if(t<46*${t_step}, 0.296, if(t<47*${t_step}, 0.297, if(t<48*${t_step}, 0.298, if(t<49*${t_step}, 0.299, 0.30 ))))))))))))))))))))))))))))))))))))))))))))))))))'
        # value = 'if(t< ${t_step}, 0, if(t< 2*${t_step}, 0.1, if(t< 3*${t_step}, 0.15, if(t< 3*${t_step}, 0.2, if(t< 4*${t_step}, 0.2, if(t< 5*${t_step}, 0.25if(t< 6*${t_step}, 0.256, if(t< 7*${t_step}, 0.257, if(t< 8*${t_step}, 0.258, if(t< 9*${t_step}, 0.259, if(t< 10*${t_step}, 0.26, if(t< 11*${t_step}, 0.261, if(t< 12*${t_step}, 0.262, if(t< 13*${t_step}, 0.263, if(t< 14*${t_step}, 0.264, if(t< 15*${t_step}, 0.265, if(t< 16*${t_step}, 0.266, if(t< 17*${t_step}, 0.267, if(t< 18*${t_step}, 0.268, if(t< 19*${t_step}, 0.269, if(t< 20*${t_step}, 0.27, if(t< 21*${t_step}, 0.271, if(t< 22*${t_step}, 0.272, if(t< 23*${t_step}, 0.273, if(t< 24*${t_step}, 0.274, if(t< 25*${t_step}, 0.275, if(t< 26*${t_step}, 0.276, if(t< 27*${t_step}, 0.277, if(t< 28*${t_step}, 0.278, if(t< 29*${t_step}, 0.279, if(t< 30*${t_step}, 0.28, if(t< 31*${t_step}, 0.281, if(t< 32*${t_step}, 0.28200000000000003, if(t< 33*${t_step}, 0.28300000000000003, if(t< 34*${t_step}, 0.28400000000000003, if(t< 35*${t_step}, 0.28500000000000003, if(t< 36*${t_step}, 0.28600000000000003, if(t< 37*${t_step}, 0.287, if(t< 38*${t_step}, 0.288, if(t< 39*${t_step}, 0.289, if(t< 40*${t_step}, 0.29, if(t< 41*${t_step}, 0.291, if(t< 42*${t_step}, 0.292, if(t< 43*${t_step}, 0.293, if(t< 44*${t_step}, 0.294, if(t< 45*${t_step}, 0.295, if(t< 46*${t_step}, 0.296, if(t< 47*${t_step}, 0.297, if(t< 48*${t_step}, 0.298, if(t< 49*${t_step}, 0.299, if(t< 50*${t_step}, 0.3, if(t< 51*${t_step}, 0.301, if(t< 52*${t_step}, 0.302, if(t< 53*${t_step}, 0.303, if(t< 54*${t_step}, 0.304, if(t< 55*${t_step}, 0.305, if(t< 56*${t_step}, 0.306, if(t< 57*${t_step}, 0.307, if(t< 58*${t_step}, 0.308, if(t< 59*${t_step}, 0.309, if(t< 60*${t_step}, 0.31, if(t< 61*${t_step}, 0.311, if(t< 62*${t_step}, 0.312, if(t< 63*${t_step}, 0.313, if(t< 64*${t_step}, 0.314, if(t< 65*${t_step}, 0.315, if(t< 66*${t_step}, 0.316, if(t< 67*${t_step}, 0.317, if(t< 68*${t_step}, 0.318, if(t< 69*${t_step}, 0.319, if(t< 70*${t_step}, 0.32, if(t< 71*${t_step}, 0.321, if(t< 72*${t_step}, 0.322, if(t< 73*${t_step}, 0.323, if(t< 74*${t_step}, 0.324, if(t< 75*${t_step}, 0.325, if(t< 76*${t_step}, 0.326, if(t< 77*${t_step}, 0.327, if(t< 78*${t_step}, 0.328, if(t< 79*${t_step}, 0.329, if(t< 80*${t_step}, 0.33, if(t< 81*${t_step}, 0.331, if(t< 82*${t_step}, 0.332, if(t< 83*${t_step}, 0.333, if(t< 84*${t_step}, 0.334, if(t< 85*${t_step}, 0.335, if(t< 86*${t_step}, 0.336, if(t< 87*${t_step}, 0.337, if(t< 88*${t_step}, 0.33799999999999997, if(t< 89*${t_step}, 0.33899999999999997, if(t< 90*${t_step}, 0.33999999999999997, if(t< 91*${t_step}, 0.34099999999999997, if(t< 92*${t_step}, 0.34199999999999997, if(t< 93*${t_step}, 0.34299999999999997, if(t< 94*${t_step}, 0.344, if(t< 95*${t_step}, 0.345, if(t< 96*${t_step}, 0.346, if(t< 97*${t_step}, 0.347, if(t< 98*${t_step}, 0.348, if(t< 99*${t_step}, 0.349, 0.30 ))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))'
        # value = 0.2
        # value = 'if(t<${t_step}*3/2, (${j_b}/(1+exp(-${smooth}*(t-${t_step})))), if(t<${t_step}*( 2+(1/2)), (${j_b}/(1+exp(-${smooth}*(t- 2* ${t_step}))))+(2-1) * ${j_b}, if(t<${t_step}*( 3+(1/2)), (${j_b}/(1+exp(-${smooth}*(t- 3* ${t_step}))))+(3-1) * ${j_b}, if(t<${t_step}*( 4+(1/2)), (${j_b}/(1+exp(-${smooth}*(t- 4* ${t_step}))))+(4-1) * ${j_b}, 0 ))))'
        value = 'if(t<600, t/(5*2000), (0.3/5)+((t-600)/50000))'
      []

    [Phi_right]
        type = ParsedFunction
        # value= 'if(t<${t_step}, 0, -(t-50)*${j_b}/50)'
        #  value= 'if(t<${t_step}, (-50)*${j_b}/50, -(0.01*t)*${j_b}/50)'
        # value = 'if(t<0.3*${t_step}, -0.3, if(t<0.301*${t_step}, -0.301, if(t<0.302*${t_step}, -0.302, if(t<0.303*${t_step}, -0.303, if(t<0.304*${t_step}, -0.304, if(t<0.305*${t_step}, -0.305, if(t<0.306*${t_step}, -0.306, if(t<0.307*${t_step}, -0.307, if(t<0.308*${t_step}, -0.308, if(t<0.309*${t_step}, -0.309, if(t<0.31*${t_step}, -0.31, if(t<0.311*${t_step}, -0.311, if(t<0.312*${t_step}, -0.312, if(t<0.313*${t_step}, -0.313, if(t<0.314*${t_step}, -0.314, if(t<0.315*${t_step}, -0.315, if(t<0.316*${t_step}, -0.316, if(t<0.317*${t_step}, -0.317, if(t<0.318*${t_step}, -0.318, if(t<0.319*${t_step}, -0.319, if(t<0.32*${t_step}, -0.32, if(t<0.321*${t_step}, -0.321, if(t<0.322*${t_step}, -0.322, if(t<0.323*${t_step}, -0.323, if(t<0.324*${t_step}, -0.324, if(t<0.325*${t_step}, -0.325, if(t<0.326*${t_step}, -0.326, if(t<0.327*${t_step}, -0.327, if(t<0.328*${t_step}, -0.328, if(t<0.329*${t_step}, -0.329, if(t<0.32999999999999996*${t_step}, -0.32999999999999996, if(t<0.33099999999999996*${t_step}, -0.33099999999999996, if(t<0.33199999999999996*${t_step}, -0.33199999999999996, if(t<0.33299999999999996*${t_step}, -0.33299999999999996, if(t<0.33399999999999996*${t_step}, -0.33399999999999996, if(t<0.33499999999999996*${t_step}, -0.33499999999999996, if(t<0.33599999999999997*${t_step}, -0.33599999999999997, if(t<0.33699999999999997*${t_step}, -0.33699999999999997, if(t<0.33799999999999997*${t_step}, -0.33799999999999997, if(t<0.33899999999999997*${t_step}, -0.33899999999999997, if(t<0.33999999999999997*${t_step}, -0.33999999999999997, if(t<0.34099999999999997*${t_step}, -0.34099999999999997, if(t<0.34199999999999997*${t_step}, -0.34199999999999997, if(t<0.34299999999999997*${t_step}, -0.34299999999999997, if(t<0.344*${t_step}, -0.344, if(t<0.345*${t_step}, -0.345, if(t<0.346*${t_step}, -0.346, if(t<0.347*${t_step}, -0.347, if(t<0.348*${t_step}, -0.348, if(t<0.349*${t_step}, -0.349, 0.35 ))))))))))))))))))))))))))))))))))))))))))))))))))'
        # value = 'if(t<0*${t_step}, -0.0, if(t<1*${t_step}, -0.0, if(t<2*${t_step}, -0.1, if(t<3*${t_step}, -0.2, if(t<4*${t_step}, -0.254, if(t<5*${t_step}, -0.255, if(t<6*${t_step}, -0.256, if(t<7*${t_step}, -0.257, if(t<8*${t_step}, -0.258, if(t<9*${t_step}, -0.259, if(t<10*${t_step}, -0.26, if(t<11*${t_step}, -0.261, if(t<12*${t_step}, -0.262, if(t<13*${t_step}, -0.263, if(t<14*${t_step}, -0.264, if(t<15*${t_step}, -0.265, if(t<16*${t_step}, -0.266, if(t<17*${t_step}, -0.267, if(t<18*${t_step}, -0.268, if(t<19*${t_step}, -0.269, if(t<20*${t_step}, -0.27, if(t<21*${t_step}, -0.271, if(t<22*${t_step}, -0.272, if(t<23*${t_step}, -0.273, if(t<24*${t_step}, -0.274, if(t<25*${t_step}, -0.275, if(t<26*${t_step}, -0.276, if(t<27*${t_step}, -0.277, if(t<28*${t_step}, -0.278, if(t<29*${t_step}, -0.279, if(t<30*${t_step}, -0.28, if(t<31*${t_step}, -0.281, if(t<32*${t_step}, -0.28200000000000003, if(t<33*${t_step}, -0.28300000000000003, if(t<34*${t_step}, -0.28400000000000003, if(t<35*${t_step}, -0.28500000000000003, if(t<36*${t_step}, -0.28600000000000003, if(t<37*${t_step}, -0.287, if(t<38*${t_step}, -0.288, if(t<39*${t_step}, -0.289, if(t<40*${t_step}, -0.29, if(t<41*${t_step}, -0.291, if(t<42*${t_step}, -0.292, if(t<43*${t_step}, -0.293, if(t<44*${t_step}, -0.294, if(t<45*${t_step}, -0.295, if(t<46*${t_step}, -0.296, if(t<47*${t_step}, -0.297, if(t<48*${t_step}, -0.298, if(t<49*${t_step}, -0.299, 0.30 ))))))))))))))))))))))))))))))))))))))))))))))))))'
        # value = 'if(t< ${t_step}, 0, if(t< 2*${t_step}, -0.1, if(t< 3*${t_step}, -0.15, if(t< 3*${t_step}, -0.2, if(t< 4*${t_step}, -0.2, if(t< 5*${t_step}, 0.25if(t< 6*${t_step}, -0.256, if(t< 7*${t_step}, -0.257, if(t< 8*${t_step}, -0.258, if(t< 9*${t_step}, -0.259, if(t< 10*${t_step}, -0.26, if(t< 11*${t_step}, -0.261, if(t< 12*${t_step}, -0.262, if(t< 13*${t_step}, -0.263, if(t< 14*${t_step}, -0.264, if(t< 15*${t_step}, -0.265, if(t< 16*${t_step}, -0.266, if(t< 17*${t_step}, -0.267, if(t< 18*${t_step}, -0.268, if(t< 19*${t_step}, -0.269, if(t< 20*${t_step}, -0.27, if(t< 21*${t_step}, -0.271, if(t< 22*${t_step}, -0.272, if(t< 23*${t_step}, -0.273, if(t< 24*${t_step}, -0.274, if(t< 25*${t_step}, -0.275, if(t< 26*${t_step}, -0.276, if(t< 27*${t_step}, -0.277, if(t< 28*${t_step}, -0.278, if(t< 29*${t_step}, -0.279, if(t< 30*${t_step}, -0.28, if(t< 31*${t_step}, -0.281, if(t< 32*${t_step}, -0.28200000000000003, if(t< 33*${t_step}, -0.28300000000000003, if(t< 34*${t_step}, -0.28400000000000003, if(t< 35*${t_step}, -0.28500000000000003, if(t< 36*${t_step}, -0.28600000000000003, if(t< 37*${t_step}, -0.287, if(t< 38*${t_step}, -0.288, if(t< 39*${t_step}, -0.289, if(t< 40*${t_step}, -0.29, if(t< 41*${t_step}, -0.291, if(t< 42*${t_step}, -0.292, if(t< 43*${t_step}, -0.293, if(t< 44*${t_step}, -0.294, if(t< 45*${t_step}, -0.295, if(t< 46*${t_step}, -0.296, if(t< 47*${t_step}, -0.297, if(t< 48*${t_step}, -0.298, if(t< 49*${t_step}, -0.299, if(t< 50*${t_step}, -0.3, if(t< 51*${t_step}, -0.301, if(t< 52*${t_step}, -0.302, if(t< 53*${t_step}, -0.303, if(t< 54*${t_step}, -0.304, if(t< 55*${t_step}, -0.305, if(t< 56*${t_step}, -0.306, if(t< 57*${t_step}, -0.307, if(t< 58*${t_step}, -0.308, if(t< 59*${t_step}, -0.309, if(t< 60*${t_step}, -0.31, if(t< 61*${t_step}, -0.311, if(t< 62*${t_step}, -0.312, if(t< 63*${t_step}, -0.313, if(t< 64*${t_step}, -0.314, if(t< 65*${t_step}, -0.315, if(t< 66*${t_step}, -0.316, if(t< 67*${t_step}, -0.317, if(t< 68*${t_step}, -0.318, if(t< 69*${t_step}, -0.319, if(t< 70*${t_step}, -0.32, if(t< 71*${t_step}, -0.321, if(t< 72*${t_step}, -0.322, if(t< 73*${t_step}, -0.323, if(t< 74*${t_step}, -0.324, if(t< 75*${t_step}, -0.325, if(t< 76*${t_step}, -0.326, if(t< 77*${t_step}, -0.327, if(t< 78*${t_step}, -0.328, if(t< 79*${t_step}, -0.329, if(t< 80*${t_step}, -0.33, if(t< 81*${t_step}, -0.331, if(t< 82*${t_step}, -0.332, if(t< 83*${t_step}, -0.333, if(t< 84*${t_step}, -0.334, if(t< 85*${t_step}, -0.335, if(t< 86*${t_step}, -0.336, if(t< 87*${t_step}, -0.337, if(t< 88*${t_step}, -0.33799999999999997, if(t< 89*${t_step}, -0.33899999999999997, if(t< 90*${t_step}, -0.33999999999999997, if(t< 91*${t_step}, -0.34099999999999997, if(t< 92*${t_step}, -0.34199999999999997, if(t< 93*${t_step}, -0.34299999999999997, if(t< 94*${t_step}, -0.344, if(t< 95*${t_step}, -0.345, if(t< 96*${t_step}, -0.346, if(t< 97*${t_step}, -0.347, if(t< 98*${t_step}, -0.348, if(t< 99*${t_step}, -0.349, 0.30 ))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))' 
        # value =-0.2
        # value = 'if(t<${t_step}*3/2, -(${j_b}/(1+exp(-${smooth}*(t-${t_step})))), if(t<${t_step}*( 2+(1/2)), -(${j_b}/(1+exp(-${smooth}*(t- 2* ${t_step}))))-(2-1) * ${j_b}, if(t<${t_step}*( 3+(1/2)), -(${j_b}/(1+exp(-${smooth}*(t- 3* ${t_step}))))-(3-1) * ${j_b}, if(t<${t_step}*( 4+(1/2)), -(${j_b}/(1+exp(-${smooth}*(t- 4* ${t_step}))))-(4-1) * ${j_b}, 0 ))))'
        value = 'if(t<600, -t/(5*2000), -(0.3/5)-((t-600)/50000))'
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

# New BC
# [Psi_Re_x]
#     type = SuperBC
#     variable = Psi_Re
#     Psi_Im = Psi_Im
#     psi_MAG = 1
#     boundary = 'left right'
#   []
  # [Psi_Re_x]
  #   type = SuperBC2
  #   variable = Psi_Re
  #   Psi_Im = Psi_Im
  #   psi_MAG = 1
  #   boundary = 'left right'
  # []
  # [Psi_Im_x]
  #   type = SuperBC
  #   variable = Psi_Im
  #   Psi_Im = Psi_Re
  #   psi_MAG = 1
  #   boundary = 'left right'
  # []

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
#     point = '2.25 0.0 0.0'
# []
# [ave_Phi_right_top]
#     type = PointValue
#     variable = Phi
#     point = '197.75 50.0 0.0'
# []
# [ave_Phi_left_top]
#     type = PointValue
#     variable = Phi
#     point = '2.25 50.0 0.0'
# []
# [ave_Phi_right_bot]
#     type = PointValue
#     variable = Phi
#     point = '197.75 0.0 0.0'
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
#     scale_factor = 10
#     []
# [ave_Psi_Mag]
#     type= AverageNodalVariableValue
#     variable = Psi_Mag
# []
# []

[Executioner]
type = Transient
end_time = 6000
# end_time = 250
nl_max_its = 50
l_max_its = 50
# dt= 2
# automatic_scaling = True 
nl_abs_tol = 1e-9
[TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = 0.4
    cutback_factor_at_failure = 0.5
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