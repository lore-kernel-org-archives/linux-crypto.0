Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45F326D4F7;
	Wed,  1 Oct 2025 16:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759334758; cv=none; b=N8Zk4iy02Ob/IjFauSFBi6fmPyEcnXpoiPvMD+4FsHspiFF1zxI93EkLm+QGReBoh3tgPYtztqvDJTKFjA5E1T+26vL1qJ9bdZE1hhcgHUSwHf+BYMZKDvi4y0n9MOBb0ElU3e/hJycaY1iHOdk0wFA3vZK5j2M1GKGB8HEYlD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759334758; c=relaxed/simple;
	bh=8YEuuHbQcB0ssAKQlRVDg0rxT1MUBfh3vVk/ixUFwL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=on1q9WjFeiIY4W66dlxyH6ezpGWwalg9Qgs9SSoCy2TPkmpVktdPBymWguXbniQywSMoCOGI5Rlm9umbhcc9mW3mDFrgLpwf13Huwsg5v94XgjyLFgZEvwpaLNQ+jgPS92In4IXOtjXodyBmT4uhsbKGB1RgSFmbDYzSuy/fp2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HNXxHjaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HNXxHjaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8540CC4CEF1;
	Wed,  1 Oct 2025 16:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759334757;
	bh=8YEuuHbQcB0ssAKQlRVDg0rxT1MUBfh3vVk/ixUFwL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HNXxHjaO2WbwSqpkdb3qAyu7qY0EFDi/4NueZ5cklrzoa0o0xPtGf2OtzwSlTEh11
	 RgRe/N7b9ppLzRa9CL1tUcqRirYKLf1tD91p+/xs48/eLfTlDwSlVuBi9XJjT11TwD
	 6PYUtWqsCtZWwxql3rS5OqDRRGYea4ESLcoKkKrAm5pYsSh6D/341gWS1eubSW3Eoy
	 xTI2T1BJ6w0ljn0ZpWP6V1vPgdloe/EIHYLUqJ68Dg7BBfaQIyYOiUwb6dlq649TYx
	 ccDO/Sn1FxI3yZROTHMgN8OllNrIcHyEhMQ6L/z5Y5CscLNBm5yrcNHOrClESZgn7N
	 D0sl7fI/RvbbA==
Date: Wed, 1 Oct 2025 09:04:35 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/8] lib/crypto: Add SHA3 kunit tests
Message-ID: <20251001160435.GC1592@sol>
References: <20250926141959.1272455-1-dhowells@redhat.com>
 <20250926141959.1272455-6-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926141959.1272455-6-dhowells@redhat.com>

On Fri, Sep 26, 2025 at 03:19:48PM +0100, David Howells wrote:
> +config CRYPTO_LIB_SHA3_KUNIT_TEST
> +	tristate "KUnit tests for SHA-3" if !KUNIT_ALL_TESTS
> +	depends on KUNIT
> +	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
> +	select CRYPTO_LIB_BENCHMARK_VISIBLE
> +	select CRYPTO_LIB_SHA3
> +	help
> +	  KUnit tests for the SHA3 cryptographic hash functions, including
> +	  SHA3-224, SHA3-256, SHA3-386, SHA3-512, SHAKE128 and SHAKE256.  Note

SHA3-386 => SHA3-384

> +	  that whilst the SHAKE* hash functions can support arbitrary-length
> +	  digests, these tests only check the nominal digest sizes for now.

Arbitrary-length output support needs to be tested.  It looks like it is
now, and you just forgot to update this help text?

