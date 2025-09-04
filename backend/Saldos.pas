unit Saldos;

interface

uses
  System.SysUtils, System.Classes, System.JSON, FireDAC.Comp.Client, Data.DB,
  EMS.Services, EMS.ResourceAPI, EMS.ResourceTypes, FireDAC.Stan.Param,
  FireDAC.Phys.Oracle;

type
  [ResourceName('Saldos')]
  {$METHODINFO ON}
  TSaldosResource = class
  published
    [EndPointRequestSummary('Tests', 'GetSaldoPorCaficultor', 'Retrieves wallet balance by caficultor', 'application/json', '')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Path, 'id', 'A caficultor ID', true, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spObject, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(400, 'Bad Request', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(404, 'Not Found', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [ResourceSuffix('{id}')]
    procedure GetSaldoMonederoPorCaficultor(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
  end;

implementation

procedure TSaldosResource.GetSaldoMonederoPorCaficultor(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  Query: TFDQuery;
  IdCaficultor: Integer;
  SaldoTotal: Double;
  JSONObject: TJSONObject;
begin
  try
    // Obtener el ID del caficultor desde la URL
    IdCaficultor := StrToIntDef(ARequest.Params.Values['id'], -1);
    if IdCaficultor <= 0 then
    begin
      AResponse.RaiseBadRequest('ID de caficultor inválido');
      Exit;
    end;

    // Iniciar conexión y ejecutar el procedimiento almacenado
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := TFDConnection.Create(nil);
      Query.Connection.Params.DriverID := 'Ora';
      Query.Connection.Params.Database := 'XE';
      Query.Connection.Params.UserName := 'system';
      Query.Connection.Params.Password := 'admin';
      Query.SQL.Text := 'BEGIN consultar_saldo(:p_id_caficultor, :p_saldo_total); END;';
      Query.Params.ParamByName('p_id_caficultor').DataType := ftInteger;
      Query.Params.ParamByName('p_id_caficultor').AsInteger := IdCaficultor;
      Query.Params.ParamByName('p_saldo_total').DataType := ftFloat;
      Query.Params.ParamByName('p_saldo_total').ParamType := ptOutput;
      Query.ExecSQL;
      SaldoTotal := Query.Params.ParamByName('p_saldo_total').AsFloat;

      // Verificar si el caficultor existe (si saldo es 0, podría no tener monederos)
      Query.SQL.Text := 'SELECT 1 FROM caficultores WHERE id_caficultor = :id_caficultor';
      Query.Params.ParamByName('id_caficultor').DataType := ftInteger;
      Query.Params.ParamByName('id_caficultor').AsInteger := IdCaficultor;
      Query.Open;
      if Query.IsEmpty then
      begin
        AResponse.RaiseNotFound('Caficultor no encontrado');
        Exit;
      end;

      // Preparar la respuesta
      JSONObject := TJSONObject.Create;
      JSONObject.AddPair('id_caficultor', TJSONNumber.Create(IdCaficultor));
      JSONObject.AddPair('saldo_total', TJSONNumber.Create(SaldoTotal));
      AResponse.Body.SetValue(JSONObject, True);
      AResponse.StatusCode := 200;
    finally
      Query.Free;
    end;
  except
    on E: Exception do
    begin
      AResponse.RaiseError(500, 'Error al consultar saldo: ', E.Message);
      Exit;
    end;
  end;
end;

procedure Register;
begin
  RegisterResource(TypeInfo(TSaldosResource));
end;

initialization
  Register;
end.
