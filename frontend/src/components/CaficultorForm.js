import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { getCaficultores, postCaficultor, putCaficultor } from '../services/api';

const CaficultorForm = () => {
  const { id: idCaficultor } = useParams();
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    nombre: '',
    identificacion: '',
    ciudad: '',
    tipo_producto: 'MVI'
  });
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  useEffect(() => {
    if (idCaficultor) {
      const fetchCaficultor = async () => {
        try {
          const data = await getCaficultores().then((caficultores) => caficultores.find(c => c.id_caficultor === parseInt(idCaficultor)));
          if (data) {
            setFormData({
              nombre: data.nombre || '',
              identificacion: data.identificacion || '',
              ciudad: data.ciudad || '',
              tipo_producto: data.tipo_producto || 'MVI'
            });
          }
        } catch (err) {
          setError('Error al cargar caficultor: ' + err.message);
        }
      };
      fetchCaficultor();
    }
  }, [idCaficultor]);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
    setError('');
    setSuccess('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!formData.nombre || !formData.identificacion || !formData.ciudad) {
      setError('Todos los campos son requeridos');
      return;
    }
    if (!/^\d+$/.test(formData.identificacion)) {
      setError('La identificación debe ser numérica');
      return;
    }
    try {
      if (idCaficultor) {
        await putCaficultor(idCaficultor, formData);
        setSuccess('Caficultor actualizado con éxito');
      } else {
        await postCaficultor(formData);
        setSuccess('Caficultor registrado con éxito');
      }
      setFormData({ nombre: '', identificacion: '', ciudad: '', tipo_producto: 'MVI' });
      setTimeout(() => navigate('/'), 1000);
    } catch (error) {
      setError(error);
    }
  };

  return (
    <div className="container">
      <h2>{idCaficultor ? 'Editar Caficultor' : 'Registrar Caficultor'}</h2>
      {error && <p className="error">{error}</p>}
      {success && <p className="success">{success}</p>}
      <form onSubmit={handleSubmit}>
        <input
          name="nombre"
          value={formData.nombre}
          onChange={handleChange}
          placeholder="Nombre"
          required
        />
        <input
          name="identificacion"
          value={formData.identificacion}
          onChange={handleChange}
          placeholder="Identificación"
          required
        />
        <input
          name="ciudad"
          value={formData.ciudad}
          onChange={handleChange}
          placeholder="Ciudad"
          required
        />
        <select
          name="tipo_producto"
          value={formData.tipo_producto}
          onChange={handleChange}
          required
        >
          <option value="CAA">Cuenta Ahorro (CAA)</option>
          <option value="TAD">Tarjeta Débito (TAD)</option>
          <option value="SGP">Gestión Productiva (SGP)</option>
          <option value="MVI">Monedero Virtual (MVI)</option>
        </select>
        <button type="submit" className="primary">{idCaficultor ? 'Actualizar' : 'Registrar'}</button>
      </form>
    </div>
  );
};

export default CaficultorForm;