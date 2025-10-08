#!/bin/bash

# ============================================================================
# MioVim - Script di installazione avanzato con opzioni personalizzabili
# ============================================================================

set -e

# Versione dello script
VERSION="1.0.0"

# Colori
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Variabili di configurazione
INSTALL_VIM=true
INSTALL_NODEJS=true
INSTALL_FONTS=true
INSTALL_PLUGINS=true
INSTALL_COC_EXTENSIONS=true
CREATE_BACKUP=true
INTERACTIVE_MODE=true
MINIMAL_INSTALL=false

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

log_debug() {
    echo -e "${PURPLE}[DEBUG]${NC} $1"
}

print_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
    ███╗   ███╗██╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    ████╗ ████║██║██╔═══██╗██║   ██║██║████╗ ████║
    ██╔████╔██║██║██║   ██║██║   ██║██║██╔████╔██║
    ██║╚██╔╝██║██║██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚═╝ ██║██║╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝     ╚═╝╚═╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
EOF
    echo -e "${NC}"
    echo -e "${GREEN}Configurazione Vim per JavaScript/TypeScript v${VERSION}${NC}"
    echo ""
}

show_help() {
    cat << EOF
Uso: $0 [OPZIONI]

OPZIONI:
    -h, --help              Mostra questo help
    -v, --version           Mostra versione
    -y, --yes               Modalità non interattiva (sì a tutto)
    -m, --minimal           Installazione minimale (solo .vimrc base)
    --no-vim               Non installare Vim
    --no-nodejs            Non installare Node.js
    --no-fonts             Non installare font
    --no-plugins           Non installare plugin Vim
    --no-coc               Non installare estensioni COC
    --no-backup            Non creare backup
    --dry-run              Mostra cosa verrebbe fatto senza eseguire
    --config-only          Installa solo le configurazioni (non dipendenze)
    --update               Aggiorna configurazione esistente
    --theme THEME          Specifica tema (gruvbox, dracula, nord, onedark)

ESEMPI:
    $0                     Installazione completa interattiva
    $0 -y                  Installazione completa automatica
    $0 -m                  Installazione minimale
    $0 --no-nodejs --no-fonts  Installa senza Node.js e font
    $0 --config-only       Solo configurazioni Vim
    $0 --update            Aggiorna configurazione esistente
    $0 --theme dracula     Installa con tema Dracula

EOF
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

ask_user() {
    if [[ "$INTERACTIVE_MODE" == "false" ]]; then
        return 0
    fi
    
    local question="$1"
    local default="${2:-y}"
    
    if [[ "$default" == "y" ]]; then
        read -p "$question [Y/n]: " -n 1 -r
    else
        read -p "$question [y/N]: " -n 1 -r
    fi
    
    echo
    
    if [[ "$default" == "y" ]]; then
        [[ $REPLY =~ ^[Nn]$ ]] && return 1 || return 0
    else
        [[ $REPLY =~ ^[Yy]$ ]] && return 0 || return 1
    fi
}

check_system() {
    log_info "Verificando sistema..."
    
    # OS Detection
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        log_info "Sistema operativo: macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        log_info "Sistema operativo: Linux"
        
        # Detect package manager
        if command_exists apt-get; then
            PACKAGE_MANAGER="apt"
        elif command_exists yum; then
            PACKAGE_MANAGER="yum"
        elif command_exists dnf; then
            PACKAGE_MANAGER="dnf"
        elif command_exists pacman; then
            PACKAGE_MANAGER="pacman"
        else
            log_error "Package manager non supportato"
            exit 1
        fi
        log_info "Package manager: $PACKAGE_MANAGER"
    else
        log_error "Sistema operativo non supportato: $OSTYPE"
        exit 1
    fi
    
    # Verifica spazio disco
    if [[ "$OS" == "macos" ]]; then
        AVAILABLE_SPACE=$(df -h . | awk 'NR==2 {print $4}' | sed 's/G//')
    else
        AVAILABLE_SPACE=$(df -h . | awk 'NR==2 {print $4}' | sed 's/G//')
    fi
    
    log_info "Spazio disponibile: ${AVAILABLE_SPACE}G"
    
    # Verifica rete
    if ! ping -c 1 google.com >/dev/null 2>&1; then
        log_warning "Connessione internet non disponibile. Alcuni download potrebbero fallire."
    fi
}

install_vim_advanced() {
    if [[ "$INSTALL_VIM" == "false" ]]; then
        log_info "Saltando installazione Vim"
        return
    fi
    
    log_info "Installando Vim..."
    
    if command_exists vim; then
        VIM_VERSION=$(vim --version | head -n1)
        log_info "Vim già installato: $VIM_VERSION"
        
        if ask_user "Vuoi aggiornare Vim alla versione più recente?"; then
            case "$OS" in
                "macos")
                    if command_exists brew; then
                        brew upgrade vim
                    fi
                    ;;
                "linux")
                    case "$PACKAGE_MANAGER" in
                        "apt")
                            sudo apt update && sudo apt upgrade vim
                            ;;
                        "yum"|"dnf")
                            sudo $PACKAGE_MANAGER update vim
                            ;;
                        "pacman")
                            sudo pacman -Syu vim
                            ;;
                    esac
                    ;;
            esac
        fi
    else
        case "$OS" in
            "macos")
                if ! command_exists brew; then
                    log_info "Installando Homebrew..."
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                fi
                brew install vim
                ;;
            "linux")
                case "$PACKAGE_MANAGER" in
                    "apt")
                        sudo apt update && sudo apt install -y vim vim-gtk3
                        ;;
                    "yum")
                        sudo yum install -y vim vim-enhanced
                        ;;
                    "dnf")
                        sudo dnf install -y vim vim-enhanced
                        ;;
                    "pacman")
                        sudo pacman -S vim gvim
                        ;;
                esac
                ;;
        esac
    fi
    
    log_success "Vim installato/aggiornato!"
}

