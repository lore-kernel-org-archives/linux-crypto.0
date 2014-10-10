From: "tudor.ambarus@freescale.com" <tudor.ambarus@freescale.com>
Subject: RE: [PATCH 2/2] crypto: caam - add support for rfc4106(gcm(aes))
Date: Fri, 10 Oct 2014 10:10:55 +0000
Message-ID: <d162838411ed444f82f75bb211653b5a@DM2PR0301MB0720.namprd03.prod.outlook.com>
References: <1412866450-22587-1-git-send-email-tudor.ambarus@freescale.com>
	<1412866450-22587-2-git-send-email-tudor.ambarus@freescale.com>
 <20141009194358.dd99e22634005c93f462274d@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: Kim Phillips <Kim.Phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0119.outbound.protection.outlook.com ([207.46.100.119]:16317
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753538AbaJJKK6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Oct 2014 06:10:58 -0400
In-Reply-To: <20141009194358.dd99e22634005c93f462274d@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Thu, 9 Oct 2014 17:54:10 +0300
Tudor Ambarus <tudor.ambarus@freescale.com> wrote:

> +static int rfc4106_set_sh_desc(struct crypto_aead *aead)
...
> +	/*
> +	 * Job Descriptor and Shared Descriptors
> +	 * must all fit into the 64-word Descriptor h/w Buffer
> +	 */
> +	if (DESC_RFC4106_DEC_LEN + DESC_JOB_IO_LEN +
> +	    ctx->enckeylen <= CAAM_DESC_BYTES_MAX)
> +		key_fit_inline = true;

we need to reset encrypt descriptor's keys_fit_inline setting to
false before doing this.

Also, the singular of "keys_fit_inline" is "key_fits_inline", but
I'd prefer we not gratuitously rename the variable from the rest of
the driver's keys_fit_inline for consistency's sake, thanks.
[TA] Agreed.

> +	/*
> +	 * Job Descriptor and Shared Descriptors
> +	 * must all fit into the 64-word Descriptor h/w Buffer
> +	 */
> +	if (DESC_RFC4106_GIVENC_LEN + DESC_JOB_IO_LEN +
> +	    ctx->split_key_pad_len + ctx->enckeylen <=
> +	    CAAM_DESC_BYTES_MAX)
> +		key_fit_inline = true;

we need to reset the variable here too.
[TA] Agreed.

> +static int rfc4106_setauthsize(struct crypto_aead *authenc,
> +			       unsigned int authsize)
> +{
> +	struct caam_ctx *ctx = crypto_aead_ctx(authenc);
> +
> +	switch (authsize) {
> +	case 8:
> +	case 12:
> +	case 16:
> +		break;
> +	default:
> +		return -EINVAL;
> +	}

the h/w can handle more authsizes than that, so we
shouldn't be blocking it from doing so here.

[TA] rfc4106 says that "Implementations MUST support a full-length 16-octet ICV, and MAY support 8 or 12 octet ICVs, and MUST NOT support other ICV lengths."
Do we want to support other ICV lengths?

> @@ -2601,6 +2986,23 @@ static struct caam_alg_template driver_algs[] = {
>  				   OP_ALG_AAI_HMAC_PRECOMP,
>  		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
>  	},
> +	{
> +		.name = "rfc4106(gcm(aes))",
> +		.driver_name = "rfc4106-gcm-aes-caam",
> +		.blocksize = 1,
> +		.type = CRYPTO_ALG_TYPE_AEAD,
> +		.template_aead = {
> +			.setkey = rfc4106_setkey,
> +			.setauthsize = rfc4106_setauthsize,
> +			.encrypt = aead_encrypt,
> +			.decrypt = aead_decrypt,
> +			.givencrypt = aead_givencrypt,
> +			.geniv = "<built-in>",
> +			.ivsize = 8,
> +			.maxauthsize = 16,

AES_BLOCK_SIZE

[TA] I don't think we should change the blocksize value to AES_BLOCK_SIZE.

Thank you,
Tudor

Thanks,

Kim
