Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792989943;
	b=mzBWJE6TF4oa6yI64uWGxxR3mjjTMRX6/1tIJI0F0nvVYgb8E/jTMRh92Z8F39LaVlH2
	 iGDDERJzJbem/8TEjQXBOmiWiC6lo99A1TkRnriIzA2GL9D0QRTfisqMdcDmc9zYChSDa
	 JdJR+l75GgWd3Vyf+3/lAo2t8E+2crryH3P5BeTKviCBdeV0cimPZ2yanJ6DYFEj+WpRr
	 p7QKZhnaA4E9Lgwo0E5Y+ZtlCIG9rDi49e1OMqzP1kd9OTLZzyGtOxSq9058+xYd8EiQS
	 WG8iS7D4a9gia9tzfufcRnGt9pq6c8r0C0KtiTeqgQW0NEREWC6CdPy6kMyTPcikGUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792989943;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Ctg4ZBllywdoJU1LPL4rKBvQK/JQ33ryqPTistYi/Kg=;
	b=t8yRax65S+TBXGKOzCC0AHkxfMzNgK+DeTHCuiNPtLdTYgmEwCo5bCx2nsQliaTajl0h
	 Irii4+OxteQfXUYFVvziXpbCrN9YDXfJ5vyWzeCadY9bewCxNBPyV/VMS953WjsKoP8Hi
	 nnnoyGkUd+yHThCwc8Wd+2Rpj+SSdrYxoUnmr3vN+rFaouRBWgvjGH1jyXb4BTcm1zDAv
	 uycLF64F5eshp6emtWtEAIta15unJs3uJMdkkwp/nY2OcGHAZjawFA6szwdn3OiHUQnT4
	 cVawXHUgSSOPecmXv4xgndM+qjuEknyA3yJH/5sEdvPuqM8pq3gXUXZLQt00mATnGrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=UoBomuu5;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD742606A31A;
	Mon, 26 Oct 2026 04:45:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD742606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=UoBomuu5
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Ctg4ZBllywdoJU1LPL4rKBvQK/JQ33ryqPTistYi/Kg=; 
	b=UoBomuu5yZN3a0RZLc2jM8bDh6tdxZe7kE31Dr13AdHUEx/LBUtd0wC6OYfC4eqL5puQUaFlzsb
	ara+p7mtdmC2tlWGUNgm6VmsHFO7rXIq4e/TEAJrQ8zCTtjR3h0xwEVYkuLTkkYcdV1i6IYVtjwvN
	+Ky1Il4QflXWr9b7a+6z5f2maHLX/5KEobcc5fiBnSl44ZDend/Bn1zdBWFMm0jLpfVV08haKv1iC
	82WTNscul4q7wYD5ZZHeSRb+VSETNJkgH2b1dBHJaUmvCB9k8m6mN4JzPNTOMN3Yp7s55X7baBf1y
	9pYWiKaCNKnXOXgxQzxlWdHkO8rKpzrKiP/g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xLCaW-00000007Xfd-36JY;
	Mon, 26 Oct 2026 12:45:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 26 Oct 2026 12:45:36 +0800
Date: Mon, 26 Oct 2026 12:45:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Paul Louvel <paul.louvel@bootlin.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Christophe Leroy <chleroy@kernel.org>
Subject: Re: [PATCH v8 00/20] crypto: talitos - Driver cleanup
Message-ID: <at7a8Dhk_Gubr7hB@gondor.apana.org.au>
References: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
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
In-Reply-To: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>

On Tue, Oct 13, 2026 at 03:11:26PM +0200, Paul Louvel wrote:
> The Freescale Integrated Security Engine (SEC) aka "Talitos" driver
> implementation is a monolithic ~3800-line file that mixes SEC1 and SEC2
> hardware variants with hash, skcipher, aead and hwrng algorithm.
> 
> This series reorganises the driver to improve readability and
> maintainability:
> 
> - Split the driver into a dedicated directory with separate files for
>   hash, skcipher, aead, and hwrng implementations.
> 
> - Modernise the crypto API usage: adopt {init,exit}_tfm (deprecated
>   cra_init/cra_exit), use CRYPTO_AHASH_ALG_BLOCK_ONLY to eliminate
>   manual partial-block buffering, and use macros to deduplicate
>   algorithm definitions.
> 
> - Introduce a is_sec1() helper to get rid of is_sec1 variables /
>   parameters.
> 
> - Define descriptor/pointer structures for each hardware version,
>   instead of using a single structure and anonymous union.
> 
> No functional changes are intended except for patch 1.
> 
> This series depends on the "crypto: talitos - bug fixes" series :
> https://patch.msgid.link/20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-0-c98d7589b942@bootlin.com
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
> ---
> Changes in v8:
> - Patch 1: not addressing this Sashiko issue.
>   I had no problem while testing, and [0] "When this flag is cleared to
>   manually pad the message, it appears to completely disable the
>   hardware's HMAC outer hash (opad) execution." is an hallucination.
>   There is no such statement in the reference manual, nor the
>   programming manual (AN2912).

Well, Sashiko now has another comment to the same patch.

I think this series is too big.  Let's break it into smaller pieces.
For instance, let's just focus on the first patch for now without
the rest.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
