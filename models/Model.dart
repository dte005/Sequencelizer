import 'dart:convert'; // Para converter os dados em JSON
import 'dart:io'; // Para manipulação de arquivos
import 'dart:async'; //importando o timeout
import '../assets/index.dart';

class Model {
  //{type: String, field: name}
  List _attr = [];
  String _name = "";
  String _filePath = "./Sequencelizer/assets";

  void populate(String modelName, List<Map<String, dynamic>> dataModel) {
    dataModel.forEach((model) {
      if (model.keys.length == 2 &&
          model.keys.contains("type") &&
          model.keys.contains("field") &&
          modelName.isNotEmpty) {
        model.entries.forEach((action) {
          if (action.key.contains('type')) {
            if (!action.value.toString().contains('String') &&
                !action.value.toString().contains('double') &&
                !action.value.toString().contains('bool') &&
                !action.value.toString().contains('int')) {
              throw Exception("DataModel passed is not formatted");
            }
          }
        });
        this._attr.add(model);
      }
    });
    this._name = modelName;
  }

  //Criar um arquivo json de model
  Future<void> createModel() async {
    String jsonData = jsonEncode({"${this._name}": []});
    File arquivo = File('${this._filePath}/${this.name}.json');
    try {
      await arquivo.create();
      await arquivo.writeAsString(jsonData);
    } catch (e) {
      print(arquivo);
      throw Exception(e);
    }
  }

  Future<void> checkFile() async {
    File arquivo = File('${this._filePath}/${this._name}.json');
    if (await arquivo.exists()) {
      throw Exception("Model already exists");
    }
  }

  Future<Sequencelizer> index(
    String modelName,
    List<Map<String, dynamic>> dataModel,
  ) async {
    print("Start model checking");
    this.populate(modelName, dataModel);
    await Future.delayed(Duration(seconds: 2));
    print("Check modeling existance");
    await this.checkFile();
    await Future.delayed(Duration(seconds: 2));
    print("Population is finished");
    await this.createModel();
    await Future.delayed(Duration(seconds: 2));
    print("Model created");

    //Vamos criar a instancia do Sequencelizer
    print("Sequencelizer initializing");
    return Sequencelizer(modelTemp: this);
  }

  get attr {
    return "Model name: ${this._name}, Model Structure: ${this._attr}";
  }

  get name {
    return this._name;
  }
}
