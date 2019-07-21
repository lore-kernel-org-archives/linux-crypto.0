Return-Path: <SRS0=CriU=VS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63EDCC76188
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jul 2019 09:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24BB72085A
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jul 2019 09:51:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Yn85RkPR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfGUJvO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jul 2019 05:51:14 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39116 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfGUJvO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jul 2019 05:51:14 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so36284625wrt.6
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jul 2019 02:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z53hRrHefOJhtDHfaXpJagunFHYavBL1a4i0yU/Dq9U=;
        b=Yn85RkPRbwuTEgaXrTiRfWDTI0VMgsgSoMtA8IdmuWKicP5JEmaUUGtgQGTbJfiwOC
         vpFiyR/jBRf4qSSYP8PHdCxvuhJmCUgBlbBCVo53lpCcKzhr3sN8EzritimAyvvMHeXM
         JqHo04lZrwH9cUbKxH7+NqzUgotAToqy0Wj8EHTRIMEEJ/taENibtLkr15VzZfaXXDuC
         3DicZ3rZ1aZU18qwPJZ52vS4Q2ZFJK/HQXw1QbloO9aoQ88U5QHIJpoOxkJCehgQbFG+
         K5ayaEyss9diFgRJXOU8IznqvFzzKiBYFeaDRVInVeBoV9uegHrIqfXT34ANp8a+q5NS
         dVng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z53hRrHefOJhtDHfaXpJagunFHYavBL1a4i0yU/Dq9U=;
        b=rV3fDH3LUExf8ffr/T64vWHMmd7ZuuHUKUboBLJ+z1qbIeQ6lksTqicpwf8g+oDDE4
         QDHTLn0OffJffi0t7ob1dgvgKoeRt1p2I2zSnovSaiwMl2eEas6M64VtTGfm1M2+VcPT
         AEuFAw6Komt7z5JtU0biyhl0uGualGIicOyGRtj9BC+IbA9daYiSEnTT1cfBm4x3q8mX
         7qQ156lIhsArfqZ+zvijx+Gjw1fE4gXgM6kqDNQHX2KAXNGGhWju8w5B3YRU3sLnPVei
         FlnInbn2nP5/G4c5tDxMQshJ4yD4AgwYhwB34V+5Gl1q4W49QMMtm7ptxbJCnLB4byuU
         tqWw==
X-Gm-Message-State: APjAAAX8RyLyISy/3+k9CknJ8vfEfSXd6Mq7Xejkp4uX3htSQIHPqbgP
        H77dy5SxGwTTvPTksyPsxN/T64JSnbtxIqizsoc/hw==
X-Google-Smtp-Source: APXvYqxliFPcuzeq8Ysnd9+fL7pyXWiKMKEYncCpQcmdc6ApDQQ+7IFA6y4HALDXdOKSMcdHxB2PVu16OcghDMWwDy8=
X-Received: by 2002:a5d:6b07:: with SMTP id v7mr68418396wrw.169.1563702671127;
 Sun, 21 Jul 2019 02:51:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190720060918.25880-1-ebiggers@kernel.org>
