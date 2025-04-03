Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCE6A927;
	Thu,  3 Apr 2025 01:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743643546; cv=none; b=f9GiBhcF0uGnsQ1cFc7Bdjj1rKCqXPJ8wKh5nLKkfgEyUL/M2VoQ/zXg/R6pg9hCNR2z7ZVgKLzRF4s/pfyGmEjOyHOcIbD+aedXW81aztGSsyvi91sqRCyEmWQwB5u2bhsbJb1kGhbFZufDmKAXI9PD0SJ99quvRMpS4NSpRVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743643546; c=relaxed/simple;
	bh=rQ/HeysvQzTFSqKzvuHOCxICJs4XQNgxqqRT1cdWBT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t5H5cIlXDBM62mhoGFsLVV7rU3/tZ0NgSsdu7sn9ZdkGUzs2fGBvmVTf7q4ywICQz7RYeSMqOtN9HovG/B+4u9scZQNjHoyoQLYxNj6otR8+PANQLeXae1cBjd1ViaLyjgKrCBFuqxl2f7s2fEJzgcKprUUXfAxiC+sH0qWixkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=eEzb23+y; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="eEzb23+y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OIg3XfRKP5VukiiXaWiXHEhXzRBRGdXx2kli7F3IU+Q=; b=eEzb23+y7Ohut2ZAznP/QwUDDo
	Dii8Qqxldj3aXNAyS19gzQIm56onzWpCzxIGfvdw1Mtd+7wZIjp8eLZjthKQ74ja62lthG5WtJrus
	tgxv0ya0G38osKzjvdxPcNTiETUWALuN6xshKw60adaXwT6SOuYfTgMh9+Qo+Tg7lGqr/A94OE+uo
	URaFaEQgmoxFU5aXvQyS0T/7haZgblQroVql5yMG1kSyZNXc9vH2tTj8adetfTEi12Khrn1W32sVD
	MYGCcb9UDirhYTjnIo+Xx2eMRFaXiSqfnFBzgjZvAX77LJJQnwJJ//SGtyS1CNgNi6qU+ZXZCFFWk
	KZzKfJCg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u09Kr-00CKTz-0K;
	Thu, 03 Apr 2025 09:25:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 03 Apr 2025 09:25:37 +0800
Date: Thu, 3 Apr 2025 09:25:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v2 0/9] crypto: x86 - stop using the SIMD helper
Message-ID: <Z-3jkYNtZpTDtKGf@gondor.apana.org.au>
References: <20250402002420.89233-1-ebiggers@kernel.org>
 <Z-yrf_9D2rV1Q136@gondor.apana.org.au>
 <CAMj1kXEx__RLBriW0kVPrKnx6+DCpq8=6F-7Tmj2Us61gvGGaw@mail.gmail.com>
 <CAMj1kXE-vo7E1U++4mAqDH2SXfc=sRZs8KganedJk5z0QF49NA@mail.gmail.com>
 <Z-zzvXbjt3xzquXb@gondor.apana.org.au>
 <20250402171930.GD1235@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402171930.GD1235@sol.localdomain>

On Wed, Apr 02, 2025 at 10:19:30AM -0700, Eric Biggers wrote:
>
> This seems premature.  crypto_shash is documented to be usable in any context.
> See the "Context:" comments in include/crypto/hash.h.  Similarly, developers
> expect lib/ functions to be available in any context unless otherwise
> documented.

Doing slow computations in a hard IRQ is a bad idea.  The whole
point of a hard IRQ handler is to set a flag and defer everything
to a different context.

Please show me one good reason why we should allow crypto in
a hard IRQ.
 
> IMO, doing it for lib/ too would be going too far though.  The lib/ functions
> should be easy to use and not have random requirements on the calling context.
> And since they're just functions, it's easy for them to fall back to the generic
> functions when needed.  Also note that for very short inputs it can actually be
> faster to use no-SIMD code, as that avoids the overhead of a kernel-mode SIMD
> section.  So the fallback sometimes exists anyway for that.

We already disallow SIMD in hard IRQs anyway (may_use_simd is
always false in that context).  The only thing you could use
is the generic implementation.

So making this change in lib/crypto does not take any functionality
away.  You could still invoke the generic lib/crypto code directly.

It does mean that we take away a completely useless check for
people who are actually doing crypto because crypto work should
never be done in a hard IRQ.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
