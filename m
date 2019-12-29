Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD10C2D0DC
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7845A222C2
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588293;
	bh=0sl1twcT8+jC8T4XH9T9Fo+gk1sfXiftvIEUZFYE1pk=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=do8eeV/uItrcshDcfjQg+IqaGVfo7MPsL/io/zKVHl9EBonco5d6/PbEsv3jZceX7
	 LavCoS3RqBwxdYXM6UFE3chrK56tcZ8jZe9GzZLX3OFZiOIPDUamY0rRXT6G+O9Etg
	 nTDlFXfM6+148GMr9B2I1CNlj+IEVa2lOSBVlUxs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfL2C6M (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbfL2C6L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:11 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2796F21744
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588290;
        bh=0sl1twcT8+jC8T4XH9T9Fo+gk1sfXiftvIEUZFYE1pk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=cDMEE6pcR5V59hj4dXRl/tLDcwzNx86UMimgJhDahr9+jXnEG9phfgCfVEz8NL4Y0
         +ceYHoklpe3eqSz5VnrMbJipOdWfxoKCnrbHZbGPlXK4ITns5wvuqvauMkkDnMqQQT
         OxwXVt53yxAVmZYMPievqEHqDTs8qYmQRFfgKMsg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 18/28] crypto: ccm - use crypto_grab_ahash() and simplify error paths
Date:   Sat, 28 Dec 2019 20:57:04 -0600
Message-Id: <20191229025714.544159-19-ebiggers@kernel.org>
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

Make the ccm and ccm_base templates use the new function
crypto_grab_ahash() to initialize their ahash spawn.

This is needed to make all spawns be initialized in a consistent way.

Also simplify the error handling by taking advantage of crypto_drop_*()
now accepting (as a no-op) spawns that haven't been initialized yet.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ccm.c | 60 +++++++++++++++++-----------------------------------
 1 file changed, 19 insertions(+), 41 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 9c377976581d..f430f3650b52 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -15,8 +15,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 
-#include "internal.h"
-
 struct ccm_instance_ctx {
 	struct crypto_skcipher_spawn ctr;
 	struct crypto_ahash_spawn mac;
@@ -459,10 +457,9 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 	struct crypto_attr_type *algt;
 	u32 mask;
 	struct aead_instance *inst;
+	struct ccm_instance_ctx *ictx;
 	struct skcipher_alg *ctr;
-	struct crypto_alg *mac_alg;
 	struct hash_alg_common *mac;
-	struct ccm_instance_ctx *ictx;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
@@ -474,35 +471,26 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 
 	mask = crypto_requires_sync(algt->type, algt->mask);
 
-	mac_alg = crypto_find_alg(mac_name, &crypto_ahash_type,
-				  CRYPTO_ALG_TYPE_HASH,
-				  CRYPTO_ALG_TYPE_AHASH_MASK |
-				  CRYPTO_ALG_ASYNC);
-	if (IS_ERR(mac_alg))
-		return PTR_ERR(mac_alg);
-
-	mac = __crypto_hash_alg_common(mac_alg);
-	err = -EINVAL;
-	if (strncmp(mac->base.cra_name, "cbcmac(", 7) != 0 ||
-	    mac->digestsize != 16)
-		goto out_put_mac;
-
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
-	err = -ENOMEM;
 	if (!inst)
-		goto out_put_mac;
-
+		return -ENOMEM;
 	ictx = aead_instance_ctx(inst);
-	err = crypto_init_ahash_spawn(&ictx->mac, mac,
-				      aead_crypto_instance(inst));
+
+	err = crypto_grab_ahash(&ictx->mac, aead_crypto_instance(inst),
+				mac_name, 0, CRYPTO_ALG_ASYNC);
 	if (err)
-		goto err_free_inst;
+		goto out;
+	mac = crypto_spawn_ahash_alg(&ictx->mac);
+
+	err = -EINVAL;
+	if (strncmp(mac->base.cra_name, "cbcmac(", 7) != 0 ||
+	    mac->digestsize != 16)
+		goto out;
 
 	err = crypto_grab_skcipher(&ictx->ctr, aead_crypto_instance(inst),
 				   ctr_name, 0, mask);
 	if (err)
-		goto err_drop_mac;
-
+		goto out;
 	ctr = crypto_spawn_skcipher_alg(&ictx->ctr);
 
 	/* The skcipher algorithm must be CTR mode, using 16-byte blocks. */
@@ -510,21 +498,21 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 	if (strncmp(ctr->base.cra_name, "ctr(", 4) != 0 ||
 	    crypto_skcipher_alg_ivsize(ctr) != 16 ||
 	    ctr->base.cra_blocksize != 1)
-		goto err_drop_ctr;
+		goto out;
 
 	/* ctr and cbcmac must use the same underlying block cipher. */
 	if (strcmp(ctr->base.cra_name + 4, mac->base.cra_name + 7) != 0)
-		goto err_drop_ctr;
+		goto out;
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "ccm(%s", ctr->base.cra_name + 4) >= CRYPTO_MAX_ALG_NAME)
-		goto err_drop_ctr;
+		goto out;
 
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "ccm_base(%s,%s)", ctr->base.cra_driver_name,
 		     mac->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
-		goto err_drop_ctr;
+		goto out;
 
 	inst->alg.base.cra_flags = ctr->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = (mac->base.cra_priority +
@@ -546,20 +534,10 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 	inst->free = crypto_ccm_free;
 
 	err = aead_register_instance(tmpl, inst);
+out:
 	if (err)
-		goto err_drop_ctr;
-
-out_put_mac:
-	crypto_mod_put(mac_alg);
+		crypto_ccm_free(inst);
 	return err;
-
-err_drop_ctr:
-	crypto_drop_skcipher(&ictx->ctr);
-err_drop_mac:
-	crypto_drop_ahash(&ictx->mac);
-err_free_inst:
-	kfree(inst);
-	goto out_put_mac;
 }
 
 static int crypto_ccm_create(struct crypto_template *tmpl, struct rtattr **tb)
-- 
2.24.1

