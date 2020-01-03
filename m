Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842FCC2D0CE
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51B5421D7D
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024098;
	bh=VAy7i9KLF+tp4M9JhwoVIwor8TQDhSF7HRM9Xv2hSLM=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=UiZRVgaMY3uBkm2bBs20prpdc6MTbnuQGKF0IIHst5dbF83UfhA6oLJ6SmLNoC+AU
	 QoEZQNiARdt+cNgGk2q4jlO3YaZNxMrtdbRidGFlgSv70gu76tTNxCB01tmDHyE0hr
	 AyZ96PU8bBVz3CLtEv0upYXLB4f/0cLy8IznYE2A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgACEBh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:01:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:33508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726792AbgACEB1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:01:27 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73ED822314
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024086;
        bh=VAy7i9KLF+tp4M9JhwoVIwor8TQDhSF7HRM9Xv2hSLM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=zlX1uGc0xeCVEKD7Y/Qjbw4bk/Hd2mk9mCIuOKUnHDEKLP1oSgE7JNm/LR7WvmxdO
         YuEZWdvt9jvcJ5B/j9kU9l9kXR9IDP4/IFj15CVB6+jyqN5B5eNDn1Jrr5P0Oia6gf
         mXaGl59Etrk6I99+hO6AVKu2LxyPLjKTQvOVCEgI=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 12/28] crypto: adiantum - use crypto_grab_{cipher,shash} and simplify error paths
Date:   Thu,  2 Jan 2020 19:58:52 -0800
Message-Id: <20200103035908.12048-13-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200103035908.12048-1-ebiggers@kernel.org>
References: <20200103035908.12048-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make the adiantum template use the new functions crypto_grab_cipher()
and crypto_grab_shash() to initialize its cipher and shash spawns.

This is needed to make all spawns be initialized in a consistent way.

Also simplify the error handling by taking advantage of crypto_drop_*()
now accepting (as a no-op) spawns that haven't been initialized yet, and
by taking advantage of crypto_grab_*() now handling ERR_PTR() names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/adiantum.c | 85 ++++++++++++++---------------------------------
 1 file changed, 25 insertions(+), 60 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 9e44180111c8..8abaecde1464 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -39,8 +39,6 @@
 #include <crypto/scatterwalk.h>
 #include <linux/module.h>
 
-#include "internal.h"
-
 /*
  * Size of right-hand part of input data, in bytes; also the size of the block
  * cipher's block size and the hash function's output.
@@ -64,7 +62,7 @@
 
 struct adiantum_instance_ctx {
 	struct crypto_skcipher_spawn streamcipher_spawn;
-	struct crypto_spawn blockcipher_spawn;
+	struct crypto_cipher_spawn blockcipher_spawn;
 	struct crypto_shash_spawn hash_spawn;
 };
 
@@ -418,7 +416,7 @@ static int adiantum_init_tfm(struct crypto_skcipher *tfm)
 	if (IS_ERR(streamcipher))
 		return PTR_ERR(streamcipher);
 
-	blockcipher = crypto_spawn_cipher(&ictx->blockcipher_spawn);
+	blockcipher = crypto_spawn_cipher(&ictx->blockcipher_spawn.base);
 	if (IS_ERR(blockcipher)) {
 		err = PTR_ERR(blockcipher);
 		goto err_free_streamcipher;
@@ -469,7 +467,7 @@ static void adiantum_free_instance(struct skcipher_instance *inst)
 	struct adiantum_instance_ctx *ictx = skcipher_instance_ctx(inst);
 
 	crypto_drop_skcipher(&ictx->streamcipher_spawn);
-	crypto_drop_spawn(&ictx->blockcipher_spawn);
+	crypto_drop_cipher(&ictx->blockcipher_spawn);
 	crypto_drop_shash(&ictx->hash_spawn);
 	kfree(inst);
 }
@@ -502,14 +500,11 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
 	u32 mask;
-	const char *streamcipher_name;
-	const char *blockcipher_name;
 	const char *nhpoly1305_name;
 	struct skcipher_instance *inst;
 	struct adiantum_instance_ctx *ictx;
 	struct skcipher_alg *streamcipher_alg;
 	struct crypto_alg *blockcipher_alg;
-	struct crypto_alg *_hash_alg;
 	struct shash_alg *hash_alg;
 	int err;
 
@@ -522,20 +517,6 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	mask = crypto_requires_sync(algt->type, algt->mask);
 
-	streamcipher_name = crypto_attr_alg_name(tb[1]);
-	if (IS_ERR(streamcipher_name))
-		return PTR_ERR(streamcipher_name);
-
-	blockcipher_name = crypto_attr_alg_name(tb[2]);
-	if (IS_ERR(blockcipher_name))
-		return PTR_ERR(blockcipher_name);
-
-	nhpoly1305_name = crypto_attr_alg_name(tb[3]);
-	if (nhpoly1305_name == ERR_PTR(-ENOENT))
-		nhpoly1305_name = "nhpoly1305";
-	if (IS_ERR(nhpoly1305_name))
-		return PTR_ERR(nhpoly1305_name);
-
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
@@ -544,33 +525,29 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	/* Stream cipher, e.g. "xchacha12" */
 	err = crypto_grab_skcipher(&ictx->streamcipher_spawn,
 				   skcipher_crypto_instance(inst),
-				   streamcipher_name, 0, mask);
+				   crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
-		goto out_free_inst;
+		goto err_free_inst;
 	streamcipher_alg = crypto_spawn_skcipher_alg(&ictx->streamcipher_spawn);
 
 	/* Block cipher, e.g. "aes" */
