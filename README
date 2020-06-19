Um script simples que automatiza a instalação e execução de programas feitos para Windows (focado em games que não estão disponíveis na Steam), utilizando a versão mais recente do Proton-GE (https://github.com/GloriousEggroll/proton-ge-custom).

Recomendado para usuários que tem familiaridade com: shell script, bash, wine, winetricks.

A versão atual conta com o instalador da Epic Games Store (www.epicgames.com) como exemplo de utilização. Basicamente o .sh contem duas funções que devem ser customizadas para outros programas PL-INSTRUC e PL-INSTRUC-DESK. 

As instruções de utilização estão nos comentários do script. Para testar o .sh e instalar a  Epic Games Store, basta executar o comando: source PL.sh && PL ou  source PL.sh && PL-GUI (para iniciar a interface simples em Zenity).

Os arquivos .desktop gerados ficam no diretório: ATALHOS

Antes de rodar, verifique se o vulkan está funcionando adequadamente: sudo vulkaninfo

Toda vez que é executado o .sh verifica a estrutura de diretórios, caso qualquer um deles seja excluído, ao executar novamente o .sh a estrutura será verificada e o diretório será recriado.

Para o exemplo da Epic: Separei os diretórios de Games e Saves da loja da Epic, desse modo é possível mudar o prefix para jogos específicos. Para realizar essa ação, mude o valor da variável GARRAFA.    

Aparentemente está funcionando bem, se possível revise as libs utilizadas. Toda contribuição é bem vinda!




p.s.: Decidi fazer o .sh inteiramente em pt-br para facilitar a utilização, uma vez que o objetivo desse .sh é justamente ser alterado pelo usuário para cada Game :)




Baseado no trabalho de 7oxicshadow (23/09/19) - https://github.com/7oxicshadow/proton-standalone-script e nas postagens de unixuniverse - https://unixuniverse.com.br/winedxvk/usando-winetricks
