From: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH 2/2] crypto: qat - Enforce valid numa configuration.
Date: Wed, 08 Oct 2014 13:57:22 -0400
Message-ID: <54357B02.8080008@redhat.com>
References: <20141008173750.13714.49713.stgit@tstruk-mobl1> <20141008173853.13714.47458.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, bruce.w.allan@intel.com,
	qat-linux@intel.com, john.griffin@intel.com,
	linux-crypto@vger.kernel.org, naleksan@redhat.com,
	davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbaJHR5a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Oct 2014 13:57:30 -0400
In-Reply-To: <20141008173853.13714.47458.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/08/2014 01:38 PM, Tadeusz Struk wrote:
> In a system with NUMA configuration we want to enforce that the accelerator is
> connected to a node with memory to avoid cross QPI memory transaction.
> Otherwise there is no point in using the accelerator as the encryption in
> software will be faster.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  drivers/crypto/qat/qat_common/adf_accel_devices.h |    3 +--
>  drivers/crypto/qat/qat_common/adf_transport.c     |   12 +++++++-----
>  drivers/crypto/qat/qat_common/qat_algs.c          |    5 +++--
>  drivers/crypto/qat/qat_common/qat_crypto.c        |    8 +++++---
>  drivers/crypto/qat/qat_dh895xcc/adf_admin.c       |    2 +-
>  drivers/crypto/qat/qat_dh895xcc/adf_drv.c         |    9 ++++++++-
>  drivers/crypto/qat/qat_dh895xcc/adf_isr.c         |    2 +-
>  7 files changed, 26 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
> index 3cfe195..96e0b06 100644
> --- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
> +++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
> @@ -203,8 +203,7 @@ struct adf_accel_dev {
>  	struct dentry *debugfs_dir;
>  	struct list_head list;
>  	struct module *owner;
> -	uint8_t accel_id;
> -	uint8_t numa_node;
>  	struct adf_accel_pci accel_pci_dev;
> +	uint8_t accel_id;
>  } __packed;
>  #endif
> diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
> index 5f3fa45..9dd2cb7 100644
> --- a/drivers/crypto/qat/qat_common/adf_transport.c
> +++ b/drivers/crypto/qat/qat_common/adf_transport.c
> @@ -419,9 +419,10 @@ static int adf_init_bank(struct adf_accel_dev *accel_dev,
>  		WRITE_CSR_RING_BASE(csr_addr, bank_num, i, 0);
>  		ring = &bank->rings[i];
>  		if (hw_data->tx_rings_mask & (1 << i)) {
> -			ring->inflights = kzalloc_node(sizeof(atomic_t),
> -						       GFP_KERNEL,
> -						       accel_dev->numa_node);
> +			ring->inflights =
> +				kzalloc_node(sizeof(atomic_t),
> +					     GFP_KERNEL,
> +					     dev_to_node(&GET_DEV(accel_dev)));
>  			if (!ring->inflights)
>  				goto err;
>  		} else {
> @@ -469,13 +470,14 @@ int adf_init_etr_data(struct adf_accel_dev *accel_dev)
>  	int i, ret;
>  
>  	etr_data = kzalloc_node(sizeof(*etr_data), GFP_KERNEL,
> -				accel_dev->numa_node);
> +				dev_to_node(&GET_DEV(accel_dev)));
>  	if (!etr_data)
>  		return -ENOMEM;
>  
>  	num_banks = GET_MAX_BANKS(accel_dev);
>  	size = num_banks * sizeof(struct adf_etr_bank_data);
> -	etr_data->banks = kzalloc_node(size, GFP_KERNEL, accel_dev->numa_node);
> +	etr_data->banks = kzalloc_node(size, GFP_KERNEL,
> +				       dev_to_node(&GET_DEV(accel_dev)));
>  	if (!etr_data->banks) {
>  		ret = -ENOMEM;
>  		goto err_bank;
> diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
> index bffa8bf..0897a1c 100644
> --- a/drivers/crypto/qat/qat_common/qat_algs.c
> +++ b/drivers/crypto/qat/qat_common/qat_algs.c
> @@ -598,7 +598,8 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
>  	if (unlikely(!n))
>  		return -EINVAL;
>  
> -	bufl = kmalloc_node(sz, GFP_ATOMIC, inst->accel_dev->numa_node);
> +	bufl = kmalloc_node(sz, GFP_ATOMIC,
> +			    dev_to_node(&GET_DEV(inst->accel_dev)));
>  	if (unlikely(!bufl))
>  		return -ENOMEM;
>  
> @@ -644,7 +645,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
>  		struct qat_alg_buf *bufers;
>  
>  		buflout = kmalloc_node(sz, GFP_ATOMIC,
> -				       inst->accel_dev->numa_node);
> +				       dev_to_node(&GET_DEV(inst->accel_dev)));
>  		if (unlikely(!buflout))
>  			goto err;
>  		bloutp = dma_map_single(dev, buflout, sz, DMA_TO_DEVICE);
> diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
> index 060dc0a..c1eefc4 100644
> --- a/drivers/crypto/qat/qat_common/qat_crypto.c
> +++ b/drivers/crypto/qat/qat_common/qat_crypto.c
> @@ -109,12 +109,14 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
>  
>  	list_for_each(itr, adf_devmgr_get_head()) {
>  		accel_dev = list_entry(itr, struct adf_accel_dev, list);
> -		if (accel_dev->numa_node == node && adf_dev_started(accel_dev))
> +		if ((node == dev_to_node(&GET_DEV(accel_dev)) ||
> +			dev_to_node(&GET_DEV(accel_dev)) < 0)
> +				&& adf_dev_started(accel_dev))
>  			break;
>  		accel_dev = NULL;
>  	}
>  	if (!accel_dev) {
> -		pr_err("QAT: Could not find a device on the given node\n");
> +		pr_err("QAT: Could not find a device on node %d\n", node);
>  		accel_dev = adf_devmgr_get_first();
>  	}
>  	if (!accel_dev || !adf_dev_started(accel_dev))
> @@ -164,7 +166,7 @@ static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
>  
>  	for (i = 0; i < num_inst; i++) {
>  		inst = kzalloc_node(sizeof(*inst), GFP_KERNEL,
> -				    accel_dev->numa_node);
> +				    dev_to_node(&GET_DEV(accel_dev)));
>  		if (!inst)
>  			goto err;
>  
> diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_admin.c b/drivers/crypto/qat/qat_dh895xcc/adf_admin.c
> index 978d6c5..53c491b 100644
> --- a/drivers/crypto/qat/qat_dh895xcc/adf_admin.c
> +++ b/drivers/crypto/qat/qat_dh895xcc/adf_admin.c
> @@ -108,7 +108,7 @@ int adf_init_admin_comms(struct adf_accel_dev *accel_dev)
>  	uint64_t reg_val;
>  
>  	admin = kzalloc_node(sizeof(*accel_dev->admin), GFP_KERNEL,
> -			     accel_dev->numa_node);
> +			     dev_to_node(&GET_DEV(accel_dev)));
>  	if (!admin)
>  		return -ENOMEM;
>  	admin->virt_addr = dma_zalloc_coherent(&GET_DEV(accel_dev), PAGE_SIZE,
> diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
> index 84edf17..40202cc 100644
> --- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
> +++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
> @@ -244,11 +244,18 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	}
>  
>  	node = adf_get_dev_node_id(pdev);

