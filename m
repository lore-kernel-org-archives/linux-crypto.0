Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BCB212560
	for <linux-crypto@vger.kernel.org>; Mon,  6 Oct 2025 23:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759794820; cv=none; b=sM1cGZe2+ZscnaM+SyITixn/bF6KswZWHABDeuXddJ2Op6FEY135R9/g/3/SuLGHftsqbxvU5/ddEkcfWOvatyjv+BFIuAIlD+TNfA/pSN9Kaa0Lv8b8yqxQNYOYRrlZ5Sm9EBMw+VR74PqhsreiGuCw/XoFfGAb4PBAMMhDAbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759794820; c=relaxed/simple;
	bh=jVuo3THWV4QkJczNyiUkPMEJmDXaEIHUc+LF6qNuHUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J6BorBc49VhUXdsWEOgYKiP0z1cL+6g0NZi17GHGR/nEzuuTzbSaDvxqW5lPnPaxH21vQxaIDwiZYF4ekhgO+qiErzOK8A+iNYezcaqPuV0GW2eMeW4v78MYf285hiU4iYJSzVUmbt7k2tLQNoHR3//+DOGWCdar4VDyhQeCXGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JTidlyak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JTidlyak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B94FC4AF09
	for <linux-crypto@vger.kernel.org>; Mon,  6 Oct 2025 23:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759794819;
	bh=jVuo3THWV4QkJczNyiUkPMEJmDXaEIHUc+LF6qNuHUk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=JTidlyaksUm+W+sbDJ/kdiaFfk4ZyjCQy/4dNGvFlaOxCmwdqKVVWSkdWuIYxi8Ks
	 hN+WtrnI1IQZOipxQkOItBV4RCN1mN3G029ySrGc/UsJp4qZpWgkFA/X7ohsd9qHjp
	 VPGPm5Kjo2crhTJ9ELu9r91NMbXptK6zTJuX8cQtYGnrqsEu8wVZngs6FO11xR5OoC
	 x2fhXfHEfJX3txv/FAcnqn1oLX2++3gSLKo5BHGAxtKsfU39VuoMwbE+d50T5Zg/Ek
	 jErdgPQtw09pc4vGGw4d7cht2bgsXNwO730eWsaayypO7QJ/K9C7ncEKzofso3QlHX
	 KfWU5p4AiLGrQ==
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-57b8fc6097fso7476257e87.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Oct 2025 16:53:39 -0700 (PDT)
X-Gm-Message-State: AOJu0Ywre9Z+7M+P2PM9x/h5w1vY7mzxGF8G5lS8Opv/srWYULj+wEm4
	ytJXqBjU1CZ3q2X1RjYkhCYp6uDCW+3M6dYQ7HHIRZIL5u5GlVEpnvjVwquK7sVvI4Di1rKYWi0
	Vj9p686PYuUGVhum6ExfZLrWnSrnIrZA=
X-Google-Smtp-Source: AGHT+IHL6d4rRUw0WYpBcrVhnwzxFUAZ6ygz+u9bfZ5D5UkyVyq4s54g2KSsXWDzNOV9qSR19JS2SZiA1+OXnjBOXBs=
X-Received: by 2002:ac2:4bd4:0:b0:572:1f0b:5eeb with SMTP id
 2adb3069b0e04-58cb9d1a96cmr4118324e87.18.1759794817670; Mon, 06 Oct 2025
 16:53:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251006172612.75240-1-ebiggers@kernel.org>
In-Reply-To: <20251006172612.75240-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 7 Oct 2025 01:53:25 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFTbP9dGQmk9F-WFyoL_LjtfXHMCnGT0WUQwMnrn7DHCw@mail.gmail.com>
X-Gm-Features: AS18NWASC592jbSAcXIbQVrd-kptZUbukpaKAG64lSGjP6BSE0v0avhPEnGhLIk
Message-ID: <CAMj1kXFTbP9dGQmk9F-WFyoL_LjtfXHMCnGT0WUQwMnrn7DHCw@mail.gmail.com>
Subject: Re: [PATCH] lib/crypto: Add FIPS pre-operational self-test for SHA algorithms
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Vegard Nossum <vegard.nossum@oracle.com>, 
	Joachim Vandersmissen <git@jvdsn.com>, David Howells <dhowells@redhat.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 6 Oct 2025 at 19:28, Eric Biggers <ebiggers@kernel.org> wrote:
