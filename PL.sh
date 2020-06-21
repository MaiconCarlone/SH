      #!/usr/bin/env bash
      
#     Criado por Maicon Carlone - maicon.carlone@gmail.com
#     sh baseado no trabalho de 7oxicshadow (23/09/19) - https://github.com/7oxicshadow/proton-standalone-script e nas postagens de unixuniverse - https://unixuniverse.com.br/winedxvk/usando-winetricks
#     Direcionado a distros base Debian, modifique PLGAMEMODE para outras bases ( /= 0 caso gamemode esteja instalado)!
#     PL = Proton-GE Launcher
      PL(){                                                                                                                                     # Func PL


#     COMANDO QUE DESEJA EXECUTAR NO PROTON =============================================================================================== ->
      COMANDO=$(dirname "$(readlink -f "${0}")")/GARRAFA/drive_c/Program\ Files\ \(x86\)/Epic\ Games/Launcher/Portal/Binaries/Win32/EpicGamesLauncher.exe   # Instale ou rode seu game, troque pelo comando que desejar
      ADICIONAL=" -opengl -SkipBuildPatchPrereq "                                                                                               # Parâmetro adicional para o COMANDO
      GARRAFA="GARRAFA"                                                                                                                         # Nome do prefix      
      export SteamGameId=0                                                                                                                      # Caso queira ativar um fix, informe o ID do game na Steam.
#     COMANDO QUE DESEJA EXECUTAR NO PROTON =============================================================================================== <-


#     BLOCO DE DEFINIÇÃO DE VARIÁVEIS E CONSTANTES ======================================================================================== ->
      PLPATH="$(dirname "$(readlink -f "${0}")")"                                                                                                                           # PL.sh vai construir a estrutura de diretórios onde o script estiver
      PLPROTONGE="$PLPATH"/PROTONGE                                                                                                             # Diretório do Proton-GE
      PLPROTONGEBIN="$PLPROTONGE"/proton                                                                                                        # Executável do Proton-Ge
      PROTONGELINK="https://github.com/GloriousEggroll/proton-ge-custom/releases/download/5.9-GE-2-MF/Proton-5.9-GE-2-MF.tar.gz"                # Mudar essa linha para alterar a versão do Proton-GE
      PROTONGEDIR="Proton-5.9-GE-2-MF"                                                                                                          # Mudar essa linha para alterar a versão do Proton-GE
      STEAM_HOME_DIR=".steam"                                                                                                                   # A variável STEAM_HOME_DIR deve ser inicializada corretamente! - Atualização = arrumei as libs, provavelmente não é mais necessário inicializar a variável, TESTAR!
      export STEAM_COMPAT_DATA_PATH="$PLPATH"/"$GARRAFA"                                                                                        # Definindo o prefix utilizado pelo Proton-GE
      PLGAMEMODE="$(dpkg --get-selections | grep "gamemode" )"                                                                                  # Verificando Gamemode
      ICONLINK="https://cdn.icon-icons.com/icons2/393/PNG/512/terminal_39664.png"                                                               # Link do ícone do .desktop
      SRTLINK="https://repo.steampowered.com/steamrt-images-scout/snapshots/latest-steam-client-general-availability/steam-runtime.tar.xz"      # Steam Runtime repository
      PLSTEAMRUNTIME="$PLPATH"/STEAMRUNTIME                                                                                                     # Diretório do STEAM-RUNTIME 
#     BLOCO DE DEFINIÇÃO DE VARIÁVEIS E CONSTANTES ======================================================================================== <-

      
#     VERIFICANDO, BAIXANDO E CONFIGURANDO A VERSÃO MAIS RECENTE DO PROTON-GE ============================================================= ->
      if [ -e "$PLPROTONGE" ] ; then
            echo "O arquivo $PLPROTONGE já existe!"

      else
#           Baixando, descompactando e movendo o Proton-GE
            mkdir "$PLPROTONGE"                                                                                   &&                            # Criando diretório do Proton-GE
            echo -e "\n\n$PLPROTONGE Criado! \nFazendo download do Proton-GE \n "                                 &&                             
            wget -q --show-progress "$PROTONGELINK" -O PGE.tar.gz                                                 &&                            # Baixando o Proton-GE
            echo -e "\nDownload concluido! \nIniciando descompactação \n "                                        &&
            tar -xzf PGE.tar.gz -C "$PLPROTONGE"                                                                  &&                            # Descompactando o Proton-GE
            mv "$PLPROTONGE/$PROTONGEDIR/"* "$PLPROTONGE"                                                         &&
            rm -r "$PLPROTONGE/$PROTONGEDIR/"                                                                     &&
            echo -e "Descompactação comcluida! \n "                                                               &&
            rm PGE.tar.gz                                                                                         &&                            # Apagando o arquivo tar.gz
            
#           Alterando variáveis para executar o proton sozinho
            sed -i 's/\[g\_proton\.wine\_bin\, \"steam\"\]/\[g\_proton\.wine\_bin\]/g' "$PLPROTONGE"/proton       &&                            # self.run_proc([g_proton.wine_bin, "steam"] + sys.argv[2:]) -> self.run_proc([g_proton.wine_bin] + sys.argv[2:])
            sed -i 's/\(\"pfx\/\"\)/\"\"/g' "$PLPROTONGE"/proton                                                                                # self.prefix_dir = self.path("pfx/") -> self.prefix_dir = self.path("")
            
      fi
#     VERIFICANDO, BAIXANDO E CONFIGURANDO A VERSÃO MAIS RECENTE DO PROTON-GE ============================================================= <-


#     VERIFICANDO SE O PREFIX EXISTE ====================================================================================================== ->
      if [ -e "$STEAM_COMPAT_DATA_PATH" ] ; then
            echo -e "\nO arquivo $STEAM_COMPAT_DATA_PATH já existe!\n"

      else
            mkdir "$STEAM_COMPAT_DATA_PATH"                                                                       &&                            # Criando diretório do Prefix
            echo -e "\nO arquivo $STEAM_COMPAT_DATA_PATH foi criado\nRealizando configuração inicial do Prefix\n" &&
            python3 "$PLPROTONGEBIN" waitforexitandrun wineboot                                                   &&                            # Criando o Prefix
            echo -e "\n "
            PL-INSTRUC                                                                                                                          # Instruções opcionais para instalação
      fi
#     VERIFICANDO SE O PREFIX EXISTE ====================================================================================================== <-


#     VERIFICANDO SE O ATALHO EXISTE ====================================================================================================== ->
      if [ -e "$PLPATH/ATALHO" ] ; then
            echo -e "\nO arquivo $PLPATH/ATALHO já existe!\n"

      else
            mkdir "$PLPATH/ATALHO"                                                                                &&                            # Criando diretório para os .desktop
            echo -e "\nO arquivo $PLPATH/ATALHO foi criado\nCriando $PLPATH/ATALHO/PLGUI.desktop\n"               &&
            echo -e "#!/bin/bash \n cd $PLPATH &&"                 > "$PLPATH/ATALHO/PLrun.sh"                    &&
            echo -e " source $PLPATH/PL.sh && PL-GUI"             >> "$PLPATH/ATALHO/PLrun.sh"                    &&                            # Inicia na GUI do PL
            chmod +x "$PLPATH/ATALHO/PLrun.sh"                                                                    &&
            wget -q --show-progress "$ICONLINK" -O "icon.png"                                                     &&
            mv "icon.png" "$PLPATH/ATALHO"                                                                        &&
            echo -e "[Desktop Entry]\nName=PLGUI\nExec=$PLPATH/ATALHO/PLrun.sh\nIcon=$PLPATH/ATALHO/icon.png\nTerminal=false\nType=Application\nCategories=Proton;Game;Wine;\n" > "$PLPATH/ATALHO/PLGUI.desktop" &&
            chmod +x "$PLPATH/ATALHO/PLGUI.desktop"                                                               &&
            PL-INSTRUC-DESK                                                                                                                     # Instruções opcionais para instalação - .desktop
      fi
#     VERIFICANDO SE O ATALHO EXISTE ====================================================================================================== <-


#     VERIFICANDO SE O CACHE EXISTE ======================================================================================================= ->
      if [ -e "$PLPATH/CACHE" ] ; then
            echo -e "\nO arquivo $PLPATH/CACHE já existe!\n"

      else
            mkdir "$PLPATH/CACHE"                                                                                 &&                            # Criando diretório do Cache - nohup.out vai aqui
            echo -e "\nO arquivo $PLPATH/CACHE foi criado\n"          
      fi
#     VERIFICANDO SE O CACHE EXISTE ======================================================================================================= <-


#     VERIFICANDO SE O STEAM-RUNTIME EXISTE =============================================================================================== ->
      if [ -e "$PLSTEAMRUNTIME" ] ; then
            echo -e "\nO arquivo $PLSTEAMRUNTIME já existe!\n"

      else
            mkdir "$PLSTEAMRUNTIME"                                                                               &&                            # Criando diretório do Steam-Runtime
            echo -e "\n\n$PLSTEAMRUNTIME Criado! \nFazendo download do Steam-runtime \n "                         && 
            wget -q --show-progress "$SRTLINK" -O "SRT.tar.xz"                                                    &&                            # Baixando Steam-Runtime
            tar -xvf SRT.tar.xz -C "$PLSTEAMRUNTIME"                                                              &&
            mv "$PLSTEAMRUNTIME/steam-runtime/"* "$PLSTEAMRUNTIME"                                                &&
            rm -r "$PLSTEAMRUNTIME/steam-runtime/"                                                                &&
            echo -e "Descompactação comcluida! \n "                                                               &&
            rm SRT.tar.xz                                                                                         &&                            # Apagando o arquivo tar.gz     

#           Instalando STEAM-RUNTIME
            echo -e "Instalando STEAMRUNTIME! \n "                                                                &&
            "$PLSTEAMRUNTIME/setup.sh"                                                                            &&                            # Rodando o setup.sh do Steam-Runtime
            echo -e "STEAMRUNTIME instalado! \n "

      fi
      STRrun="$PLSTEAMRUNTIME/run.sh"                                                                             &&                            # Definindo comando para inicializar o Steam-Runtime
#     VERIFICANDO SE O STEAM-RUNTIME EXISTE =============================================================================================== <-


#     VARIÁVEIS ADICIONAIS PARA O PROTON ================================================================================================== ->
#     Inicializando as variáveis descritas por 7oxicshadow (orginalmente eu não acidionava essas 4 linhas, mas decidi coloca-las por segurança)
      export SDL_GAMECONTROLLERCONFIG="03000000de280000ff11000001000000,Steam Virtual Gamepad,a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,03000000de280000fc11000001000000,Steam Controller,a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,030000005e040000a102000007010000,X360 Wireless Controller,a:b0,b:b1,back:b6,dpdown:b14,dpleft:b11,dpright:b12,dpup:b13,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,0000000058626f782047616d65706100,XInput Controller,a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,030000005e0400008e02000010010000,X360 Controller,a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,"
      export SDL_GAMECONTROLLER_ALLOW_STEAM_VIRTUAL_GAMEPAD="1"
      export SDL_GAMECONTROLLER_USE_BUTTON_LABELS="1"
      export SDL_VIDEO_X11_DGAMOUSE="0"
#     export LD_PRELOAD="$LD_PRELOAD:/usr/\$LIB/libgamemodeauto.so.0"                                                                           # Problema pendente para x86

#     Jogos não-steam lançados via Proton parecem não herdar o LD_LIBRARY_PATH do steam-runtime.
#     https://github.com/ValveSoftware/steam-for-linux/issues/6475
      LD_LIBRARY_PATH_OLD="$LD_LIBRARY_PATH"                                                                                                    # Salvando status original de LD_LIBRARY_PATH, previne erro no dpkg, caso o sh seja rodado novamente.
      PGELIB="$PLPROTONGE/dist/lib/"                                                                                                            # Libs x86 do Proton-GE
      PGELIB64="$PLPROTONGE/dist/lib64/"                                                                                                        # Libs x64 do Proton-GE

      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$PGELIB64:PGELIB::"                                                                              # Juntando as libs do Proton-GE ao LD_LIBRARY_PATH
#     VARIÁVEIS ADICIONAIS PARA O PROTON ================================================================================================== <-


#     EXECUTANDO COMANDO ================================================================================================================== ->
      PL-COMP                                                                                                                                   # Chamando as configurações adicionais para o Proton/WINE
      
      if [ -e "$PLPATH/CACHE/nohup.out" ] ; then rm "$PLPATH/CACHE/nohup.out"; fi                                                               # Apagando arquivo de log antigo, caso ele exista
      if [ "$1" == "-winecfg" ];  then   COMANDO="winecfg"; fi                                                                                  # Iniciar as configurações do wine na garrafa
      if [ "$1" == "-wineboot" ]; then  COMANDO="wineboot"; fi                                                                                  # Simula o reset do sistema
      if [ "$1" == "-comando" ];  then  COMANDO="$2";       fi                                                                                  # Executa um comando diferente daquele informado no PL.sh
      
      if [ "$1" == "-winetricks" ]; then                                                                                                        # Iniciando o winetricks no lugar do COMANDO
            LD_LIBRARY_PATH="$LD_LIBRARY_PATH_OLD"                                                                                              # Retomando status original de LD_LIBRARY_PATH para prevenir erros no winetricks
            WINEPREFIX="$STEAM_COMPAT_DATA_PATH" winetricks
           
      else
            echo -e "Conteúdo da variável COMANDO: $COMANDO\n"
            if [ -n "$PLGAMEMODE" ]; then
                  echo -e "Gamemode encontrado\n"                                                                 &&
                  nohup  gamemoderun "$STRrun" python3 "$PLPROTONGEBIN" waitforexitandrun "$COMANDO" $(echo $ADICIONAL)   >> "$PLPATH/CACHE/nohup.out"   &&  # rodando game com gamemode                    
                  echo -e "Feito\n" 
            else
                  echo -e "Gamemode não encontrado\n"                                                             &&
                  nohup "$STRrun" python3 "$PLPROTONGEBIN" waitforexitandrun "$COMANDO" $(echo $ADICIONAL) >> "$PLPATH/CACHE/nohup.out" &&                   # rodando game sem gamemode                                  
                  echo -e "Feito\n"
            fi
      fi
      LD_LIBRARY_PATH="$LD_LIBRARY_PATH_OLD"                                                                                                    # Retomando status original de LD_LIBRARY_PATH

      }                                                                                                                                         # Fim da func PL
