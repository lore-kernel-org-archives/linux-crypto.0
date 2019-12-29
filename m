Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D8AC2D0DD
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04F6A206F4
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588292;
	bh=yb4X5FzexWTglctt59bPyudtFO0lGH/9UA9belpF1ao=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0B5OvRV0LzqW7jzkhyhVzY50RTNRAfxRHdR+kJREVQtnnoaVG4sYtA4yCGuPdxVHs
	 9JDgjNNW8FUslYtYUKzaaa9Cs/RUcyzsBmaZPHxsNNqzJ0pfv75nL1zGXl6eNco5ew
	 VJ2d5DhuJ/WNBX3grxkEI5VQf0JUrcI2H9x7+caQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfL2C6L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726425AbfL2C6K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:10 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B913A206F4
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588289;
        bh=yb4X5FzexWTglctt59bPyudtFO0lGH/9UA9belpF1ao=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hMSWPyxTuobBdK3YgyCvSGS7NpUR8A4R3e7uGVZkDMvNWt5I/OZZjWFFi3SouGGb/
         JmzO3KQyterFS4bZHx840CSQ2GVaLzofmq26FjjynY1JX4N2s65wY5Hd/ibOb/Gpem
         Ydt96bS0+PFDLwKydMRwWFVfqh9DAeOKV3ai40PA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 17/28] crypto: gcm - use crypto_grab_ahash() and simplify error paths
Date:   Sat, 28 Dec 2019 20:57:03 -0600
Message-Id: <20191229025714.544159-18-ebiggers@kernel.org>
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

Make the gcm and gcm_base templates use the new function
crypto_grab_ahash() to initialize their ahash spawn.

This is needed to make all spawns be initialized in a consistent way.

Also simplify the error handling by taking advantage of crypto_drop_*()
now accepting (as a no-op) spawns that haven't been initialized yet.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/gcm.c | 51 +++++++++++++++------------------------------------
 1 file changed, 15 insertions(+), 36 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 4241264ff93a..8330dd2ffec3 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -13,7 +13,6 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/gcm.h>
 #include <crypto/hash.h>
-#include "internal.h"
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -587,10 +586,9 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	struct crypto_attr_type *algt;
 	u32 mask;
 	struct aead_instance *inst;
+	struct gcm_instance_ctx *ctx;
 	struct skcipher_alg *ctr;
-	struct crypto_alg *ghash_alg;
 	struct hash_alg_common *ghash;
-	struct gcm_instance_ctx *ctx;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
@@ -602,35 +600,26 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 
 	mask = crypto_requires_sync(algt->type, algt->mask);
 
-	ghash_alg = crypto_find_alg(ghash_name, &crypto_ahash_type,
-				    CRYPTO_ALG_TYPE_HASH,
-				    CRYPTO_ALG_TYPE_AHASH_MASK | mask);
-	if (IS_ERR(ghash_alg))
-		return PTR_ERR(ghash_alg);
-
-	ghash = __crypto_hash_alg_common(ghash_alg);
-
-	err = -ENOMEM;
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
-		goto out_put_ghash;
-
+		return -ENOMEM;
 	ctx = aead_instance_ctx(inst);
-	err = crypto_init_ahash_spawn(&ctx->ghash, ghash,
-				      aead_crypto_instance(inst));
+
+	err = crypto_grab_ahash(&ctx->ghash, aead_crypto_instance(inst),
+				ghash_name, 0, mask);
 	if (err)
-		goto err_free_inst;
+		goto out;
+	ghash = crypto_spawn_ahash_alg(&ctx->ghash);
 
 	err = -EINVAL;
 	if (strcmp(ghash->base.cra_name, "ghash") != 0 ||
 	    ghash->digestsize != 16)
-		goto err_drop_ghash;
+		goto out;
 
 	err = crypto_grab_skcipher(&ctx->ctr, aead_crypto_instance(inst),
 				   ctr_name, 0, mask);
 	if (err)
-		goto err_drop_ghash;
-
+		goto out;
 	ctr = crypto_spawn_skcipher_alg(&ctx->ctr);
 
 	/* The skcipher algorithm must be CTR mode, using 16-byte blocks. */
@@ -638,18 +627,18 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	if (strncmp(ctr->base.cra_name, "ctr(", 4) != 0 ||
 	    crypto_skcipher_alg_ivsize(ctr) != 16 ||
 	    ctr->base.cra_blocksize != 1)
-		goto out_put_ctr;
+		goto out;
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "gcm(%s", ctr->base.cra_name + 4) >= CRYPTO_MAX_ALG_NAME)
-		goto out_put_ctr;
+		goto out;
 
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "gcm_base(%s,%s)", ctr->base.cra_driver_name,
-		     ghash_alg->cra_driver_name) >=
+		     ghash->base.cra_driver_name) >=
 	    CRYPTO_MAX_ALG_NAME)
-		goto out_put_ctr;
+		goto out;
 
 	inst->alg.base.cra_flags = (ghash->base.cra_flags |
 				    ctr->base.cra_flags) & CRYPTO_ALG_ASYNC;
@@ -672,20 +661,10 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	inst->free = crypto_gcm_free;
 
 	err = aead_register_instance(tmpl, inst);
+out:
 	if (err)
-		goto out_put_ctr;
-
-out_put_ghash:
-	crypto_mod_put(ghash_alg);
+		crypto_gcm_free(inst);
 	return err;
-
-out_put_ctr:
-	crypto_drop_skcipher(&ctx->ctr);
-err_drop_ghash:
-	crypto_drop_ahash(&ctx->ghash);
-err_free_inst:
-	kfree(inst);
-	goto out_put_ghash;
 }
 
 static int crypto_gcm_create(struct crypto_template *tmpl, struct rtattr **tb)
-- 
2.24.1

