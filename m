Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A3DC282C5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB616218A1
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548284032;
	bh=/o/+1Gkyv+VzQmr4JnBcr7AkSlA8Gm95V2Q7alCLmr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=zDiYAhhJVyNxVAW9iBK+z8XJPoihEKVhzeP/pPnz/9hMigxLWZ6DOPtSdk0YE4aSW
	 +4c9x6vc7i3lSEpkAxPyxPkdbnL0kXqtWu1tgq11CI8s5EN5/fql79DZo0dBeFYgPj
	 62wbDzcaZbBYpkifd/knqIDKUOOLJOgYn434PWMA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfAWWwd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 17:52:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbfAWWwd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 17:52:33 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 044B5218A3;
        Wed, 23 Jan 2019 22:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548283952;
        bh=/o/+1Gkyv+VzQmr4JnBcr7AkSlA8Gm95V2Q7alCLmr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FX/W04iqnAk7YBzyM5Tv9r1oCignom7TCRgnoPXS7PPTZa09+8AKMHfO5v7mkBeT/
         NNHLbXYgnCE+Pt/GjZtxn7Qfyy6/lll2QGVZpg+VX/E881ms4WRnzulyfPxDugg7pn
         PVQ13rR8gIQ+8LEXJWGCUv0+XzktMxGMHKjSyyaI=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [RFC/RFT PATCH 03/15] crypto: x86/aegis - fix handling chunked inputs and MAY_SLEEP
Date:   Wed, 23 Jan 2019 14:49:14 -0800
Message-Id: <20190123224926.250525-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1.321.g9e740568ce-goog
In-Reply-To: <20190123224926.250525-1-ebiggers@kernel.org>
References: <20190123224926.250525-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The x86 AEGIS implementations all fail the improved AEAD tests because
they produce the wrong result with some data layouts.  Also, when the
MAY_SLEEP flag is given, they can sleep in the skcipher_walk_*()
functions while preemption is disabled by kernel_fpu_begin().

Fix these bugs.

