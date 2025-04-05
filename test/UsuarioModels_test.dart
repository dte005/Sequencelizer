import 'dart:io';
import 'package:test/test.dart';
import '../models/UsuarioModels.dart';

void main() {
  group('Testando manipulação de arquivos', () {
    final caminhoArquivo = 'test_arquivo.txt';

    // Teste para escrever no arquivo
    test('Deve escrever no arquivo com sucesso', () async {
      // Ação
      // await escreverArquivo(caminhoArquivo, 'Conteúdo de teste');

      // Verificação
      final arquivo = File(caminhoArquivo);
      final conteudo = await arquivo.readAsString();
      expect(conteudo, 'Conteúdo de teste');
    });

    // Teste para ler o arquivo
    test('Deve ler o arquivo com sucesso', () async {
      // Garantindo que o arquivo tenha conteúdo para ler
      // await escreverArquivo(caminhoArquivo, 'Conteúdo de leitura');

      // Ação e verificação
      // final conteudoLido = await lerArquivo(caminhoArquivo);
      // expect(conteudoLido, 'Conteúdo de leitura');
    });
  });
}
