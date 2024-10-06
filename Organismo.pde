class Organismo {
  PVector posicao;
  PVector velocidade;
  float[] dna;
  float vida;
  float velocidadeMax;
  float percepcao;
  float tamanho;

  Organismo(PVector posicao, float[] dna) {
    this.posicao = posicao.copy();
    this.dna = dna;
    this.vida = 100;
    this.velocidadeMax = map(dna[0], 0, 1, 2, 5);
    this.percepcao = map(dna[1], 0, 1, 50, 200);
    this.tamanho = map(dna[2], 0, 1, 4, 8);
    this.velocidade = PVector.random2D();
  }

  void atualiza() {
    posicao.add(velocidade);
    vida -= velocidadeMax / 10.0;

    if (posicao.x > width) posicao.x = 0;
    if (posicao.x < 0) posicao.x = width;
    if (posicao.y > height) posicao.y = 0;
    if (posicao.y < 0) posicao.y = height;
  }

  void procuraComida() {
    PVector maisProximo = null;
    float dist = Float.MAX_VALUE;

    for (PVector r : comida) {
      float d = PVector.dist(posicao, r);
      if (d < dist && d < percepcao) {
        dist = d;
        maisProximo = r;
      }
    }

    if (maisProximo != null) {
      PVector desejado = PVector.sub(maisProximo, posicao);
      desejado.setMag(velocidadeMax);

      PVector direcao = PVector.sub(desejado, velocidade);
      velocidade.add(direcao);

      if (dist < tamanho) {
        vida += 20;
        comida.remove(maisProximo);
      }
    }
  }

  Organismo reproduzirSexuado(Organismo parceiro) {
    if (random(1) < 0.005 && vida > 50 && parceiro.vida > 50) {
      float[] novoDna = new float[4];

      // Metade do DNA de cada pai
      for (int k = 0; k < 3; k++) {
        novoDna[k] = random(1) < 0.5 ? dna[k] : parceiro.dna[k];
      }

      // Sexo aleatório para o filho
      novoDna[3] = random(1) < 0.5 ? 0 : 1;

      // Mutação
      for (int k = 0; k < 3; k++) {
        if (random(1) < 0.001) {
          novoDna[k] = constrain(novoDna[k] + random(-0.1, 0.1), 0, 1);
        }
      }

      vida -= 10;
      parceiro.vida -= 10;

      return new Organismo(posicao, novoDna);
    }
    return null;
  }

  boolean morreu() {
    return vida <= 0;
  }

  void mostra() {
    stroke(0);
    colorMode(HSB, 360, 100, 100);
    fill(cor(map(velocidadeMax, 2, 5, 0, 100)));
    ellipse(posicao.x, posicao.y, tamanho, tamanho);
    colorMode(RGB, 255, 255, 255);
  }

  color cor(float valor) {
    valor = constrain(valor, 0, 100);
    float matiz = map(valor, 0, 100, 0, 120);
    return color(matiz, 100, 100);
  }
}

