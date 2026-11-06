Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964546;
	b=0tIvWadruL5p7Df6KeHVgs1Vo3xsbMorDwKfMEQnspCpio4AXkrbECQ8p0Xz0YTzjFnR
	 2zIZ8NArSwRgypPO1u5CC0n75kUM7nvyMoFw8/UHcS4Z1EBK/BnkOQYUt7ZoAxB8m6UsB
	 cYfWk7J+B3S0rtYlWepoj+LtC7OHRMlNUVEGzaOkLRiPBpXd/0saYjs/SLK8g3z/6p187
	 jVG/w/OIB7fFD4TP2JSCE+/IWmeRtb9499nBbg7PyhSrvYPIS/YV2wjISGrrWoH2CF2bd
	 RezorB85OdUW5+jV7cWRf4U1qF4MubDM8L4KXU3q7AU0F0RexQORNblU3ULfEvbfimg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964546;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=M35MjnMB5SiqdNNYFRbcSX6cDBnYQvQyiEbxPdi7f1c=;
	b=lqNF8BfIQRiWhU7Dx4ylo/i646QwUL03gGEYBKoCUXcLTxDqL7YQaSRMiqmu4VvwvgQt
	 x7Uf+tsc0EPATg4azMXaxu87XZkczKsGa07Nq9PMsrqJZUf9HyluAJhEXzVNbFcYrrTEq
	 gnXqwycB7PkTF/pPIbFGAR/dJkxPoGR0QfX3egwQ+qWyPL8kJA0t0VsxbQfcmIX3PTETa
	 z+gQfUaU22SJUJSrfHdA4k0luiR26qgihThgrKXB/Sim3ZpW5FgB60v6Hcq3N9sAoLHpC
	 p86wtYLIdgZnXY0FReHAZBTw4yo9Ccmy5Mc39JlCLr1QKgD3QujYfUbF/6n7GDli26g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=HQsIcjaw;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7157606A337
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 11:29:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7157606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=HQsIcjaw
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=M35MjnMB5SiqdNNYFRbcSX6cDBnYQvQyiEbxPdi7f1c=; 
	b=HQsIcjawpa5yvDS8IT5ojmVPaQqlJ1y0mftqJEVuGoyKR+RpQDwriTJeIrr0MeOaxgh9RAOm9lJ
	Na0tF8+TQ+FAkOrjqAlP/ytHJDZYxzE6p+Pw6i6HxPta6m1+nJkB5oK8skHMI3GJJ3M01GY5gM8F1
	YNhgnwdIm5cx0VyA6Zgxz0Wm4//d3MYMqvK8HwQ++DST7F7twTGNTkDRUHLjhqfkX37afmKWGlgFl
	UUsL6lygMqUQcCA2Kh4YdMaUK5Je5VMelyXr7cUGSlMl27XU64gg0Cjpcpr48DLw87TUwOgwCd4vd
	EribE0Hs1gFM3vInmma0e6VUfllcVi+ee0mQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xPI7y-0000000Br7P-0Dmc;
	Fri, 06 Nov 2026 19:29:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2026 19:29:02 +0800
Date: Fri, 6 Nov 2026 19:29:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 00/14] crypto: Remove the unnecessary crypto_rng API
Message-ID: <au25_gHcAw-0Wl25@gondor.apana.org.au>
References: <20261018204618.104876-1-ebiggers@kernel.org>
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
In-Reply-To: <20261018204618.104876-1-ebiggers@kernel.org>

