# 🚀 MioVim - Configurazione Vim per JavaScript e TypeScript

Una configurazione completa e ottimizzata di Vim per lo sviluppo JavaScript e TypeScript, con supporto completo per LSP, formattazione automatica, linting e debugging.

## ✨ Caratteristiche

### 🎯 Funzionalità Core
- **Language Server Protocol (LSP)** completo via COC
- **Auto-completamento intelligente** per JS/TS
- **Syntax highlighting** avanzato per JavaScript, TypeScript, JSX, TSX
- **Formattazione automatica** con Prettier
- **Linting in tempo reale** con ESLint
- **Git integration** completa
- **File explorer** avanzato con icone
- **Fuzzy finder** per navigazione rapida
- **Debugging** integrato con Vimspector

### 🎨 Interfaccia
- **Tema Gruvbox** ottimizzato per sviluppo
- **Status line** informativa con Airline
- **Icone Nerd Font** per file e cartelle
- **Evidenziazione sintassi** per tutti i linguaggi web
- **Numeri di riga relativi** per navigazione efficiente

### ⚡ Performance
- **Caricamento lazy** dei plugin
- **Cache ottimizzata** per completamento
- **Backup automatici** e gestione undo persistente
- **Ricerca veloce** con indicizzazione intelligente

## 🛠️ Installazione

### 🚀 Installazione Rapida (Solo configurazione Vim)

```bash
# Clona il repository
git clone https://github.com/sensorario/miovim.git
cd miovim

# Installazione rapida - solo configurazione Vim
./quick-install.sh
```

### 🔧 Installazione Completa (Consigliata)

```bash
# Clona il repository
git clone https://github.com/sensorario/miovim.git
cd miovim

# Installazione completa con tutte le dipendenze
./install.sh
```

Lo script completo installerà automaticamente:
- ✅ Vim (se non presente)
- ✅ Node.js e npm (versione LTS)
- ✅ Dipendenze npm globali (TypeScript, ESLint, Prettier, etc.)
- ✅ Nerd Fonts per le icone
- ✅ Tutti i plugin Vim necessari
- ✅ Estensioni COC per LSP
- ✅ File di configurazione esempio

### ⚡ Installazione Avanzata con Opzioni

```bash
# Installazione con opzioni personalizzate
./install-advanced.sh --help

# Esempi:
./install-advanced.sh -y                    # Non interattiva
./install-advanced.sh --minimal             # Solo base
./install-advanced.sh --no-nodejs           # Senza Node.js
./install-advanced.sh --theme dracula       # Con tema Dracula
./install-advanced.sh --config-only         # Solo configurazioni
```

### 🛠️ Utilizzo con Makefile

```bash
# Mostra tutti i comandi disponibili
make help

# Installazioni
make install          # Installazione completa
make quick            # Installazione rapida (solo Vim)
make minimal          # Installazione minimale
make advanced         # Installazione con opzioni

# Utilità
make demo             # Crea progetto demo
make backup           # Backup configurazione
make test             # Testa configurazione
make check-deps       # Verifica dipendenze
make update           # Aggiorna configurazione
make uninstall        # Disinstalla
```

### Installazione Manuale

<details>
<summary>Clicca per vedere i passaggi manuali</summary>

1. **Installa le dipendenze di sistema:**
   ```bash
   # macOS
   brew install vim node

   # Ubuntu/Debian
   sudo apt update && sudo apt install vim nodejs npm

   # CentOS/RHEL
   sudo yum install vim nodejs npm
   ```

2. **Installa dipendenze npm globali:**
   ```bash
   npm install -g typescript eslint prettier @typescript-eslint/parser @typescript-eslint/eslint-plugin
   ```

3. **Copia la configurazione:**
   ```bash
   cp .vimrc ~/.vimrc
   cp coc-settings.json ~/.vim/
   cat coc-config.vim >> ~/.vimrc
   ```

4. **Installa i plugin:**
   ```bash
   vim +PlugInstall +qall
   ```

5. **Installa le estensioni COC:**
   ```bash
   vim +"CocInstall coc-tsserver coc-json coc-prettier coc-eslint" +qall
   ```

</details>

## 🎮 Utilizzo

### Tasti e Shortcuts

#### Leader Key: `<Space>`

