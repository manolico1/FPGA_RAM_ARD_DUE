// Pin definitions
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

const int enable_fpga = 10;

bool loopExecuted = false;

void setup() {
  // Set control pins as outputs
  pinMode(CE, OUTPUT);
  pinMode(CE2, OUTPUT);
  pinMode(WE, OUTPUT);
  pinMode(OE, OUTPUT);
  pinMode(LB, OUTPUT);
  pinMode(UB, OUTPUT);

  pinMode(enable_fpga, OUTPUT);

  Serial.begin(115200);

  // Initialize control pins
  digitalWrite(CE, LOW);
  digitalWrite(CE2, HIGH);
  digitalWrite(LB, LOW);
  digitalWrite(enable_fpga, LOW);

  // Example usage
  unsigned long address = 0x0;
  Serial.print("address:");
  Serial.println(address);
  Serial.print("data:");
  Serial.println(leer_datos(address));

  address = 0x0;
  unsigned long data = 345;
  escribir_datos(address, data);

  Serial.print("address:");
  Serial.println(address);
  Serial.print("data:");
  Serial.println(leer_datos(address));
}

void loop() {
  if (!loopExecuted) {
    // Execute this block only once
    unsigned long address = 0;
    Serial.print("address:");
    Serial.println(address);
    Serial.print("data:");
    Serial.println(leer_datos(address));

    for (address = 0; address <= 20; address++) {
      unsigned long data = address;
      escribir_datos(address, data);
      delayMicroseconds(1);
      Serial.print("address:");
      Serial.println(address);
      Serial.print("data:");
      Serial.println(leer_datos(address));
      delayMicroseconds(1);
    }
    delay(1);

//////////////////////////////////////////////////////////
    for (address = 0; address <= 20; address++) {
      // Read from FPGA
      
      //Serial.print("address:");
      //Serial.println(address);
      //Serial.print("data:");
      //Serial.println(leer_datos(address));
      //delayMicroseconds(1);

      // Set data pins as inputs
      for (int pin = DATA_PINS_START; pin <= DATA_PINS_END; pin++) {
        pinMode(pin, INPUT);
      }
      delayMicroseconds(1);

      // Enable FPGA
      digitalWrite(enable_fpga, HIGH);
      digitalWrite(enable_fpga, LOW);
      digitalWrite(WE, HIGH);
      digitalWrite(OE, LOW);
      delayMicroseconds(100);

      // Perform the sum operation in the FPGA (not shown in this code)

      // Write operation from FPGA
      digitalWrite(WE, LOW);
      digitalWrite(OE, HIGH);
      delayMicroseconds(1);

      // Disable FPGA
      digitalWrite(enable_fpga, LOW);
      delayMicroseconds(1);
    }
    delay(1);



///////////////////////////////////



    // Read back data
    for (address = 0; address <= 20; address++) {
      unsigned long data = leer_datos(address);
      Serial.print("address_fpga:");
      Serial.println(address);
      Serial.print("data_fpga:");
      Serial.println(data);
      delayMicroseconds(1);
    }
    delay(1);

    loopExecuted = true; // Mark the loop as executed
  }
}

unsigned long leer_datos(unsigned long address) {
  SetAddress(address);
  delayMicroseconds(1);

  // Set data pins as inputs
  for (int pin = DATA_PINS_START; pin <= DATA_PINS_END; pin++) {
    pinMode(pin, INPUT);
  }
  delayMicroseconds(1);

  // Set control pins for read
  digitalWrite(WE, HIGH);
  digitalWrite(OE, LOW);
  delayMicroseconds(1);

  // Read data from data pins
  unsigned long dataram = 0;
  for (int pin = DATA_PINS_END; pin >= DATA_PINS_START; pin--) {
    dataram = (dataram << 1) | digitalRead(pin);
  }

  return dataram;
}

void escribir_datos(unsigned long address, unsigned long data) {
  SetAddress(address);
  delayMicroseconds(1);

  // Set control pins for write
  digitalWrite(WE, LOW);
  digitalWrite(OE, HIGH);
  delayMicroseconds(1);

  // Set data pins as outputs and write data
  for (int pin = DATA_PINS_START; pin <= DATA_PINS_END; pin++) {
    pinMode(pin, OUTPUT);
    digitalWrite(pin, (data >> (pin - DATA_PINS_START)) & 0x0001);
  }
  delayMicroseconds(1);
}

void SetAddress(unsigned long address) {
  for (int pin = ADDR_PINS_START; pin <= ADDR_PINS_END; pin++) {
    pinMode(pin, OUTPUT);
    digitalWrite(pin, (address >> (pin - ADDR_PINS_START)) & 0x0001);
  }
}
