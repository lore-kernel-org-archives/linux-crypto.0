From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH V3 6/6] crypto/nx: Add P9 NX support for 842 compression engine
Date: Tue, 29 Aug 2017 09:25:04 +1000
Message-ID: <878ti35l7z.fsf@concordia.ellerman.id.au>
References: <1500699702.23205.8.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mikey@neuling.org, benh@kernel.crashing.org, suka@us.ibm.com,
        ddstreet@ieee.org, linuxram@us.ibm.com, npiggin@gmail.com,
        hbabu@us.ibm.com
To: Haren Myneni <haren@linux.vnet.ibm.com>,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:35123 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751189AbdH1XZH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Aug 2017 19:25:07 -0400
In-Reply-To: <1500699702.23205.8.camel@hbabu-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Haren,

Some comments inline ...

Haren Myneni <haren@linux.vnet.ibm.com> writes:

> diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
> index c0dd4c7e17d3..13089a0b9dfa 100644
> --- a/drivers/crypto/nx/nx-842-powernv.c
> +++ b/drivers/crypto/nx/nx-842-powernv.c
> @@ -32,6 +33,9 @@ MODULE_ALIAS_CRYPTO("842-nx");
>  
>  #define WORKMEM_ALIGN	(CRB_ALIGN)
>  #define CSB_WAIT_MAX	(5000) /* ms */
> +#define VAS_RETRIES	(10)

Where does that number come from?

Do we have any idea what the trade off is between retrying vs just
falling back to doing the request in software?

