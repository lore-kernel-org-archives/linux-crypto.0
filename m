Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4538C282DB
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A516320869
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549007582;
	bh=DYDX/eWNZlZpLfWozLgd947T0LJGjepEmxpvmWGnCrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=BGQ7APdcQSAu8lmXLCGafmj7CLgCCj9l0bnBvOGnT5nXdQgdTVvv3iJ/lUcU3ibeZ
	 Fd/MvSN7WHk3z5f2PdQ8dkLhf7ORd6vl9bx2l0w6qSPbVobNCahrDXw/vz3FlnoDy9
	 RvBMdmNu3+vwpFXnjkfdnG8OjFPlxJGGABw0qqig=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfBAHwE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 02:52:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:36656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbfBAHwD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 02:52:03 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B72C2184A;
        Fri,  1 Feb 2019 07:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549007521;
        bh=DYDX/eWNZlZpLfWozLgd947T0LJGjepEmxpvmWGnCrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JuEH9vfB9JjwoVfQPZHB1jmuyKrPtIoaXL55aZ8zW9L+uvQgyWxgl51SAZA+IFSfD
         qPPv9E06ZYc2dJnYUnof0r9PQkW9SyDAPrqQqSYWfoEv1chyoJxLXORh6A8j9ZvceO
         8Ohft4W4yVnMxu1fiFuQ/0WhnmVaveUnGQZeHsgE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH v2 03/15] crypto: x86/aegis - fix handling chunked inputs and MAY_SLEEP
Date:   Thu, 31 Jan 2019 23:51:38 -0800
Message-Id: <20190201075150.18644-4-ebiggers@kernel.org>
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

The x86 AEGIS implementations all fail the improved AEAD tests because
they produce the wrong result with some data layouts.  The issue is that
they assume that if the skcipher_walk API gives 'nbytes' not aligned to
the walksize (a.k.a. walk.stride), then it is the end of the data.  In
fact, this can happen before the end.

Also, when the CRYPTO_TFM_REQ_MAY_SLEEP flag is given, they can
incorrectly sleep in the skcipher_walk_*() functions while preemption
has been disabled by kernel_fpu_begin().

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
index 2a356b948720e..3ea71b8718135 100644
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
index dbe8bb980da15..1b1b39c66c5e2 100644
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
index 8bebda2de92fe..6227ca3220a05 100644
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
2.20.1

