"use client";
import axios from "axios";
import { Card, CardHeader, CardTitle, CardContent } from "../ui/card";
import { useEffect, useState } from "react";

export const Dashboard = () => {
  const [dashboardDatas, setDashboardDatas] = useState({
    annual_income: 0,
    monthly_income: 0,
    total_bookings: 0,
    total_cars: 0,
    cars_under_maintenance: 0,
  });

  const getDashBoardData = async () => {
    const url = "http://localhost/car-rental_api/admin/process.php";
    try {
      const res = await axios.get(url, {
        params: {
          operation: "getIncomeAndBookings",
          json: "",
        },
      });

      if (res.status !== 200) {
        return alert("Status Error: " + res.statusText);
      }

      if (res.data.success) {
        setDashboardDatas(res.data.success);
      } else {
        alert("Something went wrong fetching dashboard data");
      }
    } catch (error) {
      alert(error);
      return;
    }
  };

  useEffect(() => {
    getDashBoardData();
  }, []);

  const formatNumberWithCommas = (number) => {
    return new Intl.NumberFormat().format(number);
  };

  return (
    <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
      <Card>
        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
          <CardTitle className="text-sm font-medium">Annual Revenue</CardTitle>
          <svg
            fill="#fff"
            viewBox="0 0 36 36"
            version="1.1"
            preserveAspectRatio="xMidYMid meet"
            xmlns="http://www.w3.org/2000/svg"
            width={16}
            height={16}
          >
            <title>peso-line</title>
            <path
              d="M31,13.2H27.89A6.81,6.81,0,0,0,28,12a7.85,7.85,0,0,0-.1-1.19h2.93a.8.8,0,0,0,0-1.6H27.46A8.44,8.44,0,0,0,19.57,4H11a1,1,0,0,0-1,1V9.2H7a.8.8,0,0,0,0,1.6h3v2.4H7a.8.8,0,0,0,0,1.6h3V31a1,1,0,0,0,2,0V20h7.57a8.45,8.45,0,0,0,7.89-5.2H31a.8.8,0,0,0,0-1.6ZM12,6h7.57a6.51,6.51,0,0,1,5.68,3.2H12Zm0,4.8H25.87a5.6,5.6,0,0,1,0,2.4H12ZM19.57,18H12V14.8H25.25A6.51,6.51,0,0,1,19.57,18Z"
              className="clr-i-outline clr-i-outline-path-1 h-4 w-4"
            ></path>
            <rect x="0" y="0" width="36" height="36" fill-opacity="0" />
          </svg>
        </CardHeader>
        <CardContent>
          <div className="text-2xl font-bold">
            ₱{formatNumberWithCommas(dashboardDatas.annual_income)}
          </div>
          <p className="text-xs text-muted-foreground">
            +20.1% from last month
          </p>
        </CardContent>
      </Card>

      <Card>
        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
          <CardTitle className="text-sm font-medium">Monthly Revenue</CardTitle>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeLinecap="round"
            strokeLinejoin="round"
            strokeWidth="2"
            className="h-4 w-4 text-muted-foreground"
          >
            <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
            <circle cx="9" cy="7" r="4" />
            <path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />
          </svg>
        </CardHeader>
        <CardContent>
          <div className="text-2xl font-bold">
            ₱{formatNumberWithCommas(dashboardDatas.monthly_income)}
          </div>
          <p className="text-xs text-muted-foreground">
            +180.1% from last month
          </p>
        </CardContent>
      </Card>

      <Card>
        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
          <CardTitle className="text-sm font-medium">
            Total Bookings Made
          </CardTitle>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeLinecap="round"
            strokeLinejoin="round"
            strokeWidth="2"
            className="h-4 w-4 text-muted-foreground"
          >
            <rect width="20" height="14" x="2" y="5" rx="2" />
            <path d="M2 10h20" />
          </svg>
        </CardHeader>
        <CardContent>
          <div className="text-2xl font-bold">
            {dashboardDatas.total_bookings}
          </div>
          <p className="text-xs text-muted-foreground">+19% from last month</p>
        </CardContent>
      </Card>

      <Card>
        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
          <CardTitle className="text-sm font-medium">Total Cars</CardTitle>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeLinecap="round"
            strokeLinejoin="round"
            strokeWidth="2"
            className="h-4 w-4 text-muted-foreground"
          >
            <path d="M22 12h-4l-3 9L9 3l-3 9H2" />
          </svg>
        </CardHeader>
        <CardContent>
          <div className="text-2xl font-bold">{dashboardDatas.total_cars}</div>
          <p className="text-xs text-muted-foreground">
            Cars under maintenance: {dashboardDatas.cars_under_maintenance}
          </p>
        </CardContent>
      </Card>
    </div>
  );
};
