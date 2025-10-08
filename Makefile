# MioVim Makefile
# Automatizza operazioni comuni per la configurazione Vim

.PHONY: help install quick-install advanced-install uninstall backup test clean demo

# Colori per output
GREEN = \033[0;32m
BLUE = \033[0;34m
YELLOW = \033[0;33m
NC = \033[0m

help: ## Mostra questo help
	@echo "$(BLUE)MioVim - Makefile Commands$(NC)"
	@echo "=========================="
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'

install: ## Installazione completa (default)
	@echo "$(BLUE)🚀 Avvio installazione completa...$(NC)"
	@chmod +x install.sh
	@./install.sh

install-no-fonts: ## Installazione completa senza font (evita problemi Homebrew)
	@echo "$(BLUE)🚀 Avvio installazione senza font...$(NC)"
	@chmod +x install-no-fonts.sh
	@./install-no-fonts.sh

quick: ## Installazione rapida (solo configurazione Vim)
	@echo "$(BLUE)⚡ Avvio installazione rapida...$(NC)"
	@chmod +x quick-install.sh
	@./quick-install.sh

advanced: ## Installazione avanzata con opzioni
	@echo "$(BLUE)🔧 Avvio installazione avanzata...$(NC)"
	@chmod +x install-advanced.sh
	@./install-advanced.sh

minimal: ## Installazione minimale
	@echo "$(BLUE)📦 Avvio installazione minimale...$(NC)"
	@chmod +x install-advanced.sh
	@./install-advanced.sh --minimal

uninstall: ## Disinstalla MioVim
	@echo "$(YELLOW)🗑️ Avvio disinstallazione...$(NC)"
	@chmod +x uninstall.sh
	@./uninstall.sh

backup: ## Crea backup della configurazione attuale
	@echo "$(BLUE)📦 Creando backup...$(NC)"
	@BACKUP_DIR="$$HOME/.vim-backup-$$(date +%Y%m%d_%H%M%S)"; \
	mkdir -p "$$BACKUP_DIR"; \
	[ -f ~/.vimrc ] && cp ~/.vimrc "$$BACKUP_DIR/"; \
	[ -d ~/.vim ] && cp -r ~/.vim "$$BACKUP_DIR/"; \
	echo "$(GREEN)✓ Backup creato in: $$BACKUP_DIR$(NC)"

test: ## Testa la configurazione
	@echo "$(BLUE)🧪 Testando configurazione...$(NC)"
	@echo "Verificando file necessari..."
	@test -f .vimrc && echo "$(GREEN)✓ .vimrc presente$(NC)" || echo "❌ .vimrc mancante"
	@test -f coc-settings.json && echo "$(GREEN)✓ coc-settings.json presente$(NC)" || echo "❌ coc-settings.json mancante"
	@test -f install.sh && echo "$(GREEN)✓ install.sh presente$(NC)" || echo "❌ install.sh mancante"
	@test -x install.sh && echo "$(GREEN)✓ install.sh eseguibile$(NC)" || echo "❌ install.sh non eseguibile"
	@echo "Verificando sintassi script..."
	@bash -n install.sh && echo "$(GREEN)✓ install.sh sintassi OK$(NC)" || echo "❌ install.sh errori sintassi"
	@bash -n quick-install.sh && echo "$(GREEN)✓ quick-install.sh sintassi OK$(NC)" || echo "❌ quick-install.sh errori sintassi"

clean: ## Pulisci file temporanei
	@echo "$(BLUE)🧹 Pulizia file temporanei...$(NC)"
	@rm -f .*.swp .*.swo *~
	@rm -rf .vim/backup/* .vim/swap/* .vim/undo/*
	@echo "$(GREEN)✓ Pulizia completata$(NC)"

demo: ## Crea progetto demo per testare MioVim
	@echo "$(BLUE)🎯 Creando progetto demo...$(NC)"
	@mkdir -p ~/miovim-demo/{src,tests,docs}
	@cp eslintrc.example.json ~/miovim-demo/.eslintrc.json
	@cp prettierrc.example.json ~/miovim-demo/.prettierrc
	@cp tsconfig.example.json ~/miovim-demo/tsconfig.json
	@cp gitignore.example ~/miovim-demo/.gitignore
	@echo 'console.log("Hello MioVim!");' > ~/miovim-demo/src/index.js
	@echo 'export interface User { id: number; name: string; }' > ~/miovim-demo/src/types.ts
	@echo "$(GREEN)✓ Progetto demo creato in ~/miovim-demo/$(NC)"
	@echo "$(YELLOW)Apri con: cd ~/miovim-demo && vim src/index.js$(NC)"

update: ## Aggiorna configurazione esistente
	@echo "$(BLUE)🔄 Aggiornando configurazione...$(NC)"
	@make backup
	@cp .vimrc ~/.vimrc
	@cp coc-settings.json ~/.vim/
	@echo "$(GREEN)✓ Configurazione aggiornata$(NC)"

check-deps: ## Verifica dipendenze installate
	@echo "$(BLUE)🔍 Verificando dipendenze...$(NC)"
	@command -v vim >/dev/null 2>&1 && echo "$(GREEN)✓ Vim installato$(NC)" || echo "❌ Vim non trovato"
	@command -v node >/dev/null 2>&1 && echo "$(GREEN)✓ Node.js installato: $$(node --version)$(NC)" || echo "❌ Node.js non trovato"
	@command -v npm >/dev/null 2>&1 && echo "$(GREEN)✓ npm installato: $$(npm --version)$(NC)" || echo "❌ npm non trovato"
	@command -v git >/dev/null 2>&1 && echo "$(GREEN)✓ Git installato$(NC)" || echo "❌ Git non trovato"
	@test -f ~/.vimrc && echo "$(GREEN)✓ .vimrc installato$(NC)" || echo "❌ .vimrc non trovato"
	@test -f ~/.vim/coc-settings.json && echo "$(GREEN)✓ COC configurato$(NC)" || echo "❌ COC non configurato"

info: ## Mostra informazioni di sistema
	@echo "$(BLUE)ℹ️ Informazioni Sistema$(NC)"
	@echo "===================="
	@echo "OS: $$(uname -s)"
	@echo "Arch: $$(uname -m)"
	@echo "Shell: $$SHELL"
	@echo "Home: $$HOME"
	@echo "PWD: $$(pwd)"
	@echo ""
	@echo "$(BLUE)Versioni:$(NC)"
	@command -v vim >/dev/null 2>&1 && echo "Vim: $$(vim --version | head -1)" || echo "Vim: Non installato"
	@command -v node >/dev/null 2>&1 && echo "Node.js: $$(node --version)" || echo "Node.js: Non installato"
	@command -v npm >/dev/null 2>&1 && echo "npm: $$(npm --version)" || echo "npm: Non installato"

# Default target
all: install

# Make sure scripts are executable
.ONESHELL:
permissions:
	@chmod +x *.sh