double mapNum(double input, inputA, inputZ, outputA, outputZ) {
  return (input - inputA) / (inputZ - inputA) * (outputZ - outputA) + outputA;
}