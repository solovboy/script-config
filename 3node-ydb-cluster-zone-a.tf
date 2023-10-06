resource "ycp_compute_disk" "zone-a-ydb-storage-01" {
  size    = 186
  name    = "zone-a-ydb-storage-01"
  type_id = "network-ssd-nonreplicated"
  zone_id = "ru-central1-a"
}

resource "ycp_compute_disk" "zone-a-ydb-storage-02" {
  size    = 186
  name    = "zone-a-ydb-storage-02"
  type_id = "network-ssd-nonreplicated"
  zone_id = "ru-central1-a"
}

resource "ycp_compute_disk" "zone-a-ydb-storage-03" {
  size    = 186
  name    = "zone-a-ydb-storage-03"
  type_id = "network-ssd-nonreplicated"
  zone_id = "ru-central1-a"
}


resource "ycp_compute_instance" "ydb-node-zone-a" {
  name        = "ydb-node-zone-a"
  hostname    = "ydb-node-zone-a"
  fqdn        = "ydb-node-zone-a.ydb.internal"
  description = "INFRAMARKETING-235"
  zone_id     = "ru-central1-a"
  platform_id = "standard-v2"
  resources {
    cores  = 16
    memory = 32
  }

  boot_disk {
    disk_spec {
      image_id = "fd803574efskf64jq17g"
      size     = 50
    }
  }

  secondary_disk {
    disk_id     = ycp_compute_disk.zone-a-ydb-storage-01.id
    device_name = "ydb-storage-01"
    auto_delete = true
  }
  secondary_disk {
    auto_delete = true
    device_name = "ydb-storage-02"
    disk_id     = ycp_compute_disk.zone-a-ydb-storage-02.id
  }
  secondary_disk {
    auto_delete = true
    device_name = "ydb-storage-03"
    disk_id     = ycp_compute_disk.zone-a-ydb-storage-03.id
  }

  network_interface {
    subnet_id = "e9b3498hclq3300fsb7k"
    primary_v4_address {

    }
  }
  metadata = {
    user-data          = "${file("metadata.txt")}"
    serial-port-enable = 1
    # ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

}
