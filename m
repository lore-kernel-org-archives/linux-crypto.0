From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 3/3] crypto: caam: cleanup CONFIG_64BIT ifdefs when
 using io{read|write}64
Date: Wed, 28 Jun 2017 12:20:51 +0200
Message-ID: <CAK8P3a1mXeH+qdW=MFKO7i4oXw3yfLj-QU=09Y=MvD5y-T4zmw@mail.gmail.com>
References: <20170627230204.16410-1-logang@deltatee.com> <20170627230204.16410-4-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jyri Sarha <jsarha@ti.com>,
        Stephen Bates <sbates@raithlin.com>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34391 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751552AbdF1KUx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2017 06:20:53 -0400
In-Reply-To: <20170627230204.16410-4-logang@deltatee.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 28, 2017 at 1:02 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
>  #include <linux/types.h>
>  #include <linux/bitops.h>
> -#include <linux/io.h>
> +#include <linux/io-64-nonatomic-hi-lo.h>

Here you include the hi-lo variant unconditionally.

> -#else /* CONFIG_64BIT */
> -static inline void wr_reg64(void __iomem *reg, u64 data)
> -{
> -#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
> -       if (caam_little_end) {
> -               wr_reg32((u32 __iomem *)(reg) + 1, data >> 32);
> -               wr_reg32((u32 __iomem *)(reg), data);
> -       } else
>  #endif
> -       {
> -               wr_reg32((u32 __iomem *)(reg), data >> 32);
> -               wr_reg32((u32 __iomem *)(reg) + 1, data);
> -       }
> +               iowrite64be(data, reg);
>  }

However, the #else path here uses lo-hi instead. I guess we have
to decide how to define iowrite64be_lo_hi() first: it could
either byteswap the 64-bit value first, then write the two halves,
or it could write the two halves, doing a 32-bit byte swap on
each.

       Arnd