#     EXECUTANDO COMANDO ================================================================================================================== <-      


#     COMPONENTES ADICIONAIS ============================================================================================================== ->
      PL-COMP(){

#     Componentes adicionais que podem ser ativados. Utilize esse espaço para adicionar suas configurações personalizadas!
      export DXVK_HUD=fps                                                                                                                       # Habilita o HUD
      export DXVK_SPIRV_OPT=ON                                                                                                                  # Não sei se essa opção é necessária para o Proton - Teste ai!
      export DXVK_SHADER_OPTIMIZE=1                                                                                                             # Não sei se essa opção é necessária para o Proton - Teste ai!
      export DXVK_SHADER_DUMP_PATH="/tmp"                                                                                                       # Diretório para as shaders do DXVK
      export DXVK_SHADER_READ_PATH="/tmp"                                                                                                       # Diretório para as shaders do DXVK
      export DXVK_DEBUG_LAYERS=0                                                                                                                # Ativa as camadas de depuração do Vulkan. Altamente recomendado para fins de solução de problemas e depuração.
#     export DXVK_LOG_LEVEL=none                                                                                                                # Controla as mensagens de erro do DXVK
#     export WINEDLLOVERRIDES=d3d11
#     export DRI_PRIME=1                                                                                                                        # Ative para placas híbridas
#     export PROTON_NO_ESYNC=1
#     export PROTON_NO_FSYNC=1                                                                                                                  # https://github.com/ValveSoftware/Proton/issues/3761 cuidado!
      export DXVK_STATE_CACHE_PATH="$PLPATH/CACHE"                                                                                              # Cache do DXVK                                                                                                     
      export WINEFSYNC=1
      
#     https://github.com/FeralInteractive/gamemode
      export GAMEMODERUNEXEC="env DRI_PRIME=1"                                                                                                  # Ative para placas híbridas - GameMode da Feral
#     export GAMEMODERUNEXEC="env __NV_PRIME_RENDER_OFFLOAD=1 env __GLX_VENDOR_LIBRARY_NAME=nvidia env __VK_LAYER_NV_optimus=NVIDIA_only"       # Ative para placas híbridas - GameMode da Feral

#     NVidia GPUs
#     https://www.protondb.com/help/improving-performance
#     Make sure that you have the latest Nvidia drivers installed on your system. You can use these environment variables:
      export __GL_THREADED_OPTIMIZATION=1                                                                                                       # For OpenGL games
      export __GL_SHADER_DISK_CACHE=1                                                                                                           # To create a shader cache for a game
      export __GL_SHADER_DISK_CACHE_PATH="$PLPATH/CACHE"                                                                                        # To set the location for the shader cache.

      }
