From: Cristian Stoica <cristian.stoica@nxp.com>
Subject: RE: [PATCH v2 3/4] crypto: add CONFIG_ symbol for rsa helper
Date: Mon, 28 Mar 2016 16:48:17 +0000
Message-ID: <AM4PR0401MB1876223BF756FC5AF4A5A421E7860@AM4PR0401MB1876.eurprd04.prod.outlook.com>
References: <1458745459-1096-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1458745459-1096-4-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"smueller@chronox.de" <smueller@chronox.de>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>,
	Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
To: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"tadeusz.struk@intel.com" <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0086.outbound.protection.outlook.com ([157.56.112.86]:33792
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754814AbcC1QsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Mar 2016 12:48:20 -0400
In-Reply-To: <1458745459-1096-4-git-send-email-tudor-dan.ambarus@nxp.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of Tudor Ambarus
> Sent: Wednesday, March 23, 2016 5:04 PM
> To: herbert@gondor.apana.org.au; tadeusz.struk@intel.com
> Cc: linux-crypto@vger.kernel.org; smueller@chronox.de; Horia Ioan Geanta
> Neag <horia.geanta@nxp.com>; Tudor-Dan Ambarus <tudor-
> dan.ambarus@nxp.com>
> Subject: [PATCH v2 3/4] crypto: add CONFIG_ symbol for rsa helper
> 
> All RSA implementations can now use the key extract symbols by selecting
> CRYPTO_RSA_HELPER.
> 
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

Acked-by: Cristian Stoica <cristian.stoica@nxp.com>
> ---
>  crypto/Kconfig  | 8 ++++++--
>  crypto/Makefile | 6 +++---
>  2 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig index f6bfdda..2bdf882 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -93,11 +93,15 @@ config CRYPTO_AKCIPHER
>  	select CRYPTO_AKCIPHER2
>  	select CRYPTO_ALGAPI
> 
> -config CRYPTO_RSA
> -	tristate "RSA algorithm"
> +config CRYPTO_RSA_HELPER
> +	bool "RSA key extract helper"
>  	select CRYPTO_AKCIPHER
>  	select MPILIB
>  	select ASN1
> +
> +config CRYPTO_RSA
> +	tristate "RSA algorithm"
> +	select CRYPTO_RSA_HELPER
>  	help
>  	  Generic implementation of the RSA public key algorithm.
> 
> diff --git a/crypto/Makefile b/crypto/Makefile index 4f4ef7e..d336d83
> 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -36,10 +36,10 @@ $(obj)/rsaprivkey-asn1.o: $(obj)/rsaprivkey-asn1.c
> $(obj)/rsaprivkey-asn1.h  clean-files += rsapubkey-asn1.c rsapubkey-asn1.h
> clean-files += rsaprivkey-asn1.c rsaprivkey-asn1.h
> 
> -rsa_generic-y := rsapubkey-asn1.o
> -rsa_generic-y += rsaprivkey-asn1.o
> +crypto_rsa_helper-y += rsapubkey-asn1.o rsaprivkey-asn1.o rsa_helper.o
> +obj-$(CONFIG_CRYPTO_RSA_HELPER) += crypto_rsa_helper.o
> +
>  rsa_generic-y += rsa.o
> -rsa_generic-y += rsa_helper.o
>  rsa_generic-y += rsa-pkcs1pad.o
>  obj-$(CONFIG_CRYPTO_RSA) += rsa_generic.o
> 
> --
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
