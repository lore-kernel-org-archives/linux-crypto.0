Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E186C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EADB64E9C
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhBASDs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Feb 2021 13:03:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhBASDm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Feb 2021 13:03:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97E3464EB8;
        Mon,  1 Feb 2021 18:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612202581;
        bh=F8NI4gGlhEPKGSsSKx1da+fnX3qID97zd5EPihO9rf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=helaF0sQI5XQDh8TvY4B1wpk8rk7DLnNy3GJFFkL81Twa1idM45VmYPx3peXl1YqR
         Lr2VZK7aYoic7rmm/85YUPtkBBM0snHVrr2HU4cPCz3+Xi3Fd8KQkCuV4xZUQLWvlP
         GvgTbKJsrBEtiAOfHRboPDmLFLLTwIiBzADAoCZBE46GPYwrhHYMbxyv6enx0ffRIe
         nEIHC4/3O1PQulSq6GgS+KaWD5WRK1qQIMHCA6z0Myn0HXKpn83OYGkmCW1cj1Y+Y0
         lYDtk4OJwgx10ZIx8mS/WwQ5LYLc87AWew/7f6BpCQzLL9l6EN44m5rNASJandlG2z
         BXQ+VyU7RNIEQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4/9] crypto: blowfish - use unaligned accessors instead of alignmask
Date:   Mon,  1 Feb 2021 19:02:32 +0100
Message-Id: <20210201180237.3171-5-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210201180237.3171-1-ardb@kernel.org>
References: <20210201180237.3171-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of using an alignmask of 0x3 to ensure 32-bit alignment of
the Blowfish input and output blocks, which propagates to mode drivers,
and results in pointless copying on architectures that don't care about
alignment, use the unaligned accessors, which will do the right thing on
each respective architecture, avoiding the need for double buffering.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/blowfish_generic.c | 23 ++++++++------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/crypto/blowfish_generic.c b/crypto/blowfish_generic.c
index c3c2041fe0c5..003b52c6880e 100644
--- a/crypto/blowfish_generic.c
+++ b/crypto/blowfish_generic.c
@@ -14,7 +14,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <asm/byteorder.h>
+#include <asm/unaligned.h>
 #include <linux/crypto.h>
 #include <linux/types.h>
 #include <crypto/blowfish.h>
@@ -36,12 +36,10 @@
 static void bf_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct bf_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __be32 *in_blk = (const __be32 *)src;
-	__be32 *const out_blk = (__be32 *)dst;
 	const u32 *P = ctx->p;
 	const u32 *S = ctx->s;
-	u32 yl = be32_to_cpu(in_blk[0]);
-	u32 yr = be32_to_cpu(in_blk[1]);
+	u32 yl = get_unaligned_be32(src);
+	u32 yr = get_unaligned_be32(src + 4);
 
 	ROUND(yr, yl, 0);
 	ROUND(yl, yr, 1);
@@ -63,19 +61,17 @@ static void bf_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	yl ^= P[16];
 	yr ^= P[17];
 
-	out_blk[0] = cpu_to_be32(yr);
-	out_blk[1] = cpu_to_be32(yl);
+	put_unaligned_be32(yr, dst);
+	put_unaligned_be32(yl, dst + 4);
 }
 
 static void bf_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct bf_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __be32 *in_blk = (const __be32 *)src;
-	__be32 *const out_blk = (__be32 *)dst;
 	const u32 *P = ctx->p;
 	const u32 *S = ctx->s;
-	u32 yl = be32_to_cpu(in_blk[0]);
-	u32 yr = be32_to_cpu(in_blk[1]);
+	u32 yl = get_unaligned_be32(src);
+	u32 yr = get_unaligned_be32(src + 4);
 
 	ROUND(yr, yl, 17);
 	ROUND(yl, yr, 16);
@@ -97,8 +93,8 @@ static void bf_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	yl ^= P[1];
 	yr ^= P[0];
 
-	out_blk[0] = cpu_to_be32(yr);
-	out_blk[1] = cpu_to_be32(yl);
+	put_unaligned_be32(yr, dst);
+	put_unaligned_be32(yl, dst + 4);
 }
 
 static struct crypto_alg alg = {
@@ -108,7 +104,6 @@ static struct crypto_alg alg = {
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	BF_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct bf_ctx),
-	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{ .cipher = {
 	.cia_min_keysize	=	BF_MIN_KEY_SIZE,
-- 
2.20.1

