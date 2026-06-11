Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D02A2EB0F;
	Thu, 11 Jun 2026 08:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781167686; cv=none; b=jvxj33UdalklVO2L3CQjeT/XXbWFe2sP5Tt3YIUGm3xvz+Kkl4bDPwPPA+6WKflMhnYHcrCRnZjTt9jsQco/jttBt02oKvn4KDmVp/D97IIV1TFYnNQ8HpB8o9yqlopGGS21tMFFuF4tD2jRO2J/EAI+37w3pFlaO4W9VDUmxOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781167686; c=relaxed/simple;
	bh=45ncqpgJrcQKx+gXWAJgxgeTJJDD60YjbMYFoi2dHL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1Qix63PSY8dwPv9MNDteytu0yTBlfXtNprNgNQ73lnqIUnzjLXFufRaD0mSTlPDVKFeBC9TidM1KWmNlsZPCSLG3LFUQc6M9kbZH8XFFiVyYOJ7F/7Th2vM/8GX+rnseiJjpk2V2SyO00PL2IorvK6tC2l+W+dMxFaem5lX6z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=mfixcgMH; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="mfixcgMH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=c3j48vW+9D5m6shOf5DXD0lLDgCnzW/Ek78ImnixKSc=; 
	b=mfixcgMHgRBcAHB30u1ynUg9Tappp5HybmPW5Kf0dH0t2yixJzKi56B+GYfSg6n1hJY+tJyXZKm
	WvDL3jwdXRnwT0vodSotZjF2rfihR2H7Km+6JbOoLdBr9QiEjhjcBsw3YCbdd3ii8tra7Id2E79U/
	4HUqFxFL8A7XOJERYfB9B4U6NfdRnxo/cf5Cgx35BdNzkdLuJGwmpOMcOhno/IOC3g51e6N5Pzli2
	d7YaAcBvMPSRxBCbMu+nSE3/GOD/0FqH9i39mRmhA51s4cwvYoaF/yhbDHTmZ36FLVmIAW5mEPHUi
	p6EwG0toEAp7yyWfjlc2FsSb2aquVKwBZZ2A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXb4y-00000004XRV-35Ww;
	Thu, 11 Jun 2026 16:48:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 16:48:00 +0800
Date: Thu, 11 Jun 2026 16:48:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: crypto4xx - Remove insecure and unused rng_alg
Message-ID: <aip2QHfRK9nEZMMJ@gondor.apana.org.au>
References: <20260529220430.34135-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529220430.34135-1-ebiggers@kernel.org>

On Fri, May 29, 2026 at 03:04:30PM -0700, Eric Biggers wrote:
> Remove crypto4xx_rng, as it is insecure and unused:
> 
> - It has only a 64-bit security strength, which is highly inadequate.
>   This can be seen by the fact that crypto4xx_hw_init() seeds it with
>   only 64 bits of entropy, and the fact that the original commit
>   mentions that it implements ANSI X9.17 Annex C.
> 
>   Another issue was that this driver didn't implement the crypto_rng API
>   correctly, as crypto4xx_prng_generate() didn't return 0 on success.
> 
> - No user of this code is known.  It's usable only theoretically via the
>   "rng" algorithm type of AF_ALG.  But userspace actually just uses the
>   actual Linux RNG (/dev/random etc) instead.  And rng_algs don't
>   contribute entropy to the actual Linux RNG either.  (This may have
>   been confused with hwrng, which does contribute entropy.)
> 
> Fixes: d072bfa48853 ("crypto: crypto4xx - add prng crypto support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  drivers/crypto/Kconfig                  |  1 -
>  drivers/crypto/amcc/crypto4xx_core.c    | 88 -------------------------
>  drivers/crypto/amcc/crypto4xx_core.h    |  4 --
>  drivers/crypto/amcc/crypto4xx_reg_def.h | 11 ----
>  4 files changed, 104 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
