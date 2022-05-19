class CustomerModel {
  final String customerId;
  final String customerName;
  final String customerTel;
  final String customerAddress;

  CustomerModel(
      {required this.customerName,
      required this.customerTel,
      required this.customerAddress,
      required this.customerId});
}
