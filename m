Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3D91BF30B
	for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 16:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723825355; cv=none; b=iCYuFZRbUlL5M/bhnVp3NlJ9qm1kFA1jqu9hCE7KUJ83Nk0k8+9s2L9XyQt4RSNiRua3wx2eK7UIYYLLkz/GSKfe378Qt/2aJzpSV6Dgk+sJ02aYmDHL2nXz0PAJJ1lG6xTHEjbyasDiC+laWksJWczQYMUMZHAJjEtq9faFPVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723825355; c=relaxed/simple;
	bh=sZBja4wkItLUrN6o6lYSg43rS+4ul4kiry+37jeA8Hc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ir13ZVBJ/STHdlObVboa27N3zDwJb9uC0bItKUIBYlWwcYmqSQnPfoROKr0lKNgZNx7DJlOD103IFvPzy2kNBi+IZjhgrRCC7QxquXU0CAp9zlKWEFTpG5xxOqLu4Dj5EYWud3PaL8483kUceOyNo8IyiOr2KsFff1BAu093GUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MMZZhJmw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMZZhJmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6C2C4AF0F;
	Fri, 16 Aug 2024 16:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723825354;
	bh=sZBja4wkItLUrN6o6lYSg43rS+4ul4kiry+37jeA8Hc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MMZZhJmwiCEtyjPhLaaWisuV4WS54/bL3RPjZJwvpCzExmelWmb4kmV77mdeBrbzo
	 DTPNwaa5K/kLVR18g4bYxhMeiWPrHkG8V6QwczRghp//MUtKsMvM2z0kQnoPGSyY+K
	 gmejT/8rkr5mADuNBGTVCN4jbI4LAS/jqRRioH3wvSVZyoPOq+3u0BzZ5LIF13ruAn
	 HjT41ucjI6b5FIaOwZZrEHE+wpVwolKDcoeID7HVq4YtDgsiVtly0x0YUbpkPhzama
	 CcxUwmY8cs0g+UVjGFFhTOpRqlpBjEDPhTfBDaAtJUGWCBYR6o00GUjh5NsWaKnL4w
	 Q8DDXaDf3o7aw==
Date: Fri, 16 Aug 2024 10:22:33 -0600
From: Rob Herring <robh@kernel.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v7 1/6] Add SPAcc Skcipher support
Message-ID: <20240816162233.GA1466038-robh@kernel.org>
References: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
 <20240729041350.380633-2-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240729041350.380633-2-pavitrakumarm@vayavyalabs.com>

On Mon, Jul 29, 2024 at 09:43:45AM +0530, Pavitrakumar M wrote:
> Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
> Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>

Where's the commit message? 

Not even checkpatch.pl reviewed this patch. Why is it in linux-next?

> ---
>  drivers/crypto/dwc-spacc/spacc_core.c      | 1129 ++++++++++++++++++++
>  drivers/crypto/dwc-spacc/spacc_core.h      |  826 ++++++++++++++
>  drivers/crypto/dwc-spacc/spacc_device.c    |  340 ++++++
>  drivers/crypto/dwc-spacc/spacc_device.h    |  231 ++++
>  drivers/crypto/dwc-spacc/spacc_hal.c       |  367 +++++++
>  drivers/crypto/dwc-spacc/spacc_hal.h       |  114 ++
>  drivers/crypto/dwc-spacc/spacc_interrupt.c |  316 ++++++
>  drivers/crypto/dwc-spacc/spacc_manager.c   |  650 +++++++++++
>  drivers/crypto/dwc-spacc/spacc_skcipher.c  |  712 ++++++++++++
>  9 files changed, 4685 insertions(+)
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c


> +	writel(0, spacc->regmap + SPACC_REG_SRC_PTR);
> +	writel(0, spacc->regmap + SPACC_REG_DST_PTR);
> +	writel(0, spacc->regmap + SPACC_REG_PROC_LEN);
> +	writel(0, spacc->regmap + SPACC_REG_ICV_LEN);
> +	writel(0, spacc->regmap + SPACC_REG_PRE_AAD_LEN);

All these register accesses need synchronization with DMA? If not, use 
_relaxed variants.

[...]

> diff --git a/drivers/crypto/dwc-spacc/spacc_core.h b/drivers/crypto/dwc-spacc/spacc_core.h
> new file mode 100644
> index 000000000000..399b7c976151
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_core.h
> @@ -0,0 +1,826 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +
> +#ifndef SPACC_CORE_H_
> +#define SPACC_CORE_H_
> +
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/of_device.h>
> +#include <linux/dma-mapping.h>

Why does the header need these? Put them in the .c files and use forward 
declarations if needed. You shouldn't need of_device.h unless you are 
implementing a bus.

> +#include <crypto/skcipher.h>
> +#include "spacc_hal.h"

[...]

