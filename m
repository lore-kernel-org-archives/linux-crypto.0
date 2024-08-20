Received: from michel.telenet-ops.be (michel.telenet-ops.be [195.130.137.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521D018C324
	for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2024 09:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.137.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724146725; cv=none; b=mzRf1/MrSDsTBYNfD11Ef6SWjL3P8cU4UbzuXPtxzLJdtXPUoVUNwytN1sDhFE4ibVWfOM+Voe6h24qADtYrnrk4HvJkN9m6AaUGWlr0MnqautfsOkGBX1lLbLhtf5tX/zf71TwLnqR4RTvKQpuEB69gdW1Bpvqc7L3ZW06FWlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724146725; c=relaxed/simple;
	bh=paWZtgBvhp7Vcd9o1gKj5AoPY5sacgrHwJDRltdRJuo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=aA2KNzU4yJy17gpe7054Bi49WjYYzRuoW7lYKnndZ6Erpy7pr6ICR9lLPoq1gQio2IvIgerLw7whgc11Gw2sibUYDYL10gHXGJQTOXGXi/QUAMz8WkEnoGuoz+ejErZtd5Yo92y9xJ/+6sOtUs9wkjOmBjG1dGlshUS9OUw02VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.137.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:a2e4:464c:5828:2da3])
	by michel.telenet-ops.be with bizsmtp
	id 29eg2D0062WQTnu069egcj; Tue, 20 Aug 2024 11:38:41 +0200
Received: from geert (helo=localhost)
	by ramsan.of.borg with local-esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1sgLK4-000Mdw-0L;
	Tue, 20 Aug 2024 11:38:40 +0200
Date: Tue, 20 Aug 2024 11:38:39 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
    Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com, 
    bhoomikak@vayavyalabs.com, shwetar <shwetar@vayavyalabs.com>, 
    Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
    Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 1/7] Add SPAcc Skcipher support
In-Reply-To: <20240618042750.485720-2-pavitrakumarm@vayavyalabs.com>
Message-ID: <41ed1cd-1c1a-c38-5032-a997cd13179@linux-m68k.org>
References: <20240618042750.485720-1-pavitrakumarm@vayavyalabs.com> <20240618042750.485720-2-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

 	Hi Pavitrakumar,

CC devicetree

On Tue, 18 Jun 2024, Pavitrakumar M wrote:
> Signed-off-by: shwetar <shwetar@vayavyalabs.com>
> Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>

Thanks for your patch, which is now commit fc61c658c94cb740 ("crypto:
spacc - Enable Driver compilation in crypto Kconfig and Makefile")
in crypto/master.

> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_core.c
> +int spacc_probe(struct platform_device *pdev,
> +		const struct of_device_id snps_spacc_id[])

There should not be a need to pass snps_spacc_id[] around.

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
> +		id = of_match_node(snps_spacc_id, pdev->dev.of_node);
> +		if (!id) {
> +			dev_err(&pdev->dev, "DT node did not match\n");
> +			return -EINVAL;
> +		}
> +	}

This check is not needed.

> +
> +	/* Initialize DDT DMA pools based on this device's resources */
> +	if (pdu_mem_init(&pdev->dev)) {
> +		dev_err(&pdev->dev, "Could not initialize DMA pools\n");
> +		return -ENOMEM;
> +	}
> +
> +	match = of_match_device(of_match_ptr(snps_spacc_id), &pdev->dev);
> +	if (!match) {
> +		dev_err(&pdev->dev, "SPAcc dtb missing");
> +		return -ENODEV;
> +	}

This check is also not needed.
Besides, in case of an error, you leak the ddt mem pool.

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

Please no underscores in DT properties.

> +				 &spacc_priority)) {
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
> +		dev_err(&pdev->dev, "No vspacc index specified\n");
> +		err = -EINVAL;
> +		goto free_ddt_mem_pool;
> +	}
> +	priv->spacc.config.idx = spacc_idx;
> +
> +	if (of_property_read_u32(pdev->dev.of_node, "spacc_endian",

Please use the standard big-endian / little-endian properties.

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

This device lacks DT binding documentation.

> +static struct platform_driver spacc_driver = {
> +	.probe  = spacc_crypto_probe,
> +	.remove = spacc_crypto_remove,
> +	.driver = {
> +		.name  = "spacc",
> +		.of_match_table = of_match_ptr(snps_spacc_id),

Please drop the of_match_ptr(), as your driver requires DT to function.

> +		.owner = THIS_MODULE,
> +	},
> +};

I didn't review the rest.

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
