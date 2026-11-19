import fs from 'fs';
import path from 'path';
import {defineConfig} from 'vite';

const htmlPages = [
  'index.html',
  'products.html',
  'product-detail.html',
  'cart.html',
  'account.html',
  'admin-dashboard.html',
  'admin-products.html',
  'admin-add-product.html',
  'admin-orders.html',
  'admin-customers.html',
];

export default defineConfig(() => {
  const input: Record<string, string> = {};
  for (const page of htmlPages) {
    const key = page.replace('.html', '');
    input[key] = path.resolve(__dirname, page);
  }

  return {
    build: {
      rollupOptions: {
        input,
      },
    },
    plugins: [
      {
        name: 'copy-static-store-assets',
        apply: 'build',
        closeBundle(error?: Error): void {
          if (error) {
            return;
          }
          const distDir = path.resolve(__dirname, 'dist');
          const foldersToCopy = ['src/assets', 'css', 'js'];
          for (const folder of foldersToCopy) {
            const srcPath = path.resolve(__dirname, folder);
            const destPath = path.resolve(distDir, folder);
            if (fs.existsSync(distDir) && fs.existsSync(srcPath)) {
              fs.cpSync(srcPath, destPath, {recursive: true, force: true});
            }
          }
        },
      },
    ],
    resolve: {
      alias: {
        '@': path.resolve(__dirname, '.'),
      },
    },
    server: {
      hmr: process.env.DISABLE_HMR !== 'true',
      watch: process.env.DISABLE_HMR === 'true' ? null : {},
    },
  };
});
