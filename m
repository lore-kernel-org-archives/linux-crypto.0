From: Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: RE: [PATCH] crypto: caam - Fix key inlining in AEAD shared
 descriptors
Date: Mon, 28 Apr 2014 05:39:45 +0000
Message-ID: <4180d0037a2f45d18c16e601a134846c@BL2PR03MB466.namprd03.prod.outlook.com>
References: <1398612374-1746-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"Horia.Geanta@freescale.com" <Horia.Geanta@freescale.com>,
	"alexandru.porosanu@freescale.com" <alexandru.porosanu@freescale.com>
To: Vakul Garg <vakul@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:44744
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751502AbaD1Fym convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Apr 2014 01:54:42 -0400
In-Reply-To: <1398612374-1746-1-git-send-email-vakul@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Reviewed-by: Ruchika Gupta <ruchika.gupta@freescale.com>

> -----Original Message-----
> From: Vakul Garg [mailto:vakul@freescale.com]
> Sent: Sunday, April 27, 2014 8:56 PM
> To: linux-crypto@vger.kernel.org
> Cc: herbert@gondor.apana.org.au; Geanta Neag Horia Ioan-B05471; Gupta
> Ruchika-R66431; Porosanu Alexandru-B06830
> Subject: [PATCH] crypto: caam - Fix key inlining in AEAD shared descriptors
> 
> The variable 'keys_fit_inline' is initialised correctly to avoid using its
> stale value while creating shared descriptor for decryption and given-iv-
> encryption.
> 
> Signed-off-by: Vakul Garg <vakul@freescale.com>
> ---
>  drivers/crypto/caam/caamalg.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
> index 5f89125..99fda94 100644
> --- a/drivers/crypto/caam/caamalg.c
> +++ b/drivers/crypto/caam/caamalg.c
> @@ -209,7 +209,7 @@ static int aead_null_set_sh_desc(struct crypto_aead
> *aead)
>  	struct aead_tfm *tfm = &aead->base.crt_aead;
>  	struct caam_ctx *ctx = crypto_aead_ctx(aead);
>  	struct device *jrdev = ctx->jrdev;
> -	bool keys_fit_inline = false;
> +	bool keys_fit_inline;
>  	u32 *key_jump_cmd, *jump_cmd, *read_move_cmd, *write_move_cmd;
>  	u32 *desc;
> 
> @@ -220,6 +220,8 @@ static int aead_null_set_sh_desc(struct crypto_aead
> *aead)
>  	if (DESC_AEAD_NULL_ENC_LEN + DESC_JOB_IO_LEN +
>  	    ctx->split_key_pad_len <= CAAM_DESC_BYTES_MAX)
>  		keys_fit_inline = true;
> +	else
> +		keys_fit_inline = false;
> 
>  	/* aead_encrypt shared descriptor */
>  	desc = ctx->sh_desc_enc;
> @@ -306,6 +308,8 @@ static int aead_null_set_sh_desc(struct crypto_aead
> *aead)
>  	if (DESC_AEAD_NULL_DEC_LEN + DESC_JOB_IO_LEN +
>  	    ctx->split_key_pad_len <= CAAM_DESC_BYTES_MAX)
>  		keys_fit_inline = true;
> +	else
> +		keys_fit_inline = false;
> 
>  	desc = ctx->sh_desc_dec;
> 
> @@ -399,7 +403,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
>  	struct aead_tfm *tfm = &aead->base.crt_aead;
>  	struct caam_ctx *ctx = crypto_aead_ctx(aead);
>  	struct device *jrdev = ctx->jrdev;
> -	bool keys_fit_inline = false;
> +	bool keys_fit_inline;
>  	u32 geniv, moveiv;
>  	u32 *desc;
> 
> @@ -418,6 +422,9 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
>  	    ctx->split_key_pad_len + ctx->enckeylen <=
>  	    CAAM_DESC_BYTES_MAX)
>  		keys_fit_inline = true;
> +	else
> +		keys_fit_inline = false;
> +
> 
>  	/* aead_encrypt shared descriptor */
>  	desc = ctx->sh_desc_enc;
> @@ -476,6 +483,8 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
>  	    ctx->split_key_pad_len + ctx->enckeylen <=
>  	    CAAM_DESC_BYTES_MAX)
>  		keys_fit_inline = true;
> +	else
> +		keys_fit_inline = false;
> 
>  	/* aead_decrypt shared descriptor */
>  	desc = ctx->sh_desc_dec;
> @@ -531,6 +540,8 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
>  	    ctx->split_key_pad_len + ctx->enckeylen <=
>  	    CAAM_DESC_BYTES_MAX)
>  		keys_fit_inline = true;
> +	else
> +		keys_fit_inline = false;
> 
>  	/* aead_givencrypt shared descriptor */
>  	desc = ctx->sh_desc_givenc;
> --
> 1.8.1.4
