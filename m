From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v9 7/8] crypto: caam: cleanup CONFIG_64BIT ifdefs when
 using io{read|write}64
Date: Thu, 4 Jan 2018 07:25:55 +0000
Message-ID: <VI1PR0402MB3342D07D8173696E94B38C54981F0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <20180103180618.18401-1-logang@deltatee.com>
 <20180103180618.18401-8-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Aymen Sghaier" <aymen.sghaier@nxp.com>
To: Logan Gunthorpe <logang@deltatee.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-ntb@googlegroups.com" <linux-ntb@googlegroups.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr30086.outbound.protection.outlook.com ([40.107.3.86]:18720
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750990AbeADHZ7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jan 2018 02:25:59 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1/3/2018 8:07 PM, Logan Gunthorpe wrote:=0A=
> Clean up the extra ifdefs which defined the wr_reg64 and rd_reg64=0A=
> functions in non-64bit cases in favour of the new common=0A=
> io-64-nonatomic-lo-hi header.=0A=
> =0A=
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>=0A=
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Dan Douglass <dan.douglass@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: "David S. Miller" <davem@davemloft.net>=0A=
> ---=0A=
>  drivers/crypto/caam/regs.h | 26 +-------------------------=0A=
>  1 file changed, 1 insertion(+), 25 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h=0A=
> index fee363865d88..ec6528e5ce9d 100644=0A=
> --- a/drivers/crypto/caam/regs.h=0A=
> +++ b/drivers/crypto/caam/regs.h=0A=
> @@ -10,7 +10,7 @@=0A=
>  =0A=
>  #include <linux/types.h>=0A=
>  #include <linux/bitops.h>=0A=
> -#include <linux/io.h>=0A=
> +#include <linux/io-64-nonatomic-hi-lo.h>=0A=
Typo: lo-hi should be used instead (see previous patch versions).=0A=
=0A=
Please add in the commit message the explanation (which was there in v8 but=
=0A=
removed in v9):=0A=
To be consistent with CAAM engine HW spec: in case of 64-bit registers,=0A=
irrespective of device endianness, the lower address should be read from=0A=
/ written to first, followed by the upper address. Indeed the I/O=0A=
accessors in CAAM driver currently don't follow the spec, however this=0A=
is a good opportunity to fix the code.=0A=
=0A=
>  =0A=
>  /*=0A=
>   * Architecture-specific register access methods=0A=
> @@ -136,7 +136,6 @@ static inline void clrsetbits_32(void __iomem *reg, u=
32 clear, u32 set)=0A=
>   *    base + 0x0000 : least-significant 32 bits=0A=
>   *    base + 0x0004 : most-significant 32 bits=0A=
>   */=0A=
> -#ifdef CONFIG_64BIT=0A=
>  static inline void wr_reg64(void __iomem *reg, u64 data)=0A=
>  {=0A=
>  	if (caam_little_end)=0A=
Since the 2 cases (32/64-bit) are merged, caam_imx should be accounted for =
the=0A=
logic to stay the same.=0A=
=0A=
This means for e.g. for wr_reg64 (similar for rd_reg64):=0A=
static inline void wr_reg64(void __iomem *reg, u64 data)=0A=
{=0A=
	if (!caam_imx && caam_little_end)=0A=
		iowrite64(data, reg);=0A=
	else=0A=
		iowrite64be(data, reg);=0A=
}=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
> @@ -153,29 +152,6 @@ static inline u64 rd_reg64(void __iomem *reg)=0A=
>  		return ioread64be(reg);=0A=
>  }=0A=
>  =0A=
> -#else /* CONFIG_64BIT */=0A=
> -static inline void wr_reg64(void __iomem *reg, u64 data)=0A=
> -{=0A=
> -	if (!caam_imx && caam_little_end) {=0A=
> -		wr_reg32((u32 __iomem *)(reg) + 1, data >> 32);=0A=
> -		wr_reg32((u32 __iomem *)(reg), data);=0A=
> -	} else {=0A=
> -		wr_reg32((u32 __iomem *)(reg), data >> 32);=0A=
> -		wr_reg32((u32 __iomem *)(reg) + 1, data);=0A=
> -	}=0A=
> -}=0A=
> -=0A=
> -static inline u64 rd_reg64(void __iomem *reg)=0A=
> -{=0A=
> -	if (!caam_imx && caam_little_end)=0A=
> -		return ((u64)rd_reg32((u32 __iomem *)(reg) + 1) << 32 |=0A=
> -			(u64)rd_reg32((u32 __iomem *)(reg)));=0A=
> -=0A=
> -	return ((u64)rd_reg32((u32 __iomem *)(reg)) << 32 |=0A=
> -		(u64)rd_reg32((u32 __iomem *)(reg) + 1));=0A=
> -}=0A=
> -#endif /* CONFIG_64BIT  */=0A=
> -=0A=
>  static inline u64 cpu_to_caam_dma64(dma_addr_t value)=0A=
>  {=0A=
>  	if (caam_imx)=0A=
> =0A=
