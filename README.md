## Integrantes

- Integrante 1: **Kauã Neres Moura**
- Integrante 2: **[PREENCHER: nome completo]**
- Integrante 3: **[PREENCHER: nome completo]**
- Integrante 4: **[PREENCHER: nome completo]**

Os quatro nomes completos não foram encontrados no repositório. Esta documentação permanece pendente de preenchimento da identificação da equipe exigida pela Seção 10.

## Nome do projeto

**Purple-Term** é o nome visual da aplicação. O nome técnico no `pubspec.yaml` é `avaliacao_pg_mobile_flutter_01`, com versão `1.0.0+1`.

## Descrição

Projeto acadêmico de Jogo da Forca desenvolvido em Flutter e Dart para a 1ª Avaliação da disciplina Programação para Dispositivos Móveis, ministrada pelo professor Eyder Rios, da UESPI.

O objetivo previsto é descobrir uma resposta por tentativas de letras antes de esgotar as chances, com categorias, dificuldades e dicas fornecidas por um JSON local. A aplicação deve funcionar integralmente offline.

Atualmente, estão implementados a modelagem, o carregamento e a filtragem dos dados, o tema visual e a tela de configuração. Confirmar a configuração apenas exibe uma mensagem de integração pendente; ainda não é possível jogar uma rodada completa.

## Principais funcionalidades

O estado abaixo corresponde ao código existente, considerando os requisitos fornecidos para a avaliação.

| Requisito | Estado | Implementação atual e pendências |
| --- | --- | --- |
| RF01 — Início do jogo e configuração da partida | Parcial | `SetupScreen` permite selecionar categoria e dificuldade e confirmar a escolha. O início efetivo da partida está pendente. |
| RF02 — Categorias e níveis de dificuldade | Implementado | O repository fornece as opções disponíveis nos dados; a tela apresenta rótulos em português e dificuldades da categoria selecionada. |
| RF03 — Sorteio da resposta | Pendente | `findEntries()` filtra respostas, mas não realiza sorteio. |
| RF04 — Não repetição de respostas na mesma sessão | Pendente | Não há controle de sessão ou histórico de respostas sorteadas. |
| RF05 — Tentativa de letras | Pendente | Não há entrada de tentativas nem motor do jogo. |
| RF06 — Tratamento de acentuação e caracteres não alfabéticos | Parcial | A modelagem preserva acentos, espaços e hífens. Comparação de letras e tratamento desses caracteres durante a partida estão pendentes. |
| RF07 — Controle de erros | Pendente | Não há contagem ou limite de erros de tentativas. |
| RF08 — Representação gráfica progressiva da forca | Pendente | Não há desenho progressivo nem tela da partida. |
| RF09 — Sistema de dicas | Parcial | As dicas são carregadas em `AnswerEntry.hints`; seu uso durante o jogo está pendente. |
| RF10 — Condição de vitória | Pendente | Não há regra de vitória implementada. |
| RF11 — Condição de derrota | Pendente | Não há regra de derrota implementada. |
| RF12 — Nova rodada | Pendente | O botão de configuração ainda não inicia rodadas; não há fluxo de reinício. |
| RF13 — Estatísticas da sessão | Pendente | Não há registro de resultados ou estatísticas. |
| RF14 — Identificação dos integrantes | Pendente | Não há identificação da equipe na interface e os nomes completos precisam ser preenchidos neste README. |

### Divisão de responsabilidades

| Integrante | Responsabilidade prevista | Estado observado |
| --- | --- | --- |
| 1 | Dados, modelagem, carregamento do JSON, repository e configuração da partida | Classes de dados e tela de configuração presentes. |
| 2 | Motor do jogo, tentativas, acentuação e regras de vitória e derrota | Motor e regras ainda ausentes. |
| 3 | Interface da partida, representação da forca e responsividade | Há tema e configuração com rolagem e largura limitada; interface da partida e forca pendentes. |
| 4 | Sessão, sorteio sem repetição, resultados, estatísticas e navegação | Gerenciamento da sessão e navegação para o jogo pendentes. |

Essa divisão descreve o planejamento informado para a equipe, sem atribuir autoria dos arquivos.

## Tecnologias utilizadas

