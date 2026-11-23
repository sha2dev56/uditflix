// MODELO CONTENIDO

// Esta clase representa un contenido de nuestra plataforma UDITflix.
// Por ejemplo: una pelicula, uncómic o un videojuego.

// En programación orientada a objetos, una clase define
// qué características tendrán los objetos que creemos

class Contenido {
    final int id;
    final String titulo;
    final String descripcion;
    // Tipo de contenido: vído, cómic o juego
    final String tipo;
    final String duracion;
    // URL del vídeo de demostración. Es opcional porque no todos los
    // contenidos son reproducibles (por ejemplo, los cómics).
    final String? urlVideo;

    // Constructor: permite crear nuevos Contenido

    const Contenido({
        required this.id,
        required this.titulo,
        required this.descripcion,
        required this.tipo,
        required this.duracion,
        this.urlVideo,
    });
}
