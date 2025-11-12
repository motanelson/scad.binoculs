// BINÓCULOS COM DOIS TUBOS
// Configurações principais

comprimento_total = 140;        // Comprimento total de cada tubo
diametro_interno = 20;          // Diâmetro interno dos tubos
espessura_parede = 3;           // Espessura da parede dos tubos
distancia_anilhas = 10;         // Distância das anilhas às extremidades
espessura_anilha = 2;           // Espessura das anilhas de suporte
distancia_entre_tubos = 50;     // Distância entre os centros dos tubos
espaco_nariz = 20;              // Espaço para o nariz do utilizador
espessura_barra = 5;            // Espessura da barra de conexão

// ========== CÁLCULOS DERIVADOS ==========
diametro_externo = diametro_interno + 2 * espessura_parede;
raio_interno = diametro_interno / 2;
raio_externo = diametro_externo / 2;
largura_barra = distancia_entre_tubos - diametro_externo + 10; // Sobreposição de 5mm cada lado

// ========== MÓDULOS PRINCIPAIS ==========

// Tubo individual do binóculo
module tubo_binoculo(deslocamento_x) {
    translate([deslocamento_x, 0, 0]) {
        color("Yellow")
        // Tubo principal
        difference() {
            cylinder(h = comprimento_total, r = raio_externo, $fn = 60);
            translate([0, 0, -1])
            cylinder(h = comprimento_total + 2, r = raio_interno, $fn = 60);
        }
        
        // Anilhas de suporte para lentes
        // Anilha frontal (próxima à objetiva)
        color("Yellow")
        translate([0, 0, distancia_anilhas])
        difference() {
            cylinder(h = espessura_anilha, r = raio_interno, $fn = 60);
            translate([0, 0, -1])
            cylinder(h = espessura_anilha + 2, r = raio_interno * 0.95, $fn = 60);
        }
        color("Yellow")
        // Anilha traseira (próxima à ocular)
        translate([0, 0, comprimento_total - distancia_anilhas - espessura_anilha])
        difference() {
            cylinder(h = espessura_anilha, r = raio_interno, $fn = 60);
            translate([0, 0, -1])
            cylinder(h = espessura_anilha + 2, r = raio_interno * 0.95, $fn = 60);
        }
        color("Yellow")
        // Detalhes decorativos no tubo
        for(z = [30:30:comprimento_total-30]) {
            translate([0, 0, z])
            difference() {
                cylinder(h = 2, r = raio_externo, $fn = 60);
                cylinder(h = 2.1, r = raio_externo - 1, $fn = 60);
            }
        }
    }
}

// Barra de conexão entre os tubos
module barra_conexao() {
    // Barra principal
    color("Yellow")
    translate([-largura_barra/2, raio_externo - 2.5, espaco_nariz])
    cube([largura_barra, espessura_barra, comprimento_total - 2 * espaco_nariz]);
    color("Yellow")
    // Reforços laterais
    for(x = [-largura_barra/2, largura_barra/2 - 5]) {
        translate([x, raio_externo - 2.5, espaco_nariz])
        cube([5, espessura_barra + 5, 10]);
        
        translate([x, raio_externo - 2.5, comprimento_total - espaco_nariz - 10])
        cube([5, espessura_barra + 5, 10]);
    }
}

// Sistema de ajuste interpupilar (opcional)
module ajuste_interpupilar() {
    color("Yellow")
    // Eixo central de ajuste
    translate([0, raio_externo + espessura_barra, comprimento_total/2])
    rotate([90, 0, 0])
    cylinder(h = 10, r = 3, $fn = 30);
    
    // Mostrador de ajuste
    translate([0, raio_externo + espessura_barra + 5, comprimento_total/2])
    rotate([90, 0, 0])
    cylinder(h = 2, r = 8, $fn = 60);
}

// ========== MONTAGEM FINAL ==========
union() {
    // Tubo esquerdo
    tubo_binoculo(-distancia_entre_tubos/2);
    
    // Tubo direito
    tubo_binoculo(distancia_entre_tubos/2);
    
    // Barra de conexão
    barra_conexao();
    
    // Sistema de ajuste
    ajuste_interpupilar();
}

// ========== VISUALIZAÇÃO DAS LENTES ==========
color("Yellow")
// Lentes objetivas (frontais)
for(x = [-distancia_entre_tubos/2, distancia_entre_tubos/2]) {
    translate([x, 0, distancia_anilhas - 1])
    color("Yellow", 0.5)
    cylinder(h = 1, r = raio_interno * 0.95, $fn = 60);
}
color("Yellow")
// Lentes oculares (traseiras)
for(x = [-distancia_entre_tubos/2, distancia_entre_tubos/2]) {
    translate([x, 0, comprimento_total - distancia_anilhas - espessura_anilha + 1])
    color("Yellow", 0.5)
    cylinder(h = 1, r = raio_interno * 0.95, $fn = 60);
}

// ========== INFORMAÇÕES TÉCNICAS ==========
echo("=== ESPECIFICAÇÕES DOS BINÓCULOS ===");
echo(str("Comprimento total: ", comprimento_total, "mm"));
echo(str("Diâmetro interno: ", diametro_interno, "mm"));
echo(str("Diâmetro externo: ", diametro_externo, "mm"));
echo(str("Distância entre tubos: ", distancia_entre_tubos, "mm"));
echo(str("Espaço para nariz: ", espaco_nariz, "mm"));

/*
INSTRUÇÕES DE USO E MONTAGEM:

1. IMPRESSÃO:
   - Imprima na vertical (em pé) para melhor qualidade
   - Use preenchimento de 20-25%
   - Velocidade moderada para detalhes precisos

2. MONTAGEM:
   - As lentes (não incluídas) devem ser encaixadas nas anilhas
   - Use cola para fixar as lentes nas anilhas
   - A barra de conexão proporciona rigidez estrutural

3. PERSONALIZAÇÃO:
   - Ajuste 'distancia_entre_tubos' para seu conforto
   - Modifique 'espaco_nariz' conforme necessário
   - Altere 'espessura_barra' para maior/menor rigidez

DICAS:
- Para lentes de 25mm de diâmetro, aumente 'diametro_interno' para 25
- Para binóculos mais compactos, reduza 'comprimento_total'
- Para melhor estética, pinte após a impressão
*/