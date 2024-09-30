"use client";
import React, { useEffect, useState } from "react";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Pagination,
  PaginationContent,
  PaginationItem,
  PaginationLink,
  PaginationNext,
  PaginationPrevious,
} from "@/components/ui/pagination";
import { ChevronDown, ChevronUp, ChevronsUpDown } from "lucide-react";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import axios from "axios";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

const ITEMS_PER_PAGE = 5;

export const BookingComponent = () => {
  const url = "http://localhost/car-rental_api/admin/process.php";
  const [currentPage, setCurrentPage] = useState(1);
  const [sortColumn, setSortColumn] = useState(null);
  const [sortDirection, setSortDirection] = useState("asc");
  const [bookings, setBookings] = useState([]);
  const [sortedBookings, setSortedBookings] = useState([]);
  const [carList, setCarList] = useState([]);
  const [userList, setUserList] = useState([]);
  const [isAddBookingOpen, setIsAddBookingOpen] = useState(false);
  const [selectedCar, setSelectedCar] = useState(null);
  const [newBooking, setNewBooking] = useState({
    carID: "",
    customer_id: "",
    rental_start: "",
    rental_end: "",
    total_price: "",
    status: "",
    booking_source: "walk-in",
  });

  const getCarList = async () => {
    try {
      const res = await axios.get(url, {
        params: {
          operation: "getAvailableCars",
          json: "",
        },
      });

      if (res.status !== 200) {
        alert("Status Error: " + res.statusText);
        return;
      }

      if (res.data.success) {
        setCarList(res.data.success);
        return;
      } else {
        alert("Something went wrong");
        return;
      }
    } catch (e) {
      alert("An unexpected error occurred");
      console.log(e);
    }
  };

  const getUsersList = async () => {
    try {
      const res = await axios.get(url, {
        params: {
          operation: "getListOfUsers",
          json: "",
        },
      });

      if (res.status !== 200) {
        alert("Status Error: " + res.statusText);
        return;
      }

      if (res.data.success) {
        setUserList(res.data.success);
        return;
      } else {
        alert("Something went wrong fetching users");
        return;
      }
    } catch (e) {
      alert("An unexpected error occurred fetching users");
      console.log(e);
    }
  };

  const getBookingList = async () => {
    try {
      const res = await axios.get(url, {
        params: {
          operation: "readBookings",
          json: "",
        },
      });

      if (res.status !== 200) {
        alert("Status Error: " + res.statusText);
        return;
      }

      if (res.data.success) {
        setBookings(res.data.success);
        return;
      } else {
        alert("Something went wrong fetching booking list");
        console.log(res.data);
        setBookings([]);
        return;
      }
    } catch (e) {
      alert("An unexpected error occurred fetching booking list");
      console.log(e);
    }
  };

  useEffect(() => {
    getCarList();
    getUsersList();
    getBookingList();
  }, []);

  useEffect(() => {
    if (sortColumn) {
      const sorted = [...bookings].sort((a, b) => {
        if (a[sortColumn] < b[sortColumn])
          return sortDirection === "asc" ? -1 : 1;
        if (a[sortColumn] > b[sortColumn])
          return sortDirection === "asc" ? 1 : -1;
        return 0;
      });
      setSortedBookings(sorted);
    } else {
      setSortedBookings(bookings);
    }
  }, [bookings, sortColumn, sortDirection]);

  const calculateTotalPrice = () => {
    if (selectedCar && newBooking.rental_start && newBooking.rental_end) {
      const start = new Date(newBooking.rental_start);
      const end = new Date(newBooking.rental_end);
      const days = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
      const totalPrice = days * selectedCar.price_per_day;
      setNewBooking((prev) => ({
        ...prev,
        total_price: totalPrice.toFixed(2),
      }));
    }
  };

  useEffect(() => {
    calculateTotalPrice();
  }, [newBooking.rental_start, newBooking.rental_end, selectedCar]);

  const handleCarSelect = (value) => {
    const car = carList.find((car) => car.car_id === value);
    setSelectedCar(car);
    setNewBooking((prevBooking) => ({
      ...prevBooking,
      carID: value,
    }));
  };

  const handleUserSelect = (value) => {
    setNewBooking((prevBooking) => ({
      ...prevBooking,
      customer_id: value,
    }));
  };

  const handleSort = (column) => {
    if (sortColumn === column) {
      setSortDirection(sortDirection === "asc" ? "desc" : "asc");
    } else {
      setSortColumn(column);
      setSortDirection("asc");
    }
  };

  const paginatedBookings = sortedBookings.slice(
    (currentPage - 1) * ITEMS_PER_PAGE,
    currentPage * ITEMS_PER_PAGE
  );

  const totalPages = Math.ceil(bookings.length / ITEMS_PER_PAGE);

  const SortIcon = ({ column }) => {
    if (sortColumn !== column)
      return <ChevronsUpDown className="ml-2 h-4 w-4" />;
    return sortDirection === "asc" ? (
      <ChevronUp className="ml-2 h-4 w-4" />
    ) : (
      <ChevronDown className="ml-2 h-4 w-4" />
    );
  };

  const createBooking = async () => {
    const formData = new FormData();
    formData.append("operation", "createBooking");
    formData.append(
      "json",
      JSON.stringify({
        car_id: newBooking.carID,
        customer_id: newBooking.customer_id,
        rental_start: newBooking.rental_start,
        rental_end: newBooking.rental_end,
        total_price: newBooking.total_price,
        status: newBooking.status,
        booking_source: "walk-in",
      })
    );

    try {
      const res = await axios({
        url: url,
        method: "POST",
        data: formData,
      });

      if (res.status !== 200) {
        alert("Status Error");
        return;
      }

      if (res.data.success) {
        alert("Booking Created!");
        getBookingList();
        return;
      } else {
        alert("Something went wrong while creating the booking");
        console.log(res.data);
        return;
      }
    } catch (error) {
      alert("An error occured in the system");
      return;
    }
  };

  const updateBookingStatus = async (bookingId, newStatus) => {
    try {
      const formData = new FormData();
      formData.append("operation", "updateBooking");
      formData.append(
        "json",
        JSON.stringify({
          booking_id: bookingId,
          status: newStatus,
        })
      );

      const res = await axios({
        url: url,
        method: "POST",
        data: formData,
      });

      if (res.status !== 200) {
        alert("Status Error");
        return;
      }

      if (res.data.success) {
        alert("Booking status updated successfully!");
        getBookingList();
      } else {
        alert("Something went wrong while updating the booking status");
        console.log(res.data);
      }
    } catch (error) {
      alert("An error occurred in the system");
      console.log(error);
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setNewBooking((prev) => ({ ...prev, [name]: value }));
  };

  const handleAddBooking = () => {
    createBooking();
    setIsAddBookingOpen(false);
    setNewBooking({
      carID: "",
      customer_id: "",
      rental_start: "",
      rental_end: "",
      total_price: "",
      status: "",
      booking_source: "walk-in",
    });
    setSelectedCar(null);
  };

  const formatDate = (dateString) => {
    const options = {
      year: "numeric",
      month: "long",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    };
    return new Date(dateString).toLocaleDateString("en-US", options);
  };

  return (
    <Card className="w-full">
      <CardHeader className="flex flex-row items-center justify-between">
        <CardTitle>Bookings Management</CardTitle>
        <AlertDialog open={isAddBookingOpen} onOpenChange={setIsAddBookingOpen}>
          <AlertDialogTrigger asChild>
            <Button>New Booking</Button>
          </AlertDialogTrigger>
          <AlertDialogContent>
            <AlertDialogHeader>
              <AlertDialogTitle>Add New Booking</AlertDialogTitle>
              <AlertDialogDescription>
                Fill in the details for the new booking.
              </AlertDialogDescription>
            </AlertDialogHeader>
            <div className="grid gap-4 py-4">
              <div className="grid grid-cols-4 items-center gap-4">
                <Label className="text-right">Select Car</Label>
                <Select onValueChange={handleCarSelect}>
                  <SelectTrigger className="w-[180px]">
                    <SelectValue placeholder="Select Car" />
                  </SelectTrigger>
                  <SelectContent>
                    {carList.map((car) => (
                      <SelectItem key={car.car_id} value={car.car_id}>
                        {car.make} {car.model} (₱{car.price_per_day}/day)
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="grid grid-cols-4 items-center gap-4">
                <Label className="text-right">Select Customer</Label>
                <Select onValueChange={handleUserSelect}>
                  <SelectTrigger className="w-[180px]">
                    <SelectValue placeholder="Customer List" />
                  </SelectTrigger>
                  <SelectContent>
                    {userList.map((user) => (
                      <SelectItem
                        key={user.customer_id}
                        value={user.customer_id}
                      >
                        {user.first_name} {user.last_name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="grid grid-cols-4 items-center gap-4">
                <Label className="text-right">Rental Start</Label>
                <Input
                  name="rental_start"
                  value={newBooking.rental_start}
                  onChange={handleInputChange}
                  type="datetime-local"
                  className="col-span-2"
                />
              </div>
              <div className="grid grid-cols-4 items-center gap-4">
                <Label className="text-right">Rental End</Label>
                <Input
                  name="rental_end"
                  value={newBooking.rental_end}
                  onChange={handleInputChange}
                  type="datetime-local"
                  className="col-span-2"
                />
              </div>
              <div className="grid grid-cols-4 items-center gap-4">
                <Label className="text-right">Total Price</Label>
                <Input
                  name="total_price"
                  value={newBooking.total_price}
                  readOnly
                  type="number"
                  className="col-span-3"
                />
              </div>
              <div className="grid grid-cols-4 items-center gap-4">
                <Label className="text-right">Status</Label>
                <Select
                  onValueChange={(value) =>
                    handleInputChange({ target: { name: "status", value } })
                  }
                >
                  <SelectTrigger className="w-[180px]">
                    <SelectValue placeholder="Select status" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="confirmed">Confirmed</SelectItem>
                    <SelectItem value="pending">Pending</SelectItem>
                    <SelectItem value="canceled">Canceled</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>
            <AlertDialogFooter>
              <AlertDialogCancel>Cancel</AlertDialogCancel>
              <AlertDialogAction onClick={handleAddBooking}>
                Add
              </AlertDialogAction>
            </AlertDialogFooter>
          </AlertDialogContent>
        </AlertDialog>
      </CardHeader>
      <CardContent>
        <div className="rounded-md border">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead className="w-[100px]">ID</TableHead>
                <TableHead
                  onClick={() => handleSort("first_name")}
                  className="cursor-pointer"
                >
                  Name
                  <SortIcon column="first_name" />
                </TableHead>
                <TableHead
                  onClick={() => handleSort("rental_start")}
                  className="cursor-pointer"
                >
                  Rental Start Date
                  <SortIcon column="rental_start" />
                </TableHead>
                <TableHead
                  onClick={() => handleSort("rental_end")}
                  className="cursor-pointer"
                >
                  Rental End Date
                  <SortIcon column="rental_end" />
                </TableHead>
                <TableHead
                  onClick={() => handleSort("total_price")}
                  className="cursor-pointer"
                >
                  Total Price
                  <SortIcon column="total_price" />
                </TableHead>
                <TableHead>Status</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {paginatedBookings.map((booking) => (
                <TableRow key={booking.booking_id}>
                  <TableCell className="font-medium">
                    {booking.booking_id}
                  </TableCell>
                  <TableCell>{`${booking.first_name} ${booking.last_name}`}</TableCell>
                  <TableCell>{formatDate(booking.rental_start)}</TableCell>
                  <TableCell>{formatDate(booking.rental_end)}</TableCell>
                  <TableCell>{booking.total_price}</TableCell>
                  <TableCell>
                    <Select
                      defaultValue={booking.status}
                      onValueChange={(value) =>
                        updateBookingStatus(booking.booking_id, value)
                      }
                      disabled={
                        booking.status === "completed" ||
                        booking.status === "canceled"
                      }
                    >
                      <SelectTrigger
                        className={`w-[180px] capitalize ${
                          booking.status === "canceled" ? "bg-red-600" : ""
                        }`}
                      >
                        <SelectValue placeholder={booking.status} />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="confirmed">Confirmed</SelectItem>
                        <SelectItem value="pending">Pending</SelectItem>
                        <SelectItem value="canceled">Canceled</SelectItem>
                        <SelectItem value="completed">Completed</SelectItem>
                      </SelectContent>
                    </Select>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
        <Pagination className="mt-4">
          <PaginationContent>
            <PaginationItem>
              <PaginationPrevious
                onClick={() => setCurrentPage((prev) => Math.max(prev - 1, 1))}
                className={
                  currentPage === 1 ? "pointer-events-none opacity-50" : ""
                }
              />
            </PaginationItem>
            {[...Array(totalPages)].map((_, i) => (
              <PaginationItem key={i}>
                <PaginationLink
                  onClick={() => setCurrentPage(i + 1)}
                  isActive={currentPage === i + 1}
                >
                  {i + 1}
                </PaginationLink>
              </PaginationItem>
            ))}
            <PaginationItem>
              <PaginationNext
                onClick={() =>
                  setCurrentPage((prev) => Math.min(prev + 1, totalPages))
                }
                className={
                  currentPage === totalPages
                    ? "pointer-events-none opacity-50"
                    : ""
                }
              />
            </PaginationItem>
          </PaginationContent>
        </Pagination>
      </CardContent>
    </Card>
  );
};

export default BookingComponent;
