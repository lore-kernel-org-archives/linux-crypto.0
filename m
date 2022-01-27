Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 260B3C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 08:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbiA0IMp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 03:12:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57968 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbiA0IMo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 03:12:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF471B821C9
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 08:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA58C340E6;
        Thu, 27 Jan 2022 08:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643271161;
        bh=rNG85CkQHYUoADadt+1RadTkg6tLzQAOOLmWYflMaxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3RU8fwSS+cDYuRYfBHneJWtALJDh5kgeYJH8ysYF333OLiyhyzjeAru52aaqqXVh
         6u7uEtQFB4xgH63fzB/xTGDTQbIATFoxf3eH2uoIo5Y31FVVncHWiBBJ561Kr1ehcb
         x4w+kZZ4PvtDtAeyU82Tb17Ij4DmbhtQFYqkOvS9lQptZEvJFJbbQnCcdBXbkXDVHP
         5pIWqi2XURMKHWZrUYgqNFsFKjltavgJyJTOYPu92Ae5cmsr+J6hENTkk1Bdz56PEo
         oM4Puo8UqDDCy/GrKmOeMDF8TJz6YtNm3ENCSd4hi4IjgrMOrORPdrA46+D1PskXva
         n/IqdAtAT+LPQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 2/2] crypto: arm/xor - make vectorized C code Clang-friendly
Date:   Thu, 27 Jan 2022 09:12:27 +0100
Message-Id: <20220127081227.2430-3-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127081227.2430-1-ardb@kernel.org>
References: <20220127081227.2430-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1904; h=from:subject; bh=rNG85CkQHYUoADadt+1RadTkg6tLzQAOOLmWYflMaxo=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh8lPqrXdKXgXsJZzdBhWSqiwt6LyXOJcJIMg04C0M v7yv+c2JAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYfJT6gAKCRDDTyI5ktmPJBSRDA C4Lg58KgAAHe9V8R6ZHoUC8hNPk93Fh5ycqujLA0Sf9f5IBx+qrtso9cXW6trn/90Rqf0s/3CBO9N1 SaHu2ERAeZS1CEEZdS2U6RqbbVvXxbexhk4NnB35YJxvkifTNnzkQIWvKazdz+jf5cy8pT56tQ1r4H uGzcYOfgmz0RESzjZuI+ymkIghe2WLiO6x+6RSwvCKRraf9YvWk6L0g/YbSx1f8x3l4OjFGkEZ9tBr afiEt45LXVhd8WQfMg2W+GUqTzXyBFVzeDOsS4v9roalbQ9UzfmrqacKf9Rv/r84dgrud9V8AZsx/M mFYw4/39XqqT1j7nfi9FENoHfKdsC6ZkVjuDwMVJEN7Pppi3d0W+GRX7ohejucggQL7avLfJsH/UW4 GEewzEHjxlOGxAQkgd+095iPY2UwjasnJB7uwL8TEm382V65Ld1zmxHuweLlmO9jNYejiY9dsivIzN Hf/5lLTGZD1OQP/29QCMo/0FcjgzANtLHurmgO2LvGPiU=
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

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
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

