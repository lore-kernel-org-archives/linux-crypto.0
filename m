Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A27C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 07:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7EB164FCA
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 07:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhCJH2q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Mar 2021 02:28:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229904AbhCJH23 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Mar 2021 02:28:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2420D64FCA;
        Wed, 10 Mar 2021 07:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615361309;
        bh=R0OfRjGvzNSRJ02U22rhwrhu7SCjsKqyME6WkyEIXjY=;
        h=From:To:Cc:Subject:Date:From;
        b=cp0cg9KnQ9eV2/ICgNK/FygpPCaxovjdDiUKKcUEsCyN8tU8DsG0dATUtn+Ga/Ht4
         nPW5NK40l6QFH+w6NSqZ2XlXodaRGXVQzXLzXF3pNcUN91aZzvnQwDG/bvxSwVraNf
         nDjpa74TOU46fL4FNEPJ+rjZokdOUbYSDpwo/lV8qcyI5AY44kmkLOcEPE1ur2vTmN
         C3QYQ1RTlK3YjpZr6RSIJNqKr/dG1oqFcTqsx6w/32MSnwdYoaQXjVhlJB3y8i4p8v
         aKrw8d9aPhxPXwAMih5bhEye58XU0I8x+31ocRLHjPWxQoBQ0QqOOggSYI4bdoOpm9
         fbwsqBJ1WmslA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org
Subject: [PATCH] crypto: arm/blake2s - fix for big endian
Date:   Tue,  9 Mar 2021 23:27:26 -0800
Message-Id: <20210310072726.288252-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The new ARM BLAKE2s code doesn't work correctly (fails the self-tests)
in big endian kernel builds because it doesn't swap the endianness of
the message words when loading them.  Fix this.

Fixes: 5172d322d34c ("crypto: arm/blake2s - add ARM scalar optimized BLAKE2s")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/blake2s-core.S | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/crypto/blake2s-core.S b/arch/arm/crypto/blake2s-core.S
index bed897e9a181a..86345751bbf3a 100644
--- a/arch/arm/crypto/blake2s-core.S
+++ b/arch/arm/crypto/blake2s-core.S
@@ -8,6 +8,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/assembler.h>
 
 	// Registers used to hold message words temporarily.  There aren't
 	// enough ARM registers to hold the whole message block, so we have to
@@ -38,6 +39,23 @@
 #endif
 .endm
 
+.macro _le32_bswap	a, tmp
+#ifdef __ARMEB__
+	rev_l		\a, \tmp
+#endif
+.endm
+
+.macro _le32_bswap_8x	a, b, c, d, e, f, g, h,  tmp
+	_le32_bswap	\a, \tmp
+	_le32_bswap	\b, \tmp
+	_le32_bswap	\c, \tmp
+	_le32_bswap	\d, \tmp
+	_le32_bswap	\e, \tmp
+	_le32_bswap	\f, \tmp
+	_le32_bswap	\g, \tmp
+	_le32_bswap	\h, \tmp
+.endm
+
 // Execute a quarter-round of BLAKE2s by mixing two columns or two diagonals.
 // (a0, b0, c0, d0) and (a1, b1, c1, d1) give the registers containing the two
 // columns/diagonals.  s0-s1 are the word offsets to the message words the first
@@ -180,8 +198,10 @@ ENTRY(blake2s_compress_arch)
 	tst		r1, #3
 	bne		.Lcopy_block_misaligned
 	ldmia		r1!, {r2-r9}
+	_le32_bswap_8x	r2, r3, r4, r5, r6, r7, r8, r9,  r14
 	stmia		r12!, {r2-r9}
 	ldmia		r1!, {r2-r9}
+	_le32_bswap_8x	r2, r3, r4, r5, r6, r7, r8, r9,  r14
 	stmia		r12, {r2-r9}
 .Lcopy_block_done:
 	str		r1, [sp, #68]		// Update message pointer
@@ -268,6 +288,7 @@ ENTRY(blake2s_compress_arch)
 1:
 #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 	ldr		r3, [r1], #4
+	_le32_bswap	r3, r4
 #else
 	ldrb		r3, [r1, #0]
 	ldrb		r4, [r1, #1]
-- 
2.30.1