> +/* # of requests allowed per RxFIFO at a time. 0 for unlimited */
> +#define MAX_CREDITS_PER_RXFIFO	(1024)
>  
>  struct nx842_workmem {
>  	/* Below fields must be properly aligned */
> @@ -42,16 +46,27 @@ struct nx842_workmem {
>  
>  	ktime_t start;
>  
> +	struct vas_window *txwin;	/* Used with VAS function */

I don't understand how it makes sense to put txwin and start between the
fields above, and the padding.

If the workmem pointer you receive is not aligned, then PTR_ALIGN() will
advance it and mean you end up writing over start and txwin.

That's probably not your bug, the code is already like that.

>  	char padding[WORKMEM_ALIGN]; /* unused, to allow alignment */
>  } __packed __aligned(WORKMEM_ALIGN);

> @@ -576,6 +690,198 @@ static inline void nx842_add_coprocs_list(struct nx842_coproc *coproc,
>  	list_add(&coproc->list, &nx842_coprocs);
>  }
>  
> +/*
> + * Identify chip ID for each CPU and save coprocesor adddress for the
> + * corresponding NX engine in percpu coproc_inst.
> + * coproc_inst is used in crypto_init to open send window on the NX instance
> + * for the corresponding CPU / chip where the open request is executed.
> + */
> +static void nx842_set_per_cpu_coproc(struct nx842_coproc *coproc)
> +{
> +	unsigned int i, chip_id;
> +
> +	for_each_possible_cpu(i) {
> +		chip_id = cpu_to_chip_id(i);
> +
> +		if (coproc->chip_id == chip_id)
> +			per_cpu(coproc_inst, i) = coproc;
> +	}
> +}
> +
> +
> +static struct vas_window *nx842_alloc_txwin(struct nx842_coproc *coproc)
> +{
> +	struct vas_window *txwin = NULL;
> +	struct vas_tx_win_attr txattr;
> +
> +	/*
> +	 * Kernel requests will be high priority. So open send
> +	 * windows only for high priority RxFIFO entries.
> +	 */
> +	vas_init_tx_win_attr(&txattr, coproc->ct);
> +	txattr.lpid = 0;	/* lpid is 0 for kernel requests */
> +	txattr.pid = mfspr(SPRN_PID);

Should we be using SPRN_PID here? That makes it appear as if it comes
from the current user process, which seems fishy.

> +	/*
> +	 * Open a VAS send window which is used to send request to NX.
> +	 */
> +	txwin = vas_tx_win_open(coproc->vas.id, coproc->ct, &txattr);
> +	if (IS_ERR(txwin)) {
> +		pr_err("ibm,nx-842: Can not open TX window: %ld\n",
> +				PTR_ERR(txwin));
> +		return NULL;
> +	}
> +
> +	return txwin;
> +}
> +
> +static int __init vas_cfg_coproc_info(struct device_node *dn, int chip_id,
> +					int vasid)
> +{
> +	struct vas_window *rxwin = NULL;
> +	struct vas_rx_win_attr rxattr;
> +	struct nx842_coproc *coproc;
> +	u32 lpid, pid, tid, fifo_size;
> +	u64 rx_fifo;
> +	const char *priority;
> +	int ret;
> +
> +	ret = of_property_read_u64(dn, "rx-fifo-address", (void *)&rx_fifo);
                                                          ^^^^^^^^
                                                          Unnecessary cast.

> +	if (ret) {
> +		pr_err("Missing rx-fifo-address property\n");
> +		return ret;
> +	}
> +
> +	ret = of_property_read_u32(dn, "rx-fifo-size", &fifo_size);
> +	if (ret) {
> +		pr_err("Missing rx-fifo-size property\n");
> +		return ret;
> +	}
> +
> +	ret = of_property_read_u32(dn, "lpid", &lpid);
> +	if (ret) {
> +		pr_err("Missing lpid property\n");
> +		return ret;
> +	}
> +
> +	ret = of_property_read_u32(dn, "pid", &pid);
> +	if (ret) {
> +		pr_err("Missing pid property\n");
> +		return ret;
> +	}
> +
> +	ret = of_property_read_u32(dn, "tid", &tid);
> +	if (ret) {
> +		pr_err("Missing tid property\n");
> +		return ret;
> +	}
> +
> +	ret = of_property_read_string(dn, "priority", &priority);
> +	if (ret) {
> +		pr_err("Missing priority property\n");
> +		return ret;
> +	}
> +
> +	coproc = kzalloc(sizeof(*coproc), GFP_KERNEL);
> +	if (!coproc)
> +		return -ENOMEM;
> +
> +	if (!strcmp(priority, "High"))
> +		coproc->ct = VAS_COP_TYPE_842_HIPRI;
> +	else if (!strcmp(priority, "Normal"))
> +		coproc->ct = VAS_COP_TYPE_842;
> +	else {
> +		pr_err("Invalid RxFIFO priority value\n");
> +		ret =  -EINVAL;
> +		goto err_out;
> +	}
> +
> +	vas_init_rx_win_attr(&rxattr, coproc->ct);
> +	rxattr.rx_fifo = (void *)rx_fifo;
> +	rxattr.rx_fifo_size = fifo_size;
> +	rxattr.lnotify_lpid = lpid;
> +	rxattr.lnotify_pid = pid;
> +	rxattr.lnotify_tid = tid;
> +	rxattr.wcreds_max = MAX_CREDITS_PER_RXFIFO;
> +
> +	/*
> +	 * Open a VAS receice window which is used to configure RxFIFO
> +	 * for NX.
> +	 */
> +	rxwin = vas_rx_win_open(vasid, coproc->ct, &rxattr);
> +	if (IS_ERR(rxwin)) {
> +		ret = PTR_ERR(rxwin);
> +		pr_err("setting RxFIFO with VAS failed: %d\n",
> +			ret);
> +		goto err_out;
> +	}
> +
> +	coproc->vas.rxwin = rxwin;
> +	coproc->vas.id = vasid;
> +	nx842_add_coprocs_list(coproc, chip_id);
> +
> +	/*
> +	 * Kernel requests use only high priority FIFOs. So save coproc
> +	 * info in percpu coproc_inst which will be used to open send
> +	 * windows for crypto open requests later.
> +	 */
> +	if (coproc->ct == VAS_COP_TYPE_842_HIPRI)
> +		nx842_set_per_cpu_coproc(coproc);
> +
> +	return 0;
> +
> +err_out:
> +	kfree(coproc);
> +	return ret;
> +}
> +
> +
> +static int __init nx842_powernv_probe_vas(struct device_node *pn)
> +{
> +	struct device_node *dn;
> +	int chip_id, vasid, ret = 0;
> +	int nx_fifo_found = 0;
> +
> +	chip_id = of_get_ibm_chip_id(pn);
> +	if (chip_id < 0) {
> +		pr_err("ibm,chip-id missing\n");
> +		return -EINVAL;
> +	}
> +
> +	dn = of_find_compatible_node(pn, NULL, "ibm,power9-vas-x");

That's the wrong compatible, that will find the raw node, not the one
that's intended for Linux use.

It's also not really the NX drivers business to be looking for VAS
nodes. You should just look for the P9 NX nodes, and if VAS wasn't
configured for some reason then the VAS window open will fail and you
detect it then.

> +	if (!dn) {
> +		pr_err("Missing VAS device node\n");
> +		return -EINVAL;
> +	}
> +
> +	if (of_property_read_u32(dn, "ibm,vas-id", &vasid)) {
> +		pr_err("Missing ibm,vas-id device property\n");
> +		of_node_put(dn);
> +		return -EINVAL;
> +	}
> +
> +	of_node_put(dn);

So basically just drop all of that above.

> diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
> index d94e25df503b..da3cb8c35ec7 100644
> --- a/drivers/crypto/nx/nx-842.c
> +++ b/drivers/crypto/nx/nx-842.c
> @@ -116,7 +116,7 @@ int nx842_crypto_init(struct crypto_tfm *tfm, struct nx842_driver *driver)
>  
>  	spin_lock_init(&ctx->lock);
>  	ctx->driver = driver;
> -	ctx->wmem = kmalloc(driver->workmem_size, GFP_KERNEL);
> +	ctx->wmem = kzalloc(driver->workmem_size, GFP_KERNEL);
>  	ctx->sbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
>  	ctx->dbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
>  	if (!ctx->wmem || !ctx->sbounce || !ctx->dbounce) {

That looks OK but should be split into a separate patch because it
affects the Power8 code as well as the pseries code.

cheers
