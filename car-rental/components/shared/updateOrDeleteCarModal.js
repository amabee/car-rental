import React, { useState, useEffect } from "react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import axios from "axios";

export const CarUpdateDeleteModal = ({ car, onUpdate, onDelete }) => {
  const [isOpen, setIsOpen] = useState(false);
  const [isDeleting, setIsDeleting] = useState(false);
  const [formData, setFormData] = useState({
    make: "",
    model: "",
    year: "",
    price_per_day: "",
    status: "",
  });
  const url = "http://localhost/car-rental_api/admin/process.php";

  useEffect(() => {
    if (car) {
      setFormData({
        make: car.make,
        model: car.model,
        year: car.year,
        price_per_day: car.price_per_day,
        status: car.status,
      });
    }
  }, [car]);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleStatusChange = (value) => {
    setFormData((prev) => ({ ...prev, status: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const formDataObj = new FormData();
    formDataObj.append("operation", "updateCar");
    formDataObj.append(
      "json",
      JSON.stringify({
        car_id: car.car_id,
        make: formData.make,
        model: formData.model,
        year: formData.year,
        license_plate: car.license_plate,
        price_per_day: formData.price_per_day,
        status: formData.status,
      })
    );

    try {
      const response = await axios({
        url: url,
        method: "POST",
        data: formDataObj,
      });
      if (response.data.success) {
        window.location.reload();
        setIsOpen(false);
      } else {
        alert("Something went wrong updating the car info");
      }
    } catch (error) {
      console.error("Error updating car:", error);
      alert("An error occurred while updating the car");
    }
  };

  const handleDelete = async () => {
    if (window.confirm("Are you sure you want to delete this car?")) {
      const formData = new FormData();
      formData.append("operation", "deleteCar");
      formData.append(
        "json",
        JSON.stringify({
          car_id: car.car_id,
        })
      );

      try {
        const response = await axios({
          url: url,
          method: "POST",
          data: formData,
        });
        if (response.status !== 200) {
          alert("Status Error");
          return;
        }

        if (response.data.success) {
          onDelete(car.car_id);
          setIsOpen(false);
        } else {
          alert(JSON.stringify(response.data));
        }
      } catch (error) {
        console.error("Error deleting car:", error);
        alert("An error occurred while deleting the car");
      }
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <DialogTrigger asChild>
        <Button
          variant="secondary"
          className="hover:bg-blue-500 hover:text-white"
          onClick={() => setIsOpen(true)}
        >
          Update
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>{isDeleting ? "Delete Car" : "Update Car"}</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit}>
          <div className="grid gap-4 py-4">
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="make" className="text-right">
                Make
              </Label>
              <Input
                id="make"
                name="make"
                value={formData.make}
                onChange={handleInputChange}
                className="col-span-3"
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="model" className="text-right">
                Model
              </Label>
              <Input
                id="model"
                name="model"
                value={formData.model}
                onChange={handleInputChange}
                className="col-span-3"
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="year" className="text-right">
                Year
              </Label>
              <Input
                id="year"
                name="year"
                type="number"
                value={formData.year}
                onChange={handleInputChange}
                className="col-span-3"
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="price_per_day" className="text-right">
                Price/Day
              </Label>
              <Input
                id="price_per_day"
                name="price_per_day"
                type="number"
                value={formData.price_per_day}
                onChange={handleInputChange}
                className="col-span-3"
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="status" className="text-right">
                Status
              </Label>
              <Select
                onValueChange={handleStatusChange}
                value={formData.status}
              >
                <SelectTrigger className="col-span-3">
                  <SelectValue placeholder="Select status" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="Available">Available</SelectItem>
                  <SelectItem value="Rented">Rented Out</SelectItem>
                  <SelectItem value="Maintenance">Maintenance</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
          <DialogFooter>
            <Button type="submit" className="mr-2">
              Update Car
            </Button>
            <Button
              type="button"
              variant="destructive"
              onClick={() => handleDelete()}
            >
              Delete Car
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
};
