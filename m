Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE8DDC43217
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 19:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbiKRTqk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 14:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235556AbiKRTqa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 14:46:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD458CFD3
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 11:46:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8064562789
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 19:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA40C43470;
        Fri, 18 Nov 2022 19:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668800787;
        bh=Jktv+/Qu/uCCZJ2itmlKVBoDqxZ3t6fI03aW0+AnaOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0nHEAK6+gGwwvbGug2zU5o5c9AvD4J8LVD7A5I0bsJep+SZ+nLXLmWdCKLTHuToc
         gmz0GC4mEPhWbunktEF3A4pKjjUaxa0E/Ypzs2v+vJB/T8SaqYh57y1W3wFN/X7Nd/
         61MPbQJE/3yZUASVFukPNYvg50koFQy7Ied7Wye9UX5rUAA1rhBF25YYEi61gj/SId
         WoUsuILKqmHaT80VGqyHIjdSrLH/sZwobE6dKDuEZ18bLaex8VOv/Dl8HK+jZcRUYa
         nbR24R9KPBk8CLjzFvEvGg2CcDfQ26figvmVvtvbxwDp1yykkePPEj6IejOjWr75LD
         8jqOfsYpb6JgQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH v2 11/12] crypto: arm/nhpoly1305 - eliminate unnecessary CFI wrapper
Date:   Fri, 18 Nov 2022 11:44:20 -0800
Message-Id: <20221118194421.160414-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118194421.160414-1-ebiggers@kernel.org>
References: <20221118194421.160414-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The arm architecture doesn't support CFI yet, and even if it did, the
new CFI implementation supports indirect calls to assembly functions.
Therefore, there's no need to use a wrapper function for nh_neon().

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/nh-neon-core.S         |  2 +-
 arch/arm/crypto/nhpoly1305-neon-glue.c | 11 ++---------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/arm/crypto/nh-neon-core.S b/arch/arm/crypto/nh-neon-core.S
index 434d80ab531c2..01620a0782ca9 100644
--- a/arch/arm/crypto/nh-neon-core.S
+++ b/arch/arm/crypto/nh-neon-core.S
@@ -69,7 +69,7 @@
 
 /*
  * void nh_neon(const u32 *key, const u8 *message, size_t message_len,
- *		u8 hash[NH_HASH_BYTES])
+ *		__le64 hash[NH_NUM_PASSES])
  *
  * It's guaranteed that message_len % 16 == 0.
  */
diff --git a/arch/arm/crypto/nhpoly1305-neon-glue.c b/arch/arm/crypto/nhpoly1305-neon-glue.c
index ffa8d73fe722c..e93e41ff26566 100644
--- a/arch/arm/crypto/nhpoly1305-neon-glue.c
+++ b/arch/arm/crypto/nhpoly1305-neon-glue.c
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

