//
//  CarsController.swift
//  App
//
//  Created by Afiq Hamdan on 22/12/2018.
//

import Vapor

class CarsController: RouteCollection {
    func boot(router: Router) throws {
        let carsRoute = router.grouped("api", "cars")
        carsRoute.get(use: getAllCars)
        carsRoute.post(use: createCar)
    }
    
    func getAllCars(_ req: Request) throws -> Future<[Car]> {
        return Car.query(on: req).all()
    }
    
    func createCar(_ req:Request) throws -> Future<Car> {
        let car = try req.content.decode(Car.self)
        return car.save(on: req)
    }
}
