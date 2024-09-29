"use client";

import React, { useEffect, useState } from "react";
import { useTheme } from "next-themes";
import { Moon, Sun, Menu } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Switch } from "@/components/ui/switch";
import { Sidebar } from "@/components/shared/sidebar";
import { Dashboard } from "@/components/shared/dashboard";
import { Cars } from "@/components/shared/cars";
import { Settings } from "@/components/shared/settings";
import { BookingComponent } from "@/components/shared/bookings";
import "../../public/styles/styles.css";

const AdminDashboard = () => {
  const [activeView, setActiveView] = useState("dashboard");
  const { theme, setTheme } = useTheme();
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [currentSession, setCurrentSession] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const timer = setTimeout(() => {
      const getSession = sessionStorage.getItem("user");
      if (getSession === null) {
        window.location.href = "/";
        return;
      }

      const parsedSession = JSON.parse(getSession);
      setCurrentSession(parsedSession);
      setLoading(false);
    }, 2000); // Simulate a 2-second delay

    return () => clearTimeout(timer); // Cleanup timer on unmount
  }, []);

  const renderView = () => {
    switch (activeView) {
      case "dashboard":
        return <Dashboard />;
      case "bookings":
        return <BookingComponent />;
      case "cars":
        return <Cars />;
      case "settings":
        return <Settings />;
      default:
        return <Dashboard />;
    }
  };

  if (loading) {
    return (
      <div className="flex flex-col items-center justify-center h-screen bg-gray-100 dark:bg-gray-900">
        <h3 className="text-3xl font-bold text-gray-800 dark:text-white">
          Loading
        </h3>
        <div className="loader mt-3"></div>
      </div>
    );
  }

  return (
    <div className="flex h-screen bg-gray-100 dark:bg-gray-900">
      <div
        className={`md:hidden fixed inset-y-0 left-0 z-50 w-64 bg-white dark:bg-gray-800 transform ${
          isSidebarOpen ? "translate-x-0" : "-translate-x-full"
        } transition-transform duration-300 ease-in-out`}
      >
        <Sidebar
          activeView={activeView}
          setActiveView={setActiveView}
          isSidebarOpen={isSidebarOpen}
        />
      </div>

      <div className="hidden md:block">
        <Sidebar
          activeView={activeView}
          setActiveView={setActiveView}
          isSidebarOpen={isSidebarOpen}
        />
      </div>

      <div className="flex-1 flex flex-col overflow-hidden">
        <header className="bg-white dark:bg-gray-800 shadow-sm">
          <div className="max-w-7xl mx-auto py-4 px-4 sm:px-6 lg:px-8">
            <div className="flex items-center justify-between">
              <h2 className="font-semibold text-xl text-gray-800 dark:text-white leading-tight">
                {activeView.charAt(0).toUpperCase() + activeView.slice(1)}
              </h2>
              <div className="flex items-center">
                <Button
                  variant="ghost"
                  size="icon"
                  className="md:hidden mr-2"
                  onClick={() => setIsSidebarOpen(!isSidebarOpen)}
                >
                  <Menu className="h-6 w-6" />
                </Button>
                <div className="flex items-center space-x-2">
                  <Sun className="h-6 w-6" />
                  <Switch
                    checked={theme === "dark"}
                    onCheckedChange={() =>
                      setTheme(theme === "dark" ? "light" : "dark")
                    }
                  />
                  <Moon className="h-6 w-6" />
                </div>
              </div>
            </div>
          </div>
        </header>
        <main className="flex-1 overflow-x-hidden overflow-y-auto bg-gray-100 dark:bg-gray-900">
          <div className="container mx-auto px-6 py-8">{renderView()}</div>
        </main>
      </div>
    </div>
  );
};

export default AdminDashboard;
