const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

// Function to recursively get all files in a directory
function getAllFiles(dirPath, arrayOfFiles) {
  const files = fs.readdirSync(dirPath);
  
  arrayOfFiles = arrayOfFiles || [];
  
  files.forEach((file) => {
    const filePath = path.join(dirPath, file);
    if (fs.statSync(filePath).isDirectory()) {
      arrayOfFiles = getAllFiles(filePath, arrayOfFiles);
    } else {
      arrayOfFiles.push(filePath);
    }
  });
  
  return arrayOfFiles;
}

// Function to compress a file using gzip
function compressFile(filePath) {
  const fileContent = fs.readFileSync(filePath);
  const compressedContent = zlib.gzipSync(fileContent);
  const compressedFilePath = filePath + '.gz';
  fs.writeFileSync(compressedFilePath, compressedContent);
  console.log(`Compressed: ${filePath} -> ${compressedFilePath}`);
}

// Function to determine if a file should be compressed
function shouldCompress(filePath) {
  const compressibleExtensions = [
    '.js', '.css', '.html', '.json', '.xml', '.svg', '.txt', '.map'
  ];
  
  const ext = path.extname(filePath).toLowerCase();
  return compressibleExtensions.includes(ext);
}

// Main function
function compressAssets() {
  const buildDir = path.join(__dirname, '..', 'build', 'web');
  
  if (!fs.existsSync(buildDir)) {
    console.error('Build directory not found. Please run "flutter build web" first.');
    process.exit(1);
  }
  
  console.log('Starting asset compression...');
  
  const files = getAllFiles(buildDir);
  
  let compressedCount = 0;
  
  files.forEach((file) => {
    if (shouldCompress(file)) {
      try {
        compressFile(file);
        compressedCount++;
      } catch (error) {
        console.error(`Error compressing ${file}:`, error.message);
      }
    }
  });
  
  console.log(`Compression complete. Compressed ${compressedCount} files.`);
}

// Run the compression
compressAssets();