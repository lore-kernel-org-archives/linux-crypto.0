Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 713BCC2D0CE
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43F862176D
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588294;
	bh=ZBdcV9MfU4GKG53RFtgMte2bkXBSg2J0wCjvKMTVHR0=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ZZWZTAT4SG3aRDFq5nURSes3JZ2sfjaRNUEqLTjlm4GVGinhkVDqe6AsKL04wQg9m
	 af1Te5R50hYP2cfR+NDgS7mzxINNvjb0qO4jzV6U8GSqd1FzCq0W74UnHl/NxI4q5+
	 jbNdlCguFhPoZYDhuxPteLe6q+Ys+OE4swtn4WmQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfL2C6N (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbfL2C6J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:09 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECD7121927
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588289;
        bh=ZBdcV9MfU4GKG53RFtgMte2bkXBSg2J0wCjvKMTVHR0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pGpl/juQIWsdPpWD+DeV71FF/xlB9Wky5zAi0zIpIyXQXn7/X2au8LW8gvV0jCFiS
         58n3fcz2Mxh8LCVyUGTk8yS0Dgm4klUU2gDalHbwpt4Kfb8g0S029wVOdRYly+2/J1
         0FWpJJYm4LNdjSpdzYCmt8iqqAxlLcyyxkrM6O0A=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 15/28] crypto: authenc - use crypto_grab_ahash() and simplify error paths
Date:   Sat, 28 Dec 2019 20:57:01 -0600
Message-Id: <20191229025714.544159-16-ebiggers@kernel.org>
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

Make the authenc template use the new function crypto_grab_ahash() to
initialize its ahash spawn.

This is needed to make all spawns be initialized in a consistent way.

Also simplify the error handling by taking advantage of crypto_drop_*()
now accepting (as a no-op) spawns that haven't been initialized yet, and
by taking advantage of crypto_grab_*() now handling ERR_PTR() names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/authenc.c | 51 ++++++++++++------------------------------------
 1 file changed, 13 insertions(+), 38 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index aef04792702a..f3f49fc022f2 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -385,11 +385,10 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 	struct crypto_attr_type *algt;
 	u32 mask;
 	struct aead_instance *inst;
+	struct authenc_instance_ctx *ctx;
 	struct hash_alg_common *auth;
 	struct crypto_alg *auth_base;
 	struct skcipher_alg *enc;
-	struct authenc_instance_ctx *ctx;
-	const char *enc_name;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
@@ -401,35 +400,22 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 
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
-		goto err_free_inst;
+		goto out;
+	auth = crypto_spawn_ahash_alg(&ctx->auth);
+	auth_base = &auth->base;
 
 	err = crypto_grab_skcipher(&ctx->enc, aead_crypto_instance(inst),
-				   enc_name, 0, mask);
+				   crypto_attr_alg_name(tb[2]), 0, mask);
 	if (err)
-		goto err_drop_auth;
-
+		goto out;
 	enc = crypto_spawn_skcipher_alg(&ctx->enc);
 
 	ctx->reqoff = ALIGN(2 * auth->digestsize + auth_base->cra_alignmask,
@@ -440,12 +426,12 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 		     "authenc(%s,%s)", auth_base->cra_name,
 		     enc->base.cra_name) >=
 	    CRYPTO_MAX_ALG_NAME)
-		goto err_drop_enc;
+		goto out;
 
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "authenc(%s,%s)", auth_base->cra_driver_name,
 		     enc->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
-		goto err_drop_enc;
+		goto out;
 
 	inst->alg.base.cra_flags = (auth_base->cra_flags |
 				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
@@ -470,21 +456,10 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 	inst->free = crypto_authenc_free;
 
 	err = aead_register_instance(tmpl, inst);
-	if (err)
-		goto err_drop_enc;
-
 out:
-	crypto_mod_put(auth_base);
+	if (err)
+		crypto_authenc_free(inst);
 	return err;
-
-err_drop_enc:
-	crypto_drop_skcipher(&ctx->enc);
-err_drop_auth:
-	crypto_drop_ahash(&ctx->auth);
-err_free_inst:
-	kfree(inst);
-out_put_auth:
-	goto out;
 }
 
 static struct crypto_template crypto_authenc_tmpl = {
-- 
2.24.1

