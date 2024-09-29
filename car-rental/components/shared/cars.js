import React, { useState, useEffect } from "react";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Pagination,
  PaginationContent,
  PaginationItem,
  PaginationLink,
  PaginationNext,
  PaginationPrevious,
} from "@/components/ui/pagination";
import { AddCarModal } from "./addCarModal";
import axios from "axios";
import { Trash2 } from "lucide-react";
import { Pencil2Icon } from "@radix-ui/react-icons";
import { CarUpdateDeleteModal } from "./updateOrDeleteCarModal";

export const Cars = () => {
  const url = "http://localhost/car-rental_api/admin/process.php";
  const car_image_path = "http://localhost/car-rental_api/CAR_IMAGES/";
  const [carList, setCarList] = useState([]);
  const [sortCriteria, setSortCriteria] = useState({
    column: "make",
    direction: "asc",
  });
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 8;

  const handleSort = (value) => {
    const [newSortColumn, newSortDirection] = value.split("-");
    setSortCriteria({ column: newSortColumn, direction: newSortDirection });
  };

  const handleAddCar = (newCar) => {
    setCarList((prevCars) => [...prevCars, newCar]);
  };

  const sortedCars = [...carList].sort((a, b) => {
    if (sortCriteria.column === "availability") {
      const availabilityOrder = ["Available", "Rented Out", "Maintenance"];
      return sortCriteria.direction === "asc"
        ? availabilityOrder.indexOf(a.status) -
            availabilityOrder.indexOf(b.status)
        : availabilityOrder.indexOf(b.status) -
            availabilityOrder.indexOf(a.status);
    }

    if (a[sortCriteria.column] < b[sortCriteria.column])
      return sortCriteria.direction === "asc" ? -1 : 1;
    if (a[sortCriteria.column] > b[sortCriteria.column])
      return sortCriteria.direction === "asc" ? 1 : -1;
    return 0;
  });

  const indexOfLastItem = currentPage * itemsPerPage;
  const indexOfFirstItem = indexOfLastItem - itemsPerPage;
  const currentCars = sortedCars.slice(indexOfFirstItem, indexOfLastItem);

  const paginate = (pageNumber) => setCurrentPage(pageNumber);

  const getCars = async () => {
    try {
      const res = await axios.get(url, {
        params: {
          operation: "getCars",
          json: "",
        },
      });

      if (res.status !== 200) {
        return alert("Status Error: " + res.statusText);
      }

      if (res.data.success) {
        setCarList(res.data.success);
      } else {
        alert("No cars found!");
      }
    } catch (error) {
      alert("Exception Error: " + error);
    }
  };

  useEffect(() => {
    getCars();
  }, []);

  return (
    <Card className="w-full">
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
        <CardTitle>Cars Management</CardTitle>
        <div className="flex space-x-2">
          <Select onValueChange={handleSort} defaultValue="make-asc">
            <SelectTrigger className="w-[180px]">
              <SelectValue placeholder="Sort by" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="make-asc">Make (A-Z)</SelectItem>
              <SelectItem value="make-desc">Make (Z-A)</SelectItem>
              <SelectItem value="price-asc">Price (Low to High)</SelectItem>
              <SelectItem value="price-desc">Price (High to Low)</SelectItem>
              <SelectItem value="year-desc">Year (Newest)</SelectItem>
              <SelectItem value="year-asc">Year (Oldest)</SelectItem>
              <SelectItem value="availability-asc">
                Availability (Available First)
              </SelectItem>
              <SelectItem value="availability-desc">
                Availability (Maintenance First)
              </SelectItem>
            </SelectContent>
          </Select>
          <AddCarModal onAddCar={handleAddCar} />
        </div>
      </CardHeader>
      <CardContent>
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
          {currentCars.map((car) => (
            <Card key={car.id} className="flex flex-col justify-between">
              <img
                src={car_image_path + car.car_image}
                alt={`${car.make} ${car.model}`}
                className="w-full h-40 object-cover"
              />
              <CardHeader>
                <CardTitle className="text-lg">
                  {car.make} {car.model}
                </CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-md text-gray-500">Year: {car.year}</p>
                <p className="text-md text-gray-500">
                  License Plate: {car.license_plate}
                </p>
                <p className="text-md font-semibold">
                  ₱{car.price_per_day} / Day
                </p>
                <p
                  className={`text-md capitalize ${
                    car.status === "available"
                      ? "text-green-600"
                      : car.status === "rented"
                      ? "text-yellow-500"
                      : car.status === "maintenance"
                      ? "text-red-600"
                      : ""
                  }`}
                >
                  {car.status}
                </p>

                <div className="flex justify-center mt-3">
                  <CarUpdateDeleteModal
                    car={car}
                    onUpdate={() => getCars()}
                    onDelete={() => getCars()}
                  />
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
        <Pagination className="mt-4">
          <PaginationContent>
            <PaginationItem>
              <PaginationPrevious
                onClick={() => paginate(currentPage - 1)}
                disabled={currentPage === 1}
              />
            </PaginationItem>
            {Array.from({
              length: Math.ceil(carList.length / itemsPerPage),
            }).map((_, index) => (
              <PaginationItem key={index}>
                <PaginationLink
                  onClick={() => paginate(index + 1)}
                  isActive={currentPage === index + 1}
                >
                  {index + 1}
                </PaginationLink>
              </PaginationItem>
            ))}
            <PaginationItem>
              <PaginationNext
                onClick={() => paginate(currentPage + 1)}
                disabled={
                  currentPage === Math.ceil(carList.length / itemsPerPage)
                }
              />
            </PaginationItem>
          </PaginationContent>
        </Pagination>
      </CardContent>
    </Card>
  );
};

export default Cars;
