Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F61C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 29 Jan 2022 22:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353380AbiA2Wpk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 Jan 2022 17:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353379AbiA2Wpk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 Jan 2022 17:45:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11117C061714
        for <linux-crypto@vger.kernel.org>; Sat, 29 Jan 2022 14:45:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2F8660DF1
        for <linux-crypto@vger.kernel.org>; Sat, 29 Jan 2022 22:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE76C340E5;
        Sat, 29 Jan 2022 22:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643496338;
        bh=ir7JITqypjuYMlQS0f577krwRMvFJWUahO/MS1SkLaU=;
        h=From:To:Cc:Subject:Date:From;
        b=RKSpVnRDQmvtMKU0y8Zx+Vs4fk+zE8ib1712DW2KUFvFJwvV//K+//BV8vrfx38Mg
         NfagKIlB3TKYC0uWso1dLCl79RG7uQXhQi1I7H/JWTfgpNMjN+ncErdBIJ9lL5DpJb
         WPZQLhBj4GUH/C5Si+/Rr2mMnd6BzTQ81WYme7bWeL54JyeB4jLn+Iaq572kIfObV9
         7APHkyK2DKiX+0Q7iI9WbIwC6pLH6HgqV126YwsTOSKgJM9RCu2mpyvBAeTcXnMYaa
         akpV6c/NTqyQFt3m1qwuN7wiprLKNc63MMQKXp67Aanx/hDdys9iNIBJOW9ZRncEF1
         V/95d2gZwqO/Q==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v2 0/2] xor: enable auto-vectorization in Clang
Date:   Sat, 29 Jan 2022 23:45:27 +0100
Message-Id: <20220129224529.76887-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1787; h=from:subject; bh=ir7JITqypjuYMlQS0f577krwRMvFJWUahO/MS1SkLaU=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh9cOH6X+ayHMDlL29NrlC4k/aPSV8AmrHjy8qoauk OA8295mJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYfXDhwAKCRDDTyI5ktmPJJ5MC/ 99lmrLufWmIL0DMI5Wq3GxDNuaiEhhIUC17TTDkovWqS9Aze92PAqIBwqJZBgFW17vq3ZX+BZ7ONNW 3JmhDamvrkGxeMEc8I/Ho/tS8IxmcqZm3RguAq8vq4pvFD7b28AUmnRZe1pWDcrXRLs8H6FOgMFUaN FYeXWQn7E7M+/6417F24+5nLvK6s5EP+XpaHcUfMitgBU43pFncT0rJdX6p1v5M/xh9y6eBxUGzbf3 XMiN20RLaKeEG0PvtSkxA2jK8DKBkKJUzUTmfejEpfpkC4miOjhzrx72R1cAHAUUwn88wccHRwvxbE EGONdhpJ8/Le1m8R02fjciMF5q7u77cmVsKrsQHW2L6itfk1EuIku/eI1M60mm8rn8crhja+dXunFx Gcx+X0qJW67MaYDQCi6VwcVxGYJ9pFd5CGZk1ahkGgiZrtD5Ea6UM21kqUfARhA1lSfvs+JAfv6Y8o 5QfParpmGYTkZ8uDgU2+2t0VkpynvoDQuKPU/QSmMVVfU=
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

Changes since v1:
- fix PPC build
- add Nathan's Tested-by

Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>

Ard Biesheuvel (2):
  lib/xor: make xor prototypes more friendely to compiler vectorization
  crypto: arm/xor - make vectorized C code Clang-friendly

 arch/alpha/include/asm/xor.h           | 53 ++++++++----
 arch/arm/include/asm/xor.h             | 42 ++++++----
 arch/arm/lib/xor-neon.c                | 12 +--
 arch/arm64/include/asm/xor.h           | 21 +++--
 arch/arm64/lib/xor-neon.c              | 23 +++---
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
 18 files changed, 369 insertions(+), 209 deletions(-)

-- 
2.30.2

