Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [144.76.133.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB56B45040C;
	Wed, 29 Jul 2026 19:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.133.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353181; cv=none; b=FMelingBdyl6EWyEOd5293nVvRNBxdL9q3bbq4b4Uuz/kLdOZikeePEihRT0ueo8qtU311iualduKqbEEiiN43VeL9kNPhyvl84bPRBwTB0I4sCeYBLoVMuqh6Pzgg8UKXDDJowFdLOumCYoAhd+/eVYwnRGIMQi/htgulwHe6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353181; c=relaxed/simple;
	bh=zVc22Ikbh9BTcgnnwJJCYK4gsI0cw5Im21vlD5odV7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nBvShZWGVd3Pt4eG06jHbdbN0HVax+f+1k/WtubSox0g9oCWt1VAcm4u9wsF/CwtbGvO/96Q8lgZOGSRCUJNySWkPeY6wZcnGkeDdXT/1olXod9LVlvS4itpkCSwHXkTTzZC6/Ojf0xESp7lbzyXRUCRR66B97Aoph1s7MDynis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=144.76.133.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout3.hostsharing.net (Postfix) with ESMTPS id 81AF9C31;
	Wed, 29 Jul 2026 21:26:09 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 402BC6031592; Wed, 29 Jul 2026 21:26:09 +0200 (CEST)
Date: Wed, 29 Jul 2026 21:26:09 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Changwei Zou <changwei.zou@canonical.com>
Cc: Martin.Kepplinger-Novakovic@ginzinger.com, davem@davemloft.net,
	herbert@gondor.apana.org.au, ignat@linux.win,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	martink@posteo.de
Subject: Re: [PATCH v3] crypto: rsassa-pkcs1 - Align DMA buffer to
 CRYPTO_DMA_ALIGN
Message-ID: <ampT0ZVFqOgxKFa6@wunner.de>
References: <20260729004156.11925-1-changwei.zou@canonical.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729004156.11925-1-changwei.zou@canonical.com>

On Wed, Jul 29, 2026 at 10:41:56AM +1000, Changwei Zou wrote:
> +++ b/crypto/rsassa-pkcs1.c
> @@ -237,12 +237,13 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
>  		return -EINVAL;
>  
>  	/* RFC 8017 sec 8.2.2 step 2 - RSA verification */
> -	child_req = kmalloc(sizeof(*child_req) + child_reqsize + ctx->key_size,
> -			    GFP_KERNEL);
> +	child_req = kmalloc(sizeof(*child_req) + child_reqsize +
> +			    ctx->key_size + CRYPTO_DMA_ALIGN - 1, GFP_KERNEL);
>  	if (!child_req)
>  		return -ENOMEM;
>  
> -	out_buf = (u8 *)(child_req + 1) + child_reqsize;
> +	out_buf = PTR_ALIGN((u8 *)(child_req + 1) + child_reqsize,
> +			    CRYPTO_DMA_ALIGN);
>  	memcpy(out_buf, src, slen);
>  
>  	crypto_init_wait(&cwait);

Thank, this all looks good to me.

However after reading around a bit in crypto code, I'm under the
impression that the "native" way of doing this is to have struct
caam_akcipher_alg[] in drivers/crypto/caam/caampkc.c define
".cra_alignmask = CRYPTO_DMA_ALIGN - 1," and then have
rsassa_pkcs1_verify() call crypto_akcipher_alignmask()
to determine the amount of padding needed and the alignment.

That crypto_akcipher_alignmask() doesn't exist yet, but can
easily be copy-pasted from crypto_skcipher_alignmask()
except it invokes crypto_akcipher_tfm() instead of
crypto_skcipher_tfm().

Finally the kernel-doc of struct crypto_alg would have to be
amended because the documentation of the cra_alignmask member
does not mention akcipher yet.

Now this may all sound like a roundabout way of doing things
but it seems to fit neatly into the existing OO-like approach
of the crypto subsystem and so I strongly suspect that's what
Herbert would want.  I apologize for not having steered you
in that direction right away, I feel like a novice myself
sometimes when navigating that code.

You can find some pre-existing use cases with
"git grep alignmask -- crypto/".  E.g. in crypto/xctr.c,
alignmask is determined with crypto_cipher_alignmask()
and that (plus 1) is then fed to PTR_ALIGN().

Basically the idea is that whether padding is added at all
and how much depends on the child request, and that child
request knows exactly whether it needs any padding at all.

I think you can do all of that in a single patch and thus
keep this easily backportable to stable kernels.

Thanks!

Lukas