In-Reply-To: <20190720060918.25880-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 21 Jul 2019 12:51:00 +0300
Message-ID: <CAKv+Gu8NGoNdt2ZEKToKjM0YMzLxUjAM+4yHPkQKBDx=7Wo_rw@mail.gmail.com>
Subject: Re: [PATCH] crypto: ghash - add comment and improve help text
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 20 Jul 2019 at 09:10, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> To help avoid confusion, add a comment to ghash-generic.c which explains
> the convention that the kernel's implementation of GHASH uses.
>
> Also update the Kconfig help text and module descriptions to call GHASH
> a "hash function" rather than a "message digest", since the latter
> normally means a real cryptographic hash function, which GHASH is not.
>
> Cc: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm/crypto/ghash-ce-glue.c            |  2 +-
>  arch/s390/crypto/ghash_s390.c              |  2 +-
>  arch/x86/crypto/ghash-clmulni-intel_glue.c |  3 +--
>  crypto/Kconfig                             | 11 ++++----
>  crypto/ghash-generic.c                     | 31 +++++++++++++++++++---
>  drivers/crypto/Kconfig                     |  6 ++---
>  include/crypto/ghash.h                     |  2 +-
>  7 files changed, 41 insertions(+), 16 deletions(-)
>
> diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-g=
lue.c
> index 52d472a050e6a..bfdc557dc031c 100644
> --- a/arch/arm/crypto/ghash-ce-glue.c
> +++ b/arch/arm/crypto/ghash-ce-glue.c
> @@ -17,7 +17,7 @@
>  #include <linux/crypto.h>
>  #include <linux/module.h>
>
> -MODULE_DESCRIPTION("GHASH secure hash using ARMv8 Crypto Extensions");
> +MODULE_DESCRIPTION("GHASH hash function using ARMv8 Crypto Extensions");
>  MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
>  MODULE_LICENSE("GPL v2");
>  MODULE_ALIAS_CRYPTO("ghash");
> diff --git a/arch/s390/crypto/ghash_s390.c b/arch/s390/crypto/ghash_s390.=
c
> index eeeb6a7737a4a..a3e7400e031ca 100644
> --- a/arch/s390/crypto/ghash_s390.c
> +++ b/arch/s390/crypto/ghash_s390.c
> @@ -153,4 +153,4 @@ module_exit(ghash_mod_exit);
>  MODULE_ALIAS_CRYPTO("ghash");
>
>  MODULE_LICENSE("GPL");
> -MODULE_DESCRIPTION("GHASH Message Digest Algorithm, s390 implementation"=
);
> +MODULE_DESCRIPTION("GHASH hash function, s390 implementation");
> diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto=
/ghash-clmulni-intel_glue.c
> index ac76fe88ac4fd..04d72a5a8ce98 100644
> --- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
> +++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
> @@ -357,6 +357,5 @@ module_init(ghash_pclmulqdqni_mod_init);
>  module_exit(ghash_pclmulqdqni_mod_exit);
>
>  MODULE_LICENSE("GPL");
> -MODULE_DESCRIPTION("GHASH Message Digest Algorithm, "
> -                  "accelerated by PCLMULQDQ-NI");
> +MODULE_DESCRIPTION("GHASH hash function, accelerated by PCLMULQDQ-NI");
>  MODULE_ALIAS_CRYPTO("ghash");
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index e801450bcb1cf..f14c457183c55 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -728,11 +728,12 @@ config CRYPTO_VPMSUM_TESTER
>           Unless you are testing these algorithms, you don't need this.
>
>  config CRYPTO_GHASH
> -       tristate "GHASH digest algorithm"
> +       tristate "GHASH hash function"
>         select CRYPTO_GF128MUL
>         select CRYPTO_HASH
>         help
> -         GHASH is message digest algorithm for GCM (Galois/Counter Mode)=
.
> +         GHASH is the hash function used in GCM (Galois/Counter Mode).
> +         It is not a general-purpose cryptographic hash function.
>
>  config CRYPTO_POLY1305
>         tristate "Poly1305 authenticator algorithm"
> @@ -1057,12 +1058,12 @@ config CRYPTO_WP512
>           <http://www.larc.usp.br/~pbarreto/WhirlpoolPage.html>
>
>  config CRYPTO_GHASH_CLMUL_NI_INTEL
> -       tristate "GHASH digest algorithm (CLMUL-NI accelerated)"
> +       tristate "GHASH hash function (CLMUL-NI accelerated)"
>         depends on X86 && 64BIT
>         select CRYPTO_CRYPTD
>         help
> -         GHASH is message digest algorithm for GCM (Galois/Counter Mode)=
.
> -         The implementation is accelerated by CLMUL-NI of Intel.
> +         This is the x86_64 CLMUL-NI accelerated implementation of
> +         GHASH, the hash function used in GCM (Galois/Counter mode).
>
>  comment "Ciphers"
>
> diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
> index dad9e1f91a783..5027b3461c921 100644
> --- a/crypto/ghash-generic.c
> +++ b/crypto/ghash-generic.c
> @@ -1,12 +1,37 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
> - * GHASH: digest algorithm for GCM (Galois/Counter Mode).
> + * GHASH: hash function for GCM (Galois/Counter Mode).
>   *
>   * Copyright (c) 2007 Nokia Siemens Networks - Mikko Herranen <mh1@iki.f=
i>
>   * Copyright (c) 2009 Intel Corp.
>   *   Author: Huang Ying <ying.huang@intel.com>
> + */
> +
> +/*
> + * GHASH is a keyed hash function used in GCM authentication tag generat=
ion.
> + *
> + * The original GCM paper [1] presents GHASH as a function GHASH(H, A, C=
) which
> + * takes a 16-byte hash key H, additional authenticated data A, and a ci=
phertext
> + * C.  It formats A and C into a single byte string X, interprets X as a
> + * polynomial over GF(2^128), and evaluates this polynomial at the point=
 H.
> + *
> + * However, the NIST standard for GCM [2] presents GHASH as GHASH(H, X) =
where X
> + * is the already-formatted byte string containing both A and C.
> + *
> + * "ghash" in the Linux crypto API uses the 'X' (pre-formatted) conventi=
on,
> + * since the API supports only a single data stream per hash.  Thus, the
> + * formatting of 'A' and 'C' is done in the "gcm" template, not in "ghas=
h".
> + *
> + * The reason "ghash" is separate from "gcm" is to allow "gcm" to use an
> + * accelerated "ghash" when a standalone accelerated "gcm(aes)" is unava=
ilable.
> + * It is generally inappropriate to use "ghash" for other purposes, sinc=
e it is
> + * an "=CE=B5-almost-XOR-universal hash function", not a cryptographic h=
ash function.
> + * It can only be used securely in crypto modes specially designed to us=
e it.
>   *
> - * The algorithm implementation is copied from gcm.c.
> + * [1] The Galois/Counter Mode of Operation (GCM)
> + *     (http://citeseerx.ist.psu.edu/viewdoc/download?doi=3D10.1.1.694.6=
95&rep=3Drep1&type=3Dpdf)
> + * [2] Recommendation for Block Cipher Modes of Operation: Galois/Counte=
r Mode (GCM) and GMAC
> + *     (https://csrc.nist.gov/publications/detail/sp/800-38d/final)
>   */
>
>  #include <crypto/algapi.h>
> @@ -156,6 +181,6 @@ subsys_initcall(ghash_mod_init);
>  module_exit(ghash_mod_exit);
>
>  MODULE_LICENSE("GPL");
> -MODULE_DESCRIPTION("GHASH Message Digest Algorithm");
> +MODULE_DESCRIPTION("GHASH hash function");
>  MODULE_ALIAS_CRYPTO("ghash");
>  MODULE_ALIAS_CRYPTO("ghash-generic");
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 603413f28fa35..43c36533322f1 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -189,12 +189,12 @@ config S390_PRNG
>           It is available as of z9.
>
>  config CRYPTO_GHASH_S390
> -       tristate "GHASH digest algorithm"
> +       tristate "GHASH hash function"
>         depends on S390
>         select CRYPTO_HASH
>         help
> -         This is the s390 hardware accelerated implementation of the
> -         GHASH message digest algorithm for GCM (Galois/Counter Mode).
> +         This is the s390 hardware accelerated implementation of GHASH,
> +         the hash function used in GCM (Galois/Counter mode).
>
>           It is available as of z196.
>
> diff --git a/include/crypto/ghash.h b/include/crypto/ghash.h
> index 9136301062a5c..f832c9f2aca30 100644
> --- a/include/crypto/ghash.h
> +++ b/include/crypto/ghash.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  /*
> - * Common values for GHASH algorithms
> + * Common values for the GHASH hash function
>   */
>
>  #ifndef __CRYPTO_GHASH_H__
> --
> 2.22.0
>