#     COMPONENTES ADICIONAIS ============================================================================================================== <-


#     INSTRUÇÕES DE INSTALAÇÃO - BLOCO OPCIONAL =========================================================================================== ->
      PL-INSTRUC(){
      # Use esse espaço para adicionar comandos e realizar automaticamente a instalação de algum game ou software.
      # Esse bloco será executado uma única vez, no momento que o Prefix for criado.
      # Para criar um sh funcional que instala e roda seu programa, lembre de definir corretamente a variável COMANDO contendo o .exe que-
      # será gerado no diretório que o programa for instalado. Assim, após a instalação o PL.sh vai executar automaticamente seu programa. 

      # https://lutris.net/games/install/5835/view
      WINEPREFIX="$STEAM_COMPAT_DATA_PATH" winetricks arial cjkfonts d3dcompiler_43 d3dcompiler_47 d3dx9          &&                            # Instalando tudo que recomendaram no wineDB
      # https://www.epicgames.com/help/en-US/epic-games-store-c73/error-codes-c100/supqr-ispqr-the-necessary-prerequisites-have-failed-to-install-please-contact-support-a3511
      WINEPREFIX="$STEAM_COMPAT_DATA_PATH" winetricks vcrun2010 vcrun2012 vcrun2013 vcrun2015                     &&                            # O winetricks vai mudar o prefix para winXP

#     Baixando a Loja da Epic
      EPIC="https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncherInstaller.msi?trackingId=14f8617ecf6c41dcb693cd5b2a7ff883" &&
      echo -e "\nO arquivo EPIC.msi será baixado\n"                                                               &&
      wget -q --show-progress "$EPIC" -O "EPIC.msi"                                                               &&                            # Baixando a Loja da Epic

#     Instalando a Loja Epic
      WINEPREFIX="$STEAM_COMPAT_DATA_PATH" winetricks win7                                                        &&                            # Rodar o .msi em modo win7 para evitar problemas
      cd "$PLPATH/"                                                                                               &&
      python3 "$PLPROTONGEBIN" waitforexitandrun start EPIC.msi                                                   &&                            # Instalando a loja da Epic
      python3 "$PLPROTONGEBIN" waitforexitandrun wineserver-k                                                     &&                            # Reiniciando o Proton depois de instalar a Epic
      rm EPIC.msi                                                                                                 &&                            # Apagando o arquivo de instalação
      sleep 15                                                                                                    &&                            # Esperando por segurança!

#     Separando as pastas de jogos do Prefix
      if [ -e "$PLPATH/Epic Games/" ]; then                                                                                                     # Verificando se o diretório dos games da Epic existe

            # Criando atalho para a pasta já existente
            echo -e "\nO $PLPATH/Epic Games/ existe e o link será criado!\n"                                                                    
      else

            # Criando estrutura
            echo -e "\nO $PLPATH/Epic Games/ não existe, criando estrutura!\n"                                    &&
            mkdir "$PLPATH/Epic Games"                                                                                                          # Caso diretório dos games da Epic não exista, criar ele                      
      fi
      ln -sr "Epic Games/" "$PLPATH/GARRAFA/drive_c/Program Files/Epic Games"                                     &&                            # Link para o diretório dos games da Epic esperado pela Epic Store

#     Separando as pastas de Saves do Prefix
      rm -r  "$PLPATH/GARRAFA/drive_c/users/steamuser/AppData/LocalLow"                                           &&                            # Apagando o diretório criado pela instalação da Epic Store
      if [ -e "$PLPATH/Epic Saves/" ]; then                                                                                                     # Verificando se o diretório dos saves da Epic existe

            # Criando atalho para a pasta já existente
            echo -e "\nO $PLPATH/Epic Saves/ existe e o link será criado!\n"                                                                    
      else

            # Criando estrutura
            echo -e "\nO $PLPATH/Epic Saves/ não existe, criando estrutura!\n"                                    &&
            mkdir "$PLPATH/Epic Saves"                                                                                                          # Caso diretório dos saves da Epic não exista, cria ele
      fi
      ln -sr "Epic Saves/" "$PLPATH/GARRAFA/drive_c/users/steamuser/AppData/LocalLow"                             &&                            # Link para o diretório dos saves da Epic esperado pela Epic Store
      
      sleep 1                                                                                                                                   # Lixo para ocupar a função e evitar erro 
      }
