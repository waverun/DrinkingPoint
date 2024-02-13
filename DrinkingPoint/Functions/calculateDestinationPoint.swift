import CoreLocation

/// Calculates a new coordinate a given distance (in meters) away from a starting coordinate.
/// - Parameters:
///   - startCoordinate: The starting point.
///   - distanceMeters: The distance to move away from the starting point, in meters.
///   - bearingDegrees: The direction in which to move from the starting point, in degrees.
/// - Returns: A new `CLLocationCoordinate2D` that is `distanceMeters` away from `startCoordinate` in the `bearingDegrees` direction.
func calculateDestinationPoint(from startCoordinate: CLLocationCoordinate2D, distanceMeters: CLLocationDistance, bearingDegrees: CLLocationDirection) -> CLLocationCoordinate2D {
    let distanceRadians = distanceMeters / 6371000.0 // Earth's radius in meters
    let bearingRadians = bearingDegrees * .pi / 180.0

    let startLatitudeRadians = startCoordinate.latitude * .pi / 180.0
    let startLongitudeRadians = startCoordinate.longitude * .pi / 180.0

    let endLatitudeRadians = asin(sin(startLatitudeRadians) * cos(distanceRadians) + cos(startLatitudeRadians) * sin(distanceRadians) * cos(bearingRadians))
    let endLongitudeRadians = startLongitudeRadians + atan2(sin(bearingRadians) * sin(distanceRadians) * cos(startLatitudeRadians), cos(distanceRadians) - sin(startLatitudeRadians) * sin(endLatitudeRadians))

    return CLLocationCoordinate2D(latitude: endLatitudeRadians * 180.0 / .pi, longitude: endLongitudeRadians * 180.0 / .pi)
}
