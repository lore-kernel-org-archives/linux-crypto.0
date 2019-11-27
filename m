Return-Path: <SRS0=XAm+=ZT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D23C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 15:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 522CE20665
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 15:03:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dzr5XA0L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfK0PDi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Nov 2019 10:03:38 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45194 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbfK0PDi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Nov 2019 10:03:38 -0500
Received: by mail-wr1-f67.google.com with SMTP id j42so1212801wrj.12
        for <linux-crypto@vger.kernel.org>; Wed, 27 Nov 2019 07:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TPSdYWPsxVaZZs7XMbf85yoh9+QLbbbAn0Y9s5Tq39Q=;
        b=dzr5XA0LFhxUEA80Hf1lH8eKQRxhAaPKRfQiWhNn8VfXmjd1dKLvUcRAjfxqg15rXo
         J/kLBjqWfKAj8mI8unG/clL1JPoxxNDp3NjZ+IfZlSZh9Pzv255gzi6juBMbZg4wl6za
         WMODD+imnxnqCL7Hw+GbNSTbuvaiW1jt8f0hiLtMnQXlBa1eT9Q+ZQBBw2oRHYGtWSOn
         WXA6jRvj2WeRX8kLUlQ4Amb9K0l+VuYdBsCDRgHm39fdFdmcc56MneivQbubnfKZf/6Z
         ZwaxVz51Prja2DpSAF81nSIPyfl4T1I6vLIqtaZ8AMxxA/a2OUmbxTru94LfV9P6Iyow
         1sbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TPSdYWPsxVaZZs7XMbf85yoh9+QLbbbAn0Y9s5Tq39Q=;
        b=foFX4hd2rveHjpw5nv03hmIfEhk9uAJWtvrGZa2KnHxbKWVkOA/qFr+ELkAijVrIEH
         lPLy8g5YEGmSsnEBDu3b72OpTtjR/GEpUzm2i//aMD6pF7yKXHfSX7ahFtyAaC35sqet
         ovswaRAbXzivYJJwJWdboAQ36EbeR/VjsXv9Yh1x4mTfRzyiyZ27+NEDv5xhyxGebUJi
         2/QQBuoNwiBOHpHW+MaxMhvwh0Pr3B4bXbHQZxDrqZSwfWT0ljTC/COAto1fT1eIIHhH
         1pu0ZhTtGPekKgCDfsc580ODOGYMfvDb2FGnMF9SW3rSuZGgsbVYPzJF3JA7KE/0yO3a
         FJ+A==
X-Gm-Message-State: APjAAAVShy/Hymrc9a0YhtoztLaCnTNnAmvUBoKUeo1Ks6ieLih6mSWl
        /8Kb2tWsq6EonufG9NTixozDs/9RrzvYpIMxQVc+hw==
X-Google-Smtp-Source: APXvYqxIKLa2LPH2JUMg8rKd9cLtzDfM0oUfFtHHu1JmdjPCxQB1qigIXkCD7VJIQ76ZLrSxC6WbuHL3ePcRzmrpqUY=
X-Received: by 2002:a5d:6652:: with SMTP id f18mr1250887wrw.246.1574867015749;
 Wed, 27 Nov 2019 07:03:35 -0800 (PST)
MIME-Version: 1.0
References: <1574864578-467-1-git-send-email-neal.liu@mediatek.com> <1574864578-467-4-git-send-email-neal.liu@mediatek.com>
In-Reply-To: <1574864578-467-4-git-send-email-neal.liu@mediatek.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 27 Nov 2019 16:03:24 +0100
Message-ID: <CAKv+Gu_VicmyCGa8sQOwj_iRBf7Sf-iXpVa_3SQyB2Xjru=rmg@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] hwrng: add mtk-sec-rng driver
To:     Neal Liu <neal.liu@mediatek.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@kernel.org>,
        Crystal Guo <Crystal.Guo@mediatek.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        wsd_upstream@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 27 Nov 2019 at 15:23, Neal Liu <neal.liu@mediatek.com> wrote:
