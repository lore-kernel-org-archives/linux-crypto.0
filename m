From: Cristian Stoica <cristian.stoica@nxp.com>
Subject: RE: [PATCH v2 4/4] crypto: rsa_helper - export symbols for asn1
 structures
Date: Mon, 28 Mar 2016 16:48:34 +0000
Message-ID: <AM4PR0401MB1876853E5118A36AE976DA7AE7860@AM4PR0401MB1876.eurprd04.prod.outlook.com>
References: <1458745459-1096-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1458745459-1096-5-git-send-email-tudor-dan.ambarus@nxp.com>
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
Received: from mail-db5eur01on0087.outbound.protection.outlook.com ([104.47.2.87]:28625
	"EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754086AbcC1Qsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Mar 2016 12:48:37 -0400
In-Reply-To: <1458745459-1096-5-git-send-email-tudor-dan.ambarus@nxp.com>
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
> Subject: [PATCH v2 4/4] crypto: rsa_helper - export symbols for asn1
> structures
> 
> Export rsapubkey_decoder and rsaprivkey_decoder structures, since they
> can (will) be used by caam and qat drivers.
> 
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

Acked-by: Cristian Stoica <cristian.stoica@nxp.com>

> ---
>  crypto/rsa_helper.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c index df1f480..d81a0ec
> 100644
> --- a/crypto/rsa_helper.c
> +++ b/crypto/rsa_helper.c
> @@ -21,6 +21,9 @@
>  #include "rsapubkey-asn1.h"
>  #include "rsaprivkey-asn1.h"
> 
> +EXPORT_SYMBOL_GPL(rsapubkey_decoder);
> +EXPORT_SYMBOL_GPL(rsaprivkey_decoder);
> +
>  int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
>  	      const void *value, size_t vlen)
>  {
> --
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
