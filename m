Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A937727EFE3;
	Wed, 14 Jan 2026 23:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768431873; cv=none; b=DpHvfD/avYXs0K5e3j/axBaPfc5HDK59gfxs1EQ5UMTaEzAY4tC2gnMainUecbeKrVglyWCYbb08tbR+mc3dn3L7QyXYJNnvY/EaTuVSwfuJNUNhGaCmiwCINMGmwMNECuJ3ysu5QFPEdMflosbz5ARAQpiEwDAci4jjvEhBXjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768431873; c=relaxed/simple;
	bh=kCUJZp4XHE6/y1YteTqtaBZVDDjQUd2J1p2pxbOtZM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tpvpr1RI8e1D8zb6vLJSB81QQ0Xe0gfdZWG49q1ATsjM+yNmyCpGtpUrmXdL95/EvCVvs4FfnECR0yB0F6tI/2PMxFUurMvRZMDJDGHdGq6HdWVMmMU0HEzzpb004PHOcUCz5mW6mkNO4t3AMa7sYUd/7R5LYuQC5m3sG9uMF1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fWdO+Gm2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fWdO+Gm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D04C4CEF7;
	Wed, 14 Jan 2026 23:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768431872;
	bh=kCUJZp4XHE6/y1YteTqtaBZVDDjQUd2J1p2pxbOtZM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fWdO+Gm2HeH6F6Bp3WvK9qtGSs30SIXazAfZa3u5ewYDRJRAlCzbnx19pnniDs6k8
	 9a9LUdnWyqtC6kL2YtHEA/X3Jt8aRgr5FCDDreWnFOueOyOXPRNOXMkpRyB5HGDFdf
	 YI6caV3TZp9TPf3BkwIJlS7BNLsbMdrJrbdK8qNguhubdRJNHZJLodhpJ6Su82OkYm
	 JOU76/E0WnQ9LG4OHzNtax6KhCrmWp5pzYHEMZJCi3arrkFlgppN7ncFQLxGXysEPg
	 LImuMzL1MdpS6RmG0fgKMY90IP7KKUyEaBbaDsB0oaAsrosFNNhstSVvlAx1IB/U0S
	 W3pHYw0DbsmDQ==
Date: Wed, 14 Jan 2026 23:04:30 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Harald Freudenberger <freude@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] lib/crypto: tests: Add KUnit tests for AES
Message-ID: <20260114230430.GB1449008@google.com>
References: <20260112192035.10427-35-ebiggers@kernel.org>
 <20260114153138.4896-1-dengler@linux.ibm.com>
 <20260114153138.4896-2-dengler@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114153138.4896-2-dengler@linux.ibm.com>

Thanks for writing this!

On Wed, Jan 14, 2026 at 04:31:38PM +0100, Holger Dengler wrote:
> diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
> index 4970463ea0aa..f34e79093275 100644
> --- a/lib/crypto/tests/Kconfig
> +++ b/lib/crypto/tests/Kconfig
> @@ -118,6 +118,18 @@ config CRYPTO_LIB_SHA3_KUNIT_TEST
>  	  including SHA3-224, SHA3-256, SHA3-384, SHA3-512, SHAKE128 and
>  	  SHAKE256.
>  
> +config CRYPTO_LIB_AES_KUNIT_TEST
> +	tristate "KUnit tests for AES" if !KUNIT_ALL_TESTS
> +	depends on KUNIT
> +	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
> +	select CRYPTO_LIB_BENCHMARK_VISIBLE
> +	select CRYPTO_LIB_AES
> +	help
> +	  KUnit tests for the AES library functions, including known answer
> +	  tests and benchmarks for encrypt/decrypt with all key sizes. The
> +	  test suite does not contain any key generation test, nor any error
> +	  cases.

It should go first in the file, to maintain the existing alphabetical
order.

> diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
> index f4262379f56c..72234e965cdc 100644
> --- a/lib/crypto/tests/Makefile
> +++ b/lib/crypto/tests/Makefile
> @@ -12,3 +12,4 @@ obj-$(CONFIG_CRYPTO_LIB_SHA1_KUNIT_TEST) += sha1_kunit.o
>  obj-$(CONFIG_CRYPTO_LIB_SHA256_KUNIT_TEST) += sha224_kunit.o sha256_kunit.o
>  obj-$(CONFIG_CRYPTO_LIB_SHA512_KUNIT_TEST) += sha384_kunit.o sha512_kunit.o
>  obj-$(CONFIG_CRYPTO_LIB_SHA3_KUNIT_TEST) += sha3_kunit.o
> +obj-$(CONFIG_CRYPTO_LIB_AES_KUNIT_TEST) += aes_kunit.o

Likewise in the Makefile.

