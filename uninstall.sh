#!/bin/bash

# ============================================================================
# MioVim - Script di disinstallazione
# ============================================================================

set -e

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Funzione principale di disinstallazione
uninstall_miovim() {
    echo "============================================================================"
    echo "🗑️  MioVim - Disinstallazione configurazione Vim"
    echo "============================================================================"
    echo ""
    
    log_warning "Questa operazione rimuoverà:"
    echo "  - ~/.vimrc"
    echo "  - ~/.vim/coc-settings.json"
    echo "  - ~/.vim/plugged/ (tutti i plugin)"
    echo "  - ~/.vim/backup/, ~/.vim/swap/, ~/.vim/undo/"
    echo "  - File di configurazione esempio in home"
    echo ""
    
    read -p "Sei sicuro di voler continuare? [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Disinstallazione annullata"
        exit 0
    fi
    
    # Crea backup prima della rimozione
    log_info "Creando backup finale..."
    BACKUP_DIR="$HOME/.miovim-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Backup file esistenti
    [ -f ~/.vimrc ] && cp ~/.vimrc "$BACKUP_DIR/"
    [ -d ~/.vim ] && cp -r ~/.vim "$BACKUP_DIR/"
    [ -f ~/.eslintrc.json ] && cp ~/.eslintrc.json "$BACKUP_DIR/"
    [ -f ~/.prettierrc ] && cp ~/.prettierrc "$BACKUP_DIR/"
    [ -f ~/tsconfig.example.json ] && cp ~/tsconfig.example.json "$BACKUP_DIR/"
    
    log_success "Backup creato in: $BACKUP_DIR"
    
    # Rimuovi file di configurazione
    log_info "Rimuovendo file di configurazione..."
    
    rm -f ~/.vimrc
    rm -f ~/.vim/coc-settings.json
    rm -rf ~/.vim/plugged/
    rm -rf ~/.vim/backup/
    rm -rf ~/.vim/swap/
    rm -rf ~/.vim/undo/
    rm -f ~/.eslintrc.json
    rm -f ~/.prettierrc
    rm -f ~/tsconfig.example.json
    
    # Pulisci directory .vim se vuota
    if [ -d ~/.vim ] && [ -z "$(ls -A ~/.vim)" ]; then
        rmdir ~/.vim
        log_info "Directory ~/.vim rimossa (era vuota)"
    fi
    
    log_success "File di configurazione rimossi!"
    
    # Opzionale: rimuovi dipendenze npm globali
    echo ""
    read -p "Vuoi rimuovere anche le dipendenze npm globali installate? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Rimuovendo dipendenze npm globali..."
        
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
            if npm list -g "$package" >/dev/null 2>&1; then
                log_info "Rimuovendo $package..."
                npm uninstall -g "$package" 2>/dev/null || log_warning "Impossibile rimuovere $package"
            fi
        done
        
        log_success "Dipendenze npm rimosse!"
    fi
    
    echo ""
    log_success "🎉 MioVim disinstallato completamente!"
    echo ""
    echo "Backup dei tuoi file salvato in: $BACKUP_DIR"
    echo ""
    echo "Per reinstallare MioVim in futuro:"
    echo "  git clone https://github.com/sensorario/miovim.git"
    echo "  cd miovim && ./install.sh"
    echo ""
}

# Esegui solo se chiamato direttamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    uninstall_miovim "$@"
fi