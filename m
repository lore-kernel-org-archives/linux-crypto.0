From: Horia Ioan Geanta Neag <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: caam: fix misspelled upper_32_bits
Date: Thu, 16 Jun 2016 10:28:23 +0000
Message-ID: <DB4PR04MB0686F901AB1265AF2F60E23998560@DB4PR04MB0686.eurprd04.prod.outlook.com>
References: <20160616090609.1041337-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0090.outbound.protection.outlook.com ([157.56.112.90]:20521
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751640AbcFPK22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jun 2016 06:28:28 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/16/2016 12:04 PM, Arnd Bergmann wrote:
> An endianess fix mistakenly used higher_32_bits() instead of
> upper_32_bits(), and that doesn't exist:
>=20
> drivers/crypto/caam/desc_constr.h: In function 'append_ptr':
> drivers/crypto/caam/desc_constr.h:84:75: error: implicit declaration =
of function 'higher_32_bits' [-Werror=3Dimplicit-function-declaration]
>   *offset =3D cpu_to_caam_dma(ptr);
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 261ea058f016 ("crypto: caam - handle core endianness !=3D caam=
 endianness")

Oops... thanks Arnd!
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>

> ---
>  drivers/crypto/caam/regs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
> index 8c766cf9202c..b3c5016f6458 100644
> --- a/drivers/crypto/caam/regs.h
> +++ b/drivers/crypto/caam/regs.h
> @@ -183,10 +183,10 @@ static inline u64 rd_reg64(void __iomem *reg)
>  #ifdef CONFIG_SOC_IMX7D
>  #define cpu_to_caam_dma(value) \
>  		(((u64)cpu_to_caam32(lower_32_bits(value)) << 32) | \
> -		 (u64)cpu_to_caam32(higher_32_bits(value)))
> +		  (u64)cpu_to_caam32(upper_32_bits(value)))
>  #define caam_dma_to_cpu(value) \
>  		(((u64)caam32_to_cpu(lower_32_bits(value)) << 32) | \
> -		 (u64)caam32_to_cpu(higher_32_bits(value)))
> +		  (u64)caam32_to_cpu(upper_32_bits(value)))
>  #else
>  #define cpu_to_caam_dma(value) cpu_to_caam64(value)
>  #define caam_dma_to_cpu(value) caam64_to_cpu(value)
>=20
