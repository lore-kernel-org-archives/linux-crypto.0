Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F120FC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 10:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC1AB2087C
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 10:50:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YOuuyshi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfCMKu5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 06:50:57 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:36222 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfCMKu4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 06:50:56 -0400
Received: by mail-it1-f194.google.com with SMTP id v83so2118212itf.1
        for <linux-crypto@vger.kernel.org>; Wed, 13 Mar 2019 03:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7DZvKRCZmrXFP614c2AQCpd/wpLZc345gRK5VIt9Y48=;
        b=YOuuyshimio2HSehUHmBVSqSh7z0pN5fhvw5gYw4Ylv7W7DBPMF9KVpxZmwsaxKwjV
         SOwdt0+Kia9qDTPGkJP80bbEpDsxbIZMLUdz+O6x3X0ATxqPGFziCKR1vzqyPEwwEA1o
         MLrAEUFy0oIDKQDGZHwBoKOLXQ9HUt2St6S6xplY/o4YzI33qChe0qhNFflWAwT022g9
         vF27dpvQGhN21qJdCuNMmhFb9clIwHwkSIsIIfThXOWJ8/Yn8ly3Faprj4pTMKAwI+QO
         Msi21wUrlrgrxgG2Rk0JCm3Ze+TRYSUwlUPFsvz8sOV65sWDtoA5wuoF2aWvVPC7NTxP
         KHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7DZvKRCZmrXFP614c2AQCpd/wpLZc345gRK5VIt9Y48=;
        b=HHq8+rI8g7WTrLdtoPT2JC8u2YwgKZgqsWchz47Pyoy/OHkip+hsfp0uwViYBCarxC
         vL4ah1qSvpzRx4Vbf4hNivhI0LblzFELGA1vGzaGHFG6iVBHRLRAdbqZBsh7ZASRVlRt
         R+0TQ7t2d41MN8mqGX00WLhmN6E2geUVg6VA586LQ7/S/rTc+p3JU6VUYcAulDYLfaWu
         ICzV4zRhKWRF+Fnih0pC0mVZN6iuQEKwtRKb3letVfxX6SFopInreQARW+9DknfyyPAb
         wlICAi71dG/8Oodd+tW7srXJ/fD2V/mClMMSLmzItBl9OKY6bHt4u0YuYH3d9QYe1Nf1
         59jA==
X-Gm-Message-State: APjAAAVOm3rAlNJxu298lPzYdnz7ZDhPVDzSJlP2kryRU77l8KYJD4MY
        4ETsp6YhEIPvrmi/M3mplCjga1ZQXDGQGxCni8GabQ==
X-Google-Smtp-Source: APXvYqyp1Atm++mV46TokA1lqkLbDTINws2KGWoF4yohdl0HcX2f0r4PQ/wl6z1ugCPS8lYMgaAVi+92FXhc1g59VEI=
X-Received: by 2002:a24:1947:: with SMTP id b68mr1164620itb.121.1552474255537;
 Wed, 13 Mar 2019 03:50:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190313051252.2917-1-ebiggers@kernel.org>
In-Reply-To: <20190313051252.2917-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 13 Mar 2019 11:50:44 +0100
Message-ID: <CAKv+Gu_zNvcXAaRuz8cwnbRYjqo__KmY4PzVpGivZGPeEdsk=Q@mail.gmail.com>
Subject: Re: [PATCH 0/8] crypto: test the !may_use_simd() fallback code
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 13 Mar 2019 at 06:15, Eric Biggers <ebiggers@kernel.org> wrote:
>
> All crypto API algorithms are supposed to support the case where they
> are called in a context where SIMD instructions are unusable, e.g. IRQ
> context on some architectures.  However, this isn't tested for by the
> self-tests, causing bugs to go undetected.
>
> This patch series therefore updates the self-tests to test the no-SIMD
> code.  It works by converting all may_use_simd() checks to a new macro
> crypto_simd_usable(), which also returns false when the self-tests have
> disabled SIMD in crypto algorithms on the current CPU for test purposes.
>
> For now, all no-SIMD testing is limited to the extra crypto self-tests,
> because it might be a bit too invasive for the regular self-tests.
> But this could be changed later.
>
> This already found bugs in the arm64 implementations of AES-GCM and
> ChaCha.  These are fixed by the first two patches.  Following this, the
> tests pass on x86, arm, and arm64.
>

