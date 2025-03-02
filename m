Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768915661
	for <linux-crypto@vger.kernel.org>; Sun,  2 Mar 2025 03:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740887589; cv=none; b=fJyp1Yw7yaL1gpIoZcV1QR9ixuy3gtVLyb1bswXpxxvMa3oR3+jK/XLqm2RGn/UrjOoqr4+fcbjp4/586hVBuojBfVomIPhkaccAGSUTtZAXHSobdtd4/f5zGejrc6GXAOxUHAlXYgn5Up5za3+yXdHpP984fGjn2DnHF5ez3NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740887589; c=relaxed/simple;
	bh=BydKwClDB7Fj6VIb+ReT1dt0BYOFeIHFjnfjvRLt2U0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MGvIwxkhURbb37S53Ph2bndsvOzF+25Wu1UqjQggDYpgWebszUx8hmfYtj2yq7nxTmSit25nPnkVRqjvRItnfo7JDyeTPqj8vNCHz1U+R6HZqMr+01xc4NGwKUDUeXkQuUbDpICKsd3E363bJjzQbWtV7M/JiHSrzMgSpY2s4OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=sbhRNPoH; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="sbhRNPoH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bVA4c2z78Mx6tq5s4Ps60yndhOQS8WKqzyEM8Zh98Hk=; b=sbhRNPoHReIMmMX8GjwtY3KzIQ
	3wt2LVtTIpzPTuz0wK6ysfhvSqbRCBjMW1pRi3HrifndUwlnqDhP4e9hu7TTKenQXhcrTKAMg3z6V
	VfiCYHJUdl633mU6I8WhhN3SalMfZJclfDCo7fhTf07g8x28Vry3t29qVcArFESwdbBB0722iaqst
	HiKENwawHZjNqFHXME1SKSy7Vl1Xd4sN7OpiTsCRPqLCxhybxkr7hQthUXGku8NItO5ODbolcVdBH
	ReXAOi5+FbclWuH7So9Z2d/+IZZ+pzFUWiZU4E4E8Hx7PWFcXfSWs95EpzkARz1bQGQNPX3wQoAxt
	kcHb9k7w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1toaNp-002yYu-2F;
	Sun, 02 Mar 2025 11:52:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 02 Mar 2025 11:52:53 +0800
Date: Sun, 2 Mar 2025 11:52:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: mpagano@gentoo.org
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	Ard Biesheuvel <ardb@kernel.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: Re: [PATCH] crypto: lib/aescfb - fix build with GCC 15 due to
 -Werror=unterminated-string-initialization
Message-ID: <Z8PWFaeE7znrSjlV@gondor.apana.org.au>
References: <20250301143842.173872-1-mpagano@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250301143842.173872-1-mpagano@gentoo.org>

On Sat, Mar 01, 2025 at 09:38:42AM -0500, mpagano@gentoo.org wrote:
> Fix char length error which appears when compiling with GCC 15:
> 
> CC      lib/crypto/aescfb.o
> lib/crypto/aescfb.c:124:27: error: initializer-string for array of ‘unsigned char’ is too long [-Werror=unterminated-string-initialization]
> 124 |                 .ptext  = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
>     |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> lib/crypto/aescfb.c:132:27: error: initializer-string for array of ‘unsigned char’ is too long [-Werror=unterminated-string-initialization]
> 132 |                 .ctext  = "\x3b\x3f\xd9\x2e\xb7\x2d\xad\x20"
>     |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> lib/crypto/aescfb.c:148:27: error: initializer-string for array of ‘unsigned char’ is too long [-Werror=unterminated-string-initialization]
> 148 |                 .ptext  = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
>     |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> lib/crypto/aescfb.c:156:27: error: initializer-string for array of ‘unsigned char’ is too long [-Werror=unterminated-string-initialization]
> 156 |                 .ctext  = "\xcd\xc8\x0d\x6f\xdd\xf1\x8c\xab"
>     |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> lib/crypto/aescfb.c:166:27: error: initializer-string for array of ‘unsigned char’ is too long [-Werror=unterminated-string-initialization]
> 166 |                 .key    = "\x60\x3d\xeb\x10\x15\xca\x71\xbe"
>     |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> lib/crypto/aescfb.c:173:27: error: initializer-string for array of ‘unsigned char’ is too long [-Werror=unterminated-string-initialization]
> 173 |                 .ptext  = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
>     |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> lib/crypto/aescfb.c:181:27: error: initializer-string for array of ‘unsigned char’ is too long [-Werror=unterminated-string-initialization]
> 181 |                 .ctext  = "\xdc\x7e\x84\xbf\xda\x79\x16\x4b"
>     |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Mike Pagano <mpagano@gentoo.org>
> ---
>  lib/crypto/aescfb.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Perhaps convert the vectors to a char array instead?

	.ptext = { 0x6b, 0xc1, ... }

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
