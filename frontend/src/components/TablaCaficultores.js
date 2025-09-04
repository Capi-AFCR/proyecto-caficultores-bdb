import React, { useState, useMemo, useEffect } from 'react';
import { useReactTable, getCoreRowModel, getFilteredRowModel } from '@tanstack/react-table';
import { getCaficultores } from '../services/api';

const TablaCaficultores = () => {
  const [data, setData] = useState([]);
  const [filter, setFilter] = useState('');

  useEffect(() => {
    const fetchData = async () => {
      try {
        const result = await getCaficultores();
        setData(result);
      } catch (error) {
        console.error('Error fetching caficultores:', error);
      }
    };
    fetchData();
  }, []);

  const columns = useMemo(() => [
    { header: 'ID', accessorKey: 'id' },
    { header: 'Nombre', accessorKey: 'nombre' },
    { header: 'Identificación', accessorKey: 'identificacion' },
    { header: 'Ciudad', accessorKey: 'ciudad' },
  ], []);

  const table = useReactTable({
    data,
    columns,
    getCoreRowModel: getCoreRowModel(),
    getFilteredRowModel: getFilteredRowModel(), // Reemplazo de useFilters
    state: {
      globalFilter: filter, // Estado del filtro global
    },
    onGlobalFilterChange: setFilter, // Actualiza el filtro cuando cambia
  });

  return (
    <div>
      <input
        value={filter}
        onChange={(e) => setFilter(e.target.value)}
        placeholder="Filtrar por nombre..."
        style={{ marginBottom: '10px', padding: '5px', width: '200px' }}
      />
      <table {...table.getTableProps()} style={{ border: '1px solid black', width: '100%', borderCollapse: 'collapse' }}>
        <thead>
          {table.getHeaderGroups().map(headerGroup => (
            <tr key={headerGroup.id} style={{ borderBottom: '2px solid black' }}>
              {headerGroup.headers.map(header => (
                <th key={header.id} style={{ padding: '8px', border: '1px solid black', background: '#f0f0f0' }}>
                  {header.column.columnDef.header}
                </th>
              ))}
            </tr>
          ))}
        </thead>
        <tbody>
          {table.getRowModel().rows.map(row => (
            <tr key={row.id} style={{ borderBottom: '1px solid black' }}>
              {row.getVisibleCells().map(cell => (
                <td key={cell.id} style={{ padding: '8px', border: '1px solid black' }}>
                  {cell.getValue()}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default TablaCaficultores;