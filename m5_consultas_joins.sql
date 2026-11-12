
-- =====================================================
-- PRE-ENTREGA 5: CONSULTAS CON JOINS
-- Proyecto: Ventas_Tech_DB
-- Motor: SQL Server
-- =====================================================


-- =====================================================
-- CONSULTA 1: VISTA BASE DEL PROYECTO (INNER JOIN)
-- Propósito: combinar las ventas con la información
-- de clientes, productos y categorías para obtener
-- una vista enriquecida del negocio.
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

-- Hallazgo: la consulta permite analizar las ventas
-- relacionando clientes, ciudades, productos y categorías.
-- Esta información sirve como base para construir
-- indicadores y filtros en Power BI.


-- =====================================================
-- CONSULTA 2: CLIENTES SIN VENTAS (LEFT JOIN)
-- Propósito: identificar clientes registrados que
-- nunca realizaron una compra, para que el área de
-- CRM pueda realizar acciones de seguimiento.
-- =====================================================

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: no se encontraron clientes sin compras.
-- Los 5 clientes registrados realizaron al menos
-- una compra, por lo que no hay clientes pendientes
-- de seguimiento por parte del área de CRM.


-- =====================================================
-- CONSULTA 3: PRODUCTOS SIN VENTAS (LEFT JOIN)
-- Propósito: identificar productos del catálogo que
-- todavía no registraron ventas, para que el área de
-- producto pueda revisar su movimiento comercial.
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
WHERE v.id_venta IS NULL;

-- Hallazgo: no se encontraron productos sin ventas.
-- Los 6 productos del catálogo registraron al menos
-- una venta, por lo que todos presentan movimiento
-- comercial.


-- =====================================================
-- CONSULTA 4: CONSOLIDADO POR GRUPO (UNION ALL)
-- Propósito: comparar la facturación de dos grupos
-- de ventas utilizando UNION ALL.
-- =====================================================

SELECT
    origen,
    SUM(total) AS total_facturado
FROM (
    SELECT
        cantidad * precio_unitario AS total,
        'Grupo 1' AS origen
    FROM ventas
    WHERE id_venta BETWEEN 1 AND 5

    UNION ALL

    SELECT
        cantidad * precio_unitario AS total,
        'Grupo 2' AS origen
    FROM ventas
    WHERE id_venta BETWEEN 6 AND 10
) AS consolidado
GROUP BY origen;

-- Hallazgo: se comparan los importes facturados por
-- dos grupos de ventas, separados según su identificador.
-- Esta segmentación permite comparar la facturación
-- de ambos grupos, aunque no representa canales
-- comerciales reales.
