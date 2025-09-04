-- Insertar 10 caficultores
INSERT INTO caficultores (nombre, identificacion, ciudad) VALUES ('Juan Pérez', '1234567890', 'Manizales');
INSERT INTO caficultores (nombre, identificacion, ciudad) VALUES ('María López', '2345678901', 'Pereira');
INSERT INTO caficultores (nombre, identificacion, ciudad) VALUES ('Carlos Gómez', '3456789012', 'Armenia');
INSERT INTO caficultores (nombre, identificacion, ciudad) VALUES ('Ana Rodríguez', '4567890123', 'Medellín');
INSERT INTO caficultores (nombre, identificacion, ciudad) VALUES ('Luis Martínez', '5678901234', 'Cali');
INSERT INTO caficultores (nombre, identificacion, ciudad) VALUES ('Sofía Hernández', '6789012345', 'Bogotá');
INSERT INTO caficultores (nombre, identificacion, ciudad) VALUES ('Diego Castro', '7890123456', 'Quibdó');
INSERT INTO caficultores (nombre, identificacion, ciudad) VALUES ('Laura Sánchez', '8901234567', 'Ibagué');
INSERT INTO caficultores (nombre, identificacion, ciudad) VALUES ('Pedro Ramírez', '9012345678', 'Popayán');
INSERT INTO caficultores (nombre, identificacion, ciudad) VALUES ('Clara Torres', '0123456789', 'Neiva');

-- Insertar un producto por caficultor (5 con MVI, otros con CAA, TAD, SGP)
INSERT INTO productos (id_caficultor, tipo_producto, numero_producto, saldo) VALUES (1, 'MVI', 'MVI-1001', 0);
INSERT INTO productos (id_caficultor, tipo_producto, numero_producto, saldo) VALUES (2, 'MVI', 'MVI-1002', 0);
INSERT INTO productos (id_caficultor, tipo_producto, numero_producto, saldo) VALUES (3, 'MVI', 'MVI-1003', 0);
INSERT INTO productos (id_caficultor, tipo_producto, numero_producto, saldo) VALUES (4, 'MVI', 'MVI-1004', 0);
INSERT INTO productos (id_caficultor, tipo_producto, numero_producto, saldo) VALUES (5, 'MVI', 'MVI-1005', 0);
INSERT INTO productos (id_caficultor, tipo_producto, numero_producto, saldo) VALUES (6, 'CAA', 'CAA-2001', 1500000);
INSERT INTO productos (id_caficultor, tipo_producto, numero_producto, saldo) VALUES (7, 'TAD', 'TAD-3001', 0);
INSERT INTO productos (id_caficultor, tipo_producto, numero_producto, saldo) VALUES (8, 'SGP', 'SGP-4001', 0);
INSERT INTO productos (id_caficultor, tipo_producto, numero_producto, saldo) VALUES (9, 'CAA', 'CAA-2002', 2500000);
INSERT INTO productos (id_caficultor, tipo_producto, numero_producto, saldo) VALUES (10, 'TAD', 'TAD-3002', 0);

-- Insertar abonos para los monederos virtuales (varios por caficultor con MVI)
INSERT INTO abonos (id_producto, monto, descripcion) VALUES (1, 500000, 'Abono por venta de café');
INSERT INTO abonos (id_producto, monto, descripcion) VALUES (1, 300000, 'Abono por subsidio agrícola');
INSERT INTO abonos (id_producto, monto, fecha_abono, descripcion) VALUES (1, 200000, TO_DATE('2025-08-15', 'YYYY-MM-DD'), 'Abono por apoyo FNC');
INSERT INTO abonos (id_producto, monto, descripcion) VALUES (2, 400000, 'Abono por cosecha');
INSERT INTO abonos (id_producto, monto, descripcion) VALUES (2, 600000, 'Abono por programa de fertilizantes');
INSERT INTO abonos (id_producto, monto, fecha_abono, descripcion) VALUES (3, 1000000, TO_DATE('2025-07-20', 'YYYY-MM-DD'), 'Abono por exportación');
INSERT INTO abonos (id_producto, monto, descripcion) VALUES (3, 150000, 'Abono por capacitación');
INSERT INTO abonos (id_producto, monto, descripcion) VALUES (4, 800000, 'Abono por venta directa');
INSERT INTO abonos (id_producto, monto, fecha_abono, descripcion) VALUES (4, 250000, TO_DATE('2025-09-01', 'YYYY-MM-DD'), 'Abono por apoyo gubernamental');
INSERT INTO abonos (id_producto, monto, descripcion) VALUES (5, 700000, 'Abono por producción orgánica');

-- Commit para confirmar los cambios
COMMIT;