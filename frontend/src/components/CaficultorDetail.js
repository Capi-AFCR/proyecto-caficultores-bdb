import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { getDetalleCaficultor } from '../services/api';

const CaficultorDetail = () => {
  const { id } = useParams();
  const [detalle, setDetalle] = useState(null);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchDetalle = async () => {
      try {
        const data = await getDetalleCaficultor(id);
        setDetalle(data);
      } catch (err) {
        setError(err.message || 'Error al consultar detalle');
      } finally {
        setLoading(false);
      }
    };
    fetchDetalle();
  }, [id]);

  if (loading) return <p>Cargando...</p>;
  if (error) return <p className="error">{error}</p>;
  if (!detalle) return <p>No se encontraron datos.</p>;

  return (
    <div className="container">
      <h2>Detalle del Caficultor ID {detalle.id_caficultor}</h2>
      <p><strong>Nombre:</strong> {detalle.nombre}</p>
      <p><strong>Identificación:</strong> {detalle.identificacion}</p>
      <p><strong>Ciudad:</strong> {detalle.ciudad}</p>

      <h3>Productos Asociados</h3>
      {detalle.productos.length > 0 ? (
        <ul>
          {detalle.productos.map((prod) => (
            <li key={prod.id_producto}>
              Producto: {prod.numero_producto}, Saldo: ${prod.saldo.toFixed(2)}
            </li>
          ))}
        </ul>
      ) : (
        <p>No hay productos asociados.</p>
      )}
    </div>
  );
};

export default CaficultorDetail;