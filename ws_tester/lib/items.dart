class items {
  int id;
  String title;
  int price;
  bool isVeg;
  String imageUrl;
  String descritpion;

  items(
      {this.id,
      this.title,
      this.price,
      this.isVeg,
      this.imageUrl,
      this.descritpion});

  items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    isVeg = json['isVeg'];
    imageUrl = json['imageUrl'];
    descritpion = json['descritpion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['isVeg'] = this.isVeg;
    data['imageUrl'] = this.imageUrl;
    data['descritpion'] = this.descritpion;
    return data;
  }
}
