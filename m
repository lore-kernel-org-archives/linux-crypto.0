Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD88C433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Feb 2022 07:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiBEH67 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Feb 2022 02:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379668AbiBEH67 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Feb 2022 02:58:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134B7C061347
        for <linux-crypto@vger.kernel.org>; Fri,  4 Feb 2022 23:58:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA826B83992
        for <linux-crypto@vger.kernel.org>; Sat,  5 Feb 2022 07:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5782EC340F1;
        Sat,  5 Feb 2022 07:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644047935;
        bh=qcipBAZoHSGtkTN9yHJ0ciJ/e0rE2CJLdEsIWqhrb4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ac1wns1vGmOGVybj4WRqy72+w8XMMfrzo7YguCar/9yrbmhGvbz57KOsvrU4itSIK
         jC1QFf8uUx7IVzqMrAqmkY5of/OBXU487Zo2EORXTN8tCC3k4nD7XNntaRmX9mEQGp
         fT9UoYBNEUFCVqkSCimrATpwnbt98DjPFO7dDE/gNwPWi1CgGL2QBjgGs6JYfiZwp9
         eMe5JCquDSUQNXMRIijlSv/G0PzBkMKLfr3kLjCzzIcOHvktyhr2uatuRQXkyAWdjs
         65QRr0nqq0irxy+GsAzgBRcOC8KodnKzFUoeDWNjCNFnRfLLD7J63JdKF5ChjPYA6M
         Zm4W/6n7WBSEw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v3 2/2] crypto: arm/xor - make vectorized C code Clang-friendly
Date:   Sat,  5 Feb 2022 08:58:37 +0100
Message-Id: <20220205075837.153418-3-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220205075837.153418-1-ardb@kernel.org>
References: <20220205075837.153418-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2129; h=from:subject; bh=qcipBAZoHSGtkTN9yHJ0ciJ/e0rE2CJLdEsIWqhrb4M=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh/i4s5ntRJgpuwWrmJYcYI53WG3WN6XF6sRBUsVrj R0+0GD2JAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYf4uLAAKCRDDTyI5ktmPJNl+C/ 4xnRRyLZFJFxCexy2mNZEsK0JRjfPOwCUQHEAciBx5Y2aer8tXGHNuXuTPK6xfScdYPxrKTIOBpehY FrN/gmfPolFcXhnB3jIGAgRaReGST4QpztID0eKqkyVQC6CJiATPlrUCY0B6R7jAOjiwkfaZPPVs6J U6EoGv8HCB15VVbAb3bu5VVjxrWcwdRdd6qLS6PLRN6dyxkb7wLvezTL5BKUQVzUU6qbvsyAGnrd7x 0ssH9guu2v8rlNtfLeaTULukGJx0q2pEL/1pDY1jKC/jhiN3HfhH3nrVx3E9D4XbzmyRAQLJ7P7fsk R5RmWBgGemKXTmc0/w31NRIAwPkHxrTK/FLbu6hiStZlCDtnSlf7Rsw6moc30D2w+YGExSbligtfCW lYQa7df47c/YdjMfUSr90hLn54qqnBYlhi4myMnu6aYq9PBergXmXl2J9FDTb7Emq8qxQ2UhzwDY/I PrQ5rf+J0T/HkGpJZ1tBNJbGq3klex06DnYsA+w0HXdEI=
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