install_theme() {
    local theme="${1:-gruvbox}"
    
    log_info "Configurando tema: $theme"
    
    case "$theme" in
        "gruvbox")
            # Già configurato nel .vimrc
            ;;
        "dracula")
            echo "Plug 'dracula/vim', { 'as': 'dracula' }" >> ~/.vimrc.themes
            echo "colorscheme dracula" >> ~/.vimrc.themes
            ;;
        "nord")
            echo "Plug 'arcticicestudio/nord-vim'" >> ~/.vimrc.themes
            echo "colorscheme nord" >> ~/.vimrc.themes
            ;;
        "onedark")
            echo "Plug 'joshdick/onedark.vim'" >> ~/.vimrc.themes
            echo "colorscheme onedark" >> ~/.vimrc.themes
            ;;
        *)
            log_warning "Tema '$theme' non riconosciuto. Usando gruvbox."
            ;;
    esac
}

create_development_environment() {
    log_info "Creando ambiente di sviluppo esempio..."
    
    # Crea struttura progetto esempio
    mkdir -p ~/miovim-demo/{src,tests,docs}
    
    # File TypeScript esempio
    cat > ~/miovim-demo/src/index.ts << 'EOF'
// MioVim Demo - File TypeScript esempio
interface User {
  id: number
  name: string
  email: string
}

class UserService {
  private users: User[] = []
  
  constructor() {
    this.loadUsers()
  }
  
  async loadUsers(): Promise<void> {
    // Simula caricamento asincrono
    setTimeout(() => {
      this.users = [
        { id: 1, name: 'Mario Rossi', email: 'mario@example.com' },
        { id: 2, name: 'Luigi Bianchi', email: 'luigi@example.com' }
      ]
      console.log('Utenti caricati:', this.users.length)
    }, 1000)
  }
  
  getUserById(id: number): User | undefined {
    return this.users.find(user => user.id === id)
  }
  
  getAllUsers(): User[] {
    return [...this.users]
  }
}

// Test delle funzionalità
const userService = new UserService()

// Prova il completamento automatico, go-to-definition, e refactoring!
export { UserService, User }
EOF

    # File React/JSX esempio
    cat > ~/miovim-demo/src/UserComponent.tsx << 'EOF'
import React, { useState, useEffect } from 'react'

interface User {
  id: number
  name: string
  email: string
}

interface UserComponentProps {
  userId: number
  onUserLoad?: (user: User) => void
}

const UserComponent: React.FC<UserComponentProps> = ({ userId, onUserLoad }) => {
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    const fetchUser = async () => {
      try {
        setLoading(true)
        // Simula API call
        const response = await fetch(`/api/users/${userId}`)
        const userData = await response.json()
        setUser(userData)
        onUserLoad?.(userData)
      } catch (err) {
        setError('Errore nel caricamento utente')
        console.error(err)
      } finally {
        setLoading(false)
      }
    }

    fetchUser()
  }, [userId, onUserLoad])

  if (loading) return <div>Caricamento...</div>
  if (error) return <div className="error">{error}</div>
  if (!user) return <div>Utente non trovato</div>

  return (
    <div className="user-card">
      <h2>{user.name}</h2>
      <p>Email: {user.email}</p>
      <p>ID: {user.id}</p>
    </div>
  )
}

