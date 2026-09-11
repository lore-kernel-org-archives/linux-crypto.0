Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC223C4B79;
	Fri, 11 Sep 2026 05:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789104638; cv=none; b=kkY+Ah7GQe9NFyfLu8IsgFLPtUu2NyX6QsejfrefvyIK1wXHdJCa6S/6T+MP0wGp3BC6YIAvIyVSjHE7Hqy6zc7m2rMF0r6K+1Tyd+/ua+mpRg0lynbLQZF3q+R9vbVO9GVar3Yaxs3pbsnbWU0t6EI8xU8zEFe+OWZvP/wFNkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789104638; c=relaxed/simple;
	bh=Bl9SglN3O84V62hsrLBML0+Aw9m3FCn6Tna43CBs4JI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a5MEwQJ2JVYN+qik6nnyPhEeZ39yJi+ODemKsQ4eDyWivSgiDl3SuaZ0t3JtSVOBkMxFUvRCal9U83USnLsnKzunoMSHk9sIRBphvCawrVBHsy5Mcn3+Jv0P3loNpG3Ywg9fXXp0vU2w4x3mASaRt2gbqR6AG7NDsKh3PlFlea8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Mov11AJS; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Mov11AJS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=RAzqMJyfWffnd0KP5f4SwAp8Y5vWAr+5IodcQ5y1LnQ=; 
	b=Mov11AJSwbzm2/RpeywMES4De1nrUJ3gQs7Wfr4CFwCghSsX11X9Y+RnhlQovOcqKM79OGXAOCf
	Euuk3ehdm5ZLP1czSgWRQVtIE6jT0ajK2faPwObgYex3/2pvNqYaDy5ODa893Lk3UDY75lDvdqbTd
	trjs5swrmslxrlVghRcJesnpJPpb5efR7EverX25vvm7g7/VR8wSKoobUZAntCr3/N+y//zLfSK1d
	qbOJRCkWZw9qqJIr6mJh15N7SuI80TX4ZR3ePJmmhbHGOAieH5RlfCk4wPFPElRof4uup5FvqLTTa
	M2Y8Dtz+WPWIHnxud0D5vF+QRRQd/gW0quQw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4tqH-0000000CuAu-0mpt;
	Fri, 11 Sep 2026 13:30:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:30:29 +1000
Date: Fri, 11 Sep 2026 15:30:29 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-aes - fix AADLENR for standalone GHASH
Message-ID: <aqOR9dg-KzA-U2QP@gondor.apana.org.au>
References: <20260829042604.82719-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829042604.82719-1-kmehltretter@gmail.com>

On Sat, Aug 29, 2026 at 06:26:04AM +0200, Karl Mehltretter wrote:
> atmel_aes_gcm_ghash_init() writes dd->total, the request's text length,
> to AES_AADLENR.  But the GHASH it runs hashes the dd->datalen bytes passed
> in: the 16-byte length block, or the padded IV when the IV is not 96 bits.
> The data sheet requires AES_AADLENR to hold the length of that input.
> 
> With empty plaintext and empty AAD, dd->total is 0 and the tag comes out
> wrong.  Later requests only pass because dd->total still holds the
> previous request's length.
> 
> This is testmgr's first gcm(aes) vector, so CONFIG_CRYPTO_SELFTESTS=y
> fails at boot:
> 
>   alg: aead: atmel-gcm-aes encryption test failed (wrong result) on test
>   vector 0, cfg="in-place (one sglist)"
> 
> Without selftests the broken atmel-gcm-aes is preferred at priority 300.
> Seen on a SAM9X75 Curiosity with 6.18 and current mainline.
> 
> Write dd->datalen instead.
> 
> Fixes: d4419548dba9 ("crypto: atmel-aes - add support to GCM mode")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  drivers/crypto/atmel-aes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
