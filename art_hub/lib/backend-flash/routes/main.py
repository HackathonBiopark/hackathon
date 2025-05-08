from flask import Blueprint, request, jsonify
import json

# Definindo o Blueprint para agrupar as rotas de usuários
main_bp = Blueprint('main', __name__)

def carregar_dados():
    try:
        with open('data.json', 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        return {"autores": []}  # Caso o arquivo não exista, retorna uma estrutura vazia

# Função para salvar os dados de autores no arquivo JSON
def salvar_dados(dados):
    with open('data.json', 'w') as f:
        json.dump(dados, f, indent=4)

# POST: Cadastrar um novo autor
@main_bp.route('/cadastrar_autor', methods=['POST'])
def cadastrar_autor():
    """
    Cadastro de um novo autor.
    """
    dados = request.get_json()  # Pega os dados enviados no corpo da requisição (espera um JSON)
    
    # Verifica se todos os campos necessários estão presentes
    if not dados.get("nome") or not dados.get("email") or not dados.get("telefone") or not dados.get("instituicao") or not dados.get("cpf"):
        return jsonify({
            "status": "erro",  # Indica que houve um erro
            "message": "Campos obrigatórios faltando."  # Mensagem informando o erro
        }), 400  # Código HTTP 400 indica Bad Request (requisição inválida)

    # Carrega os dados existentes de autores
    dados_autores = carregar_dados()

    # Gera um novo ID para o autor (assumindo que os IDs sejam gerados automaticamente)
    novo_id = len(dados_autores["autores"]) + 1
    dados["id"] = novo_id  # Atribui o novo ID ao autor

    # Adiciona o autor à lista de autores
    dados_autores["autores"].append(dados)

    # Salva os dados atualizados no arquivo JSON
    salvar_dados(dados_autores)

    # Retorna a resposta de sucesso com os dados do autor
    return jsonify({
        "status": "sucesso",  # Indica que a operação foi bem-sucedida
        "message": "Autor cadastrado com sucesso",  # Mensagem para o usuário
        "autor": dados  # Retorna os dados do autor enviado na requisição
    }), 201  # Código HTTP 201 indica que o recurso foi criado com sucesso




@main_bp.route('/cadastrar_corretor', methods=['POST'])
def cadastrar_corretor():
    """
    Cadastro de um novo corretor.
    """
    dados = request.get_json()  # Pega os dados enviados no corpo da requisição (espera um JSON)
    
    # Verifica se todos os campos necessários estão presentes
    if not dados.get("nome") or not dados.get("email") or not dados.get("telefone") or not dados.get("creci") or not dados.get("cpf"):
        return jsonify({
            "status": "erro",  # Indica que houve um erro
            "message": "Campos obrigatórios faltando."  # Mensagem informando o erro
        }), 400  # Código HTTP 400 indica Bad Request (requisição inválida)

    # Carrega os dados existentes do arquivo JSON
    dados_gerais = carregar_dados()

    # Gera um novo ID para o corretor (assumindo que os IDs sejam gerados automaticamente)
    novo_id = len(dados_gerais["corretores"]) + 1
    dados["id"] = novo_id  # Atribui o novo ID ao corretor

    # Adiciona o corretor à lista de corretores
    dados_gerais["corretores"].append(dados)

    # Salva os dados atualizados no arquivo JSON
    salvar_dados(dados_gerais)

    # Retorna a resposta de sucesso com os dados do corretor
    return jsonify({
        "status": "sucesso",  # Indica que a operação foi bem-sucedida
        "message": "Corretor cadastrado com sucesso",  # Mensagem para o usuário
        "corretor": dados  # Retorna os dados do corretor enviado na requisição
    }), 201  # Código HTTP 201 indica que o recurso foi criado com sucesso

@main_bp.route('/cadastrar_coordenador', methods=['POST'])
def cadastrar_coordenador():
    """
    Cadastro de um novo coordenador.
    """
    dados = request.get_json()  # Pega os dados enviados no corpo da requisição (espera um JSON)
    
    # Verifica se todos os campos necessários estão presentes
    if not dados.get("nome") or not dados.get("email") or not dados.get("telefone") or not dados.get("instituicao") or not dados.get("cpf"):
        return jsonify({
            "status": "erro",  # Indica que houve um erro
            "message": "Campos obrigatórios faltando."  # Mensagem informando o erro
        }), 400  # Código HTTP 400 indica Bad Request (requisição inválida)

    # Carrega os dados existentes do arquivo JSON
    dados_gerais = carregar_dados()

    # Gera um novo ID para o coordenador (assumindo que os IDs sejam gerados automaticamente)
    novo_id = len(dados_gerais["coordenadores"]) + 1
    dados["id"] = novo_id  # Atribui o novo ID ao coordenador

    # Adiciona o coordenador à lista de coordenadores
    dados_gerais["coordenadores"].append(dados)

    # Salva os dados atualizados no arquivo JSON
    salvar_dados(dados_gerais)

    # Retorna a resposta de sucesso com os dados do coordenador
    return jsonify({
        "status": "sucesso",  # Indica que a operação foi bem-sucedida
        "message": "Coordenador cadastrado com sucesso",  # Mensagem para o usuário
        "coordenador": dados  # Retorna os dados do coordenador enviado na requisição
    }), 201  # Código HTTP 201 indica que o recurso foi criado com sucesso

@main_bp.route('/cadastrar_evento', methods=['POST'])
def cadastrar_evento():
    """
    Cadastro de um novo evento.
    """
    dados = request.get_json()  # Pega os dados enviados no corpo da requisição (espera um JSON)
    
    # Verifica se todos os campos necessários estão presentes
    if not dados.get("nome_evento") or not dados.get("data") or not dados.get("local") or not dados.get("descricao") or not dados.get("coordenador_id"):
        return jsonify({
            "status": "erro",  # Indica que houve um erro
            "message": "Campos obrigatórios faltando."  # Mensagem informando o erro
        }), 400  # Código HTTP 400 indica Bad Request (requisição inválida)

    # Carrega os dados existentes do arquivo JSON
    dados_gerais = carregar_dados()

    # Gera um novo ID para o evento (assumindo que os IDs sejam gerados automaticamente)
    novo_id = len(dados_gerais["eventos"]) + 1
    dados["id"] = novo_id  # Atribui o novo ID ao evento

    # Adiciona o evento à lista de eventos
    dados_gerais["eventos"].append(dados)

    # Salva os dados atualizados no arquivo JSON
    salvar_dados(dados_gerais)

    # Retorna a resposta de sucesso com os dados do evento
    return jsonify({
        "status": "sucesso",  # Indica que a operação foi bem-sucedida
        "message": "Evento cadastrado com sucesso",  # Mensagem para o usuário
        "evento": dados  # Retorna os dados do evento enviado na requisição
    }), 201  # Código HTTP 201 indica que o recurso foi criado com sucesso

@main_bp.route('/enviar_artigo', methods=['POST'])
def enviar_artigo():
    """
    Envio de um artigo para avaliação.
    """
    dados = request.get_json()  # Pega os dados enviados no corpo da requisição (espera um JSON)
    
    # Verifica se todos os campos necessários estão presentes
    if not dados.get("titulo") or not dados.get("resumo") or not dados.get("conteudo") or not dados.get("autor_id") or not dados.get("evento_id"):
        return jsonify({
            "status": "erro",  # Indica que houve um erro
            "message": "Campos obrigatórios faltando."  # Mensagem informando o erro
        }), 400  # Código HTTP 400 indica Bad Request (requisição inválida)

    # Simula o envio do artigo e retorna os dados
    return jsonify({
        "status": "sucesso",  # Indica que a operação foi bem-sucedida
        "message": "Artigo enviado com sucesso",  # Mensagem para o usuário
        "artigo": dados  # Retorna os dados do artigo enviado na requisição (simula o envio)
    }), 201  # Código HTTP 201 indica que o recurso foi criado com sucesso
#####################################################################################################
#####################################################################################################
###########################Exemplo pratico###########################################################
#####################################################################################################
#####################################################################################################
# GET: retornar um recurso
@main_bp.route('/usuarios', methods=['GET'])
def listar_usuarios():
    """
    Essa rota retorna uma lista de usuários cadastrados.
    Quando um cliente faz uma requisição GET para '/usuarios', a função 'listar_usuarios' é chamada.
    Aqui, retornamos uma lista simulada de usuários em formato JSON.
    """
    return jsonify([
        {"id": 1, "nome": "Alice"},  # Exemplo de usuário com id 1 e nome Alice
        {"id": 2, "nome": "Bob"}     # Exemplo de usuário com id 2 e nome Bob
    ])
    # Resposta: HTTP 200 com a lista de usuários no corpo da resposta

# POST: criar um novo recurso
@main_bp.route('/usuarios', methods=['POST'])
def criar_usuario():
    """
    Essa rota cria um novo usuário.
    Quando o cliente envia uma requisição POST para '/usuarios', com os dados no corpo,
    a função 'criar_usuario' é chamada. O 'request.get_json()' recupera os dados enviados.
    """
    dados = request.get_json()  # Pega os dados enviados no corpo da requisição (espera um JSON)
    
    # Aqui, a resposta é simulada como um sucesso no cadastro
    return jsonify({
        "status": "sucesso",  # Indica que a operação foi bem-sucedida
        "message": "Usuário criado com sucesso",  # Mensagem para o usuário
        "usuario": dados  # Retorna os dados do usuário enviado na requisição (simula a criação)
    }), 201  # Código HTTP 201 indica que o recurso foi criado com sucesso

# PUT: atualizar um recurso
@main_bp.route('/usuarios/<int:id_usuario>', methods=['PUT'])
def atualizar_usuario(id_usuario):
    """
    Essa rota atualiza os dados de um usuário específico.
    A diferença do PUT é que ele é usado para substituir recursos existentes, geralmente atualizando dados.
    Aqui, o 'id_usuario' é capturado da URL, e 'request.get_json()' pega os dados a serem atualizados.
    """
    dados = request.get_json()  # Pega os dados enviados no corpo da requisição para atualizar

    # Retorna uma mensagem confirmando a atualização com os novos dados
    return jsonify({
        "status": "sucesso",  # Indica que a operação foi bem-sucedida
        "message": f"Usuário {id_usuario} atualizado",  # Mensagem com o id do usuário atualizado
        "novos_dados": dados  # Retorna os novos dados que foram passados para o usuário
    })

# DELETE: remover um recurso
@main_bp.route('/usuarios/<int:id_usuario>', methods=['DELETE'])
def deletar_usuario(id_usuario):
    """
    Essa rota exclui um usuário com base no id fornecido na URL.
    O DELETE é utilizado para remover recursos existentes.
    """
    # Retorna uma resposta confirmando a exclusão do usuário
    return jsonify({
        "status": "sucesso",  # Indica que a operação foi bem-sucedida
        "message": f"Usuário {id_usuario} deletado"  # Mensagem confirmando que o usuário foi deletado
    })
#####################################################################################################
#####################################################################################################
###########################Exemplo pratico###########################################################
#####################################################################################################
#####################################################################################################

# Sistema de Gestão Acadêmica para Eventos Científicos
import json
import os
import hashlib
from datetime import datetime
from getpass import getpass
import sys

# Diretórios para armazenamento dos dados
if not os.path.exists('dados/usuarios'):
    os.makedirs('dados/usuarios')
if not os.path.exists('dados/eventos'):
    os.makedirs('dados/eventos')
if not os.path.exists('dados/artigos'):
    os.makedirs('dados/artigos')

# Função para carregar dados de um arquivo JSON
def carregar_dados(caminho):
    if os.path.exists(caminho):
        with open(caminho, 'r') as arquivo:
            return json.load(arquivo)
    return {}

# Função para salvar dados em um arquivo JSON
def salvar_dados(caminho, dados):
    with open(caminho, 'w') as arquivo:
        json.dump(dados, arquivo, indent=4)

# Função para hash de senha
def hash_senha(senha):
    return hashlib.sha256(senha.encode()).hexdigest()

# Função para listar e selecionar artigos
def selecionar_artigo(status_filtro=None):
    artigos = []
    for arquivo in os.listdir('dados/artigos'):
        if arquivo.endswith('.json'):
            caminho = f'dados/artigos/{arquivo}'
            artigo = carregar_dados(caminho)
            if status_filtro is None or artigo['status'] == status_filtro:
                artigos.append(artigo)
    
    if not artigos:
        print("\nNenhum artigo disponível para seleção.")
        return None
    
    print("\nArtigos disponíveis:")
    for i, artigo in enumerate(artigos, 1):
        print(f"{i}. {artigo['titulo']} - Status: {artigo['status']}")
    
    try:
        escolha = int(input("\nSelecione o artigo (número): ")) - 1
        if 0 <= escolha < len(artigos):
            return artigos[escolha]
        else:
            print("\nNúmero inválido!")
            return None
    except ValueError:
        print("\nEntrada inválida! Digite um número.")
        return None

# Função para listar e selecionar eventos
def selecionar_evento():
    eventos = []
    for arquivo in os.listdir('dados/eventos'):
        if arquivo.endswith('.json'):
            caminho = f'dados/eventos/{arquivo}'
            eventos.append(carregar_dados(caminho))
    
    if not eventos:
        print("\nNenhum evento disponível para seleção.")
        return None
    
    print("\nEventos disponíveis:")
    for i, evento in enumerate(eventos, 1):
        print(f"{i}. {evento['nome']} - Prazo: {evento['prazo']}")
    
    try:
        escolha = int(input("\nSelecione o evento (número): ")) - 1
        if 0 <= escolha < len(eventos):
            return eventos[escolha]
        else:
            print("\nNúmero inválido!")
            return None
    except ValueError:
        print("\nEntrada inválida! Digite um número.")
        return None

# Função de login melhorada
def login():
    print("\n" + "="*50)
    print("SISTEMA DE GESTÃO ACADÊMICA PARA EVENTOS CIENTÍFICOS".center(50))
    print("="*50)
    print("\n>>> LOGIN <<<\n")
    
    tentativas = 3
    while tentativas > 0:
        email = input("Email: ").strip()
        senha = getpass("Senha: ").strip()
        
        caminho = f'dados/usuarios/{email}.json'
        usuario = carregar_dados(caminho)
        
        if usuario and usuario['senha'] == hash_senha(senha):
            print("\n" + "="*50)
            print(f"Bem-vindo(a), {usuario['nome']}!".center(50))
            print(f"Tipo de usuário: {usuario['tipo']}".center(50))
            print("="*50 + "\n")
            return usuario
        
        tentativas -= 1
        if tentativas > 0:
            print(f"\nCredenciais inválidas! Você tem mais {tentativas} tentativa(s).\n")
        else:
            print("\nNúmero máximo de tentativas excedido. Acesso bloqueado.")
            sys.exit()
    
    return None

# Função para avaliação inicial pelo coordenador
def avaliar_artigo_inicial():
    print("\n" + "="*50)
    print("AVALIAÇÃO INICIAL DE ARTIGO".center(50))
    print("="*50 + "\n")
    
    artigo = selecionar_artigo('em avaliação')
    if not artigo:
        return
    
    caminho = f'dados/artigos/{artigo["titulo"]}.json'
    
    print(f"\nResumo do artigo: {artigo['resumo']}")
    decisao = input('\nAprovar para avaliação final? (sim/nao): ')
    if decisao.lower() == 'sim':
        artigo['status'] = 'aguardando avaliador'
        print('\nArtigo aprovado para avaliação final!')
    else:
        artigo['status'] = 'reprovado'
        print('\nArtigo reprovado na avaliação inicial.')
    salvar_dados(caminho, artigo)

# Função para avaliação final pelo avaliador
def avaliar_artigo_final():
    print("\n" + "="*50)
    print("AVALIAÇÃO FINAL DE ARTIGO".center(50))
    print("="*50 + "\n")
    
    artigo = selecionar_artigo('aguardando avaliador')
    if not artigo:
        return
    
    caminho = f'dados/artigos/{artigo["titulo"]}.json'
    
    print(f"\nAvaliando artigo: {artigo['titulo']}")
    print(f"Autores: {artigo['autores']}")
    print(f"\nResumo: {artigo['resumo']}")
    
    print("\n" + "-"*50)
    print("Critérios de avaliação:".center(50))
    print("-"*50)
    print("1. Adequação ao tema do evento (0-10)")
    print("2. Originalidade e contribuição científica (0-10)")
    print("3. Clareza e organização do texto (0-10)")
    print("4. Metodologia adequada (0-10)")
    print("5. Resultados e conclusões consistentes (0-10)")
    print("-"*50 + "\n")
    
    notas = []
    for i in range(1, 6):
        while True:
            try:
                nota = float(input(f"Nota para critério {i} (0-10): "))
                if 0 <= nota <= 10:
                    notas.append(nota)
                    break
                else:
                    print("Por favor, digite um valor entre 0 e 10.")
            except ValueError:
                print("Valor inválido! Digite um número.")
    
    media = sum(notas) / len(notas)
    print(f"\nMédia calculada: {media:.2f}")
    
    while True:
        parecer = input("\nParecer final (aprovado/reprovado): ").lower()
        if parecer in ['aprovado', 'reprovado']:
            break
        print("Opção inválida! Digite 'aprovado' ou 'reprovado'")
    
    recomendacao = input("\nRecomendações para melhoria: ")
    
    artigo['notas'] = notas
    artigo['media'] = media
    artigo['parecer'] = parecer
    artigo['recomendacao'] = recomendacao
    artigo['status'] = 'avaliado'
    artigo['data_avaliacao'] = str(datetime.now())
    
    salvar_dados(caminho, artigo)
    print('\nAvaliação final concluída com sucesso!')

# Função para cadastrar eventos
def cadastrar_evento():
    print("\n" + "="*50)
    print("CADASTRO DE EVENTO".center(50))
    print("="*50 + "\n")
    
    nome = input('Nome do Evento: ')
    descricao = input('Descrição: ')
    banner = input('Caminho do Banner: ')
    prazo = input('Prazo para submissões (DD/MM/AAAA): ')
    caminho = f'dados/eventos/{nome}.json'
    evento = {
        'nome': nome, 
        'descricao': descricao, 
        'banner': banner, 
        'prazo': prazo,
        'data_cadastro': str(datetime.now())
    }
    salvar_dados(caminho, evento)
    print('\nEvento cadastrado com sucesso!')

# Função para submeter artigo
def submeter_artigo():
    print("\n" + "="*50)
    print("SUBMISSÃO DE ARTIGO".center(50))
    print("="*50 + "\n")
    
    titulo = input('Título do Artigo: ')
    autores = input('Autores (separados por vírgula): ')
    resumo = input('Resumo: ')
    palavras_chave = input('Palavras-chave (separadas por vírgula): ')
    area_tematica = input('Área temática: ')
    arquivo_pdf = input('Caminho do PDF: ')
    caminho = f'dados/artigos/{titulo}.json'
    artigo = {
        'titulo': titulo,
        'autores': autores,
        'resumo': resumo,
        'palavras_chave': palavras_chave,
        'area_tematica': area_tematica,
        'arquivo_pdf': arquivo_pdf,
        'status': 'em avaliação',
        'data_submissao': str(datetime.now())
    }
    salvar_dados(caminho, artigo)
    print('\nArtigo submetido com sucesso!')

# Função para cadastrar usuários
def cadastrar_usuario():
    print("\n" + "="*50)
    print("CADASTRO DE USUÁRIO".center(50))
    print("="*50 + "\n")
    
    nome = input('Nome completo: ')
    email = input('Email: ')
    senha = getpass('Senha: ')
    
    print('\nTipos de usuário disponíveis:')
    print('1. Autor - Pode submeter artigos')
    print('2. Avaliador - Pode avaliar artigos')
    print('3. Coordenador - Acesso completo ao sistema')
    
    while True:
        tipo_opcao = input('\nEscolha o tipo de usuário (1-3): ')
        if tipo_opcao in ['1', '2', '3']:
            break
        print("Opção inválida! Digite 1, 2 ou 3")
    
    tipo = ''
    if tipo_opcao == '1':
        tipo = 'Autor'
    elif tipo_opcao == '2':
        tipo = 'Avaliador'
    elif tipo_opcao == '3':
        tipo = 'Coordenador'

    caminho = f'dados/usuarios/{email}.json'
    usuario = {
        'nome': nome, 
        'email': email, 
        'senha': hash_senha(senha), 
        'tipo': tipo,
        'data_cadastro': str(datetime.now())
    }
    salvar_dados(caminho, usuario)
    print('\nUsuário cadastrado com sucesso!')

# Função para acompanhar submissões
def acompanhar_submissoes():
    print("\n" + "="*50)
    print("ACOMPANHAMENTO DE SUBMISSÕES".center(50))
    print("="*50 + "\n")
    
    artigos = []
    for arquivo in os.listdir('dados/artigos'):
        if arquivo.endswith('.json'):
            caminho = f'dados/artigos/{arquivo}'
            artigos.append(carregar_dados(caminho))
    
    if not artigos:
        print("Nenhum artigo encontrado.")
        return
    
    for artigo in artigos:
        print("\n" + "-"*50)
        print(f"Título: {artigo['titulo']}")
        print(f"Status: {artigo['status'].upper()}")
        print(f"Data de submissão: {artigo.get('data_submissao', 'N/A')}")
        if 'data_avaliacao' in artigo:
            print(f"Data de avaliação: {artigo['data_avaliacao']}")
        if 'media' in artigo:
            print(f"Média: {artigo['media']:.2f}")
        print("-"*50)

# Função para publicar anais
def publicar_anais():
    print("\n" + "="*50)
    print("PUBLICAÇÃO DE ANAIS".center(50))
    print("="*50 + "\n")
    
    evento = selecionar_evento()
    if not evento:
        return
    
    artigos_aprovados = []
    for arquivo in os.listdir('dados/artigos'):
        if arquivo.endswith('.json'):
            caminho = f'dados/artigos/{arquivo}'
            artigo = carregar_dados(caminho)
            if artigo.get('status') == 'avaliado' and artigo.get('parecer') == 'aprovado':
                artigos_aprovados.append(artigo)
    
    if not artigos_aprovados:
        print("\nNenhum artigo aprovado para este evento.")
        return
    
    nome_anais = f"anais_{evento['nome'].replace(' ', '_').lower()}_{datetime.now().strftime('%Y%m%d')}.json"
    with open(nome_anais, 'w') as f:
        json.dump({
            'evento': evento,
            'artigos': artigos_aprovados,
            'data_publicacao': str(datetime.now())
        }, f, indent=4)
    
    print(f"\nAnais publicados com sucesso no arquivo {nome_anais}!")
    print(f"Total de artigos publicados: {len(artigos_aprovados)}")

# Função principal do sistema
def menu():
    usuario = login()
    if not usuario:
        return

    while True:
        print("\n" + "="*50)
        print("MENU PRINCIPAL".center(50))
        print("="*50)
        print("\n1. Cadastrar Usuário")
        print("2. Cadastrar Evento")
        print("3. Submeter Artigo")
        print("4. Avaliar Artigo Inicial (Coordenador)")
        print("5. Avaliar Artigo Final (Avaliador)")
        print("6. Acompanhar Submissões")
        print("7. Publicar Anais")
        print("8. Sair\n")

        opcao = input('Escolha uma opção: ')

        if opcao == '1' and usuario['tipo'] == 'Coordenador':
            cadastrar_usuario()
        elif opcao == '2' and usuario['tipo'] == 'Coordenador':
            cadastrar_evento()
        elif opcao == '3' and usuario['tipo'] in ['Autor', 'Coordenador']:
            submeter_artigo()
        elif opcao == '4' and usuario['tipo'] == 'Coordenador':
            avaliar_artigo_inicial()
        elif opcao == '5' and usuario['tipo'] == 'Avaliador':
            avaliar_artigo_final()
        elif opcao == '6':
            acompanhar_submissoes()
        elif opcao == '7' and usuario['tipo'] == 'Coordenador':
            publicar_anais()
        elif opcao == '8':
            print('\nSaindo do sistema...')
            break
        else:
            print('\nOpção inválida ou permissão negada!')

if __name__ == "__main__":
    menu()