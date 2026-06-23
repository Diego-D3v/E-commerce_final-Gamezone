import '../models/product.dart';

// Lista hardcodeada de productos GameZone
const List<Product> kProducts = [
  // ── CONSOLAS ──────────────────────────────────────────────────
  Product(
    id: 'c001',
    name: 'PlayStation 5',
    description:
        'La consola de nueva generación de Sony con SSD ultrarrápido, ray tracing y DualSense con retroalimentación háptica. Experimenta velocidad y mundos de juego increíbles.',
    price: 2899900,
    originalPrice: 3199900,
    imageUrl:
        'https://exitocol.vtexassets.com/arquivos/ids/28105967/playstation-5-pro-2tb.jpg?v=639045198442470000',
    category: 'Consolas',
    platform: 'PlayStation',
    rating: 4.9,
    reviewCount: 1243,
    isFeatured: true,
    stock: 5,
    tags: ['PS5', 'Sony', 'Nueva Gen'],
  ),
  Product(
    id: 'c002',
    name: 'Xbox Series X',
    description:
        'La Xbox más potente hasta la fecha. Con 12 teraflops de GPU, SSD personalizado y retrocompatibilidad con miles de juegos de Xbox, Xbox 360 y Xbox One.',
    price: 2749900,
    originalPrice: 2999900,
    imageUrl:
        'https://images.unsplash.com/photo-1621259182978-fbf93132d53d?w=500',
    category: 'Consolas',
    platform: 'Xbox',
    rating: 4.8,
    reviewCount: 987,
    isFeatured: true,
    stock: 7,
    tags: ['Xbox', 'Microsoft', 'Nueva Gen', '4K'],
  ),
  Product(
    id: 'c003',
    name: 'Nintendo Switch OLED',
    description:
        'Disfruta de la pantalla OLED vibrante de 7 pulgadas, base con puerto LAN, 64 GB de almacenamiento interno y audio mejorado. ¡Juega en casa o en cualquier lugar!',
    price: 1599900,
    imageUrl:
        'https://exitocol.vtexassets.com/arquivos/ids/32433207/consola-nintendo-switch-oled-blanca-64gb-pantalla-7-pulgadas.jpg?v=639059222278530000',
    category: 'Consolas',
    platform: 'Nintendo',
    rating: 4.7,
    reviewCount: 2105,
    isFeatured: true,
    stock: 12,
    tags: ['Nintendo', 'Portátil', 'OLED'],
  ),
  Product(
    id: 'c004',
    name: 'PlayStation 5 Slim',
    description:
        'La versión más compacta y ligera de PS5. Mismo rendimiento de nueva generación en un diseño más pequeño. Incluye unidad de disco desmontable.',
    price: 2499900,
    imageUrl:
        'https://carulla.vtexassets.com/arquivos/ids/16502547/consola-playstation-5-slim-lector-disco-ps5-spiderman-digital.jpg?v=638566818702170000',
    category: 'Consolas',
    platform: 'PlayStation',
    rating: 4.8,
    reviewCount: 634,
    isNew: true,
    stock: 8,
    tags: ['PS5', 'Slim', 'Compacta'],
  ),
  // ── VIDEOJUEGOS ───────────────────────────────────────────────
  Product(
    id: 'g001',
    name: 'God of War: Ragnarök',
    description:
        'Kratos y Atreus se embarcan en un épico viaje por los nueve reinos en busca de respuestas. Combate brutal, historia profunda y gráficos impresionantes.',
    price: 249900,
    originalPrice: 319900,
    imageUrl:
        'https://hips.hearstapps.com/hmg-prod/images/gof-of-war-ragnarok-portada-1631262719.jpg',
    category: 'Videojuegos',
    platform: 'PlayStation',
    rating: 4.9,
    reviewCount: 5421,
    isFeatured: true,
    stock: 20,
    tags: ['Acción', 'Aventura', 'PS5'],
  ),
  Product(
    id: 'g002',
    name: 'Elden Ring',
    description:
        'Una vasta tierra a través de la niebla. Un reino antiguo donde el Anillo de Élder fue destrozado. El mayor desafío de tu vida te espera.',
    price: 219900,
    originalPrice: 279900,
    imageUrl:
        'https://i.redd.it/bueqtztxmnj81.png',
    category: 'Videojuegos',
    platform: 'Multi',
    rating: 4.8,
    reviewCount: 8932,
    isFeatured: true,
    stock: 15,
    tags: ['RPG', 'Souls-like', 'Mundo Abierto'],
  ),
  Product(
    id: 'g003',
    name: 'Zelda: Tears of the Kingdom',
    description:
        'Link se aventura bajo las nubes y sobre ellas explorando el vasto reino de Hyrule. Un mundo abierto épico con mecánicas de construcción revolucionarias.',
    price: 239900,
    imageUrl:
        'https://i0.wp.com/meowmeowguatemala.com/wp-content/uploads/2024/08/LEGEND-OF-ZELDA-TEARS-OF-THE-KINGDOM-2025-WALL-CAL.jpg?fit=1800%2C1800&ssl=1',
    category: 'Videojuegos',
    platform: 'Nintendo',
    rating: 4.9,
    reviewCount: 6745,
    stock: 18,
    tags: ['Aventura', 'RPG', 'Nintendo'],
  ),
  Product(
    id: 'g004',
    name: 'Spider-Man 2',
    description:
        'Peter Parker y Miles Morales se unen para enfrentar a Kraven el Cazador y Venom. La mayor aventura de Spider-Man en PS5.',
    price: 259900,
    imageUrl:
        'https://acdn-us.mitiendanube.com/stores/004/056/791/products/ofertas-1-noviembre-5-fc50fd6091835f9f8517297165717363-1024-1024.webp',
    category: 'Videojuegos',
    platform: 'PlayStation',
    rating: 4.7,
    reviewCount: 3210,
    isNew: true,
    stock: 22,
    tags: ['Acción', 'Marvel', 'PS5'],
  ),
  Product(
    id: 'g005',
    name: 'Hogwarts Legacy',
    description:
        'Vive la experiencia de ser estudiante en Hogwarts en los años 1800. Explora ubicaciones icónicas, aprende hechizos y descubre una antigua magia.',
    price: 199900,
    originalPrice: 249900,
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/3/33/Hogwarts_Legacy_promotional_photo_horizontal.jpg',
    category: 'Videojuegos',
    platform: 'Multi',
    rating: 4.6,
    reviewCount: 4102,
    stock: 25,
    tags: ['RPG', 'Magia', 'Mundo Abierto'],
  ),
  Product(
    id: 'g006',
    name: 'Starfield',
    description:
        'La primera nueva IP de Bethesda en 25 años. Explora más de 1000 planetas en este épico RPG de ciencia ficción.',
    price: 229900,
    imageUrl:
        'https://pbs.twimg.com/media/GmA7FJiWQAE3Akg.jpg',
    category: 'Videojuegos',
    platform: 'Xbox',
    rating: 4.4,
    reviewCount: 2867,
    stock: 16,
    tags: ['RPG', 'Sci-Fi', 'Bethesda'],
  ),
  // ── ACCESORIOS ────────────────────────────────────────────────
  Product(
    id: 'a001',
    name: 'DualSense Edge (PS5)',
    description:
        'El mando inalámbrico premium de PS5 con palancas intercambiables, botones traseros y perfiles personalizables para gaming competitivo.',
    price: 529900,
    imageUrl:
        'https://audiocolor.co/cdn/shop/files/ControlPS5DualsenseEdgeNegro-2.jpg?v=1743274949',
    category: 'Accesorios',
    platform: 'PlayStation',
    rating: 4.8,
    reviewCount: 1543,
    isNew: true,
    stock: 9,
    tags: ['Mando', 'PS5', 'Pro'],
  ),
  Product(
    id: 'a002',
    name: 'Xbox Elite Controller S2',
    description:
        'El mando más avanzado de Xbox con palancas de tensión ajustable, gatillos de viaje corto y hasta 40 horas de batería recargable.',
    price: 499900,
    originalPrice: 549900,
    imageUrl:
        'https://exitocol.vtexassets.com/arquivos/ids/25122485/Control-Xbox-Elite-Series-2-XBOX-4IK-00001-3300099_a.jpg?v=638641719174030000',
    category: 'Accesorios',
    platform: 'Xbox',
    rating: 4.7,
    reviewCount: 2234,
    stock: 11,
    tags: ['Mando', 'Xbox', 'Elite'],
  ),
  Product(
    id: 'a003',
    name: 'Headset HyperX Cloud Alpha',
    description:
        'Auriculares gaming con drivers duales de cámara dividida para audio más claro. Compatible con PS5, Xbox, PC y Nintendo Switch.',
    price: 379900,
    originalPrice: 429900,
    imageUrl:
        'https://exitocol.vtexassets.com/arquivos/ids/24868793/auriculares-inalambricos-hyperx-gaming-cloud-alpha-dtsx-para-pc-ps5-ps4-color-negro.jpg?v=638629686574600000',
    category: 'Accesorios',
    platform: 'Multi',
    rating: 4.6,
    reviewCount: 3421,
    isFeatured: true,
    stock: 14,
    tags: ['Auriculares', 'Gaming', 'HyperX'],
  ),
  Product(
    id: 'a004',
    name: 'Silla Gamer DXRacer Racing',
    description:
        'Silla ergonómica de alta gama con soporte lumbar ajustable, reposabrazos 4D y reclinable hasta 135°. Perfecta para sesiones largas.',
    price: 1299900,
    originalPrice: 1499900,
    imageUrl:
        'https://http2.mlstatic.com/D_Q_NP_781897-MLU70616450526_072023-O.webp',
    category: 'Accesorios',
    platform: 'PC',
    rating: 4.5,
    reviewCount: 876,
    stock: 6,
    tags: ['Silla', 'Ergonómica', 'DXRacer'],
  ),
  // ── PC GAMING ─────────────────────────────────────────────────
  Product(
    id: 'p001',
    name: 'NVIDIA RTX 4080 Super',
    description:
        'Tarjeta gráfica de última generación con 16GB GDDR6X, ray tracing de 2da gen y DLSS 3. Domina los juegos en 4K con framerate altísimo.',
    price: 3899900,
    originalPrice: 4299900,
    imageUrl:
        'https://http2.mlstatic.com/D_NQ_NP_949342-MLU77059730920_062024-O.webp',
    category: 'PC Gaming',
    platform: 'PC',
    rating: 4.9,
    reviewCount: 654,
    isFeatured: true,
    stock: 3,
    tags: ['GPU', 'NVIDIA', 'RTX', '4K'],
  ),
  Product(
    id: 'p002',
    name: 'Teclado Razer BlackWidow V4',
    description:
        'Teclado mecánico gaming con switches Razer Yellow de actuación lineal, iluminación Chroma RGB por tecla y reposamuñecas magnético.',
    price: 459900,
    imageUrl:
        'https://exitocol.vtexassets.com/arquivos/ids/31895182/image-fd8df5cfee0e4287a42118402ddfa936.jpg?v=638996951895600000',
    category: 'PC Gaming',
    platform: 'PC',
    rating: 4.6,
    reviewCount: 1876,
    stock: 13,
    tags: ['Teclado', 'Mecánico', 'RGB', 'Razer'],
  ),
];

// Categorías únicas
List<String> get kCategories => [
      'Todos',
      ...{...kProducts.map((p) => p.category)}
    ];

// Utilidades de búsqueda/filtro
List<Product> searchProducts(String query) {
  final q = query.toLowerCase();
  return kProducts
      .where((p) =>
          p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.platform.toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q)))
      .toList();
}

List<Product> filterByCategory(String category) => category == 'Todos'
    ? kProducts
    : kProducts.where((p) => p.category == category).toList();

List<Product> get featuredProducts =>
    kProducts.where((p) => p.isFeatured).toList();
List<Product> get newProducts => kProducts.where((p) => p.isNew).toList();

Product? findProductById(String id) {
  try {
    return kProducts.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
}
