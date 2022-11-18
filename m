Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F60FC4321E
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 19:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235453AbiKRTqc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 14:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235220AbiKRTq3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 14:46:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31788CF0D
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 11:46:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B5956276D
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 19:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23D2C43140;
        Fri, 18 Nov 2022 19:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668800784;
        bh=EjO3B77EIOTiWRygSBkRyIXiyATPysPcP7wmb2ToCDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHXo4sVaL3o8Zv5oH/58o8qIXTUaVmfy/xvsdGatFdPmp72sZHeiCQamxe+6zQLsv
         OrtAe1wOfSxzp+zI/VCoo9wVEipbCdEj5JmFl965KkqVSp35U4Se/YvdlPGFpqfpfO
         29qfQnUPE6rtrRt3x6LORz70j1MH2sk7M1heQar6wUhUoRsIdcorRcrZYafkhOU46f
         aFzNTyKA2fJNvXLm+ETMq9XrfxIpnJh4iIS5V7uncd4KkSvJ+sZGsV3d//tn8BUU0/
         SxmOROrRMkYf7tWReVw+SrizAR1o/plLqnHF/tF5BQ5HPjG/S4N6dJacB4XgPnGus0
         lgPGT5ayQVuiw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH v2 03/12] crypto: x86/nhpoly1305 - eliminate unnecessary CFI wrappers
Date:   Fri, 18 Nov 2022 11:44:12 -0800
Message-Id: <20221118194421.160414-4-ebiggers@kernel.org>
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
functions, take advantage of that rather than use wrapper functions.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/nh-avx2-x86_64.S       |  5 +++--
 arch/x86/crypto/nh-sse2-x86_64.S       |  5 +++--
 arch/x86/crypto/nhpoly1305-avx2-glue.c | 11 ++---------
 arch/x86/crypto/nhpoly1305-sse2-glue.c | 11 ++---------
 4 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/arch/x86/crypto/nh-avx2-x86_64.S b/arch/x86/crypto/nh-avx2-x86_64.S
index 6a0b15e7196a8..ef73a3ab87263 100644
--- a/arch/x86/crypto/nh-avx2-x86_64.S
+++ b/arch/x86/crypto/nh-avx2-x86_64.S
@@ -8,6 +8,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 #define		PASS0_SUMS	%ymm0
 #define		PASS1_SUMS	%ymm1
@@ -65,11 +66,11 @@
 
 /*
  * void nh_avx2(const u32 *key, const u8 *message, size_t message_len,
- *		u8 hash[NH_HASH_BYTES])
+ *		__le64 hash[NH_NUM_PASSES])
  *
  * It's guaranteed that message_len % 16 == 0.
  */
-SYM_FUNC_START(nh_avx2)
+SYM_TYPED_FUNC_START(nh_avx2)
 
 	vmovdqu		0x00(KEY), K0
 	vmovdqu		0x10(KEY), K1
diff --git a/arch/x86/crypto/nh-sse2-x86_64.S b/arch/x86/crypto/nh-sse2-x86_64.S
index 34c567bbcb4fa..75fb994b6d177 100644
--- a/arch/x86/crypto/nh-sse2-x86_64.S
+++ b/arch/x86/crypto/nh-sse2-x86_64.S
@@ -8,6 +8,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 #define		PASS0_SUMS	%xmm0
 #define		PASS1_SUMS	%xmm1
@@ -67,11 +68,11 @@
 
 /*
  * void nh_sse2(const u32 *key, const u8 *message, size_t message_len,
- *		u8 hash[NH_HASH_BYTES])
+ *		__le64 hash[NH_NUM_PASSES])
  *
  * It's guaranteed that message_len % 16 == 0.
  */
-SYM_FUNC_START(nh_sse2)
+SYM_TYPED_FUNC_START(nh_sse2)
 
 	movdqu		0x00(KEY), K0
 	movdqu		0x10(KEY), K1
diff --git a/arch/x86/crypto/nhpoly1305-avx2-glue.c b/arch/x86/crypto/nhpoly1305-avx2-glue.c
index 8ea5ab0f1ca74..46b036204ed91 100644
--- a/arch/x86/crypto/nhpoly1305-avx2-glue.c
+++ b/arch/x86/crypto/nhpoly1305-avx2-glue.c
@@ -14,14 +14,7 @@
 #include <asm/simd.h>
 
 asmlinkage void nh_avx2(const u32 *key, const u8 *message, size_t message_len,
-			u8 hash[NH_HASH_BYTES]);
-
-/* wrapper to avoid indirect call to assembly, which doesn't work with CFI */
-static void _nh_avx2(const u32 *key, const u8 *message, size_t message_len,
-		     __le64 hash[NH_NUM_PASSES])
-{
-	nh_avx2(key, message, message_len, (u8 *)hash);
-}
+			__le64 hash[NH_NUM_PASSES]);
 
 static int nhpoly1305_avx2_update(struct shash_desc *desc,
 				  const u8 *src, unsigned int srclen)
@@ -33,7 +26,7 @@ static int nhpoly1305_avx2_update(struct shash_desc *desc,
 		unsigned int n = min_t(unsigned int, srclen, SZ_4K);
 
 		kernel_fpu_begin();
-		crypto_nhpoly1305_update_helper(desc, src, n, _nh_avx2);
+		crypto_nhpoly1305_update_helper(desc, src, n, nh_avx2);
 		kernel_fpu_end();
 		src += n;
 		srclen -= n;
diff --git a/arch/x86/crypto/nhpoly1305-sse2-glue.c b/arch/x86/crypto/nhpoly1305-sse2-glue.c
index 2b353d42ed13f..4a4970d751076 100644
--- a/arch/x86/crypto/nhpoly1305-sse2-glue.c
+++ b/arch/x86/crypto/nhpoly1305-sse2-glue.c
@@ -14,14 +14,7 @@
 #include <asm/simd.h>
 
 asmlinkage void nh_sse2(const u32 *key, const u8 *message, size_t message_len,
-			u8 hash[NH_HASH_BYTES]);
-
-/* wrapper to avoid indirect call to assembly, which doesn't work with CFI */
-static void _nh_sse2(const u32 *key, const u8 *message, size_t message_len,
-		     __le64 hash[NH_NUM_PASSES])
-{
-	nh_sse2(key, message, message_len, (u8 *)hash);
-}
+			__le64 hash[NH_NUM_PASSES]);
 
 static int nhpoly1305_sse2_update(struct shash_desc *desc,
 				  const u8 *src, unsigned int srclen)
@@ -33,7 +26,7 @@ static int nhpoly1305_sse2_update(struct shash_desc *desc,
 		unsigned int n = min_t(unsigned int, srclen, SZ_4K);
 
 		kernel_fpu_begin();
-		crypto_nhpoly1305_update_helper(desc, src, n, _nh_sse2);
+		crypto_nhpoly1305_update_helper(desc, src, n, nh_sse2);
 		kernel_fpu_end();
 		src += n;
 		srclen -= n;
-- 
2.38.1

