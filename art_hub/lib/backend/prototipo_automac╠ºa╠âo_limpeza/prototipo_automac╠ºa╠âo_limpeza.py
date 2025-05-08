import datetime
import json
import os
import pandas as pd

# diretório do arquivo .py atual
diretorio_atual = os.path.dirname(os.path.abspath(__file__))

# caminho completo para o arquivo JSON
caminho_arquivo = os.path.join(diretorio_atual, "dados_limpeza.json")
caminho_usuarios = os.path.join(diretorio_atual, "usuarios.json")
caminho_propriedades = os.path.join(diretorio_atual, "propriedades.json")

# Verifica e cria arquivos se não existirem
for arquivo in [caminho_arquivo, caminho_usuarios, caminho_propriedades]:
    if not os.path.exists(arquivo):
        with open(arquivo, 'w') as f:
            json.dump({}, f, indent=4)

class SistemaLimpeza:
    def __init__(self):
        self.arquivo_dados = caminho_arquivo
        self.arquivo_usuarios = caminho_usuarios
        self.arquivo_propriedades = caminho_propriedades
        self.apartamentos = self.carregar_dados()
        self.usuarios = self.carregar_usuarios()
        self.propriedades = self.carregar_propriedades()
        self.usuario_logado = None
        
        # Definindo os status possíveis
        self.STATUS_PENDENTE = 'pendente'
        self.STATUS_EM_ANDAMENTO = 'em_andamento'
        self.STATUS_FINALIZADA_ESPERANDO_ANALISE = 'finalizada_esperando_analise'
        self.STATUS_APROVADA = 'aprovada'
        self.STATUS_REPROVADA = 'reprovada'
        
    def obter_historico_por_usuario(self, login=None, data_inicio=None, data_fim=None, propriedade=None):
        historico = []

        for ap, dados in self.apartamentos.items():
        # Se login informado, filtra por ele
            if login and dados.get('funcionario') != login:
                continue

            if dados.get('status') not in [
            self.STATUS_FINALIZADA_ESPERANDO_ANALISE,
            self.STATUS_APROVADA,
            self.STATUS_REPROVADA
        ]:
                continue

            if propriedade and dados.get('propriedade') != propriedade:
                continue

            data_limpeza_str = dados.get('data_limpeza')
            if data_limpeza_str:
                try:
                    data_limpeza = datetime.datetime.strptime(data_limpeza_str, "%Y-%m-%d %H:%M")
                    if data_inicio and data_limpeza < data_inicio:
                        continue
                    if data_fim and data_limpeza > data_fim:
                        continue
                except Exception as e:
                    print(f"Erro ao converter data da limpeza: {e}")
                    continue

        tarefa = dict(dados)
        tarefa['apartamento'] = ap
        historico.append(tarefa)

        return historico



    def carregar_dados(self):
        """Carrega os dados do arquivo JSON ou retorna uma estrutura vazia"""
        return self._carregar_json(self.arquivo_dados)
    
    def carregar_usuarios(self):
        """Carrega os usuários do arquivo JSON"""
        dados = self._carregar_json(self.arquivo_usuarios)
        return [Usuario(u['nome'], u['login'], u['senha'], u['tipo']) for u in dados.values()]
    
    def carregar_propriedades(self):
        """Carrega as propriedades do arquivo JSON"""
        return self._carregar_json(self.arquivo_propriedades)
    
    def _carregar_json(self, arquivo):
        """Método genérico para carregar JSON"""
        if os.path.exists(arquivo):
            with open(arquivo, 'r') as f:
                try:
                    content = f.read().strip()
                    return json.loads(content) if content else {}
                except json.JSONDecodeError:
                    return {}
        return {}
    
    def salvar_dados(self):
        """Salva os dados nos arquivos JSON"""
        try:
            with open(self.arquivo_dados, 'w') as f:
                json.dump(self.apartamentos, f, indent=4)
            
            usuarios_dict = {u.login: {'nome': u.nome, 'login': u.login, 
                            'senha': u.senha, 'tipo': u.tipo} for u in self.usuarios}
            with open(self.arquivo_usuarios, 'w') as f:
                json.dump(usuarios_dict, f, indent=4)
                
            with open(self.arquivo_propriedades, 'w') as f:
                json.dump(self.propriedades, f, indent=4)
                
        except Exception as e:
            print(f"Erro ao salvar dados: {e}")
    
    def registrar_saida(self, numero_apartamento):
        """Registra a saída de um hóspede e cria/reinicia uma ordem de limpeza"""
        if numero_apartamento in self.apartamentos:
            if self.apartamentos[numero_apartamento]['status'] in [self.STATUS_APROVADA, self.STATUS_REPROVADA]:
                # Se já foi aprovada/reprovada, reinicia a limpeza (sem perder histórico)
                self.apartamentos[numero_apartamento] = {
                    'data_saida': datetime.datetime.now().strftime("%Y-%m-%d %H:%M"),
                    'status': self.STATUS_PENDENTE,
                    'funcionario': None,
                    'data_limpeza': None,
                    'observacoes': '',
                    'historico': self.apartamentos[numero_apartamento].get('historico', []) + [self.apartamentos[numero_apartamento]]
                }
                self.salvar_dados()
                print(f"Nova ordem de limpeza criada para o apartamento {numero_apartamento} (histórico preservado).")
                return True
            else:
                print(f"Já existe uma ordem de limpeza ativa para o apartamento {numero_apartamento}.")
                return False
        
        # Se não existe, cria uma nova ordem
        ordem = {
            'data_saida': datetime.datetime.now().strftime("%Y-%m-%d %H:%M"),
            'status': self.STATUS_PENDENTE,
            'funcionario': None,
            'data_limpeza': None,
            'observacoes': '',
            'historico': []
        }
        
        self.apartamentos[numero_apartamento] = ordem
        self.salvar_dados()
        print(f"Ordem de limpeza criada para o apartamento {numero_apartamento}.")
        return True
    
    def atribuir_limpeza(self, numero_apartamento, funcionario):
        """Atribui uma ordem de limpeza a uma funcionária"""
        if not self.usuario_logado or self.usuario_logado.tipo not in ['admin', 'gestor']:
            print("Apenas administradores ou gerentes podem atribuir limpezas.")
            return False
        
        if numero_apartamento not in self.apartamentos:
            print(f"Não existe ordem de limpeza para o apartamento {numero_apartamento}.")
            return False
        
        if self.apartamentos[numero_apartamento]['status'] != self.STATUS_PENDENTE:
            print(f"A limpeza do apartamento {numero_apartamento} não está com status 'pendente'.")
            return False
        
        # Verificar se a funcionária está registrada
        funcionario_registrado = any(u.login == funcionario and u.tipo == 'funcionario' for u in self.usuarios)
        if not funcionario_registrado:
            print(f"A funcionária {funcionario} não está registrada.")
            return False
        
        self.apartamentos[numero_apartamento]['funcionario'] = funcionario
        self.apartamentos[numero_apartamento]['status'] = self.STATUS_EM_ANDAMENTO
        self.salvar_dados()
        print(f"Limpeza do apartamento {numero_apartamento} atribuída a {funcionario}.")
        return True
    
    def registrar_limpeza_concluida(self, numero_apartamento, observacoes=''):
        """Registra a conclusão da limpeza (muda status para 'finalizada_esperando_analise')"""
        if not self.usuario_logado or self.usuario_logado.tipo != 'funcionario':
            print("Apenas funcionários podem registrar limpeza concluída.")
            return False
            
        if numero_apartamento not in self.apartamentos:
            print(f"Não existe ordem de limpeza para o apartamento {numero_apartamento}.")
            return False
        
        if self.apartamentos[numero_apartamento]['status'] != self.STATUS_EM_ANDAMENTO:
            print(f"A limpeza do apartamento {numero_apartamento} não está em andamento.")
            return False
        
        if self.apartamentos[numero_apartamento]['funcionario'] != self.usuario_logado.login:
            print(f"Esta limpeza não está atribuída a você.")
            return False
        
        self.apartamentos[numero_apartamento]['status'] = self.STATUS_FINALIZADA_ESPERANDO_ANALISE
        self.apartamentos[numero_apartamento]['data_limpeza'] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        self.apartamentos[numero_apartamento]['observacoes'] = observacoes
        self.salvar_dados()
        print(f"Limpeza do apartamento {numero_apartamento} registrada como concluída, aguardando análise do gestor.")
        return True
    
    def aprovar_limpeza(self, numero_apartamento):
        """Aprova uma limpeza que estava aguardando análise"""
        if not self.usuario_logado or self.usuario_logado.tipo not in ['admin', 'gestor']:
            print("Apenas administradores ou gerentes podem aprovar limpezas.")
            return False
        
        if numero_apartamento not in self.apartamentos:
            print(f"Não existe ordem de limpeza para o apartamento {numero_apartamento}.")
            return False
        
        if self.apartamentos[numero_apartamento]['status'] != self.STATUS_FINALIZADA_ESPERANDO_ANALISE:
            print(f"A limpeza do apartamento {numero_apartamento} não está aguardando análise.")
            return False
        
        self.apartamentos[numero_apartamento]['status'] = self.STATUS_APROVADA
        self.apartamentos[numero_apartamento]['data_aprovacao'] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        self.apartamentos[numero_apartamento]['aprovador'] = self.usuario_logado.login
        self.salvar_dados()
        print(f"Limpeza do apartamento {numero_apartamento} aprovada por {self.usuario_logado.nome}.")
        return True

    def reprovar_limpeza(self, numero_apartamento, motivo=''):
        """Reprova uma limpeza que estava aguardando análise"""
        if not self.usuario_logado or self.usuario_logado.tipo not in ['admin', 'gestor']:
            print("Apenas administradores ou gerentes podem reprovar limpezas.")
            return False
        
        if numero_apartamento not in self.apartamentos:
            print(f"Não existe ordem de limpeza para o apartamento {numero_apartamento}.")
            return False
        
        if self.apartamentos[numero_apartamento]['status'] != self.STATUS_FINALIZADA_ESPERANDO_ANALISE:
            print(f"A limpeza do apartamento {numero_apartamento} não está aguardando análise.")
            return False
        
        self.apartamentos[numero_apartamento]['status'] = self.STATUS_REPROVADA
        self.apartamentos[numero_apartamento]['data_reprovacao'] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        self.apartamentos[numero_apartamento]['reprovador'] = self.usuario_logado.login
        self.apartamentos[numero_apartamento]['motivo_reprovacao'] = motivo
        # Volta para pendente para que possa ser atribuída novamente
        self.apartamentos[numero_apartamento]['status'] = self.STATUS_PENDENTE
        self.salvar_dados()
        print(f"Limpeza do apartamento {numero_apartamento} reprovada por {self.usuario_logado.nome}. Motivo: {motivo}")
        return True
    
    def listar_limpezas_pendentes(self):
        """Lista todas as limpezas pendentes"""
        pendentes = {k: v for k, v in self.apartamentos.items() if v['status'] == self.STATUS_PENDENTE}
        if not pendentes:
            print("Não há limpezas pendentes.")
            return
        
        print("\n=== LIMPEZAS PENDENTES ===")
        for ap, dados in pendentes.items():
            print(f"Apartamento {ap} - Saída: {dados['data_saida']}")
    
    def listar_limpezas_em_andamento(self):
        """Lista todas as limpezas em andamento"""
        andamento = {k: v for k, v in self.apartamentos.items() if v['status'] == self.STATUS_EM_ANDAMENTO}
        if not andamento:
            print("Não há limpezas em andamento.")
            return
        
        print("\n=== LIMPEZAS EM ANDAMENTO ===")
        for ap, dados in andamento.items():
            print(f"Apartamento {ap} - Funcionária: {dados['funcionario']} - Saída: {dados['data_saida']}")
    
    def listar_limpezas_aguardando_analise(self):
        """Lista todas as limpezas aguardando análise do gestor"""
        aguardando = {k: v for k, v in self.apartamentos.items() if v['status'] == self.STATUS_FINALIZADA_ESPERANDO_ANALISE}
        if not aguardando:
            print("Não há limpezas aguardando análise.")
            return
        
        print("\n=== LIMPEZAS AGUARDANDO ANÁLISE ===")
        for ap, dados in aguardando.items():
            print(f"Apartamento {ap} - Funcionária: {dados['funcionario']} - Data limpeza: {dados['data_limpeza']}")
    
    def listar_todas_limpezas(self):
        """Lista todas as ordens de limpeza"""
        if not self.apartamentos:
            print("Não há ordens de limpeza registradas.")
            return
        
        print("\n=== TODAS AS ORDENS DE LIMPEZA ===")
        for ap, dados in self.apartamentos.items():
            status = dados['status'].upper()
            print(f"\nApartamento {ap} - Status: {status}")
            print(f"Data saída: {dados['data_saida']}")
            if dados['funcionario']:
                print(f"Funcionária: {dados['funcionario']}")
            if dados['data_limpeza']:
                print(f"Data limpeza: {dados['data_limpeza']}")
            if dados['observacoes']:
                print(f"Observações: {dados['observacoes']}")
            if 'aprovador' in dados:
                print(f"Aprovado por: {dados['aprovador']} em {dados['data_aprovacao']}")
            if 'reprovador' in dados:
                print(f"Reprovado por: {dados['reprovador']} em {dados['data_reprovacao']}")
                print(f"Motivo: {dados['motivo_reprovacao']}")

    def cadastrar_usuario(self, nome, login, senha, tipo):
        """Cadastra um novo usuário no sistema"""
        if not self.usuario_logado:
            print("Nenhum usuário logado.")
            return False
            
        if tipo == 'admin' and self.usuario_logado.tipo != 'admin':
            print("Apenas administradores podem cadastrar novos administradores.")
            return False
        if tipo == 'gestor' and self.usuario_logado.tipo != 'admin':
            print("Apenas administradores podem cadastrar novos gerentes.")
            return False
        if tipo == 'funcionario' and self.usuario_logado.tipo not in ['admin', 'gestor']:
            print("Apenas administradores ou gerentes podem cadastrar novos funcionários.")
            return False
        
        if any(u.login == login for u in self.usuarios):
            print("Login já está em uso.")
            return False
            
        novo_usuario = Usuario(nome, login, senha, tipo)
        self.usuarios.append(novo_usuario)
        self.salvar_dados()
        print(f"Usuário {nome} cadastrado como {tipo}.")
        return True

    def cadastrar_propriedade(self, nome, endereco):
        """Cadastra uma nova propriedade"""
        if not self.usuario_logado or self.usuario_logado.tipo not in ['admin', 'gestor']:
            print("Apenas administradores ou gerentes podem cadastrar propriedades.")
            return False
            
        if nome in self.propriedades:
            print("Propriedade já cadastrada.")
            return False
            
        self.propriedades[nome] = {'endereco': endereco}
        self.salvar_dados()
        print(f"Propriedade {nome} cadastrada com sucesso.")
        return True

    def autenticar_usuario(self, login, senha):
        for usuario in self.usuarios:
            if usuario.login == login and usuario.senha == senha:
                self.usuario_logado = usuario
                print(f"Bem-vindo(a), {usuario.nome}!")
                return True
        print("Login ou senha incorretos.")
        return False
    
    def logout(self):
        """Desconecta o usuário atual"""
        if self.usuario_logado:
            print(f"Até logo, {self.usuario_logado.nome}!")
            self.usuario_logado = None
        else:
            print("Nenhum usuário logado.")

    def anexar_foto(self, numero_apartamento, caminho_foto):
        """Anexa uma foto ao registro de limpeza"""
        if not self.usuario_logado or self.usuario_logado.tipo != 'funcionario':
            print("Apenas funcionários podem anexar fotos.")
            return False
            
        if numero_apartamento in self.apartamentos:
            if 'fotos' not in self.apartamentos[numero_apartamento]:
                self.apartamentos[numero_apartamento]['fotos'] = []
            self.apartamentos[numero_apartamento]['fotos'].append(caminho_foto)
            self.salvar_dados()
            print(f"Foto anexada ao apartamento {numero_apartamento}.")
            return True
        return False

    def registrar_checklist(self, numero_apartamento, itens):
        """Registra o checklist de limpeza"""
        if not self.usuario_logado or self.usuario_logado.tipo != 'funcionario':
            print("Apenas funcionários podem registrar checklists.")
            return False
            
        if numero_apartamento in self.apartamentos:
            self.apartamentos[numero_apartamento]['checklist'] = itens
            self.salvar_dados()
            print(f"Checklist registrado para o apartamento {numero_apartamento}.")
            return True
        return False

    def exportar_para_excel(self, caminho_arquivo):
        """Exporta os dados de limpeza para um arquivo Excel"""
        if not self.usuario_logado:
            print("Acesso negado. Faça login primeiro.")
            return False
            
        if not self.apartamentos:
            print("Não há dados para exportar.")
            return False
        
        try:
            # Converter dados para DataFrame
            dados_exportar = []
            for ap, info in self.apartamentos.items():
                row = {
                    'apartamento': ap,
                    'data_saida': info.get('data_saida'),
                    'status': info.get('status'),
                    'funcionario': info.get('funcionario'),
                    'data_limpeza': info.get('data_limpeza'),
                    'observacoes': info.get('observacoes'),
                    'aprovador': info.get('aprovador'),
                    'data_aprovacao': info.get('data_aprovacao'),
                    'reprovador': info.get('reprovador'),
                    'data_reprovacao': info.get('data_reprovacao'),
                    'motivo_reprovacao': info.get('motivo_reprovacao')
                }
                
                # Adicionar danos como string
                if 'danos' in info:
                    row['danos'] = "; ".join([f"{d['item']} (R${d['preco']})" for d in info['danos']])
                    row['total_danos'] = sum(float(d['preco']) for d in info['danos'])
                
                dados_exportar.append(row)
            
            df = pd.DataFrame(dados_exportar)
            df.to_excel(caminho_arquivo, index=False)
            print(f"Dados exportados com sucesso para {caminho_arquivo}")
            return True
        except Exception as e:
            print(f"Erro ao exportar dados: {e}")
            return False


