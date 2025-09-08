Plataforma FNC - Gestión de Caficultores y Abonos

Descripción

    Esta aplicación es una plataforma desarrollada para la gestión de caficultores, productos (monederos virtuales) y abonos, utilizando un backend en Delphi con EMS (Enterprise Mobility Services) y un frontend en React. Permite realizar operaciones CRUD (Crear, Leer, Actualizar, Eliminar) para caficultores, productos y abonos, así como consultar saldos y detalles asociados, con soporte para filtros por fechas y procedimientos almacenados en una base de datos Oracle.

Funcionalidades

    Registro de caficultores con nombre, identificación, ciudad y tipo de producto.
    Registro de abonos a monederos con validaciones básicas.
    Consulta de saldo total del monedero por caficultor.
    Visualización de productos bancarios asociados (pendiente de corrección en cursor).
    Visualización de tablas de caficultores y abonos.
    Filtros por fechas para abonos (pendiente de corrección en validación).
    CRUD básico para todas las entidades (caficultores, productos, abonos).
    Uso de procedimientos almacenados para registrar abonos, consultar saldos y detalles.

Estado Actual

    Completadas: Registro de caficultores, registro de abonos, consulta de saldos, visualización de tablas, CRUD básico.
    Pendientes: Corrección del cursor para mostrar productos asociados.

Requisitos

    Backend
    Delphi: Versión compatible con EMS (recomendado Delphi 10.3 o superior).
    FireDAC: Componentes de acceso a datos FireDAC (incluidos en Delphi Enterprise/Architect).
    Oracle Database: Versión XE o superior (configurada en localhost:1521/XE con usuario system y contraseña admin).
    EMS Server: Paquete EMS incluido con Delphi.

Frontend

    Node.js: Versión 14.x o superior.
    npm: Incluido con Node.js.
    React: Dependencias manejadas por package.json.

Instalación

Backend

Configura el Entorno:

    Instala Delphi y configura FireDAC con el driver para Oracle.
    Asegúrate de que Oracle XE esté corriendo en localhost:1521/XE con el usuario system y contraseña admin.


Clona el Repositorio:

    Descarga o clona el proyecto desde tu repositorio (ajusta la URL según corresponda):
    git clone <URL_DEL_REPOSITORIO>
    cd <ruta_del_proyecto>/backend

Abre y Compila el Proyecto:

    Abre CaficultoresBackend.dpk en Delphi.
    Asegúrate de que las unidades (Caficultores.pas, AbonosResource.pas, SaldosResource.pas, ProductosResource.pas) estén incluidas.
    Compila e instala el paquete.

Ejecuta el Servidor:

    Ejecuta EMSDevServer.exe desde la carpeta del proyecto.
    El servidor estará disponible en http://localhost:8080.

Frontend

Clona el Repositorio:

    Descarga o clona el proyecto:
    git clone <URL_DEL_REPOSITORIO>
    cd <ruta_del_proyecto>/frontend

Instala Dependencias:

    Instala Node.js y npm si no los tienes.
    
Ejecuta:

    npm install

Configura el Entorno:

Asegúrate de que la variable API_BASE en src/services/api.js apunte al backend:
    
    const API_BASE = 'http://localhost:8080';

Ejecuta la Aplicación:

Inicia el servidor de desarrollo:
    
    npm start
    Abre tu navegador en http://localhost:3000.

Estructura del Proyecto

Backend

    Caficultores.pas: CRUD para caficultores.
    AbonosResource.pas: Gestión de abonos (incluye filtros por fechas).
    SaldosResource.pas: Consulta de saldos y detalles de caficultores (usa procedimientos almacenados).
    ProductosResource.pas: CRUD para productos.
    EMSDevServer.dpr: Punto de entrada del servidor EMS.

Frontend

    src/App.js: Configuración de rutas.
    src/components/: Componentes React (TablaCaficultores, TablaAbonos, CaficultorForm, AbonoForm, CaficultorDetail).
    src/services/api.js: Llamadas a la API del backend.
    src/styles.css: Estilos globales de la aplicación.

Instrucciones de Uso

    Registrar Caficultor: Navega a /registrar, completa el formulario y envía.
    Ver Caficultores: Ve a / para ver la lista y usa los botones para detalles, abonos o eliminar.
    Registrar/Editar Abono: Usa /abonos/registrar o /abonos/registrar/{id} para crear o editar abonos.
    Filtrar Abonos: En /abonos/{idCaficultor}, ingresa fechas (formato DD-MM-YYYY) y haz clic en "Filtrar".
    Ver Detalle: Haz clic en "Ver Detalle" en la tabla de caficultores para ver información completa.
