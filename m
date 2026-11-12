Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794478614;
	b=wg3mwlgMo9dyWButepVQi4guqvdMq2ihe9vIz91a/sVBQMA9xIFA0/AvMOmEtweY8WcI
	 ArwnKbeELMZUt2HeRW0t8i/jknWXVDCprAFJqd3hseKlXS+FuLzgW/tRwRUbFTXh3jDkO
	 deG/3lxNsYimrys21GaU9aJGSW9r9NS9BtBztEP4HJkr4XRm8dWlaYsXr48zTrArMdHo5
	 qqGXIO3uBnOb1VXvc7gFLGqhhoyh7vyrertOwupOAYChdK7U8fy3wV7u7lTrnE3JGzQVw
	 xUVhMHTmszI5/lXiTpgauD//1YhAJGBsIg+oo8T4qVrvRF0l6ZD44C4JG6FzmjJlTtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794478614;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=GzIboxxC5b28vKQNFPiZLgg+bHE+rPHJS9xPgz/9zo4=;
	b=FBJ7Qla21DZsSxzU15LL2ogWEr94rf0GfKvtbMG0jlaw39PKrwf58qzfVG3IQmEJ4JnE
	 lmOYpqaRrpvd5wc006zwlF4f4oZUsA9o9laU8CkgMa64qATMfwpGkEzC0ANh0PIqNpJEl
	 5aWnV3DvINQTBZS4fzavzR1+mVq+9wXPCk1+onni8boOp+7TIN6dRdFYsWQHCei+JsvOs
	 GaRhf4UBNb6xrfHqbDHawWxQRRbA9fctdt2qLbBzEsfkKoeHoSLP8Y0JW2GiZYAUQBPRd
	 vr8vIT4a9KU0b2cEFiWcKUkUAT1VdCoGFrqzwtdG4b7Ep8t5UefrzIeFWI72Us435Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b="m/9qBWXr";
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2593D606A327
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 10:16:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2593D606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=m/9qBWXr
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=GzIboxxC5b28vKQNFPiZLgg+bHE+rPHJS9xPgz/9zo4=; 
	b=m/9qBWXrpwZUkNYG+oY/krE3YyfvZ2g2wEZx/EnJlsKSZ4nciq6JINQnQHY421nSXusV5qFePLJ
	H+reMszAvKzg8JRF3xlAkqnlKyTpUjXdAncDTnRETAVrHxTwMfcrzDwXfKLGagk91j5ZL69Fq4GaL
	cxZe9NoGRNbQexWxDT1Jcm2pa4y+ncWNC7lroeg9djMK5wFuPsQTD7RbGFB+EDxKYTPIEWPYO8yVD
	j3vSThy4u+t5wdLfqAIe1qDg2KyPa8cJ1ZSYTfmsPH7wAv6TKHw7xbNPhv4mIgBfT8rL/FUBsqgnq
	2IlxxCEOuCmApahnmZt3pTABt/a6NfWW8FHQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRRrO-0000000EEGA-2iIC;
	Thu, 12 Nov 2026 18:16:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Nov 2026 18:16:50 +0800
Date: Thu, 12 Nov 2026 18:16:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: arc4 - Remove obsolete crypto API support for
 ARC4
Message-ID: <avWSEpYV-dxvc1-g@gondor.apana.org.au>
References: <20261031211535.8793-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261031211535.8793-1-ebiggers@kernel.org>

On Sat, Oct 31, 2026 at 02:15:35PM -0700, Eric Biggers wrote:
> All in-kernel users of ARC4 use the ARC4 library (lib/crypto/arc4.c)
> directly, not the crypto API wrapper (crypto/arc4.c).
> 
> Removal of the crypto API wrapper was attempted in 2020
> (https://lore.kernel.org/linux-crypto/20200702101947.682-5-ardb@kernel.org/)
> but was delayed due to its use by iwd via AF_ALG.  This was, however,
> soon afterwards resolved by making iwd simply use userspace ARC4 code
> (https://git.kernel.org/pub/scm/network/wireless/iwd.git/commit/?id=1db8a85a60c645232eb5bba1ec0cd0a2927ccd16),
> which was released in iwd 1.9 in September 2020.
> 
> Also at the time, CONFIG_CRYPTO_ARC4 was placed under
> CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE, and the kernel started printing
> a warning whenever "ecb(arc4)" is used.  See commit 9ace67718310
> ("crypto: arc4 - mark ecb(arc4) skcipher as obsolete").  So, any other
> hypothetical user would have had 6 years of deprecation warnings, even
> if somehow they were overlooking that ARC4 is insecure.
> 
> Finally, "ecb(arc4)" isn't on the skcipher_allowlist introduced in v7.3,
> so it's no longer available in AF_ALG by default even if
> CONFIG_CRYPTO_ARC4 is enabled.
> 
> Given all this, it's clear that the crypto_skcipher / crypto_lskcipher
> API support for ARC4 is no longer used or needed.  Remove it.
> 
> The ARC4 library remains in place, as it's still used in the kernel to
> support certain legacy protocols.  (Note: since this removes the only
> ARC4 test, I'll also add a KUnit test to replace it in a later commit.)
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  arch/arm/configs/am200epdkit_defconfig     |  1 -
>  arch/arm/configs/spitz_defconfig           |  1 -
>  arch/m68k/configs/amiga_defconfig          |  1 -
>  arch/m68k/configs/apollo_defconfig         |  1 -
>  arch/m68k/configs/atari_defconfig          |  1 -
>  arch/m68k/configs/bvme6000_defconfig       |  1 -
>  arch/m68k/configs/hp300_defconfig          |  1 -
>  arch/m68k/configs/mac_defconfig            |  1 -
>  arch/m68k/configs/multi_defconfig          |  1 -
>  arch/m68k/configs/mvme147_defconfig        |  1 -
>  arch/m68k/configs/mvme16x_defconfig        |  1 -
>  arch/m68k/configs/q40_defconfig            |  1 -
>  arch/m68k/configs/sun3_defconfig           |  1 -
>  arch/m68k/configs/sun3x_defconfig          |  1 -
>  arch/mips/configs/decstation_defconfig     |  1 -
>  arch/mips/configs/decstation_r4k_defconfig |  1 -
>  arch/mips/configs/ip32_defconfig           |  1 -
>  arch/mips/configs/rt305x_defconfig         |  1 -
>  arch/mips/configs/xway_defconfig           |  1 -
>  arch/powerpc/configs/44x/eiger_defconfig   |  1 -
>  arch/powerpc/configs/44x/redwood_defconfig |  1 -
>  arch/s390/configs/debug_defconfig          |  1 -
>  arch/s390/configs/defconfig                |  1 -
>  arch/sh/configs/sh2007_defconfig           |  1 -
>  arch/sh/configs/titan_defconfig            |  1 -
>  arch/sparc/configs/sparc32_defconfig       |  1 -
>  crypto/Kconfig                             | 13 ----
>  crypto/Makefile                            |  1 -
>  crypto/arc4.c                              | 82 ----------------------
>  crypto/tcrypt.c                            | 19 -----
>  crypto/testmgr.c                           |  7 --
>  crypto/testmgr.h                           | 62 ----------------
>  include/crypto/arc4.h                      |  3 +-
>  33 files changed, 1 insertion(+), 212 deletions(-)
>  delete mode 100644 crypto/arc4.c

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
