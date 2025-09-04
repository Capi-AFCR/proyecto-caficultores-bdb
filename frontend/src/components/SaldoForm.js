import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { getSaldoPorCaficultor } from '../services/api';

const SaldoForm = () => {
  const { id } = useParams();
  const [saldo, setSaldo] = useState(null);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchSaldo = async () => {
      try {
        const data = await getSaldoPorCaficultor(id);
        setSaldo(data.saldo_total);
      } catch (err) {
        setError(err.message || 'Error al consultar saldo');
      } finally {
        setLoading(false);
      }
    };
    fetchSaldo();
  }, [id]);

  return (
    <div style={{ maxWidth: '400px', margin: '20px auto', padding: '20px', border: '1px solid #ccc' }}>
      <h2>Consultar Saldo del Monedero</h2>
      {loading && <p>Cargando...</p>}
      {error && <p style={{ color: 'red' }}>{error}</p>}
      {saldo !== null && !error && (
        <p style={{ color: 'green' }}>Saldo total para caficultor ID {id}: ${saldo.toFixed(2)}</p>
      )}
    </div>
  );
};

export default SaldoForm;