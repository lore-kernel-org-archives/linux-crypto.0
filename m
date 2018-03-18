From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: Re: [PATCH v12 1/9] iomap: Fix sparse endian check warnings
Date: Sun, 18 Mar 2018 17:13:27 +0100
Message-ID: <20180317190311.tdmx2vlcjttsjs5j@ltop.local>
References: <20180316154852.13206-1-logang@deltatee.com>
 <20180316154852.13206-2-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Kate Stewart <kstewart@linuxfoundation.org>
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180316154852.13206-2-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 16, 2018 at 09:48:44AM -0600, Logan Gunthorpe wrote:
> Warnings of the form:
> 
> lib/iomap.c:84:9: warning: cast to restricted __be16
> 
> Are found when running sparse checker with:
> 
> make C=2 CF=-D__CHECK_ENDIAN__
> 
> This patch casts them with __force to suppress the warnings.
 
Hi,

it looks correct but if you should explain why the warning
is not a valid one. Once done, you can then explain what problem
you have fixed instead of saying you suppressed a warning.

> Also, it looks like the wrong conversion function was used in

I would suggest to split the patch in two since it does two
different things which should have their own explanation.

> diff --git a/lib/iomap.c b/lib/iomap.c
> index 541d926da95e..a05d9fa21794 100644
> --- a/lib/iomap.c
> +++ b/lib/iomap.c
> @@ -106,8 +106,10 @@ EXPORT_SYMBOL(ioread32be);
>  #endif
>  
>  #ifndef mmio_write16be
> -#define mmio_write16be(val,port) __raw_writew(be16_to_cpu(val),port)
> -#define mmio_write32be(val,port) __raw_writel(be32_to_cpu(val),port)
> +#define mmio_write16be(val, port) \
> +	__raw_writew((u16 __force)cpu_to_be16(val), port)
> +#define mmio_write32be(val, port) \
> +	__raw_writel((u32 __force)cpu_to_be32(val), port)
>  #endif

I think that in this sort of replacement, it's better to not split
the lines (even if larger than 80, that's it).

-- Luc Van Oostenryck
