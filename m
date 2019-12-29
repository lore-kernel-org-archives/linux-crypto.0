Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E72CC2D0CE
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C3D4222C2
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588288;
	bh=IrycCQJGoY/hKQPN/6Xc7K5Y4Kl9hDwAeLMhBZ6Zb10=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=d1ahduskrwaxYwausEKBC/sh3vGrMglQ5ybudntRMGQU4DlK0I+wwX3X2nUhxGox5
	 LBblW3ze/DwxwBmudb4fd3pUehi0rx8/Q18i+fm+Lz8TNbVC8Bspkhv/PJjRctus/I
	 1jXmtGr2tRN5da/mpZsSu07t0bhIF1lSIUjKcUas=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfL2C6G (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbfL2C6G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:06 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC172206F4
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588285;
        bh=IrycCQJGoY/hKQPN/6Xc7K5Y4Kl9hDwAeLMhBZ6Zb10=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=i1/aWJRHlcWE3w4qEzJgUxyg0JtqXNbe8SiVg/leqmr3mYSeGkp5NqazwkUkV/iqw
         8DYwYx/PsCDUnwrf6xhxbWX1IYDZG3gxCbhUP+fPNa5WWfUrYW2H1+YOts2LZYtTuF
         /QfPIWulqZlzXp02ulG9WPsDXMUJNxvAT9jGnp4M=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 06/28] crypto: aead - pass instance to crypto_grab_aead()
Date:   Sat, 28 Dec 2019 20:56:52 -0600
Message-Id: <20191229025714.544159-7-ebiggers@kernel.org>
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

Initializing a crypto_aead_spawn currently requires:

1. Set spawn->base.inst to point to the instance.
2. Call crypto_grab_aead().

But there's no reason for these steps to be separate, and in fact this
unneeded complication has caused at least one bug, the one fixed by
commit 6db43410179b ("crypto: adiantum - initialize crypto_spawn::inst")

So just make crypto_grab_aead() take the instance as an argument.

To keep the function calls from getting too unwieldy due to this extra
argument, also introduce a 'mask' variable into the affected places
which weren't already using one.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/aead.c                  |  6 ++++--
 crypto/ccm.c                   |  8 +++++---
 crypto/cryptd.c                |  4 ++--
 crypto/essiv.c                 |  3 +--
 crypto/gcm.c                   | 16 ++++++++++------
 crypto/geniv.c                 |  4 ++--
 crypto/pcrypt.c                |  5 ++---
 include/crypto/internal/aead.h | 11 +++--------
 8 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 47f16d139e8e..c7135e00b8ea 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -207,9 +207,11 @@ static const struct crypto_type crypto_aead_type = {
 	.tfmsize = offsetof(struct crypto_aead, base),
 };
 
-int crypto_grab_aead(struct crypto_aead_spawn *spawn, const char *name,
-		     u32 type, u32 mask)
+int crypto_grab_aead(struct crypto_aead_spawn *spawn,
+		     struct crypto_instance *inst,
+		     const char *name, u32 type, u32 mask)
 {
+	spawn->base.inst = inst;
 	spawn->base.frontend = &crypto_aead_type;
 	return crypto_grab_spawn(&spawn->base, name, type, mask);
 }
diff --git a/crypto/ccm.c b/crypto/ccm.c
index d2279dc5b970..9c377976581d 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -746,6 +746,7 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 				 struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
+	u32 mask;
 	struct aead_instance *inst;
 	struct crypto_aead_spawn *spawn;
 	struct aead_alg *alg;
@@ -759,6 +760,8 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
+	mask = crypto_requires_sync(algt->type, algt->mask);
+
 	ccm_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(ccm_name))
 		return PTR_ERR(ccm_name);
@@ -768,9 +771,8 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 		return -ENOMEM;
 
 	spawn = aead_instance_ctx(inst);
