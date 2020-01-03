Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E91C2D0CE
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00F0F21D7D
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024091;
	bh=ZWZKRU2mBzIREo72I47XbqSuNNF67PNQUGEaj77DA3Q=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=t4IRyMltDiqOHYSIgVm+/Ye+6LOXTWp/FD/ztfIm5SDmT3ZgvQN37vxnTi21G2N4M
	 oWPtYhUvgwgpzpIIoQ1DeT+7s0rm/2q1+Vtke8JevYUzwnxZYqSwjutK0KWIXgHSV6
	 wjiGLL38HCJFVleWZBy44GVOkQrQ2sjrN1N5ty4g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgACEBa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:01:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727213AbgACEB3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:01:29 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D6362464E
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024088;
        bh=ZWZKRU2mBzIREo72I47XbqSuNNF67PNQUGEaj77DA3Q=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=0auWb3dE2dmepdXhKxCWAJrP56Qv+1rB5JTBeZH2/dO3Sehcj+g+lO+SBN+dd2RUi
         lxjNGS8kwtAbwNi2dDtRmB6JUlapZ2av6bvpvAWOYaRuIPxP41xhX0AiMODFrTXoI5
         gm7f00CffbSNY/upQN+CE829rLqXwqQcJ9m65R5Q=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 20/28] crypto: skcipher - use crypto_grab_cipher() and simplify error paths
Date:   Thu,  2 Jan 2020 19:59:00 -0800
Message-Id: <20200103035908.12048-21-ebiggers@kernel.org>
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

Make skcipher_alloc_instance_simple() use the new function
crypto_grab_cipher() to initialize its cipher spawn.

This is needed to make all spawns be initialized in a consistent way.

Also simplify the error handling by taking advantage of crypto_drop_*()
now accepting (as a no-op) spawns that haven't been initialized yet, and
by taking advantage of crypto_grab_*() now handling ERR_PTR() names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c                  | 39 ++++++++++++------------------
 include/crypto/internal/skcipher.h |  4 +--
 2 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index a9418a7e80a9..5869ed0ddcad 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -923,7 +923,7 @@ static void skcipher_exit_tfm_simple(struct crypto_skcipher *tfm)
 
 static void skcipher_free_instance_simple(struct skcipher_instance *inst)
 {
-	crypto_drop_spawn(skcipher_instance_ctx(inst));
+	crypto_drop_cipher(skcipher_instance_ctx(inst));
 	kfree(inst);
 }
 
@@ -947,10 +947,10 @@ struct skcipher_instance *skcipher_alloc_instance_simple(
 	struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
-	struct crypto_alg *cipher_alg;
-	struct skcipher_instance *inst;
-	struct crypto_spawn *spawn;
 	u32 mask;
+	struct skcipher_instance *inst;
+	struct crypto_cipher_spawn *spawn;
+	struct crypto_alg *cipher_alg;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
@@ -960,32 +960,25 @@ struct skcipher_instance *skcipher_alloc_instance_simple(
 	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return ERR_PTR(-EINVAL);
 
-	mask = CRYPTO_ALG_TYPE_MASK |
-		crypto_requires_off(algt->type, algt->mask,
-				    CRYPTO_ALG_NEED_FALLBACK);
-
-	cipher_alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER, mask);
-	if (IS_ERR(cipher_alg))
-		return ERR_CAST(cipher_alg);
+	mask = crypto_requires_off(algt->type, algt->mask,
+				   CRYPTO_ALG_NEED_FALLBACK);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
-	if (!inst) {
-		err = -ENOMEM;
-		goto err_put_cipher_alg;
-	}
+	if (!inst)
+		return ERR_PTR(-ENOMEM);
 	spawn = skcipher_instance_ctx(inst);
 
-	err = crypto_inst_setname(skcipher_crypto_instance(inst), tmpl->name,
-				  cipher_alg);
+	err = crypto_grab_cipher(spawn, skcipher_crypto_instance(inst),
+				 crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
+	cipher_alg = crypto_spawn_cipher_alg(spawn);
 
-	spawn->dropref = true;
-	err = crypto_init_spawn(spawn, cipher_alg,
-				skcipher_crypto_instance(inst),
-				CRYPTO_ALG_TYPE_MASK);
+	err = crypto_inst_setname(skcipher_crypto_instance(inst), tmpl->name,
+				  cipher_alg);
 	if (err)
 		goto err_free_inst;
+
 	inst->free = skcipher_free_instance_simple;
 
 	/* Default algorithm properties, can be overridden */
@@ -1005,9 +998,7 @@ struct skcipher_instance *skcipher_alloc_instance_simple(
 	return inst;
 
 err_free_inst:
-	kfree(inst);
-err_put_cipher_alg:
-	crypto_mod_put(cipher_alg);
+	skcipher_free_instance_simple(inst);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(skcipher_alloc_instance_simple);
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index b81cb4902abc..d46517275b3c 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -216,9 +216,9 @@ struct skcipher_instance *skcipher_alloc_instance_simple(
 static inline struct crypto_alg *skcipher_ialg_simple(
 	struct skcipher_instance *inst)
 {
-	struct crypto_spawn *spawn = skcipher_instance_ctx(inst);
+	struct crypto_cipher_spawn *spawn = skcipher_instance_ctx(inst);
 
-	return spawn->alg;
+	return crypto_spawn_cipher_alg(spawn);
 }
 
 #endif	/* _CRYPTO_INTERNAL_SKCIPHER_H */
-- 
2.24.1

