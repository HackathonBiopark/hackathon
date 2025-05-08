import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TelaOrganizacaoEvento extends StatefulWidget {
  const TelaOrganizacaoEvento({super.key});

  @override
  State<TelaOrganizacaoEvento> createState() => _TelaOrganizacaoEventoState();
}

class _TelaOrganizacaoEventoState extends State<TelaOrganizacaoEvento> {
  bool sidebarAberta = false;
  String? bannerFileName;

  void _pickBannerFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        bannerFileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D3E5F),
        title: const Text('Organização', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(sidebarAberta ? Icons.arrow_back : Icons.menu,
              color: Colors.white),
          onPressed: () {
            setState(() {
              sidebarAberta = !sidebarAberta;
            });
          },
        ),
      ),
      body: Row(
        children: [
          if (sidebarAberta)
            Container(
              width: 220,
              color: const Color(0xFF1D3E5F),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  ListTile(
                    leading: const Icon(Icons.add, color: Colors.white),
                    title: const Text('Novo evento',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  const Divider(
                      color: Colors.white30,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Text(
                      'Eventos recentes',
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const ListTile(
                    dense: true,
                    title: Text(
                      'Conferência Data Minds 2025',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    leading:
                        Icon(Icons.event_note, color: Colors.white70, size: 20),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ],
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: SizedBox(
                  width: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Nome do evento',
                          hintText: 'Digite o nome do evento',
                        ),
                        controller: TextEditingController(
                          text: 'Conferência Data Minds 2025',
                        ),
                      ),
                      const SizedBox(height: 16),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Data',
                          hintText: 'dd/mm/aaaa',
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _pickBannerFile,
                        child: AbsorbPointer(
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Banner',
                              prefixIcon: const Icon(Icons.add_circle_outline),
                              hintText: bannerFileName ?? 'Adicionar banner',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Salvar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1D3E5F),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            textStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
