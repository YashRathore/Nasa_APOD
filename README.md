# Nasa_APOD
NasaAPOD demo app (Swift + Objective C)

# NasaAPOD App (UI Layer in Swift).
# NasaAPOD App (Network layer in Objective C)
# Network Layer Architecture Diagram.
# Facade Design Pattern implemented for network module. 
# In network layer open architecture is implemented to provide scalability, modularity and configure different web service architecture (like Rest, Soap and Proprietary).
# Basic NSURLSessionDataTask is used for network calls in current implementation
# Coredata is used for persistent storage
# Image rendering is using ImageDownloadUtility along with cache implementation 

# TO-DO:
# Error code parsed and  action handling is done only for no network scenario, rest are pending. 
# Network indicator for network calls
# No retry button added in case of network unavailability.
# Image synchronisation for cells after download
# Database, Operation queue's, Concurrent operation limit, Singleton. (Improvements)
