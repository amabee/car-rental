import {
  Moon,
  Sun,
  LayoutDashboard,
  ShoppingCart,
  Menu,
  Users,
  Settings,
} from "lucide-react";
import { Button } from "../ui/button";
export const Sidebar = ({ activeView, setActiveView }) => {
  const menuItems = [
    { icon: LayoutDashboard, label: "Dashboard", view: "dashboard" },
    { icon: Users, label: "Users", view: "users" },
    { icon: ShoppingCart, label: "Cars", view: "cars" },
    { icon: Settings, label: "Settings", view: "settings" },
  ];

  return (
    <div className="bg-white dark:bg-gray-800 h-full w-64 p-4 hidden md:block">
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
