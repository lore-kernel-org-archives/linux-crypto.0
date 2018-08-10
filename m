From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [PATCH net-next 1/2] virtio: Make vp_set_vq_affinity() take a
 mask.
Date: Fri, 10 Aug 2018 01:38:37 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020DB07C01C@dggeml511-mbx.china.huawei.com>
References: <20180810011828.199888-1-caleb.raitto@gmail.com>
 <20180810011828.199888-2-caleb.raitto@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "jasowang@redhat.com" <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Caleb Raitto <caraitto@google.com>
To: Caleb Raitto <caleb.raitto@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "mst@redhat.com" <mst@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180810011828.199888-2-caleb.raitto@gmail.com>
Content-Language: zh-CN
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org
> [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Caleb Raitto
> Sent: Friday, August 10, 2018 9:18 AM
> To: herbert@gondor.apana.org.au; mst@redhat.com; davem@davemloft.net
> Cc: Gonglei (Arei) <arei.gonglei@huawei.com>; jasowang@redhat.com;
> netdev@vger.kernel.org; linux-crypto@vger.kernel.org; Caleb Raitto
> <caraitto@google.com>
> Subject: [PATCH net-next 1/2] virtio: Make vp_set_vq_affinity() take a mask.
> 
> From: Caleb Raitto <caraitto@google.com>
> 
> Make vp_set_vq_affinity() take a cpumask instead of taking a single CPU.
> 
> If there are fewer queues than cores, queue affinity should be able to
> map to multiple cores.
> 
> Link: https://patchwork.ozlabs.org/patch/948149/
> Suggested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Caleb Raitto <caraitto@google.com>
> ---
>  drivers/crypto/virtio/virtio_crypto_core.c | 4 ++--
>  drivers/net/virtio_net.c                   | 8 ++++----
>  drivers/virtio/virtio_pci_common.c         | 7 +++----
>  drivers/virtio/virtio_pci_common.h         | 2 +-
>  include/linux/virtio_config.h              | 7 ++++---
>  5 files changed, 14 insertions(+), 14 deletions(-)
> 

Acked-by: Gonglei <arei.gonglei@huawei.com>
