# Crono - Gestor de Proyectos con Temporizador

## ⚠️ Proyecto en Desarrollo

Este proyecto **no está terminado**, pero lo dejo aquí documentado como punto de partida para futuras implementaciones o para quien quiera continuarlo.

## 📝 Descripción

Crono es un gestor de proyectos desarrollado en Flutter que busca ayudar a los usuarios a trackear el tiempo dedicado a cada uno de sus proyectos de manera visual e intuitiva.

## ✨ Características Principales

### Implementadas:

- 📊 **Gestión de Proyectos**: Crea y administra múltiples proyectos
- ⏱️ **Temporizador por Proyecto**: Cada proyecto cuenta con su propio temporizador independiente
- ▶️ **Control de Tiempo**: Inicia y detén el temporizador cuando te sientes a trabajar en un proyecto específico
- 🎨 **Interfaz Adaptativa**: Diseño responsivo que se adapta a diferentes tamaños de ventana

### Característica Principal Planeada:

- 🎯 **Temporizador Flotante**: La funcionalidad más distintiva del proyecto es que al minimizar la ventana, el temporizador del proyecto activo permanece visible en un costado de la pantalla, superpuesto a todas las demás ventanas con una animación continua del tiempo corriendo. Esto permite al usuario mantener el control visual de su tiempo sin necesidad de cambiar entre ventanas.

## 🛠️ Tecnologías

- **Flutter**: Framework principal
- **Provider**: Manejo de estado
- **Dart**: Lenguaje de programación

## 📁 Estructura del Proyecto

```
lib/
├── config/          # Configuración de temas
├── models/          # Modelos de datos (Project)
├── pages/           # Páginas de la aplicación
├── providers/       # Gestión de estado (ProjectProvider, TimerProvider)
├── widgets/         # Componentes reutilizables
└── main.dart        # Punto de entrada
```

## 🚀 Cómo Ejecutar

```bash
# Clonar el repositorio
git clone [url-del-repositorio]

# Instalar dependencias
flutter pub get

# Ejecutar en modo debug
flutter run

# Para Windows
flutter run -d windows

# Para Web
flutter run -d chrome
```

## ⚡ Estado del Proyecto

El proyecto cuenta con las funcionalidades básicas de gestión de proyectos y temporizadores, pero la característica distintiva del **temporizador flotante superpuesto** aún no está completamente implementada. Esta funcionalidad requeriría:

- Implementación de ventanas overlay nativas en cada plataforma
- Manejo de permisos para ventanas siempre-en-frente (always-on-top)
- Animaciones fluidas para el temporizador flotante
- Sincronización entre la ventana principal y la ventana flotante

## 📋 Próximos Pasos

- [ ] Implementar ventana flotante overlay
- [ ] Persistencia de datos local
- [ ] Estadísticas y reportes de tiempo
- [ ] Exportación de datos
- [ ] Notificaciones y alertas
- [ ] Temas personalizables

## 📄 Licencia

Este proyecto se comparte como está, sin garantías de finalización o soporte continuo.

---

_Proyecto iniciado como exploración de gestión de tiempo con Flutter_
