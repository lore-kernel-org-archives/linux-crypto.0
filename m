Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0982C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 19:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C45521848
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 19:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558724448;
	bh=/ZaQmYJyAh0FE742cOtNRwkB7BpxBSYHHWMM7zOEG3Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=nZMASPVw0maKSWWMEPRk6xtqYuJQVtrWO7+SSk0mCoG5c3DHJTqoPizq+KpDAEneN
	 Ohm3qtuhH6gFgBYIS2HKUsAx1f3J5DFrQzkgHz8yhV9sFX1K4rk2RWyUHNj2cFo3Hi
	 ucOHzZqjV8jTZ7bvD0Bxa9rt26NjYCtIe4x+PaZU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbfEXTAn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 15:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbfEXTAn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 15:00:43 -0400
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD5C321851;
        Fri, 24 May 2019 19:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558724442;
        bh=/ZaQmYJyAh0FE742cOtNRwkB7BpxBSYHHWMM7zOEG3Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FDom/npiPw5rmbjHkU4rH5Kbfekcpn8+YKkwud92U8FDXFOsLMV7wNUzkBeOljBHV
         85GrHYr5DLyaN4Fmkt0Y3zF46hZm0x1XdEljd42JWPUIBtGAhgvnDqrB3/a4CkS5Lq
         RCOxgTOhFtXUKR+xhi8bPf1HTGyOXdVLQb3vWwTc=
Received: by mail-wr1-f51.google.com with SMTP id l17so2601641wrm.10;
        Fri, 24 May 2019 12:00:41 -0700 (PDT)
X-Gm-Message-State: APjAAAUPxTelF3HDOO/NqtN2vAvxHknwHnB58tRFMqOMfKbEZMrYhKrh
        lONySfpu8N575TUxNP0xua8C7n6TiXiQiYXMO4I=
X-Google-Smtp-Source: APXvYqxGTGOO0apOufhHysvU5jZ9SEYlbbfl+Xfpyz93kifoNCsWxAmJUSUhvDzUMNCKBJ5X54wQq0W3FAAJ0FHSz3M=
X-Received: by 2002:adf:f38a:: with SMTP id m10mr17533668wro.81.1558724440298;
 Fri, 24 May 2019 12:00:40 -0700 (PDT)
MIME-Version: 1.0
References: <1557287937-2410-1-git-send-email-neal.liu@mediatek.com> <1557287937-2410-4-git-send-email-neal.liu@mediatek.com>
In-Reply-To: <1557287937-2410-4-git-send-email-neal.liu@mediatek.com>
From:   Sean Wang <sean.wang@kernel.org>
Date:   Fri, 24 May 2019 12:00:28 -0700
X-Gmail-Original-Message-ID: <CAGp9LzoOVuUuzdLyWiqCb=vef_gX5QOg9Y4oxsh3qALX96-gRA@mail.gmail.com>
Message-ID: <CAGp9LzoOVuUuzdLyWiqCb=vef_gX5QOg9Y4oxsh3qALX96-gRA@mail.gmail.com>
Subject: Re: [PATCH 3/3] hwrng: add mt67xx-rng driver
To:     neal.liu@mediatek.com
Cc:     mpm@selenic.com, herbert@gondor.apana.org.au,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        devicetree@vger.kernel.org, wsd_upstream@mediatek.com,
        lkml <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Neal,

On Tue, May 7, 2019 at 9:00 PM <neal.liu@mediatek.com> wrote:
>
> From: Neal Liu <neal.liu@mediatek.com>
>
> For Mediatek SoCs on ARMv8 with TrustZone enabled, peripherals like

MediaTek

> entropy sources is not accessible from normal world (linux) and
> rather accessible from secure world (ATF/TEE) only. This driver aims
> to provide a generic interface to ATF rng service.

Could we rename the mt67xx-rng.c to mtk-sec-rng.c? It seems all
MediaTek SoCs with ATF/TEE can reuse this driver, not be limited in
MT67xx.

>
> Signed-off-by: Neal Liu <neal.liu@mediatek.com>
> ---
>  drivers/char/hw_random/Kconfig      |   16 ++++++
>  drivers/char/hw_random/Makefile     |    1 +
>  drivers/char/hw_random/mt67xx-rng.c |  104 +++++++++++++++++++++++++++++++++++
>  3 files changed, 121 insertions(+)
>  create mode 100644 drivers/char/hw_random/mt67xx-rng.c
>
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 25a7d8f..98751d3 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -398,6 +398,22 @@ config HW_RANDOM_MTK
>
>           If unsure, say Y.
>
> +config HW_RANDOM_MT67XX
> +       tristate "Mediatek MT67XX Random Number Generator support"

MediaTek Security

> +       depends on HW_RANDOM
> +       depends on ARCH_MEDIATEK || COMPILE_TEST
> +       default HW_RANDOM
> +       help
> +         This driver provides kernel-side support for the Random Number
> +         Generator hardware found on Mediatek MT67xx SoCs. The difference

MediaTek

