"use client";
import React, { useState } from "react";
import { Button } from "@/components/ui/button";
import {
  Moon,
  Sun,
  LayoutDashboard,
  ShoppingCart,
  Menu,
  Users,
  Settings,
} from "lucide-react";
export const Sidebar = ({ activeView, setActiveView, isSidebarOpen }) => {
  const menuItems = [
    { icon: LayoutDashboard, label: "Dashboard", view: "dashboard" },
    { icon: Users, label: "Bookings", view: "bookings" },
    { icon: ShoppingCart, label: "Cars", view: "cars" },
    { icon: Settings, label: "Settings", view: "settings" },
  ];

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
            key={item.view}
            variant={activeView === item.view ? "secondary" : "ghost"}
            className="w-full justify-start mb-2"
            onClick={() => setActiveView(item.view)}
          >
            <item.icon className="mr-2 h-4 w-4" />
            {item.label}
          </Button>
        ))}
      </nav>
    </div>
  );
};