class Usuario:
    def __init__(self, nome, login, senha, tipo):
        self.nome = nome
        self.login = login
        self.senha = senha
        self.tipo = tipo  # 'admin', 'gestor', 'funcionario'

def menu_principal():
    sistema = SistemaLimpeza()
    
    while True:
        print("\n=== SISTEMA DE CONTROLE DE LIMPEZA ===")
        if sistema.usuario_logado:
            print(f"Usuário: {sistema.usuario_logado.nome} ({sistema.usuario_logado.tipo})")
            print("1. Registrar saída de hóspede")
            print("2. Atribuir limpeza")
            print("3. Registrar limpeza concluída")
            print("4. Aprovar limpeza")
            print("5. Reprovar limpeza")
            print("6. Anexar foto")
            print("7. Registrar checklist")
            print("8. Listar limpezas pendentes")
            print("9. Listar limpezas em andamento")
            print("10. Listar limpezas aguardando análise")
            print("11. Listar todas as ordens")
            print("12. Cadastrar usuário")
            print("13. Cadastrar propriedade")
            print("14. Exportar para Excel")
            print("0. Logout")
        else:
            print("L. Login")
            print("0. Sair")
        
        opcao = input("\nEscolha uma opção: ").lower()
        
        if sistema.usuario_logado:
            if opcao == '1':
                registrar_saida_menu(sistema)
            elif opcao == '2':
                atribuir_limpeza_menu(sistema)
            elif opcao == '3':
                registrar_limpeza_concluida_menu(sistema)
            elif opcao == '4':
                aprovar_limpeza_menu(sistema)
            elif opcao == '5':
                reprovar_limpeza_menu(sistema)
            elif opcao == '6':
                anexar_foto_menu(sistema)
            elif opcao == '7':
                registrar_checklist_menu(sistema)
            elif opcao == '8':
                sistema.listar_limpezas_pendentes()
            elif opcao == '9':
                sistema.listar_limpezas_em_andamento()
            elif opcao == '10':
                sistema.listar_limpezas_aguardando_analise()
            elif opcao == '11':
                sistema.listar_todas_limpezas()
            elif opcao == '12':
                cadastrar_usuario_menu(sistema)
            elif opcao == '13':
                cadastrar_propriedade_menu(sistema)
            elif opcao == '14':
                exportar_excel_menu(sistema)
            elif opcao == '0':
                sistema.logout()
            else:
                print("Opção inválida.")
        else:
            if opcao == 'l':
                login_menu(sistema)
            elif opcao == '0':
                print("Saindo do sistema...")
                break
            else:
                print("Opção inválida.")

