From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [RFC PATCH 1/2] crypto: caam - properly set IV after {en,de}crypt
Date: Mon, 19 Jun 2017 10:31:27 +0000
Message-ID: <VI1PR0401MB2591177E3F43DEFA8AEA3D6D98C40@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170602122446.2427-1-david@sigma-star.at>
 <20170602122446.2427-2-david@sigma-star.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "richard@sigma-star.at" <richard@sigma-star.at>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: David Gstir <david@sigma-star.at>,
        Dan Douglass <dan.douglass@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0066.outbound.protection.outlook.com ([104.47.2.66]:11435
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753830AbdFSKbc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 06:31:32 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/2/2017 3:25 PM, David Gstir wrote:=0A=
> Certain cipher modes like CTS expect the IV (req->info) of=0A=
> ablkcipher_request (or equivalently req->iv of skcipher_request) to=0A=
> contain the last ciphertext block when the {en,de}crypt operation is done=
.=0A=
> This is currently not the case for the CAAM driver which in turn breaks=
=0A=
> e.g. cts(cbc(aes)) when the CAAM driver is enabled.=0A=
> =0A=
> This patch fixes the CAAM driver to properly set the IV after the=0A=
> {en,de}crypt operation of ablkcipher finishes.=0A=
> =0A=
> Signed-off-by: David Gstir <david@sigma-star.at>=0A=
> ---=0A=
>  drivers/crypto/caam/caamalg.c | 26 ++++++++++++++++++++++++--=0A=
>  1 file changed, 24 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c=0A=
> index 398807d1b77e..d13c1aee4427 100644=0A=
> --- a/drivers/crypto/caam/caamalg.c=0A=
> +++ b/drivers/crypto/caam/caamalg.c=0A=
> @@ -882,10 +882,11 @@ static void ablkcipher_encrypt_done(struct device *=
jrdev, u32 *desc, u32 err,=0A=
>  {=0A=
>  	struct ablkcipher_request *req =3D context;=0A=
>  	struct ablkcipher_edesc *edesc;=0A=
> -#ifdef DEBUG=0A=
>  	struct crypto_ablkcipher *ablkcipher =3D crypto_ablkcipher_reqtfm(req);=
=0A=
>  	int ivsize =3D crypto_ablkcipher_ivsize(ablkcipher);=0A=
> +	int nents;=0A=
>  =0A=
> +#ifdef DEBUG=0A=
>  	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);=0A=
>  #endif=0A=
>  =0A=
> @@ -904,6 +905,19 @@ static void ablkcipher_encrypt_done(struct device *j=
rdev, u32 *desc, u32 err,=0A=
>  #endif=0A=
>  =0A=
>  	ablkcipher_unmap(jrdev, edesc, req);=0A=
> +=0A=
> +	if (req->src =3D=3D req->dst)=0A=
> +		nents =3D edesc->src_nents;=0A=
> +	else=0A=
> +		nents =3D edesc->dst_nents;=0A=
> +=0A=
> +	/*=0A=
> +	 * The crypto API expects us to set the IV (req->info) to the last=0A=
> +	 * ciphertext block. This is used e.g. by the CTS mode.=0A=
> +	 */=0A=
=0A=
IIUC, IV update is required only in case of CBC.=0A=
Since this callback is used also for CTR, we should avoid the copy:=0A=
if ((ctx->cdata.algtype & OP_ALG_AAI_MASK) =3D=3D OP_ALG_AAI_CBC) ...=0A=
=0A=
> +	sg_pcopy_to_buffer(req->dst, nents, req->info, ivsize,=0A=
> +			   req->nbytes - ivsize);=0A=
=0A=
scatterwalk_map_and_copy() should be used instead.=0A=
=0A=
> +=0A=
>  	kfree(edesc);=0A=
>  =0A=
>  	ablkcipher_request_complete(req, err);=0A=
> @@ -914,10 +928,10 @@ static void ablkcipher_decrypt_done(struct device *=
jrdev, u32 *desc, u32 err,=0A=
>  {=0A=
>  	struct ablkcipher_request *req =3D context;=0A=
>  	struct ablkcipher_edesc *edesc;=0A=
> -#ifdef DEBUG=0A=
>  	struct crypto_ablkcipher *ablkcipher =3D crypto_ablkcipher_reqtfm(req);=
=0A=
>  	int ivsize =3D crypto_ablkcipher_ivsize(ablkcipher);=0A=
>  =0A=
> +#ifdef DEBUG=0A=
>  	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);=0A=
>  #endif=0A=
>  =0A=
> @@ -935,6 +949,14 @@ static void ablkcipher_decrypt_done(struct device *j=
rdev, u32 *desc, u32 err,=0A=
>  #endif=0A=
>  =0A=
>  	ablkcipher_unmap(jrdev, edesc, req);=0A=
> +=0A=
> +	/*=0A=
> +	 * The crypto API expects us to set the IV (req->info) to the last=0A=
> +	 * ciphertext block.=0A=
> +	 */=0A=
> +	sg_pcopy_to_buffer(req->src, edesc->src_nents, req->info, ivsize,=0A=
> +			   req->nbytes - ivsize);=0A=
> +=0A=
>  	kfree(edesc);=0A=
>  =0A=
>  	ablkcipher_request_complete(req, err);=0A=
>=0A=