>
> For MediaTek SoCs on ARMv8 with TrustZone enabled, peripherals like
> entropy sources is not accessible from normal world (linux) and
> rather accessible from secure world (ATF/TEE) only. This driver aims
> to provide a generic interface to ATF rng service.
>
> Signed-off-by: Neal Liu <neal.liu@mediatek.com>
> ---
>  drivers/char/hw_random/Kconfig       |   16 ++++++
>  drivers/char/hw_random/Makefile      |    1 +
>  drivers/char/hw_random/mtk-sec-rng.c |  103 ++++++++++++++++++++++++++++++++++
>  3 files changed, 120 insertions(+)
>  create mode 100644 drivers/char/hw_random/mtk-sec-rng.c
>
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 25a7d8f..f08c852 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -398,6 +398,22 @@ config HW_RANDOM_MTK
>
>           If unsure, say Y.
>
> +config HW_RANDOM_MTK_SEC
> +       tristate "MediaTek Security Random Number Generator support"
> +       depends on HW_RANDOM
> +       depends on ARCH_MEDIATEK || COMPILE_TEST
> +       default HW_RANDOM
> +         help
> +         This driver provides kernel-side support for the Random Number
> +         Generator hardware found on MediaTek SoCs. The difference with
> +         mtk-rng is the Random Number Generator hardware is secure
> +         access only.
> +
> +         To compile this driver as a module, choose M here. the
> +         module will be called mtk-sec-rng.
> +
> +         If unsure, say Y.
> +
>  config HW_RANDOM_S390
>         tristate "S390 True Random Number Generator support"
>         depends on S390
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> index 7c9ef4a..bee5412 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -36,6 +36,7 @@ obj-$(CONFIG_HW_RANDOM_PIC32) += pic32-rng.o
>  obj-$(CONFIG_HW_RANDOM_MESON) += meson-rng.o
>  obj-$(CONFIG_HW_RANDOM_CAVIUM) += cavium-rng.o cavium-rng-vf.o
>  obj-$(CONFIG_HW_RANDOM_MTK)    += mtk-rng.o
> +obj-$(CONFIG_HW_RANDOM_MTK_SEC)        += mtk-sec-rng.o
>  obj-$(CONFIG_HW_RANDOM_S390) += s390-trng.o
>  obj-$(CONFIG_HW_RANDOM_KEYSTONE) += ks-sa-rng.o
>  obj-$(CONFIG_HW_RANDOM_OPTEE) += optee-rng.o
> diff --git a/drivers/char/hw_random/mtk-sec-rng.c b/drivers/char/hw_random/mtk-sec-rng.c
> new file mode 100644
> index 0000000..69ddeca
> --- /dev/null
> +++ b/drivers/char/hw_random/mtk-sec-rng.c
> @@ -0,0 +1,103 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 MediaTek Inc.
> + */
> +
> +#include <linux/arm-smccc.h>
> +#include <linux/hw_random.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/soc/mediatek/mtk_sip_svc.h>
> +
> +#define MTK_SEC_RNG_MAGIC      0x74726e67
> +#define SMC_RET_NUM            4
> +#define MTK_SEC_RND_SIZE       (sizeof(u32) * SMC_RET_NUM)
> +
> +static void mtk_sec_get_rnd(uint32_t *val)
> +{
> +       struct arm_smccc_res res;
> +
> +       arm_smccc_smc(MTK_SIP_KERNEL_GET_RND,
> +                     MTK_SEC_RNG_MAGIC, 0, 0, 0, 0, 0, 0, &res);
> +

Can this call never fail? How does the firmware signal that something
is wrong with the underlying hardware?

> +       val[0] = res.a0;
> +       val[1] = res.a1;
> +       val[2] = res.a2;
> +       val[3] = res.a3;
> +}
> +
> +static int mtk_sec_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> +{
> +       u32 val[4] = {0};
> +       int retval = 0;
> +       int i;
> +
> +       while (max >= MTK_SEC_RND_SIZE) {
> +               mtk_sec_get_rnd(val);
> +
> +               for (i = 0; i < SMC_RET_NUM; i++) {
> +                       *(u32 *)buf = val[i];
> +                       buf += sizeof(u32);
> +               }
> +
> +               retval += MTK_SEC_RND_SIZE;
> +               max -= MTK_SEC_RND_SIZE;
> +       }
> +
> +       return retval;
> +}
> +
> +static struct hwrng mtk_sec_rng = {
> +       .name = "mtk_sec_rng",
> +       .read = mtk_sec_rng_read,
> +       .quality = 900,
> +};
> +
> +static int mtk_sec_rng_probe(void)
> +{
> +       int ret;
> +
> +       ret = hwrng_register(&mtk_sec_rng);
> +       if (ret) {
> +               pr_err("Failed to register rng device: %d\n", ret);
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static int __init mtk_sec_rng_driver_init(void)
> +{
> +       struct device_node *fw_np;
> +       struct device_node *np;
> +       const char *method;
> +
> +       fw_np = of_find_node_by_name(NULL, "firmware");
> +       if (!fw_np)
> +               return -ENODEV;
> +
> +       np = of_find_compatible_node(fw_np, NULL, "mediatek,mtk-sec-rng");
> +       if (!np)
> +               return -ENODEV;
> +
> +       if (of_property_read_string(np, "method", &method))
> +               return -ENXIO;
> +
> +       if (strncmp("smc", method, strlen("smc")))
> +               return -EINVAL;
> +
> +       return mtk_sec_rng_probe();
> +}
> +
> +static void __exit mtk_sec_rng_driver_exit(void)
> +{
> +       hwrng_unregister(&mtk_sec_rng);
> +}
> +
> +module_init(mtk_sec_rng_driver_init);
> +module_exit(mtk_sec_rng_driver_exit);
> +
> +MODULE_DESCRIPTION("MediaTek Security Random Number Generator Driver");
> +MODULE_AUTHOR("Neal Liu <neal.liu@mediatek.com>");
> +MODULE_LICENSE("GPL");
> --
> 1.7.9.5
