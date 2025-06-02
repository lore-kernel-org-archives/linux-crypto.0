Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720CB101EE;
	Mon,  2 Jun 2025 06:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748844328; cv=none; b=s1P8/ENR728rPG36fV96zrJzzvWThPbfLsydb0HY9gC5UTF3SI4lickycTh+wozcZ4kiuddV2AV/KJUUesOfMQL2rfXIHFsiD7zU7edmzz94NAnm+UB2wQept/SAh0jTHXzE+SaFqcqjTViOu4xMZsp12TWEgaCrRZ494MrYmnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748844328; c=relaxed/simple;
	bh=G96Zhnpaq7UecF5ktVyL1Wx1CNqxXE3R3mtYh1g4Ybc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rlqbcRLiQpRejRiXnyGh1tZkse9YChPx2T130vUk1W3pyJen00ZCOW9MsZhnjVOCiht07DOqFGINlb0vVz1YmKdCoyfOPRi2Dvsoe1ZdL16pyLMOKYvsADaOBiTIwpUxcXC0OvTlpSJ7V9lIuPRpyiGlT6yPDf5m1ulCJyr+Fj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=deZc2yLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="deZc2yLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC43FC4CEEB;
	Mon,  2 Jun 2025 06:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748844327;
	bh=G96Zhnpaq7UecF5ktVyL1Wx1CNqxXE3R3mtYh1g4Ybc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=deZc2yLk4PCnoOnCcirEhEMpMr96X3FfFg2avXQl3BjNRrhKJXWO9ZETc8EW67MpI
	 jxtZOTNU7oWwCAwiEuTq3a/rWO5IK+R1N+8i+RhIa+JerH/c1dY0F9LN+uZuHjaEYG
	 QPjorpBWazmHA01+ZgJZWc+DeB8Bk4lF6+LXqZBM6z04QMPEeK90tWYtudZuYdo78L
	 06MzKRYLBlAuURNu38vKZvgl+AVk5jUj99BVkoLrTp3JpgBer1WPstsDiHJrdIBZ3s
	 0UBIC0BTSQfBr4jtVditHgRadw1S8k02f9QesQKrQxrnPOmQavCzmJOmMOJxj1q5wq
	 /8nCe772Onw9g==
Message-ID: <9f6b4442-1fb0-479d-9514-410d4d8bfd98@kernel.org>
Date: Mon, 2 Jun 2025 08:05:23 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] Add SPAcc Skcipher support
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org
Cc: krzk+dt@kernel.org, conor+dt@kernel.org, Ruud.Derwig@synopsys.com,
 manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com,
 Shweta Raikar <shwetar@vayavyalabs.com>
References: <20250602053231.403143-1-pavitrakumarm@vayavyalabs.com>
 <20250602053231.403143-3-pavitrakumarm@vayavyalabs.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <20250602053231.403143-3-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/06/2025 07:32, Pavitrakumar Managutte wrote:
