import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  /* config options here */
  eslint: {
    ignoreDuringBuilds: true, // ✅ This skips linting during build
  },
  output: "standalone",
};

export default nextConfig;
