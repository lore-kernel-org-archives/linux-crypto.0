Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2881CBA04;
	Fri, 25 Oct 2024 08:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729843519; cv=none; b=DK88ZKwBoSLd0S+nTZxo4kcsY8oT/FNNBgxXyqjrwyXPg5syaq6eb7cDIBt7Stmu/yJz9fHQF8pFMnFD0XfoC2trHzi68MtLeuFKMAO1XHavoGbzhXH+bpbRXIEDIfTQ44e5yXQGza/jTYBIqf1nrlkTmCc1D4PocHL17wmNZ0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729843519; c=relaxed/simple;
	bh=KfmEL14rVYtfMW9cS9/j2bydxqHvt8iK8MkWYzJOEvA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m9YOjjmUrhPjyj16mgSIGyfrtYuxsvY4hicPILvQO4opAhvQeJBEG2UOLKqK0rFLqsN5XP6AVqXe9QEi0WTvS4G8+x+BvKpQ9kvY/py9tCi5nWniS4VDpVL0K+VXsKSU93eC5MT3hrl8dpoAN2+IEm78v4jTTvBMaRFsf15EwfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NVvZEqOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NVvZEqOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C76C4CECC;
	Fri, 25 Oct 2024 08:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729843518;
	bh=KfmEL14rVYtfMW9cS9/j2bydxqHvt8iK8MkWYzJOEvA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NVvZEqOgckAGp2/wGcICDCHu1ywbgm66lHVMxvD5Ps1t/KsbQvygjH5NDjD+7xOhv
	 tPdNyewBDRwuFJD2bf3kEymZHJoyiTgw+eYn5/8gA7bI1gIHLp1EpTk9dUFj2LGm+/
	 J8vU4SyM1u+pbttYSCzH5uyhBAV4HhkqnPP4qMj9h3f9Zp3sduBWs0NdLGg+1vem7h
	 EgVt2Rv6ZZ7ZKLq4RJTKTPbu235tbRwm2GDb1WmH0Qw/Z+mU309rlcgp42gDhTjQIO
	 XRpyAB97ENeBo/S8KkeP2RjhDK7UAnuFkX+48kp9Vf0U7qbyWRTVIMATsJ8BiudR19
	 /avWhjhSlAt/A==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-539983beb19so2249780e87.3;
        Fri, 25 Oct 2024 01:05:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU+FskcdzkLP6NEvR1+slzQlWgZQMAxkrq621GH4RBtxi9OD2Z9oEGRaF9cv/jgyq9Z8fmepFgu0p0tINE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhrGj7HHIjuJ5T6oJI+Bd9dPRe5b37Zt3GloWApI4pkNzmOYqN
	bDuqQlqVCr0JEk+TlnqCS+8u0JerNl+twHh/olrgBSmkH3dDCJHpsnQnUU6bxHsZO84I+Yp+2Uz
	V2yft9dtJWRM/ailsWsfYAzkgRAs=
X-Google-Smtp-Source: AGHT+IG27Yb80kx6CJY+4tOhVGsT/ZEj4ynv9I5D6j49Hjrinwf5ULC9VA4qcGFViD1IszHktbXduIrXQPhRWuonH7A=
X-Received: by 2002:a05:6512:33cf:b0:539:dc87:fd3a with SMTP id
 2adb3069b0e04-53b1a2fad1fmr5310677e87.6.1729843517038; Fri, 25 Oct 2024
 01:05:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241018235343.425758-1-ebiggers@kernel.org>
In-Reply-To: <20241018235343.425758-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 25 Oct 2024 10:05:05 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGvh3DBGL2g-3Xnj_F1e3w+HDBxoekgiE2iJq9TsOK--g@mail.gmail.com>
Message-ID: <CAMj1kXGvh3DBGL2g-3Xnj_F1e3w+HDBxoekgiE2iJq9TsOK--g@mail.gmail.com>
Subject: Re: [PATCH] crypto - move crypto_simd_disabled_for_test to lib
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 19 Oct 2024 at 01:54, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Move crypto_simd_disabled_for_test to lib/ so that crypto_simd_usable()
> can be used by library code.
>
> This was discussed previously
> (https://lore.kernel.org/linux-crypto/20220716062920.210381-4-ebiggers@kernel.org/)
> but was not done because there was no use case yet.  However, this is
> now needed for the arm64 CRC32 library code.
>
> Tested with:
>     export ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
>     echo CONFIG_CRC32=y > .config
>     echo CONFIG_MODULES=y >> .config
>     echo CONFIG_CRYPTO=m >> .config
>     echo CONFIG_DEBUG_KERNEL=y >> .config
>     echo CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n >> .config
>     echo CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y >> .config
>     make olddefconfig
>     make -j$(nproc)
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>


> ---
>  crypto/algapi.c     |  6 ------
>  lib/crypto/Makefile |  2 ++
>  lib/crypto/simd.c   | 11 +++++++++++
>  3 files changed, 13 insertions(+), 6 deletions(-)
>  create mode 100644 lib/crypto/simd.c
>
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index 74e2261c184ca..429a832f90fe0 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -4,11 +4,10 @@
>   *
>   * Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
>   */
>
>  #include <crypto/algapi.h>
> -#include <crypto/internal/simd.h>
>  #include <linux/err.h>
>  #include <linux/errno.h>
>  #include <linux/fips.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> @@ -21,15 +20,10 @@
>
>  #include "internal.h"
>
>  static LIST_HEAD(crypto_template_list);
>
> -#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
> -DEFINE_PER_CPU(bool, crypto_simd_disabled_for_test);
> -EXPORT_PER_CPU_SYMBOL_GPL(crypto_simd_disabled_for_test);
> -#endif
> -
>  static inline void crypto_check_module_sig(struct module *mod)
>  {
>         if (fips_enabled && mod && !module_sig_ok(mod))
>                 panic("Module %s signature verification failed in FIPS mode\n",
>                       module_name(mod));
> diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
> index 969baab8c805f..01fac1cd05a19 100644
> --- a/lib/crypto/Makefile
> +++ b/lib/crypto/Makefile
> @@ -56,5 +56,7 @@ libblake2s-y                                  += blake2s-selftest.o
>  libchacha20poly1305-y                          += chacha20poly1305-selftest.o
>  libcurve25519-y                                        += curve25519-selftest.o
>  endif
>
>  obj-$(CONFIG_MPILIB) += mpi/
> +
> +obj-$(CONFIG_CRYPTO_MANAGER_EXTRA_TESTS)       += simd.o
> diff --git a/lib/crypto/simd.c b/lib/crypto/simd.c
> new file mode 100644
> index 0000000000000..9c36cb3bb49c4
> --- /dev/null
> +++ b/lib/crypto/simd.c
> @@ -0,0 +1,11 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * SIMD testing utility functions
> + *
> + * Copyright 2024 Google LLC
> + */
> +
> +#include <crypto/internal/simd.h>
> +
> +DEFINE_PER_CPU(bool, crypto_simd_disabled_for_test);
> +EXPORT_PER_CPU_SYMBOL_GPL(crypto_simd_disabled_for_test);
>
> base-commit: 5c20772738e1d1d7bec41664eb9d61497e53c10e
> --
> 2.47.0
>
