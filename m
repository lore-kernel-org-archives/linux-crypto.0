Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB4C3E63A2;
	Mon, 10 Aug 2026 14:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786370723; cv=none; b=jBAEOQZoTUUrxoMVUGNZcyMnnTXeJwChS/kbtT5sO8/KxWouGAdhhJKbl225HBTBe7DtvnHa9q+ZTnvkiG03YSoHW8ceNflZRIBJegcYIN6AA/w9Ogq0pg3kokw/Ue+IFgbc2hMCa96H8eXztf61r1Qx54iM8HXVCLCXh1Obznc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786370723; c=relaxed/simple;
	bh=NTEFInckLl4pLPOuKBomC4F0QdgBlSfQmbtV/i6ilmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lOWjhXmu1WqKCwpM2iiLdampPZmzHwQ6s3JmNJdjjdWzOUh8OddSArZrt1kk7wmzjcMWqeLWgJNirFhqXl8aHBvCVJXLUxolHanR/HVtlLFnhReqHTHRA6LJmgdtAfJ7e3N9b67VEfqbdBhWsdIQ1jERZx/Nrvzj9hc9u1RewZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZmELtMM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZmELtMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CBC1F000E9;
	Mon, 10 Aug 2026 14:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786370722;
	bh=HW6YP4HyvWx4jEIER3YeFiDGIBwTt3SR8rL1n0bPxPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eZmELtMMivlXz9pdY9PF9lv+ZBuKlypWPOwB4Y5gWI9YasvjT2NEQ3Ebg8IcF6nRh
	 hja6BsXToPCLSj3ER0qUIY6FIGTpRJ0mfgn5+klRtfXDteePcJu3nWKM4B58TYXQrf
	 hBbVGkwizBBh2tpa0tuKUmxRJsDeWySmu6mTo7Va+DT48Soaqo7b9JOpmqdBL+Y1FB
	 MN1OTDjMQKr8F2ZvMQp57hc4ZWu4cDnZm0HwkFQsxHgdqya2E29MasaME+2Uy18vN5
	 HjIhmVR+1910/XG5WRY0o51+Lp0IVO3otQk+QgUNDocE51YKcWILPp29ZJnrnyVQ4j
	 vbjJW/Yba5GGg==
Date: Mon, 10 Aug 2026 16:05:19 +0200
From: Antoine Tenart <atenart@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 08/10] crypto: safexcel - Simplify the check for a
 valid AES key
Message-ID: <annZlgf4ygaT0pZg@kwain>
References: <20260810093009.608090-1-thuth@redhat.com>
 <20260810093009.608090-9-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810093009.608090-9-thuth@redhat.com>

On Mon, Aug 10, 2026 at 11:30:03AM +0200, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> safexcel_aead_setkey() currently uses aes_expandkey() to check for a valid
> AES key, but then does not use the crypto_aes_ctx afterwards anymore,
> i.e. this is just a wasteful way of checking the key length, and thus
> aes_check_keylen() should be used instead.
> This also fixes a potential leak of sensitive data via the stack, since
> this function forgot to zeroize crypto_aes_ctx before returning to the
> caller.
> 
> Suggested-by: Antoine Tenart <atenart@kernel.org>
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Acked-by: Antoine Tenart <atenart@kernel.org>

Thanks!

> ---
>  drivers/crypto/inside-secure/safexcel_cipher.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
> index a8349b684693e..f07d043c67d45 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -407,7 +407,6 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
>  	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
>  	struct safexcel_crypto_priv *priv = ctx->base.priv;
>  	struct crypto_authenc_keys keys;
> -	struct crypto_aes_ctx aes;
>  	int err = -EINVAL, i;
>  	const char *alg;
>  
> @@ -438,7 +437,7 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
>  			goto badkey;
>  		break;
>  	case SAFEXCEL_AES:
> -		err = aes_expandkey(&aes, keys.enckey, keys.enckeylen);
> +		err = aes_check_keylen(keys.enckeylen);
>  		if (unlikely(err))
>  			goto badkey;
>  		break;
> -- 
> 2.55.0
> 
