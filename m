Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8790EC433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Feb 2022 15:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377182AbiBEPY1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Feb 2022 10:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376427AbiBEPYY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Feb 2022 10:24:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086A2C061353
        for <linux-crypto@vger.kernel.org>; Sat,  5 Feb 2022 07:24:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3EA5B80C6D
        for <linux-crypto@vger.kernel.org>; Sat,  5 Feb 2022 15:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7A1C340F0;
        Sat,  5 Feb 2022 15:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644074661;
        bh=qcipBAZoHSGtkTN9yHJ0ciJ/e0rE2CJLdEsIWqhrb4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPQ0ITfZBLzYBh9Bxm7oBNFGEc9HQgM8LRP9YNuEhRjvqZsFemCoHqo2qLZz1v4+1
         wPuYjPQoG1GIyf6q1gMGouFDU0dtfghsiXyqI6UDFVu+J9DF6t2tyaaFllUwtgx2LU
         +qsKEOqXO9A7he8f9GSDOJUBUYEaYm9SCfUb5PFLBQpEsVdSyecTQFDdlAGA3nQumj
         EteKiTRLL/oZAiRqQ/zFim8uCU8g/urSFtFXFf2QM585G3zLWAtTwQGzmtHY+exiU0
         uY4SEDhsPFHHlvdk40Q/DyeBnfOwVseKeioe/XL64zQFpmKtNjd5JAdd/eSOg8FYnq
         Q+NQierA1MSWg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v4 2/2] crypto: arm/xor - make vectorized C code Clang-friendly
Date:   Sat,  5 Feb 2022 16:23:46 +0100
Message-Id: <20220205152346.237392-3-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220205152346.237392-1-ardb@kernel.org>
References: <20220205152346.237392-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2129; h=from:subject; bh=qcipBAZoHSGtkTN9yHJ0ciJ/e0rE2CJLdEsIWqhrb4M=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh/paC5ntRJgpuwWrmJYcYI53WG3WN6XF6sRBUsVrj R0+0GD2JAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYf6WggAKCRDDTyI5ktmPJEHtC/ 993DIVt+KPN7w+sLOW4EUzdRy5/qnnnq8RlbJC2vlsfW+WFsjtglQvXK27QJAMMgVH9/XftWyIWzba LiBIo+WIuQOYa0puCuUrzQPgz39wuJd15Jj12Od88A76lqBTxz10tTVOkC4HPyhAoZB7lLDnjk9FfA kW+bI6drQzc08FaizoW8RrNoTk30+1yhdfMWKd/2qIaSH3sOsiFpH3/gSeQFXAMlmVgoEf8ACNEueR VPD4WPUqUlDvEjx39mM9wpdl+SdFBksjWSXQytyjjHCsMsbAp1rWdlIIyI234G9KLQfL1sidyboLca LjWscSiajfFxHnSOag0ERoCehXk6PPcw3UC5SYdEbuQX213cxlDXS8c0YbOjNsbYDrD2seo/sFrT/Z urci0qZWgU0ba8Lzwu4vw7CXrX/JkeOgrelcXy65XFw88UES4Phy6OR8OTkVhtC5FPxKTHnbLalEiz RWSvmPRZc/yIDIZ7YI0icz60jd+Wa0PXaxwfbGtJvEnJI=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The ARM version of the accelerated XOR routines are simply the 8-way C
routines passed through the auto-vectorizer with SIMD codegen enabled.
This used to require GCC version 4.6 at least, but given that 5.1 is now
the baseline, this check is no longer necessary, and actually
misidentifies Clang as GCC < 4.6 as Clang defines the GCC major/minor as
well, but makes no attempt at doing this in a way that conveys feature
parity with a certain version of GCC (which would not be a great idea in
the first place).

So let's drop the version check, and make the auto-vectorize pragma
(which is based on a GCC-specific command line option) GCC-only. Since
Clang performs SIMD auto-vectorization by default at -O2, no pragma is
necessary here.

Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/496
Link: https://github.com/ClangBuiltLinux/linux/issues/503
---
 arch/arm/lib/xor-neon.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/arm/lib/xor-neon.c b/arch/arm/lib/xor-neon.c
index b99dd8e1c93f..522510baed49 100644
--- a/arch/arm/lib/xor-neon.c
+++ b/arch/arm/lib/xor-neon.c
@@ -17,17 +17,11 @@ MODULE_LICENSE("GPL");
 /*
  * Pull in the reference implementations while instructing GCC (through
  * -ftree-vectorize) to attempt to exploit implicit parallelism and emit
- * NEON instructions.
+ * NEON instructions. Clang does this by default at O2 so no pragma is
+ * needed.
  */
-#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 6)
+#ifdef CONFIG_CC_IS_GCC
 #pragma GCC optimize "tree-vectorize"
-#else
-/*
- * While older versions of GCC do not generate incorrect code, they fail to
- * recognize the parallel nature of these functions, and emit plain ARM code,
- * which is known to be slower than the optimized ARM code in asm-arm/xor.h.
- */
-#warning This code requires at least version 4.6 of GCC
 #endif
 
 #pragma GCC diagnostic ignored "-Wunused-variable"
-- 
2.30.2

