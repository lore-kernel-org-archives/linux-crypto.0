From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH 7/7] crypto: caam: cleanup CONFIG_64BIT ifdefs when using
 io{read|write}64
Date: Fri, 23 Jun 2017 11:59:02 -0600
Message-ID: <411c4bb0-2709-1902-778a-bf4d7734e3e1@deltatee.com>
References: <20170622164817.25515-1-logang@deltatee.com>
 <20170622164817.25515-8-logang@deltatee.com>
 <VI1PR0401MB259182B9B11B72B4B53B2C1498D80@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Bates <sbates@raithlin.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Radu Solea <radu.solea@nxp.com>,
        Steve Cornelius <steve.cornelius@nxp.com>
To: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-ntb@googlegroups.com" <linux-ntb@googlegroups.com>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <VI1PR0401MB259182B9B11B72B4B53B2C1498D80@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Thanks Horia.

I'm inclined to just use your patch verbatim. I can set you as author,
but no matter how I do it, I'll need your Signed-off-by.

Logan

On 23/06/17 12:51 AM, Horia Geantã wrote:
> On 6/22/2017 7:49 PM, Logan Gunthorpe wrote:
>> Now that ioread64 and iowrite64 are always available we don't
>> need the ugly ifdefs to change their implementation when they
>> are not.
>>
> Thanks Logan.
> 
> Note however this is not equivalent - it changes the behaviour, since
> CAAM engine on i.MX6S/SL/D/Q platforms is broken in terms of 64-bit
> register endianness - see CONFIG_CRYPTO_DEV_FSL_CAAM_IMX usage in code
> you are removing.
> 
> [Yes, current code has its problems, as it does not differentiate b/w
> i.MX platforms with and without the (unofficial) erratum, but this
> should be fixed separately.]
> 
> Below is the change that would keep current logic - still forcing i.MX
> to write CAAM 64-bit registers in BE even if the engine is LE (yes, diff
> is doing a poor job).
> 
> Horia
> 
> diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
> index 84d2f838a063..b893ebb24e65 100644
> --- a/drivers/crypto/caam/regs.h
> +++ b/drivers/crypto/caam/regs.h
> @@ -134,50 +134,25 @@ static inline void clrsetbits_32(void __iomem
> *reg, u32 clear, u32 set)
>   *    base + 0x0000 : least-significant 32 bits
>   *    base + 0x0004 : most-significant 32 bits
>   */
> -#ifdef CONFIG_64BIT
>  static inline void wr_reg64(void __iomem *reg, u64 data)
>  {
> +#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
>         if (caam_little_end)
>                 iowrite64(data, reg);
>         else
> -               iowrite64be(data, reg);
> -}
> -
> -static inline u64 rd_reg64(void __iomem *reg)
> -{
> -       if (caam_little_end)
> -               return ioread64(reg);
> -       else
> -               return ioread64be(reg);
> -}
> -
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
> 
>  static inline u64 rd_reg64(void __iomem *reg)
>  {
>  #ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
>         if (caam_little_end)
> -               return ((u64)rd_reg32((u32 __iomem *)(reg) + 1) << 32 |
> -                       (u64)rd_reg32((u32 __iomem *)(reg)));
> +               return ioread64(reg);
>         else
>  #endif
> -               return ((u64)rd_reg32((u32 __iomem *)(reg)) << 32 |
> -                       (u64)rd_reg32((u32 __iomem *)(reg) + 1));
> +               return ioread64be(reg);
>  }
> -#endif /* CONFIG_64BIT  */
> 
>  #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
>  #ifdef CONFIG_SOC_IMX7D
> 
> 
>> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
>> Cc: "Horia Geantã" <horia.geanta@nxp.com>
>> Cc: Dan Douglass <dan.douglass@nxp.com>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> ---
>>  drivers/crypto/caam/regs.h | 29 -----------------------------
>>  1 file changed, 29 deletions(-)
>>
>> diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
>> index 84d2f838a063..26fc19dd0c39 100644
>> --- a/drivers/crypto/caam/regs.h
>> +++ b/drivers/crypto/caam/regs.h
>> @@ -134,7 +134,6 @@ static inline void clrsetbits_32(void __iomem *reg, u32 clear, u32 set)
>>   *    base + 0x0000 : least-significant 32 bits
>>   *    base + 0x0004 : most-significant 32 bits
>>   */
>> -#ifdef CONFIG_64BIT
>>  static inline void wr_reg64(void __iomem *reg, u64 data)
>>  {
>>  	if (caam_little_end)
>> @@ -151,34 +150,6 @@ static inline u64 rd_reg64(void __iomem *reg)
>>  		return ioread64be(reg);
>>  }
>>  
>> -#else /* CONFIG_64BIT */
>> -static inline void wr_reg64(void __iomem *reg, u64 data)
>> -{
>> -#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
>> -	if (caam_little_end) {
>> -		wr_reg32((u32 __iomem *)(reg) + 1, data >> 32);
>> -		wr_reg32((u32 __iomem *)(reg), data);
>> -	} else
>> -#endif
>> -	{
>> -		wr_reg32((u32 __iomem *)(reg), data >> 32);
>> -		wr_reg32((u32 __iomem *)(reg) + 1, data);
>> -	}
>> -}
>> -
>> -static inline u64 rd_reg64(void __iomem *reg)
>> -{
>> -#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
>> -	if (caam_little_end)
>> -		return ((u64)rd_reg32((u32 __iomem *)(reg) + 1) << 32 |
>> -			(u64)rd_reg32((u32 __iomem *)(reg)));
>> -	else
>> -#endif
>> -		return ((u64)rd_reg32((u32 __iomem *)(reg)) << 32 |
>> -			(u64)rd_reg32((u32 __iomem *)(reg) + 1));
>> -}
>> -#endif /* CONFIG_64BIT  */
>> -
>>  #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
>>  #ifdef CONFIG_SOC_IMX7D
>>  #define cpu_to_caam_dma(value) \
>>
