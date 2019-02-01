Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA33C282DA
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EED520869
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549007580;
	bh=Gar+v92lcduTbv83Ih6+MRPRccKTVLzwxxoQbXTwXTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Nuy68QtwwX9c671VnCCSNaTKqS1/mKSAGCsJ5VDNnBBEC+oMi8NjDobE58YtcwPf0
	 ariI/Ez+mKMu7VGXpUCu9jmiXE28fpW4ah04jIl+xUifTq++UFLuVkR704ODcWLbRo
	 jALrMzTFCd0x8sSfrO68P1wHHslP6Rp7oRL6BvdE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfBAHwF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 02:52:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbfBAHwC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 02:52:02 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78C4321872;
        Fri,  1 Feb 2019 07:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549007521;
        bh=Gar+v92lcduTbv83Ih6+MRPRccKTVLzwxxoQbXTwXTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgwcA0KWDFgGt0SZOOvHdd0H7Oo5Yf1gf314Sde6ukjijJIRtqfYSqhEeGLc+50du
         +8fqCWIKDf6mIsZrFLwzBHZ2K1YIsFIuXqewCvfCzl8MBviA4RWPJ+oHrG6iRoroPf
         lexWV7U2cMmBfPd5Tc2ByjyH5f27eX9B3xUq+IlQ=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH v2 04/15] crypto: x86/morus - fix handling chunked inputs and MAY_SLEEP
Date:   Thu, 31 Jan 2019 23:51:39 -0800
Message-Id: <20190201075150.18644-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190201075150.18644-1-ebiggers@kernel.org>
References: <20190201075150.18644-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The x86 MORUS implementations all fail the improved AEAD tests because
they produce the wrong result with some data layouts.  The issue is that
they assume that if the skcipher_walk API gives 'nbytes' not aligned to
the walksize (a.k.a. walk.stride), then it is the end of the data.  In
fact, this can happen before the end.

Also, when the CRYPTO_TFM_REQ_MAY_SLEEP flag is given, they can
incorrectly sleep in the skcipher_walk_*() functions while preemption
has been disabled by kernel_fpu_begin().

Fix these bugs.

Fixes: 56e8e57fc3a7 ("crypto: morus - Add common SIMD glue code for MORUS")
Cc: <stable@vger.kernel.org> # v4.18+
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/morus1280_glue.c | 40 +++++++++++++-------------------
 arch/x86/crypto/morus640_glue.c  | 39 ++++++++++++-------------------
 2 files changed, 31 insertions(+), 48 deletions(-)