^^^ I don't think you should ever make this call.  IMO it is wrong to do it that
way.  Just stick with

	node = dev_to_node(&pdev->dev)

as the line below forces a default to that anyway.

> +	if (node != dev_to_node(&pdev->dev) && dev_to_node(&pdev->dev) > 0) {
> +		/* If the accelerator is connected to a node with no memory
> +		 * there is no point in using the accelerator since the remote
> +		 * memory transaction will be very slow. */
> +		dev_err(&pdev->dev, "Invalid NUMA configuration.\n");
> +		return -EINVAL;

Hmm ... I wonder if it would be safe to do

	/* force allocations to node 0 */
	node = 0;
	dev_err(&pdev->dev, "Invalid NUMA configuration detected, node id = %d .
Defaulting node to 0.  \n",
                node);

and then continue?

And maybe even a FW_WARN of some sort here might be appropriate to indicate that
something is wrong with the mapping?  In any case a better error message is a
always good idea IMO.

P.

> +	}
> +
>  	accel_dev = kzalloc_node(sizeof(*accel_dev), GFP_KERNEL, node);
>  	if (!accel_dev)
>  		return -ENOMEM;
>  
> -	accel_dev->numa_node = node;
>  	INIT_LIST_HEAD(&accel_dev->crypto_list);
>  
>  	/* Add accel device to accel table.
> diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
> index c9212b9..fe8f896 100644
> --- a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
> +++ b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
> @@ -168,7 +168,7 @@ static int adf_isr_alloc_msix_entry_table(struct adf_accel_dev *accel_dev)
>  	uint32_t msix_num_entries = hw_data->num_banks + 1;
>  
>  	entries = kzalloc_node(msix_num_entries * sizeof(*entries),
> -			       GFP_KERNEL, accel_dev->numa_node);
> +			       GFP_KERNEL, dev_to_node(&GET_DEV(accel_dev)));
>  	if (!entries)
>  		return -ENOMEM;
>  
> 
