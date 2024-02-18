import Foundation

func degreesToRadians(degrees: Double) -> Double {
    return degrees * .pi / 180
}

func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
    let earthRadiusKm: Double = 6371.0

    let dLat = degreesToRadians(degrees: lat2 - lat1)
    let dLon = degreesToRadians(degrees: lon2 - lon1)

    let lat1 = degreesToRadians(degrees: lat1)
    let lat2 = degreesToRadians(degrees: lat2)

    let a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2)
    let c = 2 * atan2(sqrt(a), sqrt(1-a))

    return earthRadiusKm * c * 1000 // Convert to meters
}

func isLessThan20MetersApart(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Bool {
    let distance = calculateDistance(lat1: lat1, lon1: lon1, lat2: lat2, lon2: lon2)
    switch true {
        case distance < 20:
            return true
        default:
            return false
    }
}

func formatDistanceWithUnits(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> String {
    let distance = calculateDistance(lat1: lat1, lon1: lon1, lat2: lat2, lon2: lon2)

    switch true {
        case distance < 1000:
            return "(\(Int(distance)) m)"
        default:
            return "(\(String(format: "%.1f", distance / 1000)) km)"
    }
}

func distanceWithUnits(for point: PointAdded) -> String {
    guard let userLocation = LocationManager.shared.location else {
        return ""
    }
    return formatDistanceWithUnits(lat1: userLocation.latitude, lon1: userLocation.longitude, lat2: point.latitude, lon2: point.longitude)
}
