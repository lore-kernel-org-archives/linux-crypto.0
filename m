Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0545A2E6CC6;
	Thu,  6 Nov 2025 07:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762413855; cv=none; b=AzJcnuo+wFx/B0DE49fXkDEnRop6ZehYpOekFx8w6DnLCZOQ0sFVVaIRifxcv6UMleFNNNY3RUlB9zfERbYKE8HLo/BRqFycRYcnMK0Sk1GTkVrDuhqlbTq+B3gqyEs+1YSJ3m8gQEar4F8HcvdvkcY4Uc6gcfxur09T6KZmOGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762413855; c=relaxed/simple;
	bh=EQIh4D6IlbvqscR4GqNU/8zxERgLPJ4GCKIjho5utAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tTn6DaklC5BGFlqRg/VIPtvm3IamwNpzsagg5FMHd49QPHd47V22Dm8EYNl3iv+1L9muuOKB2KehC3eJyZBb10hqPdLdDr6HugcSpVj0czEaBgR0lmdD1Hqi5AxZjm5ZpIjpiz/q7x3KSAs7b1lu3LqMMDUIJlCr0FfPrhsH+6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqVYDScy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqVYDScy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545D5C4CEFB;
	Thu,  6 Nov 2025 07:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762413854;
	bh=EQIh4D6IlbvqscR4GqNU/8zxERgLPJ4GCKIjho5utAg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PqVYDScyf2laH9yanLvCfPYB3oEZdbDvBk1Nlv94RwxblyYeNSBg84zYu3VVelNux
	 qoE+NVG/712HRyNrjkodwLqEkE9+gFEXxlbyZNjBp0DK4/ypwYX9XaIpNxxh6GG/YM
	 uqNVQQeiSRPSEssJZnqBdoTCA0bOjSWQyPyB1DJ7u6WQyO2YF889Z55ytzR18+jEOE
	 atq9IWZz9ewQSWuVh0qRol5GGvAOELX1F04jgpC3ruwyt4LTgXcHsttIJWY81P8MoQ
	 EAJXOv05FebmrLL8omgPNYCNZOgJFdu5WkecghRqQVC721+Q7v1WDUnP9ANgd0SlTj
	 MEg9wbpfP0u5w==
Date: Wed, 5 Nov 2025 23:22:33 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/15] SHA-3 library
Message-ID: <20251106072233.GA117499@sol>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
 <20251103173404.GE1735@sol>
 <4188d18bfcc8a64941c5ebd8de10ede2@linux.ibm.com>
 <20251106043340.GC1650@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106043340.GC1650@sol>

On Wed, Nov 05, 2025 at 08:33:40PM -0800, Eric Biggers wrote:
> On Wed, Nov 05, 2025 at 04:39:01PM +0100, Harald Freudenberger wrote:
> > On 2025-11-03 18:34, Eric Biggers wrote:
> > > On Sat, Oct 25, 2025 at 10:50:17PM -0700, Eric Biggers wrote:
> > > > This series is targeting libcrypto-next.  It can also be retrieved
> > > > from:
> > > > 
> > > >     git fetch
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> > > > sha3-lib-v2
> > > > 
> > > > This series adds SHA-3 support to lib/crypto/.  This includes support
> > > > for the digest algorithms SHA3-224, SHA3-256, SHA3-384, and SHA3-512,
> > > > and also support for the extendable-output functions SHAKE128 and
> > > > SHAKE256.  The SHAKE128 and SHAKE256 support will be needed by ML-DSA.
> > > > 
> > > > The architecture-optimized SHA-3 code for arm64 and s390 is migrated
> > > > into lib/crypto/.  (The existing s390 code couldn't really be
> > > > reused, so
> > > > really I rewrote it from scratch.)  This makes the SHA-3 library
> > > > functions be accelerated on these architectures.
> > > > 
> > > > Finally, the sha3-224, sha3-256, sha3-384, and sha3-512 crypto_shash
> > > > algorithms are reimplemented on top of the library API.
> > > 
> > > I've applied this series to
> > > https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next,
> > > excluding the following 2 patches which are waiting on benchmark results
> > > from the s390 folks:
> > > 
> > >     lib/crypto: sha3: Support arch overrides of one-shot digest
> > > functions
> > >     lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest functions
> > > 
> > > I'd be glad to apply those too if they're shown to be worthwhile.
> > > 
> > > Note: I also reordered the commits in libcrypto-next to put the new
> > > KUnit test suites (blake2b and sha3) last, and to put the AES-GCM
> > > improvements on a separate branch that's merged in.  This will allow
> > > making separate pull requests for the tests and the AES-GCM
> > > improvements, which I think aligns with what Linus had requested before
> > > (https://lore.kernel.org/linux-crypto/CAHk-=wi5d4K+sF2L=tuRW6AopVxO1DDXzstMQaECmU2QHN13KA@mail.gmail.com/).
> > > 
> > > - Eric
> > 
> > Here are now some measurements on a LPAR with 500 runs once with
> > sha3-lib-v2 branch full ("with") and once with reverting only the
> > b2e169dd8ca5 lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest
> > functions
> > patch ("without"). With the help of gnuplot I generated distribution
> > charts over the results of the len=16, 64, 256, 1024 and 4096 benchmark.
> > See attached pictures - Sorry but I see no other way to provide this data
> > than using an attachment.
> > 
> > Clearly the patch brings a boost - especially for the 256 byte case.
> > 
> > Harald Freudenberger
> 
> Thanks.  I applied "lib/crypto: sha3: Support arch overrides of one-shot
> digest functions" and "lib/crypto: s390/sha3: Add optimized one-shot
> SHA-3 digest functions" to libcrypto-next.  For the latter, I improved
> the commit message to mention your benchmark results:

Also, I'm wondering what your plan to add support for these instructions
to QEMU is?  The status quo, where only people with an s390 mainframe
can test this code, isn't sustainable.

I already have s390 in my testing matrix; I run the crypto and CRC tests
on all architectures with optimized crypto or CRC code.  But most of the
s390 optimized crypto code isn't actually being executed.

- Eric
