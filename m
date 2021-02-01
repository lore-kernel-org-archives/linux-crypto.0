Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A358DC433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57A5B64EAA
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhBASEU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Feb 2021 13:04:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhBASET (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Feb 2021 13:04:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06AE364EA9;
        Mon,  1 Feb 2021 18:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612202586;
        bh=iJ33YdErUvCXsq+ZFQjFu55GbmWN6ibQM4OajKfZIXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3+gMfw6VOkhgwVRtuox47wXU1O+42C5tTcZT+DNrVeKtzvh6+RRbRtoDbXkvl6dT
         pnQKudfL+3QNhQchu3zMXeQ1559ADw04G4KP2d/jjBe1G/z0mn6c11XMur1p5uDx5q
         a9wUpZ6HIY4SU7FfHSoiXvpk70zlU0iIei2JeQogDtDmDWKF/XqwxtjBWAQxNAVHXJ
         cKX02woUpGSFRR6n56Oe/QwzFGWUNfIIJQAsJRR92+wut5wrZi61yx4OzLNjQ1wEWV
         nTWoAvcEOkzTefwejw8/jagwWDavrPCOf6sTyfBX34Hmp9MyrlWOb7wDI6dMz0u9P+
         2ztsOuv23qzkQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 7/9] crypto: cast6 - use unaligned accessors instead of alignmask
Date:   Mon,  1 Feb 2021 19:02:35 +0100
Message-Id: <20210201180237.3171-8-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210201180237.3171-1-ardb@kernel.org>
References: <20210201180237.3171-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of using an alignmask of 0x3 to ensure 32-bit alignment of the
CAST6 input and output blocks, which propagates to mode drivers, and
results in pointless copying on architectures that don't care about
alignment, use the unaligned accessors, which will do the right thing on
each respective architecture, avoiding the need for double buffering.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/cast6_generic.c | 39 +++++++++-----------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/crypto/cast6_generic.c b/crypto/cast6_generic.c
index c77ff6c8a2b2..75346380aa0b 100644
--- a/crypto/cast6_generic.c
+++ b/crypto/cast6_generic.c
@@ -10,7 +10,7 @@
  */
 
 
-#include <asm/byteorder.h>
+#include <asm/unaligned.h>
 #include <linux/init.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
@@ -172,16 +172,14 @@ static inline void QBAR(u32 *block, const u8 *Kr, const u32 *Km)
 void __cast6_encrypt(const void *ctx, u8 *outbuf, const u8 *inbuf)
 {
 	const struct cast6_ctx *c = ctx;
-	const __be32 *src = (const __be32 *)inbuf;
-	__be32 *dst = (__be32 *)outbuf;
 	u32 block[4];
 	const u32 *Km;
 	const u8 *Kr;
 
-	block[0] = be32_to_cpu(src[0]);
-	block[1] = be32_to_cpu(src[1]);
-	block[2] = be32_to_cpu(src[2]);
-	block[3] = be32_to_cpu(src[3]);
+	block[0] = get_unaligned_be32(inbuf);
+	block[1] = get_unaligned_be32(inbuf + 4);
+	block[2] = get_unaligned_be32(inbuf + 8);
+	block[3] = get_unaligned_be32(inbuf + 12);
 
 	Km = c->Km[0]; Kr = c->Kr[0]; Q(block, Kr, Km);
 	Km = c->Km[1]; Kr = c->Kr[1]; Q(block, Kr, Km);
@@ -196,10 +194,10 @@ void __cast6_encrypt(const void *ctx, u8 *outbuf, const u8 *inbuf)
 	Km = c->Km[10]; Kr = c->Kr[10]; QBAR(block, Kr, Km);
 	Km = c->Km[11]; Kr = c->Kr[11]; QBAR(block, Kr, Km);
 
-	dst[0] = cpu_to_be32(block[0]);
-	dst[1] = cpu_to_be32(block[1]);
-	dst[2] = cpu_to_be32(block[2]);
-	dst[3] = cpu_to_be32(block[3]);
+	put_unaligned_be32(block[0], outbuf);
+	put_unaligned_be32(block[1], outbuf + 4);
+	put_unaligned_be32(block[2], outbuf + 8);
+	put_unaligned_be32(block[3], outbuf + 12);
 }
 EXPORT_SYMBOL_GPL(__cast6_encrypt);
 
@@ -211,16 +209,14 @@ static void cast6_encrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
 void __cast6_decrypt(const void *ctx, u8 *outbuf, const u8 *inbuf)
 {
 	const struct cast6_ctx *c = ctx;
-	const __be32 *src = (const __be32 *)inbuf;
-	__be32 *dst = (__be32 *)outbuf;
 	u32 block[4];
 	const u32 *Km;
 	const u8 *Kr;
 
-	block[0] = be32_to_cpu(src[0]);
-	block[1] = be32_to_cpu(src[1]);
-	block[2] = be32_to_cpu(src[2]);
-	block[3] = be32_to_cpu(src[3]);
+	block[0] = get_unaligned_be32(inbuf);
+	block[1] = get_unaligned_be32(inbuf + 4);
+	block[2] = get_unaligned_be32(inbuf + 8);
+	block[3] = get_unaligned_be32(inbuf + 12);
 
 	Km = c->Km[11]; Kr = c->Kr[11]; Q(block, Kr, Km);
 	Km = c->Km[10]; Kr = c->Kr[10]; Q(block, Kr, Km);
@@ -235,10 +231,10 @@ void __cast6_decrypt(const void *ctx, u8 *outbuf, const u8 *inbuf)
 	Km = c->Km[1]; Kr = c->Kr[1]; QBAR(block, Kr, Km);
 	Km = c->Km[0]; Kr = c->Kr[0]; QBAR(block, Kr, Km);
 
-	dst[0] = cpu_to_be32(block[0]);
-	dst[1] = cpu_to_be32(block[1]);
-	dst[2] = cpu_to_be32(block[2]);
-	dst[3] = cpu_to_be32(block[3]);
+	put_unaligned_be32(block[0], outbuf);
+	put_unaligned_be32(block[1], outbuf + 4);
+	put_unaligned_be32(block[2], outbuf + 8);
+	put_unaligned_be32(block[3], outbuf + 12);
 }
 EXPORT_SYMBOL_GPL(__cast6_decrypt);
 
@@ -254,7 +250,6 @@ static struct crypto_alg alg = {
 	.cra_flags = CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize = CAST6_BLOCK_SIZE,
 	.cra_ctxsize = sizeof(struct cast6_ctx),
-	.cra_alignmask = 3,
 	.cra_module = THIS_MODULE,
 	.cra_u = {
 		  .cipher = {
-- 
2.20.1

