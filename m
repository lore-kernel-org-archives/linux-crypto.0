From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] crypto: qat - Add support for RSA algorithm
Date: Tue, 14 Jul 2015 14:46:31 +0800
Message-ID: <20150714064631.GA20343@gondor.apana.org.au>
References: <20150710170616.4483.44445.stgit@tstruk-mobl1>
 <20150710170632.4483.9019.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	pingchao.yang@intel.com, davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55508 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbbGNGqh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jul 2015 02:46:37 -0400
Content-Disposition: inline
In-Reply-To: <20150710170632.4483.9019.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 10, 2015 at 10:06:32AM -0700, Tadeusz Struk wrote:
>
> +	ctx->key_sz = mpi_get_size(pkey->n);
> +	if (!qat_rsa_enc_fn_id(ctx->key_sz)) {
> +		/* invalid key size provided */
> +		rsa_free_key(pkey);
> +		ctx->key_sz = 0;
> +		return -EINVAL;
> +	}

As we discussed a while ago, the hardware implementation must not
support a smaller feature set than the software implementation.

So please either add a software fallback for unsupported key sizes,
or ensure that the software implementation also rejects these key
sizes.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
