resource "google_compute_instance" "vm" {
  count = 8
  project = "mdifilippo-terraform-demo"
  name = "testing-${count.index}"
  # machine_type = "n2-custom-2-4096"
  machine_type = "e2-standard-2"

  zone = "us-east4-a"

  metadata = {
    "startup-script" = <<END_HEREDOC
echo "TESTING!!!"
sudo apt-get update
sudo apt-get install -y htop zip unzip openjdk-17-jdk wget git tmux
echo "Done!"

echo "Downloading MC Server!"
mkdir -p /home/marc/minecraft-server/
wget https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar -O /home/marc/minecraft-server/Server.jar
echo "echo \"eula=true\" > /home/marc/minecraft-server/eula.txt && cd /home/marc/minecraft-server/ && java -Xmx4096M -jar Server.jar nogui" > /home/marc/start.sh
echo "sudo -u marc tmux new -s mc-server -d sh /home/marc/start.sh" > /home/marc/launch.sh
chmod +x /home/marc/start.sh
chmod +x /home/marc/launch.sh
chmod 755 -R /home/marc/
chown marc:marc -R /home/marc/
echo "Downloaded MC Server!"

echo "Launching MC Server!"
/home/marc/launch.sh
echo "Finished launching MC Server!"
END_HEREDOC
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {
      
    }
  }
}

resource "google_compute_firewall" "firewall_allow_mc_traffic" {
  project = "mdifilippo-terraform-demo"
  name    = "allow-mc-traffic"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["25565"]
  }
}
