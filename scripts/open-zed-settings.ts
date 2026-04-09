import { $ } from "bun";
import { homedir } from "node:os";

const main = async () => {
  const path = `${homedir()}/.config/zed`;
  console.log(`Opening ${path}...`);

  await $`zed ${path}`;
};

main().then(
  () => {},
  (error) => {
    console.error(`Could not open Zed settings: ${error}`);
  },
);