- **Flutter**: interface e empacotamento dos recursos locais. O `pubspec.yaml` não fixa uma versão do Flutter SDK.
- **Dart**: linguagem da aplicação; restrição de SDK `^3.13.5` no `pubspec.yaml` (a partir de `3.13.5` e abaixo de `4.0.0`).
- **Material Design 3**: componentes e tema, com `useMaterial3: true` e `uses-material-design: true`.
- **JSON e `dart:convert`**: armazenamento local e desserialização das respostas.
- **`cupertino_icons: ^1.0.8`**: dependência declarada para ícones Cupertino; não foi encontrado uso nos arquivos de `lib/`.
- **`flutter_test`**: dependência do Flutter SDK para testes unitários e de widgets.
- **`flutter_lints: ^6.0.0`**: regras de análise habilitadas em `analysis_options.yaml`.

As versões acima são as restrições declaradas no projeto, não uma indicação da versão instalada no ambiente.

## Pré-requisitos

Para desenvolver e executar pelo código-fonte:

- Git para clonar o repositório.
- Flutter SDK instalado e disponível no terminal, incluindo um Dart SDK compatível com `^3.13.5`.
- Ferramentas Android configuradas, incluindo Android SDK e JDK compatível com a configuração do projeto, que utiliza Java 17.
- Dispositivo Android com depuração USB habilitada ou emulador Android configurado e em execução.

Android Studio pode ser utilizado para configurar o SDK e o emulador. A obtenção inicial do código, das ferramentas e das dependências pode exigir internet.

Para usar o aplicativo Android já compilado e instalado, basta um dispositivo compatível com a compilação: não são necessários Flutter SDK, Dart SDK, Git ou ferramentas de desenvolvimento. A versão mínima do Android é delegada a `flutter.minSdkVersion` em `android/app/build.gradle.kts`; não há um número fixado nesse arquivo.

## Instalação e execução

O endereço abaixo corresponde ao remoto `origin` do repositório. Por utilizar SSH, exige acesso ao GitHub com chave SSH configurada.

```bash
git clone git@github.com:ericSilvaP/avaliacao_pg_mobile_flutter_01.git
cd avaliacao_pg_mobile_flutter_01
flutter pub get
flutter devices
flutter run
```

Execute os comandos Flutter na raiz do projeto. Com mais de um dispositivo disponível, selecione o destino com `flutter run -d <identificador_do_dispositivo>`, substituindo o marcador por um identificador listado por `flutter devices`.

A aplicação abre a tela de configuração. Selecione categoria e dificuldade, toque em “INICIAR RODADA” e confirme no diálogo. No estado atual, a confirmação exibe uma `SnackBar` informando que a integração com o jogo está pendente.

## Estrutura do projeto

Árvore simplificada dos arquivos e diretórios relevantes existentes:

```text
.
├── README.md
├── pubspec.yaml
├── pubspec.lock
├── analysis_options.yaml
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
├── assets/
│   ├── data/
│   │   └── hangman.json
│   ├── fonts/
│   │   ├── Outfit-Regular.ttf
│   │   ├── Outfit-SemiBold.ttf
│   │   ├── Outfit-Bold.ttf
│   │   ├── PlusJakartaSans-Regular.ttf
│   │   └── PlusJakartaSans-SemiBold.ttf
│   └── images/
│       ├── purple-term-logo.png
│       └── purple-term-dead-logo.png
├── lib/
│   ├── main.dart
│   ├── data/
│   │   ├── models/
│   │   │   └── answer_entry.dart
│   │   ├── repositories/
│   │   │   ├── answer_repository.dart
│   │   │   └── local_answer_repository.dart
│   │   └── sources/
│   │       └── answer_local_data_source.dart
│   ├── domain/
│   │   └── enums/
│   │       ├── answer_category.dart
│   │       └── difficulty.dart
│   ├── features/
│   │   └── setup/
│   │       ├── setup_screen.dart
│   │       └── widgets/
│   │           ├── setup_async_dropdown_field.dart
│   │           ├── setup_dropdown_field.dart
│   │           ├── setup_header.dart
│   │           └── setup_start_button.dart
│   └── shared/
│       ├── presentation/
│       │   └── enum_labels.dart
│       └── theme/
│           ├── app_colors.dart
│           └── app_theme.dart
└── test/
    ├── answer_entry_test.dart
    ├── answer_local_data_source_test.dart
    ├── answer_repository_test.dart
    ├── enum_labels_test.dart
    ├── setup_screen_test.dart
    └── widget_test.dart
```

