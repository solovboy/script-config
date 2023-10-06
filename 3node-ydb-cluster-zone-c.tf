resource "ycp_compute_disk" "zone-c-ydb-storage-01" {
  size    = 186
  name    = "ydb-storage-01"
  type_id = "network-ssd-nonreplicated"
  zone_id = "ru-central1-c"
}

resource "ycp_compute_disk" "zone-c-ydb-storage-02" {
  size    = 186
  name    = "zone-cydb-storage-02"
  type_id = "network-ssd-nonreplicated"
  zone_id = "ru-central1-c"
}

resource "ycp_compute_disk" "zone-c-ydb-storage-03" {
  size    = 186
  name    = "zone-cydb-storage-03"
  type_id = "network-ssd-nonreplicated"
  zone_id = "ru-central1-c"
}


resource "ycp_compute_instance" "ydb-node-zone-c" {
  name        = "ydb-node-zone-c"
  hostname    = "ydb-node-zone-c"
  fqdn        = "ydb-node-zone-c.ydb.internal"
  description = "INFRAMARKETING-235"
  zone_id     = "ru-central1-c"
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
    disk_id     = ycp_compute_disk.zone-c-ydb-storage-01.id
    device_name = "ydb-storage-01"
    auto_delete = true
  }
  secondary_disk {
    auto_delete = true
    device_name = "ydb-storage-02"
    disk_id     = ycp_compute_disk.zone-c-ydb-storage-02.id
  }
  secondary_disk {
    auto_delete = true
    device_name = "ydb-storage-03"
    disk_id     = ycp_compute_disk.zone-c-ydb-storage-03.id
  }

  network_interface {
    subnet_id = "b0crk5i30gohutpi4968"
    primary_v4_address {

    }
  }
  metadata = {
    user-data          = "${file("metadata.txt")}"
    serial-port-enable = 1
    # ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

}
