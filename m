Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6EB267AF2;
	Fri,  3 Apr 2026 01:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775178357; cv=none; b=GeqBxb3imh02htWrnGM12eBJ6OuTKuzQtnkbcABLSJ6/xdGR6T2dzzefdhudQTJ5izqFLq//N+P6Z++gtWv8SuNaaecwOCAMcLkQxAvcoZVxwe09lEHXYFC9NDM2si+mkvAazIzwZ5mseIhbxjAqufv34yklvdSOxXoeFssHW2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775178357; c=relaxed/simple;
	bh=5enYkb26ImBotZHMWbIyApwM0/CTaxr5EfEIXqvL3oc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J8zcAtHil/i6zjcfoc/AS05GFXI/O121+R5Gvr8pgsf7+Lws0BnAzMmj+RC1culqSA+vCtnpSNsBxEi/JfTAHREvxJvHkFfrlBK/y0O/YZKw5dw1nRfbx/4JZoaffDEaGUmrbQUkZrYtYmBXV25Mi/TzQ8d0Im3MMK87tGRcYeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ceIs9GZT; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ceIs9GZT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IO9PAf7GiboQfN7tMcKHwXbPSg1kG4PLH4y/GW18OMI=; 
	b=ceIs9GZTFKdKxMDALYvyAlu4BqX3ZsKE8lyiB3OCN+9MaRdCNQswICNL8l/hpE08fA4LMcGXO0J
	idr5uId5nIKGvUHNEUg+Psqe9Vfhv7zqUHzJysr9OuVEdMuTDYF35AiWBzB5R4TWuJiOgliMv/2jd
	vi0kCxJtEnn9DWq3n5Gcv6QKzcJWrhWNOhR6Sxjsr/qcMBCzrxNAE0c6njLWisB3qDMAczLuZZtWh
	nbqqbW99VjUSZPO0kvlywOaKrCxEHMKEkwLh7E6CLvXcSoJwvr8G0HDz3v2l2lKAH49VFiE33AhuS
	1iLQH/WllMIVxXe5KqgDn27ghPHBcXm4r0Tg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8SZR-003R0T-26;
	Fri, 03 Apr 2026 09:05:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Apr 2026 09:05:52 +0800
Date: Fri, 3 Apr 2026 09:05:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 00/11] Stop pulling DRBG code into non-FIPS kernels
Message-ID: <ac8ScCXxWfaCx-9T@gondor.apana.org.au>
References: <20260326001507.66500-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326001507.66500-1-ebiggers@kernel.org>

On Wed, Mar 25, 2026 at 05:14:56PM -0700, Eric Biggers wrote:
> Most kernels have CRYPTO_FIPS=n but still include crypto/drbg.c and
> everything it depends on, including crypto/jitterentropy.c.
> 
> This dependency bloat happens because some kernel code gets random bytes
> from "stdrng" in the crypto_rng API instead of from get_random_bytes().
> (This is apparently done for FIPS certification reasons.)  Then, that
> pulls crypto/drbg.c to provide a "stdrng" implementation.
> 
> This series fixes the dependency bloat by making "stdrng" be used only
> in FIPS mode, and get_random_bytes_wait() be used otherwise.
> 
> This series is targeting cryptodev/master.
> 
> Eric Biggers (11):
>   crypto: rng - Add crypto_stdrng_get_bytes()
>   crypto: dh - Use crypto_stdrng_get_bytes()
>   crypto: ecc - Use crypto_stdrng_get_bytes()
>   crypto: geniv - Use crypto_stdrng_get_bytes()
>   crypto: hisilicon/hpre - Use crypto_stdrng_get_bytes()
>   crypto: intel/keembay-ocs-ecc - Use crypto_stdrng_get_bytes()
>   net: tipc: Use crypto_stdrng_get_bytes()
>   crypto: rng - Unexport "default RNG" symbols
>   crypto: rng - Make crypto_stdrng_get_bytes() use normal RNG in
>     non-FIPS mode
>   crypto: fips - Depend on CRYPTO_DRBG=y
>   crypto: rng - Don't pull in DRBG when CRYPTO_FIPS=n
> 
>  crypto/Kconfig                                |  9 +------
>  crypto/dh.c                                   |  8 +-----
>  crypto/ecc.c                                  | 11 +++-----
>  crypto/geniv.c                                |  8 +-----
>  crypto/rng.c                                  | 23 ++++++++++++-----
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c   | 12 ++-------
>  .../crypto/intel/keembay/keembay-ocs-ecc.c    | 17 +++----------
>  include/crypto/rng.h                          | 25 ++++++++++++++++---
>  net/tipc/crypto.c                             | 13 ++--------
>  9 files changed, 53 insertions(+), 73 deletions(-)
> 
> 
> base-commit: f9bbd547cfb98b1c5e535aab9b0671a2ff22453a
> -- 
> 2.53.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