#     INSTRUÇÕES DE INSTALAÇÃO - BLOCO OPCIONAL =========================================================================================== <-


#     INSTRUÇÕES DE INSTALAÇÃO - .desktop - BLOCO OPCIONAL ================================================================================ ->
      PL-INSTRUC-DESK(){
      # Use esse espaço para adicionar comandos e realizar automaticamente a criação de atalhos para seu game ou software.
      # Esse bloco será executado uma única vez, no momento que o $PLPATH/ATALHO/ for criado.

#     Criando o .dektop para a loja da Epic dentro do diretório ATALHO
      cp "$PLPATH/GARRAFA/drive_c/Program Files (x86)/Epic Games/Launcher/Portal/Content/New UI/epic_logo_large.png" "$PLPATH/ATALHO/iconC.png" &&
      echo -e "#!/bin/bash \n cd $PLPATH &&"                 > "$PLPATH/ATALHO/PL-COMANDOrun.sh"                  &&
      echo -e " source $PLPATH/PL.sh && PL"                 >> "$PLPATH/ATALHO/PL-COMANDOrun.sh"                  &&                            # Inicia com a variável COMANDO, no caso a Epic Store win64
      chmod +x "$PLPATH/ATALHO/PL-COMANDOrun.sh"                                                                  &&
      echo -e "[Desktop Entry]\nName=Epic\nExec=$PLPATH/ATALHO/PL-COMANDOrun.sh\nIcon=$PLPATH/ATALHO/iconC.png\nTerminal=false\nType=Application\nCategories=Proton;Game;Wine;\n" > "$PLPATH/ATALHO/Epic.desktop" &&
      chmod +x "$PLPATH/ATALHO/Epic.desktop"                                                                      &&
            
      sleep 1                                                                                                                                   # Lixo para ocupar a função e evitar erro 
      }
