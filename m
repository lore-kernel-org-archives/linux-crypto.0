Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 191B1C33C9A
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEE4F21D7D
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024094;
	bh=oP03XBrmE4G+p/Xh8RaSzFf/+MvvdLPxYmtN3QYvfM8=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MJBFT8VqxQByIjBcVksQuQDXzt7j9kLy+3ZSWQXMYABkLMTp1bDpJmWj6fQd7vLFe
	 AdBWgOhHhlNgeI1Xw8KT2VWduWWIpT/8MxgXGsVtcvXSHhoTqk9tvS1MChS0bm6RaR
	 6vka0InRXu6VP6ahT+4bDRh3cMXarrM9iGOfmBmA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbgACEBa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:01:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727210AbgACEB2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:01:28 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF48724649
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024087;
        bh=oP03XBrmE4G+p/Xh8RaSzFf/+MvvdLPxYmtN3QYvfM8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=x/BPPO0rVcV/6kGDGvrclV8Qmgj0XcfEoPlxxh0jpw7uHdI3MWsOxVN7YXIbIXC90
         hV/uAQ/QeCk1dLSLimfExkcTN6cnBUgsjOVtY2AAtHJ4STYSh1e7R7pv4gsUp7h76W
         faJDtALvrtHuVXFUpP7WUDfUoVGaxKP2yBDbE1gE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 19/28] crypto: chacha20poly1305 - use crypto_grab_ahash() and simplify error paths
Date:   Thu,  2 Jan 2020 19:58:59 -0800
Message-Id: <20200103035908.12048-20-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200103035908.12048-1-ebiggers@kernel.org>
References: <20200103035908.12048-1-ebiggers@kernel.org>
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
 crypto/chacha20poly1305.c | 84 +++++++++++++--------------------------
 1 file changed, 27 insertions(+), 57 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index fcb8ec4ba083..72543cfa45ef 100644
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
+		goto err_free_inst;
 	chacha = crypto_spawn_skcipher_alg(&ctx->chacha);
 
+	err = crypto_grab_ahash(&ctx->poly, aead_crypto_instance(inst),
+				crypto_attr_alg_name(tb[2]), 0, mask);
+	if (err)
+		goto err_free_inst;
+	poly = crypto_spawn_ahash_alg(&ctx->poly);
+
 	err = -EINVAL;
+	if (poly->digestsize != POLY1305_DIGEST_SIZE)
+		goto err_free_inst;
 	/* Need 16-byte IV size, including Initial Block Counter value */
 	if (crypto_skcipher_alg_ivsize(chacha) != CHACHA_IV_SIZE)
-		goto out_drop_chacha;
+		goto err_free_inst;
 	/* Not a stream cipher? */
 	if (chacha->base.cra_blocksize != 1)
-		goto out_drop_chacha;
+		goto err_free_inst;
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "%s(%s,%s)", name, chacha->base.cra_name,
-		     poly->cra_name) >= CRYPTO_MAX_ALG_NAME)
-		goto out_drop_chacha;
+		     poly->base.cra_name) >= CRYPTO_MAX_ALG_NAME)
+		goto err_free_inst;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "%s(%s,%s)", name, chacha->base.cra_driver_name,
-		     poly->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
-		goto out_drop_chacha;
+		     poly->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		goto err_free_inst;
 
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
@@ -661,20 +640,11 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 	inst->free = chachapoly_free;
 
 	err = aead_register_instance(tmpl, inst);
-	if (err)
-		goto out_drop_chacha;
-
-out_put_poly:
-	crypto_mod_put(poly);
-	return err;
-
-out_drop_chacha:
-	crypto_drop_skcipher(&ctx->chacha);
-err_drop_poly:
-	crypto_drop_ahash(&ctx->poly);
+	if (err) {
 err_free_inst:
-	kfree(inst);
-	goto out_put_poly;
+		chachapoly_free(inst);
+	}
+	return err;
 }
 
 static int rfc7539_create(struct crypto_template *tmpl, struct rtattr **tb)
-- 
2.24.1

