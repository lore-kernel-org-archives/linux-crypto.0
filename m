Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184B53CC9E8;
	Fri, 15 May 2026 10:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840442; cv=none; b=Vy1N+Gt+PUFcQlB6Y2b/JXtD3zpe7eZeOifphaxcw1Cj1UX2oXc7OsnRo4Ktov1puTcagpOYszZ2nMjg/NnxnxGpoxat0YkMk7yCI/vw3uA9SPr3RmYqNpPhMLkwruoUHK/vnnqt3iP6IXWwkEaMvA4gep6J9kfdVrGfMiMFgyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840442; c=relaxed/simple;
	bh=TTzaA7eH9oy/ae3Bw/v87NrQw1JWVCOIoNwVjVH6a4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ct50QYTblAHi2LNlRi6Pv26d3NG3M81OjRUaWYso4x6OffgGSS+VSsFMLpOF3FlmkLWzSsV8lH28oYR7VLuuX3F76Y1ev5+YF7c8cogNlKzq4e4QaQGT2qoxYD4MW31KFnsaC6CcE5AaMXBEzYx0QEvgyJZX7wby5L8RlDNWiC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=HztqwzDA; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="HztqwzDA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Alp+nnGUNhTbYWx7XAc/wEFqQVeSO9IZyif6u2Q6Ypo=; 
	b=HztqwzDA2zR9vfgUq4yTkdcAHrKDryW5FjpzJ7SRQ4e5mcbQPKmOrzmZS/XnxIeinOunQngUuL5
	e5416fWYNyJvxyI4sW3R7tAybTUVSguvud6e78vyHF3p4/IacmLRAyJV7JUW+yZiQHSDFsMqn51mT
	3LFm2UgDl4nWv6Jnjc1udx/7b8JtxaoU+LcmlzPvwTjmENmn62cM0OeuaHNh+zdFIyd3EJQxbuIXc
	hHdx5dv0VmfOl6460H8DC8y+su7Xk0LjNgGymCy+cY0eDB8E4PW0K9jYPFjW0DtRcag2ItHYPidhm
	nVZbRFaimideUiZTs3h3H7XaM3NfvEZaTGrg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNpen-00EOTQ-2v;
	Fri, 15 May 2026 18:20:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:20:37 +0800
Date: Fri, 15 May 2026 18:20:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Joachim Vandersmissen <joachim@jvdsn.com>
Subject: Re: [PATCH] crypto: drbg - Remove support for "prediction resistance"
Message-ID: <agbzdbZgaTUf_ZFI@gondor.apana.org.au>
References: <20260506000258.70807-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506000258.70807-1-ebiggers@kernel.org>

On Tue, May 05, 2026 at 05:02:58PM -0700, Eric Biggers wrote:
> "Prediction resistance", i.e. the property that the RNG's output is
> unpredictable even after a state compromise, might sound like a nice
> property to have.  In reality, it's not very practical, as it requires
> that fresh entropy be pulled on every request.  (The normal Linux RNG
> doesn't provide prediction resistance.)  In the case of drbg.c, that
> means pulling from "jitterentropy", which is extremely slow.
> 
> For some perspective, running a simple benchmark, generating 32 random
> bytes takes the following amount of time:
> 
>     get_random_bytes(): 90 ns
>     drbg_nopr_hmac_sha512: 3707 ns
>     drbg_pr_hmac_sha512: 773082 ns
> 
> So at least in this case, the "pr" (prediction-resistant) DRBG is over
> 200 times slower than the "nopr" (non-prediction-resistant) DRBG, or
> over 8000 times slower than the normal Linux RNG.  While anyone using
> drbg.c has always had to tolerate that it's slower than the normal Linux
> RNG, the "pr" DRBG is clearly at another level of slowness.
> 
> Thus, the following is also entirely unsurprising:
> 
>   - FIPS 140-3 doesn't actually require that SP800-90A DRBG
>     implementations support prediction resistance.  The non-prediction
>     resistant DRBGs can be, and have been, certified.
> 
>   - drbg.c registers "drbg_nopr_hmac_sha512" with a higher cra_priority
>     than "drbg_pr_hmac_sha512".  So "drbg_nopr_hmac_sha512" is already
>     the one actually being used in practice.
> 
> Given these considerations, it's clear that "drbg_pr_hmac_sha512" isn't
> actually useful, and it essentially just existed as another curiosity in
> the museum of crypto algorithms.  Remove it to simplify the code.
> 
> Suggested-by: Joachim Vandersmissen <joachim@jvdsn.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  crypto/drbg.c    |  82 ++++++-------------
>  crypto/testmgr.c |  21 +----
>  crypto/testmgr.h | 202 -----------------------------------------------
>  3 files changed, 27 insertions(+), 278 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
