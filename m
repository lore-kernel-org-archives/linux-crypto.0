Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8B158AD6
	for <linux-crypto@vger.kernel.org>; Fri, 26 Jan 2024 09:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259910; cv=none; b=hha8lqZ0XY6/KKO6QYSRA/IsExDmYZXQ1lHdvUt/E5lyeyc856n3gSF5rH+FD4fViH4+is8fCu1jg6WxnhwV4bxSF2KAOba2Ir3PSLIzwQM0GepdTNPTL84rxdUnw86A7BjyXj4fSGnUiV8Q/xLdf2meC/7BbM4JfZZveOZatVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259910; c=relaxed/simple;
	bh=uwb6oz79eDENEy+0SQNheTm4YArttrkyh84CBGd8Sok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xgikpudc8SuzNhkHh1F54czyNHfK63opCxzxgTnGDrkSWvQ/IR5Wr+2omrXFg++MRb1TNcGNxFATQ92glUTshSPws+td+X4O8uHKMJ/W9cbBsA8W8is/0c9K72tmlQfWLswBbAD4kM+m+c1pFuCqoJCZDt00dA6ELagaElwSmuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rTI90-006Erc-Ll; Fri, 26 Jan 2024 17:05:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Jan 2024 17:05:15 +0800
Date: Fri, 26 Jan 2024 17:05:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, ebiggers@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2 0/8] crypto: Clean up arm64 AES-CCM code
Message-ID: <ZbN1y/oViQpoxyR4@gondor.apana.org.au>
References: <20240118170628.3049797-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240118170628.3049797-10-ardb+git@google.com>

On Thu, Jan 18, 2024 at 06:06:29PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The AES-CCM driver was written 10+ years ago, based on the very first
> kernel mode NEON API for arm64, which eagerly preserved/restored the
> NEON registers on each call to kernel_neon_begin() resp.
> kernel_neon_end().
> 
> For this reason, the asm helpers were constructed in a way that used
> only 6 NEON registers, as the kernel mode NEON API at the time
> implemented an optimization where kernel_neon_begin() took an int
> denoting the number of NEON registers to preserve/restore. Given that no
> actual hardware existed at the time (except perhaps for APM Xgene1 which
> did not implement the crypto instructions), all of this was based on
> premature assumptions.
> 
> These days, the NEON API is a bit more sophisticated, and does not
> bother to preserve/restore anything unless it is needed (e.g., when
> context switching or returning to user space). It also no longer
> disables preemption. Finally, we've developed some code patterns in the
> mean time to deal with tail blocks more cleanly and efficiently.
> 
> So let's bring the CCM driver up to date with all of this.
> 
> Changes since v1:
> - keep primary en/decryption paths separate
> - fix rebase error in v1
> 
> Ard Biesheuvel (8):
>   crypto: arm64/aes-ccm - Revert "Rewrite skcipher walker loop"
>   crypto: arm64/aes-ccm - Keep NEON enabled during skcipher walk
>   crypto: arm64/aes-ccm - Pass short inputs via stack buffer
>   crypto: arm64/aes-ccm - Replace bytewise tail handling with NEON
>     permute
>   crypto: arm64/aes-ccm - Reuse existing MAC update for AAD input
>   crypto: arm64/aes-ccm - Cache round keys and unroll AES loops
>   crypto: arm64/aes-ccm - Merge encrypt and decrypt tail handling
>   crypto: arm64/aes-ccm - Merge finalization into en/decrypt asm helpers
> 
>  arch/arm64/crypto/Kconfig           |   1 +
>  arch/arm64/crypto/aes-ce-ccm-core.S | 265 +++++++-------------
>  arch/arm64/crypto/aes-ce-ccm-glue.c | 154 ++++++++----
>  arch/arm64/crypto/aes-glue.c        |   1 +
>  4 files changed, 200 insertions(+), 221 deletions(-)
> 
> -- 
> 2.43.0.381.gb435a96ce8-goog

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
