*&---------------------------------------------------------------------*
*& Report ZDLFAJRRP_009_05
*&---------------------------------------------------------------------*
*&
*& Relatório para demonstração de parâmetros, opções de filtro e interação de tela
*&---------------------------------------------------------------------*

REPORT ZDLFAJRRP_009_05.

" Declaração das tabelas usadas no relatório
TABLES: sflight,           " Tabela de voos
        sscrfields.        " Tabela de eventos de tela

" Parâmetros (Filtros individuais)
" Parâmetro para selecionar o código da companhia aérea
PARAMETERS: p_carrid TYPE sflight-carrid.  " Código da companhia aérea

" Opções (Ranges)
" Intervalo de moedas para filtro de passagens aéreas
SELECT-OPTIONS: s_curr FOR sflight-currency.  " Passagem aérea (Moeda)

" Checkbox (Controle binário, verdadeiro ou falso)
PARAMETERS: cx_blog AS CHECKBOX.  " Checkbox para blog

" Radio Buttons (Opções exclusivas de uma escolha)
PARAMETERS: rd_cred RADIOBUTTON GROUP rbg1,  " Opção de crédito
            rb_debt RADIOBUTTON GROUP rbg1.  " Opção de débito

" Quebra de linha para melhor organização na tela de seleção
SELECTION-SCREEN SKIP 1.

" Listbox (Lista de seleção de tipo de arquivo)
PARAMETERS: lb_typ AS LISTBOX VISIBLE LENGTH 30 MODIF ID typ.  " Lista suspensa para selecionar tipos de arquivo

" Quebra de linha
SELECTION-SCREEN SKIP 1.

" Bloco de seleção para definir parâmetros adicionais
SELECTION-SCREEN BEGIN OF BLOCK block WITH FRAME TITLE text-001.
  PARAMETERS: p_block TYPE belnr_d.
SELECTION-SCREEN END OF BLOCK block.

" Botão para interação na tela
SELECTION-SCREEN PUSHBUTTON 1(20) p_but1 USER-COMMAND but1.  " Botão com ação associada

" Botão de função na toolbar
SELECTION-SCREEN FUNCTION KEY 1.

" Inicialização dos valores dos parâmetros e botões
INITIALIZATION.
  p_but1 = '@01@ Carrega aqui'.                 " Texto do botão
  sscrfields-functxt_01 = '@01@ Carrega Aqui'.  " Texto do evento de função

" Ação ao clicar nos botões
AT SELECTION-SCREEN.
  " Verificação do botão clicado e exibição de mensagem apropriada
  IF sscrfields-ucomm = 'BUT1'.
    MESSAGE 'Clicou no botão da screen' TYPE 'I'.
  ELSEIF sscrfields-ucomm = 'FC01'.
    MESSAGE 'Clicou no botão da toolbar' TYPE 'I'.
  ENDIF.

" Definindo os valores a serem exibidos no Listbox
AT SELECTION-SCREEN OUTPUT.
  DATA(lt_values) = VALUE vrm_values(
    ( key = '1' text = 'PDF')
    ( key = '2' text = 'Arquivo Texto')
    ( key = '3' text = 'Power Point')
    ( key = '4' text = 'Word')
  ).

" Chama a função que preenche os valores no Listbox com as opções definidas
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = 'LB_TYP'       " Identificador do Listbox
      values = lt_values      " Valores a serem carregados
    EXCEPTIONS
      id_illegal_name = 1     " Caso o nome do ID seja ilegal
      OTHERS          = 2.    " Outras exceções genéricas