class Triple<F,S,T> {
  F first;
  S second;
  T third;

  Triple({this.first, this.second, this.third});

  @override
  String toString() {
    return '${this.first} ${this.second} ${this.third}';
  }

}