export default UserComponent
EOF

    # package.json esempio
    cat > ~/miovim-demo/package.json << 'EOF'
{
  "name": "miovim-demo",
  "version": "1.0.0",
  "description": "Progetto demo per testare MioVim",
  "main": "src/index.ts",
  "scripts": {
    "build": "tsc",
    "dev": "ts-node src/index.ts",
    "test": "jest",
    "lint": "eslint src/**/*.{ts,tsx}",
    "format": "prettier --write src/**/*.{ts,tsx}"
  },
  "dependencies": {
    "react": "^18.0.0",
    "react-dom": "^18.0.0"
  },
  "devDependencies": {
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "typescript": "^5.0.0",
    "ts-node": "^10.0.0",
    "jest": "^29.0.0",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.0.0",
    "eslint-plugin-react": "^7.0.0",
    "prettier": "^3.0.0"
  }
}
EOF

    # Copia configurazioni esempio
    cp eslintrc.example.json ~/miovim-demo/.eslintrc.json
    cp prettierrc.example.json ~/miovim-demo/.prettierrc
    cp tsconfig.example.json ~/miovim-demo/tsconfig.json
    cp gitignore.example ~/miovim-demo/.gitignore
    
    log_success "Ambiente demo creato in ~/miovim-demo/"
    log_info "Apri il progetto con: cd ~/miovim-demo && vim src/index.ts"
}

run_post_install_tests() {
    log_info "Eseguendo test post-installazione..."
    
    # Test 1: Vim è installato e funzionante
    if command_exists vim; then
        log_success "✓ Vim installato correttamente"
    else
        log_error "✗ Vim non trovato"
        return 1
    fi
    
    # Test 2: Node.js è installato
    if command_exists node; then
        NODE_VERSION=$(node --version)
        log_success "✓ Node.js installato: $NODE_VERSION"
    else
        log_warning "! Node.js non trovato"
    fi
    
    # Test 3: File di configurazione esistono
    if [[ -f ~/.vimrc ]]; then
        log_success "✓ .vimrc installato"
    else
        log_error "✗ .vimrc mancante"
        return 1
    fi
    
    if [[ -f ~/.vim/coc-settings.json ]]; then
        log_success "✓ coc-settings.json installato"
    else
        log_warning "! coc-settings.json mancante"
    fi
    
    # Test 4: Plugin directory esiste
    if [[ -d ~/.vim/plugged ]]; then
        PLUGIN_COUNT=$(ls -1 ~/.vim/plugged | wc -l)
        log_success "✓ Plugin directory creata ($PLUGIN_COUNT plugin)"
    else
        log_warning "! Plugin directory mancante"
    fi
    
    log_success "Test completati!"
}

