import React, { useState } from 'react';
import { postCaficultor } from '../services/api';

const CaficultorForm = () => {
  const [formData, setFormData] = useState({
    nombre: '',
    identificacion: '',
    ciudad: '',
    tipo_producto: 'MVI'
  });
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

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
      console.log(formData);
      await postCaficultor(formData);
      setSuccess('Caficultor registrado con éxito');
      setFormData({ nombre: '', identificacion: '', ciudad: '', tipo_producto: 'MVI' });
    } catch (error) {
      setError(error);
    }
  };

  return (
    <div style={{ maxWidth: '400px', margin: '20px auto', padding: '20px', border: '1px solid #ccc' }}>
      <h2>Registrar Caficultor</h2>
      {error && <p style={{ color: 'red' }}>{error}</p>}
      {success && <p style={{ color: 'green' }}>{success}</p>}
      <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '15px' }}>
        <input
          name="nombre"
          value={formData.nombre}
          onChange={handleChange}
          placeholder="Nombre"
          required
          style={{ padding: '8px' }}
        />
        <input
          name="identificacion"
          value={formData.identificacion}
          onChange={handleChange}
          placeholder="Identificación"
          required
          style={{ padding: '8px' }}
        />
        <input
          name="ciudad"
          value={formData.ciudad}
          onChange={handleChange}
          placeholder="Ciudad"
          required
          style={{ padding: '8px' }}
        />
        <select
          name="tipo_producto"
          value={formData.tipo_producto}
          onChange={handleChange}
          required
          style={{ padding: '8px' }}
        >
          <option value="CAA">Cuenta Ahorro (CAA)</option>
          <option value="TAD">Tarjeta Débito (TAD)</option>
          <option value="SGP">Gestión Productiva (SGP)</option>
          <option value="MVI">Monedero Virtual (MVI)</option>
        </select>
        <button type="submit" style={{ padding: '10px', background: '#007bff', color: 'white', border: 'none' }}>
          Registrar
        </button>
      </form>
    </div>
  );
};

export default CaficultorForm;