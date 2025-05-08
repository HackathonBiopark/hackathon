from flask import Flask, request, jsonify
from prototipo_automação_limpeza import SistemaLimpeza  # seu backend
import os

app = Flask(__name__)
sistema = SistemaLimpeza()

# ==== LOGIN ====

@app.route('/login', methods=['POST'])
def login():
    data = request.json
    login = data.get('login')
    senha = data.get('senha')

    success = sistema.autenticar_usuario(login, senha)
    if success:
        return jsonify({
            "success": True,
            "usuario": {
                "nome": sistema.usuario_logado.nome,
                "tipo": sistema.usuario_logado.tipo,
                "login": sistema.usuario_logado.login
            }
        })
    else:
        return jsonify({"success": False, "mensagem": "Login ou senha inválidos"}), 401


@app.route('/logout', methods=['POST'])
def logout():
    sistema.logout()
    return jsonify({"mensagem": "Logout realizado com sucesso."})


# ==== USUÁRIOS ====

@app.route('/usuarios', methods=['GET'])
def listar_usuarios():
    usuarios = {
        u.login: {
            'nome': u.nome,
            'login': u.login,
            'tipo': u.tipo
        } for u in sistema.usuarios
    }
    return jsonify(usuarios)


@app.route('/usuarios', methods=['POST'])
def cadastrar_usuario():
    data = request.json
    success = sistema.cadastrar_usuario(data['nome'], data['login'], data['senha'], data['tipo'])
    return jsonify({"success": success})


# ==== PROPRIEDADES ====

@app.route('/propriedades', methods=['GET'])
def listar_propriedades():
    return jsonify(sistema.propriedades)


@app.route('/propriedades', methods=['POST'])
def cadastrar_propriedade():
    data = request.json
    success = sistema.cadastrar_propriedade(data['nome'], data['endereco'])
    return jsonify({"success": success})


# ==== LIMPEZAS ====

@app.route('/limpezas', methods=['GET'])
def listar_limpezas():
    return jsonify(sistema.apartamentos)


@app.route('/limpezas', methods=['POST'])
def registrar_saida():
    data = request.json
    success = sistema.registrar_saida(data['apartamento'])
    return jsonify({"success": success})


@app.route('/limpezas/atribuir', methods=['POST'])
def atribuir_limpeza():
    data = request.json
    success = sistema.atribuir_limpeza(data['apartamento'], data['funcionaria'])
    return jsonify({"success": success})


@app.route('/limpezas/concluir', methods=['POST'])
def concluir_limpeza():
    data = request.json
    success = sistema.registrar_limpeza_concluida(data['apartamento'], data.get('observacoes', ''))
    return jsonify({"success": success})


@app.route('/limpezas/<apto>/validar', methods=['POST'])
def validar_limpeza(apto):
    success = sistema.aprovar_limpeza(apto)
    return jsonify({"success": success})


@app.route('/limpezas/<apto>/checklist', methods=['POST'])
def registrar_checklist(apto):
    data = request.json
    sucesso = sistema.registrar_checklist(apto, data['itens'])
    return jsonify({"success": sucesso})


@app.route('/limpezas/<apto>/foto', methods=['POST'])
def anexar_foto(apto):
    data = request.json
    sucesso = sistema.anexar_foto(apto, data['caminho'])
    return jsonify({"success": sucesso})

@app.route('/limpezas/<apto>/reprovar', methods=['POST'])
def reprovar_limpeza(apto):
    data = request.json
    motivo = data.get("motivo", "")
    success = sistema.reprovar_limpeza(apto, motivo)
    return jsonify({"success": success})

# ==== RELATÓRIO ====

@app.route('/relatorio', methods=['GET'])
def exportar_excel():
    caminho = os.path.join(os.getcwd(), "relatorio_limpezas.xlsx")
    sucesso = sistema.exportar_para_excel(caminho)
    return jsonify({"success": sucesso, "arquivo": caminho})

@app.route('/historico', methods=['GET'])
def historico_limpezas():
    login = request.args.get('login')
    data_inicio = request.args.get('data_inicio')
    data_fim = request.args.get('data_fim')
    propriedade = request.args.get('propriedade')

    dt_inicio = datetime.datetime.strptime(data_inicio, "%Y-%m-%d") if data_inicio else None
    dt_fim = datetime.datetime.strptime(data_fim, "%Y-%m-%d") if data_fim else None

    tarefas = sistema.obter_historico_por_usuario(login, dt_inicio, dt_fim, propriedade)
    return jsonify(tarefas)

@app.route('/limpezas-para-validar', methods=['GET'])
def limpezas_para_validar():
    tarefas_dict = {ap: dados for ap, dados in sistema.apartamentos.items()
                    if dados.get('status') == sistema.STATUS_FINALIZADA_ESPERANDO_ANALISE}
    
    tarefas = []
    for ap, dados in tarefas_dict.items():
        info = dict(dados)
        info['apartamento'] = ap
        tarefas.append(info)

    return jsonify(tarefas)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5050)