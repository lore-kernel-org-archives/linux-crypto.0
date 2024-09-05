Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFDD3D6D
	for <linux-crypto@vger.kernel.org>; Thu,  5 Sep 2024 20:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725566449; cv=none; b=PStACWPHLkRfXrojnYtT/id4Qch1IOR7UThYR5d+n1Um4R77Q3/ZfUTwC7p8L5sJ8epx/gF3mGRVJOPZaFR/7TE+e2CnNa4Hj2akgdmwOJfvXh6mtDi4XuOeSQu5SLwP/OSmIwK+KDx6O9QlqVwoF44ZFg6vUN1PD/AGWU7rSlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725566449; c=relaxed/simple;
	bh=avPSvdKLZrnpXLRi4hJjIsSLeb7AaXu85ObqMfhceRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eTdSq7KMNsK6VfFapS76CuR9bhVBNE57zFzdWvE1+YWPZJNzwnI5AE5LUmxuccuRxGJS6j/HBpmhh3nTXv3jZOCRhhjm+66sg6fOv81vmMfEwjvhiytrPvjx/8pjGbLt/S7XWmYR+mdFQXyQN/04z520dAUr1GPbEwYwZBpbLtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sSzlxfSs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sSzlxfSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D99C4CEC3;
	Thu,  5 Sep 2024 20:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725566449;
	bh=avPSvdKLZrnpXLRi4hJjIsSLeb7AaXu85ObqMfhceRc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sSzlxfSsBQuSALYcPY8ixCnM8JJiyQoj27uPyHsSgFklRnW7z0hwLP6g/sdkoIWub
	 y0S6bxVH5zmyxOdUD2SKDWVrZC4nXaTWDB+uZUKiNFHC2h5n4XX2QOpmhooHVeXGFF
	 QnW3Eown7rnOHBAZVGJFD9iuXYk6yfbCmYWwt1GgsnbTah28qchFjiGCnINlaLAw9q
	 ArJ8dDE0SFwAKfWKdErAsmrpP+tBB/UteF2K0yBVewVHch984v4j5hNgzEB5oStdMQ
	 uBztRg0aftS3V4ACtysbsWnXC/+egReqF6TMS8CtQfYwyzKdkZ+VwVNWfYV6ukK2ST
	 oYdatPHYwr+JA==
Date: Thu, 5 Sep 2024 15:00:47 -0500
From: Rob Herring <robh@kernel.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v8 1/6] Add SPAcc Skcipher support
Message-ID: <20240905200047.GA2451375-robh@kernel.org>
References: <20240905113050.237789-1-pavitrakumarm@vayavyalabs.com>
 <20240905113050.237789-2-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905113050.237789-2-pavitrakumarm@vayavyalabs.com>

On Thu, Sep 05, 2024 at 05:00:45PM +0530, Pavitrakumar M wrote:
> Add SPAcc Skcipher support to Synopsys Protocol Accelerator(SPAcc) IP,
> which is a crypto accelerator engine.
> SPAcc supports ciphers, hashes and AEAD algorithms such as
> AES in different modes, SHA variants, AES-GCM, Chacha-poly1305 etc.
> 
> Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
> Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> ---
>  drivers/crypto/dwc-spacc/spacc_core.c      | 1130 ++++++++++++++++++++
>  drivers/crypto/dwc-spacc/spacc_core.h      |  819 ++++++++++++++
>  drivers/crypto/dwc-spacc/spacc_device.c    |  304 ++++++
>  drivers/crypto/dwc-spacc/spacc_device.h    |  228 ++++
>  drivers/crypto/dwc-spacc/spacc_hal.c       |  367 +++++++
>  drivers/crypto/dwc-spacc/spacc_hal.h       |  114 ++
>  drivers/crypto/dwc-spacc/spacc_interrupt.c |  317 ++++++
>  drivers/crypto/dwc-spacc/spacc_manager.c   |  658 ++++++++++++
>  drivers/crypto/dwc-spacc/spacc_skcipher.c  |  716 +++++++++++++
>  9 files changed, 4653 insertions(+)
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c


