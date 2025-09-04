import React, { useState, useMemo, useEffect } from 'react';
import { useReactTable } from '@tanstack/react-table';
import { getAbonos } from '../services/api';

const TablaAbonos = ({ idCaficultor }) => {
  const [data, setData] = useState([]);
  const [fechaInicio, setFechaInicio] = useState('');
  const [fechaFin, setFechaFin] = useState('');

  useEffect(() => {
    const fetchData = async () => {
      try {
        const result = await getAbonos(idCaficultor, fechaInicio, fechaFin);
        setData(result);
      } catch (error) {
        console.error('Error fetching abonos:', error);
      }
    };
    fetchData();
  }, [idCaficultor, fechaInicio, fechaFin]);

  const columns = useMemo(() => [
    { Header: 'ID', accessor: 'id_abono' },
    { Header: 'Monto', accessor: 'monto' },
    { Header: 'Fecha', accessor: 'fecha_abono' },
    { Header: 'Descripción', accessor: 'descripcion' },
  ], []);

  const { getTableProps, getTableBodyProps, headerGroups, rows, prepareRow } = useReactTable({ columns, data });

  return (
    <div>
      <div>
        <label>Fecha Inicio:</label>
        <input type="date" value={fechaInicio} onChange={(e) => setFechaInicio(e.target.value)} />
        <label>Fecha Fin:</label>
        <input type="date" value={fechaFin} onChange={(e) => setFechaFin(e.target.value)} />
      </div>
      <table {...getTableProps()} style={{ border: '1px solid black', width: '100%' }}>
        <thead>
          {headerGroups.map(headerGroup => (
            <tr {...headerGroup.getHeaderGroupProps()}>
              {headerGroup.headers.map(column => (
                <th {...column.getHeaderProps()} style={{ border: '1px solid black', padding: '8px' }}>
                  {column.render('Header')}
                </th>
              ))}
            </tr>
          ))}
        </thead>
        <tbody {...getTableBodyProps()}>
          {rows.map(row => {
            prepareRow(row);
            return (
              <tr {...row.getRowProps()}>
                {row.cells.map(cell => (
                  <td {...cell.getCellProps()} style={{ border: '1px solid black', padding: '8px' }}>
                    {cell.render('Cell')}
                  </td>
                ))}
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
};

export default TablaAbonos;