>
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
>  lib/crypto/fips.h                   | 38 +++++++++++++++++++++++++++++
>  lib/crypto/sha1.c                   | 19 ++++++++++++++-
>  lib/crypto/sha256.c                 | 19 ++++++++++++++-
>  lib/crypto/sha512.c                 | 19 ++++++++++++++-
>  scripts/crypto/gen-fips-testvecs.py | 33 +++++++++++++++++++++++++
>  5 files changed, 125 insertions(+), 3 deletions(-)
>  create mode 100644 lib/crypto/fips.h
>  create mode 100755 scripts/crypto/gen-fips-testvecs.py
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
> +       0x66, 0x69, 0x70, 0x73, 0x20, 0x74, 0x65, 0x73,
> +       0x74, 0x20, 0x64, 0x61, 0x74, 0x61, 0x00, 0x00,
> +};
> +
> +static const u8 fips_test_key[] __initconst __maybe_unused = {
> +       0x66, 0x69, 0x70, 0x73, 0x20, 0x74, 0x65, 0x73,
> +       0x74, 0x20, 0x6b, 0x65, 0x79, 0x00, 0x00, 0x00,
> +};
> +
> +static const u8 fips_test_hmac_sha1_value[] __initconst __maybe_unused = {
> +       0x29, 0xa9, 0x88, 0xb8, 0x5c, 0xb4, 0xaf, 0x4b,
> +       0x97, 0x2a, 0xee, 0x87, 0x5b, 0x0a, 0x02, 0x55,
> +       0x99, 0xbf, 0x86, 0x78,
> +};
> +
> +static const u8 fips_test_hmac_sha256_value[] __initconst __maybe_unused = {
> +       0x59, 0x25, 0x85, 0xcc, 0x40, 0xe9, 0x64, 0x2f,
> +       0xe9, 0xbf, 0x82, 0xb7, 0xd3, 0x15, 0x3d, 0x43,
> +       0x22, 0x0b, 0x4c, 0x00, 0x90, 0x14, 0x25, 0xcf,
> +       0x9e, 0x13, 0x2b, 0xc2, 0x30, 0xe6, 0xe8, 0x93,
> +};
> +
> +static const u8 fips_test_hmac_sha512_value[] __initconst __maybe_unused = {
> +       0x6b, 0xea, 0x5d, 0x27, 0x49, 0x5b, 0x3f, 0xea,
> +       0xde, 0x2d, 0xfa, 0x32, 0x75, 0xdb, 0x77, 0xc8,
> +       0x26, 0xe9, 0x4e, 0x95, 0x4d, 0xad, 0x88, 0x02,
> +       0x87, 0xf9, 0x52, 0x0a, 0xd1, 0x92, 0x80, 0x1d,
> +       0x92, 0x7e, 0x3c, 0xbd, 0xb1, 0x3c, 0x49, 0x98,
> +       0x44, 0x9c, 0x8f, 0xee, 0x3f, 0x02, 0x71, 0x51,
> +       0x57, 0x0b, 0x15, 0x38, 0x95, 0xd8, 0xa3, 0x81,
> +       0xba, 0xb3, 0x15, 0x37, 0x5c, 0x6d, 0x57, 0x2b,
> +};
> diff --git a/lib/crypto/sha1.c b/lib/crypto/sha1.c
> index 5904e4ae85d24..001059cb0fce4 100644
> --- a/lib/crypto/sha1.c
> +++ b/lib/crypto/sha1.c
> @@ -10,10 +10,11 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/string.h>
>  #include <linux/unaligned.h>
>  #include <linux/wordpart.h>
> +#include "fips.h"
>
>  static const struct sha1_block_state sha1_iv = {
>         .h = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
>  };
>
> @@ -328,14 +329,30 @@ void hmac_sha1_usingrawkey(const u8 *raw_key, size_t raw_key_len,
>         hmac_sha1_update(&ctx, data, data_len);
>         hmac_sha1_final(&ctx, out);
>  }
>  EXPORT_SYMBOL_GPL(hmac_sha1_usingrawkey);
>
> -#ifdef sha1_mod_init_arch
> +#if defined(sha1_mod_init_arch) || defined(CONFIG_CRYPTO_FIPS)
>  static int __init sha1_mod_init(void)
>  {
> +#ifdef sha1_mod_init_arch
>         sha1_mod_init_arch();
> +#endif
> +       if (fips_enabled) {
> +               /*
> +                * FIPS pre-operational self-test.  As per the FIPS
> +                * Implementation Guidance, testing HMAC-SHA1 satisfies the test
> +                * requirement for SHA-1 too.
> +                */
> +               u8 mac[SHA1_DIGEST_SIZE];
> +
> +               hmac_sha1_usingrawkey(fips_test_key, sizeof(fips_test_key),
> +                                     fips_test_data, sizeof(fips_test_data),
> +                                     mac);
> +               if (memcmp(fips_test_hmac_sha1_value, mac, sizeof(mac)) != 0)
> +                       panic("sha1: FIPS pre-operational self-test failed\n");
> +       }
>         return 0;
>  }
>  subsys_initcall(sha1_mod_init);
>

In the builtin case, couldn't this execute only after the first calls
into the library? That would mean it does not quite fit the
requirements of the pre-operational selftest.

So perhaps, we should wrap the fips test in a separate function, and
in the builtin case, add a call to it to every exported library
routine, conditional on some static key that gets set on success? With
the right macro foo, it doesn't have to be that ugly, and it can just
disappear entirely if FIPS support is disabled.

(For all I care, we don't bother with this at all, but if we add this
it should be solid)