> +
> +static int spacc_init_device(struct platform_device *pdev)
> +{
> +	int vspacc_id = -1;
> +	u64 timer = 100000;
> +	void __iomem *baseaddr;
> +	struct pdu_info   info;
> +	struct spacc_priv *priv;
> +	int err = 0;
> +	int oldmode;
> +	int irq_num;
> +	const u64 oldtimer = 100000;
> +
> +	/* initialize DDT DMA pools based on this device's resources */
> +	if (pdu_mem_init(&pdev->dev)) {
> +		dev_err(&pdev->dev, "Could not initialize DMA pools\n");
> +		return -ENOMEM;
> +	}
> +
> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv) {
> +		err = -ENOMEM;
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	/* default to little-endian */
> +	priv->spacc.config.big_endian	 = false;
> +	priv->spacc.config.little_endian = true;
> +
> +	if (of_property_read_u32(pdev->dev.of_node, "snps,vspacc-id",
> +				 &vspacc_id)) {
> +		dev_err(&pdev->dev, "No virtual spacc id specified\n");

This makes no sense. It's not a required property. Just look at your
binding.

> +		err = -EINVAL;
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	priv->spacc.config.idx = vspacc_id;
> +	priv->spacc.config.oldtimer = oldtimer;
> +
> +	if (of_property_read_u64(pdev->dev.of_node, "spacc-internal-counter",

You never tested this.

> +				 &timer)) {
> +		dev_dbg(&pdev->dev, "No spacc-internal-counter specified\n");
> +		dev_dbg(&pdev->dev, "Default internal-counter: (100000)\n");
> +		timer = 100000;
> +	}
> +	priv->spacc.config.timer = timer;
> +
> +	baseaddr = devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(baseaddr)) {
> +		dev_err(&pdev->dev, "Unable to map iomem\n");
> +		err = PTR_ERR(baseaddr);
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	pdu_get_version(baseaddr, &info);
> +
> +	dev_dbg(&pdev->dev, "EPN %04X : virt [%d]\n",
> +		info.spacc_version.project,
> +		info.spacc_version.vspacc_id);
> +
> +	/*
> +	 * Validate virtual spacc index with vspacc count read from
> +	 * VERSION_EXT.VSPACC_CNT. Thus vspacc count=3, gives valid index 0,1,2
> +	 */
> +	if (vspacc_id != info.spacc_version.vspacc_id) {
> +		dev_err(&pdev->dev, "DTS vspacc_id mismatch read value\n");
> +		err = -EINVAL;
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	if (vspacc_id < 0 || vspacc_id > (info.spacc_config.num_vspacc - 1)) {
> +		dev_err(&pdev->dev, "Invalid vspacc index specified\n");
> +		err = -EINVAL;
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	err = spacc_init(baseaddr, &priv->spacc, &info);
> +	if (err != 0) {
> +		dev_err(&pdev->dev, "Failed to initialize SPAcc device\n");
> +		err = -ENXIO;

No, use real errors.

> +		goto free_ddt_mem_pool;
> +	}
> +
> +	/* Set the priority from kernel config */
> +	priv->spacc.config.priority = CONFIG_CRYPTO_DEV_SPACC_PRIORITY;
> +	dev_dbg(&pdev->dev, "VSPACC priority set from config: %u\n",
> +		priv->spacc.config.priority);
> +
> +	/* Set the priority for this virtual SPAcc instance */
> +	spacc_set_priority(&priv->spacc, priv->spacc.config.priority);
> +
> +	priv->spacc_wq = alloc_workqueue("spacc_workqueue", WQ_UNBOUND, 0);
> +	if (!priv->spacc_wq) {
> +		dev_err(&pdev->dev, "failed to allocated workqueue\n");

Memory allocations NEVER result in error messages.

Please run standard kernel tools for static analysis, like coccinelle,
smatch and sparse, and fix reported warnings. Also please check for
warnings when building with W=1 for gcc and clang. Most of these
commands (checks or W=1 build) can build specific targets, like some
directory, to narrow the scope to only your code. The code here looks
like it needs a fix. Feel free to get in touch if the warning is not clear.

> +		err = -ENOMEM;
> +		goto free_spacc_ctx;
> +	}
> +
> +	spacc_irq_glbl_disable(&priv->spacc);
> +	INIT_WORK(&priv->pop_jobs, spacc_pop_jobs);
> +
> +	priv->spacc.dptr = &pdev->dev;
> +	platform_set_drvdata(pdev, priv);
> +
> +	irq_num = platform_get_irq(pdev, 0);
> +	if (irq_num < 0) {
> +		dev_err(&pdev->dev, "No irq resource for spacc\n");
> +		err = -ENXIO;

No, you must use actual error code.

> +		goto free_spacc_workq;
> +	}
> +
> +	/* determine configured maximum message length */
> +	priv->max_msg_len = priv->spacc.config.max_msg_size;
> +
> +	if (devm_request_irq(&pdev->dev, irq_num, spacc_irq_handler,
> +			     IRQF_SHARED, dev_name(&pdev->dev),
> +			     &pdev->dev)) {
> +		dev_err(&pdev->dev, "Failed to request IRQ\n");
> +		err = -EBUSY;

No, you must use actual error code.

> +		goto free_spacc_workq;
> +	}
> +
> +	priv->spacc.irq_cb_stat = spacc_stat_process;
> +	priv->spacc.irq_cb_cmdx = spacc_cmd_process;
> +	oldmode			= priv->spacc.op_mode;
> +	priv->spacc.op_mode     = SPACC_OP_MODE_IRQ;
> +
> +	/* Enable STAT and CMD interrupts */
> +	spacc_irq_stat_enable(&priv->spacc, 1);
> +	spacc_irq_cmdx_enable(&priv->spacc, 0, 1);
> +	spacc_irq_stat_wd_disable(&priv->spacc);
> +	spacc_irq_glbl_enable(&priv->spacc);
> +
> +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AUTODETECT)

Drop all such conditionals from the code.

> +
> +	err = spacc_autodetect(&priv->spacc);
> +	if (err < 0) {
> +		spacc_irq_glbl_disable(&priv->spacc);
> +		goto free_spacc_workq;
> +	}
> +#else
> +	err = spacc_static_config(&priv->spacc);
> +	if (err < 0) {
> +		spacc_irq_glbl_disable(&priv->spacc);
> +		goto free_spacc_workq;
> +	}
> +#endif
> +
> +	priv->spacc.op_mode = oldmode;
> +	if (priv->spacc.op_mode == SPACC_OP_MODE_IRQ) {
> +		priv->spacc.irq_cb_stat = spacc_stat_process;
> +		priv->spacc.irq_cb_cmdx = spacc_cmd_process;
> +
> +		/* Enable STAT and CMD interrupts */
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
> +		/* Enable STAT and WD interrupts */
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
> +	/* unlock normal */
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
> +free_spacc_workq:
> +	flush_workqueue(priv->spacc_wq);
> +	destroy_workqueue(priv->spacc_wq);
> +
> +free_spacc_ctx:
> +	spacc_fini(&priv->spacc);
> +
> +free_ddt_mem_pool:
> +	pdu_mem_deinit(&pdev->dev);
> +
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
> +static int spacc_crypto_probe(struct platform_device *pdev)
> +{
> +	int rc = 0;
> +
> +	rc = spacc_init_device(pdev);
> +	if (rc < 0)
> +		goto err;
> +
> +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_HASH)
> +	rc = spacc_probe_hashes(pdev);
> +	if (rc < 0)
> +		goto err;
> +#endif
> +
> +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_CIPHER)
> +	rc = spacc_probe_ciphers(pdev);
> +	if (rc < 0)
> +		goto err;
> +#endif
> +
> +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AEAD)
> +	rc = spacc_probe_aeads(pdev);
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
> +	struct spacc_priv *priv = platform_get_drvdata(pdev);
> +
> +	if (priv->spacc_wq) {
> +		flush_workqueue(priv->spacc_wq);
> +		destroy_workqueue(priv->spacc_wq);
> +	}
> +
> +	spacc_unregister_algs();
> +	spacc_remove(pdev);
> +}
> +
> +static const struct of_device_id snps_spacc_id[] = {
> +	{.compatible = "snps,nsimosci-hs-spacc" },
> +	{ /* sentinel */        }
> +};
> +
> +MODULE_DEVICE_TABLE(of, snps_spacc_id);
> +
> +static struct platform_driver spacc_driver = {
> +	.probe  = spacc_crypto_probe,
> +	.remove = spacc_crypto_remove,
> +	.driver = {
> +		.name  = "spacc",
> +		.of_match_table = snps_spacc_id,
> +		.owner = THIS_MODULE,

This is some ancient downstream code. Base your work (means START from)
a new, recent drivers. This was fixed many years ago.

Please run standard kernel tools for static analysis, like coccinelle,
smatch and sparse, and fix reported warnings. Also please check for
warnings when building with W=1 for gcc and clang. Most of these
commands (checks or W=1 build) can build specific targets, like some
directory, to narrow the scope to only your code. The code here looks
like it needs a fix. Feel free to get in touch if the warning is not clear.

> +	},
> +};
> +
> +module_platform_driver(spacc_driver);
> +


Best regards,
Krzysztof
