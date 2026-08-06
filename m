Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F7D3EEACB;
	Thu,  6 Aug 2026 08:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786004239; cv=none; b=UyRYbk359bzd7aSS0oyPTJsW09TlmxoOmMTTuVHBSfJSDj0dDe5q1dOCq+AiLV5Wdse+Y5ekU4qfPteYpJ6Of9K84t+D8dFsjm/AruMtetsCHi6Db98qvBnQ3jkpCeqsbjkQIPlHqxQIX8+xwR+gLBtbVD7y0D8zKR7dO3maUPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786004239; c=relaxed/simple;
	bh=kZvZLF3b3rcBxOYVM7XHqJO/ZR4fDioLr4QENCvvwgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GF2KjUoi9rAmixtOOmm5+oCgxhxl/x/IXtulBU6gxEhgy6xxCo3S5CADDu5KD1fBQOSCdsQlvzhK4UH0U12P5xa0kZ/+bOexdBGU1jhefzmR/VSsVtTRraM+O2+D6JZeWaQ0xche+gyIizAdCxPiOfFbSFg3US5baIzS3EA0Z8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iT69S8rr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iT69S8rr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8D71F01563;
	Thu,  6 Aug 2026 08:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786004236;
	bh=YDDqyowTupehwgLiADNHCPwD/DHsFz7p9EL8ekF3ZKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iT69S8rrFM1gRwV+8pV+UbjzU/FJGfM7yqtJT0sDhNDXkrTI2mDZTjdMrESzuM1v9
	 kRaCN6E4ndB82sO6rtEgvTEWj44Ztb5Rm0tETJmMj8ztKKDIufJp40t7WdUXgtRcLc
	 TKhgSLUH/WJzR7Y/KY2US5EX2ER8r1PYVbLrjoMyAo3M/R46Z+froC+BWAqvntgpIv
	 Vva5VCN6MkO9TtJW/MKzZ62KhwXbCiy8ktf7oPFOzugnEq7Y/h8JilPKpiY03fF4Nt
	 HmFsmk1z3us7h13rVMQOAhGPF9BGaz32wnj4jHsUXA3fuX2lXPoJTm+r3ypdM6jzMz
	 d6SDb/I9PPkgQ==
Date: Thu, 6 Aug 2026 10:17:13 +0200
From: Antoine Tenart <atenart@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v3 10/10] crypto: safexcel - zeroize crypto_aes_ctx with
 __cleanup(aes_zeroize_ctx)
Message-ID: <anRC5AYai6TVHcac@kwain>
References: <20260805115749.392672-1-thuth@redhat.com>
 <20260805115749.392672-11-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805115749.392672-11-thuth@redhat.com>

On Wed, Aug 05, 2026 at 01:57:48PM +0200, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> The code clears the crypto_aes_ctx in most cases already with
> memzero_explicit(), but safexcel_skcipher_aesxts_setkey() runs
> aes_expandkey() twice, and in case the second call fails, the
> context from the first call is leaked.
> 
> To fix this issue and to avoid future similar problems, let's use
> the new __cleanup(aes_zeroize_ctx) mechanism to make sure that we
> always clear the crypto_aes_ctx in all cases.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Acked-by: Antoine Tenart <atenart@kernel.org>

> ---
>  drivers/crypto/inside-secure/safexcel_cipher.c | 13 ++++---------
>  drivers/crypto/inside-secure/safexcel_hash.c   |  3 +--
>  2 files changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
> index e94686490bb27..50e8792b399de 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -375,7 +375,7 @@ static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
>  	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
>  	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
>  	struct safexcel_crypto_priv *priv = ctx->base.priv;
> -	struct crypto_aes_ctx aes;
> +	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
>  	int ret, i;
>  
>  	ret = aes_expandkey(&aes, key, len);
> @@ -396,7 +396,6 @@ static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
>  
>  	ctx->key_len = len;
>  
> -	memzero_explicit(&aes, sizeof(aes));
>  	return 0;
>  }
>  
> @@ -1357,7 +1356,7 @@ static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
>  	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
>  	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
>  	struct safexcel_crypto_priv *priv = ctx->base.priv;
> -	struct crypto_aes_ctx aes;
> +	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
>  	int ret, i;
>  	unsigned int keylen;
>  
> @@ -1383,7 +1382,6 @@ static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
>  
>  	ctx->key_len = keylen;
>  
> -	memzero_explicit(&aes, sizeof(aes));
>  	return 0;
>  }
>  
> @@ -2537,7 +2535,7 @@ static int safexcel_skcipher_aesxts_setkey(struct crypto_skcipher *ctfm,
>  	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
>  	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
>  	struct safexcel_crypto_priv *priv = ctx->base.priv;
> -	struct crypto_aes_ctx aes;
> +	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
>  	int ret, i;
>  	unsigned int keylen;
>  
> @@ -2585,7 +2583,6 @@ static int safexcel_skcipher_aesxts_setkey(struct crypto_skcipher *ctfm,
>  
>  	ctx->key_len = keylen << 1;
>  
> -	memzero_explicit(&aes, sizeof(aes));
>  	return 0;
>  }
>  
> @@ -2751,12 +2748,11 @@ static int safexcel_aead_ccm_setkey(struct crypto_aead *ctfm, const u8 *key,
>  	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
>  	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
>  	struct safexcel_crypto_priv *priv = ctx->base.priv;
> -	struct crypto_aes_ctx aes;
> +	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
>  	int ret, i;
>  
>  	ret = aes_expandkey(&aes, key, len);
>  	if (ret) {
> -		memzero_explicit(&aes, sizeof(aes));
>  		return ret;
>  	}
>  
> @@ -2785,7 +2781,6 @@ static int safexcel_aead_ccm_setkey(struct crypto_aead *ctfm, const u8 *key,
>  	else
>  		ctx->hash_alg = CONTEXT_CONTROL_CRYPTO_ALG_XCBC128;
>  
> -	memzero_explicit(&aes, sizeof(aes));
>  	return 0;
>  }
>  
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
> index 3402e570d045c..20c17eb09495e 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -1905,7 +1905,7 @@ static int safexcel_cbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
>  				 unsigned int len)
>  {
>  	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
> -	struct crypto_aes_ctx aes;
> +	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
>  	int ret, i;
>  
>  	ret = aes_expandkey(&aes, key, len);
> @@ -1928,7 +1928,6 @@ static int safexcel_cbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
>  	}
>  	ctx->cbcmac  = true;
>  
> -	memzero_explicit(&aes, sizeof(aes));
>  	return 0;
>  }
>  
> -- 
> 2.55.0
> 
