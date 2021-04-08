File data/tas_hadukgrid_uk_5km_ann_199001-199012.nc (NC_FORMAT_NETCDF4):

     7 variables (excluding dimension variables):
        double tas[projection_x_coordinate,projection_y_coordinate,time]   (Contiguous storage)  
            standard_name: air_temperature
            long_name: Mean air temperature
            units: degC
            description: Mean air temperature
            label_units: C
            level: 1.5m
            plot_label: Mean air temperature at 1.5m (C)
            cell_methods: time: mid_range within days time: mean over days time: mean
            grid_mapping: transverse_mercator
            coordinates: latitude longitude
        int transverse_mercator[]   (Contiguous storage)  
            grid_mapping_name: transverse_mercator
            longitude_of_prime_meridian: 0
            semi_major_axis: 6377563.396
            semi_minor_axis: 6356256.909
            longitude_of_central_meridian: -2
            latitude_of_projection_origin: 49
            false_easting: 4e+05
            false_northing: -1e+05
            scale_factor_at_central_meridian: 0.9996012717
        double time_bnds[bnds,time]   (Contiguous storage)  
        double projection_y_coordinate_bnds[bnds,projection_y_coordinate]   (Contiguous storage)  
        double projection_x_coordinate_bnds[bnds,projection_x_coordinate]   (Contiguous storage)  
        double latitude[projection_x_coordinate,projection_y_coordinate]   (Contiguous storage)  
            units: degrees_north
            standard_name: latitude
        double longitude[projection_x_coordinate,projection_y_coordinate]   (Contiguous storage)  
            units: degrees_east
            standard_name: longitude

     4 dimensions:
        time  Size:1
            axis: T
            bounds: time_bnds
            units: hours since 1800-01-01 00:00:00
            standard_name: time
            calendar: gregorian
        projection_y_coordinate  Size:290
            axis: Y
            bounds: projection_y_coordinate_bnds
            units: m
            standard_name: projection_y_coordinate
        projection_x_coordinate  Size:180
            axis: X
            bounds: projection_x_coordinate_bnds
            units: m
            standard_name: projection_x_coordinate
        bnds  Size:2
[1] "vobjtovarid4: **** WARNING **** I was asked to get a varid for dimension named bnds BUT this dimension HAS NO DIMVAR! Code will probably fail at this point"

    10 global attributes:
        comment: annual resolution gridded climate observations
        creation_date: 2020-08-14T11:52:50
        frequency: ann
        institution: Met Office
        references: doi: 10.1002/joc.1161
        short_name: annual_meantemp
        source: HadUK-Grid_v1.0.2.1
        title: Gridded surface climate observations data for the UK
        version: v20200731
        Conventions: CF-1.5