> +static const u8 test_sha3_sample[] =
> +	"The quick red fox jumped over the lazy brown dog!\n"
> +	"The quick red fox jumped over the lazy brown dog!\n"
> +	"The quick red fox jumped over the lazy brown dog!\n"
> +	"The quick red fox jumped over the lazy brown dog!\n";
> +
> +static const u8 test_sha3_224[8 + SHA3_224_DIGEST_SIZE + 8] = {
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* Write-before guard */
> +	0xd6, 0xe8, 0xd8, 0x80, 0xfa, 0x42, 0x80, 0x70,
> +	0x7e, 0x7f, 0xd7, 0xd2, 0xd7, 0x7a, 0x35, 0x65,
> +	0xf0, 0x0b, 0x4f, 0x9f, 0x2a, 0x33, 0xca, 0x0a,
> +	0xef, 0xa6, 0x4c, 0xb8,
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* Write-after guard */
> +};
> +
> +static const u8 test_sha3_256[8 + SHA3_256_DIGEST_SIZE + 8] = {
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* Write-before guard */
> +	0xdb, 0x3b, 0xb0, 0xb8, 0x8d, 0x15, 0x78, 0xe5,
> +	0x78, 0x76, 0x8e, 0x39, 0x7e, 0x89, 0x86, 0xb9,
> +	0x14, 0x3a, 0x1e, 0xe7, 0x96, 0x7c, 0xf3, 0x25,
> +	0x70, 0xbd, 0xc3, 0xa9, 0xae, 0x63, 0x71, 0x1d,
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* Write-after guard */
> +};
> +
> +static const u8 test_sha3_384[8 + SHA3_384_DIGEST_SIZE + 8] = {
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* Write-before guard */
> +	0x2d, 0x4b, 0x29, 0x85, 0x19, 0x94, 0xaa, 0x31,
> +	0x9b, 0x04, 0x9d, 0x6e, 0x79, 0x66, 0xc7, 0x56,
> +	0x8a, 0x2e, 0x99, 0x84, 0x06, 0xcf, 0x10, 0x2d,
> +	0xec, 0xf0, 0x03, 0x04, 0x1f, 0xd5, 0x99, 0x63,
> +	0x2f, 0xc3, 0x2b, 0x0d, 0xd9, 0x45, 0xf7, 0xbb,
> +	0x0a, 0xc3, 0x46, 0xab, 0xfe, 0x4d, 0x94, 0xc2,
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* Write-after guard */
> +};
> +
> +static const u8 test_sha3_512[8 + SHA3_512_DIGEST_SIZE + 8] = {
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* Write-before guard */
> +	0xdd, 0x71, 0x3b, 0x44, 0xb6, 0x6c, 0xd7, 0x78,
> +	0xe7, 0x93, 0xa1, 0x4c, 0xd7, 0x24, 0x16, 0xf1,
> +	0xfd, 0xa2, 0x82, 0x4e, 0xed, 0x59, 0xe9, 0x83,
> +	0x15, 0x38, 0x89, 0x7d, 0x39, 0x17, 0x0c, 0xb2,
> +	0xcf, 0x12, 0x80, 0x78, 0xa1, 0x78, 0x41, 0xeb,
> +	0xed, 0x21, 0x4c, 0xa4, 0x4a, 0x5f, 0x30, 0x1a,
> +	0x70, 0x98, 0x4f, 0x14, 0xa2, 0xd1, 0x64, 0x1b,
> +	0xc2, 0x0a, 0xff, 0x3b, 0xe8, 0x26, 0x41, 0x8f,
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* Write-after guard */
> +};
> +
> +static const u8 test_shake128[8 + SHAKE128_DEFAULT_SIZE + 8] = {
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* Write-before guard */
> +	0x41, 0xd6, 0xb8, 0x9c, 0xf8, 0xe8, 0x54, 0xf2,
> +	0x5c, 0xde, 0x51, 0x12, 0xaf, 0x9e, 0x0d, 0x91,
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* Write-after guard */
> +};
> +
> +static const u8 test_shake256[8 + SHAKE256_DEFAULT_SIZE + 8] = {
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* Write-before guard */
> +	0xab, 0x06, 0xd4, 0xf9, 0x8b, 0xfd, 0xb2, 0xc4,
> +	0xfe, 0xf1, 0xcc, 0xe2, 0x40, 0x45, 0xdd, 0x15,
> +	0xcb, 0xdd, 0x02, 0x8d, 0xb7, 0x9f, 0x1e, 0x67,
> +	0xd6, 0x7f, 0x98, 0x5e, 0x1b, 0x19, 0xf8, 0x01,
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* Write-after guard */
> +};

If these expected outputs are from an external source, then that source
needs to be documented.  If they aren't, then the way in which they were
generated needs to be easily reproducible and documented, e.g. by adding
support for generating them to gen-hash-testvecs.py.

> +MODULE_DESCRIPTION("KUnit tests and benchmark for SHA3-256");

SHA3-256 => SHA3

> diff --git a/lib/crypto/tests/sha3_testvecs.h b/lib/crypto/tests/sha3_testvecs.h
> new file mode 100644
> index 000000000000..9c4c403cc6e0
> --- /dev/null
> +++ b/lib/crypto/tests/sha3_testvecs.h
> @@ -0,0 +1,231 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/* This file was generated by: ./scripts/crypto/gen-hash-testvecs.py sha3-256 */

If that's the case, then running "./scripts/crypto/gen-hash-testvecs.py
sha3-256 > lib/crypto/tests/sha3_testvecs.h" should reproduce this file
exactly.  But it doesn't, so you must have manually edited this file.

It should match exactly.  That can be done by tweaking
gen-hash-testvecs.py to use the correct *_DIGEST_SIZE constant and
skipping the HMAC test if sha3-256 is requested.

> diff --git a/scripts/crypto/gen-hash-testvecs.py b/scripts/crypto/gen-hash-testvecs.py
> index fc063f2ee95f..a5b0abd8dabe 100755
> --- a/scripts/crypto/gen-hash-testvecs.py
> +++ b/scripts/crypto/gen-hash-testvecs.py
> @@ -61,6 +61,10 @@ def hash_update(ctx, data):
>      ctx.update(data)
>  
>  def hash_final(ctx):
> +    if ctx.name == "shake_128":
> +        return ctx.digest(16)
> +    if ctx.name == "shake_256":
> +        return ctx.digest(32)

This addition is unnecessary.

>      return ctx.digest()
>  
>  def compute_hash(alg, data):
> @@ -122,7 +126,7 @@ def gen_hmac_testvecs(alg):
>          ctx.update(mac)
>      print_static_u8_array_definition(
>              f'hmac_testvec_consolidated[{alg.upper()}_DIGEST_SIZE]',
> -            ctx.digest())
> +            hash_final(ctx))
>  
>  BLAKE2S_KEY_SIZE = 32
>  BLAKE2S_HASH_SIZE = 32
> @@ -164,5 +168,5 @@ if alg == 'blake2s':
>      gen_additional_blake2s_testvecs()
>  elif alg == 'poly1305':
>      gen_additional_poly1305_testvecs()
> -else:
> +elif alg != 'shake128' and alg != 'shake256':
>      gen_hmac_testvecs(alg)

Likewise.  Except it really needs to be 'sha3-256', as I mentioned.

- Eric
