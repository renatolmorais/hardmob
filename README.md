# hardmob
Um script em bash para buscar por threads com promoções no Forum Hardmob.
Para utilizar, crie um arquivo chamado "keywords.txt" e coloque as palavras-chave, 1 por linha, que você quer que sejam buscadas, como "acer", "lenovo", "gamer" etc.
Feito isso, execute o script main.sh.
O script busca na página de promoções do fórum por threads que contenham as palavras-chave e retorna as urls delas.
Os links encontrados serão mostrados na tela e salvos no arquivo "urls.txt", e os hashes md5 serão salvos no arquivo "md5-urls.txt".

UPDATE 06/06/2020
Agora é possível enviar e-mails após encontrar urls. Entretanto, o script que envia e-mail não é fornecido!

UPDATE 07/06/2020
Agora o controle é feito pelo número da thread. Assim evita-se links repetidos.

UPDATE 29/09/2020
Agora é possível incluir keywords para filtrar o resultado final, excluindo aquilo que não se deseja.
Exemplo: eu quis utilizar o programa para pesquisar condiconadores de ar.
Então coloquei samsung como keywork.
Entretanto, estavam sendo retornados "monitores" e "celulares".
Então criei um artificío para não retornar esses resultados.
As keywords que NÃO DEVEM ser retornadas agoram são inclídas com um "-" na frente, e as que DEVEM ser retornadas são incluídas com um "+" na frente.
Ex:
+samsung
+condicionado
+gree
-monitor
-celular
-tablet
