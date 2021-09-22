Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C30C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 02:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DFDE60EE7
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 02:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbhIVCDo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Sep 2021 22:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbhIVCDo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Sep 2021 22:03:44 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CD9C061574;
        Tue, 21 Sep 2021 19:02:15 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id u21so1280318qtw.8;
        Tue, 21 Sep 2021 19:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mgCRAj8DzBJSfsE3q2tNnkO0IJ8gTb2jzC1NsaR7PCw=;
        b=e3dJJbTI3j2a4UlsU42Mx8Izjnu4cn+MYwXRcLaBkKq3aPjTwiNdE/uPyyygnCwrYG
         bEuZbnydfYaCTCaDmWuA6pdxrxvizY4MLLq3DHKqinBfzfhqek0FBVxEVbIg1PpE76c9
         nhZiucwpaCgFyC1JuKoMYkCnJ4UU8QrWri+pQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mgCRAj8DzBJSfsE3q2tNnkO0IJ8gTb2jzC1NsaR7PCw=;
        b=ks8A2D7HS+zT69Cla222DdhZUYmKXPCMBCsYZ/weFuFcHRcgfNvhP0Jm7jS40t07na
         gwxv2ktOlHJN3pPB77u9JovXQFQzeRKOyPexjRd08N9gi8ENhXSkZsMSE9l0xoUgqr7e
         OPRejAbdFZw7v2MsMRVVRkbmYGaFshCFnS4y7ItV/BFXNZI7sDzsmF8/MZru2jbxylOb
         pBWV0vHPDbqW3yMsMiJrBPkRox/J4/csMoykGFgSOVNtnOFYGwFnwo8INqSBjSJoZXNR
         Ah4W8Jibb4GY8N4JsVTIJMor1GJXwHxD8sFKo9UbE/41eUQaZicKw2sppE1mXspBxNQx
         zZpQ==
X-Gm-Message-State: AOAM5321f6DSSVOQV6QVnutebd5WBKKJhoMG+qWBLFxg/tfjZfiFQjDn
        4wobrDpyh+p3nB70AP1X1QHAYHEeAGf291ouE9U=
X-Google-Smtp-Source: ABdhPJzh6A9rX+IW79HZTeRbvve7SXL1Rw0lrxiKHDq8DtkRDywzrL3dBIAPBPhRqTX5kMpZIAcltvjZ6QcdFTZTOGM=
X-Received: by 2002:ac8:7549:: with SMTP id b9mr22594619qtr.392.1632276134046;
 Tue, 21 Sep 2021 19:02:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210921213930.10366-1-linkmauve@linkmauve.fr> <20210921213930.10366-2-linkmauve@linkmauve.fr>
In-Reply-To: <20210921213930.10366-2-linkmauve@linkmauve.fr>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 22 Sep 2021 02:02:01 +0000
Message-ID: <CACPK8Xc+J0PbCdgheRxJbOVZ=OyyfsCA=cwkneMoboJLzC8TZQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] crypto: nintendo-aes - add a new AES driver
To:     Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Ash Logan <ash@heyquark.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Jonathan_Neusch=C3=A4fer?= <j.ne@posteo.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 21 Sept 2021 at 21:47, Emmanuel Gil Peyrot
<linkmauve@linkmauve.fr> wrote:
>
> This engine implements AES in CBC mode, using 128-bit keys only.  It is
> present on both the Wii and the Wii U, and is apparently identical in
> both consoles.
>
> The hardware is capable of firing an interrupt when the operation is
> done, but this driver currently uses a busy loop, I=E2=80=99m not too sur=
e
> whether it would be preferable to switch, nor how to achieve that.
>
> It also supports a mode where no operation is done, and thus could be
> used as a DMA copy engine, but I don=E2=80=99t know how to expose that to=
 the
