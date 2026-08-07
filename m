Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD04040BCB3;
	Fri,  7 Aug 2026 08:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786089739; cv=none; b=TPTVB4MpoAP5UmEQKTXRIJU+PqwLwkz7IIvQp1JkSIBOZeGHbdlT0sVm4HQ69K/kGb2LRVzDGP5T6pr6d/XVG2p55BICkaPFdhpdpHkP/4GBCKbjyd/WViyhjn2fcH+DsacslgiOdha2vX8dSp6jacyyjtHUVlWO92nJzlJTCEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786089739; c=relaxed/simple;
	bh=ZPqQQoSLtAVbX9+1x1t/1g+x4EDQltItfrtDYS7Nu7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MZoyknd6WDU4ohueodOvSfX/7KP/n+XKcLekhy0o4w8339Lfl+Ebg0FOZSqTCRibCNsyvHzu4KtZqWjQFHkBYxSRGFwcc4hQI5/vc6Jj/U28RgqGEVYN3h8XTy2nMwaa21MHvNLONHGZRdlmjgAPxO2HWNWr81wx5s8rx1uE9r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNbH5+7V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNbH5+7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239A31F000E9;
	Fri,  7 Aug 2026 08:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786089734;
	bh=uypd2uO8fB5Qqh/9FlQ7qeiOpTGxs0xxABbC2nGMrZ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oNbH5+7VO8VgGAZnc/JzqQim5E+wYPtgF5P/pANVfSc+0Dx5u3ex98Rrlq8BhD3/H
	 T/Ju+GMTZlDYhnVmqsxeia+bTDi5l0IIAP0lLnt776K3+6deRmaLqDhimGsnbWsrKR
	 tA4BLjwZ/uWggO7DRPSCBeTcCoPjNAmH1VjYEmypdJvtWsMS48PkQgNE62/udPl5Sm
	 aG82barBEj80JMQ8RNgYgDYGxLBp7Axa03pafm+aqghk9c0556+2+jQj/oN5OQSZTG
	 c58RMjxuNHB808RTbSO95PL1FXAlHfitYXYb/p7K5z2ClWAL2K0zgQCO3cBRleh2Yx
	 88ViiAkxb34gg==
Date: Fri, 7 Aug 2026 10:02:11 +0200
From: Antoine Tenart <atenart@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/10] crypto: safexcel - Rework cleanup of sensitive
 structs in safexcel_aead_setkey
Message-ID: <anWPtWKdJFUoe2Pq@kwain>
References: <20260807070651.228713-1-thuth@redhat.com>
 <20260807070651.228713-10-thuth@redhat.com>
 <anWL9TltGiN0QAFg@kwain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anWL9TltGiN0QAFg@kwain>

On Fri, Aug 07, 2026 at 09:40:58AM +0200, Antoine Tenart wrote:
> On Fri, Aug 07, 2026 at 09:06:36AM +0200, Thomas Huth wrote:
> > From: Thomas Huth <thuth@redhat.com>
> > 
> > The crypto_authenc_keys structure only contains pointers to keys, but not
> > the key data itself. So explicitly clearing the structure at the end of
> > safexcel_aead_setkey() is not really necessary, see Eric's recommendation
> > here:
> > 
> >  https://lore.kernel.org/linux-crypto/20260804185402.GD2904385@google.com/
> > 
> > On the other hand, the crypto_aes_ctx might contain sensitive information,
> > so this structure should be cleaned up at the end instead. Do this
> > now via the new __cleanup(aes_zeroize_ctx) marker.
> > 
> > Since __cleanup() and gotos should not be mixed in the same function,
> > replace the gotos with early return statements, which is fine now that
> > we dropped the memzero_explicit(&keys, sizeof(keys)) at the end.
> > 
> > Suggested-by: Eric Biggers <ebiggers@kernel.org>
> > Signed-off-by: Thomas Huth <thuth@redhat.com>
> 
> Reviewed-by: Antoine Tenart <atenart@kernel.org>

Actually I think we could do better here:

The AES key is expanded in safexcel_aead_setkey using aes_expandkey but
the result (the aes variable) is discarded and never used. This seems a
waste of CPU cycles for doing a validity check on the input key, which
can be replaced by a simple aes_check_keylen.

The same applies to the EIP93 patch for both chunks.

> > ---
> >  .../crypto/inside-secure/safexcel_cipher.c    | 27 ++++++++-----------
> >  1 file changed, 11 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
> > index a8349b684693e..c331d81ac8a2d 100644
> > --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> > +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> > @@ -407,17 +407,17 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
> >  	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
> >  	struct safexcel_crypto_priv *priv = ctx->base.priv;
> >  	struct crypto_authenc_keys keys;
> > -	struct crypto_aes_ctx aes;
> > -	int err = -EINVAL, i;
> > +	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
> > +	int err, i;
> >  	const char *alg;
> >  
> >  	if (unlikely(crypto_authenc_extractkeys(&keys, key, len)))
> > -		goto badkey;
> > +		return -EINVAL;
> >  
> >  	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD) {
> >  		/* Must have at least space for the nonce here */
> >  		if (unlikely(keys.enckeylen < CTR_RFC3686_NONCE_SIZE))
> > -			goto badkey;
> > +			return -EINVAL;
> >  		/* last 4 bytes of key are the nonce! */
> >  		ctx->nonce = *(u32 *)(keys.enckey + keys.enckeylen -
> >  				      CTR_RFC3686_NONCE_SIZE);
> > @@ -430,25 +430,25 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
> >  	case SAFEXCEL_DES:
> >  		err = verify_aead_des_key(ctfm, keys.enckey, keys.enckeylen);
> >  		if (unlikely(err))
> > -			goto badkey;
> > +			return err;
> >  		break;
> >  	case SAFEXCEL_3DES:
> >  		err = verify_aead_des3_key(ctfm, keys.enckey, keys.enckeylen);
> >  		if (unlikely(err))
> > -			goto badkey;
> > +			return err;
> >  		break;
> >  	case SAFEXCEL_AES:
> >  		err = aes_expandkey(&aes, keys.enckey, keys.enckeylen);
> >  		if (unlikely(err))
> > -			goto badkey;
> > +			return err;
> >  		break;
> >  	case SAFEXCEL_SM4:
> >  		if (unlikely(keys.enckeylen != SM4_KEY_SIZE))
> > -			goto badkey;
> > +			return -EINVAL;
> >  		break;
> >  	default:
> >  		dev_err(priv->dev, "aead: unsupported cipher algorithm\n");
> > -		goto badkey;
> > +		return -EINVAL;
> >  	}
> >  
> >  	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
> > @@ -486,24 +486,19 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
> >  		break;
> >  	default:
> >  		dev_err(priv->dev, "aead: unsupported hash algorithm\n");
> > -		goto badkey;
> > +		return -EINVAL;
> >  	}
> >  
> >  	if (safexcel_hmac_setkey(&ctx->base, keys.authkey, keys.authkeylen,
> >  				 alg, ctx->state_sz))
> > -		goto badkey;
> > +		return -EINVAL;
> >  
> >  	/* Now copy the keys into the context */
> >  	for (i = 0; i < keys.enckeylen / sizeof(u32); i++)
> >  		ctx->key[i] = cpu_to_le32(((u32 *)keys.enckey)[i]);
> >  	ctx->key_len = keys.enckeylen;
> >  
> > -	memzero_explicit(&keys, sizeof(keys));
> >  	return 0;
> > -
> > -badkey:
> > -	memzero_explicit(&keys, sizeof(keys));
> > -	return err;
> >  }
> >  
> >  static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
> > -- 
> > 2.55.0
> > 
> 
