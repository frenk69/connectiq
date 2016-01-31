using Toybox.Application as App;

class OlliSchiriApp extends App.AppBase {

    function onStart()
    {
        return false;
    }

    function getInitialView()
    {
        return [new OlliSchiriAppView(), new BaseInputDelegate() ];
    }

    function onStop()
    {
        return false;
    }
    
}