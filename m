Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8222765CE;
	Fri, 26 Sep 2025 21:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758921025; cv=none; b=c2gdvce/3Q0bRRDwvfSkjrU11dR7NyQibdziEaAV1oeb2l2nmNYuAA9RzcMUQkF1pZznecfmwHUdeUYXeWaqE741lOHtj6Il6+2z9gYsEzJiNdmIlOLzQUSzexVkXVHp3vuO5THpQ0jtuFgJ8sd4fSpYp/a4ILSDAr3I2Qvxd/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758921025; c=relaxed/simple;
	bh=NbkfRJ3uCCCWJnqxp6JEmBPHMnSmpX7FBo/Rs06M/4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9PHjhm6YAmSIIO+wlzN2ux3Np+RXebRV3w+HrzqJNMZj2oH2gKY34cN7a+BbIwbP7832pLncrZGy+PQMzjdrDuXgfEntUu4mtkq6BPmQrHqKDj6d5G8WZmySpSAqGmCQTSZkaduuBlHGg/NmaqzOTawdOXIqvabjiQxsjpNCjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=itEOIySJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="itEOIySJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DEBC4CEF7;
	Fri, 26 Sep 2025 21:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758921025;
	bh=NbkfRJ3uCCCWJnqxp6JEmBPHMnSmpX7FBo/Rs06M/4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=itEOIySJQ6PLc22iI/TXbenNX0MXPiw0Hc1Oe/Bkg2C7kDzlJDSS6Zr1Q0pGKKjL9
	 X3JzPHEVe6HE133pxSDKhCwq99pDsUFtjbKVQ4x/EMW9kmtKJO16Shx6B8F0QrwUJM
	 56DssVqhEAQ4xlvkUJcZ+jcoTanHmT+Rc2rXkwgmaaO+d+hnoJjhQEDxx5/kZaTdEk
	 N4vSH0wg9iwxMtrY5rRBqQu5zltvFRwyIDblBBnm60yAHVzAWl3X+yvFfoBOcEiF++
	 h6FNgrsW3Fzz/u9/Ey018habqiH+tjUbKaDgdLWpr9W+xh4cp+UB2a3PQ5NtV0R5Hs
	 vOwpBLYJfQIHw==
Date: Fri, 26 Sep 2025 14:09:05 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/8] lib/crypto: Add SHA3-224, SHA3-256, SHA3-384,
 SHA-512, SHAKE128, SHAKE256
Message-ID: <20250926210905.GB2163@sol>
References: <20250926141959.1272455-1-dhowells@redhat.com>
 <20250926141959.1272455-4-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926141959.1272455-4-dhowells@redhat.com>

On Fri, Sep 26, 2025 at 03:19:46PM +0100, David Howells wrote:
> Add SHA3, providing SHA3-224, SHA3-256, SHA3-384, SHA-512, SHAKE128 and

SHA-512 => SHA3-512

> SHAKE256 to lib/crypto.  Also add kunit tests for each of these.
> 
> gen-hash-testvecs.py is also modified to be able to generate SHAKE hashes
> because Python's hashlib requires the output digest size supplying for
> those two algorithms as they produce arbitrary length digests.

Now that the tests are in a separate patch, the above needs to be
updated.  Either remove it, or change it to say that the tests come in a
later patch.

> diff --git a/Documentation/crypto/sha3.rst b/Documentation/crypto/sha3.rst
> new file mode 100644
> index 000000000000..ae4902895882
> --- /dev/null
> +++ b/Documentation/crypto/sha3.rst
> @@ -0,0 +1,245 @@
> +.. SPDX-License-Identifier: GPL-2.0-or-later
> +
> +==========================
> +SHA-3 Algorithm collection
> +==========================
> +
> +.. Contents:
> +
> +  - Overview
> +  - Basic API
> +    - Extendable-Output Functions
> +  - Convenience API
> +  - Internal API
> +    - Testing
> +  - References
> +  - API Function Reference
> +
> +
> +Overview
> +========
> +
> +The SHA-3 algorithm base, as specified in NIST FIPS-202[1], provides a number
> +of specific algorithms all based on the same engine (Keccak).  The differences
> +between them are: the block size (how much of the common state buffer gets
> +updated with new data between invocations of the Keccak mixing function), what
> +termination markers get mixed in upon finalisation and how much data is
> +extracted at the end.  The Keccak engine is designed such that arbitrary
> +amounts of output can be obtained for certain algorithms.

