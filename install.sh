#!/bin/bash

# ============================================================================
# MioVim - Script di installazione per configurazione Vim JavaScript/TypeScript
# ============================================================================

set -e  # Esci se un comando fallisce

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funzioni di utilità
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verifica se un comando esiste
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Installa Homebrew se non presente (macOS)
install_homebrew() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if ! command_exists brew; then
            log_info "Installando Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            log_success "Homebrew installato!"
        else
            log_info "Homebrew già installato"
        fi
    fi
}

# Installa Vim
install_vim() {
    log_info "Installando Vim..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS con Homebrew
        if command_exists brew; then
            brew install vim
        else
            log_error "Homebrew non trovato. Installalo prima."
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command_exists apt-get; then
            sudo apt-get update
            sudo apt-get install -y vim vim-gtk
        elif command_exists yum; then
            sudo yum install -y vim vim-enhanced
        elif command_exists pacman; then
            sudo pacman -S vim
        elif command_exists dnf; then
            sudo dnf install -y vim vim-enhanced
        else
            log_error "Package manager non supportato. Installa Vim manualmente."
            exit 1
        fi
    else
        log_error "Sistema operativo non supportato"
        exit 1
    fi
    
    log_success "Vim installato!"
}

# Installa Node.js
install_nodejs() {
    log_info "Controllando Node.js..."
    
    if command_exists node; then
        NODE_VERSION=$(node --version)
        log_info "Node.js già installato: $NODE_VERSION"
        
        # Verifica se la versione è >= 14
        MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
        if [ "$MAJOR_VERSION" -lt 14 ]; then
            log_warning "Node.js versione $NODE_VERSION trovata. Raccomandato >= 14.x"
            read -p "Vuoi aggiornare Node.js? [y/N]: " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                install_nodejs_fresh
            fi
        fi
    else
        install_nodejs_fresh
    fi
}

install_nodejs_fresh() {
    log_info "Installando Node.js..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS con Homebrew
        if command_exists brew; then
            brew install node
        else
            log_error "Homebrew non trovato"
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux - usa NodeSource repository per ultima versione LTS
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        if command_exists apt-get; then
            sudo apt-get install -y nodejs
        elif command_exists yum; then
            curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
            sudo yum install -y nodejs npm
        elif command_exists dnf; then
            curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
            sudo dnf install -y nodejs npm
        fi
    fi
    
    log_success "Node.js installato!"
}

# Installa dipendenze globali npm
install_npm_dependencies() {
    log_info "Installando dipendenze npm globali..."
    
    PACKAGES=(
        "typescript"
        "eslint"
        "prettier"
        "@typescript-eslint/parser"
        "@typescript-eslint/eslint-plugin"
        "eslint-plugin-react"
        "@types/node"
        "flow-bin"
        "graphql-language-service-cli"
    )
    
    for package in "${PACKAGES[@]}"; do
        log_info "Installando $package..."
        npm install -g "$package"
    done
    
    log_success "Dipendenze npm installate!"
}

# Installa font con icone
install_fonts() {
    log_info "Installando Nerd Fonts..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - Installa i font direttamente senza il tap deprecato
        if command_exists brew; then
            log_info "Installando font tramite download diretto..."
            
            # Crea directory font se non esiste
            mkdir -p ~/Library/Fonts
            
            # Scarica FiraCode Nerd Font
            log_info "Scaricando FiraCode Nerd Font..."
            curl -fLo ~/Library/Fonts/FiraCodeNerdFont-Regular.ttf \
                https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
            curl -fLo ~/Library/Fonts/FiraCodeNerdFont-Bold.ttf \
                https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Bold/FiraCodeNerdFont-Bold.ttf
            
            # Scarica JetBrains Mono Nerd Font
            log_info "Scaricando JetBrains Mono Nerd Font..."
            curl -fLo ~/Library/Fonts/JetBrainsMonoNerdFont-Regular.ttf \
                https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf
            curl -fLo ~/Library/Fonts/JetBrainsMonoNerdFont-Bold.ttf \
                https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Bold/JetBrainsMonoNerdFont-Bold.ttf
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        mkdir -p ~/.local/share/fonts
        cd ~/.local/share/fonts
        
        # Scarica FiraCode Nerd Font
        curl -fLo "FiraCode-Regular.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf
        curl -fLo "FiraCode-Bold.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Bold/complete/Fira%20Code%20Bold%20Nerd%20Font%20Complete.ttf
        
        # Aggiorna cache font
        fc-cache -fv
    fi
    
    log_success "Font installati!"
}

# Backup configurazione esistente
backup_existing_config() {
    if [ -f ~/.vimrc ] || [ -d ~/.vim ]; then
        log_info "Creando backup della configurazione Vim esistente..."
        BACKUP_DIR="$HOME/.vim-backup-$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$BACKUP_DIR"
        
        [ -f ~/.vimrc ] && cp ~/.vimrc "$BACKUP_DIR/"
        [ -d ~/.vim ] && cp -r ~/.vim "$BACKUP_DIR/"
        
        log_success "Backup creato in: $BACKUP_DIR"
    fi
}