On Sun, Oct 18, 2026 at 01:46:04PM -0700, Eric Biggers wrote:
> This series applies to cryptodev/master commit 666d66df25253
> 
> The crypto_rng abstraction layer was designed as a generic interface for
> random number generators.  However, it's now exclusively used to
> implement a "NIST approved" RNG and the "jitterentropy" entropy
> collector that supports it (for certification reasons).
> 
> Previously some hardware RNG drivers supported crypto_rng.  However,
> that functionality was unused and just caused confusion, as it existed
> alongside hw_random which is the interface that is actually used.
> 
> Reflecting this reality, this series removes crypto_rng and makes the
> drbg and jitterentropy modules provide dedicated APIs directly.  This
> simplifies the code, improves performance, and ensures that people don't
> waste time implementing unused crypto_rng algorithms in drivers.
> 
> To make this work, update the users of crypto_rng accordingly:
> 
> - drbg.c now calls the jitterentropy API directly.
> 
> - __crypto_stdrng_get_bytes() now calls the DRBG API directly.
> 
> - algif_rng.c now calls the DRBG and jitterentropy APIs directly.
> 
> - The DRBG self-tests are moved from the testmgr to drbg.c itself, and
>   the DRBG APIs are used directly.
> 
> The new implementation should comply with all the same certification
> requirements it did before (which is the only reason this stuff exists
> in the first place).  This includes, for example, running self-tests
> before anything is used, and continuing to support CAVP testing via
> AF_ALG when af_alg_restrict=0 (though a different UAPI should be defined
> for that at some point).  If I missed anything, let me know.
> 
> Eric Biggers (14):
>   crypto: drbg - Don't use uninitialized stack data
>   crypto: rng - Remove unnecessary inclusions of internal/rng.h
>   crypto: jitterentropy - Move health check to first use
>   crypto: jitterentropy - Add library API
>   crypto: drbg - Use jitterentropy library API
>   crypto: drbg - Add library API
>   crypto: drbg - Add self-test for library API
>   crypto: algif_rng - Use DRBG and jitterentropy library APIs
>   crypto: stdrng - Reimplement "stdrng" using direct DRBG calls
>   crypto: drbg - Remove crypto_rng support
>   crypto: jitterentropy - Remove crypto_rng support
>   crypto: jitterentropy - Remove the kconfig prompt
>   crypto: rng - Remove the rng algorithm type
>   crypto: stdrng - Make crypto_stdrng_get_bytes() take size_t
> 
>  Documentation/crypto/api-rng.rst       |  17 --
>  Documentation/crypto/api-samples.rst   |  37 ---
>  Documentation/crypto/api.rst           |   1 -
>  Documentation/crypto/architecture.rst  |   8 -
>  crypto/Kconfig                         |  19 +-
>  crypto/Makefile                        |   1 -
>  crypto/algif_rng.c                     | 109 ++++++---
>  crypto/crypto_user.c                   |   2 +-
>  crypto/drbg-testvecs.h                 | 228 +++++++++++++++++
>  crypto/drbg.c                          | 323 +++++++++++++++++--------
>  crypto/drbg.h                          |  20 ++
>  crypto/geniv.c                         |   2 +-
>  crypto/jitterentropy-kcapi.c           | 158 ++++++------
>  crypto/jitterentropy-kcapi.h           |  17 ++
>  crypto/rng.c                           | 245 -------------------
>  crypto/testmgr.c                       | 102 --------
>  crypto/testmgr.h                       | 218 -----------------
>  drivers/crypto/gemini/sl3516-ce-core.c |   1 -
>  include/crypto/internal/rng.h          |  40 ---
>  include/crypto/rng.h                   | 194 +--------------
>  include/linux/crypto.h                 |   3 +-
>  include/uapi/linux/cryptouser.h        |   3 +-
>  22 files changed, 661 insertions(+), 1087 deletions(-)
>  delete mode 100644 Documentation/crypto/api-rng.rst
>  create mode 100644 crypto/drbg-testvecs.h
>  create mode 100644 crypto/drbg.h
>  create mode 100644 crypto/jitterentropy-kcapi.h
>  delete mode 100644 crypto/rng.c
>  delete mode 100644 include/crypto/internal/rng.h
> 
> 
> base-commit: 666d66df25253070cb297cb920b0bcfcfe5eb871
> -- 
> 2.56.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
