From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 7/7] crypto: caam: cleanup CONFIG_64BIT ifdefs when using
 io{read|write}64
Date: Fri, 23 Jun 2017 06:51:14 +0000
Message-ID: <VI1PR0401MB259182B9B11B72B4B53B2C1498D80@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170622164817.25515-1-logang@deltatee.com>
 <20170622164817.25515-8-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Bates <sbates@raithlin.com>,
        "Dan Douglass" <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Radu Solea <radu.solea@nxp.com>,
        Steve Cornelius <steve.cornelius@nxp.com>
To: Logan Gunthorpe <logang@deltatee.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-ntb@googlegroups.com" <linux-ntb@googlegroups.com>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:1488
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754334AbdFWGvU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 02:51:20 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/22/2017 7:49 PM, Logan Gunthorpe wrote:=0A=
> Now that ioread64 and iowrite64 are always available we don't=0A=
> need the ugly ifdefs to change their implementation when they=0A=
> are not.=0A=
> =0A=
Thanks Logan.=0A=
=0A=
Note however this is not equivalent - it changes the behaviour, since=0A=
CAAM engine on i.MX6S/SL/D/Q platforms is broken in terms of 64-bit=0A=
register endianness - see CONFIG_CRYPTO_DEV_FSL_CAAM_IMX usage in code=0A=
you are removing.=0A=
=0A=
[Yes, current code has its problems, as it does not differentiate b/w=0A=
i.MX platforms with and without the (unofficial) erratum, but this=0A=
should be fixed separately.]=0A=
=0A=
Below is the change that would keep current logic - still forcing i.MX=0A=
to write CAAM 64-bit registers in BE even if the engine is LE (yes, diff=0A=
is doing a poor job).=0A=
=0A=
Horia=0A=
=0A=
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h=0A=
index 84d2f838a063..b893ebb24e65 100644=0A=
--- a/drivers/crypto/caam/regs.h=0A=
+++ b/drivers/crypto/caam/regs.h=0A=
@@ -134,50 +134,25 @@ static inline void clrsetbits_32(void __iomem=0A=
*reg, u32 clear, u32 set)=0A=
  *    base + 0x0000 : least-significant 32 bits=0A=
  *    base + 0x0004 : most-significant 32 bits=0A=
  */=0A=
-#ifdef CONFIG_64BIT=0A=
 static inline void wr_reg64(void __iomem *reg, u64 data)=0A=
 {=0A=
+#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX=0A=
        if (caam_little_end)=0A=
                iowrite64(data, reg);=0A=
        else=0A=
-               iowrite64be(data, reg);=0A=
-}=0A=
-=0A=
-static inline u64 rd_reg64(void __iomem *reg)=0A=
-{=0A=
-       if (caam_little_end)=0A=
-               return ioread64(reg);=0A=
-       else=0A=
-               return ioread64be(reg);=0A=
-}=0A=
-=0A=
-#else /* CONFIG_64BIT */=0A=
-static inline void wr_reg64(void __iomem *reg, u64 data)=0A=
-{=0A=
-#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX=0A=
-       if (caam_little_end) {=0A=
-               wr_reg32((u32 __iomem *)(reg) + 1, data >> 32);=0A=
-               wr_reg32((u32 __iomem *)(reg), data);=0A=
-       } else=0A=
 #endif=0A=
-       {=0A=
-               wr_reg32((u32 __iomem *)(reg), data >> 32);=0A=
-               wr_reg32((u32 __iomem *)(reg) + 1, data);=0A=
-       }=0A=
+               iowrite64be(data, reg);=0A=
 }=0A=
=0A=
 static inline u64 rd_reg64(void __iomem *reg)=0A=
 {=0A=
 #ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX=0A=
        if (caam_little_end)=0A=
-               return ((u64)rd_reg32((u32 __iomem *)(reg) + 1) << 32 |=0A=
-                       (u64)rd_reg32((u32 __iomem *)(reg)));=0A=
+               return ioread64(reg);=0A=
        else=0A=
 #endif=0A=
-               return ((u64)rd_reg32((u32 __iomem *)(reg)) << 32 |=0A=
-                       (u64)rd_reg32((u32 __iomem *)(reg) + 1));=0A=
+               return ioread64be(reg);=0A=
 }=0A=
-#endif /* CONFIG_64BIT  */=0A=
=0A=
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT=0A=
 #ifdef CONFIG_SOC_IMX7D=0A=
=0A=
=0A=
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>=0A=
> Cc: "Horia Geant=E3" <horia.geanta@nxp.com>=0A=
> Cc: Dan Douglass <dan.douglass@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: "David S. Miller" <davem@davemloft.net>=0A=
> ---=0A=
>  drivers/crypto/caam/regs.h | 29 -----------------------------=0A=
>  1 file changed, 29 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h=0A=
> index 84d2f838a063..26fc19dd0c39 100644=0A=
> --- a/drivers/crypto/caam/regs.h=0A=
> +++ b/drivers/crypto/caam/regs.h=0A=
> @@ -134,7 +134,6 @@ static inline void clrsetbits_32(void __iomem *reg, u=
32 clear, u32 set)=0A=
>   *    base + 0x0000 : least-significant 32 bits=0A=
>   *    base + 0x0004 : most-significant 32 bits=0A=
>   */=0A=
> -#ifdef CONFIG_64BIT=0A=
>  static inline void wr_reg64(void __iomem *reg, u64 data)=0A=
>  {=0A=
>  	if (caam_little_end)=0A=
> @@ -151,34 +150,6 @@ static inline u64 rd_reg64(void __iomem *reg)=0A=
>  		return ioread64be(reg);=0A=
>  }=0A=
>  =0A=
> -#else /* CONFIG_64BIT */=0A=
> -static inline void wr_reg64(void __iomem *reg, u64 data)=0A=
> -{=0A=
> -#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX=0A=
> -	if (caam_little_end) {=0A=
> -		wr_reg32((u32 __iomem *)(reg) + 1, data >> 32);=0A=
> -		wr_reg32((u32 __iomem *)(reg), data);=0A=
> -	} else=0A=
> -#endif=0A=
> -	{=0A=
> -		wr_reg32((u32 __iomem *)(reg), data >> 32);=0A=
> -		wr_reg32((u32 __iomem *)(reg) + 1, data);=0A=
> -	}=0A=
> -}=0A=
> -=0A=
> -static inline u64 rd_reg64(void __iomem *reg)=0A=
> -{=0A=
> -#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX=0A=
> -	if (caam_little_end)=0A=
> -		return ((u64)rd_reg32((u32 __iomem *)(reg) + 1) << 32 |=0A=
> -			(u64)rd_reg32((u32 __iomem *)(reg)));=0A=
> -	else=0A=
> -#endif=0A=
> -		return ((u64)rd_reg32((u32 __iomem *)(reg)) << 32 |=0A=
> -			(u64)rd_reg32((u32 __iomem *)(reg) + 1));=0A=
> -}=0A=
> -#endif /* CONFIG_64BIT  */=0A=
> -=0A=
>  #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT=0A=
>  #ifdef CONFIG_SOC_IMX7D=0A=
>  #define cpu_to_caam_dma(value) \=0A=
> =0A=
