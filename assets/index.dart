import 'dart:convert'; // Para converter os dados em JSON
import 'dart:io'; // Para manipulação de arquivos
import '../models/Model.dart';

class Sequencelizer {
  Model? modelTemp; //pode ser nulable
  String mainPath = "./Sequencelizer/assets";
  File? jsonFile;
  List<dynamic> _modelKeys = [];

  Sequencelizer({this.modelTemp}) {
    this.modelTemp = modelTemp;
    if (this.modelTemp!.name.length == 0)
      throw Exception("Name of model is invalid");

    this.jsonFile = File('${this.mainPath}/${this.modelTemp!.name}.json');
    List models = this.modelTemp!.attr;
    this._modelKeys = models.map((item) => item['field']).toList();
  }
  _readAndTransform() async {
    final jsonString = await this.jsonFile!.readAsString();
    return jsonDecode(jsonString);
  }

  // Encontra um no modelo
  findWhere(String field, String value) async {
    if (!this._modelKeys.contains(field))
      throw Exception("The name of the field does not match the model");
    Map data = await this._readAndTransform();
    List dataList = data[this.modelTemp!.name];
    return dataList.where((item) => item[field]?.contains(value) ?? false);
  }

  //Recupera todos do modelo
  Future<List> findAll() async {
    Map data = await this._readAndTransform();
    return data[this.modelTemp!.name];
  }

  //Cria um registro
  Future createOne(Map<String, dynamic> bodySent) async {
    if (this.jsonFile == null)
      throw Exception("Create sequencelizer instance first");
    //Validar se as keys enviadas sao do mesmo formato e tipo da do modelo
    List<String> sentKeys = bodySent.keys.toList();
    List<dynamic> sentValues = bodySent.values.toList();
    if (sentKeys.length != _modelKeys)
      throw Exception("Body content is not valid");
    sentKeys.forEach((key) {
      if (!_modelKeys.contains(key))
        throw Exception("Body content is not valid");
    });
    sentValues.forEach((values) {
      if (this.modelTemp!.availableTypes.contains("")) {
        throw Exception("Body senti is not valid");
      }
    });
    //Recuperar o arquivo, adicionar um usuario ao array de usuarios
    Map data = await this._readAndTransform();
    data[this.modelTemp!.name].add(bodySent);
    //Salvar arquivo
    String jsonEncoded = jsonEncode(data);
    this.jsonFile!.writeAsString(jsonEncoded);
  }

  //Deleta um registro
  deleteOne() {
    print("Done");
  }

  //Altera um registro
  updateOne() {
    print("Done");
  }
}
