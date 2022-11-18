Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B30C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 09:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241702AbiKRJEs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241712AbiKRJEQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 04:04:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4815E13D4F
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 01:04:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE6D1B82274
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 09:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8187AC43146;
        Fri, 18 Nov 2022 09:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668762249;
        bh=fc2JKYQatpTxXu11VT4a3V3fN6ivlyjI0KHBLOLHcEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWBHjlxK1blh/DEay6JaIGEL7wJIjBmtDxcPiGMfrHpdnkXk+LoFlctITaF3RXAYV
         2yWhgt/dqlHzVPsnZthunPoK6jWayfFXHAD6LUeActAsOQ8ePYimylbS5Kz7BRh8oj
         hzDBNypHtok8kY0GHME3FQbOZZgA420/7KWbEY0uCwenBN4Kdp+SbSWcI2wcaITHuP
         3vVdytMQFZYh14BrSbYisTfcmf8u34OleBaax7luuOy+9SX3OT7ImWs7FGdn2yoMBi
         KuLCzI2RD8DYd6sIbjyWH13Sa0UJqcfyybEMoAvCiY6CVmQ2BK2dHRazBnf4TQ4NEg
         pAKiN/iYuB9uA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 08/11] crypto: arm64/nhpoly1305 - eliminate unnecessary CFI wrapper
Date:   Fri, 18 Nov 2022 01:02:17 -0800
Message-Id: <20221118090220.398819-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118090220.398819-1-ebiggers@kernel.org>
References: <20221118090220.398819-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Since the CFI implementation now supports indirect calls to assembly
functions, take advantage of that rather than use a wrapper function.

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

