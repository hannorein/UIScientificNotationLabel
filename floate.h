//
//  floate.h
//
//  Created by Hanno Rein on 5/19/13.
//
//

#ifndef Exoplanet_floate_h
#define Exoplanet_floate_h

typedef struct {
	float value;
	float error_minus;
	float error_plus;
	float lowerlimit;
	float upperlimit;
} floate;

extern const floate feNAN;

#endif
