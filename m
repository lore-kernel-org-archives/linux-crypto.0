Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539E128D8F4;
	Fri, 26 Sep 2025 21:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758921994; cv=none; b=CnpugY3PjNzetwxheAbaMI5xYsXjnWf8EvaSc+dLqErPOmSGWW2ztiRhmh7QhQZixTIw4natAvWBAAm3AbHte+W5KZgKzKlRsDNy1FiaQ/WAnBgsY4fwzJ33YPKf7ee14DTFnR8VvRMsuXBI0i6cbepONLDq9ElrYAlxdeEWAWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758921994; c=relaxed/simple;
	bh=IoZKsPrcS7krE4hjJ+t9Lyy0kyIowgRVUJ+7yyEDQ34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NHh2aGlNBwDZTM8uJnt1f+D2lcNikZrUvmzahDlJNOehm+y1h7OS+CpCtluzrQCQssxShfeENkYMn5tvzAUnYaEFIAL0EhZjJ0YT3QXp9++8UAiqHFb2+ZqmifTjyXxZRHw8Pv8lr3UT2KN7SDwPFz/1J0WLo21pCCeeklBkYQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ak/qavcg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ak/qavcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C8FC4CEF8;
	Fri, 26 Sep 2025 21:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758921993;
	bh=IoZKsPrcS7krE4hjJ+t9Lyy0kyIowgRVUJ+7yyEDQ34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ak/qavcgVqOI1gOpq0ZPpnm6Hc8AQ9nswgpvYE+gayELkYTvfr8BQAO876OoRnsnL
	 M+R1YM5WkN8/fbV14000pmbN67Yo8hZDalgKMjaTHuAmMi+1BAkc81b9uxO7zLGoQQ
	 NQ+sbYsS2Eou2/Fat1p0C/YDEMJmSVA7+dq6WRWjiUY2y4JYZmbhhJ5a2h6SWeDCCL
	 Qk+lneolh9Un2oz1qNXD2qdHI5dZbOFd6RMeqc/pznobKZoVMrTvtRd4yeMm+m/bHX
	 3pXs7f07tl/eY31n/Pl+N+1egPAbJSvTdGTLfAXtON0NYTekBhTbl8KTQ6OS2I3Ex1
	 CGePosTC04UqQ==
Date: Fri, 26 Sep 2025 14:25:14 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/8] crypto/sha3: Use lib/crypto/sha3
Message-ID: <20250926212514.GD2163@sol>
References: <20250926141959.1272455-1-dhowells@redhat.com>
 <20250926141959.1272455-7-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926141959.1272455-7-dhowells@redhat.com>

On Fri, Sep 26, 2025 at 03:19:49PM +0100, David Howells wrote:
> Switch crypto/sha3_generic.c to use lib/crypto/sha3.  Note that this makes
> use of the internal general API rather implementing a separate set of
> init/update/finup handlers for each algorithm.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Eric Biggers <ebiggers@kernel.org>
> cc: Jason A. Donenfeld <Jason@zx2c4.com>
> cc: Ard Biesheuvel <ardb@kernel.org>
> cc: Herbert Xu <herbert@gondor.apana.org.au>
> cc: Stephan Mueller <smueller@chronox.de>
> cc: linux-crypto@vger.kernel.org
> ---
>  Documentation/crypto/sha3.rst    |   8 +-
>  arch/arm64/crypto/sha3-ce-glue.c |  25 ++--
>  crypto/sha3_generic.c            | 201 +++----------------------------
>  include/crypto/sha3.h            |   6 +-
>  lib/crypto/sha3.c                |  35 +++---
>  5 files changed, 52 insertions(+), 223 deletions(-)

What's worked well for the other algorithms is to do things in this
order:

    1. Move the arch-specific implementations into lib/crypto/,
       making them available via the library API and temporarily
       removing them from the crypto_shash API.  One patch per arch.

    2. Replace crypto/${alg}_generic.c with crypto/${alg}.c that is
       built directly on the library API.  The algorithms are called
       "*-lib" instead of "*-generic", and they don't use the
       crypto_shash generic partial block handling.

Again, if you don't want to do all that, I'd be glad to do it.  I'd be a
bit hesitant to take this patch instead, as it sort of starts out going
in a different direction.  So it would create a temporary situation, and
we'd need to make sure that temporary situation works.  (FWIW, this
patch breaks the build of sha3-ce-glue.c, so that's not a great start.)

- Eric