-	err = crypto_grab_spawn(&ictx->blockcipher_spawn,
-				skcipher_crypto_instance(inst),
-				blockcipher_name,
-				CRYPTO_ALG_TYPE_CIPHER, CRYPTO_ALG_TYPE_MASK);
+	err = crypto_grab_cipher(&ictx->blockcipher_spawn,
+				 skcipher_crypto_instance(inst),
+				 crypto_attr_alg_name(tb[2]), 0, mask);
 	if (err)
-		goto out_drop_streamcipher;
-	blockcipher_alg = ictx->blockcipher_spawn.alg;
+		goto err_free_inst;
+	blockcipher_alg = crypto_spawn_cipher_alg(&ictx->blockcipher_spawn);
 
 	/* NHPoly1305 ε-∆U hash function */
-	_hash_alg = crypto_alg_mod_lookup(nhpoly1305_name,
-					  CRYPTO_ALG_TYPE_SHASH,
-					  CRYPTO_ALG_TYPE_MASK);
-	if (IS_ERR(_hash_alg)) {
-		err = PTR_ERR(_hash_alg);
-		goto out_drop_blockcipher;
-	}
-	hash_alg = __crypto_shash_alg(_hash_alg);
-	err = crypto_init_shash_spawn(&ictx->hash_spawn, hash_alg,
-				      skcipher_crypto_instance(inst));
+	nhpoly1305_name = crypto_attr_alg_name(tb[3]);
+	if (nhpoly1305_name == ERR_PTR(-ENOENT))
+		nhpoly1305_name = "nhpoly1305";
+	err = crypto_grab_shash(&ictx->hash_spawn,
+				skcipher_crypto_instance(inst),
+				nhpoly1305_name, 0, mask);
 	if (err)
-		goto out_put_hash;
+		goto err_free_inst;
+	hash_alg = crypto_spawn_shash_alg(&ictx->hash_spawn);
 
 	/* Check the set of algorithms */
 	if (!adiantum_supported_algorithms(streamcipher_alg, blockcipher_alg,
@@ -579,7 +556,7 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 			streamcipher_alg->base.cra_name,
 			blockcipher_alg->cra_name, hash_alg->base.cra_name);
 		err = -EINVAL;
-		goto out_drop_hash;
+		goto err_free_inst;
 	}
 
 	/* Instance fields */
@@ -588,13 +565,13 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "adiantum(%s,%s)", streamcipher_alg->base.cra_name,
 		     blockcipher_alg->cra_name) >= CRYPTO_MAX_ALG_NAME)
-		goto out_drop_hash;
+		goto err_free_inst;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "adiantum(%s,%s,%s)",
 		     streamcipher_alg->base.cra_driver_name,
 		     blockcipher_alg->cra_driver_name,
 		     hash_alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
-		goto out_drop_hash;
+		goto err_free_inst;
 
 	inst->alg.base.cra_flags = streamcipher_alg->base.cra_flags &
 				   CRYPTO_ALG_ASYNC;
@@ -624,22 +601,10 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->free = adiantum_free_instance;
 
 	err = skcipher_register_instance(tmpl, inst);
-	if (err)
-		goto out_drop_hash;
-
-	crypto_mod_put(_hash_alg);
-	return 0;
-
-out_drop_hash:
-	crypto_drop_shash(&ictx->hash_spawn);
-out_put_hash:
-	crypto_mod_put(_hash_alg);
-out_drop_blockcipher:
-	crypto_drop_spawn(&ictx->blockcipher_spawn);
-out_drop_streamcipher:
-	crypto_drop_skcipher(&ictx->streamcipher_spawn);
-out_free_inst:
-	kfree(inst);
+	if (err) {
+err_free_inst:
+		adiantum_free_instance(inst);
+	}
 	return err;
 }
 
-- 
2.24.1

