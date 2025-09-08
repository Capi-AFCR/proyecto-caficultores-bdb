import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { getAbonos, deleteAbono } from '../services/api';

const TablaAbonos = () => {
  const { idCaficultor } = useParams();
  const navigate = useNavigate();
  const [abonos, setAbonos] = useState([]);
  const [fechaInicio, setFechaInicio] = useState('');
  const [fechaFin, setFechaFin] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  const fetchAbonos = async () => {
    try {
      setLoading(true);
      setError('');
      const params = {};
      if (fechaInicio) {
        const [year, month, day] = fechaInicio.split('-');
        params.fechaInicio = `${year}-${month}-${day}`;
      } else {
        params.fechaInicio = '';
      }
      if (fechaFin) {
        const [year, month, day] = fechaFin.split('-');
        params.fechaFin = `${year}-${month}-${day}`;
      } else {
        params.fechaFin = '';
      }
      //
      console.log('Fetching abonos with params:', params);
      const data = await getAbonos(idCaficultor, { params });
      if (data.mensaje) {
        setAbonos([]);
      } else {
        setAbonos(data);
      }
    } catch (err) {
      setError(err.message || 'Error al cargar abonos');
      console.error('Error fetching abonos:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchAbonos();
  }, [idCaficultor]);

  const handleFilter = () => {
    fetchAbonos();
  };

  const handleDelete = async (id) => {
    if (window.confirm('¿Estás seguro de eliminar este abono?')) {
      try {
        await deleteAbono(id);
        setAbonos(abonos.filter((a) => a.id_abono !== id));
        setError('');
      } catch (err) {
        setError(err.message || 'Error al eliminar abono');
      }
    }
  };

  const handleRegister = () => navigate('/abonos/registrar');
  const handleEdit = (id) => navigate(`/abonos/registrar/${id}`);

  if (loading) return <p>Cargando...</p>;
  if (error) return <p className="error">{error}</p>;

  return (
    <div className="container">
      <h2>Abonos para Caficultor ID {idCaficultor}</h2>
      <button onClick={handleRegister} className="primary">Registrar Nuevo Abono</button>
      <div style={{ marginBottom: '15px' }}>
        <input
          type="date"
          value={fechaInicio}
          onChange={(e) => setFechaInicio(e.target.value)}
          style={{ padding: '8px', marginRight: '10px', borderRadius: '4px' }}
        />
        <input
          type="date"
          value={fechaFin}
          onChange={(e) => setFechaFin(e.target.value)}
          style={{ padding: '8px', marginRight: '10px', borderRadius: '4px' }}
        />
        <button onClick={handleFilter} className="primary">Filtrar</button>
      </div>
      <table>
        <thead>
          <tr>
            <th data-label="ID Abono">ID Abono</th>
            <th data-label="ID Producto">ID Producto</th>
            <th data-label="Monto">Monto</th>
            <th data-label="Fecha">Fecha</th>
            <th data-label="Descripción">Descripción</th>
            <th data-label="Acciones">Acciones</th>
          </tr>
        </thead>
        <tbody>
          {abonos.length > 0 ? (
            abonos.map((abono) => (
              <tr key={abono.id_abono}>
                <td data-label="ID Abono">{abono.id_abono}</td>
                <td data-label="ID Producto">{abono.id_producto}</td>
                <td data-label="Monto">${abono.monto.toFixed(2)}</td>
                <td data-label="Fecha">{abono.fecha_abono}</td>
                <td data-label="Descripción">{abono.descripcion || 'Sin descripción'}</td>
                <td data-label="Acciones">
                  <button onClick={() => handleEdit(abono.id_abono)} className="secondary">Editar</button> | 
                  <button onClick={() => handleDelete(abono.id_abono)} className="danger">Eliminar</button>
                </td>
              </tr>
            ))
          ) : (
            <tr><td colSpan="6" style={{ borderBottom: '1px solid #ddd', padding: '12px', textAlign: 'center' }}>No se encontraron abonos para este caficultor en el rango de fechas.</td></tr>
          )}
        </tbody>
      </table>
    </div>
  );
};

export default TablaAbonos;