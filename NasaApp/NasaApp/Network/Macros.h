//
//  Macros.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#define RETPARAM_RESULTS            @"results"
#define RETPARAM_RANGE_ARRAY        @"retparameterrangearray"
#define RETPARAM_SEARCH_ARRAY       @"retparametersearcharray"
#define RETPARAM_TITLE              @"title"
#define RETPARAM_MEDIA_TYPE         @"media_type"
#define RETPARAM_URL                @"url"
#define RETPARAM_HD_URL             @"hdurl"
#define RETPARAM_DATE               @"date"
#define RETPARAM_EXPLANATION        @"explanation"
#define RETPARAM_COPYRIGHT          @"copyright"
#define RETPARAM_SERVICE_VERSION    @"service_version"
#define RETPARAM_FAVOURITE          @"favourite"


#define HOST_ADDRESS @"https://api.nasa.gov/planetary/apod"
#define API_KEY      @"NKBDhErFDGwZl3muYqEfgm6mMWqUYquZD7ADk6m4"

#define GET_APOD_RANGE_ENDPOINT    @"?api_key=%@&start_date=%@&end_date=%@"
#define SEARCH_APOD_ENDPOINT       @"?api_key=%@&date=%@"

#define APP_ERROR_DOMIAN  @"com.nasaapodapp.nasaapod"


enum  {
    DATA_NOT_FOUND = 901,
    INVALID_ARGUMENTS,
};

#endif /* Macros_h */