Fixes: 1d373d4e8e15 ("crypto: x86 - Add optimized AEGIS implementations")
Cc: <stable@vger.kernel.org> # v4.18+
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis128-aesni-glue.c  | 38 ++++++++++----------------
 arch/x86/crypto/aegis128l-aesni-glue.c | 38 ++++++++++----------------
 arch/x86/crypto/aegis256-aesni-glue.c  | 38 ++++++++++----------------
 3 files changed, 45 insertions(+), 69 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index 2a356b948720..3ea71b871813 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -119,31 +119,20 @@ static void crypto_aegis128_aesni_process_ad(
 }
 
 static void crypto_aegis128_aesni_process_crypt(
-		struct aegis_state *state, struct aead_request *req,
+		struct aegis_state *state, struct skcipher_walk *walk,
 		const struct aegis_crypt_ops *ops)
 {
-	struct skcipher_walk walk;
-	u8 *src, *dst;
-	unsigned int chunksize, base;
-
-	ops->skcipher_walk_init(&walk, req, false);
-
-	while (walk.nbytes) {
-		src = walk.src.virt.addr;
-		dst = walk.dst.virt.addr;
-		chunksize = walk.nbytes;
-
-		ops->crypt_blocks(state, chunksize, src, dst);
-
-		base = chunksize & ~(AEGIS128_BLOCK_SIZE - 1);
-		src += base;
-		dst += base;
-		chunksize &= AEGIS128_BLOCK_SIZE - 1;
-
-		if (chunksize > 0)
-			ops->crypt_tail(state, chunksize, src, dst);
+	while (walk->nbytes >= AEGIS128_BLOCK_SIZE) {
+		ops->crypt_blocks(state,
+				  round_down(walk->nbytes, AEGIS128_BLOCK_SIZE),
+				  walk->src.virt.addr, walk->dst.virt.addr);
+		skcipher_walk_done(walk, walk->nbytes % AEGIS128_BLOCK_SIZE);
+	}
 
-		skcipher_walk_done(&walk, 0);
+	if (walk->nbytes) {
+		ops->crypt_tail(state, walk->nbytes, walk->src.virt.addr,
+				walk->dst.virt.addr);
+		skcipher_walk_done(walk, 0);
 	}
 }
 
@@ -186,13 +175,16 @@ static void crypto_aegis128_aesni_crypt(struct aead_request *req,
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aegis_ctx *ctx = crypto_aegis128_aesni_ctx(tfm);
+	struct skcipher_walk walk;
 	struct aegis_state state;
 
+	ops->skcipher_walk_init(&walk, req, true);
+
 	kernel_fpu_begin();
 
 	crypto_aegis128_aesni_init(&state, ctx->key.bytes, req->iv);
 	crypto_aegis128_aesni_process_ad(&state, req->src, req->assoclen);
-	crypto_aegis128_aesni_process_crypt(&state, req, ops);
+	crypto_aegis128_aesni_process_crypt(&state, &walk, ops);
 	crypto_aegis128_aesni_final(&state, tag_xor, req->assoclen, cryptlen);
 
 	kernel_fpu_end();
diff --git a/arch/x86/crypto/aegis128l-aesni-glue.c b/arch/x86/crypto/aegis128l-aesni-glue.c
index dbe8bb980da1..1b1b39c66c5e 100644
--- a/arch/x86/crypto/aegis128l-aesni-glue.c
+++ b/arch/x86/crypto/aegis128l-aesni-glue.c
@@ -119,31 +119,20 @@ static void crypto_aegis128l_aesni_process_ad(
 }
 
 static void crypto_aegis128l_aesni_process_crypt(
-		struct aegis_state *state, struct aead_request *req,
+		struct aegis_state *state, struct skcipher_walk *walk,
 		const struct aegis_crypt_ops *ops)
 {
-	struct skcipher_walk walk;
-	u8 *src, *dst;
-	unsigned int chunksize, base;
-
-	ops->skcipher_walk_init(&walk, req, false);
-
-	while (walk.nbytes) {
-		src = walk.src.virt.addr;
-		dst = walk.dst.virt.addr;
-		chunksize = walk.nbytes;
-
-		ops->crypt_blocks(state, chunksize, src, dst);
-
-		base = chunksize & ~(AEGIS128L_BLOCK_SIZE - 1);
-		src += base;
-		dst += base;
-		chunksize &= AEGIS128L_BLOCK_SIZE - 1;
-
-		if (chunksize > 0)
-			ops->crypt_tail(state, chunksize, src, dst);
+	while (walk->nbytes >= AEGIS128L_BLOCK_SIZE) {
+		ops->crypt_blocks(state, round_down(walk->nbytes,
+						    AEGIS128L_BLOCK_SIZE),
+				  walk->src.virt.addr, walk->dst.virt.addr);
+		skcipher_walk_done(walk, walk->nbytes % AEGIS128L_BLOCK_SIZE);
+	}
 
-		skcipher_walk_done(&walk, 0);
+	if (walk->nbytes) {
+		ops->crypt_tail(state, walk->nbytes, walk->src.virt.addr,
+				walk->dst.virt.addr);
+		skcipher_walk_done(walk, 0);
 	}
 }
 
@@ -186,13 +175,16 @@ static void crypto_aegis128l_aesni_crypt(struct aead_request *req,
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aegis_ctx *ctx = crypto_aegis128l_aesni_ctx(tfm);
+	struct skcipher_walk walk;
 	struct aegis_state state;
 
+	ops->skcipher_walk_init(&walk, req, true);
+
 	kernel_fpu_begin();
 
 	crypto_aegis128l_aesni_init(&state, ctx->key.bytes, req->iv);
 	crypto_aegis128l_aesni_process_ad(&state, req->src, req->assoclen);
-	crypto_aegis128l_aesni_process_crypt(&state, req, ops);
+	crypto_aegis128l_aesni_process_crypt(&state, &walk, ops);
 	crypto_aegis128l_aesni_final(&state, tag_xor, req->assoclen, cryptlen);
 
 	kernel_fpu_end();
diff --git a/arch/x86/crypto/aegis256-aesni-glue.c b/arch/x86/crypto/aegis256-aesni-glue.c
index 8bebda2de92f..6227ca3220a0 100644
--- a/arch/x86/crypto/aegis256-aesni-glue.c
+++ b/arch/x86/crypto/aegis256-aesni-glue.c
@@ -119,31 +119,20 @@ static void crypto_aegis256_aesni_process_ad(
 }
 
 static void crypto_aegis256_aesni_process_crypt(
-		struct aegis_state *state, struct aead_request *req,
+		struct aegis_state *state, struct skcipher_walk *walk,
 		const struct aegis_crypt_ops *ops)
 {
-	struct skcipher_walk walk;
-	u8 *src, *dst;
-	unsigned int chunksize, base;
-
-	ops->skcipher_walk_init(&walk, req, false);
-
-	while (walk.nbytes) {
-		src = walk.src.virt.addr;
-		dst = walk.dst.virt.addr;
-		chunksize = walk.nbytes;
-
-		ops->crypt_blocks(state, chunksize, src, dst);
-
-		base = chunksize & ~(AEGIS256_BLOCK_SIZE - 1);
-		src += base;
-		dst += base;
-		chunksize &= AEGIS256_BLOCK_SIZE - 1;
-
-		if (chunksize > 0)
-			ops->crypt_tail(state, chunksize, src, dst);
+	while (walk->nbytes >= AEGIS256_BLOCK_SIZE) {
+		ops->crypt_blocks(state,
+				  round_down(walk->nbytes, AEGIS256_BLOCK_SIZE),
+				  walk->src.virt.addr, walk->dst.virt.addr);
+		skcipher_walk_done(walk, walk->nbytes % AEGIS256_BLOCK_SIZE);
+	}
 
-		skcipher_walk_done(&walk, 0);
+	if (walk->nbytes) {
+		ops->crypt_tail(state, walk->nbytes, walk->src.virt.addr,
+				walk->dst.virt.addr);
+		skcipher_walk_done(walk, 0);
 	}
 }
 
@@ -186,13 +175,16 @@ static void crypto_aegis256_aesni_crypt(struct aead_request *req,
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aegis_ctx *ctx = crypto_aegis256_aesni_ctx(tfm);
+	struct skcipher_walk walk;
 	struct aegis_state state;
 
+	ops->skcipher_walk_init(&walk, req, true);
+
 	kernel_fpu_begin();
 
 	crypto_aegis256_aesni_init(&state, ctx->key, req->iv);
 	crypto_aegis256_aesni_process_ad(&state, req->src, req->assoclen);
-	crypto_aegis256_aesni_process_crypt(&state, req, ops);
+	crypto_aegis256_aesni_process_crypt(&state, &walk, ops);
 	crypto_aegis256_aesni_final(&state, tag_xor, req->assoclen, cryptlen);
 
 	kernel_fpu_end();
-- 
2.20.1.321.g9e740568ce-goog

