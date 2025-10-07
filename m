Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FD6DDD2;
	Tue,  7 Oct 2025 03:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759806735; cv=none; b=vEA+Z6b9Q/CMbO1YGi9mYHZroa3haDvF5p0tcaLW3QUxq05L/q0uUHby89W5bKUFjn6PKhp+zBIod+VezsKheG2khjgGkg2xPvAUOm6f3XwUHK9tKz74P1RKnMFhBW1y6w46LvdiAnbiu0TyYXge4WCHxDABj03GwBL8lGFp7mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759806735; c=relaxed/simple;
	bh=sPtwSwYIm+kFv8VeEOMEc0+lx1FkEwpscYqDlyfIVUw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SyS1IHWYuNO/jZ6ByIXnwjyITuGoSIngqoyKeDMqIhWMS7SLfRye3fUQlrpFk20/EsjFjvWvm0hZJE6aPxj5klJQe25iNLkSwPRhXrkQ6wNdSCHdkYkQMU1TIp3nJBlZbLboBAiOyswvrXZHdvQNwkVLcYs9mmrmmXal1ssD1j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=UUKwviQo; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="UUKwviQo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1759806226; bh=sPtwSwYIm+kFv8VeEOMEc0+lx1FkEwpscYqDlyfIVUw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UUKwviQoZBfARwaRNiqGt5aSMO9OVST+0KTC7NVYW9f4wsQRugqHZVmK+gx5g8Mpi
	 KDpUQXpPQxhQhGKuCmbocENRHTwhXSIppdiCazRb4kfyxDwrcqwLSMSrsNe3KmmaWc
	 NfIu0+3ZxlDsJc4oXjLi6zpQiRHebuZ1Kse8eBGyM8+lc5SI7uitafNfAU/n/OmwKh
	 UqgdhuCD53cEeJnwcMLuZ6hrzu9TyEvmc6QwB255MD9vjG2u6YlSKyPWY1tdPA2CTt
	 wgbSXtSOvBSzAJa+XjZ6+oudVwPYl0ir1fsIURCJ0adt4/18Hc0Mw6qRGdm5JNm8ur
	 msvMPbB6JP6Yg==
Message-ID: <38ca063d-521a-4fc4-8398-5e77625533c4@jvdsn.com>
Date: Mon, 6 Oct 2025 22:03:44 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] lib/crypto: Add FIPS pre-operational self-test for SHA
 algorithms
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Vegard Nossum <vegard.nossum@oracle.com>, David Howells
 <dhowells@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>
References: <20251006172612.75240-1-ebiggers@kernel.org>
From: Joachim Vandersmissen <git@jvdsn.com>
Content-Language: en-US
In-Reply-To: <20251006172612.75240-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Eric,

It's a very minor change but I suggest not using "pre-operational 
self-test". That term specifically refers to a different type of 
self-test in FIPS 140-3 and it could lead to some confusion here. 
"cryptographic algorithm self-test" may be better (if you want to be 
formal), or just "self-test" or "known-answer test".

As for the initialization discussion, it is also allowed to defer the 
self-test until before the first use of the algorithm. However that 
would mean checking that the self-test has ran in the public APIs, which 
is probably more complicated and maybe more costly at runtime.

Kind regards,
Joachim

