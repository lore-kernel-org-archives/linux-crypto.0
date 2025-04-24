Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA8A284692
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 15:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745509683; cv=none; b=OVdASwk2maNVpcDdQN4GSWxQQWhP6gLsEPw+wq3vRWmjA8XV/Fy/PR5UgwyExTlVVcEIgjlW4lEg/5l3NVPRk9Fjh+I/4U/W4nWI+RzU7JoD5rihBbO2umvNOGxBWyhzG6FTxVEZiHHmeceFoDELKNPvUw9F7DQK9ktO4g3jmzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745509683; c=relaxed/simple;
	bh=nKl6m74eYD3xxFYA5r5d/4izabmSnof5v7BnVZFQ1Sk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l1/2Yv77m4H4MvkrhY7U3rAsrC+aTISF3UeD1VgeM/FoddIgw6dsAkUKHlxCtr55Nqfc+Nr9LZRdPJ8ftrfiipxZ4r/vMITEsSSzzT7+OoKhDPRvOTY7a3N1o7pi36praj2oBHtSoc0JaIAmuYDKWCHj/TgO8vBJvu6zkTBby5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cx1Vh1Et; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cx1Vh1Et"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAF9C4CEE3;
	Thu, 24 Apr 2025 15:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745509682;
	bh=nKl6m74eYD3xxFYA5r5d/4izabmSnof5v7BnVZFQ1Sk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cx1Vh1EtiMYpzQetDQ3BZZW9Veaz2K0cEhPZvIsL9kqqMRGC9cYigdSDFXt8v5NSs
	 IV3pOQz4NmLiQ7XytZ43TrrDZeLSsZcq5hd0dLZhRiLwV+1blXKHuLyHiswLgKAZst
	 pqXybnHOUfGXxUes8R25pHqrUDNX4t7KhKRb5pZU4aGWf6cjPBPipKMbso4D2+UpRT
	 UdDzngj02dCyAtSAbD9CeMb0QbrzTn43t3toD6kSxpkoi94q+6wnPxzWd8ajXtAXPm
	 lNEMlovqONiLYPpQFX9pRZrBrbSky7xUm0fUqi/GEyFM5QvyrM7LsrYcwxthtHYJim
	 UwZOSrccFsJ7A==
Date: Thu, 24 Apr 2025 08:48:01 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 09/15] crypto: lib/poly1305 - Use block-only interface
Message-ID: <20250424154801.GC2427@sol.localdomain>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
 <6c08ba96e4cb6a6219e06bb77006cba91e6e84a2.1745490652.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c08ba96e4cb6a6219e06bb77006cba91e6e84a2.1745490652.git.herbert@gondor.apana.org.au>

On Thu, Apr 24, 2025 at 06:47:16PM +0800, Herbert Xu wrote:
> diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
> index ebdfccf378ee..a37b424ee84b 100644
> --- a/lib/crypto/poly1305.c
> +++ b/lib/crypto/poly1305.c
> @@ -22,47 +22,59 @@ void poly1305_block_init_generic(struct poly1305_block_state *desc,
>  }
>  EXPORT_SYMBOL_GPL(poly1305_block_init_generic);
>  
> -void poly1305_init_generic(struct poly1305_desc_ctx *desc,
> -			   const u8 key[POLY1305_KEY_SIZE])
> +void poly1305_init(struct poly1305_desc_ctx *desc,
> +		   const u8 key[POLY1305_KEY_SIZE])
>  {
>  	desc->s[0] = get_unaligned_le32(key + 16);
>  	desc->s[1] = get_unaligned_le32(key + 20);
>  	desc->s[2] = get_unaligned_le32(key + 24);
>  	desc->s[3] = get_unaligned_le32(key + 28);
>  	desc->buflen = 0;
> -	poly1305_block_init_generic(&desc->state, key);
> +	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
> +		poly1305_block_init_arch(&desc->state, key);
> +	else
> +		poly1305_block_init_generic(&desc->state, key);
>  }
> -EXPORT_SYMBOL_GPL(poly1305_init_generic);
> +EXPORT_SYMBOL(poly1305_init);
>  
> -static inline void poly1305_block(struct poly1305_block_state *state, const u8 *src,
> -				  unsigned int len)
> +static inline void poly1305_block(struct poly1305_block_state *state,
> +				  const u8 *src, unsigned int len)
>  {
> -	poly1305_blocks_generic(state, src, len, 1);
> +	if (!IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
> +		poly1305_blocks_generic(state, src, len, 1);
> +	poly1305_blocks_arch(state, src, len, 1);
>  }
>  
> -void poly1305_update_generic(struct poly1305_desc_ctx *desc, const u8 *src,
> -			     unsigned int nbytes)
> +void poly1305_update(struct poly1305_desc_ctx *desc,
> +		     const u8 *src, unsigned int nbytes)
>  {
>  	desc->buflen = BLOCK_HASH_UPDATE(&poly1305_block, &desc->state,
>  					 src, nbytes, POLY1305_BLOCK_SIZE,
>  					 desc->buf, desc->buflen);
>  }
> -EXPORT_SYMBOL_GPL(poly1305_update_generic);
> +EXPORT_SYMBOL(poly1305_update);

This randomly changes it to only do 1 block at a time.

And it also changes it to call poly1305_blocks_arch() even if the arch doesn't
have it, causing build errors.

- Eric
