Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 028C2C2D0C8
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 09:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDBEF24654
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 09:30:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Lfml23Qk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbfLLJam (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 04:30:42 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:41827 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbfLLJak (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 04:30:40 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id ab7ceb1f;
        Thu, 12 Dec 2019 08:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-type:content-transfer-encoding; s=mail; bh=Klwp9JpAhfzi
        9ZAZqdspfVd0z2Y=; b=Lfml23QkzeJSaPZhnmwm4NDHRA0df8Lj8Pv5q2dwQPbC
        IxRo7evyhn+JNrwVV132BNZZRyZ0kYq4Z+7hds6o0W336E3+txROdPLsCw1jutVF
        Pul3pEeA0kIIhSk/s/KDgaM7LlyocEJDzRfiu4oYaB3otS/n/8SUXwxGoGkLAGYw
        Nw5YS73qMKP1VINqsPt/203lngGhdAEJR+PSYcfSWO9u6LsKwG8wJ+7tNGc6PVa1
        mER/DLB5NMzSM+rXRbiSv1sHFnQ/zknirvIir3HdlsdJULuBwLkMxM9DZR2B73Jx
        NZS7x5TQrT3HZqCQhHCpFW+bbdnUJkaiOa3iQwP0Kw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 48c0fccb (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 12 Dec 2019 08:34:42 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org, ebiggers@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH crypto-next v2 3/3] crypto: arm/arm64/mips/poly1305 - remove redundant non-reduction from emit
Date:   Thu, 12 Dec 2019 10:30:08 +0100
Message-Id: <20191212093008.217086-3-Jason@zx2c4.com>
In-Reply-To: <20191212093008.217086-1-Jason@zx2c4.com>
References: <20191211170936.385572-1-Jason@zx2c4.com>
 <20191212093008.217086-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This appears to be some kind of copy and paste error, and is actually
dead code.

Pre: f = 0 ⇒ (f >> 32) = 0
    f = (f >> 32) + le32_to_cpu(digest[0]);
Post: 0 ≤ f < 2³²
    put_unaligned_le32(f, dst);

Pre: 0 ≤ f < 2³² ⇒ (f >> 32) = 0
    f = (f >> 32) + le32_to_cpu(digest[1]);
Post: 0 ≤ f < 2³²
    put_unaligned_le32(f, dst + 4);

Pre: 0 ≤ f < 2³² ⇒ (f >> 32) = 0
    f = (f >> 32) + le32_to_cpu(digest[2]);
Post: 0 ≤ f < 2³²
    put_unaligned_le32(f, dst + 8);

Pre: 0 ≤ f < 2³² ⇒ (f >> 32) = 0
    f = (f >> 32) + le32_to_cpu(digest[3]);
Post: 0 ≤ f < 2³²
    put_unaligned_le32(f, dst + 12);

Therefore this sequence is redundant. And Andy's code appears to handle
misalignment acceptably.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/poly1305-glue.c   | 18 ++----------------
 arch/arm64/crypto/poly1305-glue.c | 18 ++----------------
 arch/mips/crypto/poly1305-glue.c  | 18 ++----------------
 3 files changed, 6 insertions(+), 48 deletions(-)

diff --git a/arch/arm/crypto/poly1305-glue.c b/arch/arm/crypto/poly1305-glue.c
index abe3f2d587dc..ceec04ec2f40 100644
--- a/arch/arm/crypto/poly1305-glue.c
+++ b/arch/arm/crypto/poly1305-glue.c
@@ -20,7 +20,7 @@
 
 void poly1305_init_arm(void *state, const u8 *key);
 void poly1305_blocks_arm(void *state, const u8 *src, u32 len, u32 hibit);
-void poly1305_emit_arm(void *state, __le32 *digest, const u32 *nonce);
+void poly1305_emit_arm(void *state, u8 *digest, const u32 *nonce);
 
 void __weak poly1305_blocks_neon(void *state, const u8 *src, u32 len, u32 hibit)
 {
@@ -179,9 +179,6 @@ EXPORT_SYMBOL(poly1305_update_arch);
 
 void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
 {
-	__le32 digest[4];
-	u64 f = 0;
-
 	if (unlikely(dctx->buflen)) {
 		dctx->buf[dctx->buflen++] = 1;
 		memset(dctx->buf + dctx->buflen, 0,
@@ -189,18 +186,7 @@ void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
 		poly1305_blocks_arm(&dctx->h, dctx->buf, POLY1305_BLOCK_SIZE, 0);
 	}
 
-	poly1305_emit_arm(&dctx->h, digest, dctx->s);
-
-	/* mac = (h + s) % (2^128) */
-	f = (f >> 32) + le32_to_cpu(digest[0]);
-	put_unaligned_le32(f, dst);
-	f = (f >> 32) + le32_to_cpu(digest[1]);
-	put_unaligned_le32(f, dst + 4);
-	f = (f >> 32) + le32_to_cpu(digest[2]);
-	put_unaligned_le32(f, dst + 8);
-	f = (f >> 32) + le32_to_cpu(digest[3]);
-	put_unaligned_le32(f, dst + 12);
-
+	poly1305_emit_arm(&dctx->h, dst, dctx->s);
 	*dctx = (struct poly1305_desc_ctx){};
 }
 EXPORT_SYMBOL(poly1305_final_arch);
diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
index 83a2338a8826..e97b092f56b8 100644
--- a/arch/arm64/crypto/poly1305-glue.c
+++ b/arch/arm64/crypto/poly1305-glue.c
@@ -21,7 +21,7 @@
 asmlinkage void poly1305_init_arm64(void *state, const u8 *key);
 asmlinkage void poly1305_blocks(void *state, const u8 *src, u32 len, u32 hibit);
 asmlinkage void poly1305_blocks_neon(void *state, const u8 *src, u32 len, u32 hibit);
-asmlinkage void poly1305_emit(void *state, __le32 *digest, const u32 *nonce);
+asmlinkage void poly1305_emit(void *state, u8 *digest, const u32 *nonce);
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 
@@ -162,9 +162,6 @@ EXPORT_SYMBOL(poly1305_update_arch);
 
 void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
 {
-	__le32 digest[4];
-	u64 f = 0;
-
 	if (unlikely(dctx->buflen)) {
 		dctx->buf[dctx->buflen++] = 1;
 		memset(dctx->buf + dctx->buflen, 0,
@@ -172,18 +169,7 @@ void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
 		poly1305_blocks(&dctx->h, dctx->buf, POLY1305_BLOCK_SIZE, 0);
 	}
 
-	poly1305_emit(&dctx->h, digest, dctx->s);
-
-	/* mac = (h + s) % (2^128) */
-	f = (f >> 32) + le32_to_cpu(digest[0]);
-	put_unaligned_le32(f, dst);
-	f = (f >> 32) + le32_to_cpu(digest[1]);
-	put_unaligned_le32(f, dst + 4);
-	f = (f >> 32) + le32_to_cpu(digest[2]);
-	put_unaligned_le32(f, dst + 8);
-	f = (f >> 32) + le32_to_cpu(digest[3]);
-	put_unaligned_le32(f, dst + 12);
-
+	poly1305_emit(&dctx->h, dst, dctx->s);
 	*dctx = (struct poly1305_desc_ctx){};
 }
 EXPORT_SYMBOL(poly1305_final_arch);
diff --git a/arch/mips/crypto/poly1305-glue.c b/arch/mips/crypto/poly1305-glue.c
index b37d29cf5d0a..fc881b46d911 100644
--- a/arch/mips/crypto/poly1305-glue.c
+++ b/arch/mips/crypto/poly1305-glue.c
@@ -15,7 +15,7 @@
 
 asmlinkage void poly1305_init_mips(void *state, const u8 *key);
 asmlinkage void poly1305_blocks_mips(void *state, const u8 *src, u32 len, u32 hibit);
-asmlinkage void poly1305_emit_mips(void *state, __le32 *digest, const u32 *nonce);
+asmlinkage void poly1305_emit_mips(void *state, u8 *digest, const u32 *nonce);
 
 void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 *key)
 {
@@ -134,9 +134,6 @@ EXPORT_SYMBOL(poly1305_update_arch);
 
 void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
 {
-	__le32 digest[4];
-	u64 f = 0;
-
 	if (unlikely(dctx->buflen)) {
 		dctx->buf[dctx->buflen++] = 1;
 		memset(dctx->buf + dctx->buflen, 0,
@@ -144,18 +141,7 @@ void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
 		poly1305_blocks_mips(&dctx->h, dctx->buf, POLY1305_BLOCK_SIZE, 0);
 	}
 
-	poly1305_emit_mips(&dctx->h, digest, dctx->s);
-
-	/* mac = (h + s) % (2^128) */
-	f = (f >> 32) + le32_to_cpu(digest[0]);
-	put_unaligned_le32(f, dst);
-	f = (f >> 32) + le32_to_cpu(digest[1]);
-	put_unaligned_le32(f, dst + 4);
-	f = (f >> 32) + le32_to_cpu(digest[2]);
-	put_unaligned_le32(f, dst + 8);
-	f = (f >> 32) + le32_to_cpu(digest[3]);
-	put_unaligned_le32(f, dst + 12);
-
+	poly1305_emit_mips(&dctx->h, dst, dctx->s);
 	*dctx = (struct poly1305_desc_ctx){};
 }
 EXPORT_SYMBOL(poly1305_final_arch);
-- 
2.24.0

