From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 4/5] crypto/nx: Add P9 NX support for 842 compression engine.
Date: Tue, 04 Apr 2017 20:55:30 +1000
Message-ID: <87mvbwv3vh.fsf@concordia.ellerman.id.au>
References: <1491066107.29552.29.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        benh@kernel.crashing.org, mikey@neuling.org, suka@us.ibm.com,
        hbabu@us.ibm.com
To: Haren Myneni <haren@linux.vnet.ibm.com>,
        herbert@gondor.apana.org.au, ddstreet@ieee.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:55785 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753534AbdDDKzd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Apr 2017 06:55:33 -0400
In-Reply-To: <1491066107.29552.29.camel@hbabu-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Haren,

A few comments ...

Haren Myneni <haren@linux.vnet.ibm.com> writes:

> diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/vas.h
> index 4e5a470..7315621 100644
> --- a/arch/powerpc/include/asm/vas.h
> +++ b/arch/powerpc/include/asm/vas.h
> @@ -19,6 +19,8 @@
>  #define VAS_RX_FIFO_SIZE_MIN	(1 << 10)	/* 1KB */
>  #define VAS_RX_FIFO_SIZE_MAX	(8 << 20)	/* 8MB */
>  
> +#define is_vas_available()	(cpu_has_feature(CPU_FTR_ARCH_300))

You shouldn't need that, it should all come from the device tree.

> diff --git a/drivers/crypto/nx/Kconfig b/drivers/crypto/nx/Kconfig
> index ad7552a..4ad7fdb 100644
> --- a/drivers/crypto/nx/Kconfig
> +++ b/drivers/crypto/nx/Kconfig
> @@ -38,6 +38,7 @@ config CRYPTO_DEV_NX_COMPRESS_PSERIES
>  config CRYPTO_DEV_NX_COMPRESS_POWERNV
>  	tristate "Compression acceleration support on PowerNV platform"
>  	depends on PPC_POWERNV
> +	select VAS

Don't select symbols that are user visible. 

I'm not sure we actually want CONFIG_VAS to be user visible, but
currently it is so this should be 'depends on VAS'.

> diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
> index 8737e90..66efd39 100644
> --- a/drivers/crypto/nx/nx-842-powernv.c
> +++ b/drivers/crypto/nx/nx-842-powernv.c
> @@ -554,6 +662,164 @@ static int nx842_powernv_decompress(const unsigned char *in, unsigned int inlen,
>  				      wmem, CCW_FC_842_DECOMP_CRC);
>  }
>  
> +
> +static int __init vas_cfg_coproc_info(struct device_node *dn, int chip_id,
> +					int vasid, int ct)
> +{
> +	struct vas_window *rxwin, *txwin = NULL;
> +	struct vas_rx_win_attr rxattr;
> +	struct vas_tx_win_attr txattr;
> +	struct nx842_coproc *coproc;
> +	u32 lpid, pid, tid;
> +	u64 rx_fifo;
> +	int ret;
> +#define RX_FIFO_SIZE 0x8000

Where's that come from?

> +	if (of_property_read_u64(dn, "rx-fifo-address", (void *)&rx_fifo)) {
> +		pr_err("ibm,nx-842: Missing rx-fifo-address property\n");

The driver already declares pr_fmt(), so do you need the prefixes on
these pr_err()s ?

> +		return -EINVAL;
> +	}
> +
> +	if (of_property_read_u32(dn, "lpid", &lpid)) {
> +		pr_err("ibm,nx-842: Missing lpid property\n");
> +		return -EINVAL;
> +	}
> +
> +	if (of_property_read_u32(dn, "pid", &pid)) {
> +		pr_err("ibm,nx-842: Missing pid property\n");
> +		return -EINVAL;
> +	}
> +
> +	if (of_property_read_u32(dn, "tid", &tid)) {
> +		pr_err("ibm,nx-842: Missing tid property\n");
> +		return -EINVAL;
> +	}
> +
> +	vas_init_rx_win_attr(&rxattr, ct);
> +	rxattr.rx_fifo = (void *)rx_fifo;
> +	rxattr.rx_fifo_size = RX_FIFO_SIZE;
> +	rxattr.lnotify_lpid = lpid;
> +	rxattr.lnotify_pid = pid;
> +	rxattr.lnotify_tid = tid;
> +	rxattr.wcreds_max = 64;
> +
> +	/*
> +	 * Open a VAS receice window which is used to configure RxFIFO
> +	 * for NX.
> +	 */
> +	rxwin = vas_rx_win_open(vasid, ct, &rxattr);
> +	if (IS_ERR(rxwin)) {
> +		pr_err("ibm,nx-842: setting RxFIFO with VAS failed: %ld\n",
> +			PTR_ERR(rxwin));
> +		return PTR_ERR(rxwin);
> +	}
> +
> +	/*
> +	 * Kernel requests will be high priority. So open send
> +	 * windows only for high priority RxFIFO entries.
> +	 */
> +	if (ct == VAS_COP_TYPE_842_HIPRI) {

This if body looks like it should be a separate function to me.

> +		vas_init_tx_win_attr(&txattr, ct);
> +		txattr.lpid = 0;	/* lpid is 0 for kernel requests */
> +		txattr.pid = mfspr(SPRN_PID);
> +
> +		/*
> +		 * Open a VAS send window which is used to send request to NX.
> +		 */
> +		txwin = vas_tx_win_open(vasid, ct, &txattr);
> +		if (IS_ERR(txwin)) {
> +			pr_err("ibm,nx-842: Can not open TX window: %ld\n",
> +				PTR_ERR(txwin));
> +			ret = PTR_ERR(txwin);
> +			goto err_out;
> +		}
> +	}
> +
> +	coproc = kmalloc(sizeof(*coproc), GFP_KERNEL);
> +	if (!coproc) {
> +		ret = -ENOMEM;
> +		goto err_out;
> +	}

The error handling would be simpler if you did that earlier, before you
open the RX/TX windows.

> +	coproc->chip_id = chip_id;
> +	coproc->vas.rxwin = rxwin;
> +	coproc->vas.txwin = txwin;
> +
> +	INIT_LIST_HEAD(&coproc->list);
> +	list_add(&coproc->list, &nx842_coprocs);

That duplicates logic in the non-vas probe, so ideally would be shared
or in a helper.

> +
> +	return 0;
> +
> +err_out:
> +	if (txwin)
> +		vas_win_close(txwin);
> +
> +	vas_win_close(rxwin);
> +
> +	return ret;
> +}
> +
> +
> +static int __init nx842_powernv_probe_vas(struct device_node *dn)
> +{
> +	struct device_node *nxdn, *np;

There's too many device nodes in this function.

> +	int chip_id, vasid, rc;
> +
> +	chip_id = of_get_ibm_chip_id(dn);
> +	if (chip_id < 0) {
> +		pr_err("ibm,chip-id missing\n");
> +		return -EINVAL;
> +	}
> +
> +	np = of_find_node_by_name(dn, "vas");

You should always search by compatible when possible. I don't see why
you wouldn't here.


> +	if (!np) {
> +		pr_err("ibm,xscom: Missing VAS device node\n");
> +		return -EINVAL;
> +	}
> +
> +	if (of_property_read_u32(np, "vas-id", &vasid)) {
> +		pr_err("ibm,vas: Missing vas-id device property\n");
> +		of_node_put(np);
> +		return -EINVAL;
> +	}
> +
> +	of_node_put(np);
> +
> +	nxdn = of_find_compatible_node(dn, NULL, "ibm,power-nx");

What are you trying to do here?

This will find any node in the device tree that is compatible with
"ibm,power-nx". It will start searching after dn in the device tree. But
it doesn't search the children of dn necessarily, is that what you're
trying to do?

> +	if (!nxdn) {
> +		pr_err("ibm,xscom: Missing NX device node\n");
> +		return -EINVAL;
> +	}
> +
> +	np = of_find_node_by_name(nxdn, "ibm,nx-842-high");

Search by name again.

> +	if (!np) {
> +		pr_err("ibm,nx-842-high device node is missing\n");
> +		rc = -EINVAL;
> +		goto out_nd_put;
> +	}
> +
> +	rc = vas_cfg_coproc_info(np, chip_id, vasid, VAS_COP_TYPE_842_HIPRI);
> +	of_node_put(np);
> +	if (rc)
> +		goto out_nd_put;
> +
> +	np = of_find_node_by_name(nxdn, "ibm,nx-842-normal");

Search by name again.

Normal vs high should not be encoded in the name, it should be a
property of the node.

> +	if (!np) {
> +		pr_err("ibm,nx-842-normal device node is missing\n");
> +		rc = -EINVAL;
> +		goto out_nd_put;
> +	}
> +
> +	rc = vas_cfg_coproc_info(np, chip_id, vasid, VAS_COP_TYPE_842);
> +	of_node_put(np);
> +	if (!rc)
> +		return 0;
> +
> +out_nd_put:
> +	of_node_put(nxdn);
> +	return rc;
> +}
> +
>  static int __init nx842_powernv_probe(struct device_node *dn)
>  {
>  	struct nx842_coproc *coproc;
> @@ -602,11 +868,42 @@ static void nx842_delete_coproc(void)
>  	struct nx842_coproc *coproc, *n;
>  
>  	list_for_each_entry_safe(coproc, n, &nx842_coprocs, list) {
> +		if (is_vas_available()) {

That should just be a check of coproc->vas.rxwin != NULL or similar.

> +			vas_win_close(coproc->vas.rxwin);
> +			/*
> +			 * txwin opened only for high priority RxFIFOs
> +			 */
> +			if (coproc->vas.txwin)
> +				vas_win_close(coproc->vas.txwin);
> +		}

That should be pulled out into a helper, not in the middle of the loop
here.

>  		list_del(&coproc->list);
>  		kfree(coproc);
>  	}
>  }


cheers