Thanks a lot for doing this Eric.

I pushed your branch to kernelci again, let's see if anything else
falls out (although not as likely, given that this shouldn't affect
h/w accelerators)



> This patch series is based on top of my other pending patch series
> "crypto: add SIMD helpers for AEADs".  It can also be found in git at:
>
>     URL:     https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
>     Branch:  crypto-nosimd-tests
>
> Eric Biggers (8):
>   crypto: chacha-generic - fix use as arm64 no-NEON fallback
>   crypto: arm64/gcm-aes-ce - fix no-NEON fallback code
>   crypto: simd,testmgr - introduce crypto_simd_usable()
>   crypto: x86 - convert to use crypto_simd_usable()
>   crypto: arm - convert to use crypto_simd_usable()
>   crypto: arm64 - convert to use crypto_simd_usable()
>   crypto: simd - convert to use crypto_simd_usable()
>   crypto: testmgr - test the !may_use_simd() fallback code
>
>  arch/arm/crypto/chacha-neon-glue.c         |   5 +-
>  arch/arm/crypto/crc32-ce-glue.c            |   5 +-
>  arch/arm/crypto/crct10dif-ce-glue.c        |   3 +-
>  arch/arm/crypto/ghash-ce-glue.c            |   7 +-
>  arch/arm/crypto/nhpoly1305-neon-glue.c     |   3 +-
>  arch/arm/crypto/sha1-ce-glue.c             |   5 +-
>  arch/arm/crypto/sha1_neon_glue.c           |   5 +-
>  arch/arm/crypto/sha2-ce-glue.c             |   5 +-
>  arch/arm/crypto/sha256_neon_glue.c         |   5 +-
>  arch/arm/crypto/sha512-neon-glue.c         |   5 +-
>  arch/arm64/crypto/aes-ce-ccm-glue.c        |   7 +-
>  arch/arm64/crypto/aes-ce-glue.c            |   5 +-
>  arch/arm64/crypto/aes-glue.c               |   4 +-
>  arch/arm64/crypto/aes-neonbs-glue.c        |   2 +-
>  arch/arm64/crypto/chacha-neon-glue.c       |   5 +-
>  arch/arm64/crypto/crct10dif-ce-glue.c      |   5 +-
>  arch/arm64/crypto/ghash-ce-glue.c          |  17 ++-
>  arch/arm64/crypto/nhpoly1305-neon-glue.c   |   3 +-
>  arch/arm64/crypto/sha1-ce-glue.c           |   7 +-
>  arch/arm64/crypto/sha2-ce-glue.c           |   7 +-
>  arch/arm64/crypto/sha256-glue.c            |   5 +-
>  arch/arm64/crypto/sha3-ce-glue.c           |   5 +-
>  arch/arm64/crypto/sha512-ce-glue.c         |   7 +-
>  arch/arm64/crypto/sm3-ce-glue.c            |   7 +-
>  arch/arm64/crypto/sm4-ce-glue.c            |   5 +-
>  arch/x86/crypto/aesni-intel_glue.c         |   8 +-
>  arch/x86/crypto/chacha_glue.c              |   6 +-
>  arch/x86/crypto/crc32-pclmul_glue.c        |   5 +-
>  arch/x86/crypto/crc32c-intel_glue.c        |   7 +-
>  arch/x86/crypto/crct10dif-pclmul_glue.c    |   7 +-
>  arch/x86/crypto/ghash-clmulni-intel_glue.c |   9 +-
>  arch/x86/crypto/nhpoly1305-avx2-glue.c     |   5 +-
>  arch/x86/crypto/nhpoly1305-sse2-glue.c     |   5 +-
>  arch/x86/crypto/poly1305_glue.c            |   4 +-
>  arch/x86/crypto/sha1_ssse3_glue.c          |   7 +-
>  arch/x86/crypto/sha256_ssse3_glue.c        |   7 +-
>  arch/x86/crypto/sha512_ssse3_glue.c        |  10 +-
>  crypto/chacha_generic.c                    |   2 +-
>  crypto/simd.c                              |   8 +-
>  crypto/testmgr.c                           | 142 +++++++++++++++++----
>  include/crypto/internal/simd.h             |  24 ++++
>  41 files changed, 272 insertions(+), 123 deletions(-)
>
> --
> 2.21.0
>