### 📁 Gestione File
| Shortcut | Descrizione |
|----------|-------------|
| `<Space>nt` | Apri/chiudi NERDTree |
| `<Space>nf` | Trova file corrente in NERDTree |
| `<Space>e` | Apri COC Explorer |
| `<Space>p` | Fuzzy finder (CtrlP) |
| `<Space>pb` | Lista buffer aperti |
| `<Space>pm` | File recenti (MRU) |

### ✏️ Editing e Formattazione (come VS Code)
| Shortcut | Descrizione |
|----------|-------------|
| `<Space>w` | Salva file |
| `<Space>q` | Chiudi file |
| `<Space>x` | Salva e chiudi |
| `<Space>f` | Formatta documento/selezione |
| `<Alt><Shift>f` | Formatta con Prettier (esatto come VS Code) |
| `<Space>pr` | Prettier: formatta file |
| `<Space>pc` | Prettier: check formato |
| `<Space>tf` | Toggle format on save |
| `<Space>rn` | Rinomina symbol |
| `<Space>ca` | Code actions |
| `<Space>qf` | Quick fix |

**Prettier configurato identico a VS Code:**
- ✅ Semicoloni abilitati (default VS Code)
- ✅ Doppi apici (default VS Code) 
- ✅ Format on save automatico
- ✅ Stesse impostazioni di formattazione

### 🔍 Navigazione e Ricerca
| Shortcut | Descrizione |
|----------|-------------|
| `gd` | Vai alla definizione |
| `gy` | Vai al tipo |
| `gi` | Vai all'implementazione |
| `gr` | Trova riferimenti |
| `K` | Mostra documentazione |
| `<Space>a` | Ricerca globale (Ack) |
| `<Space>/` | Rimuovi highlight ricerca |

### 🔄 Buffer e Split
| Shortcut | Descrizione |
|----------|-------------|
| `<Space>bn` | Buffer successivo |
| `<Space>bp` | Buffer precedente |
| `<Space>bd` | Chiudi buffer |
| `<Ctrl>h/j/k/l` | Naviga tra split |
| `<Space>+/-` | Ridimensiona split orizzontale |
| `<Space></>` | Ridimensiona split verticale |

### 🌿 Git
| Shortcut | Descrizione |
|----------|-------------|
| `<Space>gs` | Git status |
| `<Space>gc` | Git commit |
| `<Space>gp` | Git push |
| `<Space>gl` | Git pull |
| `<Space>gd` | Git diff |

### 🚀 COC (LSP)
| Shortcut | Descrizione |
|----------|-------------|
| `<Tab>` | Accetta completamento |
| `<Ctrl>Space` | Trigger completamento |
| `[g` / `]g` | Diagnostico precedente/successivo |
| `<Space>cd` | Lista diagnostici |
| `<Space>ce` | Lista estensioni |
| `<Space>cc` | Lista comandi |
| `<Space>co` | Outline documento |

### 💻 Terminale
| Shortcut | Descrizione |
|----------|-------------|
| `<Space>tt` | Apri terminale integrato |
| `<Space>r` | Ricarica configurazione |

## ⚙️ Configurazione

### File di Configurazione

La configurazione include i seguenti file:

- **`.vimrc`** - Configurazione principale Vim
- **`coc-settings.json`** - Configurazione COC/LSP
- **`eslintrc.example.json`** - Configurazione ESLint esempio
- **`prettierrc.example.json`** - Configurazione Prettier esempio
- **`tsconfig.example.json`** - Configurazione TypeScript esempio
- **`.editorconfig`** - Configurazione editor cross-platform

### Plugin Installati

#### Core
- `vim-sensible` - Configurazioni base sensate
- `nerdtree` - File explorer
- `ctrlp.vim` - Fuzzy finder
- `vim-fugitive` - Git integration
- `vim-airline` - Status bar migliorata

#### JavaScript/TypeScript
- `vim-javascript` - Syntax highlighting JS
- `typescript-vim` - Syntax highlighting TS
- `vim-jsx-pretty` - JSX support
- `vim-jsx-typescript` - TSX support
- `coc.nvim` - Language Server Protocol

#### Editing
- `vim-surround` - Gestione quotes/brackets
- `vim-commentary` - Commenti intelligenti
- `auto-pairs` - Auto-chiusura parentesi
- `vim-closetag` - Auto-chiusura tag HTML/JSX

