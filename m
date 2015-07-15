From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH  v2 3/3] crypto: qat - Add support for RSA algorithm
Date: Wed, 15 Jul 2015 21:03:33 +0800
Message-ID: <20150715130333.GA2006@gondor.apana.org.au>
References: <20150714183243.18949.93255.stgit@tstruk-mobl1>
 <20150714183259.18949.581.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	pingchao.yang@intel.com, davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43169 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbbGONDj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2015 09:03:39 -0400
Content-Disposition: inline
In-Reply-To: <20150714183259.18949.581.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 14, 2015 at 11:33:00AM -0700, Tadeusz Struk wrote:
>
> +static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
> +{
> +	struct akcipher_request *areq = (void *)(__force long)resp->opaque;
> +	struct qat_rsa_request *req = PTR_ALIGN(akcipher_request_ctx(areq), 64);

You need to include the extra alignment space in reqsize.

> +	ctx->key_sz = mpi_get_size(pkey->n);
> +	if (!qat_rsa_enc_fn_id(ctx->key_sz)) {
> +		/* invalid key size provided falling back to sw */
> +		rsa_free_key(pkey);
> +		ctx->key_sz = 0;
> +		ctx->n = NULL;
> +		ctx->e = NULL;
> +		ctx->d = NULL;
> +
> +		pr_info("QAT: RSA key size not supported by hardware.\n");
> +		pr_info("Falling back to software");

That's way too verbose for something that could in future be
triggered from user-space.  Either remove them or use dev_debug.

> +		ctx->fallback = crypto_alloc_akcipher("rsa-generic", 0, 0);

You need to set CRYPTO_ALG_NEED_FALLBACK in the mask here.  You
should also set it in your cra_flags.  Then you can have rsa here
instead of rsa-generic.

There is also an issue with reqsize since your fallback's reqsize
may be bigger than yours.  You'll need to change akcipher first
to move the reqsize field into crypto_akcipher.  Then you can
set the reqsize here.

> +	ret = mpi_read_buffer(pkey->n, ctx->n, ctx->key_sz, &len, NULL);
> +	if (ret)
> +		goto free_d;

Huh? Why are you converting in and out of MPI? If the hardware wants
raw integers, then you should just give the raw numbers to it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