> +         with mtk-rng is the Random Number Generator hardware is secure
> +         access only.
> +
> +         To compile this driver as a module, choose M here. the
> +         module will be called mt67xx-rng.
> +
> +         If unsure, say Y.
> +
>  config HW_RANDOM_S390
>         tristate "S390 True Random Number Generator support"
>         depends on S390
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> index 7c9ef4a..4be95ab 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -36,6 +36,7 @@ obj-$(CONFIG_HW_RANDOM_PIC32) += pic32-rng.o
>  obj-$(CONFIG_HW_RANDOM_MESON) += meson-rng.o
>  obj-$(CONFIG_HW_RANDOM_CAVIUM) += cavium-rng.o cavium-rng-vf.o
>  obj-$(CONFIG_HW_RANDOM_MTK)    += mtk-rng.o
> +obj-$(CONFIG_HW_RANDOM_MT67XX) += mt67xx-rng.o
>  obj-$(CONFIG_HW_RANDOM_S390) += s390-trng.o
>  obj-$(CONFIG_HW_RANDOM_KEYSTONE) += ks-sa-rng.o
>  obj-$(CONFIG_HW_RANDOM_OPTEE) += optee-rng.o
> diff --git a/drivers/char/hw_random/mt67xx-rng.c b/drivers/char/hw_random/mt67xx-rng.c
> new file mode 100644
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

sort these headers in alphabetical order

> +#define PFX                    KBUILD_MODNAME ": "

PFX can be dropped that is less useful

> +#define MT67XX_RNG_MAGIC       0x74726e67
> +#define SMC_RET_NUM            4
> +
> +struct mt67xx_rng_priv {
> +       struct hwrng rng;
> +};
> +
> +
> +static void __rng_sec_read(uint32_t *val)
> +{

add a prefix like mt67xx, the function call is specific to mtk

> +       struct arm_smccc_res res;
> +
> +       arm_smccc_smc(MTK_SIP_KERNEL_GET_RND,
> +                     MT67XX_RNG_MAGIC, 0, 0, 0, 0, 0, 0, &res);
> +
> +       val[0] = res.a0;
> +       val[1] = res.a1;
> +       val[2] = res.a2;
> +       val[3] = res.a3;
> +}
> +
> +static int mt67xx_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> +{
> +       int i, retval = 0;
> +       uint32_t val[4] = {0};
> +       size_t get_rnd_size = sizeof(u32) * SMC_RET_NUM;

sort declarations in the reverse-Xmas tree. and get_rnd_size always be
unchanged so it can be a macro

> +
> +       if (!buf) {

the sanity check is unnecessary, the parameter max would ensure the
size of the whole buffer

> +               pr_err("%s, buf is NULL\n", __func__);
> +               return -EFAULT;
> +       }
> +
> +       while (max >= get_rnd_size) {
> +               __rng_sec_read(val);
> +
> +               for (i = 0; i < SMC_RET_NUM; i++) {
> +                       *(u32 *)buf = val[i];
> +                       buf += sizeof(u32);
> +               }
> +
> +               retval += get_rnd_size;
> +               max -= get_rnd_size;
> +       }
> +
> +       return retval;
> +}
> +
> +static int mt67xx_rng_probe(struct platform_device *pdev)
> +{
> +       int ret;
> +       struct mt67xx_rng_priv *priv;

sort declarations in the reverse-Xmas tree.

> +
> +       pr_info(PFX "driver registered\n");

drop the message

> +       priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +       if (!priv)
> +               return -ENOMEM;
> +
> +       priv->rng.name = KBUILD_MODNAME;

suggest using the device name

priv->rng.name = pdev->name;

> +       priv->rng.read = mt67xx_rng_read;
> +       priv->rng.priv = (unsigned long)&pdev->dev;
> +       priv->rng.quality = 900;
> +
> +       ret = devm_hwrng_register(&pdev->dev, &priv->rng);
> +       if (ret) {
> +               dev_err(&pdev->dev, "failed to register rng device: %d\n", ret);
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static const struct of_device_id mt67xx_rng_match[] = {
> +       { .compatible = "mediatek,mt67xx-rng", },
> +       {}
> +};
> +MODULE_DEVICE_TABLE(of, mt67xx_rng_match);
> +
> +static struct platform_driver mt67xx_rng_driver = {
> +       .probe = mt67xx_rng_probe,
> +       .driver = {
> +               .name = KBUILD_MODNAME,
> +               .owner = THIS_MODULE,
> +               .of_match_table = mt67xx_rng_match,
> +       },
> +};
> +
> +module_platform_driver(mt67xx_rng_driver);
> +
> +MODULE_DESCRIPTION("Mediatek MT67XX Random Number Generator Driver");

MediaTek

> +MODULE_AUTHOR("Neal Liu <neal.liu@mediatek.com>");
> +MODULE_LICENSE("GPL");
> --
> 1.7.9.5
>
>
> _______________________________________________
> Linux-mediatek mailing list
> Linux-mediatek@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-mediatek
