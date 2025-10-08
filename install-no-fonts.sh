#!/bin/bash

# ============================================================================
# MioVim - Script di installazione senza font (per evitare problemi Homebrew)
# ============================================================================

set -e

# Colori
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "============================================================================"
echo "🚀 MioVim - Installazione senza font (evita problemi Homebrew)"
echo "============================================================================"
echo ""

# Verifica se siamo nella directory corretta
if [ ! -f ".vimrc" ]; then
    log_error "File .vimrc non trovato. Esegui lo script dalla directory del progetto."
    exit 1
fi

log_info "Questa installazione include tutto tranne i font Nerd Font"
echo "• ✅ Vim (se necessario)"
echo "• ✅ Node.js e npm"
echo "• ✅ Dipendenze npm globali"
echo "• ✅ Configurazione Vim completa"
echo "• ✅ Plugin Vim"
echo "• ✅ Estensioni COC"
echo "• ⚠️  Font: da installare manualmente"
echo ""

read -p "Continuare con l'installazione? [y/N]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "Installazione annullata"
    exit 0
fi

# Source delle funzioni dal file install.sh originale
source ./install.sh

# Definisci una funzione install_fonts vuota per saltare i font
install_fonts() {
    log_warning "Saltando installazione font per evitare problemi Homebrew"
    log_info "Per installare i font manualmente:"
    echo "1. Vai su: https://www.nerdfonts.com/font-downloads"
    echo "2. Scarica FiraCode Nerd Font o JetBrains Mono Nerd Font"
    echo "3. Installa facendo doppio click sui file .ttf/.otf"
    echo "4. Riavvia il terminale per utilizzare i nuovi font"
}

# Esegui l'installazione senza font
log_info "Avvio installazione..."

install_homebrew
install_vim
install_nodejs
install_npm_dependencies
install_fonts  # Versione vuota che non fa nulla
backup_existing_config
install_vim_config
install_plugins
install_coc_extensions
create_example_configs
verify_installation

log_success "Installazione completata senza font!"
echo ""
log_warning "IMPORTANTE: Per le icone nei file explorer, installa manualmente i Nerd Font:"
echo "1. Visita: https://www.nerdfonts.com/font-downloads"
echo "2. Scarica 'FiraCode Nerd Font' o 'JetBrains Mono Nerd Font'"
echo "3. Installa i font sul sistema"
echo "4. Configura il terminale per usare il nuovo font"
echo ""
echo "🎉 MioVim è pronto per l'uso!"