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
  digitalWrite(CE, LOW);
  digitalWrite(CE2, HIGH);
  digitalWrite(LB, LOW);  //LB# or UB# low


//FUNCIONA: CASO PARA LEER UNA DIRECCION (CON VOID LOOP VACIO)
  //unsigned long address = 0x5;
  //Serial.print("address:");
  //Serial.println(address);
  //Serial.print("data:");
  //Serial.println(leer_datos(address));
  
//FUNCIONA: CASO PARA ESCRIBIR EN UNA DIRECCION UN DATO (CON VOID LOOP VACIO)
  //unsigned long address= 0x5;
  //unsigned long data = 34567;
  //escribir_datos(address, data);

  //Serial.print("address:");
  //Serial.println(address);
  //Serial.print("data:");
  //Serial.println(leer_datos(address));
}
//void loop() { }

//void loop() {  //CASO LEER UNA DIRECCION ESCRITA POR EL MONITOR SERIE

//  Serial.println("Por favor ingrese una direccion: "); // Solicitar al usuario que ingrese un número
//  while (!Serial.available()) {} // Esperar hasta que haya datos disponibles en el puerto serie
  
  // Leer el número ingresado por el usuario solo si hay datos disponibles
//  unsigned long address = Serial.parseInt(); // Leer el número ingresado por el usuario
//  delayMicroseconds(1);

//  Serial.print("address:");
//  Serial.println(address);
//  Serial.print("data:");
//  Serial.println(leer_datos(address));


  // Esperar un momento antes de volver a solicitar un número
//  delay(20);
  
//}

void loop() {   //BUCLE PARA LEER Y ESCRIBIR EN UN RANGO DE DIRECCIONES

if (!loopExecuted) { // Verifica si el bucle ya se ha ejecutado
    // Código dentro del bucle que se ejecutará solo una vez
    unsigned long address = 0; 

    for (address = 0; address <= 256; address += 1) {   //2^16 =65536
    // El dato que se va a escribir es el mismo que la dirección actual
    unsigned long data = address;

    // Escribir el dato en la dirección de memoria actual
    escribir_datos(address, data);
    delayMicroseconds(1); 
    // Mostrar la dirección y los datos escritos en el monitor serie
    Serial.print("address:");
    Serial.println(address);
    Serial.print("data:");
    Serial.println(leer_datos(address));
    delayMicroseconds(1); 
    }
  delay(1);
  loopExecuted = true; // Marcar el bucle como ejecutado
  } 
}

unsigned long leer_datos(unsigned long address) {

  SetAddress(address);
  delayMicroseconds(1); 
  
  // Configura los pines de datos como entradas
  for (int pin = DATA_PINS_START; pin <= DATA_PINS_END; pin++) {
    pinMode(pin, INPUT);
  }
  delayMicroseconds(1); 
  // Configura los pines de control para leer

  digitalWrite(WE, HIGH);
  digitalWrite(OE, LOW);

  delayMicroseconds(1); 
  // Lee el byte desde los pines de datos
  unsigned long dataram = 0;
  for (int pin = DATA_PINS_END; pin >= DATA_PINS_START; pin -= 1) {
    dataram = (dataram << 1) + digitalRead(pin);
  }

  return dataram;
}


void escribir_datos(unsigned long address, unsigned long data) {
  // SetAddress: Configurar los pines de dirección como salida y escribir el valor de la dirección en ellos
  SetAddress(address);
  delayMicroseconds(1); 

  // Configura los pines de control para escribir
  digitalWrite(WE, LOW); 
  digitalWrite(OE, HIGH);
  
  delayMicroseconds(1);

  // Configura los pines de datos como salidas
  for (int pin = DATA_PINS_START; pin <= DATA_PINS_END; pin++) {
    pinMode(pin, OUTPUT);
    digitalWrite(pin, (data >> (pin - DATA_PINS_START)) & 0x000001);
    //digitalWrite(pin, data & 0x000001);
    //data = data >> 1;
  }
  delayMicroseconds(1); 
  // Configura los pines de control para escribir
  //digitalWrite(CE, LOW);
  //digitalWrite(CE2, HIGH);
  //digitalWrite(WE, LOW); 
  //digitalWrite(LB, LOW);  //LB# or UB# low
  //digitalWrite(OE, HIGH);

  

  digitalWrite(WE, HIGH);
  digitalWrite(OE, LOW);
  
  //digitalWrite(BYTE#, LOW);   //tied to Vcc to use the device as 4M x 16 SRAM

  // Write operation, wait for some time to ensure data is written properly
  delayMicroseconds(1); 
}

unsigned long SetAddress(unsigned long address) {
  // SetAddress:Configurar los pines de dirección como salida y escribir el valor de la dirección en ellos
  for (int pin = ADDR_PINS_START; pin <= ADDR_PINS_END; pin++) {
    pinMode(pin, OUTPUT);
    digitalWrite(pin, (address >> (pin - ADDR_PINS_START)) & 0x000001);
  }
}