diff --git a/arch/x86/crypto/morus1280_glue.c b/arch/x86/crypto/morus1280_glue.c
index 0dccdda1eb3a1..7e600f8bcdad8 100644
--- a/arch/x86/crypto/morus1280_glue.c
+++ b/arch/x86/crypto/morus1280_glue.c
@@ -85,31 +85,20 @@ static void crypto_morus1280_glue_process_ad(
 
 static void crypto_morus1280_glue_process_crypt(struct morus1280_state *state,
 						struct morus1280_ops ops,
-						struct aead_request *req)
+						struct skcipher_walk *walk)
 {
-	struct skcipher_walk walk;
-	u8 *cursor_src, *cursor_dst;
-	unsigned int chunksize, base;
-
-	ops.skcipher_walk_init(&walk, req, false);
-
-	while (walk.nbytes) {
-		cursor_src = walk.src.virt.addr;
-		cursor_dst = walk.dst.virt.addr;
-		chunksize = walk.nbytes;
-
-		ops.crypt_blocks(state, cursor_src, cursor_dst, chunksize);
-
-		base = chunksize & ~(MORUS1280_BLOCK_SIZE - 1);
-		cursor_src += base;
-		cursor_dst += base;
-		chunksize &= MORUS1280_BLOCK_SIZE - 1;
-
-		if (chunksize > 0)
-			ops.crypt_tail(state, cursor_src, cursor_dst,
-				       chunksize);
+	while (walk->nbytes >= MORUS1280_BLOCK_SIZE) {
+		ops.crypt_blocks(state, walk->src.virt.addr,
+				 walk->dst.virt.addr,
+				 round_down(walk->nbytes,
+					    MORUS1280_BLOCK_SIZE));
+		skcipher_walk_done(walk, walk->nbytes % MORUS1280_BLOCK_SIZE);
+	}
 
-		skcipher_walk_done(&walk, 0);
+	if (walk->nbytes) {
+		ops.crypt_tail(state, walk->src.virt.addr, walk->dst.virt.addr,
+			       walk->nbytes);
+		skcipher_walk_done(walk, 0);
 	}
 }
 
@@ -147,12 +136,15 @@ static void crypto_morus1280_glue_crypt(struct aead_request *req,
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct morus1280_ctx *ctx = crypto_aead_ctx(tfm);
 	struct morus1280_state state;
+	struct skcipher_walk walk;
+
+	ops.skcipher_walk_init(&walk, req, true);
 
 	kernel_fpu_begin();
 
 	ctx->ops->init(&state, &ctx->key, req->iv);
 	crypto_morus1280_glue_process_ad(&state, ctx->ops, req->src, req->assoclen);
-	crypto_morus1280_glue_process_crypt(&state, ops, req);
+	crypto_morus1280_glue_process_crypt(&state, ops, &walk);
 	ctx->ops->final(&state, tag_xor, req->assoclen, cryptlen);
 
 	kernel_fpu_end();
diff --git a/arch/x86/crypto/morus640_glue.c b/arch/x86/crypto/morus640_glue.c
index 7b58fe4d9bd1a..cb3a817320160 100644
--- a/arch/x86/crypto/morus640_glue.c
+++ b/arch/x86/crypto/morus640_glue.c
@@ -85,31 +85,19 @@ static void crypto_morus640_glue_process_ad(
 
 static void crypto_morus640_glue_process_crypt(struct morus640_state *state,
 					       struct morus640_ops ops,
-					       struct aead_request *req)
+					       struct skcipher_walk *walk)
 {
-	struct skcipher_walk walk;
-	u8 *cursor_src, *cursor_dst;
-	unsigned int chunksize, base;
-
-	ops.skcipher_walk_init(&walk, req, false);
-
-	while (walk.nbytes) {
-		cursor_src = walk.src.virt.addr;
-		cursor_dst = walk.dst.virt.addr;
-		chunksize = walk.nbytes;
-
-		ops.crypt_blocks(state, cursor_src, cursor_dst, chunksize);
-
-		base = chunksize & ~(MORUS640_BLOCK_SIZE - 1);
-		cursor_src += base;
-		cursor_dst += base;
-		chunksize &= MORUS640_BLOCK_SIZE - 1;
-
-		if (chunksize > 0)
-			ops.crypt_tail(state, cursor_src, cursor_dst,
-				       chunksize);
+	while (walk->nbytes >= MORUS640_BLOCK_SIZE) {
+		ops.crypt_blocks(state, walk->src.virt.addr,
+				 walk->dst.virt.addr,
+				 round_down(walk->nbytes, MORUS640_BLOCK_SIZE));
+		skcipher_walk_done(walk, walk->nbytes % MORUS640_BLOCK_SIZE);
+	}
 
-		skcipher_walk_done(&walk, 0);
+	if (walk->nbytes) {
+		ops.crypt_tail(state, walk->src.virt.addr, walk->dst.virt.addr,
+			       walk->nbytes);
+		skcipher_walk_done(walk, 0);
 	}
 }
 
@@ -143,12 +131,15 @@ static void crypto_morus640_glue_crypt(struct aead_request *req,
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct morus640_ctx *ctx = crypto_aead_ctx(tfm);
 	struct morus640_state state;
+	struct skcipher_walk walk;
+
+	ops.skcipher_walk_init(&walk, req, true);
 
 	kernel_fpu_begin();
 
 	ctx->ops->init(&state, &ctx->key, req->iv);
 	crypto_morus640_glue_process_ad(&state, ctx->ops, req->src, req->assoclen);
-	crypto_morus640_glue_process_crypt(&state, ops, req);
+	crypto_morus640_glue_process_crypt(&state, ops, &walk);
 	ctx->ops->final(&state, tag_xor, req->assoclen, cryptlen);
 
 	kernel_fpu_end();
-- 
2.20.1