def login_menu(sistema):
    login = input("Login: ")
    senha = input("Senha: ")
    sistema.autenticar_usuario(login, senha)

def registrar_saida_menu(sistema):
    numero = input("Número do apartamento: ")
    sistema.registrar_saida(numero)

def atribuir_limpeza_menu(sistema):
    numero = input("Número do apartamento: ")
    funcionario = input("Nome da funcionária: ")
    sistema.atribuir_limpeza(numero, funcionario)

def registrar_limpeza_concluida_menu(sistema):
    numero = input("Número do apartamento: ")
    obs = input("Observações (opcional): ")
    sistema.registrar_limpeza_concluida(numero, obs)

def aprovar_limpeza_menu(sistema):
    numero = input("Número do apartamento: ")
    sistema.aprovar_limpeza(numero)

def reprovar_limpeza_menu(sistema):
    numero = input("Número do apartamento: ")
    motivo = input("Motivo da reprovação: ")
    sistema.reprovar_limpeza(numero, motivo)

def anexar_foto_menu(sistema):
    numero = input("Número do apartamento: ")
    caminho = input("Caminho da foto: ")
    sistema.anexar_foto(numero, caminho)

def registrar_checklist_menu(sistema):
    numero = input("Número do apartamento: ")
    print("Itens do checklist (digite 'fim' para terminar):")
    itens = []
    while True:
        item = input("Item: ")
        if item.lower() == 'fim':
            break
        itens.append(item)
    sistema.registrar_checklist(numero, itens)

def cadastrar_usuario_menu(sistema):
    nome = input("Nome completo: ")
    login = input("Login: ")
    senha = input("Senha: ")
    print("Tipos disponíveis: admin, gestor, funcionario")
    tipo = input("Tipo: ")
    sistema.cadastrar_usuario(nome, login, senha, tipo)

def cadastrar_propriedade_menu(sistema):
    nome = input("Nome da propriedade: ")
    endereco = input("Endereço: ")
    sistema.cadastrar_propriedade(nome, endereco)

def exportar_excel_menu(sistema):
    caminho = input("Caminho para salvar o arquivo (ex: relatorio.xlsx): ")
    sistema.exportar_para_excel(caminho)
    

if __name__ == "__main__":
    # Criar admin padrão se não existir
    sistema = SistemaLimpeza()
    if not any(u.tipo == 'admin' for u in sistema.usuarios):
        sistema.usuarios.append(Usuario("Admin", "admin", "admin123", "admin"))
        sistema.salvar_dados()
        print("Usuário admin criado (login: admin, senha: admin123)")
    
    menu_principal()