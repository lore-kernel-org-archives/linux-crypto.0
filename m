Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DAD0C433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Feb 2022 15:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358041AbiBEPYU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Feb 2022 10:24:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44918 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357601AbiBEPYU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Feb 2022 10:24:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51DFCB80139
        for <linux-crypto@vger.kernel.org>; Sat,  5 Feb 2022 15:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC754C340EC;
        Sat,  5 Feb 2022 15:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644074658;
        bh=BbVYfJxIpEu712Gu6tPIRXohyjjOPfRxiByMcmEUk6c=;
        h=From:To:Cc:Subject:Date:From;
        b=HLcp/ynJ6hJGox9GfmBHL29ZObcY+9ECGB+rto1byXq5QxdZ098jj0C4RSBJ3solw
         iNpyHRwHNE/qXGGZK9mfGGdjCTQooe1Ty8WT1TgqLILzAKPnjPx9o+XQnZuUWSHtlk
         hLitthWkv49FtDlYJ6ZxDI7F/E8VPPIIU5hRZ6tOhuJttsmNpdBMnxyN4hhVAtyZsn
         9rujNxv73R8Hgn3CBWQgKWfSIAUbJsLDQI9BjiRQZnEqNOknJ7v2iDDvkcorDW5PbX
         5bGHbw7Dj9X4LLqthRUyjke+ztSDpcEH/sGylUn2yjdh4ypALVjU2JcLSj4fz0P1kO
         eTggYBAPXcwzw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v4 0/2] xor: enable auto-vectorization in Clang
Date:   Sat,  5 Feb 2022 16:23:44 +0100
Message-Id: <20220205152346.237392-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2119; h=from:subject; bh=BbVYfJxIpEu712Gu6tPIRXohyjjOPfRxiByMcmEUk6c=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh/pZ/FIkoO/REUthLt0O/GwEWEJuNfHGJySUgVXC0 HVTXBbWJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYf6WfwAKCRDDTyI5ktmPJFq+C/ 46MfNKKQZK+Il/yFkZp34bgyYkjmUFT5UMRIwDR+SU4nIU1EQXwpQf97QjMhSmx61/Vbyoa9FhbpnZ f2L2RSv+hj8vYhaHQ6rxZry/wVTqQQVAfCR3fiAmg1AMnkJjlKKuqz2GnqZVJAS2IwqnznUH/2lJwB Q7FWIqfayw/5KFXbz6Qw32IMocUW+6vCL4tU4zD09v1Uw7931uE5nU48AsPRXnhE97BJpSxFzLsfhL PshJGg92Q03bTLXAEUBr2dcytW39uk4hbqUS+P+1VFIj6K2Cgc27U1fsXLZeIbHpyPIOe6prNLJqGU t9n2sCkNYFC2CIXPzWQ82kEng9L9Eby1BO3eF5p2rYYOJ6SKSNlnvCgaTqXr7lOljbZS2gPUyd0ntn IZJ3hHlo4w5zyWwoO0kPPRPwxNRVJ3159IHQWGCHQlwdt19QkaQwy9SD5PZp8SMERSA894UvdP2JQc vUja52k+af/Pm11znx+cKf9EZ1hbMdATUqe4Sj+CSxrxw=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update the xor_blocks() prototypes so that the compiler understands that
the inputs always refer to distinct regions of memory. This is implied
by the existing implementations, as they use different granularities for
the load/xor/store loops.

With that, we can fix the ARM/Clang version, which refuses to SIMD
vectorize otherwise, and throws a spurious warning related to the GCC
version being incompatible.

Changes since v3:
- revert broken PPC argument rename - doing it fully results in too
  much pointless churn, and the 'inner' altivec routines are not
  strictly part of the xor_blocks API anyway

Changes since v2:
- fix arm64 build after rebase
- name PPC argument names consistently
- add Nick's acks and link tags

Changes since v1:
- fix PPC build
- add Nathan's Tested-by

Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>

Ard Biesheuvel (2):
  lib/xor: make xor prototypes more friendly to compiler vectorization
  crypto: arm/xor - make vectorized C code Clang-friendly

 arch/alpha/include/asm/xor.h           | 53 ++++++++----
 arch/arm/include/asm/xor.h             | 42 ++++++----
 arch/arm/lib/xor-neon.c                | 12 +--
 arch/arm64/include/asm/xor.h           | 21 +++--
 arch/arm64/lib/xor-neon.c              | 46 +++++++----
 arch/ia64/include/asm/xor.h            | 21 +++--
 arch/powerpc/include/asm/xor_altivec.h | 25 +++---
 arch/powerpc/lib/xor_vmx.c             | 28 ++++---
 arch/powerpc/lib/xor_vmx.h             | 27 ++++---
 arch/powerpc/lib/xor_vmx_glue.c        | 32 ++++----
 arch/s390/lib/xor.c                    | 21 +++--
 arch/sparc/include/asm/xor_32.h        | 21 +++--
 arch/sparc/include/asm/xor_64.h        | 42 ++++++----
 arch/x86/include/asm/xor.h             | 42 ++++++----
 arch/x86/include/asm/xor_32.h          | 42 ++++++----
 arch/x86/include/asm/xor_avx.h         | 21 +++--
 include/asm-generic/xor.h              | 84 +++++++++++++-------
 include/linux/raid/xor.h               | 21 +++--
 18 files changed, 384 insertions(+), 217 deletions(-)

-- 
2.30.2

