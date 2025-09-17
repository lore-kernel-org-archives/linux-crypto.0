Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6227082D
	for <linux-crypto@vger.kernel.org>; Wed, 17 Sep 2025 18:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758134940; cv=none; b=EvGLqUmFiM5lzb7rDyY03TEyaTek8oX5z5N8DuAGloSF7WSoizqLhmBr4bHnn8WkT+oZLyH1QTmi7+Zk5YXdvEA8+IQ7jPwaa88SSxQI82A8HbM+/Z2VCHokCwCRurQmNXfHJ9SNCzz99jvtezdZzMOGwxcLsEICAmBum6zR370=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758134940; c=relaxed/simple;
	bh=xLHT7aZU+wluB3wR7VwHzdJkoqTpTyUQNyl6VnuBJ8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e1wGUuiwwUK9hVj/IcDoRUP6YDuU76saw3Fm8mOFPB6Se+wSHoTYYNPC9vZTq7fkr9Mjrg03qibY3qbaG5Per1veB71ZLsBpE1AWprGHy2267nJg/T+DihhHmQPYn25Sep+C9qg/8BL77QEkA5tcodYw7n4xM6ihK9MLYsOY+RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EkZ/wDgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EkZ/wDgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3812FC4CEE7;
	Wed, 17 Sep 2025 18:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758134939;
	bh=xLHT7aZU+wluB3wR7VwHzdJkoqTpTyUQNyl6VnuBJ8o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EkZ/wDghfsTYItkhRktuB/Vl69C5QhJSEDE9RIQ3xE3ALAcln5qqxVUfjivmgzHXZ
	 SwcAVWLnTK6+wGP+bthWScxh/Ok7NXN+rQNtfzdFPf5CKi8BXMtSFWCxG0qx4EsqBk
	 lRHt0hzn0s4mTJQmeTMfWkJoolnLJqI9eOdUSwMCcHMkKy1eTnfAf7Wz1eDsOYdIXi
	 1EfJoIGlLVhRVzOuzVshxcbFCnMpmRPeUndZL7OuNiC0Ktq+Q4t1ExoCoZ7oNZj7Ds
	 ZtdvP0OrqEoa1pymL8gVckiQ4gGDN8D4bGK3p1BkpaYkQ2T/YWmh7Dsn0u8fn3SuqD
	 fWLtBou7/RwKQ==
Date: Wed, 17 Sep 2025 13:48:56 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: SHAKE256 support
Message-ID: <20250917184856.GA2560@quark>
References: <20250915220727.GA286751@quark>
 <2767539.1757969506@warthog.procyon.org.uk>
 <2768235.1757970013@warthog.procyon.org.uk>
 <3226361.1758126043@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3226361.1758126043@warthog.procyon.org.uk>

On Wed, Sep 17, 2025 at 05:20:43PM +0100, David Howells wrote:
> Okay, I have lib/crypto/sha3 working.  One question though: why are the hash
> tests built as separate kunit modules rather than being built into the
> algorithm module init function and marked __init/__initdata?

KUnit is the standard way to do unit testing in the kernel these days.
The kernel community has been working on migrating legacy ad-hoc tests
over to KUnit.  This is not specific to lib/crypto/.

> For FIPS compliance, IIRC, you *have* to run tests on the algorithms,
> so wouldn't using kunit just be a waste of resources?

The lib/crypto/ KUnit tests are real tests, which thoroughly test each
algorithm.  This includes computing thousands of hashes for each hash
algorithm, for example.

FIPS pre-operational self-testing, if and when it is required, would be
a completely different thing.  For example, FIPS often requires only a
single test (with a single call to the algorithm) per algorithm.  Refer
to section 10.3.A of "Implementation Guidance for FIPS 140-3 and the
Cryptographic Module Validation Program"
(https://csrc.nist.gov/csrc/media/Projects/cryptographic-module-validation-program/documents/fips%20140-3/FIPS%20140-3%20IG.pdf)

Of course, so far the people doing FIPS certification of the whole
kernel haven't actually cared about FIPS pre-operational self-tests for
the library functions.  lib/ has had SHA-1 support since 2005, for
example, and it's never had a FIPS pre-operational self-test.

*If* that's changing and the people doing FIPS certifications of the
whole kernel have decided that the library functions actually need FIPS
pre-operational self-tests after all, that's fine.  But please don't try
to misuse the actual (KUnit) tests.  Instead, just add exactly what is
actually required by the FIPS to the appropriate subsys_initcall in the
library.  For SHA-3 for example, you'd only need to compute and verify a
single hash, using any of SHA3-224, SHA3-256, SHA3-384, SHA3-512.  Then
panic() if it fails and fips_enabled is true.

- Eric