> kernel or whether it would even be useful.
>
> In my testing, on a Wii U, this driver reaches 80.7 MiB/s, while the
> aes-generic driver only reaches 30.9 MiB/s, so it is a quite welcome
> speedup.
>
> This driver was written based on reversed documentation, see:
> https://wiibrew.org/wiki/Hardware/AES
>
> Signed-off-by: Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
> Tested-by: Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>  # on Wii U
> ---
>  drivers/crypto/Kconfig        |  11 ++
>  drivers/crypto/Makefile       |   1 +
>  drivers/crypto/nintendo-aes.c | 273 ++++++++++++++++++++++++++++++++++
>  3 files changed, 285 insertions(+)
>  create mode 100644 drivers/crypto/nintendo-aes.c
>
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 9a4c275a1335..adc94ad7462d 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -871,4 +871,15 @@ config CRYPTO_DEV_SA2UL
>
>  source "drivers/crypto/keembay/Kconfig"
>
> +config CRYPTO_DEV_NINTENDO
> +       tristate "Support for the Nintendo Wii U AES engine"
> +       depends on WII || WIIU || COMPILE_TEST

This current seteup will allow the driver to be compile tested for
non-powerpc, which will fail on the dcbf instructions.

Perhaps use this instead:

       depends on WII || WIIU || (COMPILE_TEST && PPC)

> +       select CRYPTO_AES
> +       help
> +         Say 'Y' here to use the Nintendo Wii or Wii U on-board AES
> +         engine for the CryptoAPI AES algorithm.
> +
> +         To compile this driver as a module, choose M here: the module
> +         will be called nintendo-aes.
> +
>  endif # CRYPTO_HW
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index fa22cb19e242..004dae7bbf39 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -22,6 +22,7 @@ obj-$(CONFIG_CRYPTO_DEV_MARVELL) +=3D marvell/
>  obj-$(CONFIG_CRYPTO_DEV_MXS_DCP) +=3D mxs-dcp.o
>  obj-$(CONFIG_CRYPTO_DEV_NIAGARA2) +=3D n2_crypto.o
>  n2_crypto-y :=3D n2_core.o n2_asm.o
> +obj-$(CONFIG_CRYPTO_DEV_NINTENDO) +=3D nintendo-aes.o
>  obj-$(CONFIG_CRYPTO_DEV_NX) +=3D nx/
>  obj-$(CONFIG_CRYPTO_DEV_OMAP) +=3D omap-crypto.o
>  obj-$(CONFIG_CRYPTO_DEV_OMAP_AES) +=3D omap-aes-driver.o
> diff --git a/drivers/crypto/nintendo-aes.c b/drivers/crypto/nintendo-aes.=
c
> new file mode 100644
> index 000000000000..79ae77500999
> --- /dev/null
> +++ b/drivers/crypto/nintendo-aes.c
> @@ -0,0 +1,273 @@
> +/*
> + * Copyright (C) 2021 Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.

The  kernel uses the SDPX header instead of pasting the text.

> +static int
> +do_crypt(const void *src, void *dst, u32 len, u32 flags)
> +{
> +       u32 blocks =3D ((len >> 4) - 1) & AES_CTRL_BLOCK;
> +       u32 status;
> +       u32 counter =3D OP_TIMEOUT;
> +       u32 i;
> +
> +       /* Flush out all of src, we can=E2=80=99t know whether any of it =
is in cache */
> +       for (i =3D 0; i < len; i +=3D 32)
> +               __asm__("dcbf 0, %0" : : "r" (src + i));
> +       __asm__("sync" : : : "memory");

This could be flush_dcache_range, from asm/cacheflush.h

> +
> +       /* Set the addresses for DMA */
> +       iowrite32be(virt_to_phys((void *)src), base + AES_SRC);
> +       iowrite32be(virt_to_phys(dst), base + AES_DEST);
> +
> +       /* Start the operation */
> +       iowrite32be(flags | blocks, base + AES_CTRL);
> +
> +       /* TODO: figure out how to use interrupts here, this will probabl=
y
> +        * lower throughput but let the CPU do other things while the AES
> +        * engine is doing its work. */
> +       do {
> +               status =3D ioread32be(base + AES_CTRL);
> +               cpu_relax();
> +       } while ((status & AES_CTRL_EXEC) && --counter);

You could add a msleep in here?

Consider using readl_poll_timeout().

Cheers,

Joel

> +
> +       /* Do we ever get called with dst =E2=89=A0 src?  If so we have t=
o invalidate
> +        * dst in addition to the earlier flush of src. */
> +       if (unlikely(dst !=3D src)) {
> +               for (i =3D 0; i < len; i +=3D 32)
> +                       __asm__("dcbi 0, %0" : : "r" (dst + i));
> +               __asm__("sync" : : : "memory");
> +       }
> +
> +       return counter ? 0 : 1;
> +}
