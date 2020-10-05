Return-Path: <SRS0=TLUI=DM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3138C46466
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 18:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7271520853
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 18:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbgJESSG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Oct 2020 14:18:06 -0400
Received: from foss.arm.com ([217.140.110.172]:54990 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbgJESSG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Oct 2020 14:18:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C62A1113E;
        Mon,  5 Oct 2020 11:18:05 -0700 (PDT)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BCD2D3F71F;
        Mon,  5 Oct 2020 11:18:05 -0700 (PDT)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     linux-crypto@vger.kernel.org, broonie@kernel.org, ardb@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        Jeremy Linton <jeremy.linton@arm.com>
Subject: [BUG][PATCH] arm64: bti: fix BTI to handle local indirect branches
Date:   Mon,  5 Oct 2020 13:18:04 -0500
Message-Id: <20201005181804.1331237-1-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The AES code uses a 'br x7' as part of a function called by
a macro, that ends up needing a BTI_J as a target. Lets
define SYN_CODE_START_LOCAL() for this and replace the
SYM_FUNC_START_LOCAL with a SYM_FUNC_CODE_LOCAL in the AES block.

Without this kernels compiled with the aes_neon_bs will OOPS
at boot.

  Bad mode in Synchronous Abort handler detected on CPU1, code 0x34000003 -- BTI
  CPU: 1 PID: 265 Comm: cryptomgr_test Not tainted 5.8.11-300.fc33.aarch64 #1
  pstate: 20400c05 (nzCv daif +PAN -UAO BTYPE=j-)
  pc : aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
  lr : aesbs_xts_encrypt+0x48/0xe0 [aes_neon_bs]
  sp : ffff80001052b730
  x29: ffff80001052b730 x28: 0000000000000001
  x27: ffff0001ec8f4000 x26: ffff0001ec5d27b0
  x25: ffff0001ec8f4000 x24: ffff80001052bc00
  x23: 0000000000000018 x22: 000000000000000a
  x21: ffff0001ec5d2100 x20: ffff0001ec8f4080
  x19: ffff0001ec8f4000 x18: 0000000000000004
  x17: 0000000000000000 x16: ffffadb4db85d310
  x15: 0000000000000200 x14: 0000000000000010
  x13: 0000000000000200 x12: ffff0001ec5d2100
  x11: 000000000000000a x10: 0000020000200000
  x9 : ffffadb4db7e7488 x8 : 0000000000000000
  x7 : ffffadb4614fb110 x6 : 0000000000000000
  x5 : ffff80001052bc00 x4 : 0000000000000020
  x3 : 000000000000000a x2 : ffff0001ec5d2100
  x1 : ffff0001ec8f4000 x0 : ffff0001ec8f4000
  Kernel panic - not syncing: bad mode
  CPU: 1 PID: 265 Comm: cryptomgr_test Not tainted 5.8.11-300.fc33.aarch64 #1
  Call trace:
   dump_backtrace+0x0/0x1c0
   show_stack+0x24/0x30
   dump_stack+0xc0/0x118
   panic+0x144/0x358
   arm64_serror_panic+0x0/0x98
   el1_sync_handler+0x60/0x110
   el1_sync+0xb4/0x180
   aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
   __xts_crypt+0xb0/0x2dc [aes_neon_bs]
   xts_encrypt+0x28/0x3c [aes_neon_bs]
  crypto_skcipher_encrypt+0x50/0x84
  simd_skcipher_encrypt+0xc8/0xe0
  crypto_skcipher_encrypt+0x50/0x84
  test_skcipher_vec_cfg+0x224/0x5f0
  test_skcipher+0xbc/0x120
  alg_test_skcipher+0xa0/0x1b0
  alg_test+0x3dc/0x47c
  cryptomgr_test+0x38/0x60
  kthread+0x11c/0x120
  ret_from_fork+0x10/0x18
 SMP: stopping secondary CPUs
 Kernel Offset: 0x2db4cb7e0000 from 0xffff800010000000
 PHYS_OFFSET: 0xffffcf2440000000
 CPU features: 0x7e0152,20c02020
 Memory Limit: none
 ---[ end Kernel panic - not syncing: bad mode ]---

Fixes: commit 0e89640b640d ("crypto: arm64 - Use modern annotations for assembly functions")
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 arch/arm64/crypto/aes-neonbs-core.S | 8 ++++----
 arch/arm64/include/asm/linkage.h    | 6 +++++-
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
index b357164379f6..76de87ee80e1 100644
--- a/arch/arm64/crypto/aes-neonbs-core.S
+++ b/arch/arm64/crypto/aes-neonbs-core.S
@@ -428,7 +428,7 @@ SYM_FUNC_START(aesbs_convert_key)
 SYM_FUNC_END(aesbs_convert_key)
 
 	.align		4
-SYM_FUNC_START_LOCAL(aesbs_encrypt8)
+SYM_CODE_START_LOCAL(aesbs_encrypt8)
 	ldr		q9, [bskey], #16		// round 0 key
 	ldr		q8, M0SR
 	ldr		q24, SR
@@ -488,10 +488,10 @@ SYM_FUNC_START_LOCAL(aesbs_encrypt8)
 	eor		v2.16b, v2.16b, v12.16b
 	eor		v5.16b, v5.16b, v12.16b
 	ret
-SYM_FUNC_END(aesbs_encrypt8)
+SYM_END(aesbs_encrypt8)
 
 	.align		4
-SYM_FUNC_START_LOCAL(aesbs_decrypt8)
+SYM_CODE_START_LOCAL(aesbs_decrypt8)
 	lsl		x9, rounds, #7
 	add		bskey, bskey, x9
 
@@ -553,7 +553,7 @@ SYM_FUNC_START_LOCAL(aesbs_decrypt8)
 	eor		v3.16b, v3.16b, v12.16b
 	eor		v5.16b, v5.16b, v12.16b
 	ret
-SYM_FUNC_END(aesbs_decrypt8)
+SYM_END(aesbs_decrypt8)
 
 	/*
 	 * aesbs_ecb_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
diff --git a/arch/arm64/include/asm/linkage.h b/arch/arm64/include/asm/linkage.h
index ba89a9af820a..92c81ae8ac1e 100644
--- a/arch/arm64/include/asm/linkage.h
+++ b/arch/arm64/include/asm/linkage.h
@@ -11,7 +11,8 @@
  * set the architecture version to v8.5 we use the hint instruction
  * instead.
  */
-#define BTI_C hint 34 ;
+#define BTI_C  hint 34 ;
+#define BTI_JC hint 38 ;
 
 /*
  * When using in-kernel BTI we need to ensure that PCS-conformant assembly
@@ -42,6 +43,9 @@
 	SYM_START(name, SYM_L_WEAK, SYM_A_NONE)		\
 	BTI_C
 
+#define SYM_CODE_START_LOCAL(name)			\
+	SYM_START(name, SYM_L_LOCAL, SYM_A_ALIGN)       \
+	BTI_JC
 #endif
 
 /*
-- 
2.25.4

