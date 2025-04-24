Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BAF27FD76
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 16:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745511674; cv=none; b=IJ8ef7Wk25p+iGzKolH0FUkL+TRVN3cRHB0lAlLcO8sKaCA2qc1AIXhexpZyvF1DxkyfGSrRP0DbNmwvW1cWakK6gK9ykyiNtPKKngnsQJvl2Tpirj9fFxh67SgsIX/0pHqTJ+hAqlI0bqIne7Qv57FUSzvvC2B3OPVDD70HgL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745511674; c=relaxed/simple;
	bh=+NyEQ9EpowjiTCXvxrU9zcLh14LXEf6wKZSGPAtM3YA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6Uq9bfrgnWDKF0qyO4s+h3VAeHyAzHbi+muhrkr7uy0i2rLGGkpWot7zvgPW8dJ9rYG7wcj3PjsZB0wWClnxANYHiB3ae3rezc6pw/lDmmoCS9kQgOp6iIsaI8e59qIURzSCq6vch9fAOULFs8scxPh5o5ffwHKzPXWBFpeZEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t8vfhfWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t8vfhfWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C52C4CEE8;
	Thu, 24 Apr 2025 16:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745511674;
	bh=+NyEQ9EpowjiTCXvxrU9zcLh14LXEf6wKZSGPAtM3YA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t8vfhfWCbA8nMTjDxdKBnzJW2ZjFc9ehf0ZeYOIXgvQ7GD9N3qxxkhBr2E5zG9Eq1
	 TPUnRP90rcKWPXkzTkPjxemb7vLx8r7sHcK57Pne2wZz67ml099l3c8JORBKoo0nh4
	 ZCWgwfdPa+pmypbXSMjAAlhnk5lAF65RmzVpVnJ3EMI3k8+yUlPMijnj4tPAVq3H+f
	 Gs32I2sCcP0RzsFvH9/pn3+1kzr9w4PIomq6mzf78MaxOVM3edEtg9t4ppy7p1t62D
	 rXPV4UScLriq8o3GpmQArdvjm/EleE03goO9V7Kirt2dcWr8feuC02KjAbEZeugvIX
	 GWmCehT00zjsg==
Date: Thu, 24 Apr 2025 09:21:12 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 09/15] crypto: lib/poly1305 - Use block-only interface
Message-ID: <20250424162112.GG2427@sol.localdomain>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
 <6c08ba96e4cb6a6219e06bb77006cba91e6e84a2.1745490652.git.herbert@gondor.apana.org.au>
 <20250424154801.GC2427@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424154801.GC2427@sol.localdomain>

On Thu, Apr 24, 2025 at 08:48:01AM -0700, Eric Biggers wrote:
> On Thu, Apr 24, 2025 at 06:47:16PM +0800, Herbert Xu wrote:
> > diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
> > index ebdfccf378ee..a37b424ee84b 100644
> > --- a/lib/crypto/poly1305.c
> > +++ b/lib/crypto/poly1305.c
> > @@ -22,47 +22,59 @@ void poly1305_block_init_generic(struct poly1305_block_state *desc,
> >  }
> >  EXPORT_SYMBOL_GPL(poly1305_block_init_generic);
> >  
> > -void poly1305_init_generic(struct poly1305_desc_ctx *desc,
> > -			   const u8 key[POLY1305_KEY_SIZE])
> > +void poly1305_init(struct poly1305_desc_ctx *desc,
> > +		   const u8 key[POLY1305_KEY_SIZE])
> >  {
> >  	desc->s[0] = get_unaligned_le32(key + 16);
> >  	desc->s[1] = get_unaligned_le32(key + 20);
> >  	desc->s[2] = get_unaligned_le32(key + 24);
> >  	desc->s[3] = get_unaligned_le32(key + 28);
> >  	desc->buflen = 0;
> > -	poly1305_block_init_generic(&desc->state, key);
> > +	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
> > +		poly1305_block_init_arch(&desc->state, key);
> > +	else
> > +		poly1305_block_init_generic(&desc->state, key);
> >  }
> > -EXPORT_SYMBOL_GPL(poly1305_init_generic);
> > +EXPORT_SYMBOL(poly1305_init);
> >  
> > -static inline void poly1305_block(struct poly1305_block_state *state, const u8 *src,
> > -				  unsigned int len)
> > +static inline void poly1305_block(struct poly1305_block_state *state,
> > +				  const u8 *src, unsigned int len)
> >  {
> > -	poly1305_blocks_generic(state, src, len, 1);
> > +	if (!IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
> > +		poly1305_blocks_generic(state, src, len, 1);
> > +	poly1305_blocks_arch(state, src, len, 1);
> >  }
> >  
> > -void poly1305_update_generic(struct poly1305_desc_ctx *desc, const u8 *src,
> > -			     unsigned int nbytes)
> > +void poly1305_update(struct poly1305_desc_ctx *desc,
> > +		     const u8 *src, unsigned int nbytes)
> >  {
> >  	desc->buflen = BLOCK_HASH_UPDATE(&poly1305_block, &desc->state,
> >  					 src, nbytes, POLY1305_BLOCK_SIZE,
> >  					 desc->buf, desc->buflen);
> >  }
> > -EXPORT_SYMBOL_GPL(poly1305_update_generic);
> > +EXPORT_SYMBOL(poly1305_update);
> 
> This randomly changes it to only do 1 block at a time.
> 
> And it also changes it to call poly1305_blocks_arch() even if the arch doesn't
> have it, causing build errors.

Actually maybe it still does more than 1 block at a time, since the '1' is
actually the padbit argument, and maybe poly1305_block() is missing an "s"
accidentally.  Hard to tell because the code is obfuscated in the macro though.

- Eric
