Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD50CC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Nov 2022 09:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiKYJsR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Nov 2022 04:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiKYJrK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Nov 2022 04:47:10 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B27F3D92A
        for <linux-crypto@vger.kernel.org>; Fri, 25 Nov 2022 01:46:04 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oyVHU-000hyT-CY; Fri, 25 Nov 2022 17:46:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Nov 2022 17:46:00 +0800
Date:   Fri, 25 Nov 2022 17:46:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, samitolvanen@google.com
Subject: Re: [PATCH v2 00/12] crypto: CFI fixes
Message-ID: <Y4CO2C6QatznTz5i@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118194421.160414-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> This series fixes some crashes when CONFIG_CFI_CLANG (Control Flow
> Integrity) is enabled, with the new CFI implementation that was merged
> in 6.1 and is supported on x86.  Some of them were unconditional
> crashes, while others depended on whether the compiler optimized out the
> indirect calls or not.  This series also simplifies some code that was
> intended to work around limitations of the old CFI implementation and is
> unnecessary for the new CFI implementation.
> 
> Changed in v2:
>  - Added patch "crypto: x86/sm4 - fix crash with CFI enabled"
>  - Restored accidentally-deleted include of <asm/assembler.h>
>  - Tweaked some commit messages and added Reviewed-by and Acked-by tags
> 
> Eric Biggers (12):
>  crypto: x86/aegis128 - fix possible crash with CFI enabled
>  crypto: x86/aria - fix crash with CFI enabled
>  crypto: x86/nhpoly1305 - eliminate unnecessary CFI wrappers
>  crypto: x86/sha1 - fix possible crash with CFI enabled
>  crypto: x86/sha256 - fix possible crash with CFI enabled
>  crypto: x86/sha512 - fix possible crash with CFI enabled
>  crypto: x86/sm3 - fix possible crash with CFI enabled
>  crypto: x86/sm4 - fix crash with CFI enabled
>  crypto: arm64/nhpoly1305 - eliminate unnecessary CFI wrapper
>  crypto: arm64/sm3 - fix possible crash with CFI enabled
>  crypto: arm/nhpoly1305 - eliminate unnecessary CFI wrapper
>  Revert "crypto: shash - avoid comparing pointers to exported functions
>    under CFI"
> 
> arch/arm/crypto/nh-neon-core.S           |  2 +-
> arch/arm/crypto/nhpoly1305-neon-glue.c   | 11 ++---------
> arch/arm64/crypto/nh-neon-core.S         |  5 +++--
> arch/arm64/crypto/nhpoly1305-neon-glue.c | 11 ++---------
> arch/arm64/crypto/sm3-neon-core.S        |  3 ++-
> arch/x86/crypto/aegis128-aesni-asm.S     |  9 +++++----
> arch/x86/crypto/aria-aesni-avx-asm_64.S  | 13 +++++++------
> arch/x86/crypto/nh-avx2-x86_64.S         |  5 +++--
> arch/x86/crypto/nh-sse2-x86_64.S         |  5 +++--
> arch/x86/crypto/nhpoly1305-avx2-glue.c   | 11 ++---------
> arch/x86/crypto/nhpoly1305-sse2-glue.c   | 11 ++---------
> arch/x86/crypto/sha1_ni_asm.S            |  3 ++-
> arch/x86/crypto/sha1_ssse3_asm.S         |  3 ++-
> arch/x86/crypto/sha256-avx-asm.S         |  3 ++-
> arch/x86/crypto/sha256-avx2-asm.S        |  3 ++-
> arch/x86/crypto/sha256-ssse3-asm.S       |  3 ++-
> arch/x86/crypto/sha256_ni_asm.S          |  3 ++-
> arch/x86/crypto/sha512-avx-asm.S         |  3 ++-
> arch/x86/crypto/sha512-avx2-asm.S        |  3 ++-
> arch/x86/crypto/sha512-ssse3-asm.S       |  3 ++-
> arch/x86/crypto/sm3-avx-asm_64.S         |  3 ++-
> arch/x86/crypto/sm4-aesni-avx-asm_64.S   |  7 ++++---
> arch/x86/crypto/sm4-aesni-avx2-asm_64.S  |  7 ++++---
> crypto/shash.c                           | 18 +++---------------
> include/crypto/internal/hash.h           |  8 +++++++-
> 25 files changed, 70 insertions(+), 86 deletions(-)
> 
> 
> base-commit: 75df46b598b5b46b0857ee7d2410deaf215e23d1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
