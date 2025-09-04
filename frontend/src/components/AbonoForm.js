import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { postAbono, putAbono, getAbonos, getMonederos } from '../services/api';

const AbonoForm = () => {
  const { id: idAbono } = useParams();
  const navigate = useNavigate();
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

    if (idAbono) {
      const fetchAbono = async () => {
        try {
          const data = await getAbonos(idAbono);
          if (Array.isArray(data) && data.length > 0) {
            const abono = data[0];
            setFormData({
              id_producto: abono.id_producto || '',
              monto: abono.monto || '',
              fecha_abono: abono.fecha_abono ? new Date(abono.fecha_abono * 1000).toISOString().split('T')[0] : '',
              descripcion: abono.descripcion || ''
            });
          } else if (data && !Array.isArray(data)) {
            setFormData({
              id_producto: data.id_producto || '',
              monto: data.monto || '',
              fecha_abono: data.fecha_abono ? new Date(data.fecha_abono * 1000).toISOString().split('T')[0] : '',
              descripcion: data.descripcion || ''
            });
          }
        } catch (err) {
          setError('Error al cargar abono: ' + err.message);
        }
      };
      fetchAbono();
    }
  }, [idAbono]);

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
      if (idAbono) {
        await putAbono(idAbono, formData);
        setSuccess('Abono actualizado con éxito');
      } else {
        await postAbono(formData);
        setSuccess('Abono registrado con éxito');
      }
      setFormData({ id_producto: '', monto: '', fecha_abono: '', descripcion: '' });
      setTimeout(() => navigate('/abonos/1'), 1000); // Ajusta el ID según necesites
    } catch (error) {
      setError(error);
    }
  };

  return (
    <div className="container">
      <h2>{idAbono ? 'Editar Abono' : 'Registrar Abono'}</h2>
      {error && <p className="error">{error}</p>}
      {success && <p className="success">{success}</p>}
      <form onSubmit={handleSubmit}>
        <select
          name="id_producto"
          value={formData.id_producto}
          onChange={handleChange}
          required
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
        />
        <input
          name="fecha_abono"
          value={formData.fecha_abono}
          onChange={handleChange}
          placeholder="Fecha Abono (YYYY-MM-DD)"
        />
        <input
          name="descripcion"
          value={formData.descripcion}
          onChange={handleChange}
          placeholder="Descripción"
        />
        <button type="submit" className="primary">{idAbono ? 'Actualizar' : 'Registrar'} Abono</button>
      </form>
    </div>
  );
};

export default AbonoForm;