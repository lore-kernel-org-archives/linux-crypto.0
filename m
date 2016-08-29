From: Horia Ioan Geanta Neag <horia.geanta@nxp.com>
Subject: Re: [PATCH v2] crypto: caam - fix IV loading for authenc
 (giv)decryption
Date: Mon, 29 Aug 2016 09:58:28 +0000
Message-ID: <DB4PR04MB08477E8807C86C2EF225A23C98E10@DB4PR04MB0847.eurprd04.prod.outlook.com>
References: <1472224633-25412-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0079.outbound.protection.outlook.com ([104.47.2.79]:15890
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932868AbcH2J6b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Aug 2016 05:58:31 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 8/26/2016 6:33 PM, Horia Geant=E3 wrote:=0A=
> For algorithms that implement IV generators before the crypto ops,=0A=
> the IV needed for decryption is initially located in req->src=0A=
> scatterlist, not in req->iv.=0A=
> =0A=
> Avoid copying the IV into req->iv by modifying the (givdecrypt)=0A=
> descriptors to load it directly from req->src.=0A=
> aead_givdecrypt() is no longer needed and goes away.=0A=
> =0A=
> Cc: <stable@vger.kernel.org> # 4.3+=0A=
> Fixes: 479bcc7c5b9e ("crypto: caam - Convert authenc to new AEAD interfac=
e")=0A=
> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> ---=0A=
> =0A=
>  drivers/crypto/caam/caamalg.c | 77 +++++++++++++++++++++----------------=
------=0A=
>  1 file changed, 37 insertions(+), 40 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c=0A=
> index 6dc597126b79..775b8b524913 100644=0A=
> --- a/drivers/crypto/caam/caamalg.c=0A=
> +++ b/drivers/crypto/caam/caamalg.c=0A=
> @@ -556,7 +556,10 @@ skip_enc:=0A=
>  =0A=
>  	/* Read and write assoclen bytes */=0A=
>  	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);=0A=
> -	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);=0A=
> +	if (alg->caam.geniv)=0A=
> +		append_math_add_imm_u32(desc, VARSEQOUTLEN, REG3, IMM, ivsize);=0A=
> +	else=0A=
> +		append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);=0A=
>  =0A=
>  	/* Skip assoc data */=0A=
>  	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);=0A=
> @@ -565,6 +568,14 @@ skip_enc:=0A=
>  	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |=
=0A=
>  			     KEY_VLF);=0A=
>  =0A=
> +	if (alg->caam.geniv) {=0A=
> +		append_seq_load(desc, ivsize, LDST_CLASS_1_CCB |=0A=
> +				LDST_SRCDST_BYTE_CONTEXT |=0A=
> +				(ctx1_iv_off << LDST_OFFSET_SHIFT));=0A=
> +		append_move(desc, MOVE_SRC_CLASS1CTX | MOVE_DEST_CLASS2INFIFO |=0A=
> +			    (ctx1_iv_off << MOVE_OFFSET_SHIFT) | ivsize);=0A=
> +	}=0A=
> +=0A=
>  	/* Load Counter into CONTEXT1 reg */=0A=
>  	if (is_rfc3686)=0A=
>  		append_load_imm_u32(desc, be32_to_cpu(1), LDST_IMM |=0A=
> @@ -2150,7 +2161,7 @@ static void init_authenc_job(struct aead_request *r=
eq,=0A=
>  =0A=
>  	init_aead_job(req, edesc, all_contig, encrypt);=0A=
>  =0A=
> -	if (ivsize && (is_rfc3686 || !(alg->caam.geniv && encrypt)))=0A=
> +	if (ivsize && !alg->caam.geniv)=0A=
=0A=
This condition update is incorrect, since IV won't be loaded neither=0A=
here nor in the givencrypt aead descriptor for rfc3686 case.=0A=
I'll send v3 shortly.=0A=
=0A=
>  		append_load_as_imm(desc, req->iv, ivsize,=0A=
>  				   LDST_CLASS_1_CCB |=0A=
>  				   LDST_SRCDST_BYTE_CONTEXT |=0A=
