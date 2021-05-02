class MyObj {
  final String nama;
  final String nim;
  MyObj(this.nama, this.nim);

  @override
  /**
   * 
   * 
   * When we call print( ) method, it will print the String returned from toString() method in your class. Hence, if you don’t override toString() method in your class, the toString()method under Object class will be used. That’s why you see “Instance of ‘ClassName’”:
   * 
   * */
  String toString() {
    return '{nama: $nama, nim: $nim}';
  }
}

void main() {
  List<MyObj> mahasiswa = [
    MyObj('titus', '190'),
    MyObj('titus', '190'),
  ];
  print(mahasiswa);
}
