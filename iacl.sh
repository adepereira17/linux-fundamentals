#!/bin/bash

# Verifica se os diretórios já existem antes de tentar criá-los
echo "Criando os diretórios..."
mkdir -p /publico /adm /ven /sec

# Verifica se os grupos já existem antes de tentar criá-los
echo "Criando os grupos..."
groupadd -f GRP_ADM
groupadd -f GRP_VEN
groupadd -f GRP_SEC

# Verifica se os usuários já existem antes de tentar criá-los
echo "Criando os usuários..."
useradd_existing_check() {
    while read -r user; do
        id "$user" &>/dev/null
        if [ $? -eq 0 ]; then
            echo "Usuário $user já existe."
        else
            useradd "$user" -m -s /bin/bash -G "$1"
            echo "Usuário $user criado."
        fi
    done
}

echo "Digite a senha para os usuários:"
read -s password

echo "$password" | useradd_existing_check GRP_ADM <<EOF
carlos
maria
joao
EOF

echo "$password" | useradd_existing_check GRP_VEN <<EOF
debora
sebastiana
roberto
EOF

echo "$password" | useradd_existing_check GRP_SEC <<EOF
josefina
amanda
rogerio
EOF

# Definindo as permissões dos diretórios
echo "Especificando permissões dos diretórios..."
chown root:GRP_ADM /adm
chown root:GRP_VEN /ven
chown root:GRP_SEC /sec

chmod 770 /adm /ven /sec
chmod 777 /publico

echo "Processo finalizado."

