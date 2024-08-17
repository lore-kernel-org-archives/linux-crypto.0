Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4A520E6
	for <linux-crypto@vger.kernel.org>; Sat, 17 Aug 2024 07:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723878533; cv=none; b=YCOCDMJLPPS4J3+JV198dCGcjUw2PAoS3n4KXXMV7tQritL5KrSZL2zHcllWZPkMqQKCH7dQlmPBNbAXQpq9C5zrLD5nxaF2uyBL5QPQLClzPJ+Gc/fPoQpnXZqmlgriwev5iMXZhWgFDsKDp7+t6zCjXDrRt8qKz0gHmvO62FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723878533; c=relaxed/simple;
	bh=2y10LgyFnZMdIt82rr2BAXglctkDffLO+59sLRU3VKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QC5dVXSjebiIis6KAm7yzpmhUdZ50q1iXytKTNLkS1AT0rRvSDNTIazG645+VyHXPZcQm+ulT5RdSRDknfZiJf60EMBCAfnJYEj0A2gB+xf/GJcK6L33NpAVJRzWNMnTyMtFiPVtq3RlsCo4mhazaDbq7otGZhR1owoDiHhd6xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sfDPu-005IKh-0c;
	Sat, 17 Aug 2024 15:08:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 Aug 2024 15:08:47 +0800
Date: Sat, 17 Aug 2024 15:08:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] crypto: arm/aes-neonbs - go back to using aes-arm
 directly
Message-ID: <ZsBMf0axAtPR4Q1k@gondor.apana.org.au>
References: <20240809231149.222482-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809231149.222482-1-ebiggers@kernel.org>

On Fri, Aug 09, 2024 at 04:11:49PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> In aes-neonbs, instead of going through the crypto API for the parts
> that the bit-sliced AES code doesn't handle, namely AES-CBC encryption
> and single-block AES, just call the ARM scalar AES cipher directly.
> 
> This basically goes back to the original approach that was used before
> commit b56f5cbc7e08 ("crypto: arm/aes-neonbs - resolve fallback cipher
> at runtime").  Calling the ARM scalar AES cipher directly is faster,
> simpler, and avoids any chance of bugs specific to the use of fallback
> ciphers such as module loading deadlocks which have happened twice.  The
> deadlocks turned out to be fixable in other ways, but there's no need to
> rely on anything so fragile in the first place.
> 
> The rationale for the above-mentioned commit was to allow people to
> choose to use a time-invariant AES implementation for the fallback
> cipher.  There are a couple problems with that rationale, though:
> 
> - In practice the ARM scalar AES cipher (aes-arm) was used anyway, since
>   it has a higher priority than aes-fixed-time.  Users *could* go out of
>   their way to disable or blacklist aes-arm, or to lower its priority
>   using NETLINK_CRYPTO, but very few users customize the crypto API to
>   this extent.  Systems with the ARMv8 Crypto Extensions used aes-ce,
>   but the bit-sliced algorithms are irrelevant on such systems anyway.
> 
> - Since commit 913a3aa07d16 ("crypto: arm/aes - add some hardening
>   against cache-timing attacks"), the ARM scalar AES cipher is partially
>   hardened against cache-timing attacks.  It actually works like
>   aes-fixed-time, in that it disables interrupts and prefetches its
>   lookup table.  It does use a larger table than aes-fixed-time, but
>   even so, it is not clear that aes-fixed-time is meaningfully more
>   time-invariant than aes-arm.  And of course, the real solution for
>   time-invariant AES is to use a CPU that supports AES instructions.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/arm/crypto/Kconfig           |  14 +++-
>  arch/arm/crypto/aes-cipher-glue.c |   5 +-
>  arch/arm/crypto/aes-cipher.h      |  13 +++
>  arch/arm/crypto/aes-neonbs-glue.c | 131 ++++++++++--------------------
>  4 files changed, 67 insertions(+), 96 deletions(-)
>  create mode 100644 arch/arm/crypto/aes-cipher.h

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
