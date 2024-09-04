Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4E482C7E
	for <linux-crypto@vger.kernel.org>; Wed,  4 Sep 2024 06:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725430171; cv=none; b=YCcgu2pQVSFfYkL2ATL7BJcb9jbFYc7VgU2DKlapF/KWXpGN3IDdK+uqqjKjAW94R37uJoS3YOsKh3haxOok1uuyTZxy6glI7YO5Xe/kg+vMGfOziQ5T89e6S+wpy6cSocLF1F1wNhMMMgjti6BJYQpTdvJZrsfkrwF1OzROZ1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725430171; c=relaxed/simple;
	bh=uaMj4LSVBYFyFfTvdkA8cZz8W+d28sCmWJ7S+8vv820=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PybN1DK+XICVqOzyzlvGzuSdpNh2Fa5Fn/4KVhX6+cxg/J5BvlhmJybGRJSxS2FmA8mzCvNUYOUZFeBKoqG1MhRY4hWlTVTkP1guqGofYDTllzbtAbt7ReeVKw5g90oo0GW6EfA/rE08RnJTv8PgfgLBdSPGNl6UXQX0/w6GXjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RPpfOy7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RPpfOy7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1138C4CEC2;
	Wed,  4 Sep 2024 06:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725430171;
	bh=uaMj4LSVBYFyFfTvdkA8cZz8W+d28sCmWJ7S+8vv820=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RPpfOy7Cy5xUAsu76xSP0M6YAu3nWbQAFvpXFo5jWru2SHzje4z+4roNCRSrr3pif
	 te37H/13HR8A0jMh4k15vypRWa+0dXvQGwebxxchmnYRTECEjhw0sa5ejeSVpW7shD
	 n5rEDpvkQevcJA89IyLNtehagmhIAJGRy9qEazOsEeCyzu0ffC5t/mA5A/zqfplVgY
	 VzCsxGVayuYJ/NQzcDnOitOFdOJrMrV5bBz6wMhc8CnVbe1v3zO3mkPo0mD45dyuZc
	 p/SazgJhHXKEjO3yYY5uB0fcJjECmMa75YsxyEEqsWz5XipsyxSICdIUTOzRoCALlY
	 uN24PHCtNxydQ==
Message-ID: <4b2d796e-222e-4591-b141-eb82811a674d@kernel.org>
Date: Wed, 4 Sep 2024 08:09:25 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] Device tree registration and property names changes
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
 herbert@gondor.apana.org.au, robh@kernel.org, linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
 bhoomikak@vayavyalabs.com
References: <20240904031123.34144-1-pavitrakumarm@vayavyalabs.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 fv0=
In-Reply-To: <20240904031123.34144-1-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04/09/2024 05:11, Pavitrakumar M wrote:
> This patch fixes Device tree registrations, DT property names and counter width
> checks.

Please do not use "This commit/patch/change", but imperative mood. See
longer explanation here:
https://elixir.bootlin.com/linux/v5.17.1/source/Documentation/process/submitting-patches.rst#L95

Please wrap commit message according to Linux coding style / submission
process (neither too early nor over the limit):
https://elixir.bootlin.com/linux/v6.4-rc1/source/Documentation/process/submitting-patches.rst#L597


> 
> Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
> Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> ---
>  drivers/crypto/dwc-spacc/Kconfig          |  2 +-
>  drivers/crypto/dwc-spacc/spacc_core.c     |  4 +-
>  drivers/crypto/dwc-spacc/spacc_device.c   | 64 ++++++++---------------
>  drivers/crypto/dwc-spacc/spacc_device.h   |  3 +-
>  drivers/crypto/dwc-spacc/spacc_skcipher.c | 29 +++++-----
>  5 files changed, 40 insertions(+), 62 deletions(-)
> 
> diff --git a/drivers/crypto/dwc-spacc/Kconfig b/drivers/crypto/dwc-spacc/Kconfig
> index 9eb41a295f9d..bc44c2a61fe7 100644
> --- a/drivers/crypto/dwc-spacc/Kconfig
> +++ b/drivers/crypto/dwc-spacc/Kconfig
> @@ -3,7 +3,7 @@
>  config CRYPTO_DEV_SPACC
>  	tristate "Support for dw_spacc Security protocol accelerators"
>  	depends on HAS_DMA
> -	default m
> +	default n

How is it related?

