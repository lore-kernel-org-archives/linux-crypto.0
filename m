Return-Path: <SRS0=c791=3P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAFAC35247
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Jan 2020 13:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6D9B20716
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Jan 2020 13:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="ai+SUiF/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgAZNdK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 26 Jan 2020 08:33:10 -0500
Received: from mail-vk1-f194.google.com ([209.85.221.194]:33773 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgAZNdJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Jan 2020 08:33:09 -0500
Received: by mail-vk1-f194.google.com with SMTP id i78so1944096vke.0
        for <linux-crypto@vger.kernel.org>; Sun, 26 Jan 2020 05:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=emKfjakMK0JQ5BS5YCFkbZaOfKcUBqnq7Vw1qMXzarA=;
        b=ai+SUiF/UB+ocFDZG4bWX3gairRXyO3KEZs3g3zkaG+2pYyYWK3fd9bt+E7Rar+SD4
         EIwg+XvovGF4K2Odgt+HUesXodKNd95varMryoGJqOHTWZQOv6S1c9horPbB6zQHQUFj
         z9zcOiYdUC0xWDGg/8FTElf80uvRJry+UUYvrQXpXo/t3fWys/BSnSQ76GW5zuNCsO1l
         pZM6EFHBmDXPG3u5Ed5vydQglmNUzoQYPbUyeuzEM07UGxpDHAax8tnbup1DAOHP7Yde
         /cxPg5ADJdZmZUlDdaVtddv2qRPpZENEBJutlRleqIojB4JNHjUkH8vvrlvOeC3MPHmZ
         7vyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=emKfjakMK0JQ5BS5YCFkbZaOfKcUBqnq7Vw1qMXzarA=;
        b=ihIwQAacMP6tB9wiPRaVJYhHzBUeli4HdAWM1BJGlt1pzTSgEU41Pqyw893z3hYvgA
         xSoGGB0RWtzBSTqXLTAnLYHsyJMB0+If7i04HghJgg/vwbCuvUnn0M+aQowoH4HZ/j3P
         YA9HBoXVSbm3w7swSKt2Y37we36mqdsST5qT2dYKrseYgFmBdZb1poSqxi/1owxtyNzO
         38bMlYXh3qG3Ffp51Rpb+Cf6i5G+zvXys9SVBJ2OsTKMy5ZCAdR0n+4lR1fuFbeDljgR
         EtlAoDj+ctDK8K8ZxbgubVbPDx5eA/4Ac91MDJcB/QSV1xTeXpYUciZJbVI5/VLNtFM7
         ihHg==
X-Gm-Message-State: APjAAAW5dRav/5L6vJVesFtNjZ2wslAlnSCvhOACyVUaHRu/OuGAYgO0
        s0xq1z6hIoK65PpOcwTCv2cwooiJOkPKyTZhUTfyig==
X-Google-Smtp-Source: APXvYqwbEI5BxpWOjvqHw3OF1B1QFbz8m5/83C3fLpV6wDo9RxMYmlGUd3KSZPynqahIUdu2vYZLu7TpEP7jm7Xn4b4=
X-Received: by 2002:ac5:cd8c:: with SMTP id i12mr5971417vka.100.1580045588469;
 Sun, 26 Jan 2020 05:33:08 -0800 (PST)
MIME-Version: 1.0
References: <20200124132957.15769-1-geert+renesas@glider.be> <20200124132957.15769-3-geert+renesas@glider.be>
In-Reply-To: <20200124132957.15769-3-geert+renesas@glider.be>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 26 Jan 2020 15:32:50 +0200
Message-ID: <CAOtvUMdA2aD9DJBmSpOJOFRw=1_9OcaG4Y915q5L7dgo7n7HTA@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: ccree - fix debugfs register access while suspended
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
        Felipe Balbi <balbi@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Bin Liu <b-liu@ti.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:THERMAL" <linux-pm@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 24, 2020 at 3:30 PM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
>
> Reading the debugfs files under /sys/kernel/debug/ccree/ can be done by
> the user at any time.  On R-Car SoCs, the CCREE device is power-managed
> using a moduile clock, and if this clock is not running, bogus register
> values may be read.
>
> Fix this by filling in the debugfs_regset32.dev field, so debugfs will
> make sure the device is resumed while its registers are being read.
>
> This fixes the bogus values (0x00000260) in the register dumps on R-Car
> H3 ES1.0:
>
>     -e6601000.crypto/regs:HOST_IRR =3D 0x00000260
>     -e6601000.crypto/regs:HOST_POWER_DOWN_EN =3D 0x00000260
>     +e6601000.crypto/regs:HOST_IRR =3D 0x00000038
>     +e6601000.crypto/regs:HOST_POWER_DOWN_EN =3D 0x00000038
>      e6601000.crypto/regs:AXIM_MON_ERR =3D 0x00000000
>      e6601000.crypto/regs:DSCRPTR_QUEUE_CONTENT =3D 0x000002aa
>     -e6601000.crypto/regs:HOST_IMR =3D 0x00000260
>     +e6601000.crypto/regs:HOST_IMR =3D 0x017ffeff
>      e6601000.crypto/regs:AXIM_CFG =3D 0x001f0007
>      e6601000.crypto/regs:AXIM_CACHE_PARAMS =3D 0x00000000
>     -e6601000.crypto/regs:GPR_HOST =3D 0x00000260
>     +e6601000.crypto/regs:GPR_HOST =3D 0x017ffeff
>      e6601000.crypto/regs:AXIM_MON_COMP =3D 0x00000000
>     -e6601000.crypto/version:SIGNATURE =3D 0x00000260
>     -e6601000.crypto/version:VERSION =3D 0x00000260
>     +e6601000.crypto/version:SIGNATURE =3D 0xdcc63000
>     +e6601000.crypto/version:VERSION =3D 0xaf400001
>
> Note that this behavior is system-dependent, and the issue does not show
> up on all R-Car Gen3 SoCs and boards.  Even when the device is
> suspended, the module clock may be left enabled, if configured by the
> firmware for Secure Mode, or when controlled by the Real-Time Core.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/crypto/ccree/cc_debugfs.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/crypto/ccree/cc_debugfs.c b/drivers/crypto/ccree/cc_=
debugfs.c
> index 5669997386988055..35f3a2137502bd96 100644
> --- a/drivers/crypto/ccree/cc_debugfs.c
> +++ b/drivers/crypto/ccree/cc_debugfs.c
> @@ -81,6 +81,7 @@ int cc_debugfs_init(struct cc_drvdata *drvdata)
>         regset->regs =3D debug_regs;
>         regset->nregs =3D ARRAY_SIZE(debug_regs);
>         regset->base =3D drvdata->cc_base;
> +       regset->dev =3D dev;
>
>         ctx->dir =3D debugfs_create_dir(drvdata->plat_dev->name, cc_debug=
fs_dir);
>
> @@ -102,6 +103,7 @@ int cc_debugfs_init(struct cc_drvdata *drvdata)
>                 verset->nregs =3D ARRAY_SIZE(pid_cid_regs);
>         }
>         verset->base =3D drvdata->cc_base;
> +       verset->dev =3D dev;
>
>         debugfs_create_regset32("version", 0400, ctx->dir, verset);
>
> --
> 2.17.1
>


Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks,
Gilad
--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