> diff --git a/drivers/crypto/dwc-spacc/spacc_device.c b/drivers/crypto/dwc-spacc/spacc_device.c
> new file mode 100644
> index 000000000000..b9b6495fb5e3
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_device.c
> @@ -0,0 +1,304 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/platform_device.h>
> +#include "spacc_device.h"
> +
> +static struct platform_device *spacc_pdev[MAX_DEVICES];

Generally drivers aren't limited to some number of instances (except 1 
perhaps).

> +
> +#define VSPACC_PRIORITY_MAX 15
> +
> +void spacc_cmd_process(struct spacc_device *spacc, int x)
> +{
> +	struct spacc_priv *priv = container_of(spacc, struct spacc_priv, spacc);
> +
> +	/* run tasklet to pop jobs off fifo */
> +	tasklet_schedule(&priv->pop_jobs);
> +}
> +void spacc_stat_process(struct spacc_device *spacc)
> +{
> +	struct spacc_priv *priv = container_of(spacc, struct spacc_priv, spacc);
> +
> +	/* run tasklet to pop jobs off fifo */
> +	tasklet_schedule(&priv->pop_jobs);
> +}
> +

> +static const struct of_device_id snps_spacc_id[] = {
> +	{.compatible = "snps,dwc-spacc" },
> +	{ /*sentinel */        }
> +};
> +
> +MODULE_DEVICE_TABLE(of, snps_spacc_id);

You can move the table to where it is used since you no longer use it in 
spacc_init_device.

> +
> +static int spacc_init_device(struct platform_device *pdev)
> +{
> +	int vspacc_idx = -1;
> +	struct resource *mem;
> +	void __iomem *baseaddr;
> +	struct pdu_info   info;
> +	int vspacc_priority = -1;
> +	struct spacc_priv *priv;
> +	int x = 0, err, oldmode, irq_num;
> +	u64 oldtimer = 100000, timer = 100000;
> +
> +	/* Initialize DDT DMA pools based on this device's resources */
> +	if (pdu_mem_init(&pdev->dev)) {
> +		dev_err(&pdev->dev, "Could not initialize DMA pools\n");
> +		return -ENOMEM;
> +	}
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);

You don't need this as devm_platform_get_and_ioremap_resource() does 
this and more.

