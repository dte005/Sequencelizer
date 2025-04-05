import 'dart:convert'; // Para converter os dados em JSON
import 'dart:io'; // Para manipulação de arquivos
import '../models/Model.dart';

class Sequencelizer {
  Model? modelTemp; //pode ser nulable
  String mainPath = "./";
  File? jsonFile;

  Sequencelizer({this.modelTemp}) {
    this.modelTemp = modelTemp;
    if (this.modelTemp!.name.length == 0)
      throw Exception("Name of model is invalid");

    this.jsonFile = File('${this.mainPath}${this.modelTemp!.name}');
  }

  // Encontra um no modelo
  findOne(String field, String value) {
    print("Done");
  }

  //Recupera todos do modelo
  Future findAll() async {
    final jsonString = await this.jsonFile!.readAsString();
    final jsonData = jsonDecode(jsonString);
    return jsonData[this.modelTemp!.name];
  }

  //Cria um registro
  createOne() {
    print("Done");
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
