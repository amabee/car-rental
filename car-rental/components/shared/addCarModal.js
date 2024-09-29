"use client";

import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useState } from "react";
import { Button } from "@/components/ui/button";
import axios from "axios";

export const AddCarModal = ({ onAddCar }) => {
  const url = "http://localhost/car-rental_api/admin/process.php";

  const [newCar, setNewCar] = useState({
    make: "",
    model: "",
    year: "",
    price: "",
    availability: "Available",
    license_plate: "",
    car_image: "",
  });

  const [selectedFile, setSelectedFile] = useState(null);
  const [previewImage, setPreviewImage] = useState("");

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setNewCar((prev) => ({ ...prev, [name]: value }));
  };

  const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (file && file.type.startsWith("image/")) {
      setSelectedFile(file);
      const reader = new FileReader();
      reader.onloadend = () => {
        setPreviewImage(reader.result);
      };
      reader.readAsDataURL(file);
    } else {
      setSelectedFile(null);
      setPreviewImage("");
      alert("Please select a valid image file.");
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    if (!newCar.make || !newCar.model || !newCar.year || !newCar.price) {
      alert("Please fill in all required fields.");
      return;
    }

    if (selectedFile) {
      onAddCar({ ...newCar, id: Date.now(), imageUrl: selectedFile.name });
    } else {
      onAddCar({ ...newCar, id: Date.now() });
    }

    setNewCar({
      make: "",
      model: "",
      year: "",
      price: "",
      availability: "Available",
      license_plate: "",
      car_image: "",
    });
    setSelectedFile(null);
    setPreviewImage("");

    addCar();
  };

  const addCar = async () => {
    const formData = new FormData();

    formData.append("operation", "createCar");
    formData.append(
      "json",
      JSON.stringify({
        make: newCar.make,
        model: newCar.model,
        year: newCar.year,
        license_plate: newCar.license_plate,
        price_per_day: newCar.price,
        status: newCar.availability,
      })
    );

    if (selectedFile) {
      formData.append("car_image", selectedFile);
    }

    try {
      const res = await axios({
        url: url,
        method: "POST",
        data: formData,
        headers: {
          "Content-Type": "multipart/form-data",
        },
      });

      if (res.data.success) {
        alert("Car Created");
      } else {
        alert("Error: " + JSON.stringify(res.data));
      }
    } catch (error) {
      alert("An error occurred: " + error.message);
    }
  };

  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button>Add Car</Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Add New Car</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="grid gap-4 py-4">
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="make" className="text-right">
              Make
            </Label>
            <Input
              id="make"
              name="make"
              value={newCar.make}
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
              value={newCar.model}
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
              value={newCar.year}
              onChange={handleInputChange}
              className="col-span-3"
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="price" className="text-right">
              Price
            </Label>
            <Input
              id="price"
              name="price"
              type="number"
              value={newCar.price}
              onChange={handleInputChange}
              className="col-span-3"
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="license_plate" className="text-right">
              License Plate
            </Label>
            <Input
              id="license_plate"
              name="license_plate"
              value={newCar.license_plate}
              onChange={handleInputChange}
              className="col-span-3"
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="image" className="text-right">
              Image
            </Label>
            <Input
              id="image"
              name="image"
              type="file"
              onChange={handleFileChange}
              accept="image/*"
              className="col-span-3"
            />
          </div>
          {previewImage && (
            <div className="mt-4 justify-center self-center text-center">
              <Label>Image Preview</Label>
              <img
                src={previewImage}
                alt={`Preview of ${newCar.make} ${newCar.model}`}
                className="mt-2 max-w-full h-auto max-h-40 object-cover text-center"
              />
            </div>
          )}
          <Button type="submit" className="mt-4">
            Add Car
          </Button>
        </form>
      </DialogContent>
    </Dialog>
  );
};
