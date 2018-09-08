# ArTE

------

*A personal profile for HP-UX, OS X and Linux.*

[TOC]

ArTE es un perfil BASH/SH para proyectos de arquitectura que he ido desarrollando en función de las necesidades que se han presentado.

## Instalación

### Obtener el pkg del repositorio

```shell
$> wget https://git.bitbucket.com/andresaquino/arte/arte-v1.3-171107.tar.gz

```

### Descomprimir en temporal

```shell
$> mkdir -p ~/arte
$> tar xvf arte-v1.3-171107.tar.gz -C ~/arte
./.editorconfig
./.gitignore
./bin/
./bin/pkg2distribute
./bin/profileUpdate
./etc/
./etc/.gitkeep
./etc/default.profile
./etc/git.profile
./etc/git.setup/
./etc/git.setup/gitrc
./etc/hosts.cnf
./etc/java.profile
...
```

### Ejecutar como r00t

Para poder instalar el perfil de forma general a todos los usuarios

```shell
$> sudo su -
#> rm -fr /usr/local/arte
#> mkdir -p /usr/local/arte
#> cd /usr/local/arte
#> rsync -av ${HOME}/arte/* /usr/local/arte/ --exclude=packages
#> ln -sf /usr/local/arte/etc/shell.profile ~/shell.profile
#> ln -sf /usr/local/arte/etc/unix.profile ~/unix.profile
#> ln -sf /usr/local/arte/logo.d/default.info ~/logo.info
#> find /usr/local/arte -type d -exec chmod a+rx {} \;
#> find /usr/local/arte -type f -exec chmod a+r {} \;
#> exit
```

```shell
Simplificado:
$> rsync -avz ${HOME}/arte/* /usr/local/arte/ \
     --exclude=packages \
     --exclude=etc/vim.setup/iTerm*
```

### Perfilar el usuario

### Vundle

GIT Project: https://github.com/VundleVim/Vundle.vim

Minimal .vimrc

```
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'

" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
```

Vundle

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

```shell
$> git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
$> cat /usr/local/arte/etc/shell.setup/bash.rc > ~/.bashrc
$> cat /usr/local/arte/etc/shell.setup/bash.profile > ~/.bash_profile
```

### Vundle Packages

#### sparkup

https://vimawesome.com/plugin/sparkup

#### EditorConfig

https://github.com/editorconfig/editorconfig-vim



### Funciones

#### Sync project

```shell
rsync -avr ~/arte/ ~/projects/arte.git/ --delete

```

#### Sync project

```shell
rsync -av arte.git REMOTE_HOST:~/arte/packages/ \
   --exclude .git \
   --exclude iTerm2-colors \
   --exclude iTerm-fonts

```

#### Permissions

-  Fix permissions on files and directories. 

```shell
find . -type f -exec chmod a+r {} \;
find . -type d -exec chmod a+rx {} \;
```

Enjoy .. 

## Actualización

*TODO*

## Desinstalación

*TODO*

## Licencia

```
BSD 3-Clause License

(c) 2018, Andrés Aquino
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

BSD License, to know more about: http://www.linfo.org/bsdlicense.html
```

# vim: tw=76 si ai rnu fo-=t lbr:
