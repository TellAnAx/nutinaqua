data <- list()

data$water_tap <- import_from_server("Water%20quality%20APO-SUB-2.xlsx", 
                                     "home/OneDrive-USB/APO-SUB-2/", 
                                     sheet_name = "data", 
                                     skip = 1)

data$feed <- import_from_server("Feed%20composition%20APO-SUB-2.xlsx", 
                                  "home/OneDrive-USB/APO-SUB-2/", 
                                           sheet_name = "data", 
                                           skip = 1)

data$iaffd_overview <- import_from_server("IAFFD%20FICD.xlsx",
                                "home/OneDrive-USB/Data/", 
                                sheet_name = "overview")

data$iaffd_composition <- import_from_server("IAFFD%20FICD.xlsx",
                                          "home/OneDrive-USB/Data/", 
                                          sheet_name = "composition")

