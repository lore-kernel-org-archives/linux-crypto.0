From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [BUG?] crypto: caam: little/big endianness on ARM vs PPC
Date: Tue, 16 Jun 2015 09:45:34 +0200
Message-ID: <20150616074534.GD7947@pengutronix.de>
References: <20150615155907.GC7947@pengutronix.de>
 <20150615162816.GO7557@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150615162816.GO7557@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi!

On Mon, Jun 15, 2015 at 05:28:16PM +0100, Russell King - ARM Linux wrote:
> On Mon, Jun 15, 2015 at 05:59:07PM +0200, Steffen Trumtrar wrote:
> > I'm working on CAAM support for the ARM-based i.MX6 SoCs. The current
> > drivers/crypto/caam driver only works for PowerPC AFAIK.
> > Actually, there isn't that much to do, to get support for the i.MX6 but
> > one patch breaks the driver severely:
> > 
> > 	commit ef94b1d834aace7101de77c3a7c2631b9ae9c5f6
> > 	crypto: caam - Add definition of rd/wr_reg64 for little endian platform
> 
> You're not the only one who's hitting problems with this - Jon Nettleton
> has been working on it recently.
> 
> The way this has been done is fairly yucky to start with: several things
> about it are particularly horrid.  The first is the repetitive code
> for the BE and LE cases, when all that's actually different is the
> register order between the two code cases.
> 
> The second thing is the excessive use of masking - I'm pretty sure the
> compiler won't complain with the below.
> 
> diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
> index 378ddc17f60e..ba0fa630a25d 100644
> --- a/drivers/crypto/caam/regs.h
> +++ b/drivers/crypto/caam/regs.h
> @@ -84,34 +84,28 @@
>  #endif
>  
>  #ifndef CONFIG_64BIT
> -#ifdef __BIG_ENDIAN
> -static inline void wr_reg64(u64 __iomem *reg, u64 data)
> -{
> -	wr_reg32((u32 __iomem *)reg, (data & 0xffffffff00000000ull) >> 32);
> -	wr_reg32((u32 __iomem *)reg + 1, data & 0x00000000ffffffffull);
> -}
> -
> -static inline u64 rd_reg64(u64 __iomem *reg)
> -{
> -	return (((u64)rd_reg32((u32 __iomem *)reg)) << 32) |
> -		((u64)rd_reg32((u32 __iomem *)reg + 1));
> -}
> +#if defined(__BIG_ENDIAN)
> +#define REG64_HI32(reg) ((u32 __iomem *)(reg))
> +#define REG64_LO32(reg) ((u32 __iomem *)(reg) + 1)
> +#elif defined(__LITTLE_ENDIAN)
> +#define REG64_HI32(reg) ((u32 __iomem *)(reg) + 1)
> +#define REG64_LO32(reg) ((u32 __iomem *)(reg))
>  #else
> -#ifdef __LITTLE_ENDIAN
> +#error Broken endian?
> +#endif
> +
>  static inline void wr_reg64(u64 __iomem *reg, u64 data)
>  {
> -	wr_reg32((u32 __iomem *)reg + 1, (data & 0xffffffff00000000ull) >> 32);
> -	wr_reg32((u32 __iomem *)reg, data & 0x00000000ffffffffull);
> +	wr_reg32(REG64_HI32(reg), data >> 32);
> +	wr_reg32(REG64_LO32(reg), data);
>  }
>  
>  static inline u64 rd_reg64(u64 __iomem *reg)
>  {
> -	return (((u64)rd_reg32((u32 __iomem *)reg + 1)) << 32) |
> -		((u64)rd_reg32((u32 __iomem *)reg));
> +	return ((u64)rd_reg32(REG64_HI32(reg))) << 32 |
> +		rd_reg32(REG64_LO32(reg));
>  }
>  #endif
> -#endif
> -#endif
>  
>  /*
>   * jr_outentry
> 
> The second issue is that apparently, the register order doesn't actually
> change for LE devices - in other words, the byte order within each register
> does change, but they aren't a 64-bit register, they're two separate 32-bit
> registers.  So, they should always be written as such.
> 
> So, I'd get rid of the #if defined(__BIG_ENDIAN) stuff and instead have:
> 
> +/*
> + * The DMA address register is a pair of 32-bit registers, and should
> + * always be accessed as such.
> + */
> +#define REG64_HI32(reg) ((u32 __iomem *)(reg))
> +#define REG64_LO32(reg) ((u32 __iomem *)(reg) + 1)
> 

Thanks for all your explanations (in the other mail, too).
I, personally, like this approach the best; at least in the current state
of the driver.

Thanks,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
