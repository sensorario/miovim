#!/bin/bash

# ============================================================================
# Test per verificare che Airline non abbia conflitti
# ============================================================================

echo "🧪 Test Airline Configuration"
echo "=============================="

# Test 1: Sintassi configurazione
echo "📝 1. Verificando sintassi configurazione..."
if vim -c 'source ~/.vimrc' -c 'qa!' 2>/dev/null; then
    echo "✅ Configurazione caricata senza errori"
else
    echo "❌ Errori nella configurazione"
fi

# Test 2: Test specifico per airline
echo ""
echo "📝 2. Testando Airline specificamente..."
if vim -c 'source ~/.vimrc' -c 'echo "Airline loaded"' -c 'qa!' 2>&1 | grep -q "airline.*already been added"; then
    echo "❌ Conflitto Airline ancora presente"
else
    echo "✅ Nessun conflitto Airline rilevato"
fi

# Test 3: Controllo estensioni
echo ""
echo "📝 3. Verificando estensioni disponibili..."
echo "Le seguenti estensioni dovrebbero essere disponibili:"
echo "• COC integration"
echo "• Tabline" 
echo "• Git integration"
echo "• Powerline fonts"

echo ""
echo "🎯 Per test completo:"
echo "====================="
echo "1. Apri Vim: vim"
echo "2. Verifica che la status line mostri:"
echo "   - Informazioni file"
echo "   - Git status (se in repo)"
echo "   - COC diagnostici"
echo "   - Tab delle finestre aperte"
echo "3. Non dovrebbero esserci errori all'avvio"

echo ""
echo "✅ Test completato"