- `lib/data/models/`: representação e validação das entradas do JSON.
- `lib/data/sources/`: leitura e desserialização do arquivo local.
- `lib/data/repositories/`: contrato de acesso aos dados e implementação com filtragem.
- `lib/domain/enums/`: valores de categoria e dificuldade.
- `lib/features/setup/`: tela de configuração e seus componentes.
- `lib/shared/`: rótulos em português, cores, tipografia e tema compartilhados.
- `assets/`: dados, fontes e imagens empacotados na aplicação.
- `test/`: testes de dados, rótulos, configuração e abertura da aplicação.
- `android/`, `ios/`, `linux/`, `macos/`, `web/` e `windows/`: arquivos de suporte às plataformas gerados pelo Flutter; sua presença não comprova validação em todas elas.

## Carregamento e modelagem dos dados

### Arquivo local e registro

O arquivo de respostas utilizado é `assets/data/hangman.json`. Ele contém um objeto raiz com a lista `entries`; cada entrada possui `answer`, `category`, `difficulty` e `hints`.

O registro existente em `pubspec.yaml` inclui:

```yaml
flutter:
  assets:
    - assets/data/hangman.json
    - assets/images/purple-term-logo.png
    - assets/images/purple-term-dead-logo.png
```

Esse registro permite ao Flutter incluir os arquivos no pacote do aplicativo. Não foi encontrado documento da avaliação para confirmar a procedência ou a versão oficial do JSON; o fluxo descrito é o do arquivo presente no repositório.

### Leitura e conversão para objetos

`AnswerLocalDataSource` recebe opcionalmente um `AssetBundle` e utiliza `rootBundle` por padrão. Seu método `loadEntries()`:

1. Lê o recurso com `_bundle.loadString()` no caminho `assets/data/hangman.json`.
2. Desserializa o texto com `jsonDecode()`, de `dart:convert`.
3. Valida o objeto raiz, a lista `entries` não vazia e a estrutura de cada entrada.
4. Converte cada objeto com `AnswerEntry.fromJson()`.
5. Retorna uma lista não modificável de `AnswerEntry`.

`AnswerEntry` armazena `answer`, `category`, `difficulty` e `hints`. Sua fábrica valida resposta e dicas não vazias, converte os valores enumerados e cria uma lista não modificável de dicas. Estruturas inválidas e valores enumerados desconhecidos geram `FormatException`; outras falhas de carregamento são encapsuladas em uma exceção com contexto.

### Valores enumerados

Os valores do JSON são convertidos com `AnswerCategory.values.byName()` e `Difficulty.values.byName()`. Os identificadores permanecem em inglês; as extensões `AnswerCategoryLabel` e `DifficultyLabel`, em `enum_labels.dart`, fornecem o getter `label` para a interface.

| Enum | Valores e rótulos apresentados |
| --- | --- |
| `AnswerCategory` | `animals`: Animais; `humanBody`: Corpo humano; `sports`: Esportes; `technology`: Tecnologia. |
| `Difficulty` | `easy`: Fácil; `medium`: Médio; `hard`: Difícil. |

### Acesso pelo repository

`AnswerRepository` define o contrato implementado por `LocalAnswerRepository`:

- `getCategories()`: retorna as categorias presentes nas entradas.
- `getDifficulties(AnswerCategory category)`: retorna as dificuldades disponíveis para a categoria informada.
- `findEntries({required AnswerCategory category, required Difficulty difficulty})`: retorna as entradas que correspondem aos dois filtros.

`LocalAnswerRepository` mantém o resultado assíncrono do carregamento em `_entries`, inicializado no primeiro acesso e reutilizado pela mesma instância. As listas retornadas são não modificáveis; categorias e dificuldades seguem a ordem dos enums. O repository fornece os dados filtrados, mas não sorteia respostas nem gerencia a sessão.

### Preservação da grafia

`AnswerEntry.fromJson()` atribui a string recebida diretamente a `answer`. O uso de `trim()` serve apenas à validação de conteúdo vazio; não altera a resposta armazenada. Espaços, acentos e hífens são preservados, como em `MÃO DIREITA`, `CLIENTE-SERVIDOR` e `ARTICULAÇÃO TÊMPORO-MANDIBULAR`.

