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

## 2. Rodada provisória, vitória e derrota (RF03, RF10, RF11)

> Enquanto a interface real do Integrante 3 não chegar, a tela de partida é a
> provisória: ela exibe a resposta sorteada e as dicas, e os botões de simulação
> encerram a rodada pelo domínio `GameRound` (vitória = todas as letras reveladas;
> derrota = limite de erros atingido).

- [ ] A tela de partida mostra categoria, dificuldade, resposta sorteada e dicas.
- [ ] "Simular vitória" abre o resultado com "Vitória!", a resposta completa,
      0 erros e dica "Não".
- [ ] "Simular derrota" abre o resultado com "Derrota", a resposta completa,
      6 erros e dica "Não".
- [ ] "Abandonar rodada" volta para a configuração **sem** contar a rodada
      nas estatísticas.

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

---

**Pendência de atualização**: quando a `GameScreen` do Integrante 3 substituir a
tela de partida provisória, revisar os itens 2 e 6 para exercitar teclado de
letras, tecla de dica (RF09) e desenho progressivo da forca (RF08).
