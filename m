From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 net-next 0/2] virtio_net: Expand affinity to arbitrary
 numbers of cpu and vq
Date: Sun, 12 Aug 2018 11:44:53 +0300
Message-ID: <20180812114424-mutt-send-email-mst@kernel.org>
References: <20180810011828.199888-1-caleb.raitto@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        arei.gonglei@huawei.com, jasowang@redhat.com,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        Caleb Raitto <caraitto@google.com>
To: Caleb Raitto <caleb.raitto@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180810011828.199888-1-caleb.raitto@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 09, 2018 at 06:18:27PM -0700, Caleb Raitto wrote:
> From: Caleb Raitto <caraitto@google.com>
> 
> Virtio-net tries to pin each virtual queue rx and tx interrupt to a cpu if
> there are as many queues as cpus.
> 
> Expand this heuristic to configure a reasonable affinity setting also
> when the number of cpus != the number of virtual queues.
> 
> Patch 1 allows vqs to take an affinity mask with more than 1 cpu.
> Patch 2 generalizes the algorithm in virtnet_set_affinity beyond
> the case where #cpus == #vqs.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

Let's see where does it take us.

> v2 changes:
> Renamed "virtio_net: Make vp_set_vq_affinity() take a mask." to
> "virtio: Make vp_set_vq_affinity() take a mask."
> 
> Tested:
> 
> # 16 vCPU, 16 queue pairs, Debian 9 recent net-next kernel, GCE
> 
> # Disable GCE scripts setting affinities during startup.
> #
> # Add the following to
> # /etc/default/instance_configs.cfg.template and reboot:
> [InstanceSetup]
> set_multiqueue = false
> 
> $ cd /proc/irq
> $ for i in `seq 24 60` ; do sudo grep ".*" $i/smp_affinity_list;  done
> 0-15
> 0
> 0
> 1
> 1
> 2
> 2
> 3
> 3
> 4
> 4
> 5
> 5
> 6
> 6
> 7
> 7
> 8
> 8
> 9
> 9
> 10
> 10
> 11
> 11
> 12
> 12
> 13
> 13
> 14
> 14
> 15
> 15
> 0-15
> 0-15
> 0-15
> 0-15
> 
> $ cd /sys/class/net/eth0/queues/
> $ for i in `seq 0 15` ; do sudo grep ".*" tx-$i/xps_cpus; done
> 0001
> 0002
> 0004
> 0008
> 0010
> 0020
> 0040
> 0080
> 0100
> 0200
> 0400
> 0800
> 1000
> 2000
> 4000
> 8000
> 
> # 16 vCPU, 15 queue pairs
> $ sudo ethtool -L eth0 combined 15
> 
> $ cd /proc/irq
> $ for i in `seq 24 60` ; do sudo grep ".*" $i/smp_affinity_list;  done
> 0-15
> 0-1
> 0-1
> 2
> 2
> 3
> 3
> 4
> 4
> 5
> 5
> 6
> 6
> 7
> 7
> 8
> 8
> 9
> 9
> 10
> 10
> 11
> 11
> 12
> 12
> 13
> 13
> 14
> 14
> 15
> 15
> 15
> 15
> 0-15
> 0-15
> 0-15
> 0-15
> 
> $ cd /sys/class/net/eth0/queues/
> $ for i in `seq 0 14` ; do sudo grep ".*" tx-$i/xps_cpus; done
> 0003
> 0004
> 0008
> 0010
> 0020
> 0040
> 0080
> 0100
> 0200
> 0400
> 0800
> 1000
> 2000
> 4000
> 8000
> 
> # 16 vCPU, 8 queue pairs
> $ sudo ethtool -L eth0 combined 8
> 
> $ cd /proc/irq
> $ for i in `seq 24 60` ; do sudo grep ".*" $i/smp_affinity_list;  done
> 0-15
> 0-1
> 0-1
> 2-3
> 2-3
> 4-5
> 4-5
> 6-7
> 6-7
> 8-9
> 8-9
> 10-11
> 10-11
> 12-13
> 12-13
> 14-15
> 14-15
> 9
> 9
> 10
> 10
> 11
> 11
> 12
> 12
> 13
> 13
> 14
> 14
> 15
> 15
> 15
> 15
> 0-15
> 0-15
> 0-15
> 0-15
> 
> $ cd /sys/class/net/eth0/queues/
> $ for i in `seq 0 7` ; do sudo grep ".*" tx-$i/xps_cpus; done
> 0003
> 000c
> 0030
> 00c0
> 0300
> 0c00
> 3000
> c000
> 
> # 15 vCPU, 16 queue pairs
> $ sudo ethtool -L eth0 combined 16
> $ sudo sh -c "echo 0 > /sys/devices/system/cpu/cpu15/online"
> 
> $ cd /proc/irq
> $ for i in `seq 24 60` ; do sudo grep ".*" $i/smp_affinity_list;  done
> 0-15
> 0
> 0
> 1
> 1
> 2
> 2
> 3
> 3
> 4
> 4
> 5
> 5
> 6
> 6
> 7
> 7
> 8
> 8
> 9
> 9
> 10
> 10
> 11
> 11
> 12
> 12
> 13
> 13
> 14
> 14
> 0
> 0
> 0-15
> 0-15
> 0-15
> 0-15
> 
> $ cd /sys/class/net/eth0/queues/
> $ for i in `seq 0 15` ; do sudo grep ".*" tx-$i/xps_cpus; done
> 0001
> 0002
> 0004
> 0008
> 0010
> 0020
> 0040
> 0080
> 0100
> 0200
> 0400
> 0800
> 1000
> 2000
> 4000
> 0001
> 
> # 8 vCPU, 16 queue pairs
> $ for i in `seq 8 15`; \
> do sudo sh -c "echo 0 > /sys/devices/system/cpu/cpu$i/online"; done
> 
> $ cd /proc/irq
> $ for i in `seq 24 60` ; do sudo grep ".*" $i/smp_affinity_list;  done
> 0-15
> 0
> 0
> 1
> 1
> 2
> 2
> 3
> 3
> 4
> 4
> 5
> 5
> 6
> 6
> 7
> 7
> 0
> 0
> 1
> 1
> 2
> 2
> 3
> 3
> 4
> 4
> 5
> 5
> 6
> 6
> 7
> 7
> 0-15
> 0-15
> 0-15
> 0-15
> 
> $ cd /sys/class/net/eth0/queues/
> $ for i in `seq 0 15` ; do sudo grep ".*" tx-$i/xps_cpus; done
> 0001
> 0002
> 0004
> 0008
> 0010
> 0020
> 0040
> 0080
> 0001
> 0002
> 0004
> 0008
> 0010
> 0020
> 0040
> 0080
> 
> Caleb Raitto (2):
>   virtio: Make vp_set_vq_affinity() take a mask.
>   virtio_net: Stripe queue affinities across cores.
> 
>  drivers/crypto/virtio/virtio_crypto_core.c |  4 +-
>  drivers/net/virtio_net.c                   | 46 ++++++++++++++--------
>  drivers/virtio/virtio_pci_common.c         |  7 ++--
>  drivers/virtio/virtio_pci_common.h         |  2 +-
>  include/linux/virtio_config.h              |  7 ++--
>  5 files changed, 39 insertions(+), 27 deletions(-)
> 
> -- 
> 2.18.0.597.ga71716f1ad-goog
