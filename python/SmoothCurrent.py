def run(y, pos=True):
    if pos:
        part1 = r'if(t<${t_step}*( '
        part2 = r'+(1/2)), (${j_b}/(1+exp(-${smooth}*(t- '
        part3 = r'* ${t_step}))))+('
        part4 = r'-1) * ${j_b}, '
        string = part1 + part2 +part3
        out = str('\'if(t<${t_step}*3/2, (${j_b}/(1+exp(-${smooth}*(t-${t_step})))), ')
        bracket = r'0 '

    else:
        part1 = r'if(t<${t_step}*( '
        part2 = r'+(1/2)), -(${j_b}/(1+exp(-${smooth}*(t- '
        part3 = r'* ${t_step}))))-('
        part4 = r'-1) * ${j_b}, '
        string = part1 + part2 +part3
        out = str('\'if(t<${t_step}*3/2, -(${j_b}/(1+exp(-${smooth}*(t-${t_step})))), ')
        bracket = r'0 '





    for i in range(2, y):
        # x = -0.25-0.001*i
        # string_x = str(x)
        string_i = str(i)
        out += part1 + string_i + part2 + string_i + part3 +  string_i + part4


    for i in range(y):
        bracket+= r''

    out += bracket + '\''


    print(out)



run(5, False)