> diff --git a/drivers/crypto/dwc-spacc/spacc_device.c b/drivers/crypto/dwc-spacc/spacc_device.c
> new file mode 100644
> index 000000000000..a723aaf8784a
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_device.c
> @@ -0,0 +1,340 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/of_device.h>
> +#include <linux/module.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/platform_device.h>
> +#include "spacc_device.h"
> +
> +static struct platform_device *spacc_pdev[MAX_DEVICES];
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
> +
> +int spacc_probe(struct platform_device *pdev,
> +		const struct of_device_id snps_spacc_id[])
> +{
> +	int spacc_idx = -1;
> +	struct resource *mem;
> +	int spacc_endian = 0;
> +	void __iomem *baseaddr;
> +	struct pdu_info   info;
> +	int spacc_priority = -1;
> +	struct spacc_priv *priv;
> +	int x = 0, err, oldmode, irq_num;
> +	const struct of_device_id *match, *id;
> +	u64 oldtimer = 100000, timer = 100000;
> +
> +	if (pdev->dev.of_node) {

When do you not have a DT node?

> +		id = of_match_node(snps_spacc_id, pdev->dev.of_node);
> +		if (!id) {
> +			dev_err(&pdev->dev, "DT node did not match\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	/* Initialize DDT DMA pools based on this device's resources */
> +	if (pdu_mem_init(&pdev->dev)) {
> +		dev_err(&pdev->dev, "Could not initialize DMA pools\n");
> +		return -ENOMEM;
> +	}
> +
> +	match = of_match_device(of_match_ptr(snps_spacc_id), &pdev->dev);

Why are you matching a 2nd time? Really, it's the 3rd time, because you 
had to match to get to probe().

You have no match data, so there's 0 point in matching at all.

> +	if (!match) {
> +		dev_err(&pdev->dev, "SPAcc dtb missing");
> +		return -ENODEV;
> +	}
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
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
> +	if (of_property_read_u32(pdev->dev.of_node, "spacc_priority",
> +				 &spacc_priority)) {

None of these are documented nor do they match accepted form.

> +		dev_err(&pdev->dev, "No vspacc priority specified\n");
> +		err = -EINVAL;
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	if (spacc_priority < 0 && spacc_priority > VSPACC_PRIORITY_MAX) {
> +		dev_err(&pdev->dev, "Invalid vspacc priority\n");
> +		err = -EINVAL;
> +		goto free_ddt_mem_pool;
> +	}
> +	priv->spacc.config.priority = spacc_priority;
> +
> +	if (of_property_read_u32(pdev->dev.of_node, "spacc_index",
> +				 &spacc_idx)) {

We don't don't indexes in DT.

> +		dev_err(&pdev->dev, "No vspacc index specified\n");
> +		err = -EINVAL;
> +		goto free_ddt_mem_pool;
> +	}
> +	priv->spacc.config.idx = spacc_idx;
> +
> +	if (of_property_read_u32(pdev->dev.of_node, "spacc_endian",
> +				 &spacc_endian)) {
> +		dev_dbg(&pdev->dev, "No spacc_endian specified\n");
> +		dev_dbg(&pdev->dev, "Default spacc Endianness (0==little)\n");
> +		spacc_endian = 0;
> +	}
> +	priv->spacc.config.spacc_endian = spacc_endian;
> +
> +	if (of_property_read_u64(pdev->dev.of_node, "oldtimer",
> +				 &oldtimer)) {
> +		dev_dbg(&pdev->dev, "No oldtimer specified\n");
> +		dev_dbg(&pdev->dev, "Default oldtimer (100000)\n");
> +		oldtimer = 100000;
> +	}
> +	priv->spacc.config.oldtimer = oldtimer;
> +
> +	if (of_property_read_u64(pdev->dev.of_node, "timer", &timer)) {
> +		dev_dbg(&pdev->dev, "No timer specified\n");
> +		dev_dbg(&pdev->dev, "Default timer (100000)\n");
> +		timer = 100000;
> +	}
> +	priv->spacc.config.timer = timer;
> +
> +	baseaddr = devm_ioremap_resource(&pdev->dev, mem);

Use devm_platform_get_and_ioremap_resource() instead.

> +	if (IS_ERR(baseaddr)) {
> +		dev_err(&pdev->dev, "unable to map iomem\n");
> +		err = PTR_ERR(baseaddr);
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	pdu_get_version(baseaddr, &info);
> +	if (pdev->dev.platform_data) {
> +		struct pdu_info *parent_info = pdev->dev.platform_data;

platform_data is pretty much deprecated. Why do you need this.

> +
> +		memcpy(&info.pdu_config, &parent_info->pdu_config,
> +		       sizeof(info.pdu_config));
> +	}
> +
> +	dev_dbg(&pdev->dev, "EPN %04X : virt [%d]\n",
> +				info.spacc_version.project,
> +				info.spacc_version.vspacc_idx);
> +
> +	/* Validate virtual spacc index with vspacc count read from
> +	 * VERSION_EXT.VSPACC_CNT. Thus vspacc count=3, gives valid index 0,1,2
> +	 */
> +	if (spacc_idx != info.spacc_version.vspacc_idx) {
> +		dev_err(&pdev->dev, "DTS vspacc_idx mismatch read value\n");
> +		err = -EINVAL;
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	if (spacc_idx < 0 || spacc_idx > (info.spacc_config.num_vspacc - 1)) {
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
> +static const struct of_device_id snps_spacc_id[] = {
> +	{.compatible = "snps-dwc-spacc" },

This is not documented nor the correct form for compatible strings.

> +	{ /*sentinel */        }
> +};
> +
> +MODULE_DEVICE_TABLE(of, snps_spacc_id);
> +
> +static int spacc_crypto_probe(struct platform_device *pdev)
> +{
> +	int rc;
> +
> +	rc = spacc_probe(pdev, snps_spacc_id);

Where do you see any other driver do this? Get rid of this wrapper.


> +	if (rc < 0)
> +		goto err;
> +
> +	spacc_pdev[0] = pdev;
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
> +static int spacc_crypto_remove(struct platform_device *pdev)
> +{
> +	spacc_unregister_algs();
> +	spacc_remove(pdev);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver spacc_driver = {
> +	.probe  = spacc_crypto_probe,
> +	.remove = spacc_crypto_remove,
> +	.driver = {
> +		.name  = "spacc",
> +		.of_match_table = of_match_ptr(snps_spacc_id),

Don't need of_match_ptr().

> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +module_platform_driver(spacc_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Synopsys, Inc.");
> +MODULE_DESCRIPTION("SPAcc Crypto Accelerator Driver");