Essa preservação dos dados já existe. A normalização para comparar tentativas e o tratamento de espaços e hífens na exibição da partida dependem do motor do jogo ainda pendente.

## Interface e tema visual

`main.dart` inicializa o Flutter com `WidgetsFlutterBinding.ensureInitialized()`, cria `LocalAnswerRepository(AnswerLocalDataSource())` e o injeta em `MyApp`. O `MaterialApp` utiliza o título `Purple-Term`, abre `SetupScreen` e aplica `AppTheme.dark()` com `ThemeMode.dark`.

`AppColors` centraliza a paleta escura com tons roxos. `AppTheme` configura Material Design 3, cores, tipografia e estilos de campos, botões, cartões e diálogos. `AppSpacing`, `AppRadius` e `AppTextStyles` também estão definidos em `app_theme.dart`.

As famílias **Outfit** e **Plus Jakarta Sans** são registradas em `pubspec.yaml` a partir de arquivos locais em `assets/fonts/`. Outfit é utilizada em títulos e rótulos; Plus Jakarta Sans, no texto geral. A tela inicial usa `purple-term-logo.png`. A imagem `purple-term-dead-logo.png` está registrada, mas não há fluxo de derrota que a utilize.

`SetupScreen` consulta o repository para preencher categoria e dificuldade. Alterar a categoria limpa a dificuldade anterior; o botão só é habilitado quando ambas estão selecionadas. A tela mostra um resumo da escolha, solicita confirmação e chama `onStart`. Há estados de carregamento, erro, lista vazia e ações para tentar novamente.

A configuração utiliza `SafeArea`, `ListView` e largura máxima de 448 pixels lógicos, além de diálogo com rolagem. Isso atende à organização da tela existente; a responsividade da interface da partida ainda depende de sua implementação. Em `main.dart`, `onStart` apenas apresenta uma `SnackBar`, sem sorteio, regras ou gerenciamento de sessão.

## Testes e qualidade de código

Na raiz do projeto, após obter as dependências, execute:

```bash
dart format .
flutter analyze
flutter test
```

`dart format .` formata os arquivos Dart e pode modificá-los. `flutter analyze` executa a análise estática com as regras de `flutter_lints`. `flutter test` executa os testes presentes em `test/`.

| Arquivo | Objetivo dos testes existentes |
| --- | --- |
| `answer_entry_test.dart` | Desserialização, preservação de acentos e hífens e rejeição de categoria ou dificuldade desconhecida. |
| `answer_local_data_source_test.dart` | Carregamento do JSON empacotado e preservação de respostas com grafia complexa. |
| `answer_repository_test.dart` | Categorias, dificuldades, filtragem de todas as combinações e lista de respostas não modificável. |
| `enum_labels_test.dart` | Rótulos em português para todos os valores dos enums. |
| `setup_screen_test.dart` | Seleção, confirmação, cancelamento, limpeza da dificuldade, estados de carregamento, erro e lista vazia, semântica de acessibilidade e tela pequena com texto ampliado. |
| `widget_test.dart` | Abertura de `MyApp` na tela de configuração. |

Esses testes cobrem os módulos existentes; não comprovam regras de jogo ou sessão ainda não implementadas. Os comandos de formatação, análise e testes não foram executados nesta atualização exclusivamente documental, e não se afirma aprovação da suíte.

## Funcionamento offline

O código atual carrega respostas e dicas do JSON local, além de fontes e imagens empacotadas. Não utiliza banco de dados, Firebase ou serviços equivalentes, APIs REST, autenticação de usuários, backend remoto ou armazenamento remoto.

Conforme as restrições informadas para a avaliação, essas dependências externas não devem ser introduzidas. O fluxo implementado de configuração funciona com recursos locais; a partida completa ainda precisa ser implementada e validada offline. A necessidade de internet para preparar o ambiente ou obter dependências de desenvolvimento é distinta do uso do aplicativo instalado.

## Pendências de documentação

- Preencher os nomes completos dos quatro integrantes no início deste arquivo. Sem isso, a exigência de identificação da Seção 10 permanece pendente.
- Conferir esta documentação com o enunciado original: nenhum documento da avaliação foi encontrado no repositório. Os requisitos e o contexto acadêmico aqui descritos foram fornecidos na tarefa de documentação.
- Confirmar com o material da disciplina a procedência e a versão oficial de `assets/data/hangman.json`.
