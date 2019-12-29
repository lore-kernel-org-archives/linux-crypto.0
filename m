Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5FAC2D0C8
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11BA921927
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588293;
	bh=FToCZsBhc8K9zHvO5TL3b4cQO2c3AJyhSaZQqRg5qVQ=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Le+c+mQm9SvQnV7CX35vvOpeB3t1R5tQh1E5cLHp1iEf8D+4+KFMjQBPOrAa7fmZ2
	 kVpwxpEu0tLJiTaFDv8FTCrFE7PCQYgOvnjnw/M2IGBQUtC902BPUXhx/cyrKn76zV
	 3F8BTnbjgilX2+yobrqbGaTq7YGLtTTUZrostwdA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfL2C6L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbfL2C6L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:11 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BB5C21775
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588290;
        bh=FToCZsBhc8K9zHvO5TL3b4cQO2c3AJyhSaZQqRg5qVQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rxsRDAjIU6YAuuLJ9BNlBOK+j4ZIOVZW3Z3UG5gSSrp0nVa1njWYX2/8SqNehLNm4
         htGl8/SqmFnO8gOyIA7Lo7OVSu0vf9hc26P0Z1JVXs+lpsD8cFojtDa0TFNSDkzPN9
         t0H9zB8cWes3ytP2+zySUKRJ466ZuKpW+lEuVsCY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 19/28] crypto: chacha20poly1305 - use crypto_grab_ahash() and simplify error paths
Date:   Sat, 28 Dec 2019 20:57:05 -0600
Message-Id: <20191229025714.544159-20-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229025714.544159-1-ebiggers@kernel.org>
References: <20191229025714.544159-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make the rfc7539 and rfc7539esp templates use the new function
crypto_grab_ahash() to initialize their ahash spawn.

This is needed to make all spawns be initialized in a consistent way.

Also simplify the error handling by taking advantage of crypto_drop_*()
now accepting (as a no-op) spawns that haven't been initialized yet, and
by taking advantage of crypto_grab_*() now handling ERR_PTR() names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/chacha20poly1305.c | 81 ++++++++++++---------------------------
 1 file changed, 25 insertions(+), 56 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index fcb8ec4ba083..714532041dab 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -16,8 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-#include "internal.h"
-
 struct chachapoly_instance_ctx {
 	struct crypto_skcipher_spawn chacha;
 	struct crypto_ahash_spawn poly;
@@ -565,11 +563,9 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 	struct crypto_attr_type *algt;
 	u32 mask;
 	struct aead_instance *inst;
-	struct skcipher_alg *chacha;
-	struct crypto_alg *poly;
-	struct hash_alg_common *poly_hash;
 	struct chachapoly_instance_ctx *ctx;
-	const char *chacha_name, *poly_name;
+	struct skcipher_alg *chacha;
+	struct hash_alg_common *poly;
 	int err;
 
 	if (ivsize > CHACHAPOLY_IV_SIZE)
@@ -584,68 +580,51 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 
 	mask = crypto_requires_sync(algt->type, algt->mask);
 
-	chacha_name = crypto_attr_alg_name(tb[1]);
-	if (IS_ERR(chacha_name))
-		return PTR_ERR(chacha_name);
-	poly_name = crypto_attr_alg_name(tb[2]);
-	if (IS_ERR(poly_name))
-		return PTR_ERR(poly_name);
-
-	poly = crypto_find_alg(poly_name, &crypto_ahash_type,
-			       CRYPTO_ALG_TYPE_HASH,
-			       CRYPTO_ALG_TYPE_AHASH_MASK | mask);
-	if (IS_ERR(poly))
-		return PTR_ERR(poly);
-	poly_hash = __crypto_hash_alg_common(poly);
-
-	err = -EINVAL;
-	if (poly_hash->digestsize != POLY1305_DIGEST_SIZE)
-		goto out_put_poly;
-
-	err = -ENOMEM;
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
-		goto out_put_poly;
-
+		return -ENOMEM;
 	ctx = aead_instance_ctx(inst);
 	ctx->saltlen = CHACHAPOLY_IV_SIZE - ivsize;
-	err = crypto_init_ahash_spawn(&ctx->poly, poly_hash,
-				      aead_crypto_instance(inst));
-	if (err)
-		goto err_free_inst;
 
 	err = crypto_grab_skcipher(&ctx->chacha, aead_crypto_instance(inst),
-				   chacha_name, 0, mask);
+				   crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
-		goto err_drop_poly;
-
+		goto out;
 	chacha = crypto_spawn_skcipher_alg(&ctx->chacha);
 
+	err = crypto_grab_ahash(&ctx->poly, aead_crypto_instance(inst),
+				crypto_attr_alg_name(tb[2]), 0, mask);
+	if (err)
+		goto out;
+	poly = crypto_spawn_ahash_alg(&ctx->poly);
+
 	err = -EINVAL;
+	if (poly->digestsize != POLY1305_DIGEST_SIZE)
+		goto out;
 	/* Need 16-byte IV size, including Initial Block Counter value */
 	if (crypto_skcipher_alg_ivsize(chacha) != CHACHA_IV_SIZE)
-		goto out_drop_chacha;
+		goto out;
 	/* Not a stream cipher? */
 	if (chacha->base.cra_blocksize != 1)
-		goto out_drop_chacha;
+		goto out;
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "%s(%s,%s)", name, chacha->base.cra_name,
-		     poly->cra_name) >= CRYPTO_MAX_ALG_NAME)
-		goto out_drop_chacha;
+		     poly->base.cra_name) >= CRYPTO_MAX_ALG_NAME)
+		goto out;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "%s(%s,%s)", name, chacha->base.cra_driver_name,
-		     poly->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
-		goto out_drop_chacha;
+		     poly->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		goto out;
 
-	inst->alg.base.cra_flags = (chacha->base.cra_flags | poly->cra_flags) &
-				   CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = (chacha->base.cra_flags |
+				    poly->base.cra_flags) & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = (chacha->base.cra_priority +
-				       poly->cra_priority) / 2;
+				       poly->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = chacha->base.cra_alignmask |
-				       poly->cra_alignmask;
+				       poly->base.cra_alignmask;
 	inst->alg.base.cra_ctxsize = sizeof(struct chachapoly_ctx) +
 				     ctx->saltlen;
 	inst->alg.ivsize = ivsize;
@@ -661,20 +640,10 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 	inst->free = chachapoly_free;
 
 	err = aead_register_instance(tmpl, inst);
+out:
 	if (err)
-		goto out_drop_chacha;
-
-out_put_poly:
-	crypto_mod_put(poly);
+		chachapoly_free(inst);
 	return err;
-
-out_drop_chacha:
-	crypto_drop_skcipher(&ctx->chacha);
-err_drop_poly:
-	crypto_drop_ahash(&ctx->poly);
-err_free_inst:
-	kfree(inst);
-	goto out_put_poly;
 }
 
 static int rfc7539_create(struct crypto_template *tmpl, struct rtattr **tb)
-- 
2.24.1