#     INSTRUÇÕES DE INSTALAÇÃO - .desktop - BLOCO OPCIONAL ================================================================================ <-


#     INTERFACE EM ZENITY================================================================================================================== ->
      PL-GUI(){

#     Escolhas Disponíveis alocadas no vetor ESCOLHA
      ESCOLHA[0]="Executar o Programa descrito na variável COMANDO no Proton-GE"                                                                # Inicia com a variável COMANDO, no caso a Epic Store win64
      ESCOLHA[1]="Executar um comando customizado no Proton-GE"
      ESCOLHA[2]="Localizar e executar um arquivo (*.exe): mods, traduções, trapaças, etc.."
      ESCOLHA[3]="Abrir as configurações do Wine no Prefix: winecfg"
      ESCOLHA[4]="Instalar componentes no Prefix: winetricks"
      ESCOLHA[5]="Simular reinicialização do sistema: wineboot"
      
#     Apresentando as escolhas
      while true; do
            choice="$(zenity --width=800 --height=300 --list --column "Opções Disponíveis:" --title="PL -> Proton-GE Launcher" \
            "${ESCOLHA[0]}" \
            "${ESCOLHA[1]}" \
            "${ESCOLHA[2]}" \
            "${ESCOLHA[3]}" \
            "${ESCOLHA[4]}" \
            "${ESCOLHA[5]}" \
            "Sair")"

#           Consequência das escolhas
            case "${choice}" in
            ${ESCOLHA[0]} )  
                  PL 
            ;;
            ${ESCOLHA[1]} )
                  PL -comando "$(zenity --entry --width=800 --height=300 --title="comando que será executado no Proton-GE" --text="Digite o novo comando:" \  )"
            ;;
            ${ESCOLHA[2]} )
                  PL -comando "$(zenity --file-selection --file-filter="*.exe")"
            ;;  
            ${ESCOLHA[3]} )
                  PL -winecfg
            ;;
            ${ESCOLHA[4]} )
                  PL -winetricks
            ;;
            ${ESCOLHA[5]} )
                  PL -wineboot
            ;;
            *)
                  break
            ;;
            esac
  
      done
      }
#     INTERFACE EM ZENITY================================================================================================================== <-
