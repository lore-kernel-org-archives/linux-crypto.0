Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694F929A1;
	Thu,  6 Nov 2025 04:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762403721; cv=none; b=rdgF3NNLzhBFbm5kpPNYzf1OVA0hnIxwVHoGOZcCdcygUth3hb1w65m6rsM1DJD9NE3MtNZV2OoypcdrD1+jzpR5Tm7m+glAzyIMzcTJTpkaabjEz6S9hQ+miLrNIEEit33ikofxoC+rTTRtHCvgnQbE+W40PSp3zsPNgfzezUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762403721; c=relaxed/simple;
	bh=j/5/qmy4jIrHUj6xDBmoQ+We3edlP+5ky0U44w5itsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S32dQRo2lgYUe4kOJe7twDpnD2NaWFWYTW8jzcA5cmCuzpCy3zF/EfGadzc1w4pZQ8rAuFiH/5FtGhhCgo+KUksYUn8czoRie7+nhLQdcup8Dn542on7Ny3DJq21d2noYOBWTpTOOaZLnbFWenMeAqdM691A3LsTzOjzGVgaoHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DSyTqaRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DSyTqaRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62ACC4CEF7;
	Thu,  6 Nov 2025 04:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762403721;
	bh=j/5/qmy4jIrHUj6xDBmoQ+We3edlP+5ky0U44w5itsA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DSyTqaRL5m/48V8JP5XBhTRXBYNS68W9KvpEZSFaFbYm15M+Hb+sCSxfiZwKpnh+4
	 i0XKur1Ak/atYZK8c/FXKaZcBqo/u4/GKPQ/c5/rYqEsqqmOqkPCry2o/IHeI2CVpv
	 OfPGSA2L9pFMlNMuQqJBciVr33bO4Fyem02acQ53anuvOz6DesgtxJbZbDFQ7gJbkt
	 lBHj6/XcnVJEP09JkmzjS4lGvqeFJCeI+LAdoAnqXw4dPKdHsX9vncpvNCb/kGOR65
	 uQKb5zoRWve7/auk+1mEj0RNfKzKYlBuCi+ltf0nN1hOWlsu5cOHhD3KsxLE/o0hgN
	 LK90v0+0TsnQw==
Date: Wed, 5 Nov 2025 20:33:40 -0800
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
Message-ID: <20251106043340.GC1650@sol>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
 <20251103173404.GE1735@sol>
 <4188d18bfcc8a64941c5ebd8de10ede2@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4188d18bfcc8a64941c5ebd8de10ede2@linux.ibm.com>

On Wed, Nov 05, 2025 at 04:39:01PM +0100, Harald Freudenberger wrote:
> On 2025-11-03 18:34, Eric Biggers wrote:
> > On Sat, Oct 25, 2025 at 10:50:17PM -0700, Eric Biggers wrote:
> > > This series is targeting libcrypto-next.  It can also be retrieved
> > > from:
> > > 
> > >     git fetch
> > > https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> > > sha3-lib-v2
> > > 
> > > This series adds SHA-3 support to lib/crypto/.  This includes support
> > > for the digest algorithms SHA3-224, SHA3-256, SHA3-384, and SHA3-512,
> > > and also support for the extendable-output functions SHAKE128 and
> > > SHAKE256.  The SHAKE128 and SHAKE256 support will be needed by ML-DSA.
> > > 
> > > The architecture-optimized SHA-3 code for arm64 and s390 is migrated
> > > into lib/crypto/.  (The existing s390 code couldn't really be
> > > reused, so
> > > really I rewrote it from scratch.)  This makes the SHA-3 library
> > > functions be accelerated on these architectures.
> > > 
> > > Finally, the sha3-224, sha3-256, sha3-384, and sha3-512 crypto_shash
> > > algorithms are reimplemented on top of the library API.
> > 
> > I've applied this series to
> > https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next,
> > excluding the following 2 patches which are waiting on benchmark results
> > from the s390 folks:
> > 
> >     lib/crypto: sha3: Support arch overrides of one-shot digest
> > functions
> >     lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest functions
> > 
> > I'd be glad to apply those too if they're shown to be worthwhile.
> > 
> > Note: I also reordered the commits in libcrypto-next to put the new
> > KUnit test suites (blake2b and sha3) last, and to put the AES-GCM
> > improvements on a separate branch that's merged in.  This will allow
> > making separate pull requests for the tests and the AES-GCM
> > improvements, which I think aligns with what Linus had requested before
> > (https://lore.kernel.org/linux-crypto/CAHk-=wi5d4K+sF2L=tuRW6AopVxO1DDXzstMQaECmU2QHN13KA@mail.gmail.com/).
> > 
> > - Eric
> 
> Here are now some measurements on a LPAR with 500 runs once with
> sha3-lib-v2 branch full ("with") and once with reverting only the
> b2e169dd8ca5 lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest
> functions
> patch ("without"). With the help of gnuplot I generated distribution
> charts over the results of the len=16, 64, 256, 1024 and 4096 benchmark.
> See attached pictures - Sorry but I see no other way to provide this data
> than using an attachment.
> 
> Clearly the patch brings a boost - especially for the 256 byte case.
> 
> Harald Freudenberger

Thanks.  I applied "lib/crypto: sha3: Support arch overrides of one-shot
digest functions" and "lib/crypto: s390/sha3: Add optimized one-shot
SHA-3 digest functions" to libcrypto-next.  For the latter, I improved
the commit message to mention your benchmark results:

commit 862445d3b9e74f58360a7a89787da4dca783e6dd
Author: Eric Biggers <ebiggers@kernel.org>
Date:   Sat Oct 25 22:50:29 2025 -0700

    lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest functions
    
    Some z/Architecture processors can compute a SHA-3 digest in a single
    instruction.  arch/s390/crypto/ already uses this capability to optimize
    the SHA-3 crypto_shash algorithms.
    
    Use this capability to implement the sha3_224(), sha3_256(), sha3_384(),
    and sha3_512() library functions too.
    
    SHA3-256 benchmark results provided by Harald Freudenberger
    (https://lore.kernel.org/r/4188d18bfcc8a64941c5ebd8de10ede2@linux.ibm.com/)
    on a z/Architecture machine with "facility 86" (MSA level 12):
    
        Length (bytes)    Before (MB/s)   After (MB/s)
        ==============    =============   ============
              16                212             225
              64                820             915
             256               1850            3350
            1024               5400            8300
            4096              11200           11300
    
    Note: the original data from Harald was given in the form of a graph for
    each length, showing the distribution of throughputs from 500 runs.  I
    guesstimated the peak of each one.
    
    Harald also reported that the generic SHA-3 code was at most 259 MB/s
    (https://lore.kernel.org/r/c39f6b6c110def0095e5da5becc12085@linux.ibm.com/).
    So as expected, the earlier commit that optimized sha3_absorb_blocks()
    and sha3_keccakf() is the more important one; it optimized the Keccak
    permutation which is the most performance-critical part of SHA-3.
    Still, this additional commit does notably improve performance further
    on some lengths.
    
    Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
    Tested-by: Harald Freudenberger <freude@linux.ibm.com>
    Link: https://lore.kernel.org/r/20251026055032.1413733-13-ebiggers@kernel.org
    Signed-off-by: Eric Biggers <ebiggers@kernel.org>
