Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6635B22127E
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 16:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745511273; cv=none; b=nmH2qAQUgOXc+h2ME4zSBry5ou1YwvdowZ6CbV0t84Dm26g7S9qYotXo8SWaayBOQSSOp9RTPcqa0iwmzMgeXdp7myjwkMr+ZoMPIRBDXCHX0BlhATisGP8YGCROL1Ffb8bIrAD4VMBPVCTY7Z66Ofk0wqGN38YocfBr5IkHXhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745511273; c=relaxed/simple;
	bh=GMpVrM6i6wzKoHxHYYoovfUiJlAWC2OuUb1N/Xv++JQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vAcwMS8uEIrNQxZccLLHg7iSbM1J2i60Dh9LosI0tj1wnr4/Ylaf4pTbuJ2GU9vHBk5x2YJlCRY1qFCFG4uDxUt9V1v2rasQoviYS2Kb2ZnfFN84nhesoB9TBZuz+1EjQTaSXXZtcxR14Px0pS+i/deAG3F1yqxR9E/n8ly7J4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rVqH87/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rVqH87/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB952C4CEE3;
	Thu, 24 Apr 2025 16:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745511272;
	bh=GMpVrM6i6wzKoHxHYYoovfUiJlAWC2OuUb1N/Xv++JQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rVqH87/yKgMAq3ppyq7Dongg6XwGQt8yfHxL8ER2eRb9KEx2mbwtY54lQEllWARHI
	 oRYMmo9tiUqh6A13iPE43IOJFp78hgooR2Hg/+i57AW9+stFC4PhSoMWNLAG5D9SVW
	 qB+uTnFKOcRFQ5rYm6J2VLntcZdUhvWhjkqtSbNYIteIA8VnmL7UPgYMMjOdk5KOcb
	 k89xbUWzR6M+pgtF+v9/Bx6+4Vr5iGmGOTWbzpPFj3KEV8ovfCKtUaI3OdEiZUeW1s
	 RRTnttwphGAoiLw3ElEYjyRsgfkvLXC+ZSiCMzmr51S87g6hHRu1Im7S8OUWbMTDeE
	 KPHSaENANdgvA==
Date: Thu, 24 Apr 2025 09:14:31 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 02/15] crypto: lib/poly1305 - Add block-only interface
Message-ID: <20250424161431.GE2427@sol.localdomain>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
 <7c55da6f6310d4830360b088a5cc947e1da9b38f.1745490652.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c55da6f6310d4830360b088a5cc947e1da9b38f.1745490652.git.herbert@gondor.apana.org.au>

On Thu, Apr 24, 2025 at 06:47:00PM +0800, Herbert Xu wrote:
> +void poly1305_block_init_arch(struct poly1305_block_state *state,
> +			      const u8 key[POLY1305_BLOCK_SIZE]);
> +void poly1305_block_init_generic(struct poly1305_block_state *state,
> +				 const u8 key[POLY1305_BLOCK_SIZE]);

Use 'raw_key' instead of 'key' when referring to the 16-byte polynomial hash key
which is the first half of the full 32-byte Poly1305 one-time key.

>  void poly1305_update_generic(struct poly1305_desc_ctx *desc, const u8 *src,
>  			     unsigned int nbytes)
>  {
> -	unsigned int bytes;
> -
> -	if (unlikely(desc->buflen)) {
> -		bytes = min(nbytes, POLY1305_BLOCK_SIZE - desc->buflen);
> -		memcpy(desc->buf + desc->buflen, src, bytes);
> -		src += bytes;
> -		nbytes -= bytes;
> -		desc->buflen += bytes;
> -
> -		if (desc->buflen == POLY1305_BLOCK_SIZE) {
> -			poly1305_core_blocks(&desc->h, &desc->core_r, desc->buf,
> -					     1, 1);
> -			desc->buflen = 0;
> -		}
> -	}
> -
> -	if (likely(nbytes >= POLY1305_BLOCK_SIZE)) {
> -		poly1305_core_blocks(&desc->h, &desc->core_r, src,
> -				     nbytes / POLY1305_BLOCK_SIZE, 1);
> -		src += nbytes - (nbytes % POLY1305_BLOCK_SIZE);
> -		nbytes %= POLY1305_BLOCK_SIZE;
> -	}
> -
> -	if (unlikely(nbytes)) {
> -		desc->buflen = nbytes;
> -		memcpy(desc->buf, src, nbytes);
> -	}
> +	desc->buflen = BLOCK_HASH_UPDATE(&poly1305_block, &desc->state,
> +					 src, nbytes, POLY1305_BLOCK_SIZE,
> +					 desc->buf, desc->buflen);
>  }
>  EXPORT_SYMBOL_GPL(poly1305_update_generic);

Again, should just write this out without the weird macro, which is also being
used incorrectly here.

- Eric
