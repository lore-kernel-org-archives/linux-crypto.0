Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9E6C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8B5820693
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbfCVNEK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:04:10 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:49474 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730869AbfCVNEG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 09:04:06 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h7Jq7-0006EF-Lk; Fri, 22 Mar 2019 21:04:03 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h7Jq2-0005dB-10; Fri, 22 Mar 2019 21:03:58 +0800
Date:   Fri, 22 Mar 2019 21:03:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH 0/8] crypto: test the !may_use_simd() fallback code
Message-ID: <20190322130357.7xolehqp6ynfmfip@gondor.apana.org.au>
References: <20190313051252.2917-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190313051252.2917-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 12, 2019 at 10:12:44PM -0700, Eric Biggers wrote:
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

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
