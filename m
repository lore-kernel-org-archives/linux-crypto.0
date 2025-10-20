Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366212741B6;
	Mon, 20 Oct 2025 17:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760980813; cv=none; b=ClQFp9AqOyxvCWh0Hy5pxMja//WbR3PVg5cSZpxPSUDgh2SdAMN7uFOizCLpclGd745j0hTdfpuKotI7BvPE70P27oZFJZx2MoGTSi7gwaAfDHB6RpjUXqrCmsCuXqEEeyLpv89ClGS/PHWMgwrYCWtGXOqB+5Mpmj7MbZGM6KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760980813; c=relaxed/simple;
	bh=BBdSB5XAD1YvzsBRvHq+pGVZ+js4CR0/KKZhrayNJnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZu/vrLl1pysXXiAzxFwRKWdsqbbauEJwMMq34+Sg6UnwURsBk5ANAfwaU6TMv8QK9ynsO6D3DN6BtMFP9AgQmhVhRRNYDRPlJFA8G6dDf7fIu1Pss3uzb4zIf6XpnpDqYP/Nq+MrGflIVfGca0JBrKHOYXwY0OVzzHQrDHrVN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OePdjB6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OePdjB6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A902C4CEF9;
	Mon, 20 Oct 2025 17:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760980811;
	bh=BBdSB5XAD1YvzsBRvHq+pGVZ+js4CR0/KKZhrayNJnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OePdjB6eN0nq/HbPmKKQystov9LAi8oF8K8mYHl9KXXh4ilJKjD63usjZ08iIKSa/
	 bj9gfaXCGR5r+lZZh/squfy/YwgeJ3QaR1/WRK66VT1IyDULP5Llpdwrti0U6KPDnf
	 yglYXevr+51SpGHDz3jMCVsnXQgAJYtZ8crZMwzpTDs1DL3ku//SZWEyBhrV30ei6J
	 TUt5uvdnqAg1XdPj/juXZG4Atwlo89iJ8Vn2GcbmBjoo0hkLArzN81o4jyOvj15+z/
	 xrAcRsVca+1jSo4HvvTDrqPtZ+vOqTkpzE9irJ85sG4EYFsYVm33yPDLlxxmtydwZz
	 ts/FURmYtpu/Q==
Date: Mon, 20 Oct 2025 10:18:38 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH 11/17] lib/crypto: sha3: Simplify the API
Message-ID: <20251020171838.GB1644@sol>
References: <20251020005038.661542-12-ebiggers@kernel.org>
 <20251020005038.661542-1-ebiggers@kernel.org>
 <1062182.1760956416@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1062182.1760956416@warthog.procyon.org.uk>

On Mon, Oct 20, 2025 at 11:33:36AM +0100, David Howells wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > Instead of having separate types and functions for each of the six SHA-3
> > algorithms, instead divide them into two groups: the digests and the
> > XOFs.  The digests use sha3_ctx and the XOFs use shake_ctx.  The
> > internal context is now called __sha3_ctx.
> 
> Please roll changes into the original patches rather than posting them with a
> set of "fixes" and add a Co-developed-by tag for yourself.

Sure, that sounds good to me.  I'll do that on the next version.  For
this version I wanted to make it clear what I had changed.  Also, some
people don't like it when their patches are changed, so I wanted to make
sure you were okay with it first.

> > +/** Context for SHA3-224, SHA3-256, SHA3-384, or SHA3-512 */
> > +struct sha3_ctx {
> > +	struct __sha3_ctx	ctx;
> > +	u8			digest_size;	/* Digest size in bytes */
> > +};
> 
> Don't do that.  That expands the context by an extra word when there's spare
> space in __sha3_ctx.  If you go with the separate types, then this field is
> redundant.

Right, packing the struct tightly is nice.  On the other hand, having
the digest_size be in the digest-specific struct prevents it from
accidentally be used during XOF operations.

Consider that the arm64 SHA-3 assembly function took a digest_size
argument.  It was tempting to just use __sha3_ctx::digest_size, but of
course that would have been wrong.

But it looks like we could tighten sha3_absorb_blocks() to take a
(sha3_state, block_size) pair.  That would reduce the number of places
in which __sha3_ctx is used.  We should do that anyway.  So I'll
tentatively plan to do that and also move the digest_size to __sha3_ctx.

> Actually, I lean slightly towards passing in the desired digest length
> to sha3_*final() and doing a WARN if it doesn't match.

That would be redundant though.  It would make the API more difficult to
use, especially in the case where the caller is supporting multiple
SHA-3 variants, e.g. crypto/sha3.c.

Note that BLAKE2s has a variable-length digest too, and the BLAKE2s API
only requires that the digest size be passed to init.

I prefer the simpler version that's consistent with the BLAKE2s API.

> > +static inline void sha3_zeroize_ctx(struct sha3_ctx *ctx)
> 
> sha3_zero_ctx() please if you don't like "sha3_clear_ctx".  "zero" is a
> perfectly usable as verb in itself.

In cryptography it's normally zeroize.  See
https://en.wikipedia.org/wiki/Zeroisation

And also try 'git grep zeroize include/crypto/':

    include/crypto/acompress.h: * acomp_request_free() -- zeroize and free asynchronous (de)compression
    include/crypto/aead.h: * crypto_free_aead() - zeroize and free aead handle
    include/crypto/aead.h: * aead_request_free() - zeroize and free request data structure
    include/crypto/akcipher.h: * akcipher_request_free() - zeroize and free public key request
    include/crypto/chacha.h:static inline void chacha_zeroize_state(struct chacha_state *state)
    include/crypto/hash.h: * crypto_free_ahash() - zeroize and free the ahash handle
    include/crypto/hash.h: * ahash_request_free() - zeroize and free the request data structure
    include/crypto/hash.h: * crypto_free_shash() - zeroize and free the message digest handle
    include/crypto/internal/cipher.h: * crypto_free_cipher() - zeroize and free the single block cipher handle
    include/crypto/kpp.h: * kpp_request_free() - zeroize and free kpp request
    include/crypto/md5.h: * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
    include/crypto/md5.h: * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
    include/crypto/rng.h: * crypto_free_rng() - zeroize and free RNG handle
    include/crypto/sha1.h: * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
    include/crypto/sha1.h: * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
    include/crypto/sha2.h: * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
    include/crypto/sha2.h: * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
    include/crypto/sha2.h: * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
    include/crypto/sha2.h: * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
    include/crypto/sha2.h: * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
    include/crypto/sha2.h: * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
    include/crypto/sha2.h: * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
    include/crypto/sha2.h: * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
    include/crypto/skcipher.h: * crypto_free_skcipher() - zeroize and free cipher handle
    include/crypto/skcipher.h: * crypto_free_lskcipher() - zeroize and free cipher handle
    include/crypto/skcipher.h: * skcipher_request_free() - zeroize and free request data structure

Point is, we should prefer standard terminology that is already used in
the code and the wider problem domain, instead of coming up with new
terminology each time a new contributor hops in.

- Eric
