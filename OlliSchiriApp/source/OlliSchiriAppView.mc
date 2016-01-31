using Toybox.WatchUi as Ui;
using Toybox.Time as Time;
using Toybox.Timer as Timer;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Graphics as Gfx;
using Toybox.Attention as Attention;

var testValf = 1000f;
var tStart  = Calendar.duration( {:hours=>9, :minutes=>8, :seconds=>10} );
//var tStartM = 0f;

class OlliSchiriAppView extends Ui.View 
{

    var timer;
    var tText="nichts zu tun";
    var tTextNext = "";
    var tTextChck="";
    var tTimeNext;
    var tTime;
    var tAlt=0;
    var array = [
    			[1,"Spielfeld betreten"],
    			[2,"SR Positionen"],
    			[4,"Vorstellung"],
    			[5,"Einspielende"],
    			[12,"Aufstellungskarten"],
    			[15,"Einspielen"],
    			[16,"Auslosung"],
    			[30,"Eintreffen am Feld"],
    			[45,"Eintreffen in Halle"],
    			[60,"Aufwaermen"],
    			[9999,"Olli wartet :)"]
    			];
    //! Constructor
    function initialize()
    {
        // Set up a 1Hz update timer because we aren't registering
        // for any data callbacks that can kick our display update.
        timer = new Timer.Timer();
        timer.start( method(:onTimer), 10000, true );
    }


    //! Update the view
    function onUpdate(dc) 
    {
        // Call the parent onUpdate function to redraw the layout

    var vibrateData = [
                        new Attention.VibeProfile(  25, 100 ),
                        new Attention.VibeProfile(  50, 100 ),
                        new Attention.VibeProfile(  75, 100 ),
                        new Attention.VibeProfile( 100, 100 ),
                        new Attention.VibeProfile(  75, 100 ),
                        new Attention.VibeProfile(  50, 100 ),
                        new Attention.VibeProfile(  25, 100 )
                      ];        //array[10]="A 1";
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

       	var currTimeH;
       	var currTimeM;
		var nextTimeH;
		var nextTimeM;
       	var clockTime = Sys.getClockTime();
        var tNowM = (( clockTime.hour * 60 ) + clockTime.min );
        var tStartM = tStart.divide(60).value();
        var tDiff = tStartM - tNowM; 
        var tStartHour = tStart.divide(3600).value();
        var tStartMin = tStartM - tStartHour * 60;
        var i = 0; 
        var tZeit = "";
        
        for( i = 0; i < array.size(); i++ ) 
        {
        	tTime = array[i][0];
    		if(tDiff <= tTime)
    		{
    			tTextChck = tText;
    			tText = array[i][1].toString();
    			if ( tTextChck.toString() == tText)
		        {
				}
				else
				{
		        	Attention.playTone( 0 );
		         	Attention.vibrate( vibrateData );
	    			tText = array[i][1];
				   	if (i>0) {tAlt = i - 1;}
		         }
    			break;
    		}
		}
		tTimeNext = array[tAlt][0];
		tTextNext = array[tAlt][1];
		
        dc.drawText((dc.getWidth() / 2), ((dc.getHeight() / 2) - 90), Gfx.FONT_SMALL, clockTime.hour.toString() + ":" + (100 +clockTime.min).toString().substring(1,3), Gfx.TEXT_JUSTIFY_CENTER);
        if( tDiff >= 0 ) 
        {
        	if (tStartHour-tTime < 0) 
        	{
        		currTimeH = tStartHour-1;
        		currTimeM = 60 - tTime + tStartMin;
        	}
        	else
        	{
        		currTimeH = tStartHour;
        		currTimeM = tStartMin - tTime;
        	}
        	
        	if (tStartHour-tTimeNext < 0) 
        	{
        		nextTimeH = tStartHour-1;
        		nextTimeM = 60 - tTimeNext + tStartMin;
        	}
        	else
        	{
        		nextTimeH = tStartHour;
        		nextTimeM = tStartMin - tTimeNext;
        	}
        	
        	dc.drawText((dc.getWidth() / 2), ((dc.getHeight() / 2) - 60), Gfx.FONT_TINY, tStartHour.toString() + ":" + (100 + tStartMin).toString().substring(1,3) + " Spielbeginn (" + tDiff.toString() + "')", Gfx.TEXT_JUSTIFY_CENTER);
        	if (i<array.size() - 1)
        	{
	        	dc.drawText((dc.getWidth() / 2), ((dc.getHeight() / 2) + 40), Gfx.FONT_XTINY, nextTimeH.toString() + ":" + (100 + nextTimeM).toString().substring(1,3) + " " + tTextNext + " (" + (tDiff-tTimeNext).toString() + "')", Gfx.TEXT_JUSTIFY_CENTER);
    	     	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
		        dc.drawText((dc.getWidth() / 2), ((dc.getHeight() / 2) - 25), Gfx.FONT_SMALL, "seit " + currTimeH.toString() + ":" + (100 + currTimeM).toString().substring(1,3), Gfx.TEXT_JUSTIFY_CENTER);
		        tZeit = " (" + (tDiff-tTime).toString() + "')";
			}
	        dc.drawText((dc.getWidth() / 2), ((dc.getHeight() / 2)), Gfx.FONT_SMALL, tText.toString() + tZeit, Gfx.TEXT_JUSTIFY_CENTER);
        }
        else
        {
    	    dc.drawText((dc.getWidth() / 2), ((dc.getHeight() / 2) + 10), Gfx.FONT_SMALL, "Spielbeginn einstellen", Gfx.TEXT_JUSTIFY_CENTER);
        }
   //     dc.drawText( dc.getWidth() / 2, ( dc.getHeight() + dc.getFontHeight( Gfx.FONT_LARGE ) ) / 2, Gfx.FONT_LARGE, tText.toString() , Gfx.TEXT_JUSTIFY_CENTER);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() 
    {
    }

    function onTimer()
    {
        //Kick the display update
        Ui.requestUpdate();
    }
 }

	class NPDd extends Ui.NumberPickerDelegate 
	{
	    function onNumberPicked(value) 
	    {
	        tStart = value;
	    }
	}

	class BaseInputDelegate extends Ui.BehaviorDelegate
	{
	    var np;
	    var npi;
 	
	    function onMenu() 
	    {
	        var value;
            value = Calendar.duration( {:hours=>9, :minutes=>8, :seconds=>10} );
            np = new Ui.NumberPicker( Ui.NUMBER_PICKER_TIME_OF_DAY, value );
            Ui.pushView( np, new NPDd(), Ui.SLIDE_IMMEDIATE );
	        return true;
	    }
	
	    function onNextPage() 
	    {
	    }
	}
    
class NumberPickerView extends Ui.View {

    function onLayout(dc) {
        onUpdateNP(dc);
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    function onUpdateNP(dc) {
        dc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK );
        dc.clear();
        dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );

        dc.drawText((dc.getWidth() / 2), ((dc.getHeight() / 2) - 30), Gfx.FONT_SMALL, "Press Menu", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText((dc.getWidth() / 2), ((dc.getHeight() / 2) - 10), Gfx.FONT_SMALL, testValf.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText((dc.getWidth() / 2), ((dc.getHeight() / 2) + 10), Gfx.FONT_SMALL, testVali.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        if( dur != null )
        {
            dc.drawText((dc.getWidth() / 2), ((dc.getHeight() / 2) + 30), Gfx.FONT_SMALL, dur.value().toString(), Gfx.TEXT_JUSTIFY_CENTER);
        }
    }
}
