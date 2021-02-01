Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A1FDC433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4124364EA0
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhBASDm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Feb 2021 13:03:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229831AbhBASDl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Feb 2021 13:03:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 300F564EA0;
        Mon,  1 Feb 2021 18:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612202580;
        bh=YULinnlkuCAewuzhstFApRJ5DhxdsVgZHgBAlOivg18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GghINnXtjTrGjyv77GvlmxIC07QRqAZbKvcRa1VA8u655bZjEl1gAVCvbmiI0PjbZ
         Q6t2op79nIe/AAkPdEpt4U19ex2Mzp2wfEEfktnGXjd/0PB/e/vu920Frhsg3a4LbS
         KHeSMXEDVEySsVOY1yl0yAeYKT1AuIvDH+m4LKraBHWgYWpFoRpxFi+DU4Uz4ETe+L
         3Qz2EERB+9qbG2S7JepzRm+YugWg1KPNEIfaqTEfqn6/V2C80ptG0u9LE8E5X8nT/X
         +D6qUM6oGvQyCQGu0i+ufK+Q+Gaf31EYoKihLikYPlj3u6wf89tRcfahRYNwXzJfWn
         nae/znKfHvqmw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 3/9] crypto: serpent - use unaligned accessors instead of alignmask
Date:   Mon,  1 Feb 2021 19:02:31 +0100
Message-Id: <20210201180237.3171-4-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210201180237.3171-1-ardb@kernel.org>
References: <20210201180237.3171-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of using an alignmask of 0x3 to ensure 32-bit alignment of the
Serpent input and output blocks, which propagates to mode drivers, and
results in pointless copying on architectures that don't care about
alignment, use the unaligned accessors, which will do the right thing on
each respective architecture, avoiding the need for double buffering.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/serpent_generic.c | 44 ++++++++------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
index a932e0b2964f..236c87547a17 100644
--- a/crypto/serpent_generic.c
+++ b/crypto/serpent_generic.c
@@ -10,7 +10,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/errno.h>
-#include <asm/byteorder.h>
+#include <asm/unaligned.h>
 #include <linux/crypto.h>
 #include <linux/types.h>
 #include <crypto/serpent.h>
@@ -448,19 +448,12 @@ void __serpent_encrypt(const void *c, u8 *dst, const u8 *src)
 {
 	const struct serpent_ctx *ctx = c;
 	const u32 *k = ctx->expkey;
-	const __le32 *s = (const __le32 *)src;
-	__le32	*d = (__le32 *)dst;
 	u32	r0, r1, r2, r3, r4;
 
-/*
- * Note: The conversions between u8* and u32* might cause trouble
- * on architectures with stricter alignment rules than x86
- */
-
-	r0 = le32_to_cpu(s[0]);
-	r1 = le32_to_cpu(s[1]);
-	r2 = le32_to_cpu(s[2]);
-	r3 = le32_to_cpu(s[3]);
+	r0 = get_unaligned_le32(src);
+	r1 = get_unaligned_le32(src + 4);
+	r2 = get_unaligned_le32(src + 8);
+	r3 = get_unaligned_le32(src + 12);
 
 					K(r0, r1, r2, r3, 0);
 	S0(r0, r1, r2, r3, r4);		LK(r2, r1, r3, r0, r4, 1);
@@ -496,10 +489,10 @@ void __serpent_encrypt(const void *c, u8 *dst, const u8 *src)
 	S6(r0, r1, r3, r2, r4);		LK(r3, r4, r1, r2, r0, 31);
 	S7(r3, r4, r1, r2, r0);		K(r0, r1, r2, r3, 32);
 
-	d[0] = cpu_to_le32(r0);
-	d[1] = cpu_to_le32(r1);
-	d[2] = cpu_to_le32(r2);
-	d[3] = cpu_to_le32(r3);
+	put_unaligned_le32(r0, dst);
+	put_unaligned_le32(r1, dst + 4);
+	put_unaligned_le32(r2, dst + 8);
+	put_unaligned_le32(r3, dst + 12);
 }
 EXPORT_SYMBOL_GPL(__serpent_encrypt);
 
@@ -514,14 +507,12 @@ void __serpent_decrypt(const void *c, u8 *dst, const u8 *src)
 {
 	const struct serpent_ctx *ctx = c;
 	const u32 *k = ctx->expkey;
-	const __le32 *s = (const __le32 *)src;
-	__le32	*d = (__le32 *)dst;
 	u32	r0, r1, r2, r3, r4;
 
-	r0 = le32_to_cpu(s[0]);
-	r1 = le32_to_cpu(s[1]);
-	r2 = le32_to_cpu(s[2]);
-	r3 = le32_to_cpu(s[3]);
+	r0 = get_unaligned_le32(src);
+	r1 = get_unaligned_le32(src + 4);
+	r2 = get_unaligned_le32(src + 8);
+	r3 = get_unaligned_le32(src + 12);
 
 					K(r0, r1, r2, r3, 32);
 	SI7(r0, r1, r2, r3, r4);	KL(r1, r3, r0, r4, r2, 31);
@@ -557,10 +548,10 @@ void __serpent_decrypt(const void *c, u8 *dst, const u8 *src)
 	SI1(r3, r1, r2, r0, r4);	KL(r4, r1, r2, r0, r3, 1);
 	SI0(r4, r1, r2, r0, r3);	K(r2, r3, r1, r4, 0);
 
-	d[0] = cpu_to_le32(r2);
-	d[1] = cpu_to_le32(r3);
-	d[2] = cpu_to_le32(r1);
-	d[3] = cpu_to_le32(r4);
+	put_unaligned_le32(r2, dst);
+	put_unaligned_le32(r3, dst + 4);
+	put_unaligned_le32(r1, dst + 8);
+	put_unaligned_le32(r4, dst + 12);
 }
 EXPORT_SYMBOL_GPL(__serpent_decrypt);
 
@@ -578,7 +569,6 @@ static struct crypto_alg srp_alg = {
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	SERPENT_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct serpent_ctx),
-	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{ .cipher = {
 	.cia_min_keysize	=	SERPENT_MIN_KEY_SIZE,
-- 
2.20.1

