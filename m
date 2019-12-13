Return-Path: <SRS0=mgHx=2D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F49C341BE
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64BB224736
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="KUaliRGm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbfLMQRL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Dec 2019 11:17:11 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:36999 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727984AbfLMQRL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Dec 2019 11:17:11 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 7458ec03;
        Fri, 13 Dec 2019 15:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-type:content-transfer-encoding; s=mail; bh=IJGLjR/jsXq9
        nFZgtA6xSnrurPA=; b=KUaliRGmqUBsuP7jNXVftcdf7W96lgCn+x9o+vziEFIi
        jRoTeA6pxal/EmewurGOwp1Om/fUoCwUAZsO7fi4emS8nflX3twM4COmCeNhOjZU
        WKtUxoOG6y9sIr4cmBzp0XqzCgRyUovx1ZXiVTtnRP8aLmJuntQ11c6gYSh8nad8
        O/TMsJCNLqUJoHsz8lWtqC6+Uz7jaj0/tm8j/KRCIQcX0kueowyHT4KRQJCZCivC
        hbozaV5TGf8tOl/Sl5UG9esbW2xZY4IJ77PYP4lUhdG7435BMRe1mpxRdwKFgtVO
        kZLWi/UTXK6LMB7RpfM4EIztGaLG8juY7Fz6e1LekA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f7e17686 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 13 Dec 2019 15:21:05 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH crypto-next v4 3/3] crypto: arm/arm64/mips/poly1305 - remove redundant non-reduction from emit
Date:   Fri, 13 Dec 2019 17:16:53 +0100
Message-Id: <20191213161653.843683-3-Jason@zx2c4.com>
In-Reply-To: <20191213161653.843683-1-Jason@zx2c4.com>
References: <20191213161653.843683-1-Jason@zx2c4.com>
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
Tested-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
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
2.24.1