Calling Keccak an "engine" and a "mixing function" is nonstandard
terminology.  It should be called a sponge function, or a permutation
when referring specifically to the permutation part (Keccak-f).

"Block size" is also not what the SHA-3 spec or publications about
Keccak use.  They call it the "rate".  Though, "block size" is widely
used in the code for other hash functions already.  So "block size" is
probably fine, but we should make sure to explicitly document that it's
also known as the rate.

> +Caution: The algorithm(s) may be accelerated with optimised assembly and, as
> +such, may have to sync with or modify the FPU or CPU Vector Unit state.  How
> +this is done is arch specific and might involve waiting or locking.

As I've mentioned, the functions should be callable in any context.  See
how the existing FPU/vector/SIMD accelerated functions in lib/crypto/
and lib/crc/ achieve this.

> +If selectable algorithms are required then the crypto_hash API must be used
> +instead as this binds each algorithm to a specific C type.

Users can choose to dispatch to different library functions themselves.
There's no requirement to use crypto_hash (or rather crypto_shash or
crypto_ahash, since "crypto_hash" doesn't exist).  They could, but it's
not required.

> +Note that these are relatively large structures, so may not be suitable for
> +placing on the stack.

Not really.  It's 208 bytes, which is a lot less than the widely-used
SHASH_DESC_ON_STACK() which uses almost 400.  And the crypto functions
tend to be called near the leaves of the call tree anyway.

Considering that as well as how much stack allocation simplifies and
optimizes the calling code, warning against it seems a bit misplaced.

> +Data is then added with the appropriate update function, again one per
> +algorithm::
> +
> +	void sha3_224_update(struct sha3_224_ctx *ctx,
> +			     const u8 *data, unsigned int len);
> +	void sha3_256_update(struct sha3_256_ctx *ctx,
> +			     const u8 *data, unsigned int len);
> +	void sha3_384_update(struct sha3_384_ctx *ctx,
> +			     const u8 *data, unsigned int len);
> +	void sha3_512_update(struct sha3_512_ctx *ctx,
> +			     const u8 *data, unsigned int len);
> +	void shake128_update(struct shake128_ctx *ctx,
> +			     const u8 *data, unsigned int len);
> +	void shake256_update(struct shake256_ctx *ctx,
> +			     const u8 *data, unsigned int len);

Lengths should be size_t.

> +	unsigned int sha3_224_final(struct sha3_224_ctx *ctx,
> +				    u8 out[SHA3_224_DIGEST_SIZE]);
> +	unsigned int sha3_256_final(struct sha3_256_ctx *ctx,
> +				    u8 out[SHA3_256_DIGEST_SIZE]);
> +	unsigned int sha3_384_final(struct sha3_384_ctx *ctx,
> +				    u8 out[SHA3_384_DIGEST_SIZE]);
> +	unsigned int sha3_512_final(struct sha3_512_ctx *ctx,
> +				    u8 out[SHA3_512_DIGEST_SIZE]);

The return value should be void.

In fact, it is void in the actual code.  This demonstrates the problem
with documenting functions in a separate Documentation/ file instead of
with standard kerneldoc right next to the functions themselves...

> +Extendable-Output Functions
> +---------------------------
> +
> +For XOFs, once the data has been added to a context, a variable amount of data
> +may be extracted.  This can be done by calling the appropriate squeeze
> +function::
> +
> +	void shake128_squeeze(struct shake128_ctx *ctx, u8 *out, size_t out_len);
> +	void shake256_squeeze(struct shake256_ctx *ctx, u8 *out, size_t out_len);
> +
> +and telling it how much data should be extracted.  The squeeze function may be
> +called multiple times but it will only finalise the context on the first
> +invocation.

