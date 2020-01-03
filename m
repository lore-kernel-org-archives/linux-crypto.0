Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4FA9C32767
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D1AD21D7D
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024091;
	bh=VJsUI3nZQBs1+NtInId6C4UnPbvxMWpEAX+GXI/7fVw=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=KcJ+kjupJc4MKkjeK4yRuCzrEJy61+Y/Kv3KWnTyxjynxi7KeBE2f5cnrWl7WTZNM
	 kQkAeK+gYWvpTBmkRxVhAklRnzYQIZjhmSoZ1zUmSiKIUFhOERKoMVLFD+sZeU1vFl
	 Fy/s9UmtB/2/SyxFioNnfr+xbqQODR7emZo/o9n8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgACEBa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:01:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727186AbgACEB2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:01:28 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FB9B227BF
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024087;
        bh=VJsUI3nZQBs1+NtInId6C4UnPbvxMWpEAX+GXI/7fVw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=psxp+Wv4eZ8vgXKqcEf3LNGh4fR4GeARw7aF83SnyVDYq0GVzpS27BHJ++p6phqnC
         oZPIpk8h/0HzlfOliyMUILRExCnMscgWlKlJTN5+WItGNGCqLlr2gc1tkmXR4lGHaV
         Lv09nwk81wKIaLz2VrjpmhiqYxPd0hsPRa3W/CgA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 16/28] crypto: authencesn - use crypto_grab_ahash() and simplify error paths
Date:   Thu,  2 Jan 2020 19:58:56 -0800
Message-Id: <20200103035908.12048-17-ebiggers@kernel.org>
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

Make the authencesn template use the new function crypto_grab_ahash() to
initialize its ahash spawn.

This is needed to make all spawns be initialized in a consistent way.

Also simplify the error handling by taking advantage of crypto_drop_*()
now accepting (as a no-op) spawns that haven't been initialized yet, and
by taking advantage of crypto_grab_*() now handling ERR_PTR() names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/authencesn.c | 52 ++++++++++++---------------------------------
 1 file changed, 14 insertions(+), 38 deletions(-)

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 48582c3741dc..030cbcd2fe39 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -403,11 +403,10 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 	struct crypto_attr_type *algt;
 	u32 mask;
 	struct aead_instance *inst;
+	struct authenc_esn_instance_ctx *ctx;
 	struct hash_alg_common *auth;
 	struct crypto_alg *auth_base;
 	struct skcipher_alg *enc;
-	struct authenc_esn_instance_ctx *ctx;
-	const char *enc_name;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
@@ -419,47 +418,34 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 
 	mask = crypto_requires_sync(algt->type, algt->mask);
 
-	auth = ahash_attr_alg(tb[1], CRYPTO_ALG_TYPE_HASH,
-			      CRYPTO_ALG_TYPE_AHASH_MASK | mask);
-	if (IS_ERR(auth))
-		return PTR_ERR(auth);
-
-	auth_base = &auth->base;
-
-	enc_name = crypto_attr_alg_name(tb[2]);
-	err = PTR_ERR(enc_name);
-	if (IS_ERR(enc_name))
-		goto out_put_auth;
-
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
-	err = -ENOMEM;
 	if (!inst)
-		goto out_put_auth;
-
+		return -ENOMEM;
 	ctx = aead_instance_ctx(inst);
 
-	err = crypto_init_ahash_spawn(&ctx->auth, auth,
-				      aead_crypto_instance(inst));
+	err = crypto_grab_ahash(&ctx->auth, aead_crypto_instance(inst),
+				crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
+	auth = crypto_spawn_ahash_alg(&ctx->auth);
+	auth_base = &auth->base;
 
 	err = crypto_grab_skcipher(&ctx->enc, aead_crypto_instance(inst),
-				   enc_name, 0, mask);
+				   crypto_attr_alg_name(tb[2]), 0, mask);
 	if (err)
-		goto err_drop_auth;
-
+		goto err_free_inst;
 	enc = crypto_spawn_skcipher_alg(&ctx->enc);
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "authencesn(%s,%s)", auth_base->cra_name,
 		     enc->base.cra_name) >= CRYPTO_MAX_ALG_NAME)
-		goto err_drop_enc;
+		goto err_free_inst;
 
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "authencesn(%s,%s)", auth_base->cra_driver_name,
 		     enc->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
-		goto err_drop_enc;
+		goto err_free_inst;
 
 	inst->alg.base.cra_flags = (auth_base->cra_flags |
 				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
@@ -485,21 +471,11 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 	inst->free = crypto_authenc_esn_free,
 
 	err = aead_register_instance(tmpl, inst);
-	if (err)
-		goto err_drop_enc;
-
-out:
-	crypto_mod_put(auth_base);
-	return err;
-
-err_drop_enc:
-	crypto_drop_skcipher(&ctx->enc);
-err_drop_auth:
-	crypto_drop_ahash(&ctx->auth);
+	if (err) {
 err_free_inst:
-	kfree(inst);
-out_put_auth:
-	goto out;
+		crypto_authenc_esn_free(inst);
+	}
+	return err;
 }
 
 static struct crypto_template crypto_authenc_esn_tmpl = {
-- 
2.24.1

