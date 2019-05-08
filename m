Return-Path: <SRS0=esIh=TI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19925C04A6B
	for <linux-crypto@archiver.kernel.org>; Wed,  8 May 2019 06:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43BE521019
	for <linux-crypto@archiver.kernel.org>; Wed,  8 May 2019 06:34:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="XoI76QdS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfEHGeo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 May 2019 02:34:44 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:27173 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbfEHGeo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 May 2019 02:34:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1557297278;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=SsUTm1R7UUQ+bTJ7Pc64aIfy+AkoXx22RxCukswczwc=;
        b=XoI76QdS69Hi+4A+QDpPKefy1ze+8t9xJXNcXGo0ojMkg/JhlnzIOMCyLghzkGrUFI
        qPn93rHgx4vccmR/o59Wn673AK3WLSupxkJy2AkPv67HWvaMEX6jWqrGzgtSal/C5uty
        PF10RNoet2HR/3EB0PQvyTRRARai42HUldtOT+MqnsHzpSuVYX3ObFU7z57VlAn/9BmG
        p9AZt94CCVnZCDPyYkJh38nD1XjqTLhTqaHJPI/PeH+s37zUaKRdikeF8RXvy1VgCXbP
        kbHJ37W29xv+B7f9KgLmnTYBk9rbZ47Zpb+nC15khstXi+/+szuGiEXU2+Q68hDXO511
        JJmQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbIvSbR/w="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.18 DYNA|AUTH)
        with ESMTPSA id R0373fv486YM8ZU
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Wed, 8 May 2019 08:34:22 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     neal.liu@mediatek.com
Cc:     mpm@selenic.com, herbert@gondor.apana.org.au, robh+dt@kernel.org,
        mark.rutland@arm.com, matthias.bgg@gmail.com,
        wsd_upstream@mediatek.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 3/3] hwrng: add mt67xx-rng driver
Date:   Wed, 08 May 2019 08:34:22 +0200
Message-ID: <12193108.aNnqf5ydOJ@tauon.chronox.de>
In-Reply-To: <1557287937-2410-4-git-send-email-neal.liu@mediatek.com>
References: <1557287937-2410-1-git-send-email-neal.liu@mediatek.com> <1557287937-2410-4-git-send-email-neal.liu@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 8. Mai 2019, 05:58:57 CEST schrieb neal.liu@mediatek.com:

Hi liu,