-	crypto_set_aead_spawn(spawn, aead_crypto_instance(inst));
-	err = crypto_grab_aead(spawn, ccm_name, 0,
-			       crypto_requires_sync(algt->type, algt->mask));
+	err = crypto_grab_aead(spawn, aead_crypto_instance(inst),
+			       ccm_name, 0, mask);
 	if (err)
 		goto out_free_inst;
 
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 01a1f6aa30ac..5aea6d6c49a0 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -874,8 +874,8 @@ static int cryptd_create_aead(struct crypto_template *tmpl,
 	ctx = aead_instance_ctx(inst);
 	ctx->queue = queue;
 
-	crypto_set_aead_spawn(&ctx->aead_spawn, aead_crypto_instance(inst));
-	err = crypto_grab_aead(&ctx->aead_spawn, name, type, mask);
+	err = crypto_grab_aead(&ctx->aead_spawn, aead_crypto_instance(inst),
+			       name, type, mask);
 	if (err)
 		goto out_free_inst;
 
diff --git a/crypto/essiv.c b/crypto/essiv.c
index 2019250da08e..388cceb8c1a0 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -516,8 +516,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 		ictx = crypto_instance_ctx(inst);
 
 		/* AEAD cipher, e.g., "authenc(hmac(sha256),cbc(aes))" */
-		crypto_set_aead_spawn(&ictx->u.aead_spawn, inst);
-		err = crypto_grab_aead(&ictx->u.aead_spawn,
+		err = crypto_grab_aead(&ictx->u.aead_spawn, inst,
 				       inner_cipher_name, 0, mask);
 		if (err)
 			goto out_free_inst;
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 5a01b2b956f6..4241264ff93a 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -866,6 +866,7 @@ static int crypto_rfc4106_create(struct crypto_template *tmpl,
 				 struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
+	u32 mask;
 	struct aead_instance *inst;
 	struct crypto_aead_spawn *spawn;
 	struct aead_alg *alg;
@@ -879,6 +880,8 @@ static int crypto_rfc4106_create(struct crypto_template *tmpl,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
+	mask = crypto_requires_sync(algt->type, algt->mask);
+
 	ccm_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(ccm_name))
 		return PTR_ERR(ccm_name);
@@ -888,9 +891,8 @@ static int crypto_rfc4106_create(struct crypto_template *tmpl,
 		return -ENOMEM;
 
 	spawn = aead_instance_ctx(inst);
-	crypto_set_aead_spawn(spawn, aead_crypto_instance(inst));
-	err = crypto_grab_aead(spawn, ccm_name, 0,
-			       crypto_requires_sync(algt->type, algt->mask));
+	err = crypto_grab_aead(spawn, aead_crypto_instance(inst),
+			       ccm_name, 0, mask);
 	if (err)
 		goto out_free_inst;
 
@@ -1102,6 +1104,7 @@ static int crypto_rfc4543_create(struct crypto_template *tmpl,
 				struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
+	u32 mask;
 	struct aead_instance *inst;
 	struct crypto_aead_spawn *spawn;
 	struct aead_alg *alg;
@@ -1116,6 +1119,8 @@ static int crypto_rfc4543_create(struct crypto_template *tmpl,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
+	mask = crypto_requires_sync(algt->type, algt->mask);
+
 	ccm_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(ccm_name))
 		return PTR_ERR(ccm_name);
@@ -1126,9 +1131,8 @@ static int crypto_rfc4543_create(struct crypto_template *tmpl,
 
 	ctx = aead_instance_ctx(inst);
 	spawn = &ctx->aead;
-	crypto_set_aead_spawn(spawn, aead_crypto_instance(inst));
-	err = crypto_grab_aead(spawn, ccm_name, 0,
-			       crypto_requires_sync(algt->type, algt->mask));
+	err = crypto_grab_aead(spawn, aead_crypto_instance(inst),
+			       ccm_name, 0, mask);
 	if (err)
 		goto out_free_inst;
 
diff --git a/crypto/geniv.c b/crypto/geniv.c
index b9e45a2a98b5..7afa48414f3a 100644
--- a/crypto/geniv.c
+++ b/crypto/geniv.c
@@ -64,8 +64,8 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	/* Ignore async algorithms if necessary. */
 	mask |= crypto_requires_sync(algt->type, algt->mask);
 
-	crypto_set_aead_spawn(spawn, aead_crypto_instance(inst));
-	err = crypto_grab_aead(spawn, name, type, mask);
+	err = crypto_grab_aead(spawn, aead_crypto_instance(inst),
+			       name, type, mask);
 	if (err)
 		goto err_free_inst;
 
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index d6696e217128..1b632139a8c1 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -258,9 +258,8 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
 	if (!ctx->psdec)
 		goto out_free_psenc;
 
-	crypto_set_aead_spawn(&ctx->spawn, aead_crypto_instance(inst));
-
-	err = crypto_grab_aead(&ctx->spawn, name, 0, 0);
+	err = crypto_grab_aead(&ctx->spawn, aead_crypto_instance(inst),
+			       name, 0, 0);
 	if (err)
 		goto out_free_psdec;
 
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index 374185a7567f..27b7b0224ea6 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -81,14 +81,9 @@ static inline struct aead_request *aead_request_cast(
 	return container_of(req, struct aead_request, base);
 }
 
-static inline void crypto_set_aead_spawn(
-	struct crypto_aead_spawn *spawn, struct crypto_instance *inst)
-{
-	crypto_set_spawn(&spawn->base, inst);
-}
-
-int crypto_grab_aead(struct crypto_aead_spawn *spawn, const char *name,
-		     u32 type, u32 mask);
+int crypto_grab_aead(struct crypto_aead_spawn *spawn,
+		     struct crypto_instance *inst,
+		     const char *name, u32 type, u32 mask);
 
 static inline void crypto_drop_aead(struct crypto_aead_spawn *spawn)
 {
-- 
2.24.1

