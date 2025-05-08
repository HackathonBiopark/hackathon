from flask import Flask
from routes import main_bp  # Importando o Blueprint com as rotas

app = Flask(__name__)

# Registrando o Blueprint das rotas principais
app.register_blueprint(main_bp)

# Rota raiz
@app.route('/')
def home():
    return "API no ar - Bem-vindo à API de Gestão de Usuários e Eventos!"

# Cadastro e Usuários
@app.route('/api/cadastrar_autor', methods=['POST'])
def cadastrar_autor():
    return main_bp.cadastrar_autor()

@app.route('/api/cadastrar_corretor', methods=['POST'])
def cadastrar_corretor():
    return main_bp.cadastrar_corretor()

@app.route('/api/cadastrar_coordenador', methods=['POST'])
def cadastrar_coordenador():
    return main_bp.cadastrar_coordenador()

@app.route('/api/cadastrar_usuario', methods=['POST'])
def cadastrar_usuario():
    return main_bp.cadastrar_usuario()

@app.route('/api/listar_usuarios', methods=['GET'])
def listar_usuarios():
    return main_bp.listar_usuarios()

@app.route('/api/atualizar_usuario', methods=['PUT'])
def atualizar_usuario():
    return main_bp.atualizar_usuario()

@app.route('/api/deletar_usuario', methods=['DELETE'])
def deletar_usuario():
    return main_bp.deletar_usuario()

# Artigos e Eventos
@app.route('/api/cadastrar_evento', methods=['POST'])
def cadastrar_evento():
    return main_bp.cadastrar_evento()

@app.route('/api/enviar_artigo', methods=['POST'])
def enviar_artigo():
    return main_bp.enviar_artigo()

@app.route('/api/submeter_artigo', methods=['POST'])
def submeter_artigo():
    return main_bp.submeter_artigo()

@app.route('/api/selecionar_artigo', methods=['GET'])
def selecionar_artigo():
    return main_bp.selecionar_artigo()

@app.route('/api/selecionar_evento', methods=['GET'])
def selecionar_evento():
    return main_bp.selecionar_evento()

@app.route('/api/avaliar_artigo_inicial', methods=['POST'])
def avaliar_artigo_inicial():
    return main_bp.avaliar_artigo_inicial()

@app.route('/api/avaliar_artigo_final', methods=['POST'])
def avaliar_artigo_final():
    return main_bp.avaliar_artigo_final()

@app.route('/api/acompanhar_submissoes', methods=['GET'])
def acompanhar_submissoes():
    return main_bp.acompanhar_submissoes()

@app.route('/api/publicar_anais', methods=['POST'])
def publicar_anais():
    return main_bp.publicar_anais()

# Autenticação
@app.route('/api/login', methods=['POST'])
def login():
    return main_bp.login()

# Utilitários
@app.route('/api/menu', methods=['GET'])
def menu():
    return main_bp.menu()

if __name__ == '__main__':
    app.run(debug=True,host='localhost', port=5000)