On 10/6/25 12:26 PM, Eric Biggers wrote:
> Add FIPS pre-operational self-tests for all SHA-1 and SHA-2 algorithms.
> Following the "Implementation Guidance for FIPS 140-3" document, to
> achieve this it's sufficient to just test a single test vector for each
> of HMAC-SHA1, HMAC-SHA256, and HMAC-SHA512.
>
> Link: https://lore.kernel.org/linux-crypto/20250917184856.GA2560@quark/
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> Since there seemed to be more interest in complaining that these are
> missing than actually writing a patch, I decided to just do it.
>
>   lib/crypto/fips.h                   | 38 +++++++++++++++++++++++++++++
>   lib/crypto/sha1.c                   | 19 ++++++++++++++-
>   lib/crypto/sha256.c                 | 19 ++++++++++++++-
>   lib/crypto/sha512.c                 | 19 ++++++++++++++-
>   scripts/crypto/gen-fips-testvecs.py | 33 +++++++++++++++++++++++++
>   5 files changed, 125 insertions(+), 3 deletions(-)
>   create mode 100644 lib/crypto/fips.h
>   create mode 100755 scripts/crypto/gen-fips-testvecs.py
>
> diff --git a/lib/crypto/fips.h b/lib/crypto/fips.h
> new file mode 100644
> index 0000000000000..78a1bdd33a151
> --- /dev/null
> +++ b/lib/crypto/fips.h
> @@ -0,0 +1,38 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/* This file was generated by: gen-fips-testvecs.py */
> +
> +#include <linux/fips.h>
> +
> +static const u8 fips_test_data[] __initconst __maybe_unused = {
> +	0x66, 0x69, 0x70, 0x73, 0x20, 0x74, 0x65, 0x73,
> +	0x74, 0x20, 0x64, 0x61, 0x74, 0x61, 0x00, 0x00,
> +};
> +
> +static const u8 fips_test_key[] __initconst __maybe_unused = {
> +	0x66, 0x69, 0x70, 0x73, 0x20, 0x74, 0x65, 0x73,
> +	0x74, 0x20, 0x6b, 0x65, 0x79, 0x00, 0x00, 0x00,
> +};
> +
> +static const u8 fips_test_hmac_sha1_value[] __initconst __maybe_unused = {
> +	0x29, 0xa9, 0x88, 0xb8, 0x5c, 0xb4, 0xaf, 0x4b,
> +	0x97, 0x2a, 0xee, 0x87, 0x5b, 0x0a, 0x02, 0x55,
> +	0x99, 0xbf, 0x86, 0x78,
> +};
> +
> +static const u8 fips_test_hmac_sha256_value[] __initconst __maybe_unused = {
> +	0x59, 0x25, 0x85, 0xcc, 0x40, 0xe9, 0x64, 0x2f,
> +	0xe9, 0xbf, 0x82, 0xb7, 0xd3, 0x15, 0x3d, 0x43,
> +	0x22, 0x0b, 0x4c, 0x00, 0x90, 0x14, 0x25, 0xcf,
> +	0x9e, 0x13, 0x2b, 0xc2, 0x30, 0xe6, 0xe8, 0x93,
> +};
> +
> +static const u8 fips_test_hmac_sha512_value[] __initconst __maybe_unused = {
> +	0x6b, 0xea, 0x5d, 0x27, 0x49, 0x5b, 0x3f, 0xea,
> +	0xde, 0x2d, 0xfa, 0x32, 0x75, 0xdb, 0x77, 0xc8,
> +	0x26, 0xe9, 0x4e, 0x95, 0x4d, 0xad, 0x88, 0x02,
> +	0x87, 0xf9, 0x52, 0x0a, 0xd1, 0x92, 0x80, 0x1d,
> +	0x92, 0x7e, 0x3c, 0xbd, 0xb1, 0x3c, 0x49, 0x98,
> +	0x44, 0x9c, 0x8f, 0xee, 0x3f, 0x02, 0x71, 0x51,
> +	0x57, 0x0b, 0x15, 0x38, 0x95, 0xd8, 0xa3, 0x81,
> +	0xba, 0xb3, 0x15, 0x37, 0x5c, 0x6d, 0x57, 0x2b,
> +};
> diff --git a/lib/crypto/sha1.c b/lib/crypto/sha1.c
> index 5904e4ae85d24..001059cb0fce4 100644
> --- a/lib/crypto/sha1.c
> +++ b/lib/crypto/sha1.c
> @@ -10,10 +10,11 @@
>   #include <linux/kernel.h>
>   #include <linux/module.h>
>   #include <linux/string.h>
>   #include <linux/unaligned.h>
>   #include <linux/wordpart.h>
> +#include "fips.h"
>   
>   static const struct sha1_block_state sha1_iv = {
>   	.h = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
>   };
>   
> @@ -328,14 +329,30 @@ void hmac_sha1_usingrawkey(const u8 *raw_key, size_t raw_key_len,
>   	hmac_sha1_update(&ctx, data, data_len);
>   	hmac_sha1_final(&ctx, out);
>   }
>   EXPORT_SYMBOL_GPL(hmac_sha1_usingrawkey);
>   
> -#ifdef sha1_mod_init_arch
> +#if defined(sha1_mod_init_arch) || defined(CONFIG_CRYPTO_FIPS)
>   static int __init sha1_mod_init(void)
>   {
> +#ifdef sha1_mod_init_arch
>   	sha1_mod_init_arch();
> +#endif
> +	if (fips_enabled) {
> +		/*
> +		 * FIPS pre-operational self-test.  As per the FIPS
> +		 * Implementation Guidance, testing HMAC-SHA1 satisfies the test
> +		 * requirement for SHA-1 too.
> +		 */
> +		u8 mac[SHA1_DIGEST_SIZE];
> +
> +		hmac_sha1_usingrawkey(fips_test_key, sizeof(fips_test_key),
> +				      fips_test_data, sizeof(fips_test_data),
> +				      mac);
> +		if (memcmp(fips_test_hmac_sha1_value, mac, sizeof(mac)) != 0)
> +			panic("sha1: FIPS pre-operational self-test failed\n");
> +	}
>   	return 0;
>   }
>   subsys_initcall(sha1_mod_init);
>   
>   static void __exit sha1_mod_exit(void)
> diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
> index 8fa15165d23e8..6b3cf105147ff 100644
> --- a/lib/crypto/sha256.c
> +++ b/lib/crypto/sha256.c
> @@ -15,10 +15,11 @@
>   #include <linux/kernel.h>
>   #include <linux/module.h>
>   #include <linux/string.h>
>   #include <linux/unaligned.h>
>   #include <linux/wordpart.h>
> +#include "fips.h"
>   
>   static const struct sha256_block_state sha224_iv = {
>   	.h = {
>   		SHA224_H0, SHA224_H1, SHA224_H2, SHA224_H3,
>   		SHA224_H4, SHA224_H5, SHA224_H6, SHA224_H7,
> @@ -416,14 +417,30 @@ void hmac_sha256_usingrawkey(const u8 *raw_key, size_t raw_key_len,
>   	hmac_sha256_final(&ctx, out);
>   }
>   EXPORT_SYMBOL_GPL(hmac_sha256_usingrawkey);
>   #endif /* !__DISABLE_EXPORTS */
>   
> -#ifdef sha256_mod_init_arch
> +#if defined(sha256_mod_init_arch) || defined(CONFIG_CRYPTO_FIPS)
>   static int __init sha256_mod_init(void)
>   {
> +#ifdef sha256_mod_init_arch
>   	sha256_mod_init_arch();
> +#endif
> +	if (fips_enabled) {
> +		/*
> +		 * FIPS pre-operational self-test.  As per the FIPS
> +		 * Implementation Guidance, testing HMAC-SHA256 satisfies the
> +		 * test requirement for SHA-224, SHA-256, and HMAC-SHA224 too.
> +		 */
> +		u8 mac[SHA256_DIGEST_SIZE];
> +
> +		hmac_sha256_usingrawkey(fips_test_key, sizeof(fips_test_key),
> +					fips_test_data, sizeof(fips_test_data),
> +					mac);
> +		if (memcmp(fips_test_hmac_sha256_value, mac, sizeof(mac)) != 0)
> +			panic("sha256: FIPS pre-operational self-test failed\n");
> +	}
>   	return 0;
>   }
>   subsys_initcall(sha256_mod_init);
>   
>   static void __exit sha256_mod_exit(void)
> diff --git a/lib/crypto/sha512.c b/lib/crypto/sha512.c
> index d8062188be98a..65447083c0456 100644
> --- a/lib/crypto/sha512.c
> +++ b/lib/crypto/sha512.c
> @@ -15,10 +15,11 @@
>   #include <linux/module.h>
>   #include <linux/overflow.h>
>   #include <linux/string.h>
>   #include <linux/unaligned.h>
>   #include <linux/wordpart.h>
> +#include "fips.h"
>   
>   static const struct sha512_block_state sha384_iv = {
>   	.h = {
>   		SHA384_H0, SHA384_H1, SHA384_H2, SHA384_H3,
>   		SHA384_H4, SHA384_H5, SHA384_H6, SHA384_H7,
> @@ -403,14 +404,30 @@ void hmac_sha512_usingrawkey(const u8 *raw_key, size_t raw_key_len,
>   	hmac_sha512_update(&ctx, data, data_len);
>   	hmac_sha512_final(&ctx, out);
>   }
>   EXPORT_SYMBOL_GPL(hmac_sha512_usingrawkey);
>   
> -#ifdef sha512_mod_init_arch
> +#if defined(sha512_mod_init_arch) || defined(CONFIG_CRYPTO_FIPS)
>   static int __init sha512_mod_init(void)
>   {
> +#ifdef sha512_mod_init_arch
>   	sha512_mod_init_arch();
> +#endif
> +	if (fips_enabled) {
> +		/*
> +		 * FIPS pre-operational self-test.  As per the FIPS
> +		 * Implementation Guidance, testing HMAC-SHA512 satisfies the
> +		 * test requirement for SHA-384, SHA-512, and HMAC-SHA384 too.
> +		 */
> +		u8 mac[SHA512_DIGEST_SIZE];
> +
> +		hmac_sha512_usingrawkey(fips_test_key, sizeof(fips_test_key),
> +					fips_test_data, sizeof(fips_test_data),
> +					mac);
> +		if (memcmp(fips_test_hmac_sha512_value, mac, sizeof(mac)) != 0)
> +			panic("sha512: FIPS pre-operational self-test failed\n");
> +	}
>   	return 0;
>   }
>   subsys_initcall(sha512_mod_init);
>   
>   static void __exit sha512_mod_exit(void)
> diff --git a/scripts/crypto/gen-fips-testvecs.py b/scripts/crypto/gen-fips-testvecs.py
> new file mode 100755
> index 0000000000000..26e12397bceb2
> --- /dev/null
> +++ b/scripts/crypto/gen-fips-testvecs.py
> @@ -0,0 +1,33 @@
> +#!/usr/bin/env python3
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +#
> +# Script that generates lib/crypto/fips.h
> +#
> +# Copyright 2025 Google LLC
> +
> +import hmac
> +
> +fips_test_data = b"fips test data\0\0"
> +fips_test_key = b"fips test key\0\0\0"
> +
> +def print_static_u8_array_definition(name, value):
> +    print('')
> +    print(f'static const u8 {name}[] __initconst __maybe_unused = {{')
> +    for i in range(0, len(value), 8):
> +        line = '\t' + ''.join(f'0x{b:02x}, ' for b in value[i:i+8])
> +        print(f'{line.rstrip()}')
> +    print('};')
> +
> +print('/* SPDX-License-Identifier: GPL-2.0-or-later */')
> +print(f'/* This file was generated by: gen-fips-testvecs.py */')
> +print()
> +print('#include <linux/fips.h>')
> +
> +print_static_u8_array_definition("fips_test_data", fips_test_data)
> +print_static_u8_array_definition("fips_test_key", fips_test_key)
> +
> +for alg in 'sha1', 'sha256', 'sha512':
> +    ctx = hmac.new(fips_test_key, digestmod=alg)
> +    ctx.update(fips_test_data)
> +    print_static_u8_array_definition(f'fips_test_hmac_{alg}_value', ctx.digest())
> +
>
> base-commit: e5f0a698b34ed76002dc5cff3804a61c80233a7a
