"""
Author: Manuel Jiménez Martínez

TFM - University of Málaga

"""


import serial

# Configura los parámetros de la conexión serie
puerto = '/dev/ttyACM0'  
velocidad = 115200  # Ajusta la velocidad de baudios 


try:
    conexion_serie = serial.Serial(puerto, velocidad, timeout=1)
except serial.SerialException as e:
    print("Error al abrir la conexión serie:", e)
    exit()

# Nombre del archivo donde se guardará la salida
nombre_archivo = 'IceFUN_fpga/src/serial_terminal/data_serial.txt'


with open(nombre_archivo, 'w') as archivo:  #modo escritura
    try:
        while True:

            linea = conexion_serie.readline().decode('utf-8').strip()

            archivo.write(linea + '\n')

            print(linea)
    except KeyboardInterrupt:
        # Maneja la interrupción de teclado (Ctrl+C)
        print("Interrupción de teclado detectada. Cerrando la conexión.")
        conexion_serie.close()
