Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A626C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 19:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241649AbiKRTqm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 14:46:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235533AbiKRTqa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 14:46:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8522813D53
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 11:46:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D94F62784
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 19:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89731C433D6;
        Fri, 18 Nov 2022 19:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668800786;
        bh=X+7N1v7Ylhc12ODIGzGIdWud9IGuRB4PQ36hvFoPOac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtCymIaJdlKGgicPDjzScEGeZBPbUtIgcMmx+JdSB+XgIeGV2D9NzjsYFOZBKJxbC
         mTmt6DKomct3OOuoZhJivhmhqsmBxhXZlaGdj6nyQ9/vOcZHlV6EybyfhnEphUV45W
         UzW60U0Jo4lFOKdgseR19Ex2eWkHZscbJJdsANorpstc7QhK4MzZN5bqV6KeZTNCmC
         4fFMhbXOX7C4u9+jxk4WeZ+y/lJ9fDhD76a4ZhGDLUk5uRVAmKB5ngqS1dTOHcsPeN
         8hG6t1IxUJsakY7i/b20aE0Q8HjbaCGCpMcAX0zH/XZxEmcE0EisvfQcxC38pCPBlZ
         B1Q5hcLouLkaA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH v2 09/12] crypto: arm64/nhpoly1305 - eliminate unnecessary CFI wrapper
Date:   Fri, 18 Nov 2022 11:44:18 -0800
Message-Id: <20221118194421.160414-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118194421.160414-1-ebiggers@kernel.org>
References: <20221118194421.160414-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Since the CFI implementation now supports indirect calls to assembly
functions, take advantage of that rather than use a wrapper function.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/nh-neon-core.S         |  5 +++--
 arch/arm64/crypto/nhpoly1305-neon-glue.c | 11 ++---------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/crypto/nh-neon-core.S b/arch/arm64/crypto/nh-neon-core.S
index 51c0a534ef87c..13eda08fda1e5 100644
--- a/arch/arm64/crypto/nh-neon-core.S
+++ b/arch/arm64/crypto/nh-neon-core.S
@@ -8,6 +8,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 	KEY		.req	x0
 	MESSAGE		.req	x1
@@ -58,11 +59,11 @@
 
 /*
  * void nh_neon(const u32 *key, const u8 *message, size_t message_len,
- *		u8 hash[NH_HASH_BYTES])
+ *		__le64 hash[NH_NUM_PASSES])
  *
  * It's guaranteed that message_len % 16 == 0.
  */
-SYM_FUNC_START(nh_neon)
+SYM_TYPED_FUNC_START(nh_neon)
 
 	ld1		{K0.4s,K1.4s}, [KEY], #32
 	  movi		PASS0_SUMS.2d, #0
diff --git a/arch/arm64/crypto/nhpoly1305-neon-glue.c b/arch/arm64/crypto/nhpoly1305-neon-glue.c
index c5405e6a6db76..cd882c35d9252 100644
--- a/arch/arm64/crypto/nhpoly1305-neon-glue.c
+++ b/arch/arm64/crypto/nhpoly1305-neon-glue.c
@@ -14,14 +14,7 @@
 #include <linux/module.h>
 
 asmlinkage void nh_neon(const u32 *key, const u8 *message, size_t message_len,
-			u8 hash[NH_HASH_BYTES]);
-
-/* wrapper to avoid indirect call to assembly, which doesn't work with CFI */
-static void _nh_neon(const u32 *key, const u8 *message, size_t message_len,
-		     __le64 hash[NH_NUM_PASSES])
-{
-	nh_neon(key, message, message_len, (u8 *)hash);
-}
+			__le64 hash[NH_NUM_PASSES]);
 
 static int nhpoly1305_neon_update(struct shash_desc *desc,
 				  const u8 *src, unsigned int srclen)
@@ -33,7 +26,7 @@ static int nhpoly1305_neon_update(struct shash_desc *desc,
 		unsigned int n = min_t(unsigned int, srclen, SZ_4K);
 
 		kernel_neon_begin();
-		crypto_nhpoly1305_update_helper(desc, src, n, _nh_neon);
+		crypto_nhpoly1305_update_helper(desc, src, n, nh_neon);
 		kernel_neon_end();
 		src += n;
 		srclen -= n;
-- 
2.38.1

