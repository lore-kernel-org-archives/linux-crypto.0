From: Horia Ioan Geanta Neag <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: caam - replace deprecated EXTRA_CFLAGS
Date: Fri, 17 Jun 2016 12:22:54 +0000
Message-ID: <AM2PR04MB06732356E090D3647FAFB1D698570@AM2PR04MB0673.eurprd04.prod.outlook.com>
References: <1466083975-27054-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0061.outbound.protection.outlook.com ([157.56.112.61]:65479
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753534AbcFQMW6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jun 2016 08:22:58 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/16/2016 4:33 PM, Tudor Ambarus wrote:
> EXTRA_CFLAGS is still supported but its usage is deprecated.
>=20
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>

> ---
>  drivers/crypto/caam/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makef=
ile
> index 399ad55..3e9d3e1 100644
> --- a/drivers/crypto/caam/Makefile
> +++ b/drivers/crypto/caam/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for the CAAM backend and dependent components
>  #
>  ifeq ($(CONFIG_CRYPTO_DEV_FSL_CAAM_DEBUG), y)
> -	EXTRA_CFLAGS :=3D -DDEBUG
> +	ccflags-y :=3D -DDEBUG
>  endif
> =20
>  ccflags-y +=3D -I$(srctree)/crypto
>=20
