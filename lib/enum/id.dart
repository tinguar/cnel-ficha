enum IdType {
  IDENTIFICACION,
  CUENTA_CONTRATO,
  CUEN,
}

final List<Map<String, dynamic>> idTypes = [
  {
    'label': 'Cédula de identidad',
    'value': IdType.IDENTIFICACION,
  },
  {
    'label': 'Número de contrato',
    'value': IdType.CUENTA_CONTRATO,
  },
  {
    'label': 'Código único',
    'value': IdType.CUEN,
  },
];
