data <- list(
  water_tap = import_from_server("Water%20quality%20APO-SUB-2.xlsx", 
                                 "home/OneDrive-USB/APO-SUB-2/", 
                                 sheet_name = "municipal_tap", 
                                 skip = 1),
  feed_commercial = import_from_server("Feed%20composition%20APO-SUB-2.xlsx", 
                                       "home/OneDrive-USB/APO-SUB-2/", 
                                       sheet_name = "data_commercial", 
                                       skip = 1),
  feed_experimental = import_from_server("Feed%20_composition%20APO-SUB-2.xlsx", 
                                         "home/OneDrive-USB/APO-SUB-2/", 
                                         sheet_name = "data_experimental", 
                                         skip = 1)
)