The word "finalise" above should be replaced with something clearer.
Normally, in the hash function APIs, "finalizing the context" means
calling the *_final() function, which produces the digest and zeroizes
the context.  That's not what is meant here, though.

> +Internal API
> +============
> +
> +There is a common internal API underlying all of this that may be used to build
> +further algorithms or APIs as the engine in the same in all cases.  The
> +algorithm APIs all wrap the common context structure::
> +
> +	struct sha3_ctx {
> +		struct sha3_state	state;
> +		u8			block_size;
> +		u8			padding;
> +		u8			absorb_offset;
> +		u8			squeeze_offset;
> +		bool			end_marked;
> +	};
> +
> +	struct sha3_state {
> +		u64			st[SHA3_STATE_SIZE / 8];
> +	};
> +
> +The fields are as follows:

This part especially, where it documents implementation details
including individual fields, really feels like it should go in the code
itself.  Then it will be easier to find and keep in sync with the code.
Interestingly, it's *already* out of sync with the code...

> +/* SHAKE128 and SHAKE256 actually have variable output size, but this
> + * is needed for the kunit tests.
> + */
> +#define SHAKE128_DEFAULT_SIZE	(128 / 8)
> +#define SHAKE128_BLOCK_SIZE	(200 - 2 * SHAKE128_DEFAULT_SIZE)
> +#define SHAKE256_DEFAULT_SIZE	(256 / 8)
> +#define SHAKE256_BLOCK_SIZE	(200 - 2 * SHAKE256_DEFAULT_SIZE)

Test-only definitions should go in the tests, not the public header.

> +/**
> + * sha3_clear() - Explicitly clear the entire context
> + * @ctx: the context to clear
> + *
> + * Explicitly clear the entire context, including the type parameters; after
> + * this, the context must be fully initialised again.
> + *
> + * Return: None.
> + *
> + * Context: Any context.
> + */

"Return: None." doesn't add anything useful when the function returns
void.  I recommend omitting that, as is usually done.

> +/**
> + * sha3_224_init() - Set a SHA3 context for SHA3-224
> + * @ctx: the context to initialise
> + *
> + * Initialise a SHA3 context for the production of a SHA3-224 digest of a
> + * message.

Would you mind doing "initialise" => "initialize"?  The z spelling is
about 10x more common in the kernel, and it's what include/crypto/ uses.

> +static int __init sha3_mod_init(void)
> +{
> +#define out_len 200
> +	u8 out[8 + out_len + 8] = {};
> +
> +#ifdef sha3_mod_init_arch
> +	sha3_mod_init_arch();
> +#endif
> +
> +	BUILD_BUG_ON(sizeof(out) != sizeof(sha3_sample_shake256_200));
> +
> +	shake256(sha3_sample, sizeof(sha3_sample) - 1, out + 8, out_len);
> +
> +	if (memcmp(out, sha3_sample_shake256_200,
> +		   sizeof(sha3_sample_shake256_200)) != 0) {
> +		pr_err("SHAKE256(200) failed\n");
> +		for (int i = 0; i < out_len;) {
> +			int part = min(out_len - i, 32);
> +
> +			pr_err("%*phN\n", part, out + i);
> +			i += part;
> +		}
> +		return -EBADMSG;
> +	}
> +	return 0;
> +}
> +subsys_initcall(sha3_mod_init);
> +
> +#ifdef sha3_mod_init_arch
> +static void __exit sha3_mod_exit(void)
> +{
> +}
> +module_exit(sha3_mod_exit);
> +#endif

sha3_mod_exit() should be defined unconditionally, given that
sha3_mod_init() is defined unconditionally.  Otherwise, it would be
possible for this code to be built as a loadable module that can't be
unloaded, which is not desirable.

- Eric
