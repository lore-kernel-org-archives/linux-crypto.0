From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [PATCH net-next 1/2] virtio_net: Make vp_set_vq_affinity() take
 a mask.
Date: Fri, 10 Aug 2018 00:48:18 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020DB07BF77@dggeml511-mbx.china.huawei.com>
References: <20180810002840.186635-1-caleb.raitto@gmail.com>
 <20180810002840.186635-2-caleb.raitto@gmail.com>
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
In-Reply-To: <20180810002840.186635-2-caleb.raitto@gmail.com>
Content-Language: zh-CN
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



> -----Original Message-----
> From: Caleb Raitto [mailto:caleb.raitto@gmail.com]
> Sent: Friday, August 10, 2018 8:29 AM
> To: herbert@gondor.apana.org.au; mst@redhat.com; davem@davemloft.net
> Cc: Gonglei (Arei) <arei.gonglei@huawei.com>; jasowang@redhat.com;
> netdev@vger.kernel.org; linux-crypto@vger.kernel.org; Caleb Raitto
> <caraitto@google.com>
> Subject: [PATCH net-next 1/2] virtio_net: Make vp_set_vq_affinity() take a
> mask.
> 
> From: Caleb Raitto <caraitto@google.com>
> 
> Make vp_set_vq_affinity() take a cpumask instead of taking a single CPU.
> 
> If there are fewer queues than cores, queue affinity should be able to
> map to multiple cores.
> 

Nice work. Maybe you'd better rename this patch's header

s/virtio_net/virtio/ ?

Except that:

Acked-by: Gongle <arei.gonglei@huawei.com>


