#!/usr/bin/python3

salida = []

archivo = open("Code-groups.txt", 'r')
archivo2 = open('Code-groups.csv', 'a')

for i in archivo:
    str_tmp = ''
    i = i.replace("\n", '')
    i = i.replace('"', '')
    i = i.split(",")
    salida.append(i)

for i in range(len(salida)):
    str_tmp = ''
    nombre_tmp = ''
    salida_tmp = []

    salida[i][0] = salida[i][0].split('_')
    nombre = str(salida[i][0][0] + "." + salida[i][0][1])
    if (salida[i][0][3] == "Plus"):
        salida[i][0][3] = "+"
    else:
        salida[i][0][3] = "-"
    errede = str(salida[i][0][2] + salida[i][0][3])

    if (salida[i][1] == "None"):
        for j in salida[i-1][3]:
            if (j == "1"):
                str_tmp += "0"
            else:
                str_tmp += "1"
        salida[i][1]= str_tmp

    salida_tmp = [nombre, errede, salida[i][0][4], salida[i][1]]

    salida[i] = salida_tmp


for i in salida:
    i = str(i)
    i = i.replace('[','')
    i = i.replace(']','')
    i = i.replace("'", '')
    i += "\n"
    archivo2.write(i)

archivo.close()
archivo2.close()
