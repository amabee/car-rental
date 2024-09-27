import localFont from "next/font/local";
import "./globals.css";
import { ThemeProvider } from "next-themes";
export const metadata = {
  title: "Anster Car Rental",
  description: "Car Rental App",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className={`antialiased`}>
        <ThemeProvider attribute="class" defaultTheme="light">
          {children}
        </ThemeProvider>
      </body>
    </html>
  );
}