> diff --git a/lib/crypto/tests/aes_kunit.c b/lib/crypto/tests/aes_kunit.c
> new file mode 100644
> index 000000000000..057ddc3a1b1f
> --- /dev/null
> +++ b/lib/crypto/tests/aes_kunit.c
> @@ -0,0 +1,115 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <kunit/test.h>
> +
> +#include "aes-testvecs.h"
> +
> +#define AES_KAT(bits, func, from, to)				\
> +static void aes##bits##_kat_##func(struct kunit *test)		\
> +{								\
> +	const u8 *in = AES##bits##_KAT.from;			\
> +	u8 out[AES_BLOCK_SIZE];					\
> +	struct aes_key aes_key;					\
> +								\
> +	if (aes_preparekey(&aes_key, AES##bits##_KAT.key.b,	\
> +			   AES##bits##_KAT.key.len))		\
> +		kunit_skip(test, "no key");			\

Skipping on failure seems wrong.

> +#define KB		(1024)
> +#define MB		(KB * KB)
> +#define NS_PER_SEC	(1000000000ULL)

If you'd like to use named constants for these, note that the kernel
headers already have constants SZ_1K, SZ_1M, and NSEC_PER_SEC.  So these
local definitions aren't needed.

> +
> +#define AES_BENCHMARK(bits)					\
> +static void aes##bits##_benchmark(struct kunit *test)		\
> +{								\
> +	const size_t num_iters = 10000000;			\
> +	const u8 *cipher = AES##bits##_KAT.cipher;		\
> +	const u8 *plain = AES##bits##_KAT.plain;		\
> +	u8 out[AES_BLOCK_SIZE];					\
> +	struct aes_key aes_key;					\
> +	u64 t_enc, t_dec;					\
> +								\
> +	if (!IS_ENABLED(CONFIG_CRYPTO_LIB_BENCHMARK))		\
> +		kunit_skip(test, "not enabled");		\
> +								\
> +	if (aes_preparekey(&aes_key, AES##bits##_KAT.key.b,	\
> +			   AES##bits##_KAT.key.len))		\
> +		kunit_skip(test, "no key");			\
> +								\
> +	/* warm-up enc */					\
> +	for (size_t i = 0; i < 1000; i++)			\
> +		aes_encrypt(&aes_key, out, plain);		\
> +								\
> +	preempt_disable();					\
> +	t_enc = ktime_get_ns();					\
> +								\
> +	for (size_t i = 0; i < num_iters; i++)			\
> +		aes_encrypt(&aes_key, out, plain);		\
> +								\
> +	t_enc = ktime_get_ns() - t_enc;				\
> +	preempt_enable();					\
> +								\
> +	/* warm-up dec */					\
> +	for (size_t i = 0; i < 1000; i++)			\
> +		aes_decrypt(&aes_key, out, cipher);		\
> +								\
> +	preempt_disable();					\
> +	t_dec = ktime_get_ns();					\
> +								\
> +	for (size_t i = 0; i < num_iters; i++)			\
> +		aes_decrypt(&aes_key, out, cipher);		\
> +								\
> +	t_dec = ktime_get_ns() - t_dec;				\
> +	preempt_enable();					\
> +								\
> +	kunit_info(test, "enc (iter. %zu, duration %lluns)",	\
> +		   num_iters, t_enc);				\
> +	kunit_info(test, "enc (len=%zu): %llu MB/s",		\
> +		   (size_t)AES_BLOCK_SIZE,			\
> +		   div64_u64((u64)AES_BLOCK_SIZE * num_iters * NS_PER_SEC, \
> +			     (t_enc ?: 1) * MB));		\
> +								\
> +	kunit_info(test, "dec (iter. %zu, duration %lluns)",	\
> +		   num_iters, t_dec);				\
> +	kunit_info(test, "dec (len=%zu): %llu MB/s",		\
> +		   (size_t)AES_BLOCK_SIZE,			\
> +		   div64_u64((u64)AES_BLOCK_SIZE * num_iters * NS_PER_SEC, \
> +			     (t_dec ?: 1) * MB));		\
> +}
> +
> +AES_KAT(128, encrypt, plain, cipher);
> +AES_KAT(192, encrypt, plain, cipher);
> +AES_KAT(256, encrypt, plain, cipher);
> +AES_KAT(128, decrypt, cipher, plain);
> +AES_KAT(192, decrypt, cipher, plain);
> +AES_KAT(256, decrypt, cipher, plain);
> +AES_BENCHMARK(128);
> +AES_BENCHMARK(192);
> +AES_BENCHMARK(256);

The heavy use of macros doesn't seem that helpful here.  The API is
already unified, where we have aes_preparekey(), aes_encrypt(), and
aes_decrypt() that handle all of AES-128, AES-192, and AES-256.  So we
don't need entirely different code to test each variant.

We could just write helper functions, e.g. aes_test() and
aes_benchmark().  They would take in a pointer to a test vector, and the
individual KUnit case functions would call them.

See lib/crypto/tests/mldsa_kunit.c which does something similar.

- Eric