> +	if (!mem) {
> +		dev_err(&pdev->dev, "no memory resource for spacc\n");
> +		err = -ENXIO;
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv) {
> +		err = -ENOMEM;
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	/* Read spacc priority and index and save inside priv.spacc.config */
> +	if (of_property_read_u32(pdev->dev.of_node, "vspacc-priority",
> +				 &vspacc_priority)) {
> +		dev_err(&pdev->dev, "No virtual spacc priority specified\n");
> +		err = -EINVAL;
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	if (vspacc_priority < 0 && vspacc_priority > VSPACC_PRIORITY_MAX) {
> +		dev_err(&pdev->dev, "Invalid virtual spacc priority\n");
> +		err = -EINVAL;
> +		goto free_ddt_mem_pool;
> +	}
> +	priv->spacc.config.priority = vspacc_priority;
> +
> +	if (of_property_read_u32(pdev->dev.of_node, "vspacc-index",
> +				 &vspacc_idx)) {
> +		dev_err(&pdev->dev, "No virtual spacc index specified\n");

This property was not required in the binding, so why does the driver 
require it?

> +		err = -EINVAL;
> +		goto free_ddt_mem_pool;
> +	}
> +	priv->spacc.config.idx = vspacc_idx;
> +
> +	priv->spacc.config.spacc_endian = of_property_read_bool(
> +				pdev->dev.of_node, "little-endian");

Lack of "little-endian" doesn't equal BE.


> +
> +	priv->spacc.config.oldtimer = oldtimer;
> +
> +	if (of_property_read_u64(pdev->dev.of_node, "spacc-wdtimer", &timer)) {
> +		dev_dbg(&pdev->dev, "No spacc wdtimer specified\n");
> +		dev_dbg(&pdev->dev, "Default wdtimer: (100000)\n");
> +		timer = 100000;
> +	}
> +	priv->spacc.config.timer = timer;
> +
> +	baseaddr = devm_platform_get_and_ioremap_resource(pdev, 0, &mem);

You never use 'mem' that I see, so use devm_platform_ioremap_resource() 
instead.

> +	if (IS_ERR(baseaddr)) {
> +		dev_err(&pdev->dev, "unable to map iomem\n");
> +		err = PTR_ERR(baseaddr);
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	pdu_get_version(baseaddr, &info);
> +
> +	dev_dbg(&pdev->dev, "EPN %04X : virt [%d]\n",
> +				info.spacc_version.project,
> +				info.spacc_version.vspacc_idx);
> +
> +	/* Validate virtual spacc index with vspacc count read from
> +	 * VERSION_EXT.VSPACC_CNT. Thus vspacc count=3, gives valid index 0,1,2
> +	 */
> +	if (vspacc_idx != info.spacc_version.vspacc_idx) {
> +		dev_err(&pdev->dev, "DTS vspacc_idx mismatch read value\n");
> +		err = -EINVAL;
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	if (vspacc_idx < 0 || vspacc_idx > (info.spacc_config.num_vspacc - 1)) {
> +		dev_err(&pdev->dev, "Invalid vspacc index specified\n");
> +		err = -EINVAL;
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	err = spacc_init(baseaddr, &priv->spacc, &info);
> +	if (err != CRYPTO_OK) {
> +		dev_err(&pdev->dev, "Failed to initialize device %d\n", x);
> +		err = -ENXIO;
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	spin_lock_init(&priv->hw_lock);
> +	spacc_irq_glbl_disable(&priv->spacc);
> +	tasklet_init(&priv->pop_jobs, spacc_pop_jobs, (unsigned long)priv);
> +
> +	priv->spacc.dptr = &pdev->dev;
> +	platform_set_drvdata(pdev, priv);
> +
> +	irq_num = platform_get_irq(pdev, 0);
> +	if (irq_num < 0) {
> +		dev_err(&pdev->dev, "no irq resource for spacc\n");
> +		err = -ENXIO;
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	/* Determine configured maximum message length. */
> +	priv->max_msg_len = priv->spacc.config.max_msg_size;
> +
> +	if (devm_request_irq(&pdev->dev, irq_num, spacc_irq_handler,
> +			     IRQF_SHARED, dev_name(&pdev->dev),
> +			     &pdev->dev)) {
> +		dev_err(&pdev->dev, "failed to request IRQ\n");
> +		err = -EBUSY;
> +		goto err_tasklet_kill;
> +	}
> +
> +	priv->spacc.irq_cb_stat = spacc_stat_process;
> +	priv->spacc.irq_cb_cmdx = spacc_cmd_process;
> +	oldmode			= priv->spacc.op_mode;
> +	priv->spacc.op_mode     = SPACC_OP_MODE_IRQ;
> +
> +	spacc_irq_stat_enable(&priv->spacc, 1);
> +	spacc_irq_cmdx_enable(&priv->spacc, 0, 1);
> +	spacc_irq_stat_wd_disable(&priv->spacc);
> +	spacc_irq_glbl_enable(&priv->spacc);
> +
> +
> +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AUTODETECT)
> +	err = spacc_autodetect(&priv->spacc);
> +	if (err < 0) {
> +		spacc_irq_glbl_disable(&priv->spacc);
> +		goto err_tasklet_kill;
> +	}
> +#else
> +	err = spacc_static_config(&priv->spacc);
> +	if (err < 0) {
> +		spacc_irq_glbl_disable(&priv->spacc);
> +		goto err_tasklet_kill;
> +	}
> +#endif
> +
> +	priv->spacc.op_mode = oldmode;
> +
> +	if (priv->spacc.op_mode == SPACC_OP_MODE_IRQ) {
> +		priv->spacc.irq_cb_stat = spacc_stat_process;
> +		priv->spacc.irq_cb_cmdx = spacc_cmd_process;
> +
> +		spacc_irq_stat_enable(&priv->spacc, 1);
> +		spacc_irq_cmdx_enable(&priv->spacc, 0, 1);
> +		spacc_irq_glbl_enable(&priv->spacc);
> +	} else {
> +		priv->spacc.irq_cb_stat = spacc_stat_process;
> +		priv->spacc.irq_cb_stat_wd = spacc_stat_process;
> +
> +		spacc_irq_stat_enable(&priv->spacc,
> +				      priv->spacc.config.ideal_stat_level);
> +
> +		spacc_irq_cmdx_disable(&priv->spacc, 0);
> +		spacc_irq_stat_wd_enable(&priv->spacc);
> +		spacc_irq_glbl_enable(&priv->spacc);
> +
> +		/* enable the wd by setting the wd_timer = 100000 */
> +		spacc_set_wd_count(&priv->spacc,
> +				   priv->spacc.config.wd_timer =
> +						priv->spacc.config.timer);
> +	}
> +
> +	/* unlock normal*/
> +	if (priv->spacc.config.is_secure_port) {
> +		u32 t;
> +
> +		t = readl(baseaddr + SPACC_REG_SECURE_CTRL);
> +		t &= ~(1UL << 31);
> +		writel(t, baseaddr + SPACC_REG_SECURE_CTRL);
> +	}
> +
> +	/* unlock device by default */
> +	writel(0, baseaddr + SPACC_REG_SECURE_CTRL);

So writel/readl are always little endian (because PCI is always LE). 
Either you aren't handling endianness or you are using "little-endian" 
to refer to something else besides the registers?

> +
> +	return err;
> +
> +err_tasklet_kill:
> +	tasklet_kill(&priv->pop_jobs);
> +	spacc_fini(&priv->spacc);
> +
> +free_ddt_mem_pool:
> +	pdu_mem_deinit(&pdev->dev);
> +
> +	return err;
> +}
> +
> +static void spacc_unregister_algs(void)
> +{
> +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_HASH)
> +	spacc_unregister_hash_algs();
> +#endif
> +#if  IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AEAD)
> +	spacc_unregister_aead_algs();
> +#endif
> +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_CIPHER)
> +	spacc_unregister_cipher_algs();
> +#endif
> +}
> +
> +
> +static int spacc_crypto_probe(struct platform_device *pdev)
> +{
> +	int rc;
> +
> +	rc = spacc_init_device(pdev);
> +	if (rc < 0)
> +		goto err;
> +
> +	spacc_pdev[0] = pdev;

You have an array of devices, but always write to index 0?

> +
> +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_HASH)
> +	rc = probe_hashes(pdev);
> +	if (rc < 0)
> +		goto err;
> +#endif
> +
> +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_CIPHER)
> +	rc = probe_ciphers(pdev);
> +	if (rc < 0)
> +		goto err;
> +#endif
> +
> +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AEAD)
> +	rc = probe_aeads(pdev);
> +	if (rc < 0)
> +		goto err;
> +#endif
> +
> +	return 0;
> +err:
> +	spacc_unregister_algs();
> +
> +	return rc;
> +}
> +
> +static void spacc_crypto_remove(struct platform_device *pdev)
> +{
> +	spacc_unregister_algs();
> +	spacc_remove(pdev);
> +}
> +
> +static struct platform_driver spacc_driver = {
> +	.probe  = spacc_crypto_probe,
> +	.remove = spacc_crypto_remove,
> +	.driver = {
> +		.name  = "spacc",
> +		.of_match_table = snps_spacc_id,
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +module_platform_driver(spacc_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Synopsys, Inc.");
> +MODULE_DESCRIPTION("SPAcc Crypto Accelerator Driver");
> diff --git a/drivers/crypto/dwc-spacc/spacc_device.h b/drivers/crypto/dwc-spacc/spacc_device.h
> new file mode 100644
> index 000000000000..2223c3cfcf18
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_device.h
> @@ -0,0 +1,228 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef SPACC_DEVICE_H_
> +#define SPACC_DEVICE_H_
> +
> +#include <crypto/hash.h>
> +#include <crypto/ctr.h>
> +#include <crypto/internal/aead.h>
> +#include <linux/of.h>
> +#include "spacc_core.h"
> +
> +#define MODE_TAB_AEAD(_name, _ciph, _hash, _hashlen, _ivlen, _blocklen) \
> +	.name = _name, .aead = { .ciph = _ciph, .hash = _hash }, \
> +	.hashlen = _hashlen, .ivlen = _ivlen, .blocklen = _blocklen
> +
> +/* Helper macros for initializing the hash/cipher tables. */
> +#define MODE_TAB_COMMON(_name, _id_name, _blocklen) \
> +	.name = _name, .id = CRYPTO_MODE_##_id_name, .blocklen = _blocklen
> +
> +#define MODE_TAB_HASH(_name, _id_name, _hashlen, _blocklen) \
> +	MODE_TAB_COMMON(_name, _id_name, _blocklen), \
> +	.hashlen = _hashlen, .testlen = _hashlen
> +
> +#define MODE_TAB_CIPH(_name, _id_name, _ivlen, _blocklen) \
> +	MODE_TAB_COMMON(_name, _id_name, _blocklen), \
> +	.ivlen = _ivlen
> +
> +#define MODE_TAB_HASH_XCBC	0x8000
> +
> +#define SPACC_MAX_DIGEST_SIZE	64
> +#define SPACC_MAX_KEY_SIZE	32
> +#define SPACC_MAX_IV_SIZE	16
> +
> +#define SPACC_DMA_ALIGN		4
> +#define SPACC_DMA_BOUNDARY	0x10000
> +
> +#define MAX_DEVICES		2
> +/* flag means the IV is computed from setkey and crypt*/
> +#define SPACC_MANGLE_IV_FLAG	0x8000
> +
> +/* we're doing a CTR mangle (for RFC3686/IPsec)*/
> +#define SPACC_MANGLE_IV_RFC3686	0x0100
> +
> +/* we're doing GCM */
> +#define SPACC_MANGLE_IV_RFC4106	0x0200
> +
> +/* we're doing GMAC */
> +#define SPACC_MANGLE_IV_RFC4543	0x0300
> +
> +/* we're doing CCM */
> +#define SPACC_MANGLE_IV_RFC4309	0x0400
> +
> +/* we're doing SM4 GCM/CCM */
> +#define SPACC_MANGLE_IV_RFC8998	0x0500
> +
> +#define CRYPTO_MODE_AES_CTR_RFC3686 (CRYPTO_MODE_AES_CTR \
> +		| SPACC_MANGLE_IV_FLAG \
> +		| SPACC_MANGLE_IV_RFC3686)
> +#define CRYPTO_MODE_AES_GCM_RFC4106 (CRYPTO_MODE_AES_GCM \
> +		| SPACC_MANGLE_IV_FLAG \
> +		| SPACC_MANGLE_IV_RFC4106)
> +#define CRYPTO_MODE_AES_GCM_RFC4543 (CRYPTO_MODE_AES_GCM \
> +		| SPACC_MANGLE_IV_FLAG \
> +		| SPACC_MANGLE_IV_RFC4543)
> +#define CRYPTO_MODE_AES_CCM_RFC4309 (CRYPTO_MODE_AES_CCM \
> +		| SPACC_MANGLE_IV_FLAG \
> +		| SPACC_MANGLE_IV_RFC4309)
> +#define CRYPTO_MODE_SM4_GCM_RFC8998 (CRYPTO_MODE_SM4_GCM)
> +#define CRYPTO_MODE_SM4_CCM_RFC8998 (CRYPTO_MODE_SM4_CCM)
> +
> +struct spacc_crypto_ctx {
> +	struct device *dev;
> +
> +	spinlock_t lock;
> +	struct list_head jobs;
> +	int handle, mode, auth_size, key_len;
> +	unsigned char *cipher_key;
> +
> +	/*
> +	 * Indicates that the H/W context has been setup and can be used for
> +	 * crypto; otherwise, the software fallback will be used.
> +	 */
> +	bool ctx_valid;
> +	unsigned int flag_ppp;
> +
> +	/* salt used for rfc3686/givencrypt mode */
> +	unsigned char csalt[16];
> +	u8 ipad[128] __aligned(sizeof(u32));
> +	u8 digest_ctx_buf[128] __aligned(sizeof(u32));
> +	u8 tmp_buffer[128] __aligned(sizeof(u32));
> +
> +	/* Save keylen from setkey */
> +	int keylen;
> +	u8  key[256];
> +	int zero_key;
> +	unsigned char *tmp_sgl_buff;
> +	struct scatterlist *tmp_sgl;
> +
> +	union{
> +		struct crypto_ahash      *hash;
> +		struct crypto_aead       *aead;
> +		struct crypto_skcipher   *cipher;
> +	} fb;
> +};
> +
> +struct spacc_crypto_reqctx {
> +	struct pdu_ddt src, dst;
> +	void *digest_buf, *iv_buf;
> +	dma_addr_t digest_dma;
> +	int dst_nents, src_nents, aead_nents, total_nents;
> +	int encrypt_op, mode, single_shot;
> +	unsigned int spacc_cipher_cryptlen, rem_nents;
> +
> +	struct aead_cb_data {
> +		int new_handle;
> +		struct spacc_crypto_ctx    *tctx;
> +		struct spacc_crypto_reqctx *ctx;
> +		struct aead_request        *req;
> +		struct spacc_device        *spacc;
> +	} cb;
> +
> +	struct ahash_cb_data {
> +		int new_handle;
> +		struct spacc_crypto_ctx    *tctx;
> +		struct spacc_crypto_reqctx *ctx;
> +		struct ahash_request       *req;
> +		struct spacc_device        *spacc;
> +	} acb;
> +
> +	struct cipher_cb_data {
> +		int new_handle;
> +		struct spacc_crypto_ctx    *tctx;
> +		struct spacc_crypto_reqctx *ctx;
> +		struct skcipher_request    *req;
> +		struct spacc_device        *spacc;
> +	} ccb;
> +
> +	union {
> +		struct ahash_request hash_req;
> +		struct skcipher_request cipher_req;
> +		struct aead_request aead_req;
> +	} fb;
> +};
> +
> +struct mode_tab {
> +	char name[128];
> +
> +	int valid;
> +
> +	/* mode ID used in hash/cipher mode but not aead*/
> +	int id;
> +
> +	/* ciph/hash mode used in aead */
> +	struct {
> +		int ciph, hash;
> +	} aead;
> +
> +	unsigned int hashlen, ivlen, blocklen, keylen[3];
> +	unsigned int keylen_mask, testlen;
> +	unsigned int chunksize, walksize, min_keysize, max_keysize;
> +
> +	bool sw_fb;
> +
> +	union {
> +		unsigned char hash_test[SPACC_MAX_DIGEST_SIZE];
> +		unsigned char ciph_test[3][2 * SPACC_MAX_IV_SIZE];
> +	};
> +};
> +
> +struct spacc_alg {
> +	struct mode_tab *mode;
> +	unsigned int keylen_mask;
> +
> +	struct device *dev[MAX_DEVICES];
> +
> +	struct list_head list;
> +	struct crypto_alg *calg;
> +	struct crypto_tfm *tfm;
> +
> +	union {
> +		struct ahash_alg hash;
> +		struct aead_alg aead;
> +		struct skcipher_alg skcipher;
> +	} alg;
> +};
> +
> +static inline const struct spacc_alg *spacc_tfm_ahash(struct crypto_tfm *tfm)
> +{
> +	const struct crypto_alg *calg = tfm->__crt_alg;
> +
> +	if ((calg->cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_AHASH)
> +		return container_of(calg, struct spacc_alg, alg.hash.halg.base);
> +
> +	return NULL;
> +}
> +
> +static inline const struct spacc_alg *spacc_tfm_skcipher(struct crypto_tfm *tfm)
> +{
> +	const struct crypto_alg *calg = tfm->__crt_alg;
> +
> +	if ((calg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
> +					CRYPTO_ALG_TYPE_SKCIPHER)
> +		return container_of(calg, struct spacc_alg, alg.skcipher.base);
> +
> +	return NULL;
> +}
> +
> +static inline const struct spacc_alg *spacc_tfm_aead(struct crypto_tfm *tfm)
> +{
> +	const struct crypto_alg *calg = tfm->__crt_alg;
> +
> +	if ((calg->cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_AEAD)
> +		return container_of(calg, struct spacc_alg, alg.aead.base);
> +
> +	return NULL;
> +}
> +
> +int probe_hashes(struct platform_device *spacc_pdev);
> +int spacc_unregister_hash_algs(void);
> +
> +int probe_aeads(struct platform_device *spacc_pdev);
> +int spacc_unregister_aead_algs(void);
> +
> +int probe_ciphers(struct platform_device *spacc_pdev);
> +int spacc_unregister_cipher_algs(void);
> +
> +irqreturn_t spacc_irq_handler(int irq, void *dev);
> +#endif
> diff --git a/drivers/crypto/dwc-spacc/spacc_hal.c b/drivers/crypto/dwc-spacc/spacc_hal.c
> new file mode 100644
> index 000000000000..0d460c4df542
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_hal.c
> @@ -0,0 +1,367 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/dmapool.h>
> +#include <linux/dma-mapping.h>
> +#include "spacc_hal.h"
> +
> +static struct dma_pool *ddt_pool, *ddt16_pool, *ddt4_pool;
> +static struct device *ddt_device;
> +
> +#define PDU_REG_SPACC_VERSION   0x00180UL
> +#define PDU_REG_SPACC_CONFIG    0x00184UL
> +#define PDU_REG_SPACC_CONFIG2   0x00190UL
> +#define PDU_REG_SPACC_IV_OFFSET 0x00040UL
> +#define PDU_REG_PDU_CONFIG      0x00188UL
> +#define PDU_REG_SECURE_LOCK     0x001C0UL
> +
> +int pdu_get_version(void __iomem *dev, struct pdu_info *inf)
> +{
> +	unsigned long tmp;
> +
> +	if (!inf)
> +		return -1;
> +
> +	memset(inf, 0, sizeof(*inf));
> +	tmp = readl(dev + PDU_REG_SPACC_VERSION);
> +
> +	/* Read the SPAcc version block this tells us the revision,
> +	 * project, and a few other feature bits
> +	 *
> +	 * layout for v6.5+
> +	 */
> +	inf->spacc_version = (struct spacc_version_block) {
> +		.minor      = SPACC_ID_MINOR(tmp),
> +		.major      = SPACC_ID_MAJOR(tmp),
> +		.version    = (SPACC_ID_MAJOR(tmp) << 4) | SPACC_ID_MINOR(tmp),
> +		.qos        = SPACC_ID_QOS(tmp),
> +		.is_spacc   = SPACC_ID_TYPE(tmp) == SPACC_TYPE_SPACCQOS,
> +		.is_pdu     = SPACC_ID_TYPE(tmp) == SPACC_TYPE_PDU,
> +		.aux        = SPACC_ID_AUX(tmp),
> +		.vspacc_idx = SPACC_ID_VIDX(tmp),
> +		.partial    = SPACC_ID_PARTIAL(tmp),
> +		.project    = SPACC_ID_PROJECT(tmp),
> +	};
> +
> +	/* try to autodetect */
> +	writel(0x80000000, dev + PDU_REG_SPACC_IV_OFFSET);
> +
> +	if (readl(dev + PDU_REG_SPACC_IV_OFFSET) == 0x80000000)
> +		inf->spacc_version.ivimport = 1;
> +	else
> +		inf->spacc_version.ivimport = 0;
> +
> +
> +	/* Read the SPAcc config block (v6.5+) which tells us how many
> +	 * contexts there are and context page sizes
> +	 * this register is only available in v6.5 and up
> +	 */
> +	tmp = readl(dev + PDU_REG_SPACC_CONFIG);
> +	inf->spacc_config = (struct spacc_config_block) {
> +		SPACC_CFG_CTX_CNT(tmp),
> +		SPACC_CFG_VSPACC_CNT(tmp),
> +		SPACC_CFG_CIPH_CTX_SZ(tmp),
> +		SPACC_CFG_HASH_CTX_SZ(tmp),
> +		SPACC_CFG_DMA_TYPE(tmp),
> +		0, 0, 0, 0
> +	};
> +
> +	/* CONFIG2 only present in v6.5+ cores */
> +	tmp = readl(dev + PDU_REG_SPACC_CONFIG2);
> +	if (inf->spacc_version.qos) {
> +		inf->spacc_config.cmd0_fifo_depth =
> +				SPACC_CFG_CMD0_FIFO_QOS(tmp);
> +		inf->spacc_config.cmd1_fifo_depth =
> +				SPACC_CFG_CMD1_FIFO(tmp);
> +		inf->spacc_config.cmd2_fifo_depth =
> +				SPACC_CFG_CMD2_FIFO(tmp);
> +		inf->spacc_config.stat_fifo_depth =
> +				SPACC_CFG_STAT_FIFO_QOS(tmp);
> +	} else {
> +		inf->spacc_config.cmd0_fifo_depth =
> +				SPACC_CFG_CMD0_FIFO(tmp);
> +		inf->spacc_config.stat_fifo_depth =
> +				SPACC_CFG_STAT_FIFO(tmp);
> +	}
> +
> +	/* only read PDU config if it's actually a PDU engine */
> +	if (inf->spacc_version.is_pdu) {
> +		tmp = readl(dev + PDU_REG_PDU_CONFIG);
> +		inf->pdu_config = (struct pdu_config_block)
> +			{SPACC_PDU_CFG_MINOR(tmp),
> +			 SPACC_PDU_CFG_MAJOR(tmp)};
> +
> +		/* unlock all cores by default */
> +		writel(0, dev + PDU_REG_SECURE_LOCK);
> +	}
> +
> +	return 0;
> +}
> +
> +void pdu_to_dev(void __iomem *addr_, uint32_t *src, unsigned long nword)
> +{
> +	void __iomem *addr = addr_;
> +
> +	while (nword--) {
> +		writel(*src++, addr);
> +		addr += 4;
> +	}
> +}
> +
> +void pdu_from_dev(u32 *dst, void __iomem *addr_, unsigned long nword)
> +{
> +	void __iomem *addr = addr_;
> +
> +	while (nword--) {
> +		*dst++ = readl(addr);
> +		addr += 4;
> +	}
> +}
> +
> +static void pdu_to_dev_big(void __iomem *addr_, const unsigned char *src,
> +			   unsigned long nword)
> +{
> +	unsigned long v;
> +	void __iomem *addr = addr_;
> +
> +	while (nword--) {
> +		v = 0;
> +		v = (v << 8) | ((unsigned long)*src++);
> +		v = (v << 8) | ((unsigned long)*src++);
> +		v = (v << 8) | ((unsigned long)*src++);
> +		v = (v << 8) | ((unsigned long)*src++);

The kernel has helpers for endian conversion and types that define 
endianness of buffers (e.g. __be32). Use them.

> +		writel(v, addr);
> +		addr += 4;
> +	}
> +}
