import React, { useState, useEffect } from 'react';
import { postAbono, getMonederos } from '../services/api';

const AbonoForm = () => {
  const [formData, setFormData] = useState({
    id_producto: '',
    monto: '',
    fecha_abono: '',
    descripcion: ''
  });
  const [monederos, setMonederos] = useState([]);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  useEffect(() => {
    const fetchMonederos = async () => {
      try {
        const data = await getMonederos();
        setMonederos(data);
      } catch (err) {
        setError('Error al cargar monederos: ' + err.message);
      }
    };
    fetchMonederos();
  }, []);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
    setError('');
    setSuccess('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!formData.id_producto || !formData.monto) {
      setError('ID de producto y monto son requeridos');
      return;
    }
    if (!/^\d+$/.test(formData.id_producto)) {
      setError('ID de producto debe ser numérico');
      return;
    }
    if (parseFloat(formData.monto) <= 0) {
      setError('Monto debe ser mayor a 0');
      return;
    }
    try {
      await postAbono(formData);
      setSuccess('Abono registrado con éxito');
      setFormData({ id_producto: '', monto: '', fecha_abono: '', descripcion: '' });
    } catch (error) {
      setError(error);
    }
  };

  return (
    <div style={{ maxWidth: '400px', margin: '20px auto', padding: '20px', border: '1px solid #ccc' }}>
      <h2>Registrar Abono</h2>
      {error && <p style={{ color: 'red' }}>{error}</p>}
      {success && <p style={{ color: 'green' }}>{success}</p>}
      <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '15px' }}>
        <select
          name="id_producto"
          value={formData.id_producto}
          onChange={handleChange}
          required
          style={{ padding: '8px' }}
        >
          <option value="">Seleccione un monedero</option>
          {monederos.map((monedero) => (
            <option key={monedero.id_producto} value={monedero.id_producto}>
              {monedero.label}
            </option>
          ))}
        </select>
        <input
          name="monto"
          value={formData.monto}
          onChange={handleChange}
          placeholder="Monto"
          required
          style={{ padding: '8px' }}
        />
        <input
          name="fecha_abono"
          value={formData.fecha_abono}
          onChange={handleChange}
          placeholder="Fecha Abono (YYYY-MM-DD)"
          style={{ padding: '8px' }}
        />
        <input
          name="descripcion"
          value={formData.descripcion}
          onChange={handleChange}
          placeholder="Descripción"
          style={{ padding: '8px' }}
        />
        <button type="submit" style={{ padding: '10px', background: '#007bff', color: 'white', border: 'none' }}>
          Registrar Abono
        </button>
      </form>
    </div>
  );
};

export default AbonoForm;