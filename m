From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [PATCH V3 6/6] crypto/nx: Add P9 NX support for 842 compression
 engine
Date: Mon, 28 Aug 2017 23:30:37 -0700
Message-ID: <20170829063037.GB5922@us.ibm.com>
References: <1500699702.23205.8.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpe@ellerman.id.au, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mikey@neuling.org, benh@kernel.crashing.org, ddstreet@ieee.org,
        linuxram@linux.vnet.ibm.com, npiggin@gmail.com,
        Haren Myneni <hbabu@us.ibm.com>
To: Haren Myneni <haren@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37984 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751258AbdH2Gao (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Aug 2017 02:30:44 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7T6UKts098432
        for <linux-crypto@vger.kernel.org>; Tue, 29 Aug 2017 02:30:44 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cmvjf77ag-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 29 Aug 2017 02:30:43 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <sukadev@linux.vnet.ibm.com>;
        Tue, 29 Aug 2017 00:30:43 -0600
Content-Disposition: inline
In-Reply-To: <1500699702.23205.8.camel@hbabu-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Haren Myneni [haren@linux.vnet.ibm.com] wrote:
> 
> This patch adds P9 NX support for 842 compression engine. Virtual
> Accelerator Switchboard (VAS) is used to access 842 engine on P9.
> 
> For each NX engine per chip, setup receive window using
> vas_rx_win_open() which configures RxFIFo with FIFO address, lpid,
> pid and tid values. This unique (lpid, pid, tid) combination will
> be used to identify the target engine.
> 
> For crypto open request, open send window on the NX engine for
> the corresponding chip / cpu where the open request is executed.
> This send window will be closed upon crypto close request.
> 
> NX provides high and normal priority FIFOs. For compression /
> decompression requests, we use only hight priority FIFOs in kernel.
> 
> Each NX request will be communicated to VAS using copy/paste
> instructions with vas_copy_crb() / vas_paste_crb() functions.
> 
> Signed-off-by: Haren Myneni <haren@us.ibm.com>
> ---
>  drivers/crypto/nx/Kconfig          |   1 +
>  drivers/crypto/nx/nx-842-powernv.c | 375 ++++++++++++++++++++++++++++++++++++-
>  drivers/crypto/nx/nx-842.c         |   2 +-
>  3 files changed, 371 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/crypto/nx/Kconfig b/drivers/crypto/nx/Kconfig
> index ad7552a6998c..cd5dda9c48f4 100644
> --- a/drivers/crypto/nx/Kconfig
> +++ b/drivers/crypto/nx/Kconfig
> @@ -38,6 +38,7 @@ config CRYPTO_DEV_NX_COMPRESS_PSERIES
>  config CRYPTO_DEV_NX_COMPRESS_POWERNV
>  	tristate "Compression acceleration support on PowerNV platform"
>  	depends on PPC_POWERNV
> +	depends on PPC_VAS
>  	default y
>  	help
>  	  Support for PowerPC Nest (NX) compression acceleration. This
> diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
> index c0dd4c7e17d3..13089a0b9dfa 100644
> --- a/drivers/crypto/nx/nx-842-powernv.c
> +++ b/drivers/crypto/nx/nx-842-powernv.c
> @@ -23,6 +23,7 @@
>  #include <asm/prom.h>
>  #include <asm/icswx.h>
>  #include <asm/vas.h>
> +#include <asm/reg.h>
> 
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
> @@ -32,6 +33,9 @@ MODULE_ALIAS_CRYPTO("842-nx");
> 
>  #define WORKMEM_ALIGN	(CRB_ALIGN)
>  #define CSB_WAIT_MAX	(5000) /* ms */
> +#define VAS_RETRIES	(10)
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
>  	char padding[WORKMEM_ALIGN]; /* unused, to allow alignment */
>  } __packed __aligned(WORKMEM_ALIGN);
> 
>  struct nx842_coproc {
>  	unsigned int chip_id;
>  	unsigned int ct;
> -	unsigned int ci;
> +	unsigned int ci;	/* Coprocessor instance, used with icswx */
> +	struct {
> +		struct vas_window *rxwin;
> +		int id;
> +	} vas;
>  	struct list_head list;
>  };
> 
> +/*
> + * Send the request to NX engine on the chip for the corresponding CPU
> + * where the process is executing. Use with VAS function.
> + */
> +static DEFINE_PER_CPU(struct nx842_coproc *, coproc_inst);
> +
>  /* no cpu hotplug on powernv, so this list never changes after init */
>  static LIST_HEAD(nx842_coprocs);
>  static unsigned int nx842_ct;	/* used in icswx function */
> @@ -513,6 +528,105 @@ static int nx842_exec_icswx(const unsigned char *in, unsigned int inlen,
>  }
> 
>  /**
> + * nx842_exec_vas - compress/decompress data using the 842 algorithm
> + *
> + * (De)compression provided by the NX842 coprocessor on IBM PowerNV systems.
> + * This compresses or decompresses the provided input buffer into the provided
> + * output buffer.
> + *
> + * Upon return from this function @outlen contains the length of the
> + * output data.  If there is an error then @outlen will be 0 and an
> + * error will be specified by the return code from this function.
> + *
> + * The @workmem buffer should only be used by one function call at a time.
> + *
> + * @in: input buffer pointer
> + * @inlen: input buffer size
> + * @out: output buffer pointer
> + * @outlenp: output buffer size pointer
> + * @workmem: working memory buffer pointer, size determined by
> + *           nx842_powernv_driver.workmem_size
> + * @fc: function code, see CCW Function Codes in nx-842.h
> + *
> + * Returns:
> + *   0		Success, output of length @outlenp stored in the buffer
> + *		at @out
> + *   -ENODEV	Hardware unavailable
> + *   -ENOSPC	Output buffer is to small
> + *   -EMSGSIZE	Input buffer too large
> + *   -EINVAL	buffer constraints do not fix nx842_constraints
> + *   -EPROTO	hardware error during operation
> + *   -ETIMEDOUT	hardware did not complete operation in reasonable time
> + *   -EINTR	operation was aborted
> + */
> +static int nx842_exec_vas(const unsigned char *in, unsigned int inlen,
> +				  unsigned char *out, unsigned int *outlenp,
> +				  void *workmem, int fc)
> +{
> +	struct coprocessor_request_block *crb;
> +	struct coprocessor_status_block *csb;
> +	struct nx842_workmem *wmem;
> +	struct vas_window *txwin;
> +	int ret, i = 0;
> +	u32 ccw;
> +	unsigned int outlen = *outlenp;
> +
> +	wmem = PTR_ALIGN(workmem, WORKMEM_ALIGN);
> +
> +	*outlenp = 0;
> +
> +	crb = &wmem->crb;
> +	csb = &crb->csb;
> +
> +	ret = nx842_config_crb(in, inlen, out, outlen, wmem);
> +	if (ret)
> +		return ret;
> +
> +	ccw = 0;
> +	ccw = SET_FIELD(CCW_FC_842, ccw, fc);
> +	crb->ccw = cpu_to_be32(ccw);
> +
> +	txwin = wmem->txwin;
> +	/* shoudn't happen, we don't load without a coproc */
> +	if (!txwin) {
> +		pr_err_ratelimited("NX-842 coprocessor is not available");
> +		return -ENODEV;
> +	}
> +
> +	do {
> +		wmem->start = ktime_get();
> +		preempt_disable();
> +		/*
> +		 * VAS copy CRB into L2 cache. Refer <asm/vas.h>.
> +		 * @crb, @offset and @first (must be true)
> +		 */
> +		vas_copy_crb(crb, 0, 1);

In [v8] of the VAS patch set:

	https://lists.ozlabs.org/pipermail/linuxppc-dev/2017-August/162892.html

vas_copy_crb() takes just two parameters (crb and offset). The last
parameter "1", above should be dropped.

> +
> +		/*
> +		 * VAS paste previously copied CRB to NX.
> +		 * @txwin, @offset, @last (must be true) and @re is 
> +		 * expected/assumed to be true for NX windows.
> +		 */
> +		ret = vas_paste_crb(txwin, 0, 1, 1);

Similarly, the last parameter, "1" to vas_paste_crb() must be dropped.

i.e [v8] of VAS was tested with following changes to the above calls:

diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-power
index 13089a0..6823569 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -600,14 +600,14 @@ static int nx842_exec_vas(const unsigned char *in, unsigne
                 * VAS copy CRB into L2 cache. Refer <asm/vas.h>.
                 * @crb, @offset and @first (must be true)
                 */
-               vas_copy_crb(crb, 0, 1);
+               vas_copy_crb(crb, 0);
 
                /*
                 * VAS paste previously copied CRB to NX.
                 * @txwin, @offset, @last (must be true) and @re is 
                 * expected/assumed to be true for NX windows.
                 */
-               ret = vas_paste_crb(txwin, 0, 1, 1);
+               ret = vas_paste_crb(txwin, 0, 1);
                preempt_enable();
                /*
                 * Retry copy/paste function for VAS failures.


> +		preempt_enable();
> +		/*
> +		 * Retry copy/paste function for VAS failures.
> +		 */
> +	} while (ret && (i++ < VAS_RETRIES));
> +
> +	if (ret) {
> +		pr_err_ratelimited("VAS copy/paste failed\n");
> +		return ret;
> +	}
> +
> +	ret = wait_for_csb(wmem, csb);
> +	if (!ret)
> +		*outlenp = be32_to_cpu(csb->count);
> +
> +	return ret;
> +}
> +
> +/**
>   * nx842_powernv_compress - Compress data using the 842 algorithm
>   *
>   * Compression provided by the NX842 coprocessor on IBM PowerNV systems.
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
> +
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
> +
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
> +
> +	for_each_child_of_node(pn, dn) {
> +		if (of_device_is_compatible(dn, "ibm,p9-nx-842")) {
> +			ret = vas_cfg_coproc_info(dn, chip_id, vasid);
> +			if (ret) {
> +				of_node_put(dn);
> +				return ret;
> +			}
> +			nx_fifo_found++;
> +		}
> +	}
> +
> +	if (!nx_fifo_found) {
> +		pr_err("NX842 FIFO nodes are missing\n");
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
>  static int __init nx842_powernv_probe(struct device_node *dn)
>  {
>  	struct nx842_coproc *coproc;
> @@ -622,6 +928,9 @@ static void nx842_delete_coprocs(void)
>  	struct nx842_coproc *coproc, *n;
> 
>  	list_for_each_entry_safe(coproc, n, &nx842_coprocs, list) {
> +		if (coproc->vas.rxwin)
> +			vas_win_close(coproc->vas.rxwin);
> +
>  		list_del(&coproc->list);
>  		kfree(coproc);
>  	}
> @@ -643,6 +952,46 @@ static struct nx842_driver nx842_powernv_driver = {
>  	.decompress =	nx842_powernv_decompress,
>  };
> 
> +static int nx842_powernv_crypto_init_vas(struct crypto_tfm *tfm)
> +{
> +	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
> +	struct nx842_workmem *wmem;
> +	struct nx842_coproc *coproc;
> +	int ret;
> +
> +	ret = nx842_crypto_init(tfm, &nx842_powernv_driver);
> +
> +	if (ret)
> +		return ret;
> +
> +	wmem = PTR_ALIGN((struct nx842_workmem *)ctx->wmem, WORKMEM_ALIGN);
> +	coproc = per_cpu(coproc_inst, smp_processor_id());
> +
> +	ret = -EINVAL;
> +	if (coproc && coproc->vas.rxwin) {
> +		wmem->txwin = nx842_alloc_txwin(coproc);
> +		if (!IS_ERR(wmem->txwin))
> +			return 0;
> +
> +		ret = PTR_ERR(wmem->txwin);
> +	}
> +
> +	return ret;
> +}
> +
> +void nx842_powernv_crypto_exit_vas(struct crypto_tfm *tfm)
> +{
> +	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
> +	struct nx842_workmem *wmem;
> +
> +	wmem = PTR_ALIGN((struct nx842_workmem *)ctx->wmem, WORKMEM_ALIGN);
> +
> +	if (wmem && wmem->txwin)
> +		vas_win_close(wmem->txwin);
> +
> +	nx842_crypto_exit(tfm);
> +}
> +
>  static int nx842_powernv_crypto_init(struct crypto_tfm *tfm)
>  {
>  	return nx842_crypto_init(tfm, &nx842_powernv_driver);
> @@ -676,13 +1025,27 @@ static __init int nx842_powernv_init(void)
>  	BUILD_BUG_ON(DDE_BUFFER_ALIGN % DDE_BUFFER_SIZE_MULT);
>  	BUILD_BUG_ON(DDE_BUFFER_SIZE_MULT % DDE_BUFFER_LAST_MULT);
> 
> -	for_each_compatible_node(dn, NULL, "ibm,power-nx")
> -		nx842_powernv_probe(dn);
> +	for_each_compatible_node(dn, NULL, "ibm,power9-nx") {
> +		ret = nx842_powernv_probe_vas(dn);
> +		if (ret) {
> +			nx842_delete_coprocs();
> +			return ret;
> +		}
> +	}
> 
> -	if (!nx842_ct)
> -		return -ENODEV;
> +	if (list_empty(&nx842_coprocs)) {
> +		for_each_compatible_node(dn, NULL, "ibm,power-nx")
> +			nx842_powernv_probe(dn);
> +
> +		if (!nx842_ct)
> +			return -ENODEV;
> 
> -	nx842_powernv_exec = nx842_exec_icswx;
> +		nx842_powernv_exec = nx842_exec_icswx;
> +	} else {
> +		nx842_powernv_exec = nx842_exec_vas;
> +		nx842_powernv_alg.cra_init = nx842_powernv_crypto_init_vas;
> +		nx842_powernv_alg.cra_exit = nx842_powernv_crypto_exit_vas;
> +	}
> 
>  	ret = crypto_register_alg(&nx842_powernv_alg);
>  	if (ret) {
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
> -- 
> 2.11.0
> 
> 
