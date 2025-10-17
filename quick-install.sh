#!/bin/bash

# ============================================================================
# MioVim - Script di installazione rapida
# ============================================================================

set -e

# Colori
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🚀 MioVim - Installazione Rapida${NC}"
echo "=================================="
echo ""

# Verifica se siamo nella directory corretta
if [ ! -f ".vimrc" ]; then
    echo -e "${RED}❌ Errore: file .vimrc non trovato${NC}"
    echo "Esegui lo script dalla directory del progetto miovim"
    exit 1
fi

echo -e "${BLUE}📋 Questa installazione include:${NC}"
echo "• ✅ Backup configurazione esistente"
echo "• ✅ Installazione .vimrc ottimizzato"
echo "• ✅ Configurazione COC per LSP"
echo "• ✅ Plugin Vim automatici"
echo "• ✅ File di configurazione esempio"
echo ""

read -p "Continuare? [y/N]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Installazione annullata${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}🔄 Avvio installazione...${NC}"

# 1. Backup configurazione esistente
if [ -f ~/.vimrc ] || [ -d ~/.vim ]; then
    echo -e "${YELLOW}📦 Creando backup...${NC}"
    BACKUP_DIR="$HOME/.vim-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    [ -f ~/.vimrc ] && cp ~/.vimrc "$BACKUP_DIR/"
    [ -d ~/.vim ] && cp -r ~/.vim "$BACKUP_DIR/"
    echo -e "${GREEN}✓ Backup creato in: $BACKUP_DIR${NC}"
fi

# 2. Installa configurazione principale
echo -e "${YELLOW}📝 Installando configurazione Vim...${NC}"
cp .vimrc ~/.vimrc
mkdir -p ~/.vim
cp coc-settings.json ~/.vim/

# Aggiungi configurazioni COC se non già presenti
if ! grep -q "Configurazioni COC" ~/.vimrc; then
    echo "" >> ~/.vimrc
    cat coc-config.vim >> ~/.vimrc
fi

echo -e "${GREEN}✓ Configurazione Vim installata${NC}"

# 3. Crea directory necessarie
echo -e "${YELLOW}📁 Creando directory...${NC}"
mkdir -p ~/.vim/{backup,swap,undo}
echo -e "${GREEN}✓ Directory create${NC}"

# 4. Installa vim-plug se non presente
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    echo -e "${YELLOW}🔌 Installando vim-plug...${NC}"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo -e "${GREEN}✓ vim-plug installato${NC}"
fi

# 5. Crea file di configurazione esempio
echo -e "${YELLOW}⚙️ Creando file di configurazione esempio...${NC}"

# .eslintrc.json
if [ ! -f ~/.eslintrc.json ]; then
    cp eslintrc.example.json ~/.eslintrc.json
    echo -e "${GREEN}✓ .eslintrc.json creato${NC}"
fi

# .prettierrc
if [ ! -f ~/.prettierrc ]; then
    cp prettierrc.example.json ~/.prettierrc
    echo -e "${GREEN}✓ .prettierrc creato${NC}"
fi

# .prettierignore
if [ ! -f ~/.prettierignore ]; then
    cp prettierignore.example ~/.prettierignore
    echo -e "${GREEN}✓ .prettierignore creato${NC}"
fi

# tsconfig.json esempio
if [ ! -f ~/tsconfig.example.json ]; then
    cp tsconfig.example.json ~/tsconfig.example.json
    echo -e "${GREEN}✓ tsconfig.example.json creato${NC}"
fi

# 6. Messaggio finale
echo ""
echo -e "${GREEN}🎉 Installazione completata!${NC}"
echo ""
echo -e "${BLUE}📚 Prossimi passi:${NC}"
echo "1. Apri Vim: ${YELLOW}vim${NC}"
echo "2. I plugin si installeranno automaticamente al primo avvio"
echo "3. Per installare le estensioni COC, esegui in Vim:"
echo "   ${YELLOW}:CocInstall coc-tsserver coc-eslint coc-prettier coc-json${NC}"
echo ""
echo -e "${BLUE}🎮 Comandi base:${NC}"
echo "• Leader key: ${YELLOW}<Space>${NC}"
echo "• File explorer: ${YELLOW}<Space>nt${NC}"
echo "• Fuzzy finder: ${YELLOW}<Space>p${NC}"
echo "• Vai alla definizione: ${YELLOW}gd${NC}"
echo "• Mostra docs: ${YELLOW}K${NC}"
echo "• Formatta: ${YELLOW}<Space>f${NC}"
echo ""
echo -e "${BLUE}📖 Per installazione completa con Node.js e dipendenze:${NC}"
echo "   ${YELLOW}./install.sh${NC}"
echo ""
echo -e "${GREEN}Happy coding! 🎯${NC}"