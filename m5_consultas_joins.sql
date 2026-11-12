
-- =====================================================
-- PRE-ENTREGA 5: CONSULTAS CON JOINS
-- Proyecto: Ventas_Tech_DB
-- Motor: SQL Server
-- =====================================================


-- =====================================================
-- CONSULTA 1: VISTA BASE DEL PROYECTO (INNER JOIN)
-- Propósito: enriquecer las ventas con información
-- de clientes, productos y categorías.
-- =====================================================

SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria;

-- Hallazgo: las ventas quedan enriquecidas con los
-- datos de clientes, ciudades, productos y categorías,
-- permitiendo analizar la facturación por ubicación
-- y tipo de producto.


-- =====================================================
-- CONSULTA 2: CLIENTES SIN VENTAS (LEFT JOIN)
-- Propósito: detectar clientes registrados que nunca
-- realizaron una compra, para que CRM pueda contactarlos.
-- =====================================================

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL;

-- Hallazgo: no se encontraron clientes sin compras.
-- Los 5 clientes registrados realizaron al menos una
-- venta, por lo que no hay clientes pendientes de
-- seguimiento por parte del área de CRM.


-- =====================================================
-- CONSULTA 3: PRODUCTOS SIN VENTAS (LEFT JOIN)
-- Propósito: identificar productos del catálogo que
-- todavía no registraron movimientos.
-- =====================================================

SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
WHERE v.id_producto IS NULL;

-- Hallazgo: no se encontraron productos sin ventas.
-- Los 6 productos del catálogo registraron al menos
-- una venta, por lo que todos tienen movimiento comercial.


-- =====================================================
-- CONSULTA 4: CONSOLIDADO POR ORIGEN (UNION ALL)
-- Propósito: comparar la facturación de dos grupos
-- de ventas utilizando UNION ALL.
-- =====================================================

SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Origen A' AS canal
    FROM ventas
    WHERE id_venta BETWEEN 1 AND 5

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Origen B' AS canal
    FROM ventas
    WHERE id_venta BETWEEN 6 AND 10
) AS consolidado
GROUP BY canal;

-- Hallazgo: el Origen A registra una facturación de
-- $3.620, mientras que el Origen B registra $2.824.
-- El Origen A concentra una mayor facturación.



