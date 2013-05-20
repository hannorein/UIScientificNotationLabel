UIScientificNotationLabel
==============

UIScientificNotationLabel is a subclass of UIView that allows you to display scientific notations of very large/small numbers on iOS and MacOS X.
The implementation automatically determines the number of significant digits to be shown to the user.
It can render  symmetric and asymmetric error-bars. 
It also supports upper and lower limits. 
The class uses a struct consisting of five floats as an input.
If the value for a field is not known, it should be set to `NAN`.

    typedef struct {
    	float value;		// The actual value (set to NAN when not known)
    	float error_minus;	// Lower error bar (set to NAN when not known)
    	float error_plus;	// Upper error bar (set to NAN when not known, can be the same as error_minus)
    	float lowerlimit;	// Lower limit (set to NAN when not known,)
    	float upperlimit;	// Upper limit (set to NAN when not known,)
    } floate;

Currently, the class only supports right alignment (because I didn't need left alignment). 

I use the class in my Exoplanet App for iOS (https://itunes.apple.com/us/app/exoplanet/id327702034?mt=8). A screenshot is shown below. The numbers on the right are rendered with this class.


![Screenshot](https://raw.github.com/hannorein/UIScientificNotationLabel/master/screenshot.png "Screenshot")

License
--------------
Copyright (c) 2013 Hanno Rein

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
