unit ScreenManager.Interf;

interface

uses
  FMX.Layouts,
  System.Classes;

type
  IScreenManager = interface;
  IScreenManagerMethod = interface;

  IScreenManager = interface
    ['{1E3A1336-F80E-471B-8E9B-7FD7B46CBBD7}']
    function method: IScreenManagerMethod;
  end;

  IScreenManagerMethod = interface
    ['{B18155A9-7425-45E1-A553-B25E70176AFF}']
    procedure openForm(const layoutMain: TLayout; const aFormClass: TComponentClass);
    function &EndMethod: IScreenManager;
  end;

implementation

end.