>  
>  	help
>  	  This enables support for the HASH/CRYP/AEAD hw accelerator which can be found
> diff --git a/drivers/crypto/dwc-spacc/spacc_core.c b/drivers/crypto/dwc-spacc/spacc_core.c
> index 1da7cdd93e78..d48e4b9a56af 100644
> --- a/drivers/crypto/dwc-spacc/spacc_core.c
> +++ b/drivers/crypto/dwc-spacc/spacc_core.c
> @@ -1,9 +1,11 @@
>  // SPDX-License-Identifier: GPL-2.0
>  
> -#include <linux/of_device.h>
> +#include <crypto/skcipher.h>
> +#include <linux/of.h>
>  #include <linux/vmalloc.h>
>  #include <linux/platform_device.h>
>  #include <linux/interrupt.h>
> +#include <linux/dma-mapping.h>
>  #include "spacc_hal.h"
>  #include "spacc_core.h"
>  
> diff --git a/drivers/crypto/dwc-spacc/spacc_device.c b/drivers/crypto/dwc-spacc/spacc_device.c
> index 964ccdf294e3..332703daffef 100644
> --- a/drivers/crypto/dwc-spacc/spacc_device.c
> +++ b/drivers/crypto/dwc-spacc/spacc_device.c
> @@ -25,9 +25,14 @@ void spacc_stat_process(struct spacc_device *spacc)
>  	tasklet_schedule(&priv->pop_jobs);
>  }
>  
> +static const struct of_device_id snps_spacc_id[] = {
> +	{.compatible = "snps,dwc-spacc" },
> +	{ /*sentinel */        }
> +};
> +
> +MODULE_DEVICE_TABLE(of, snps_spacc_id);
>  
> -int spacc_probe(struct platform_device *pdev,
> -		const struct of_device_id snps_spacc_id[])
> +int spacc_probe(struct platform_device *pdev)
>  {
>  	int spacc_idx = -1;
>  	struct resource *mem;
> @@ -37,29 +42,14 @@ int spacc_probe(struct platform_device *pdev,
>  	int spacc_priority = -1;
>  	struct spacc_priv *priv;
>  	int x = 0, err, oldmode, irq_num;
> -	const struct of_device_id *match, *id;
>  	u64 oldtimer = 100000, timer = 100000;
>  
> -	if (pdev->dev.of_node) {
> -		id = of_match_node(snps_spacc_id, pdev->dev.of_node);
> -		if (!id) {
> -			dev_err(&pdev->dev, "DT node did not match\n");
> -			return -EINVAL;
> -		}
> -	}
> -
>  	/* Initialize DDT DMA pools based on this device's resources */
>  	if (pdu_mem_init(&pdev->dev)) {
>  		dev_err(&pdev->dev, "Could not initialize DMA pools\n");
>  		return -ENOMEM;
>  	}
>  
> -	match = of_match_device(of_match_ptr(snps_spacc_id), &pdev->dev);
> -	if (!match) {
> -		dev_err(&pdev->dev, "SPAcc dtb missing");
> -		return -ENODEV;
> -	}
> -
>  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!mem) {
>  		dev_err(&pdev->dev, "no memory resource for spacc\n");
> @@ -74,52 +64,52 @@ int spacc_probe(struct platform_device *pdev,
>  	}
>  
>  	/* Read spacc priority and index and save inside priv.spacc.config */
> -	if (of_property_read_u32(pdev->dev.of_node, "spacc_priority",
> +	if (of_property_read_u32(pdev->dev.of_node, "spacc-priority",
>  				 &spacc_priority)) {
> -		dev_err(&pdev->dev, "No vspacc priority specified\n");
> +		dev_err(&pdev->dev, "No virtual spacc priority specified\n");
>  		err = -EINVAL;
>  		goto free_ddt_mem_pool;
>  	}
>  
>  	if (spacc_priority < 0 && spacc_priority > VSPACC_PRIORITY_MAX) {
> -		dev_err(&pdev->dev, "Invalid vspacc priority\n");
> +		dev_err(&pdev->dev, "Invalid virtual spacc priority\n");
>  		err = -EINVAL;
>  		goto free_ddt_mem_pool;
>  	}
>  	priv->spacc.config.priority = spacc_priority;
>  
> -	if (of_property_read_u32(pdev->dev.of_node, "spacc_index",
> +	if (of_property_read_u32(pdev->dev.of_node, "spacc-index",
>  				 &spacc_idx)) {
> -		dev_err(&pdev->dev, "No vspacc index specified\n");
> +		dev_err(&pdev->dev, "No virtual spacc index specified\n");
>  		err = -EINVAL;
>  		goto free_ddt_mem_pool;
>  	}
>  	priv->spacc.config.idx = spacc_idx;
>  
> -	if (of_property_read_u32(pdev->dev.of_node, "spacc_endian",
> +	if (of_property_read_u32(pdev->dev.of_node, "spacc-endian",
>  				 &spacc_endian)) {
> -		dev_dbg(&pdev->dev, "No spacc_endian specified\n");
> +		dev_dbg(&pdev->dev, "No spacc endian specified\n");
>  		dev_dbg(&pdev->dev, "Default spacc Endianness (0==little)\n");
>  		spacc_endian = 0;
>  	}
>  	priv->spacc.config.spacc_endian = spacc_endian;
>  
> -	if (of_property_read_u64(pdev->dev.of_node, "oldtimer",
> +	if (of_property_read_u64(pdev->dev.of_node, "spacc-oldtimer",
>  				 &oldtimer)) {
> -		dev_dbg(&pdev->dev, "No oldtimer specified\n");
> +		dev_dbg(&pdev->dev, "No spacc oldtimer specified\n");
>  		dev_dbg(&pdev->dev, "Default oldtimer (100000)\n");
>  		oldtimer = 100000;
>  	}
>  	priv->spacc.config.oldtimer = oldtimer;
>  
> -	if (of_property_read_u64(pdev->dev.of_node, "timer", &timer)) {
> -		dev_dbg(&pdev->dev, "No timer specified\n");
> +	if (of_property_read_u64(pdev->dev.of_node, "spacc-timer", &timer)) {
> +		dev_dbg(&pdev->dev, "No spacc timer specified\n");
>  		dev_dbg(&pdev->dev, "Default timer (100000)\n");
>  		timer = 100000;
>  	}
>  	priv->spacc.config.timer = timer;
>  
> -	baseaddr = devm_ioremap_resource(&pdev->dev, mem);
> +	baseaddr = devm_platform_get_and_ioremap_resource(pdev, 0, &mem);
>  	if (IS_ERR(baseaddr)) {
>  		dev_err(&pdev->dev, "unable to map iomem\n");
>  		err = PTR_ERR(baseaddr);
> @@ -127,12 +117,6 @@ int spacc_probe(struct platform_device *pdev,
>  	}
>  
>  	pdu_get_version(baseaddr, &info);
> -	if (pdev->dev.platform_data) {
> -		struct pdu_info *parent_info = pdev->dev.platform_data;
> -
> -		memcpy(&info.pdu_config, &parent_info->pdu_config,
> -		       sizeof(info.pdu_config));
> -	}
>  
>  	dev_dbg(&pdev->dev, "EPN %04X : virt [%d]\n",
>  				info.spacc_version.project,
> @@ -273,18 +257,12 @@ static void spacc_unregister_algs(void)
>  #endif
>  }
>  
> -static const struct of_device_id snps_spacc_id[] = {
> -	{.compatible = "snps-dwc-spacc" },
> -	{ /*sentinel */        }
> -};
> -
> -MODULE_DEVICE_TABLE(of, snps_spacc_id);
>  
>  static int spacc_crypto_probe(struct platform_device *pdev)
>  {
>  	int rc;
>  
> -	rc = spacc_probe(pdev, snps_spacc_id);
> +	rc = spacc_probe(pdev);
>  	if (rc < 0)
>  		goto err;
>  
> @@ -326,7 +304,7 @@ static struct platform_driver spacc_driver = {
>  	.remove = spacc_crypto_remove,
>  	.driver = {
>  		.name  = "spacc",
> -		.of_match_table = of_match_ptr(snps_spacc_id),
> +		.of_match_table = snps_spacc_id,
>  		.owner = THIS_MODULE,
>  	},
>  };
> diff --git a/drivers/crypto/dwc-spacc/spacc_device.h b/drivers/crypto/dwc-spacc/spacc_device.h
> index be7fde25046b..e6a34dc20eba 100644
> --- a/drivers/crypto/dwc-spacc/spacc_device.h
> +++ b/drivers/crypto/dwc-spacc/spacc_device.h
> @@ -224,8 +224,7 @@ int spacc_unregister_aead_algs(void);
>  int probe_ciphers(struct platform_device *spacc_pdev);
>  int spacc_unregister_cipher_algs(void);
>  
> -int spacc_probe(struct platform_device *pdev,
> -		const struct of_device_id snps_spacc_id[]);
> +int spacc_probe(struct platform_device *pdev);
>  
>  irqreturn_t spacc_irq_handler(int irq, void *dev);
>  #endif
> diff --git a/drivers/crypto/dwc-spacc/spacc_skcipher.c b/drivers/crypto/dwc-spacc/spacc_skcipher.c
> index 1ef7c665188f..8410ad9d9910 100644
> --- a/drivers/crypto/dwc-spacc/spacc_skcipher.c
> +++ b/drivers/crypto/dwc-spacc/spacc_skcipher.c
> @@ -401,41 +401,40 @@ static int spacc_cipher_process(struct skcipher_request *req, int enc_dec)
>  			return ret;
>  		}
>  	}
> -
>  	if (salg->mode->id == CRYPTO_MODE_AES_CTR ||
>  	    salg->mode->id == CRYPTO_MODE_SM4_CTR) {
>  		/* copy the IV to local buffer */
>  		for (i = 0; i < 16; i++)
>  			ivc1[i] = req->iv[i];
>  
> -		/* 64-bit counter width */
> -		if (readl(device_h->regmap + SPACC_REG_VERSION_EXT_3) & (0x3)) {
> +		/* 32-bit counter width */
> +		if (readl(device_h->regmap + SPACC_REG_VERSION_EXT_3) & (0x2)) {

Your patch is absolute mess.

You must organize your changes logically. Please read carefully
submitting patches document.

Best regards,
Krzysztof

