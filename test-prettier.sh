#!/bin/bash

# ============================================================================
# Script di test per verificare configurazione Prettier uguale a VS Code
# ============================================================================

echo "🧪 Test Prettier Configuration vs VS Code"
echo "=========================================="

# Crea file di test
cat > test-prettier.js << 'EOF'
const obj={a:1,b:2,c:3};
function test(x,y,z){
if(x>y){
return z;
}
return null;
}
const arrow=(a,b)=>a+b;
const str='Hello World';
const template=`Template ${str}`;
EOF

echo "📝 File di test creato:"
echo "======================="
cat test-prettier.js
echo ""

# Test con Prettier di sistema
if command -v prettier >/dev/null 2>&1; then
    echo "🔧 Formattazione con Prettier di sistema:"
    echo "========================================"
    prettier test-prettier.js
    echo ""
fi

# Test con COC Prettier (simula Vim)
echo "🎯 Per testare in Vim:"
echo "====================="
echo "1. Apri il file: vim test-prettier.js"
echo "2. Premi <Space>f per formattare"
echo "3. Oppure :CocCommand prettier.formatFile"
echo "4. Il risultato dovrebbe essere identico a VS Code"
echo ""

echo "✅ Impostazioni attese (come VS Code default):"
echo "=============================================="
echo "• Semi: true (punto e virgola alla fine)"
echo "• Quotes: false (doppi apici, non singoli)"
echo "• Tab width: 2"
echo "• Print width: 80"
echo "• Trailing comma: es5"
echo "• Bracket spacing: true"
echo ""

# Cleanup
# rm -f test-prettier.js

echo "🎯 File test-prettier.js creato per testing manuale"