# Valides  
**Sistema de Cadastro e Publicação de Artigos Acadêmicos**  

## 📌 Motivo do Projeto  
Devido a alta necessidade de um processo mais simplificado de submissão de artigos na comunidade acadêmica, surge a criação de um sistema com foco na facilitação desse processo.  

## 🎯 Objetivos  
- Cadastro de eventos e usuários (Autores, Avaliadores, Coordenadores)  
- Submissão eletrônica de artigos  
- Avaliação double-blind  
- Acompanhamento em tempo real  

## 👥 Público-Alvo  
- **Autores**: Submetem artigos  
- **Avaliadores**: Revisam conteúdos  
- **Coordenadores**: Gerenciam processos  

## 🛠️Tecnologias
**FRONTEND:**
- Flutter 3.29.3 (Dart)
- Figma (UI/UX)

**BACKEND:**
- Python 3.13
- Firebase (Banco de Dados)
- requirements.txt

## 🔄 Fluxograma dos Processos

```mermaid
flowchart TD
    %% Protótipo 1 - Fluxo Principal
    subgraph FluxoPrincipal["Prot. 1: Fluxo Principal"]
        A[Cadastro do Evento] --> B[Publicação e Divulgação]
        B --> C[Submissão Inicial de Artigos]
        C --> D[Avaliação pelos Avaliadores]
        D --> E[Submissão Final Corrigida]
        E --> F[Cadastro e Autenticação]
        F --> G[Tipo de Usuário]
    end

    %% User Flow do Autor
    subgraph Autor["User Flow: Autor"]
        G --> H[Submissão de Artigos]
        H --> H1[Upload de PDF]
        H --> H2[Preencher Campos:\nTítulo, Autores, Resumo,\nPalavras-chave, Área Temática]
        H1 --> I[Acompanhamento de Status]
    end

    %% User Flow do Avaliador
    subgraph Avaliador["User Flow: Avaliador"]
        G --> J[Avaliação por Trios]
        J --> J1[Sistema Anônimo]
        J1 --> J2[Interface de Parecer]
        J2 --> J3[Comentários:\nPara Autores e Coordenadores]
    end

    %% User Flow do Coordenador
    subgraph Coordenador["User Flow: Coordenador"]
        G --> K[Painel de Acompanhamento]
        K --> K1[Autores:\nStatus de Submissão]
        K --> K2[Avaliadores:\nArtigos Atribuídos]
        K --> K3[Coordenador:\nPainel Geral]
        K3 --> L[Publicação dos Aprovados]
        L --> L1[Geração de Anais]
        L1 --> L2[Página Pública com Busca]
    end

    %% Conexões entre fluxos
    D -.-> J
    I -.-> K1
    J3 -.-> K3

