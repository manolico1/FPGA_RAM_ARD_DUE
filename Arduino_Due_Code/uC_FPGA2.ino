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

const int enable_fpga=10;

bool loopExecuted = false;

void setup() {
  pinMode(CE, OUTPUT);
  pinMode(CE2, OUTPUT);
  pinMode(WE, OUTPUT);
  pinMode(OE, OUTPUT);
  pinMode(LB, OUTPUT);
  pinMode(UB, OUTPUT);

  pinMode(enable_fpga, OUTPUT);

  Serial.begin(115200);

  digitalWrite(CE, LOW);
  digitalWrite(CE2, HIGH);
  digitalWrite(LB, LOW);  //LB# or UB# low

  digitalWrite(enable_fpga, LOW);

  unsigned long address = 0x0001;
  unsigned long data = 0x0001;

  // Escribe datos en la dirección 0x0000
  escribir_datos(address, data);
  Serial.print("address:");
  Serial.println(address);
  Serial.print("data:");
  Serial.println(leer_datos(address));

  SetAddress(address);

  // Configura los pines de datos como entradas
  for (int pin = DATA_PINS_START; pin <= DATA_PINS_END; pin++) {
    pinMode(pin, INPUT);
  }

  // Habilita el FPGA
  digitalWrite(enable_fpga, HIGH);
  delayMicroseconds(1);  // Espera un microsegundo para asegurar la activación

  // Configura las señales de control para leer
  digitalWrite(WE, HIGH);
  digitalWrite(OE, LOW);
  delayMicroseconds(1);

  // Configura las señales de control para escribir desde el FPGA
  digitalWrite(WE, LOW);
  digitalWrite(OE, HIGH);
  delayMicroseconds(1);

  // Deshabilita el FPGA
  digitalWrite(enable_fpga, LOW);
  delayMicroseconds(1);

  Serial.print("address:");
  Serial.println(address);
  Serial.print("data:");
  Serial.println(leer_datos(address));
}

void loop() {   //BUCLE PARA LEER Y ESCRIBIR EN UN RANGO DE DIRECCIONES

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
  for (int pin = DATA_PINS_END; pin >= DATA_PINS_START; pin--) {
    dataram = (dataram << 1) + digitalRead(pin);
  }

  return dataram;
}

void escribir_datos(unsigned long address, unsigned long data) {
  SetAddress(address);
  delayMicroseconds(1);

  // Configura los pines de control para escribir
  digitalWrite(WE, LOW);
  digitalWrite(OE, HIGH);
  delayMicroseconds(1);

  // Configura los pines de datos como salidas
  for (int pin = DATA_PINS_START; pin <= DATA_PINS_END; pin++) {
    pinMode(pin, OUTPUT);
    digitalWrite(pin, (data >> (pin - DATA_PINS_START)) & 0x1);
  }
  delayMicroseconds(1);
}

void SetAddress(unsigned long address) {
  for (int pin = ADDR_PINS_START; pin <= ADDR_PINS_END; pin++) {
    pinMode(pin, OUTPUT);
    digitalWrite(pin, (address >> (pin - ADDR_PINS_START)) & 0x1);
  }
}
