From: Horia Geanta Neag <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: caam: do not register AES-XTS mode on LP units
Date: Mon, 7 Nov 2016 07:13:38 +0000
Message-ID: <DB4PR04MB08471753F3A712A732373E0598A70@DB4PR04MB0847.eurprd04.prod.outlook.com>
References: <1478301447-75861-1-git-send-email-sven.ebenfeld@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Cata Vasile <cata.vasile@nxp.com>
To: Sven Ebenfeld <sven.ebenfeld@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0076.outbound.protection.outlook.com ([104.47.2.76]:27089
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753008AbcKGOr7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Nov 2016 09:47:59 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/5/2016 1:17 AM, Sven Ebenfeld wrote:=0A=
> When using AES-XTS on a Wandboard, we receive a Mode error:=0A=
> caam_jr 2102000.jr1: 20001311: CCB: desc idx 19: AES: Mode error.=0A=
> =0A=
> Due to the Security Reference Manual, the Low Power AES units=0A=
s/Due to/According to=0A=
=0A=
> of the i.MX6 do not support the XTS mode. Therefore we should=0A=
> try to provide them them in the API.=0A=
> =0A=
Rephrase: Therefore we mustn't register XTS implementations to Crypto=0A=
API in this case.=0A=
=0A=
> Signed-off-by: Sven Ebenfeld <sven.ebenfeld@gmail.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Please send the patch to -stable and mention the offending commit:=0A=
Cc: <stable@vger.kernel.org> # 4.4+=0A=
Fixes: c6415a6016bf "crypto: caam - add support for acipher xts(aes)"=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
> ---=0A=
>  drivers/crypto/caam/caamalg.c | 9 +++++++++=0A=
>  1 file changed, 9 insertions(+)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c=0A=
> index 156aad1..f5a63ba 100644=0A=
> --- a/drivers/crypto/caam/caamalg.c=0A=
> +++ b/drivers/crypto/caam/caamalg.c=0A=
> @@ -4583,6 +4583,15 @@ static int __init caam_algapi_init(void)=0A=
>  		if (!aes_inst && (alg_sel =3D=3D OP_ALG_ALGSEL_AES))=0A=
>  				continue;=0A=
>  =0A=
> +		/*=0A=
> +		 * Check support for AES modes not available=0A=
> +		 * on LP devices.=0A=
> +		 */=0A=
> +		if ((cha_vid & CHA_ID_LS_AES_MASK) =3D=3D CHA_ID_LS_AES_LP)=0A=
> +			if ((alg->class1_alg_type & OP_ALG_AAI_MASK) =3D=3D=0A=
> +			     OP_ALG_AAI_XTS)=0A=
> +				continue;=0A=
> +=0A=
>  		t_alg =3D caam_alg_alloc(alg);=0A=
>  		if (IS_ERR(t_alg)) {=0A=
>  			err =3D PTR_ERR(t_alg);=0A=
> =0A=
=0A=
