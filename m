Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABAF13C3CD;
	Mon, 20 Oct 2025 17:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760983149; cv=none; b=sYDevW2ULrC3tBFoJ0iinC4pEwO0nKeTFgh/kuEUZGEx0Uy6qVZN88K6dF2GVqa6L678I5y/A4rv7yk0rvTk7eVFq6yvCoxfnyO6yWTZDJwml/QUuF9vc8VhU1cxy44LAGcsfNY6SvA6X/TjjVzalHYjgovMFZzIQ7ZuvTdUC70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760983149; c=relaxed/simple;
	bh=x7GUYv8Ms47fFopUIi3Wz6TTbTv7Y2GnvOK59yf3mcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IWS2kr9d/YTHlCHgNKDkq2/LRkiBl19kVwhJlwGCcjm/WC0nIP7NZPCI+2vezC7QNJdo42CAe3iMqEW1z8mxOHo3RrAFKfEIrz/B+oOFs7JrAQ2EFRb1EhgzvSzDKmiHkHsMQLiHVGc713y7iAi7M6qUvDg8V4idb03Hn9NXHPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pIwu3N3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pIwu3N3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F22C4CEF9;
	Mon, 20 Oct 2025 17:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760983149;
	bh=x7GUYv8Ms47fFopUIi3Wz6TTbTv7Y2GnvOK59yf3mcs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pIwu3N3RIH04/zJHOEAoM7ocAG9NiaDVkyJ306sift4cHMx3Tb2f/ippaSK8Fg06m
	 6IQXodbTyF3Qn2c8aDBNoAVRP6uZT4YfvSbV/KeUzZiYZHUyMEJW0Pbfi8/fKQNP3+
	 pDGdjuzWzXILebjnLWC8McdJmoz/tKPyQwLAhX/T0UQmYRShJMBWRvW45Z1d1FMa6W
	 s2Dn0RtbK5qByuihJwoqQzl2p1ofOCvEBa9Bfw1Q3yhHuxwDJn4cH0vmPgAfOXoB9i
	 iMRB0KkL4qetti2maqpV8j/O4nn5UDYIT0eifLYn9cGmrEOg+7i5oDkN/hHaIRQa4v
	 MoYDtbKU4Sn8A==
Date: Mon, 20 Oct 2025 10:57:36 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: David Howells <dhowells@redhat.com>, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>
Subject: Re: [PATCH 15/17] lib/crypto: s390/sha3: Migrate optimized code into
 library
Message-ID: <20251020175736.GC1644@sol>
References: <20251020005038.661542-1-ebiggers@kernel.org>
 <20251020005038.661542-16-ebiggers@kernel.org>
 <51fc91b6-3a6e-44f7-ae93-aef0bcb48964@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51fc91b6-3a6e-44f7-ae93-aef0bcb48964@linux.ibm.com>

On Mon, Oct 20, 2025 at 04:00:42PM +0200, Holger Dengler wrote:
> On 20/10/2025 02:50, Eric Biggers wrote:
> > Instead of exposing the s390-optimized SHA-3 code via s390-specific
> > crypto_shash algorithms, instead just implement the sha3_absorb_blocks()
> > and sha3_keccakf() library functions.  This is much simpler, it makes
> > the SHA-3 library functions be s390-optimized, and it fixes the
> > longstanding issue where the s390-optimized SHA-3 code was disabled by
> > default.  SHA-3 still remains available through crypto_shash, but
> > individual architectures no longer need to handle it.
> > 
> > Note that the existing code used both CPACF_KIMD_SHA3_224 and
> > CPACF_KIMD_SHA3_256 after checking for just CPACF_KIMD_SHA3_256, and
> > similarly for 384 and 512.  I've preserved that behavior.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> The current code also cover a performance feature, which allows (on
> supported hardware, e.g. z17) to skip the ICV initialization.

I'm not sure if by "ICV" you mean "Integrity Check Value" or "Initial
Chaining Value", but SHA-3 doesn't have either of those.  It just starts
with a state of all zeroes.  I assume that skipping the
zero-initialization of the state is what you're referring to?

> support has been introduced with 88c02b3f79a6 ("s390/sha3: Support
> sha3 performance enhancements"). Unfortunately, this patch removes
> this support. Was this intended?

For now, yes.  I should have explained more in the patch, sorry.

As currently proposed, lib/crypto/sha3.c supports arch-specific
overrides of sha3_absorb_blocks() and sha3_keccakf().  Those cover the
Keccak-f permutation which is by far the most performance critical part.
This strategy is working well in the SHA-2, SHA-1, and MD5 libraries,
which support the same level of arch overrides.

We could update lib/crypto/sha3.c to allow architectures to override
more of the code.  But we need to consider the tradeoffs:

- Risk of bugs.  QEMU doesn't support the s390 SHA-3 instructions, so no
  one except the s390 folks can test the code.  I can try to write code
  for you, but I can't test it.  And the s390 SHA-3 code has had bugs;
  see commits 992b7066800f, 68279380266a5, 73c2437109c3.

  The first priority should be correctness.

- The proposed change to the init functions would cause the format of
  'struct __sha3_ctx' to be architecture-dependent.  While we can do
  that if really needed, it's something that's best avoided for
  simplicity.  It opens up more opportunity for error.

- As I mentioned, Keccak-f is by far the most performance critical part
  anyway.  The initial state is just all zeroes, and initializing it is
  very lightweight.  Also consider that these contexts are often on the
  stack, and people increasingly set the "init all stack variables to
  zero" kernel hardening option anyway.

  I'll also note that commit 88c02b3f79a6 has no performance data in it.
  So it's not clear that it actually helped much.

- The library has an optimization to greatly reduce the size of the
  context: instead of buffering data separately, it just XOR's data into
  the state.  So, if there's a sha3_*_init() followed by a sha3_update()
  of less than 1 block, it will have to initialize the state anyway.  We
  can delay it until that point on s390.  But again: complexity.

- These potential additional s390 optimizations would presumably help
  the most on short messages.  However, on short messages, merely
  switching to the library often gives a large performance improvement
  due to eliminating the very slow call to crypto_alloc_shash().  That's
  actually a lot more important.

I would suggest that we drop the sha3_*_init() optimization from
consideration for now.  Providing overrides for the one-shot functions
sha3_{224,256,384,512}() should be simpler as well as possibly a bit
more useful, and I would suggest exploring that.

I guess I can try to write the code for you again.  But again, without
QEMU support I cannot test it.  The first priority in cryptography code
is correctness, so that's not a great position to be in.

Note that for new optimized code I'm requiring QEMU support for the
instructions it uses.  This one would only be allowed because code that
used these instructions already existed in arch/s390/crypto/.

> Please also add me and Harald Freudenberger to the cc: list for this patch.

Will do, thanks.

- Eric
