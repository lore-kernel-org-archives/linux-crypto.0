From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/9] crypto: Add a generic Poly1305 authenticator
 implementation
Date: Thu, 4 Jun 2015 17:59:10 +0800
Message-ID: <20150604095910.GA24246@gondor.apana.org.au>
References: <1433159044-30753-1-git-send-email-martin@strongswan.org>
 <1433159044-30753-4-git-send-email-martin@strongswan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59128 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbbFDJ7T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Jun 2015 05:59:19 -0400
Content-Disposition: inline
In-Reply-To: <1433159044-30753-4-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 01, 2015 at 01:43:58PM +0200, Martin Willi wrote:
>
> +static int poly1305_setkey(struct crypto_shash *tfm,
> +			   const u8 *key, unsigned int keylen)
> +{
> +	struct poly1305_ctx *ctx = crypto_shash_ctx(tfm);
> +
> +	if (keylen != POLY1305_KEY_SIZE) {
> +		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		return -EINVAL;
> +	}
> +
> +	/* r &= 0xffffffc0ffffffc0ffffffc0fffffff */
> +	ctx->r[0] = (le32_to_cpuvp(key +  0) >> 0) & 0x3ffffff;
> +	ctx->r[1] = (le32_to_cpuvp(key +  3) >> 2) & 0x3ffff03;
> +	ctx->r[2] = (le32_to_cpuvp(key +  6) >> 4) & 0x3ffc0ff;
> +	ctx->r[3] = (le32_to_cpuvp(key +  9) >> 6) & 0x3f03fff;
> +	ctx->r[4] = (le32_to_cpuvp(key + 12) >> 8) & 0x00fffff;
> +
> +	ctx->s[0] = le32_to_cpuvp(key + 16);
> +	ctx->s[1] = le32_to_cpuvp(key + 20);
> +	ctx->s[2] = le32_to_cpuvp(key + 24);
> +	ctx->s[3] = le32_to_cpuvp(key + 28);
> +
> +	return 0;
> +}

I just realised that this doesn't quite work.  The key is shared
by all users of the tfm, yet in your case you need it to be local
to the shash_desc as otherwise two packets processed in parallel
will overwrite each other's key.

I think the simplest solution is to make the key the beginning
of the hashed text instead.  So the first two blocks that you
process get used as the key.

What do you think?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