show_post_install_info() {
    echo ""
    echo -e "${GREEN}🎉 Installazione MioVim completata!${NC}"
    echo ""
    echo -e "${CYAN}📚 Prossimi passi:${NC}"
    echo "1. Apri Vim: ${YELLOW}vim${NC}"
    echo "2. I plugin si installeranno automaticamente al primo avvio"
    echo "3. Usa ${YELLOW}<Space>${NC} come leader key"
    echo ""
    echo -e "${CYAN}🚀 Comandi utili per iniziare:${NC}"
    echo "• ${YELLOW}<Space>nt${NC} - Apri NERDTree"
    echo "• ${YELLOW}<Space>e${NC} - Apri COC Explorer"  
    echo "• ${YELLOW}<Space>p${NC} - Fuzzy finder"
    echo "• ${YELLOW}gd${NC} - Vai alla definizione"
    echo "• ${YELLOW}K${NC} - Mostra documentazione"
    echo "• ${YELLOW}<Space>f${NC} - Formatta codice"
    echo ""
    echo -e "${CYAN}📁 Progetto demo creato in:${NC} ${YELLOW}~/miovim-demo/${NC}"
    echo -e "${CYAN}📖 Documentazione completa:${NC} ${YELLOW}cat README.md${NC}"
    echo ""
    echo -e "${GREEN}Happy coding! 🎯${NC}"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            echo "MioVim installer v$VERSION"
            exit 0
            ;;
        -y|--yes)
            INTERACTIVE_MODE=false
            shift
            ;;
        -m|--minimal)
            MINIMAL_INSTALL=true
            INSTALL_NODEJS=false
            INSTALL_FONTS=false
            INSTALL_COC_EXTENSIONS=false
            shift
            ;;
        --no-vim)
            INSTALL_VIM=false
            shift
            ;;
        --no-nodejs)
            INSTALL_NODEJS=false
            shift
            ;;
        --no-fonts)
            INSTALL_FONTS=false
            shift
            ;;
        --no-plugins)
            INSTALL_PLUGINS=false
            shift
            ;;
        --no-coc)
            INSTALL_COC_EXTENSIONS=false
            shift
            ;;
        --no-backup)
            CREATE_BACKUP=false
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --config-only)
            INSTALL_VIM=false
            INSTALL_NODEJS=false
            INSTALL_FONTS=false
            shift
            ;;
        --update)
            UPDATE_MODE=true
            shift
            ;;
        --theme)
            THEME="$2"
            shift 2
            ;;
        *)
            log_error "Opzione sconosciuta: $1"
            show_help
            exit 1
            ;;
    esac
done

# Main execution
main() {
    print_banner
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "MODALITÀ DRY-RUN - Nessuna modifica verrà effettuata"
        echo ""
    fi
    
    check_system
    
    if [[ "$MINIMAL_INSTALL" == "true" ]]; then
        log_info "Modalità installazione minimale"
    fi
    
    # Source the original install script and run components
    source ./install.sh
    
    # Run the installation steps
    if [[ "$INSTALL_VIM" == "true" ]]; then
        install_vim_advanced
    fi
    
    if [[ "$INSTALL_NODEJS" == "true" ]]; then
        install_nodejs
    fi
    
    if [[ "$INSTALL_FONTS" == "true" ]]; then
        install_fonts
    fi
    
    if [[ "$CREATE_BACKUP" == "true" ]]; then
        backup_existing_config
    fi
    
    install_vim_config
    
    if [[ "$INSTALL_PLUGINS" == "true" ]]; then
        install_plugins
    fi
    
    if [[ "$INSTALL_COC_EXTENSIONS" == "true" ]]; then
        install_coc_extensions
    fi
    
    if [[ -n "$THEME" ]]; then
        install_theme "$THEME"
    fi
    
    create_example_configs
    create_development_environment
    
    if [[ "$DRY_RUN" != "true" ]]; then
        run_post_install_tests
        show_post_install_info
    fi
}

# Run only if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi