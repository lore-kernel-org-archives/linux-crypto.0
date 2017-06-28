From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 1/3] io-64-nonatomic: add io{read|write}64[be] macros
Date: Wed, 28 Jun 2017 12:11:37 +0200
Message-ID: <CAK8P3a2tL5wdCRscpyb6fW+LQVM05urud=YQRS-3+=4w53rmvg@mail.gmail.com>
References: <20170627230204.16410-1-logang@deltatee.com> <20170627230204.16410-2-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jyri Sarha <jsarha@ti.com>,
        Stephen Bates <sbates@raithlin.com>,
        Christoph Hellwig <hch@lst.de>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35085 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbdF1KLi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2017 06:11:38 -0400
In-Reply-To: <20170627230204.16410-2-logang@deltatee.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 28, 2017 at 1:02 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
> This patch adds io{read|write}64[be] macros to point to the readq/writeq
> in use.
>
> This is because new drivers are encouraged to use ioreadXX, et al instead
> of readX[1], et al -- and mixing ioreadXX with readq is pretty ugly.
>
> [1] ldd3: section 9.4.2
>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> cc: Christoph Hellwig <hch@lst.de>
> cc: Arnd Bergmann <arnd@arndb.de>
> cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
> cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  include/linux/io-64-nonatomic-hi-lo.h | 16 ++++++++++++++++
>  include/linux/io-64-nonatomic-lo-hi.h | 16 ++++++++++++++++
>  2 files changed, 32 insertions(+)
>
> diff --git a/include/linux/io-64-nonatomic-hi-lo.h b/include/linux/io-64-nonatomic-hi-lo.h
> index defcc4644ce3..07a75831244f 100644
> --- a/include/linux/io-64-nonatomic-hi-lo.h
> +++ b/include/linux/io-64-nonatomic-hi-lo.h
> @@ -54,4 +54,20 @@ static inline void hi_lo_writeq_relaxed(__u64 val, volatile void __iomem *addr)
>  #define writeq_relaxed hi_lo_writeq_relaxed
>  #endif
>
> +#ifndef ioread64
> +#define ioread64 readq
> +#endif

This is wrong since ioread* is not the same read* on x86 and other
architectures that have native PCI PIO accessors, or that require
additional barriers for those.

You have to copy hi_lo_readq() here, and call ioread32 twice instead
of calling readl() twice. Same for iowrite64.

> +#ifndef ioread64be
> +#define ioread64be(p) be64_to_cpu(ioread64(p))
> +#endif

This has another problem: ioread64() is defined to access little-endian
registers, just like readq(). This means that instead of be64_to_cpu()
you need swab64() and always perform the byte swap, otherwise this
would be broken on big-endian architectures.

       Arnd
