import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gerenciador_contas/models/conta.dart';
import 'package:gerenciador_contas/services/conta_service.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home>{
  var _nomeDaConta = TextEditingController();
  var _valorDaConta = TextEditingController();
  var _dataController = TextEditingController();

  var _editarNomeDaConta = TextEditingController();
  var _editarValorDaConta = TextEditingController();


  var _conta = Conta();
  var _contaService = ContaService();

  List<Conta> _contaList = List<Conta>();

  var conta;

  @override
  void initState(){
    super.initState();
    getAllContas();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();


  getAllContas() async {
    _contaList = List<Conta>();
    var contas = await _contaService.readConta();
    contas.forEach((conta) {
      setState(() {
        var contaModel = Conta();
        contaModel.nome = conta['nome'];
        contaModel.valor = conta['valor'];
        contaModel.id = conta['id'];
        contaModel.data = conta['data'];
        _contaList.add(contaModel);
      });
    });
  }

  _editarConta(BuildContext context, contaId) async{
    conta = await _contaService.readContaPorId(contaId);
    setState(() {
      _editarNomeDaConta.text = conta[0]['nome'] ?? 'Sem nome';
      _editarValorDaConta.text = conta[0]['valor'] ?? 'Sem valor';
    });
    _showEditDialog(context);
  }

  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _dataController.text = DateFormat('dd-MM-yyyy').format(_pickedDate);
      });
    }
  }


  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                  onPressed: () async{
                    _conta.nome = _nomeDaConta.text;
                    _conta.valor = _valorDaConta.text;
                    _conta.data = _dataController.text;
                    //_contaService.saveConta(_conta);

                    if(_conta.nome != "" && _conta.valor!= "" && _conta.data!= "") {
                      var result = await _contaService.saveConta(_conta);
                      print(result);
                      Navigator.of(context, rootNavigator: true).pop();
                      getAllContas();
                      _nomeDaConta.text = "";
                      _valorDaConta.text = "";
                      _dataController.text = "";
                    }else{
                      Navigator.of(context, rootNavigator: true).pop();
                      _nomeDaConta.text = "";
                      _valorDaConta.text = "";
                      _dataController.text = "";
                      _showSuccessSnackBar(Text('Impossível inserir uma conta com campos vazios'));
                    }
                  },
                  child: Text('Adicionar')
              ),
              TextButton(
                  //color: Colors.tealAccent,
                  onPressed: () =>Navigator.of(context, rootNavigator: true).pop(),
                  child: Text('Cancelar')
              ),
            ],
            title: Text('Adicionar Conta'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _nomeDaConta,
                    decoration: InputDecoration(
                      hintText: 'Nome da conta',
                          labelText: 'Nome'
                    ),
                  ),
                  TextField(
                    controller: _valorDaConta,
                    decoration: InputDecoration(
                        hintText: 'Valor da conta',
                        labelText: 'Valor'
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _dataController,
                    decoration: InputDecoration(
                      labelText: 'Data de vencimento',
                      hintText: 'Escolha a data de vencimento',
                      prefixIcon: InkWell(
                        onTap: () {
                          _selectedTodoDate(context);
                        },
                        child: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showEditDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                  onPressed: () async{
                    _conta.id = conta[0]['id'];
                    _conta.nome = _editarNomeDaConta.text;
                    _conta.valor = _editarValorDaConta.text;

                    var result = await _contaService.editConta(_conta);
                    print(result);
                    //Navigator.pop(context);
                    Navigator.of(context, rootNavigator: true).pop();
                    getAllContas();
                    _showSuccessSnackBar(Text('Conta editada'));
                  },
                  child: Text('Salvar')
              ),
              TextButton(
                //color: Colors.tealAccent,
                  onPressed: () =>Navigator.of(context, rootNavigator: true).pop(),
                  child: Text('Cancelar')
              ),
            ],
            title: Text('Editar Conta'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editarNomeDaConta,
                    decoration: InputDecoration(
                        hintText: 'Nome da conta',
                        labelText: 'Nome'
                    ),
                  ),
                  TextField(
                    controller: _editarValorDaConta,
                    decoration: InputDecoration(
                        hintText: 'Valor da conta',
                        labelText: 'Valor'
                    ),
                    keyboardType: TextInputType.number,
                  )
                ],
              ),
            ),
          );
        });
  }

  _showDeleteDialog(BuildContext context, contaId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  var result =
                  await _contaService.deleteConta(contaId);
                  if (result > 0) {
                    Navigator.of(context, rootNavigator: true).pop();
                    _showSuccessSnackBar(Text('Conta excluída'));
                    setState(() {
                      getAllContas();
                    });

                  }
                },
                child: Text('Sim'),
              ),
            ],
            title: Text('Tem certeza que você quer excluir essa conta?'),
          );
        });
  }

  _showSuccessSnackBar(message){
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'Gerenciador de Contas',
      home: Scaffold(
        key: _globalKey,
        appBar: AppBar(
          title: Text('Gerenciador de Contas'),
        ),
        body: ListView.builder(
            itemCount: _contaList.length, itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.only(top: 0.3),
              child: Card(
                child: ListTile(
                  leading: IconButton(icon: Icon(Icons.edit), onPressed: (){
                    _editarConta(context, _contaList[index].id);
                  }),
                  trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){
                    _showDeleteDialog(context,_contaList[index].id);
                  }),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_contaList[index].nome),
                    ],
                  ),
                  subtitle: Text(_contaList[index].data + '   |   R\$ ' +_contaList[index].valor),
                ),
              ),
            );
        }),


        floatingActionButton: FloatingActionButton(
          onPressed: (){
            _showFormDialog(context);
          },
            child: Icon(Icons.add),
        ),
      ),
    );
  }
}