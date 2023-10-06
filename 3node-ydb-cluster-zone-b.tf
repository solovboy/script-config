resource "ycp_compute_disk" "zone-b-ydb-storage-01" {
  size    = 186
  name    = "zone-b-ydb-storage-01"
  type_id = "network-ssd-nonreplicated"
  zone_id = "ru-central1-b"
}

resource "ycp_compute_disk" "zone-b-ydb-storage-02" {
  size    = 186
  name    = "zone-b-ydb-storage-02"
  type_id = "network-ssd-nonreplicated"
  zone_id = "ru-central1-b"
}

resource "ycp_compute_disk" "zone-b-ydb-storage-03" {
  size    = 186
  name    = "zone-b-ydb-storage-03"
  type_id = "network-ssd-nonreplicated"
  zone_id = "ru-central1-b"
}


resource "ycp_compute_instance" "ydb-node-zone-b" {
  name        = "ydb-node-zone-b"
  hostname    = "ydb-node-zone-b"
  fqdn        = "ydb-node-zone-b.ydb.internal"
  description = "INFRAMARKETING-235"
  zone_id     = "ru-central1-b"
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
    disk_id     = ycp_compute_disk.zone-b-ydb-storage-01.id
    device_name = "ydb-storage-01"
    auto_delete = true
  }
  secondary_disk {
    auto_delete = true
    device_name = "ydb-storage-02"
    disk_id     = ycp_compute_disk.zone-b-ydb-storage-02.id
  }
  secondary_disk {
    auto_delete = true
    device_name = "ydb-storage-03"
    disk_id     = ycp_compute_disk.zone-b-ydb-storage-03.id
  }

  network_interface {
    subnet_id = "e2l3lku4nssgfc05op9e"
    primary_v4_address {

    }
  }
  metadata = {
    user-data          = "${file("metadata.txt")}"
    serial-port-enable = 1
    # ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

}
