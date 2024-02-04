// Function to find a point by location
func findPointByLocation(latitude: Double, longitude: Double, withinMeters tolerance: Double) -> pointAdded? {
    for point in pointsAdded {
        let distance = calculateDistance(lat1: latitude, lon1: longitude, lat2: point.latitude, lon2: point.longitude)
        if distance < tolerance {
            return point
        }
    }
    return nil
}
