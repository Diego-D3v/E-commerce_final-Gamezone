# 🎮 GameZone — E-Commerce de Videojuegos y Consolas

**Programación para Dispositivos Móviles**  
Universidad Pontificia Bolivariana · Prof. Luis Castilla · 2026

> Tienda #06 — Tienda: **GameZone** | Color primario: `#4A148C` (Morado)

---

## ✅ Checklist de entrega

### Clase 1
- [x] Login con validación de formulario (correo + mínimo 6 chars)
- [x] Con credenciales correctas navega al Home
- [x] Home muestra grilla de productos destacados
- [x] Búsqueda en tiempo real filtra productos
- [x] FilterChips de categoría filtran el grid
- [x] Al tocar un producto navega al Detalle
- [x] Detalle muestra imagen, rating, precio, descripción, categoría (Chip)
- [x] Botón ← del detalle regresa al Home

### Clase 2
- [x] Estado global del carrito con Provider
- [x] Dismissible en carrito (swipe → elimina con SnackBar + Deshacer)
- [x] AlertDialog de confirmación al finalizar compra
- [x] RefreshIndicator en el Home
- [x] Animación Hero en imagen de producto (Home ↔ Detalle)
- [x] PageView de banners con auto-scroll e indicadores animados
- [x] Pantalla de Perfil con SwitchListTile (Notificaciones, Ofertas, Modo oscuro)
- [x] Cerrar sesión limpia el carrito y navega al Login
- [x] Navegación con **Go_Router** (rutas, parámetros, redirect guard, ShellRoute)

### Extras (suman puntos ✨)
- [x] Pantalla de Favoritos / Wishlist
- [x] Historial de pedidos con estados visuales
- [x] Registro de nuevos usuarios
- [x] Badge de favoritos en el bottom nav
- [x] Transiciones personalizadas (fade en auth, slide en detalle/carrito)
- [x] Indicador de stock con colores
- [x] Selector de cantidad en el Detalle
- [x] Envío gratis automático al superar $500.000

---

## 🚀 Instalación

```bash
cd gamezone
flutter pub get
flutter run
```

**Cuenta demo:** `usuario@demo.com` / `123456`

---

## 📁 Estructura del proyecto

```
gamezone/
├── pubspec.yaml
└── lib/
    ├── main.dart                        ← MaterialApp.router + MultiProvider
    ├── config/
    │   ├── router.dart                  ← Go_Router: rutas, redirect, ShellRoute
    │   └── theme.dart                   ← ThemeData oscuro + color #4A148C
    ├── models/
    │   ├── product.dart
    │   ├── cart_item.dart
    │   └── user_model.dart              ← UserModel + Order + OrderStatus
    ├── data/
    │   ├── product_data.dart            ← 16 productos hardcodeados (kProducts)
    │   └── user_data.dart               ← Lista local de usuarios
    ├── providers/
    │   ├── auth_provider.dart
    │   ├── cart_provider.dart           ← Map<id, CartItem> como en el taller
    │   ├── wishlist_provider.dart
    │   ├── orders_provider.dart
    │   └── settings_provider.dart       ← notificaciones, ofertas, modoOscuro
    ├── screens/
    │   ├── auth/auth_screen.dart        ← LoginScreen + RegisterScreen
    │   ├── home/home_screen.dart        ← HomeScreen + _BannerCarousel (PageView)
    │   ├── catalog/catalog_screen.dart  ← búsqueda + FilterChip + GridView
    │   ├── product/product_detail_screen.dart  ← Hero + cantidad + relacionados
    │   ├── cart/cart_screen.dart        ← Dismissible + AlertDialog + Snackbar
    │   ├── wishlist/wishlist_screen.dart ← Wishlist + Orders (mismo archivo)
    │   ├── orders/orders_screen.dart    ← re-export
    │   ├── profile/profile_screen.dart  ← CircleAvatar + SwitchListTile
    │   └── main_scaffold.dart           ← BottomNav con ShellRoute
    └── widgets/
        └── common_widgets.dart          ← ProductCard(Hero), NeonBadge, EmptyState…
```

---

## ⚙️ Dependencias

```yaml
go_router: ^13.0.0       # Navegación (requisito del taller)
provider: ^6.1.1          # Estado global
google_fonts: ^6.1.0      # Tipografía Rajdhani (gaming)
flutter_rating_bar: ^4.0.1
carousel_slider: ^4.2.1
```

---

## 🏗️ Navegación — Go_Router

```
/login          → LoginScreen     (fade transition)
/register       → RegisterScreen  (fade transition)
/home           → HomeScreen      ┐
/catalog        → CatalogScreen   │ ShellRoute
/wishlist       → WishlistScreen  │ (bottom nav,
/orders         → OrdersScreen    │  sin transición)
/profile        → ProfileScreen   ┘
/product/:id    → ProductDetailScreen  (slide transition)
/cart           → CartScreen           (slide transition)
```

### Redirect guard
- Sin sesión → cualquier ruta protegida redirige a `/login`
- Con sesión → `/login` o `/register` redirigen a `/home`

---

## 📦 Categorías de productos

| Categoría   | Productos |
|-------------|-----------|
| Consolas    | PS5, Xbox Series X, Nintendo Switch OLED, PS5 Slim |
| Videojuegos | God of War Ragnarök, Elden Ring, Zelda TotK, Spider-Man 2, Hogwarts Legacy, Starfield |
| Accesorios  | DualSense Edge, Xbox Elite S2, HyperX Cloud Alpha, Silla DXRacer |
| PC Gaming   | NVIDIA RTX 4080 Super, Teclado Razer BlackWidow V4 |

---

## 🎨 Paleta de colores

| Token           | Color       | Uso |
|-----------------|-------------|-----|
| `primaryColor`  | `#4A148C`   | Color tienda (README) |
| `neonPurple`    | `#B347FF`   | Botones, badges, selección |
| `neonBlue`      | `#00D4FF`   | Plataforma, info |
| `neonGreen`     | `#00FF88`   | Precios, stock, éxito |
| `neonPink`      | `#FF2D78`   | Descuentos, favoritos, error |
| `bgPrimary`     | `#0A0A0F`   | Fondo principal |
| `bgCard`        | `#1A1A26`   | Tarjetas |

---

## 🏋️ Retos extra implementados

- **Búsqueda con filtro en tiempo real** (sin debounce, reacciona a cada tecla)
- **Persistencia de sesión** en memoria durante la sesión activa
- **Envío gratis dinámico** al superar $500.000 en el carrito
- **Hero animation** en todas las tarjetas de producto

---

_Programación para Dispositivos Móviles · UPB Bucaramanga · 2026_
