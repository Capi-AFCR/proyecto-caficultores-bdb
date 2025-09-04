import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { getCaficultores, deleteCaficultor } from '../services/api';

const TablaCaficultores = () => {
  const navigate = useNavigate();
  const [caficultores, setCaficultores] = useState([]);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchCaficultores = async () => {
      try {
        const data = await getCaficultores();
        setCaficultores(data);
      } catch (err) {
        setError(err.message || 'Error al cargar caficultores');
      } finally {
        setLoading(false);
      }
    };
    fetchCaficultores();
  }, []);

  const handleDelete = async (id) => {
    if (window.confirm('¿Estás seguro de eliminar este caficultor?')) {
      try {
        await deleteCaficultor(id);
        setCaficultores(caficultores.filter((c) => c.id_caficultor !== id));
        setError('');
      } catch (err) {
        setError(err.message || 'Error al eliminar caficultor');
      }
    }
  };

  const handleViewDetail = (id) => navigate(`/caficultores/${id}`);
  const handleViewAbonos = (id) => navigate(`/abonos/${id}`);
  const handleRegister = () => navigate('/registrar');

  if (loading) return <p>Cargando...</p>;
  if (error) return <p className="error">{error}</p>;

  return (
    <div className="container">
      <h2>Lista de Caficultores</h2>
      <button onClick={handleRegister} className="primary">Registrar Nuevo Caficultor</button>
      <table>
        <thead>
          <tr>
            <th data-label="ID">ID</th>
            <th data-label="Nombre">Nombre</th>
            <th data-label="Identificación">Identificación</th>
            <th data-label="Ciudad">Ciudad</th>
            <th data-label="Acciones">Acciones</th>
          </tr>
        </thead>
        <tbody>
          {caficultores.map((caficultor) => (
            <tr key={caficultor.id_caficultor}>
              <td data-label="ID">{caficultor.id_caficultor}</td>
              <td data-label="Nombre">{caficultor.nombre}</td>
              <td data-label="Identificación">{caficultor.identificacion}</td>
              <td data-label="Ciudad">{caficultor.ciudad}</td>
              <td data-label="Acciones">
                <button onClick={() => handleViewDetail(caficultor.id_caficultor)} className="secondary">Ver Detalle</button> | 
                <button onClick={() => handleViewAbonos(caficultor.id_caficultor)} className="secondary">Ver Abonos</button> | 
                <button onClick={() => handleDelete(caficultor.id_caficultor)} className="danger">Eliminar</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default TablaCaficultores;