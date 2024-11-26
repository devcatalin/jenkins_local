#!/bin/bash
set -e

# Function to install plugins from a directory
install_plugins_from_dir() {
    local plugin_dir=$1
    
    echo "================================================================"
    echo "                 STARTING CUSTOM PLUGIN INSTALLATION              "
    echo "================================================================"
    echo "Looking for plugins in: $plugin_dir"
    echo "Timestamp: $(date)"
    echo "----------------------------------------------------------------"
    
    if [ -d "$plugin_dir" ] && [ "$(ls -A $plugin_dir)" ]; then
        echo "Installing plugins from $plugin_dir"
        
        # Create plugins directory if it doesn't exist
        mkdir -p "$JENKINS_HOME/plugins"
        
        # Find all .hpi and .jpi files and copy them directly
        find "$plugin_dir" -type f \( -name "*.hpi" -o -name "*.jpi" \) | while read plugin_file; do
            plugin_name=$(basename "$plugin_file")
            echo "----------------------------------------------------------------"
            echo "Installing plugin: $plugin_name"
            cp "$plugin_file" "$JENKINS_HOME/plugins/"
            chmod 644 "$JENKINS_HOME/plugins/$plugin_name"
            echo "Plugin $plugin_name installed successfully"
        done
        
        # Ensure correct permissions
        chown -R jenkins:jenkins "$JENKINS_HOME/plugins"
    else
        echo "Plugin directory $plugin_dir is empty or doesn't exist"
    fi
    
    echo "================================================================"
    echo "                 FINISHED CUSTOM PLUGIN INSTALLATION              "  
    echo "                 Timestamp: $(date)"
    echo "================================================================"
}

# Set correct permissions
chown -R jenkins:jenkins /var/jenkins_home/pipelines /var/jenkins_home/init.groovy.d

# Install any plugins from init_plugins before starting Jenkins
if [ -d "/var/jenkins_home/init_plugins" ]; then
    install_plugins_from_dir "/var/jenkins_home/init_plugins"
fi

# Call the original Jenkins entrypoint
exec /usr/local/bin/jenkins.sh "$@"
