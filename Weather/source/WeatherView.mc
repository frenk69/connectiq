using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.System as Sys;
using Toybox.Position;

class Weather
{
    var temperature;
    var city;
}

class WeatherModel
{
    hidden var notify;

    function kelvinToFarenheight(kelvin)
    {
        return (kelvin);
    }

    function onPosition(info)
    {
        var latLon = info.position.toDegrees();

        Sys.println(latLon[0].toString());
        Sys.println(latLon[1].toString());

      //  Comm.makeJsonRequest("http://api.openweathermap.org/data/2.5/weather",{"lat"=>90, "lon"=>0}, {}, method(:onReceive));
        Comm.makeJsonRequest("http://v220101276784590.yourvserver.net/frank/index.php",{"user"=>2, "num"=>1}, {} ,method(:onReceive));

        notify.invoke("Loading\nWeather");
    }

    function initialize(handler)
    {
        Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
        notify = handler;
    }

    function onReceive(responseCode, data)
    {
        notify.invoke(responseCode);
        if( responseCode == 200 )
        {
            var weather = new Weather();
            weather.city = data["ZEIT1"];
            weather.temperature = data["Temp1"];
            Sys.println(weather.city);
            Sys.println(weather.temperature);
            notify.invoke(weather);
        }
        else
        {
            notify.invoke( "Failed to load\nError: " + responseCode.toString() );
        }
    }

}

class WeatherView extends Ui.View {
    hidden var mWeather = "";
    hidden var mModel;
    //! Load your resources here
    function onLayout(dc) {
        mWeather = "Waiting for Data";
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, mWeather, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    }

    function onWeather(weather)
    {
        if (weather instanceof Weather)
        {
            mWeather = Lang.format("Zeit: $1$\nTemp: $2$", [weather.city, weather.temperature]);
        }
        else if (weather instanceof Lang.String)
        {
            mWeather = weather;
        }
        Ui.requestUpdate();
    }
}