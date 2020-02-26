Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6243C4BA0E
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F19420658
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582693262;
	bh=KfFvl/ZJimplfsFodEPZPfe9IZCZGa+FKliVD41RI4I=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wTcTkyi4fk0lnUg0kVKiwa0UTCbnj6TQZ1KLp9Z7xlkz1clEDxF+uUyxLT+18Jxv0
	 r4JToyw6AU7wTJWyyb70GYbDTE+G7EAf/9vp3JiMk1qL9ybp8JkYTsSsbj5IfU+WSE
	 ZYmIOsc86jQ3zjL5i+C0ZnyrMbyDb/yWlKI1ikdc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgBZFBC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Feb 2020 00:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgBZFBB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Feb 2020 00:01:01 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7A5D2067C
        for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2020 05:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582693260;
        bh=KfFvl/ZJimplfsFodEPZPfe9IZCZGa+FKliVD41RI4I=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=B2+jJpIFwsuem3kBPds2mXusU8EO741/JsIAP7R4xvj8Onkig2pCQmeCYxTxHQQGi
         X8gQTmgZyGjkdS/kbM0vOb5MitXSiySZl1TfC/yfhAqsOnFKX71tmDAF22dPKZjCME
         SbInnRgSrb90Dv0X75CXfB9eVoVP2K+hVKqvbZgQ=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 06/12] crypto: gcm - simplify error handling in crypto_rfc4106_create()
Date:   Tue, 25 Feb 2020 20:59:18 -0800
Message-Id: <20200226045924.97053-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226045924.97053-1-ebiggers@kernel.org>
References: <20200226045924.97053-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Simplify the error handling in crypto_rfc4106_create() by taking
advantage of crypto_grab_aead() now handling an ERR_PTR() name and by
taking advantage of crypto_drop_aead() now accepting (as a no-op) a
spawn that hasn't been grabbed yet.

Conveniently, this eliminates the 'ccm_name' variable which was
incorrectly named (it should have been 'gcm_name').

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/gcm.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 8e5c0ac656611..5560341e28105 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -840,7 +840,6 @@ static int crypto_rfc4106_create(struct crypto_template *tmpl,
 	struct aead_instance *inst;
 	struct crypto_aead_spawn *spawn;
 	struct aead_alg *alg;
-	const char *ccm_name;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
@@ -852,19 +851,15 @@ static int crypto_rfc4106_create(struct crypto_template *tmpl,
 
 	mask = crypto_requires_sync(algt->type, algt->mask);
 
-	ccm_name = crypto_attr_alg_name(tb[1]);
-	if (IS_ERR(ccm_name))
-		return PTR_ERR(ccm_name);
-
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
 
 	spawn = aead_instance_ctx(inst);
 	err = crypto_grab_aead(spawn, aead_crypto_instance(inst),
-			       ccm_name, 0, mask);
+			       crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
-		goto out_free_inst;
+		goto err_free_inst;
 
 	alg = crypto_spawn_aead_alg(spawn);
 
@@ -872,11 +867,11 @@ static int crypto_rfc4106_create(struct crypto_template *tmpl,
 
 	/* Underlying IV size must be 12. */
 	if (crypto_aead_alg_ivsize(alg) != GCM_AES_IV_SIZE)
-		goto out_drop_alg;
+		goto err_free_inst;
 
 	/* Not a stream cipher? */
 	if (alg->base.cra_blocksize != 1)
-		goto out_drop_alg;
+		goto err_free_inst;
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
@@ -885,7 +880,7 @@ static int crypto_rfc4106_create(struct crypto_template *tmpl,
 	    snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "rfc4106(%s)", alg->base.cra_driver_name) >=
 	    CRYPTO_MAX_ALG_NAME)
-		goto out_drop_alg;
+		goto err_free_inst;
 
 	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
@@ -909,17 +904,11 @@ static int crypto_rfc4106_create(struct crypto_template *tmpl,
 	inst->free = crypto_rfc4106_free;
 
 	err = aead_register_instance(tmpl, inst);
-	if (err)
-		goto out_drop_alg;
-
-out:
+	if (err) {
+err_free_inst:
+		crypto_rfc4106_free(inst);
+	}
 	return err;
-
-out_drop_alg:
-	crypto_drop_aead(spawn);
-out_free_inst:
-	kfree(inst);
-	goto out;
 }
 
 static int crypto_rfc4543_setkey(struct crypto_aead *parent, const u8 *key,
-- 
2.25.1

