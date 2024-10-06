// Parâmetros da Simulação
int tamanhoDaPopulacao = 100;
int geracao = 0;
ArrayList<Organismo> populacao;
ArrayList<PVector> comida;
int quantidadeRecursos = 10;
int tempoDeVida = 100;
int contadorDeFrames = 0;

void setup() {
  size(800, 600);
  populacao = new ArrayList<Organismo>();
  comida = new ArrayList<PVector>();
  
  // Inicializa a população
  for (int i = 0; i < tamanhoDaPopulacao; i++) {
    float[] dna = new float[4];  // Incluindo sexo (0 = masculino, 1 = feminino)
    for(int k = 0; k < 3; k++) dna[k] = random(1);
    dna[3] = random(1) < 0.5 ? 0 : 1;  // Definindo sexo
    populacao.add(new Organismo(new PVector(random(width), random(height)), dna));
  }
  
  // Inicializa os recursos
  for (int i = 0; i < quantidadeRecursos; i++) {
    comida.add(new PVector(random(width), random(height)));
  }
}

void draw() {
  background(255);
  
  // Atualiza e desenha os recursos
  for (PVector r : comida) {
    fill(0);
    ellipse(r.x, r.y, 10, 10);
  }
  
  // Atualiza e desenha os organismos
  for (int i = populacao.size() - 1; i >= 0; i--) {
    Organismo o = populacao.get(i);
    o.procuraComida();
    o.atualiza();
    o.mostra();
    
    // Verifica se está morto
    if (o.morreu()) {
      populacao.remove(i);
    } else {
      // Tentativa de reprodução
      Organismo parceiro = encontraParceiro(o);
      if (parceiro != null) {
        Organismo filho = o.reproduzirSexuado(parceiro);
        if (filho != null) {
          populacao.add(filho);
        }
      }
    }
  }
  
  // Contador de frames para controlar as gerações
  contadorDeFrames++;
  if (contadorDeFrames >= tempoDeVida) {
    novaGeracao();
    contadorDeFrames = 0;
    geracao++;
  }
    
  surface.setTitle("Geração: " + geracao + " | " + "População: " + populacao.size() + " | " + "Recursos: " + comida.size());
}

Organismo encontraParceiro(Organismo o) {
  for (Organismo outro : populacao) {
    if (o != outro && PVector.dist(o.posicao, outro.posicao) < o.percepcao && o.dna[3] != outro.dna[3]) {
      return outro;
    }
  }
  return null;
}

void novaGeracao() {
  comida.clear();
  for (int i = 0; i < quantidadeRecursos; i++) {
    comida.add(new PVector(random(width), random(height)));
  }
  
  if (populacao.size() < 10) {
    for (int i = 0; i < 10; i++) {
      float[] dna = new float[4];
      for(int k = 0; k < 3; k++) dna[k] = random(1);
      dna[3] = random(1) < 0.5 ? 0 : 1;  // Definindo sexo
      populacao.add(new Organismo(new PVector(random(width), random(height)), dna));
    }
  }
}