> From: Neal Liu <neal.liu@mediatek.com>
> 
> For Mediatek SoCs on ARMv8 with TrustZone enabled, peripherals like
> entropy sources is not accessible from normal world (linux) and
> rather accessible from secure world (ATF/TEE) only. This driver aims
> to provide a generic interface to ATF rng service.
> 
> Signed-off-by: Neal Liu <neal.liu@mediatek.com>
> ---
>  drivers/char/hw_random/Kconfig      |   16 ++++++
>  drivers/char/hw_random/Makefile     |    1 +
>  drivers/char/hw_random/mt67xx-rng.c |  104
> +++++++++++++++++++++++++++++++++++ 3 files changed, 121 insertions(+)
>  create mode 100644 drivers/char/hw_random/mt67xx-rng.c
> 
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 25a7d8f..98751d3 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -398,6 +398,22 @@ config HW_RANDOM_MTK
> 
>  	  If unsure, say Y.
> 
> +config HW_RANDOM_MT67XX
> +	tristate "Mediatek MT67XX Random Number Generator support"
> +	depends on HW_RANDOM
> +	depends on ARCH_MEDIATEK || COMPILE_TEST
> +	default HW_RANDOM
> +	help
> +	  This driver provides kernel-side support for the Random Number
> +	  Generator hardware found on Mediatek MT67xx SoCs. The difference
> +	  with mtk-rng is the Random Number Generator hardware is secure
> +	  access only.
> +
> +	  To compile this driver as a module, choose M here. the
> +	  module will be called mt67xx-rng.
> +
> +	  If unsure, say Y.
> +
>  config HW_RANDOM_S390
>  	tristate "S390 True Random Number Generator support"
>  	depends on S390
> diff --git a/drivers/char/hw_random/Makefile
> b/drivers/char/hw_random/Makefile index 7c9ef4a..4be95ab 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -36,6 +36,7 @@ obj-$(CONFIG_HW_RANDOM_PIC32) += pic32-rng.o
>  obj-$(CONFIG_HW_RANDOM_MESON) += meson-rng.o
>  obj-$(CONFIG_HW_RANDOM_CAVIUM) += cavium-rng.o cavium-rng-vf.o
>  obj-$(CONFIG_HW_RANDOM_MTK)	+= mtk-rng.o
> +obj-$(CONFIG_HW_RANDOM_MT67XX) += mt67xx-rng.o
>  obj-$(CONFIG_HW_RANDOM_S390) += s390-trng.o
>  obj-$(CONFIG_HW_RANDOM_KEYSTONE) += ks-sa-rng.o
>  obj-$(CONFIG_HW_RANDOM_OPTEE) += optee-rng.o
> diff --git a/drivers/char/hw_random/mt67xx-rng.c
> b/drivers/char/hw_random/mt67xx-rng.c new file mode 100644
> index 0000000..e70cbbe
> --- /dev/null
> +++ b/drivers/char/hw_random/mt67xx-rng.c
> @@ -0,0 +1,104 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 MediaTek Inc.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/hw_random.h>
> +#include <linux/of.h>
> +#include <linux/arm-smccc.h>
> +#include <linux/soc/mediatek/mtk_sip_svc.h>
> +
> +#define PFX			KBUILD_MODNAME ": "
> +#define MT67XX_RNG_MAGIC	0x74726e67
> +#define SMC_RET_NUM		4
> +
> +struct mt67xx_rng_priv {
> +	struct hwrng rng;
> +};
> +
> +
> +static void __rng_sec_read(uint32_t *val)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_smc(MTK_SIP_KERNEL_GET_RND,
> +		      MT67XX_RNG_MAGIC, 0, 0, 0, 0, 0, 0, &res);
> +
> +	val[0] = res.a0;
> +	val[1] = res.a1;
> +	val[2] = res.a2;
> +	val[3] = res.a3;
> +}
> +
> +static int mt67xx_rng_read(struct hwrng *rng, void *buf, size_t max, bool
> wait) +{
> +	int i, retval = 0;
> +	uint32_t val[4] = {0};
> +	size_t get_rnd_size = sizeof(u32) * SMC_RET_NUM;
> +
> +	if (!buf) {
> +		pr_err("%s, buf is NULL\n", __func__);
> +		return -EFAULT;
> +	}
> +
> +	while (max >= get_rnd_size) {
> +		__rng_sec_read(val);
> +
> +		for (i = 0; i < SMC_RET_NUM; i++) {
> +			*(u32 *)buf = val[i];

I am not sure this cast is right - or how is it guaranteed that buf is word-
aligned?

> +			buf += sizeof(u32);
> +		}
> +
> +		retval += get_rnd_size;
> +		max -= get_rnd_size;
> +	}
> +
> +	return retval;
> +}
> +
> +static int mt67xx_rng_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct mt67xx_rng_priv *priv;
> +
> +	pr_info(PFX "driver registered\n");
> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->rng.name = KBUILD_MODNAME;
> +	priv->rng.read = mt67xx_rng_read;
> +	priv->rng.priv = (unsigned long)&pdev->dev;
> +	priv->rng.quality = 900;
> +
> +	ret = devm_hwrng_register(&pdev->dev, &priv->rng);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to register rng device: %d\n", 
ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id mt67xx_rng_match[] = {
> +	{ .compatible = "mediatek,mt67xx-rng", },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, mt67xx_rng_match);
> +
> +static struct platform_driver mt67xx_rng_driver = {
> +	.probe = mt67xx_rng_probe,
> +	.driver = {
> +		.name = KBUILD_MODNAME,
> +		.owner = THIS_MODULE,
> +		.of_match_table = mt67xx_rng_match,
> +	},
> +};
> +
> +module_platform_driver(mt67xx_rng_driver);
> +
> +MODULE_DESCRIPTION("Mediatek MT67XX Random Number Generator Driver");
> +MODULE_AUTHOR("Neal Liu <neal.liu@mediatek.com>");
> +MODULE_LICENSE("GPL");



Ciao
Stephan