Regards,
-Gonglei

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
> diff --git a/drivers/crypto/virtio/virtio_crypto_core.c
> b/drivers/crypto/virtio/virtio_crypto_core.c
> index 83326986c113..7c7198553699 100644
> --- a/drivers/crypto/virtio/virtio_crypto_core.c
> +++ b/drivers/crypto/virtio/virtio_crypto_core.c
> @@ -146,7 +146,7 @@ static void virtcrypto_clean_affinity(struct
> virtio_crypto *vi, long hcpu)
> 
>  	if (vi->affinity_hint_set) {
>  		for (i = 0; i < vi->max_data_queues; i++)
> -			virtqueue_set_affinity(vi->data_vq[i].vq, -1);
> +			virtqueue_set_affinity(vi->data_vq[i].vq, NULL);
> 
>  		vi->affinity_hint_set = false;
>  	}
> @@ -173,7 +173,7 @@ static void virtcrypto_set_affinity(struct virtio_crypto
> *vcrypto)
>  	 *
>  	 */
>  	for_each_online_cpu(cpu) {
> -		virtqueue_set_affinity(vcrypto->data_vq[i].vq, cpu);
> +		virtqueue_set_affinity(vcrypto->data_vq[i].vq, cpumask_of(cpu));
>  		if (++i >= vcrypto->max_data_queues)
>  			break;
>  	}
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 39a7f4452587..43fabc0eb4d2 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1878,8 +1878,8 @@ static void virtnet_clean_affinity(struct virtnet_info
> *vi, long hcpu)
> 
>  	if (vi->affinity_hint_set) {
>  		for (i = 0; i < vi->max_queue_pairs; i++) {
> -			virtqueue_set_affinity(vi->rq[i].vq, -1);
> -			virtqueue_set_affinity(vi->sq[i].vq, -1);
> +			virtqueue_set_affinity(vi->rq[i].vq, NULL);
> +			virtqueue_set_affinity(vi->sq[i].vq, NULL);
>  		}
> 
>  		vi->affinity_hint_set = false;
> @@ -1905,8 +1905,8 @@ static void virtnet_set_affinity(struct virtnet_info
> *vi)
>  	for_each_online_cpu(cpu) {
>  		const unsigned long *mask = cpumask_bits(cpumask_of(cpu));
> 
> -		virtqueue_set_affinity(vi->rq[i].vq, cpu);
> -		virtqueue_set_affinity(vi->sq[i].vq, cpu);
> +		virtqueue_set_affinity(vi->rq[i].vq, cpumask_of(cpu));
> +		virtqueue_set_affinity(vi->sq[i].vq, cpumask_of(cpu));
>  		__netif_set_xps_queue(vi->dev, mask, i, false);
>  		i++;
>  	}
> diff --git a/drivers/virtio/virtio_pci_common.c
> b/drivers/virtio/virtio_pci_common.c
> index 705aebd74e56..465a6f5142cc 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -421,7 +421,7 @@ const char *vp_bus_name(struct virtio_device *vdev)
>   * - OR over all affinities for shared MSI
>   * - ignore the affinity request if we're using INTX
>   */
> -int vp_set_vq_affinity(struct virtqueue *vq, int cpu)
> +int vp_set_vq_affinity(struct virtqueue *vq, const struct cpumask *cpu_mask)
>  {
>  	struct virtio_device *vdev = vq->vdev;
>  	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> @@ -435,11 +435,10 @@ int vp_set_vq_affinity(struct virtqueue *vq, int cpu)
>  	if (vp_dev->msix_enabled) {
>  		mask = vp_dev->msix_affinity_masks[info->msix_vector];
>  		irq = pci_irq_vector(vp_dev->pci_dev, info->msix_vector);
> -		if (cpu == -1)
> +		if (!cpu_mask)
>  			irq_set_affinity_hint(irq, NULL);
>  		else {
> -			cpumask_clear(mask);
> -			cpumask_set_cpu(cpu, mask);
> +			cpumask_copy(mask, cpu_mask);
>  			irq_set_affinity_hint(irq, mask);
>  		}
>  	}
> diff --git a/drivers/virtio/virtio_pci_common.h
> b/drivers/virtio/virtio_pci_common.h
> index 135ee3cf7175..02271002c2f3 100644
> --- a/drivers/virtio/virtio_pci_common.h
> +++ b/drivers/virtio/virtio_pci_common.h
> @@ -141,7 +141,7 @@ const char *vp_bus_name(struct virtio_device *vdev);
>   * - OR over all affinities for shared MSI
>   * - ignore the affinity request if we're using INTX
>   */
> -int vp_set_vq_affinity(struct virtqueue *vq, int cpu);
> +int vp_set_vq_affinity(struct virtqueue *vq, const struct cpumask
> *cpu_mask);
> 
>  const struct cpumask *vp_get_vq_affinity(struct virtio_device *vdev, int
> index);
> 
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index 5559a2d31c46..32baf8e26735 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -79,7 +79,8 @@ struct virtio_config_ops {
>  	u64 (*get_features)(struct virtio_device *vdev);
>  	int (*finalize_features)(struct virtio_device *vdev);
>  	const char *(*bus_name)(struct virtio_device *vdev);
> -	int (*set_vq_affinity)(struct virtqueue *vq, int cpu);
> +	int (*set_vq_affinity)(struct virtqueue *vq,
> +			       const struct cpumask *cpu_mask);
>  	const struct cpumask *(*get_vq_affinity)(struct virtio_device *vdev,
>  			int index);
>  };
> @@ -236,11 +237,11 @@ const char *virtio_bus_name(struct virtio_device
> *vdev)
>   *
>   */
>  static inline
> -int virtqueue_set_affinity(struct virtqueue *vq, int cpu)
> +int virtqueue_set_affinity(struct virtqueue *vq, const struct cpumask
> *cpu_mask)
>  {
>  	struct virtio_device *vdev = vq->vdev;
>  	if (vdev->config->set_vq_affinity)
> -		return vdev->config->set_vq_affinity(vq, cpu);
> +		return vdev->config->set_vq_affinity(vq, cpu_mask);
>  	return 0;
>  }
> 
> --
> 2.18.0.597.ga71716f1ad-goog
