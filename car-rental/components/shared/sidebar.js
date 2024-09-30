"use client";
import React from "react";
import { Button } from "@/components/ui/button";
import {
  Moon,
  Sun,
  LayoutDashboard,
  ShoppingCart,
  Users,
  LogOutIcon,
} from "lucide-react";
import { useRouter } from "next/navigation";

export const Sidebar = ({ activeView, setActiveView, isSidebarOpen }) => {
  const router = useRouter(); // To redirect after logout
  const menuItems = [
    { icon: LayoutDashboard, label: "Dashboard", view: "dashboard" },
    { icon: Users, label: "Bookings", view: "bookings" },
    { icon: ShoppingCart, label: "Cars", view: "cars" },
    // { icon: Settings, label: "Settings", view: "settings" },
    { icon: LogOutIcon, label: "Log Out", view: "logout" },
  ];

  const handleLogout = () => {
    sessionStorage.removeItem("user"); 
    // Redirect to login page
    router.push("/");
  };

  return (
    <div
      className={`bg-white dark:bg-gray-800 h-full w-64 p-4 fixed top-0 left-0 z-10 transition-all duration-300 ease-in-out
      ${isSidebarOpen ? "translate-x-0" : "-translate-x-full"}
      md:translate-x-0 md:static md:block`}
    >
      <div className="text-2xl font-bold mb-6 text-gray-800 dark:text-white">
        Admin Panel
      </div>
      <nav>
        {menuItems.map((item) => (
          <Button
            key={item.label}
            variant={activeView === item.view ? "secondary" : "ghost"}
            className="w-full justify-start mb-2"
            onClick={() => {
              if (item.view === "logout") {
                handleLogout();
              } else {
                setActiveView(item.view);
              }
            }}
          >
            <item.icon className="mr-2 h-4 w-4" />
            {item.label}
          </Button>
        ))}
      </nav>
    </div>
  );
};