#### Formattazione e Linting
- `vim-prettier` - Prettier integration
- `ale` - Linting asincrono

### Estensioni COC

- `coc-tsserver` - TypeScript language server
- `coc-eslint` - ESLint integration
- `coc-prettier` - Prettier integration
- `coc-json` - JSON support
- `coc-html` - HTML support
- `coc-css` - CSS support
- `coc-emmet` - Emmet abbreviations
- `coc-snippets` - Code snippets
- `coc-explorer` - File explorer avanzato
- `coc-git` - Git integration

## 🎨 Personalizzazione

### Cambiare Tema

Per cambiare il tema da Gruvbox:

```vim
" In .vimrc, sostituisci:
colorscheme gruvbox
" Con il tema desiderato, es:
colorscheme dracula
```

Temi consigliati:
- `dracula/vim`
- `joshdick/onedark.vim`
- `arcticicestudio/nord-vim`

### Modificare Impostazioni LSP

Modifica `~/.vim/coc-settings.json` per personalizzare:

```json
{
  "typescript.preferences.includePackageJsonAutoImports": "on",
  "prettier.printWidth": 120,
  "eslint.autoFixOnSave": true
}
```

### Aggiungere Plugin

Aggiungi plugin in `.vimrc` nella sezione `call plug#begin()`:

```vim
call plug#begin('~/.vim/plugged')
" ... plugin esistenti ...
Plug 'nuovo/plugin'
call plug#end()
```

Poi esegui `:PlugInstall` in Vim.

## 🐛 Troubleshooting

### Problemi Comuni

#### COC non funziona
```bash
# Verifica Node.js
node --version  # Deve essere >= 14.x

# Reinstalla estensioni COC
vim +"CocInstall coc-tsserver coc-eslint coc-prettier" +qall
```

#### Font/Icone mancanti
```bash
# macOS
brew install --cask font-fira-code-nerd-font

# Linux
# Scarica e installa manualmente i Nerd Fonts
```

#### ESLint non funziona
```bash
# Installa ESLint globalmente
npm install -g eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin

# Crea .eslintrc.json nel progetto
cp eslintrc.example.json .eslintrc.json
```

#### Prettier non formatta
```bash
# Verifica configurazione in coc-settings.json
# Assicurati che sia presente:
"coc.preferences.formatOnSaveFiletypes": [
  "javascript", "typescript", "javascriptreact", "typescriptreact"
]
```

### Log e Debug

#### Debug COC
```vim
:CocInfo        " Informazioni sistema
:CocLog         " Log COC
:CocConfig      " Apri configurazione
```

#### Check Health
```vim
:checkhealth    " Solo in Neovim
" In Vim classico verifica manualmente le dipendenze
```

## 📚 Risorse Utili

### Documentazione
- [Vim Tips Wiki](https://vim.fandom.com/wiki/Vim_Tips_Wiki)
- [COC.nvim Documentation](https://github.com/neoclide/coc.nvim)
- [TypeScript in Vim](https://pragmatic-coder.net/setup-typescript-vim-development/)

### Cheat Sheets
- [Vim Cheat Sheet](https://vim.rtorr.com/)
- [COC Shortcuts](https://github.com/neoclide/coc.nvim#example-vim-configuration)

### Community
- [r/vim](https://reddit.com/r/vim)
- [Vi and Vim Stack Exchange](https://vi.stackexchange.com/)

## 🤝 Contribuire

1. Fork il repository
2. Crea una feature branch (`git checkout -b feature/amazing-feature`)
3. Commit le modifiche (`git commit -m 'Add amazing feature'`)
4. Push al branch (`git push origin feature/amazing-feature`)
5. Apri una Pull Request

## 📝 License

Questo progetto è sotto licenza MIT. Vedi `LICENSE` per dettagli.

## 🙏 Ringraziamenti

- [Vim](https://www.vim.org/) - L'editor che ha reso tutto possibile
- [COC.nvim](https://github.com/neoclide/coc.nvim) - LSP amazing per Vim
- [Gruvbox](https://github.com/morhetz/gruvbox) - Tema fantastico
- Tutti i maintainer dei plugin utilizzati

---

**Happy Coding! 🎉**

*Fatto con ❤️ per la community JavaScript/TypeScript*