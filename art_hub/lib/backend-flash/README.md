# 📚 API de Cadastro e Submissão de Artigos

Este projeto é uma API REST construída com **Flask**, projetada para gerenciar cadastros de autores, corretores, coordenadores, eventos e submissão de artigos.

---

## 🚀 Como iniciar o projeto

### 1. Clone o repositório
```bash
git clone https://github.com/seuusuario/seuprojeto.git
cd seuprojeto
```

### 2. Crie e ative um ambiente virtual
```bash
python -m venv venv
  # Linux/macOS
venv\Scripts\activate   # Windows
```

### 3. Instale as dependências
```bash
pip install -r requirements.txt
```

### 4. Execute o servidor
```bash
python run.py
```

A aplicação estará disponível em:  
**http://localhost:5000**

---

## 📌 Endpoints disponíveis

### `POST /cadastrar_autor`
**Descrição:** Cadastro de um novo autor

#### Corpo (JSON):
```json
{
  "nome": "string",
  "email": "string",
  "telefone": "string",
  "instituicao": "string",
  "cpf": "string"
}
```

#### Resposta:
```json
{
  "status": "string",
  "message": "string",
  "id_autor": "int"
}
```

---

### `POST /cadastrar_corretor`
**Descrição:** Cadastro de um novo corretor

#### Corpo (JSON):
```json
{
  "nome": "string",
  "email": "string",
  "telefone": "string",
  "creci": "string",
  "cpf": "string"
}
```

#### Resposta:
```json
{
  "status": "string",
  "message": "string",
  "id_corretor": "int"
}
```

---

### `POST /cadastrar_coordenador`
**Descrição:** Cadastro de um novo coordenador

#### Corpo (JSON):
```json
{
  "nome": "string",
  "email": "string",
  "telefone": "string",
  "instituicao": "string",
  "cpf": "string"
}
```

#### Resposta:
```json
{
  "status": "string",
  "message": "string",
  "id_coordenador": "int"
}
```

---

### `POST /cadastrar_evento`
**Descrição:** Cadastro de um novo evento

#### Corpo (JSON):
```json
{
  "nome_evento": "string",
  "data": "date",
  "local": "string",
  "descricao": "string",
  "coordenador_id": "int"
}
```

#### Resposta:
```json
{
  "status": "string",
  "message": "string",
  "id_evento": "int"
}
```

---

### `POST /enviar_artigo`
**Descrição:** Envio de um artigo para avaliação

#### Corpo (JSON):
```json
{
  "titulo": "string",
  "resumo": "string",
  "conteudo": "file",
  "autor_id": "int",
  "evento_id": "int"
}
```

#### Resposta:
```json
{
  "status": "string",
  "message": "string",
  "id_artigo": "int"
}
```

---

## 🧱 Estrutura do projeto

```
meu_projeto/
│
├── app/
│   ├── routes/
│   ├── models/
│   ├── services/
│   ├── __init__.py
│   └── config.py
│
├── run.py
├── requirements.txt
└── README.md
```

---

## ✨ Tecnologias usadas

- Python 3.10+
- Flask

---

## 🛠️ Em desenvolvimento

Esta API ainda está em construção. Contribuições são bem-vindas!