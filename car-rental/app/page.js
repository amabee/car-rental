"use client";

import React, { useState, useEffect } from "react";
import { useTheme } from "next-themes";
import { Moon, Sun } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent } from "@/components/ui/card";
import { Switch } from "@/components/ui/switch";
import axios from "axios";

const LoginPage = () => {
  const url = "http://localhost/car-rental_api/admin/auth.php";
  const [mounted, setMounted] = useState(false);
  const { theme, setTheme } = useTheme();
  const [userName, setUserName] = useState("");
  const [password, setPassword] = useState("");
  //#region DESIGN RELATED
  useEffect(() => {
    setMounted(true);
  }, []);

  const toggleTheme = () => {
    setTheme(theme === "dark" ? "light" : "dark");
  };

  if (!mounted) {
    return null;
  }
  //#endregion

  const handleLogin = async () => {
    try {
      const res = await axios.get(url, {
        params: {
          operation: "login",
          json: JSON.stringify({
            username: userName,
            password: password,
          }),
        },
      });

      console.log(res);

      if (res.status !== 200) {
        return alert("Connection Error");
      }

      if (res.data.success) {
        sessionStorage.setItem("user", JSON.stringify(res.data.success));
        window.location.href = "/Dashboard";
      } else {
        return alert(res.data.error);
      }
    } catch (e) {}
  };

  return (
    <div className="min-h-screen flex bg-gray-100 dark:bg-gray-900 p-6">
      <div className="w-full max-w-xl m-auto">
        <div className="flex items-center justify-between mb-12">
          <div className="flex items-center">
            <svg
              className="w-12 h-12 mr-4 text-blue-600"
              viewBox="0 0 24 24"
              fill="currentColor"
            >
              <path d="M3 3h18v18H3V3zm16 16V5H5v14h14zm-3-3H8v-2h8v2zm0-4H8v-2h8v2zm0-4H8V6h8v2z" />
            </svg>
            <span className="text-3xl font-bold text-blue-600">
              Anster Car Rental
            </span>
          </div>
          <div className="flex items-center space-x-3">
            <Sun className="h-6 w-6" />
            <Switch
              checked={theme === "dark"}
              onCheckedChange={toggleTheme}
              className="scale-125"
            />
            <Moon className="h-6 w-6" />
          </div>
        </div>
        <Card className="w-full bg-white dark:bg-gray-800 shadow-xl">
          <CardContent className="p-10">
            <h2 className="text-4xl font-bold mb-8 text-gray-800 dark:text-white">
              Welcome back
            </h2>
            <form className="space-y-6">
              <div>
                <Input
                  id="text"
                  placeholder="Username"
                  type="text"
                  className="w-full text-lg py-3 h-12"
                  value={userName}
                  onChange={(e) => setUserName(e.target.value)}
                />
              </div>
              <div>
                <Input
                  id="password"
                  placeholder="Password"
                  type="password"
                  className="w-full text-lg py-3 h-12"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                />
              </div>
              <div className="flex items-center justify-end">
                {/* <div className="text-base">
                  <a
                    href="#"
                    className="font-medium text-blue-600 hover:text-blue-500"
                  >
                    Forgot password?
                  </a>
                </div> */}
              </div>
              <Button
                className="w-full bg-blue-600 hover:bg-blue-700 text-white text-lg py-6"
                onClick={() => handleLogin()}
              >
                Sign in
              </Button>
            </form>

            {/* <div className="mt-8 text-center text-base text-gray-600 dark:text-gray-400">
              Don't have an account?{" "}
              <a
                href="#"
                className="font-medium text-blue-600 hover:text-blue-500"
              >
                Sign up
              </a>
            </div> */}
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default LoginPage;
