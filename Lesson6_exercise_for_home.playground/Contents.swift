import UIKit

class Car {
    private var id: String;
    private var isBooked: Bool;
    
    init(id: String) {
        self.id = id;
        self.isBooked = false;
    }
    
    // getter
    var info: (id: String, isBooked: Bool) {
        get {
            return (id: self.id, isBooked: self.isBooked);
        }
    }
    
    // setter
    func changeStatus(status: Bool) {
        self.isBooked = status;
    }
    
    func book() -> Bool {
        self.isBooked = !self.isBooked;
        return self.isBooked;
    }
}

class Booking {
    private static var totalBookings = 0;
    private var id: Int;
    private var carId: String;
    private var reservation: Int;
    
    init(carId: String, reserve: Int) {
        Booking.totalBookings += 1
        self.id = Booking.totalBookings;
        self.carId = carId;
        self.reservation = reserve;
    }
    
    // get
    var info: (id: Int, carId: String, reservation: Int) {
        get {
            return (id: self.id, carId: self.carId, reservation: self.reservation);
        }
    }
}

class CarRental {
    var name: String;
    var cars: [Car] = [];
    var bookings: [Booking] = [];
    var inPending: [Booking] = [];
    static let price = 50; // for a day

    init(name: String) {
        self.name = name;
    }
    private func carIsBooked(id: String) -> Bool {
        return self.cars.contains{
            $0.info.id == id ?
                $0.info.isBooked :
                    false
        }
    }
    
    private func changeCarBookingStatus(id: String) -> Void {
        let index = self.cars.index(where: { $0.info.id == id });
        if ((index == nil)) {return};
        self.cars[index!].changeStatus(status: !self.cars[index!].info.isBooked);
    }
    
    // getter&setter
    var carsAvailabled: [Car] {
        get {
            return self.cars
        }
        set (newCars) {
            self.cars.append(contentsOf: newCars)
        }
    }

    func book(carId: String, days: Int, isPossiblyPostponed: Bool? = false) -> String{
        let carInfo = "Car with id \(carId)";
        let durationBooking = "for \(days) days";
        if (!self.cars.contains{$0.info.isBooked == false} && (!isPossiblyPostponed! || false)) {
            return "all cars have been booked"
        }
        if carIsBooked(id: carId) {
            if isPossiblyPostponed ?? false {
                self.inPending.append(Booking.init(carId: carId, reserve: days))
                return "the \(carInfo)  is already booked \(durationBooking), but your reservation is between \(days + 1)";
            }
            return "the \(carInfo)  is already booked \(durationBooking)";
        }
        changeCarBookingStatus(id: carId);
        self.bookings.append(Booking.init(carId: carId, reserve: days))
        return "\(carInfo) is booked \(durationBooking)";
    };
}

// MAIN
let carRental = CarRental.init(name: "SuperCarsBooking");
let UUIDs = [UUID().uuidString, UUID().uuidString]
let cars: [Car] = [
    Car.init(id: UUIDs[0]),
    Car.init(id: UUIDs[1])
]
carRental.carsAvailabled = cars;

print(carRental.book(carId: UUIDs[0], days: 2))
print(carRental.book(carId: UUIDs[1], days: 2))
print(carRental.book(carId: UUIDs[1], days: 2))
print(carRental.book(carId: UUIDs[1], days: 4, isPossiblyPostponed: true))

print("\n\nBOOKINGS \n");
for item in carRental.bookings {
    print("\t\(item.info)")
}
print("\n\n BOOKINGS RESERVED \n");
for item in carRental.inPending {
    print("\t\(item.info)")
}


