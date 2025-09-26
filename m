Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38EC28469A;
	Fri, 26 Sep 2025 20:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758916879; cv=none; b=tYvSzoNO6qNppZ0ggaC7GZDtvuVTwYiZP+vhBemcCnXDVexoLWO0/64CQEUWik5JWwJo3wdZUA/SU1KmIfhG9PCjJzAHqzuHGDwuX6wtR7OXg5iJrf9rz5aK4O1Z6ctVhhsyuWj09ChjjTU5vlGflusqMtGX+9ESkBvr8Cpu794=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758916879; c=relaxed/simple;
	bh=s4u1ER2G5qTcgAa2BrXgHbVJuzX/qyc7Q0c8Zmmx9f4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DfXr3Zk9YZ9EBSepuergMWnBpP5QlmeZTvKQb1iKCQPImfyeDTiPkIMwBAg2CNjJ4IvPSmOnnYdIjbJvJw5Z0KAXoBIfsI19KdaUNrcStLlcfNl/d+vBRfy1bQEaR2HOVV3V+y1cZp0OsqsYhiW6FXKS3JEBZzuwC2ET82L/dLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pkNwdfqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pkNwdfqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1549BC4CEF4;
	Fri, 26 Sep 2025 20:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758916878;
	bh=s4u1ER2G5qTcgAa2BrXgHbVJuzX/qyc7Q0c8Zmmx9f4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pkNwdfqV6raOgekO0YEev2tOKM2O8uZDJyOFxlqnw+ajFnms1NvPaSwvhLVDVeSOZ
	 vT+WKhZYxr+40TpkxK+xb6q6VAYzAiAFwb6j6/qBPNAiJLPEnFs2ZDhONa0l26xGdc
	 OzL+QMIZMt5I/9t7OnWuFhs+OnSDFHHagUcopfLGmaTeoVa7g4agqtJArZofzX2Yzw
	 cgZjYIlJQ4+NDPNKVfvyhma0fUCHOSLOIQVazUsWkkTYVFNSyuwF0o/auNNWiMioda
	 jaD1CzTkxkQvsGksayGf3tlEoxkR4NVBv9OYyWSUk9PPjmBFOxUcV5CdtNkpislbL7
	 2cz0HDSHRGFEw==
Date: Fri, 26 Sep 2025 12:59:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/8] crypto, lib/crypto: Add SHAKE128/256 support and
 move SHA3 to lib/crypto
Message-ID: <20250926195958.GA2163@sol>
References: <20250926141959.1272455-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926141959.1272455-1-dhowells@redhat.com>

Hi David,

On Fri, Sep 26, 2025 at 03:19:43PM +0100, David Howells wrote:
> I have done what Eric required and made a separate wrapper struct and set
> of wrapper functions for each algorithm, though I think this is excessively
> bureaucratic as this multiplies the API load by 7 (and maybe 9 in the
> future[*]).

I don't think I "required" that it be implemented in exactly this way.
Sorry if I wasn't clear.  Let me quote what I wrote:

    First, this patch's proposed API is error-prone due to the weak
    typing that allows mixing steps of different algorithms together.
    For example, users could initialize a sha3_ctx with sha3_256_init()
    and then squeeze an arbitrary amount from it, incorrectly treating
    it as a XOF.  It would be worth considering separating the APIs for
    the different algorithms that are part of SHA-3, similar to what I
    did with SHA-224 and SHA-256.  (They would of course still share
    code internally, just like SHA-2.)

So I asked that to prevent usage errors such as treating a digest as a
XOF, you consider separating the APIs.  There is more than one way to do
that, and I was hoping that you'd consider different ways.  One way is
separate functions and types for all six SHA-3 algorithms.

However, if that is not scaling well, then we could instead just
separate the SHA-3 algorithms into two groups, the digests and the XOFs:

    void sha3_224_init(struct sha3_ctx *ctx);
    void sha3_256_init(struct sha3_ctx *ctx);
    void sha3_384_init(struct sha3_ctx *ctx);
    void sha3_512_init(struct sha3_ctx *ctx);
    void sha3_update(struct sha3_ctx *ctx, const u8 *data, size_t data_len);
    void sha3_final(struct sha3_ctx *ctx, u8 *out);

    void shake128_init(struct shake_ctx *ctx);
    void shake256_init(struct shake_ctx *ctx);
    void shake_update(struct shake_ctx *ctx, const u8 *data, size_t data_len);
    void shake_squeeze(struct shake_ctx *ctx, u8 *out, size_t out_len);
    void shake_clear(struct shake_ctx *ctx);

(With "sha3_ctx" being used for the digests specifically, the internal
context struct would then have to have a third name, like "__sha3_ctx".)

The *_init() functions would store the correct information in the
context so that the other functions would know what to do.  This would
be similar to how blake2s_init() saves the 'outlen' for blake2s_final().

That would be sufficient to prevent misuse errors where steps of
different algorithms are mixed together, right?

Keep in mind that for SHA-2 we have to have completely different code
and underlying state for the 32-bit hashes (SHA-224 and SHA-256) and
64-bit hashes (SHA-384 and SHA-512) anyway.  We also traditionally
haven't kept any information in the SHA-2 context about which SHA-2
algorithm is being executed.  So that led us more down the road of the
separate functions and types for each SHA-2 algorithm.  With SHA-3,
where e.g. the 224, 256, 384, and 512-bit digests all use the same
underlying state, a slightly more unified API might be appropriate.

All I'm really requesting is that we don't create footguns, like the
following that the API in the v2 patch permitted:

    1. sha3_init() + sha3_update()
        [infinite loop]

    2. sha3_256_init() + sha3_update() + sha3_squeeze()
        [not valid, treats SHA3-256 as a XOF]

    3. sha3_update() + sha3_squeeze() + sha3_update() + sha3_squeeze()
        [not valid, as discussed]

(1) is prevented just by not having the internal function sha3_init() as
a public function.

Splitting the context into two types, one for the digests and one for
the XOFs, is sufficient to prevent (2), as long as there's still one
init function per algorithm.  We don't necessarily need six types.

(3) isn't preventable via the type system, but it's detectable by a
run-time check, which you've done by adding a WARN_ON_ONCE() to
sha3_update().

So, I think we'd be in a good position with just the digests and XOFs
separated out into different functions + types.

> This does, however, cause a problem for what I need to do as the ML-DSA
> prehash is dynamically selectable by certificate OID, so I have to add
> SHAKE128/256 support to the crypto shash API too - though hopefully it will
> only require an output of 16 or 32 bytes respectively for the prehash case
> and won't require multiple squeezing.

When there's only a small number of supported algorithms, just doing the
dispatch in the calling code tends to be simpler than using
crypto_shash.  For example, see the recent conversion of fs/verity/ to
use the SHA-2 library API instead of crypto_shash.

- Eric
