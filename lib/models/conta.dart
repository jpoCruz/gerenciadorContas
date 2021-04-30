class Conta{
  int id;
  String nome;
  String valor;
  String data;

  contaMap(){
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['nome'] = nome;
    mapping['valor'] = valor;
    mapping['data'] = data;

    return mapping;
  }
}