import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class ProductFormPage extends StatefulWidget {
  ProductFormPage({Key? key}) : super(key: key);

  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImgae);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImgae);
    _imageUrlFocus.dispose();
  }

  void updateImgae() {
    setState(() {});
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    final newProduct = Product(
      id: Random().nextDouble().toString(),
      name: _formData['name'] as String,
      description: _formData['description'] as String,
      price: _formData['price'] as double,
      imageUrl: _formData['imageUrl'] as String,
    );

    print(newProduct.id);
    print(newProduct.name);
    print(newProduct.description);
    print(newProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Produto'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              inputName(context),
              inputPrice(context),
              inputDescription(),
              urlAndImageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Row urlAndImageInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Url da Imagem',
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            focusNode: _imageUrlFocus,
            controller: _imageUrlController,
            onFieldSubmitted: (_) => _submitForm(),
            onSaved: (imageUrl) => _formData['imageUrl'] = imageUrl ?? '',
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 10,
            left: 10,
          ),
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: _imageUrlController.text.isEmpty
              ? Text('Informe a Url')
              : FittedBox(
                  child: Image.network(_imageUrlController.text),
                  fit: BoxFit.cover,
                ),
        ),
      ],
    );
  }

   TextFormField inputName(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Nome'),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocus),
      onSaved: (name) => _formData['name'] = name ?? '',
      validator: (_name) {
        final name = _name ?? '';

        if(name.trim().isEmpty){
          return 'Nome é obrigatório';
        }

        if(name.trim().length < 3){
          return 'Mínimo de 3 letras.';
        }

        return null;
      },
    );
  }

  TextFormField inputPrice(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Preço'),
      textInputAction: TextInputAction.next,
      focusNode: _priceFocus,
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
      ),
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_descriptionFocus),
      onSaved: (price) => _formData['price'] = double.parse(price ?? '0'),
    );
  }

  TextFormField inputDescription() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Descrição'),
      focusNode: _descriptionFocus,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      onSaved: (description) => _formData['description'] = description ?? '',
    );
  }

  

 
}
