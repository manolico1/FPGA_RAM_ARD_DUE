// pin definitions

const int ADDR_PINS_START = 22;
const int ADDR_PINS_END = 43;
const int DATA_PINS_START = 44;
const int DATA_PINS_END = 59;

const int CE = 2;
const int CE2 = 3;
const int WE = 4;
const int OE = 5;
const int LB = 6;
const int UB = 7;

bool loopExecuted = false;


void setup() {
  // put your setup code here, to run once:
  pinMode(CE, OUTPUT);
  pinMode(CE2, OUTPUT);
  pinMode(WE, OUTPUT);
  pinMode(OE, OUTPUT);
  pinMode(LB, OUTPUT);
  pinMode(UB, OUTPUT);
  Serial.begin(115200);

  //FUNCIONA cuando se prueba a leer de una en una
  unsigned long address = 0x07;
  Serial.print("address:");
  Serial.println(address);
  Serial.print("data:");
  Serial.println(leer_datos(address));

  delay(1000);
  Serial.print("address:");
  Serial.println(address);
  Serial.print("data:");
  Serial.println(leer_datos(address));
  
  
}
void loop() {}
//void loop() {   //LEER UNA DIRECCION ESCRITA POR EL MONITOR SERIE

  //Serial.println("Por favor ingrese una direccion: "); // Solicitar al usuario que ingrese un número
  //while (!Serial.available()) {} // Esperar hasta que haya datos disponibles en el puerto serie
  
  // Leer el número ingresado por el usuario solo si hay datos disponibles
  //unsigned long address = Serial.parseInt(); 

  //Serial.print("address:");
  //Serial.println(address);
  //Serial.print("data:");
  //Serial.println(leer_datos(address));

  // Esperar un momento antes de volver a solicitar un número
  //delay(20);

//}

//void loop() {   //BUCLE PARA LEER EN UN RANGO DE DIRECCIONES

//if (!loopExecuted) { // Verifica si el bucle ya se ha ejecutado
    // Código dentro del bucle que se ejecutará solo una vez
//    unsigned long address = 0; 
//    for (address = 0; address <= 5; address += 1)  {
        // Mostrar la dirección y los datos leidos en el monitor serie
//        Serial.print("address: ");
//        Serial.println(address);
//        Serial.print("data: ");
//        Serial.println(leer_datos(address));
//    }
//    loopExecuted = true; // Marcar el bucle como ejecutado
//  }

  
  // delay(1);
//}

unsigned long leer_datos(unsigned long address) {

  SetAddress(address);
  delayMicroseconds(1); 
  
  // Configura los pines de datos como entradas
  for (int pin = DATA_PINS_START; pin <= DATA_PINS_END; pin++) {
    pinMode(pin, INPUT);
  }
  delayMicroseconds(1); 
  // Configura los pines de control para leer

  digitalWrite(CE, LOW);
  digitalWrite(CE2, HIGH);
  digitalWrite(WE, HIGH);
  digitalWrite(OE, LOW);
  digitalWrite(LB, LOW);  //LB# or UB# low
  //digitalWrite(BYTE#, LOW);   //tied to Vcc to use the device as 4M x 16 SRAM

  delayMicroseconds(1); 
  // Lee el byte desde los pines de datos
  unsigned long dataram = 0;
  for (int pin = DATA_PINS_END; pin >= DATA_PINS_START; pin -= 1) {
    dataram = (dataram << 1) + digitalRead(pin);
  }

  return dataram;
}

unsigned long SetAddress(unsigned long address) {
  // SetAddress:Configurar los pines de dirección como salida y escribir el valor de la dirección en ellos
  for (int pin = ADDR_PINS_START; pin <= ADDR_PINS_END; pin++) {
    pinMode(pin, OUTPUT);
    digitalWrite(pin, (address >> (pin - ADDR_PINS_START)) & 0x000001);
  }
}
