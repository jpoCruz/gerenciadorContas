import 'package:gerenciador_contas/models/conta.dart';
import 'package:gerenciador_contas/repositories/repository.dart';

class ContaService{
  Repository _repository;

  ContaService(){
    _repository = Repository();
  }

  //criando dados
  saveConta(Conta conta) async{
    return await _repository.insertData('contas', conta.contaMap());
  }

  readConta() async {
    return await _repository.readData('contas');
  }

  readContaPorId(contaId) async{
    return await _repository.readDataById('contas', contaId);
  }

  editConta(Conta conta) async{
    return await _repository.edidarDados('contas', conta.contaMap());
  }

  deleteConta(contaId) async{
    return await _repository.deletarDados('contas', contaId);
  }
}