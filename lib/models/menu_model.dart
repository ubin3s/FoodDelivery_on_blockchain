class MenuModel {
  final String menuId;
  late int menuPrice;
  late String menuName;
  late String menuDescript;
  final String restuarantMenuId;

  MenuModel(
      {required this.restuarantMenuId,
      required this.menuId,
      required this.menuName,
      required this.menuPrice,
      required this.menuDescript});
}