# Installa configurazione Vim
install_vim_config() {
    log_info "Installando configurazione Vim..."
    
    # Copia .vimrc
    cp .vimrc ~/.vimrc
    
    # Copia configurazione COC
    mkdir -p ~/.vim
    cp coc-settings.json ~/.vim/
    
    # Aggiungi configurazioni COC al .vimrc se non già presenti
    if ! grep -q "Configurazioni COC" ~/.vimrc; then
        echo "" >> ~/.vimrc
        cat coc-config.vim >> ~/.vimrc
    fi
    
    log_success "Configurazione Vim installata!"
}

# Installa vim-plug e plugin
install_plugins() {
    log_info "Installando vim-plug e plugin..."
    
    # vim-plug si installa automaticamente dal .vimrc
    # Installa tutti i plugin
    vim +PlugInstall +qall
    
    log_success "Plugin installati!"
}

# Installa estensioni COC
install_coc_extensions() {
    log_info "Installando estensioni COC..."
    
    # Le estensioni si installano automaticamente dalla configurazione
    vim +"CocInstall -sync coc-tsserver coc-json coc-html coc-css coc-prettier coc-eslint coc-emmet coc-snippets coc-pairs coc-marketplace coc-explorer coc-git coc-highlight coc-yank coc-lists" +qall
    
    log_success "Estensioni COC installate!"
}

# Crea file di configurazione esempio
create_example_configs() {
    log_info "Creando file di configurazione esempio..."
    
    # .eslintrc.json
    cat > ~/.eslintrc.json << 'EOF'
{
  "env": {
    "browser": true,
    "es6": true,
    "node": true
  },
  "extends": [
    "eslint:recommended",
    "@typescript-eslint/recommended"
  ],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": 2020,
    "sourceType": "module",
    "ecmaFeatures": {
      "jsx": true
    }
  },
  "plugins": [
    "@typescript-eslint",
    "react"
  ],
  "rules": {
    "semi": ["error", "never"],
    "quotes": ["error", "single"],
    "no-console": "warn",
    "@typescript-eslint/no-unused-vars": "error",
    "@typescript-eslint/explicit-module-boundary-types": "off"
  }
}
EOF

    # .prettierrc
    cat > ~/.prettierrc << 'EOF'
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 80,
  "bracketSpacing": true,
  "arrowParens": "always"
}
EOF

    # tsconfig.json esempio
    cat > ~/tsconfig.example.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020", "DOM"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

    log_success "File di configurazione esempio creati!"
}

# Verifica installazione
verify_installation() {
    log_info "Verificando installazione..."
    
    ERRORS=0
    
    if ! command_exists vim; then
        log_error "Vim non trovato"
        ERRORS=$((ERRORS + 1))
    fi
    
    if ! command_exists node; then
        log_error "Node.js non trovato"
        ERRORS=$((ERRORS + 1))
    fi
    
    if ! command_exists npm; then
        log_error "npm non trovato"
        ERRORS=$((ERRORS + 1))
    fi
    
    if [ ! -f ~/.vimrc ]; then
        log_error ".vimrc non trovato"
        ERRORS=$((ERRORS + 1))
    fi
    
    if [ ! -f ~/.vim/coc-settings.json ]; then
        log_error "coc-settings.json non trovato"
        ERRORS=$((ERRORS + 1))
    fi
    
    if [ $ERRORS -eq 0 ]; then
        log_success "Installazione completata con successo!"
        echo ""
        echo "🎉 MioVim è stato installato!"
        echo ""
        echo "Per iniziare:"
        echo "1. Apri Vim: vim"
        echo "2. La configurazione si caricherà automaticamente"
        echo "3. Usa <Space> come leader key"
        echo "4. Premi <Space>nt per aprire NERDTree"
        echo "5. Premi <Space>e per aprire COC Explorer"
        echo ""
        echo "Comandi utili:"
        echo "- <Space>p: Fuzzy finder (CtrlP)"
        echo "- <Space>a: Ricerca testo (Ack)"
        echo "- gd: Vai alla definizione"
        echo "- K: Mostra documentazione"
        echo "- <Space>rn: Rinomina symbol"
        echo "- <Space>f: Formatta codice"
        echo ""
        echo "Configurazioni esempio create in home directory:"
        echo "- ~/.eslintrc.json"
        echo "- ~/.prettierrc"
        echo "- ~/tsconfig.example.json"
    else
        log_error "Installazione completata con $ERRORS errori"
        exit 1
    fi
}

# Funzione principale
main() {
    echo "============================================================================"
    echo "🚀 MioVim - Installazione configurazione Vim per JavaScript/TypeScript"
    echo "============================================================================"
    echo ""
    
    # Verifica se siamo nella directory corretta
    if [ ! -f ".vimrc" ]; then
        log_error "File .vimrc non trovato. Esegui lo script dalla directory del progetto."
        exit 1
    fi
    
    log_info "Inizio installazione..."
    
    # Richiedi conferma
    read -p "Continuare con l'installazione? [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Installazione annullata"
        exit 0
    fi
    
    # Fasi installazione
    install_homebrew
    install_vim
    install_nodejs
    install_npm_dependencies
    install_fonts
    backup_existing_config
    install_vim_config
    install_plugins
    install_coc_extensions
    create_example_configs
    verify_installation
}

# Esegui solo se chiamato direttamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi