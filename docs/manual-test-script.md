# Roteiro de teste manual — Jogo da Forca

Este roteiro cobre a seção 10.10 do plano (testes manuais com respostas longas,
acentuadas, com espaços e com hífens) e serve de evidência de validação para o
Definition of Done de cada feature.

**Como executar**

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter run -d edge   # ou -d windows
```

Marcação: ao executar cada caso, anotar `[ok]` ou `[falha]` com o que foi observado.

---

## 1. Configuração da partida (RF01, RF02)

- [ ] O app abre na tela de configuração com o logotipo visível.
- [ ] O dropdown de categorias termina o carregamento e lista as 4 categorias.
- [ ] O dropdown de dificuldade fica desabilitado com a mensagem
      "Selecione uma categoria primeiro" até que uma categoria seja escolhida.
- [ ] O botão "Iniciar partida" fica desabilitado até categoria **e** dificuldade
      estarem selecionadas.
- [ ] Ao escolher categoria e dificuldade, o resumo "Sua escolha" aparece com os
      dois valores.
- [ ] "Iniciar partida" abre o diálogo de confirmação com categoria e dificuldade.
- [ ] "Voltar" no diálogo não inicia a partida.
- [ ] "Iniciar partida" no diálogo avança para a tela de partida.

## 2. Interface da partida e jogabilidade (RF03, RF05, RF06, RF07, RF08, RF09, RF10, RF11, RNF02)

- [ ] A tela de partida exibe cabeçalho com chips de categoria e dificuldade.
- [ ] A figura da forca começa apenas com a estrutura da forca visível.
- [ ] O progresso de erros inicia em "Erros: 0 de 6" com todos os 6 marcadores vazios.
- [ ] O tabuleiro oculta letras jogáveis com traços (`_`) e mantém espaços e hífens visíveis desde o início.
- [ ] O botão "Pedir dica" está visível e habilitado. Ao tocar, exibe o cartão da dica com "Dica utilizada" e não permite novo pedido.
- [ ] O teclado virtual exibe 26 teclas e o seletor de layout (QWERTY / ABC).
- [ ] Ao alternar entre QWERTY e ABC, o layout reorganiza as teclas preservando o estado de acertos e erros.
- [ ] A preferência de layout de teclado é memorizada ao longo de toda a sessão entre partidas.
- [ ] Ao tocar em uma letra correta: a letra é revelada em todas as posições correspondentes no tabuleiro (preservando acentos originais) e a tecla fica em destaque.
- [ ] Ao tocar em uma letra incorreta: a tecla é esmaecida, o contador avança ("Erros: X de 6"), o marcador correspondente é preenchido e uma parte do monstro aparece na ordem fixa (cabeça viva → tronco → braço esquerdo → braço direito → perna esquerda → perna direita).
- [ ] Vitória: ao descobrir todas as letras, surge o banner "Vitória!", o teclado é desabilitado e, após ~5 segundos, o app navega automaticamente para a tela de resultado.
- [ ] Derrota: ao cometer o 6º erro, a cabeça do monstro troca para a versão derrotada (olhos em X), a resposta completa é revelada no tabuleiro, surge o banner "Derrota", o teclado é desabilitado e, após ~5 segundos, o app navega automaticamente para a tela de resultado.
- [ ] Tentativa de abandono: ao tocar na seta de voltar durante a partida, o diálogo "Abandonar rodada?" é exibido. "Continuar jogando" mantém a partida; "Abandonar" cancela a rodada sem contabilizá-la nas estatísticas.
- [ ] Responsividade:
  - Em telas estreitas (< 768 dp) ou com texto aumentado (1.5x), o layout em coluna única acomoda os elementos com espaçamento arejado e rola suavemente sem estouro de pixels (`RenderFlex`).
  - Em telas largas ou tablets (≥ 768 dp), o layout adapta-se em duas colunas (esquerda: forca e progresso de erros; direita: cabeçalho, tabuleiro, dica/status e teclado).

## 3. Casos especiais de respostas (seção 10.10)

Executar o fluxo completo (configurar → rodada → resultado → estatísticas) para
cada resposta abaixo e conferir que acentos, espaços e hífens aparecem sempre
preservados, sem `?` ou caixa alta indevida.

| # | Resposta | Categoria | Dificuldade | O que validar |
|---|----------|-----------|-------------|----------------|
| 1 | ARTICULAÇÃO TÊMPORO-MANDIBULAR | Corpo humano | Difícil | resposta longa + acentuada + hífen; sem estouro de layout |
| 2 | CORRIDA COM OBSTÁCULOS | Esportes | Difícil | resposta longa + acentuada |
| 3 | MÃO DIREITA | Corpo humano | Fácil | acento + espaço |
| 4 | PÉ HUMANO | Corpo humano | Fácil | acento + espaço |
| 5 | PULMÃO | Corpo humano | Médio | acento em palavra curta |
| 6 | CLIENTE-SERVIDOR | Tecnologia | Médio | hífen |
| 7 | ENTRADA-SAÍDA | Tecnologia | Difícil | hífen + acento |
| 8 | PORCO-ESPINHO | Animais | Médio | hífen em nome de animal |

- [ ] Cada resposta da tabela foi exibida corretamente na partida.
- [ ] Cada resposta da tabela apareceu corretamente no resultado.
- [ ] O layout não quebra com a resposta mais longa (em fonte grande, se possível).

> Dica de execução: como o sorteio é aleatório, repetir a abertura da rodada até
> a resposta desejada aparecer, ou usar o estado vazio de "respostas esgotadas"
> da próxima seção para percorrer a combinação inteira.

## 4. Não repetição e esgotamento (RF04)

- [ ] Em uma mesma combinação, iniciar várias rodadas seguidas: nenhuma resposta
      repete enquanto houver disponível (10 respostas por combinação).
- [ ] Ao usar as 10 respostas de uma combinação, a tentativa seguinte exibe o
      diálogo "Rodada indisponível" explicando que as respostas já foram usadas.
- [ ] Trocar para outra combinação volta a sortear normalmente.
- [ ] (Informativo) A mensagem "Não há respostas disponíveis" não é reproduzível
      com os dados atuais: as 12 combinações têm 10 respostas cada.

## 5. Nova rodada e navegação (RF12)

- [ ] "Jogar novamente" no resultado inicia outra rodada preservando as
      estatísticas e o controle de respostas usadas.
- [ ] "Trocar configuração" volta para a tela inicial.
- [ ] "Estatísticas da sessão" abre as estatísticas a partir do resultado e a
      partir da configuração.
- [ ] "Sobre a equipe" abre a tela de identificação (RF14).

## 6. Estatísticas da sessão (RF13)

Após pelo menos uma vitória, uma derrota e uma rodada abandonada:

- [ ] Rodadas realizadas conta apenas as rodadas concluídas (a abandonada não conta).
- [ ] Vitórias e derrotas mostram quantidade **e** percentual (formato pt-BR,
      ex.: `66,7%`), somando 100%.
- [ ] Erros acumulados somam os erros das rodadas concluídas.
- [ ] Dicas utilizadas contam no máximo 1 por rodada.
- [ ] Reiniciar a sessão (reabrir o app) zera todos os indicadores.
- [ ] Com nenhuma rodada, aparece o estado vazio
      "Nenhuma rodada concluída nesta sessão."

## 7. Identificação da equipe (RF14)

- [ ] A tela "Sobre a equipe" exibe os 4 nomes completos:
      Kauã Neres Moura, José Maranhão da Silva Neto, Alan Rodrigues de Castro e
      Eric Silva Patricio.

## 8. Qualidade e ambiente

- [ ] `dart format .` não altera nenhum arquivo.
- [ ] `flutter analyze` sem issues.
- [ ] `flutter test` 100% verde.
- [ ] O app funciona offline (sem qualquer chamada de rede).
- [ ] Tema escuro e fontes personalizadas carregam corretamente.

