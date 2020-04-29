unit ScreenManager;

interface

uses
  ScreenManager.Interf,
  FMX.Layouts,
  System.Generics.Collections,
  FMX.Forms;

type
  TScreenManager = class(TInterfacedObject, IScreenManager, IScreenManagerMethod)
  private
    FForms : TDictionary<string, TForm>;
    function clearLayout(const layoutMain: TLayout): IScreenManagerMethod;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IScreenManager;

    // IScreenManager
    function method: IScreenManagerMethod;

    // IScreenManagerMethod
    procedure openForm(const layoutMain: TLayout; const aForm: TForm);
    function &EndMethod: IScreenManager;
  end;

implementation

uses
  System.SysUtils, System.Classes;

{ TScreenManager }

function TScreenManager.clearLayout(
  const layoutMain: TLayout): IScreenManagerMethod;
begin
  Result := Self;

  if (Assigned(layoutMain)) then
  begin
    // As long as there are objects in LayoutMain, it will be excluding one by one
    layoutMain.BeginUpdate;

    while (layoutMain.ChildrenCount > 0) do
    begin
      layoutMain.RemoveObject(layoutMain.Children[0]);
    end;

    layoutMain.EndUpdate;
  end;
end;

constructor TScreenManager.Create;
begin
  FForms := TDictionary<string, TForm>.Create;
end;

destructor TScreenManager.Destroy;
begin
  FreeAndNil(FForms);
  inherited;
end;

function TScreenManager.EndMethod: IScreenManager;
begin
  Result := Self;
end;

function TScreenManager.method: IScreenManagerMethod;
begin
  Result := Self;
end;

class function TScreenManager.New: IScreenManager;
begin
  Result := Self.Create;
end;

procedure TScreenManager.openForm(const layoutMain: TLayout; const aForm: TForm);
var
  LComponent: TComponent;
begin
  // Clean the layout before opening the new screen inside it
  clearLayout(layoutMain);

  // Creates the form to be able to search for the objects
  lComponent := aForm.FindComponent('LayoutMain');

  // Adds all LayoutMain objects to the main screen's LayoutMain
  if (Assigned(lComponent)) then
  begin
    layoutMain.AddObject(TLayout(lComponent));
  end;

  FForms.AddOrSetValue(ClassName, aForm);

  aForm.Hide;
end;

end.
