From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v22 3/6] iomap: introduce io{read|write}64_{lo_hi|hi_lo}
Date: Sat, 06 Oct 2018 21:56:13 +1000
Message-ID: <877eivjnky.fsf@concordia.ellerman.id.au>
References: <20181002224108.3321-1-logang@deltatee.com> <20181002224108.3321-4-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Suresh Warrier <warrier@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
To: Logan Gunthorpe <logang@deltatee.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181002224108.3321-4-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Logan Gunthorpe <logang@deltatee.com> writes:

> In order to provide non-atomic functions for io{read|write}64 that will
> use readq and writeq when appropriate. We define a number of variants
> of these functions in the generic iomap that will do non-atomic
> operations on pio but atomic operations on mmio.
>
> These functions are only defined if readq and writeq are defined. If
> they are not, then the wrappers that always use non-atomic operations
> from include/linux/io-64-nonatomic*.h will be used.
>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Suresh Warrier <warrier@linux.vnet.ibm.com>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/include/asm/io.h |   2 +
>  include/asm-generic/iomap.h   |  22 ++++++
>  lib/iomap.c                   | 132 ++++++++++++++++++++++++++++++++++
>  3 files changed, 156 insertions(+)
>
> diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
> index e0331e754568..20fe5d7515db 100644
> --- a/arch/powerpc/include/asm/io.h
> +++ b/arch/powerpc/include/asm/io.h
> @@ -798,8 +798,10 @@ extern void __iounmap_at(void *ea, unsigned long size);
>  
>  #define mmio_read16be(addr)		readw_be(addr)
>  #define mmio_read32be(addr)		readl_be(addr)
> +#define mmio_read64be(addr)		readq_be(addr)
>  #define mmio_write16be(val, addr)	writew_be(val, addr)
>  #define mmio_write32be(val, addr)	writel_be(val, addr)
> +#define mmio_write64be(val, addr)	writeq_be(val, addr)
>  #define mmio_insb(addr, dst, count)	readsb(addr, dst, count)
>  #define mmio_insw(addr, dst, count)	readsw(addr, dst, count)
>  #define mmio_insl(addr, dst, count)	readsl(addr, dst, count)

For the powerpc part:

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers
