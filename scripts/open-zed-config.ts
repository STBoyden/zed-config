import open from "open@11.0.0";
import { homedir } from "node:os";

const main = async () => {
  const path = `${homedir()}/.config/zed`;
  console.log(`Opening ${path}...`);
  await open(path);
};

main();
