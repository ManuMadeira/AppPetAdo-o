# CRUD de Pets - Aplicação Flutter

## Tema da Aplicação
Este aplicativo é uma plataforma para controle e visualização de animais disponíveis para adoção, permitindo que tutores temporários gerenciem de forma simples a lista de pets. 

## Classe de Negócio (Modelo)
A estrutura de dados central da aplicação utiliza a classe `Pet`, que possui as seguintes propriedades:
* `id`: Identificador único gerado por timestamp.
* `nome`: Nome do pet.
* `especie`: Espécie do animal (ex: Cachorro, Gato).
* `tutor`: Nome do responsável/tutor temporário.
* `idade`: Idade aproximada informada no cadastro.
* `sexo`: Gênero do animal (Fêmea ou Macho).

### Fluxo de Conversão e Serialização (JSON)
1. **Serialização (`toJson`)**: Transforma os atributos da classe `Pet` em um mapa chave-valor (`Map<String, dynamic>`), preparando os dados para codificação.
2. **Desserialização (`fromJson`)**: Reconstrói a instância da classe `Pet` a partir de uma estrutura de mapa obtida.

## Fluxo do CRUD e Persistência
* **Create (Cadastro)**: Inicia-se a partir do botão "Adicionar mais um animal" na tela principal. O formulário valida os dados obrigatórios e adiciona o objeto à lista existente.
* **Read (Leitura)**: No momento em que a aplicação inicia, a `ListPage` consome de forma assíncrona o método `carregarPets()` do repositório local.
* **Update (Edição)**: Ao clicar no ícone de lápis em um card de animal, o objeto selecionado é injetado no formulário, carregando os dados para modificação. Ao salvar, substitui a ocorrência antiga no índice mapeado.
* **Delete (Remoção)**: Clicar no ícone de lixeira dispara um diálogo de confirmação (`showDialog`). Em caso positivo, o pet é filtrado para fora da lista.

### Funcionamento do SharedPreferences
Toda a alteração na lista de objetos dispara a chamada para o `PetRepository`. A persistência utiliza o método `jsonEncode()` para transformar a lista completa de objetos `Pet` mapeados em uma única `String` JSON compactada, salvando-a localmente sob a chave fixa `'lista_pets'`. Ao reabrir o app, o processo inverso com `jsonDecode()` reconstrói a árvore de objetos em memória.