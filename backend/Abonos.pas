unit Abonos;

interface

uses
  System.SysUtils, System.Classes, System.JSON, FireDAC.Comp.Client, Data.DB,
  EMS.Services, EMS.ResourceAPI, EMS.ResourceTypes, FireDAC.Stan.Param,
  FireDAC.Phys.Oracle;

type
  [ResourceName('Abonos')]
  {$METHODINFO ON}
  TAbonosResource = class
  published
  [EndPointRequestSummary('Tests', 'GetMonederos', 'Retrieves list of monederos', 'application/json', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spObject, TAPIDoc.TPrimitiveFormat.None, '', '')]
    procedure GetMonederos(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
    [EndPointRequestSummary('Tests', 'PostAbono', 'Registers a payment to wallet', '', 'application/json')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Body, 'body', 'Abono data', true, TAPIDoc.TPrimitiveType.spObject,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spObject, '', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(400, 'Bad Request', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(404, 'Not Found', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    procedure PostAbono(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
  end;

implementation

procedure TAbonosResource.GetMonederos(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  Query: TFDQuery;
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := TFDConnection.Create(nil);
    Query.Connection.Params.DriverID := 'Ora';
    Query.Connection.Params.Database := 'XE';
    Query.Connection.Params.UserName := 'system';
    Query.Connection.Params.Password := 'admin';
    Query.SQL.Text := 'SELECT p.id_producto, p.numero_producto, c.nombre FROM productos p JOIN caficultores c ON p.id_caficultor = c.id_caficultor WHERE p.tipo_producto = ''MVI''';
    Query.Open;
    JSONArray := TJSONArray.Create;
    while not Query.Eof do
    begin
      JSONObject := TJSONObject.Create;
      JSONObject.AddPair('id_producto', TJSONNumber.Create(Query.FieldByName('id_producto').AsInteger));
      JSONObject.AddPair('label', Query.FieldByName('numero_producto').AsString + ' - ' + Query.FieldByName('nombre').AsString);
      JSONArray.AddElement(JSONObject);
      Query.Next;
    end;
    AResponse.Body.SetValue(JSONArray, True);
  finally
    Query.Free;
  end;
end;

procedure TAbonosResource.PostAbono(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  Query: TFDQuery;
  JSON: TJSONObject;
  IdProducto, IdAbono: Integer;
  Monto: Double;
  FechaAbono: TDateTime;
  Descripcion: string;
  NuevoSaldo: Double;
begin
  try
    // Obtener el cuerpo de la solicitud como JSON
    if not Assigned(ARequest.Body) then
    begin
      AResponse.RaiseBadRequest('Cuerpo de solicitud vacío o inválido');
      Exit;
    end;
    JSON := ARequest.Body.GetObject as TJSONObject;
    if not Assigned(JSON) then
    begin
      AResponse.RaiseBadRequest('Formato JSON inválido');
      Exit;
    end;

    // Extraer valores del JSON
    IdProducto := JSON.GetValue<Integer>('id_producto', 0);
    Monto := JSON.GetValue<Double>('monto', 0.0);
    FechaAbono := JSON.GetValue<TDateTime>('fecha_abono', Now);
    Descripcion := JSON.GetValue<string>('descripcion', '');

    // Validaciones básicas
    if IdProducto <= 0 then
    begin
      AResponse.RaiseBadRequest('ID de producto inválido');
      Exit;
    end;
    if Monto <= 0 then
    begin
      AResponse.RaiseBadRequest('Monto debe ser mayor a 0');
      Exit;
    end;

    // Iniciar conexión y transacción
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := TFDConnection.Create(nil);
      Query.Connection.Params.DriverID := 'Ora';
      Query.Connection.Params.Database := 'XE';
      Query.Connection.Params.UserName := 'system';
      Query.Connection.Params.Password := 'admin';
      // Verificar si el producto existe
      Query.SQL.Text := 'SELECT saldo FROM productos WHERE id_producto = :id_producto';
      Query.Params.ParamByName('id_producto').DataType := ftInteger;
      Query.Params.ParamByName('id_producto').AsInteger := IdProducto;
      Query.Open;
      if Query.IsEmpty then
      begin
        AResponse.RaiseNotFound('Producto no encontrado');
        Exit;
      end;
      NuevoSaldo := Query.FieldByName('saldo').AsFloat + Monto;
      Query.Close;

      // Insertar abono
      Query.SQL.Text := 'BEGIN registrar_abono(:p_id_producto, :p_monto, :p_descripcion, :p_id_abono); END;';
      Query.Params.ParamByName('p_id_producto').DataType := ftInteger;
      Query.Params.ParamByName('p_id_producto').AsInteger := IdProducto;
      Query.Params.ParamByName('p_monto').DataType := ftFloat;
      Query.Params.ParamByName('p_monto').AsFloat := Monto;
      Query.Params.ParamByName('p_descripcion').DataType := ftString;
      Query.Params.ParamByName('p_descripcion').AsString := Descripcion;
      Query.Params.ParamByName('p_id_abono').DataType := ftInteger;
      Query.Params.ParamByName('p_id_abono').ParamType := ptOutput;
      Query.ExecSQL;
      IdAbono := Query.Params.ParamByName('p_id_abono').AsInteger;

      AResponse.Body.SetValue(TJSONObject.Create.AddPair('mensaje', 'Abono '+InttoStr(IdAbono)+' registrado con éxito').AddPair('nuevo_saldo', TJSONNumber.Create(NuevoSaldo)), True);
    finally
      Query.Free;
    end;
  except
    on E: Exception do
    begin
      AResponse.RaiseError(500, 'Error al registrar abono: ', E.Message);
      Exit;
    end;
  end;
end;

procedure Register;
begin
  RegisterResource(TypeInfo(TAbonosResource));
end;

initialization
  Register;
end.
