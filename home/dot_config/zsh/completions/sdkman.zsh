# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
if [[ ! -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
  echo "sdkman not exist"
  return
else
  source $SDKMAN_DIR/bin/sdkman-init.sh
fi
