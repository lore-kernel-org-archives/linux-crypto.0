Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAE71A0BD0;
	Tue,  9 Dec 2025 23:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765322698; cv=none; b=FKrCLjZpxDofjbCT2SQCvRFQqa3pMIucdAkrobdGKrB7fLsamtlPyuIMgVZXCNdkd0st8bPVSxo91ZZX0mOPoU+muHgJnTrqemKQjAgux05rzllf1S7GmJt7R/kBOl6CP1xAxIedPNiuy6L0g0yuFqkhzlQSE7+f1UNBYTqibNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765322698; c=relaxed/simple;
	bh=NwixsbyN0vRkVzF50eT+kmqTqkAD/i/3MpDi2cl1Xtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QBIJg01PgyRjtAsRD9JnJpXQu/znAWFPFNQ2349ZLaidm1sXTRrka/ScpWHI9bDL0CKF0Ts/C7RArCzjadSMeorGD0idhCYgpdj10Ez57pFtq56fUCbUbHZRg0NQree7q11A55G9b3a7dLNJIfrWEVnehYilLgbFK71eYwQR+R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=QFf6fJj3; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="QFf6fJj3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=1u3OlWaahLtO9NoZXjfgTMx2QYqqlSsbjYBcPVq2h2E=; 
	b=QFf6fJj34Unm/pgYLMhFQZ0drNCKLXD0WqoWSyezxh9yP/e5aL/gWlb3TOzQtf2yPsq7FTeTIPG
	ju8lKL7Esqfi2H1Lj4CMu/bcSljLmF5JscKn7O6doxEgRpatal/fRkwLdLILeu4n6gFroswF0FN1c
	bi8aP6oCcZCUoXN9+BiLisjRQdUu8m12PZKE6AyNzhBqxem1NzBhZKGMZ8V7mxwCCO0hr9HOivzk9
	8oX5c+lsCkM9mqMa9PHeT+m6n37Qz1N8ICpmOOE60dUtReWyoOgL0McOIYwe/q5efvK2nsftu09Kj
	eu6m1I4CInyXMiA5comAEcWDkzcpBA7j75XQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vT74J-00995H-0L;
	Wed, 10 Dec 2025 07:24:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Dec 2025 07:24:31 +0800
Date: Wed, 10 Dec 2025 07:24:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
	Diederik de Haas <diederik@cknow-tech.com>
Subject: Re: [PATCH] crypto: arm64/ghash - Fix incorrect output from
 ghash-neon
Message-ID: <aTivr6JtPIxFmKLS@gondor.apana.org.au>
References: <DETXT7QI62KE.F3CGH2VWX1SC@cknow-tech.com>
 <20251209223417.112294-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209223417.112294-1-ebiggers@kernel.org>

On Tue, Dec 09, 2025 at 02:34:17PM -0800, Eric Biggers wrote:
> Commit 9a7c987fb92b ("crypto: arm64/ghash - Use API partial block
> handling") made ghash_finup() pass the wrong buffer to
> ghash_do_simd_update().  As a result, ghash-neon now produces incorrect
> outputs when the message length isn't divisible by 16 bytes.  Fix this.
> 
> (I didn't notice this earlier because this code is reached only on CPUs
> that support NEON but not PMULL.  I haven't yet found a way to get
> qemu-system-aarch64 to emulate that configuration.)
> 
> Fixes: 9a7c987fb92b ("crypto: arm64/ghash - Use API partial block handling")
> Cc: stable@vger.kernel.org
> Reported-by: Diederik de Haas <diederik@cknow-tech.com>
> Closes: https://lore.kernel.org/linux-crypto/DETXT7QI62KE.F3CGH2VWX1SC@cknow-tech.com/
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> If it's okay, I'd like to just take this via libcrypto-fixes.
> 
>  arch/arm64/crypto/ghash-ce-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks for catching this!

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
