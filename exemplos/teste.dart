class Pessoa{
  final String nome;
  final double peso; 
  final double altura; 
  double? _imc;
  Pessoa(
     this.nome, 
     this.peso, 
     this.altura
  ){
    this._calcImc();
  }
  void _calcImc(){
    this._imc = (peso / (altura * altura));
  }
}

void main(){
  String n = "Mateus";
  print(n.substring(0,3).substring(0,1));
}