import 'dart:convert'; // Para converter os dados em JSON
import 'dart:io'; // Para manipulação de arquivos
import 'dart:async'; //importando o timeout
import '../assets/index.dart';

//{type: String, field: name}
typedef DataModel = Map<String, dynamic>;

class Model {
  List<DataModel> _attr = [];
  String _name = "";
  String _filePath = "./Sequencelizer/assets";
  final availableTypes = ["String", "double", "bool", "int"];

  void populate(String modelName, List<DataModel> dataModel) {
    dataModel.forEach((model) {
      if (model.keys.length == 2 &&
          model.keys.contains("type") &&
          model.keys.contains("field") &&
          modelName.isNotEmpty) {
        model.entries.forEach((action) {
          if (action.key.contains('type')) {
            if (!availableTypes.contains(action.value.toString()))
              throw Exception("DataModel passed is not formatted");
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

  Future<bool> checkFile() async {
    File arquivo = File('${this._filePath}/${this._name}.json');
    return await arquivo.exists();
  }

  checkModelStructure(List<DataModel> dataModel) async {
    File jsonFile = File('${this._filePath}/${this._name}.json');
    final jsonString = await jsonFile.readAsString();
    final jsonData = jsonDecode(jsonString);
    var data = jsonData[this._name];
    data = data.length > 0 ? data[0] : {};

    //Transformando o modelo enviado para o array de valores do field
    ////Itarable eh uma iterface e List eh uma subclasse de Iterable
    Iterable<String> modelTemp = dataModel.map((el) => el['field']);
    //Verificar se o field que foi enviado bate com o existente
    data.entries.forEach((element) {
      String fieldKey = element.key;
      if (!modelTemp.contains(fieldKey))
        throw Exception("Model sent doesn't match with actual model");
    });
  }

  Future<Sequencelizer> index(
    String modelName,
    List<DataModel> dataModel,
  ) async {
    print("Start model checking");
    this.populate(modelName, dataModel);
    await Future.delayed(Duration(seconds: 2));
    print("Check modeling existance");
    var checked = await this.checkFile();
    //Verifica se o arquivo ja exite dentro da pasta
    if (!checked) {
      await Future.delayed(Duration(seconds: 2));
      print("Population is finished");
      await this.createModel();
      await Future.delayed(Duration(seconds: 2));
      print("Model created");
    } else {
      await this.checkModelStructure(dataModel);
      print("Model validated");
    }

    //Vamos criar a instancia do Sequencelizer
    print("Sequencelizer initializing");
    return Sequencelizer(modelTemp: this);
  }

  attrText() {
    return "Model name: ${this._name}, Model Structure: ${this._attr}";
  }

  get attr {
    return this._attr;
  }

  get name {
    return this._name;
  }
}
