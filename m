Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92472C2D0DA
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EC3A21744
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588298;
	bh=/tDzWVblgdkGT9ABLhJVn0LjA7ozyyw2gh7yHUcBp+M=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=DXa2WQ7KdWtvTM5M3kvHXKhVH5f+rUGKCrePrTiCDFuFAgx/MLtYkI+03c7Cs8zMI
	 4qYSUUnO7Vh4lVdrs8VNP/4Tnp9Ny0UP5g05HfSd0sv/W/ZKRqn0ICD17GoQBNSJQ0
	 +UYtbZxEnABO/J2FOe9SGe0wb+F3W/LzY+mt9Sm8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfL2C6R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbfL2C6M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:12 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD90221744
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588291;
        bh=/tDzWVblgdkGT9ABLhJVn0LjA7ozyyw2gh7yHUcBp+M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=0nZiHER1ecEg3j67CXEw4lBarj8QS+wWO5vCnWctdWWcFr2lAnqcYlOxI8x6UhjB8
         qgfkZPWRmXJHeyfMgDuDI7gayC7JqoEJbPo/mEGmB02uU5pgW2FbdNq6n5ZmyMnMY1
         YOcppNO1YZ8RQe5lqpGCB3oyr0QLzKtRASrZwHjk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 22/28] crypto: cmac - use crypto_grab_cipher() and simplify error paths
Date:   Sat, 28 Dec 2019 20:57:08 -0600
Message-Id: <20191229025714.544159-23-ebiggers@kernel.org>
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

Make the cmac template use the new function crypto_grab_cipher() to
initialize its cipher spawn.

This is needed to make all spawns be initialized in a consistent way.

This required making cmac_create() allocate the instance directly rather
than use shash_alloc_instance().

Also simplify the error handling by taking advantage of crypto_drop_*()
now accepting (as a no-op) spawns that haven't been initialized yet, and
by taking advantage of crypto_grab_*() now handling ERR_PTR() names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/cmac.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/crypto/cmac.c b/crypto/cmac.c
index 0928aebc6205..cb41aab2fe58 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -222,6 +222,7 @@ static void cmac_exit_tfm(struct crypto_tfm *tfm)
 static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct shash_instance *inst;
+	struct crypto_cipher_spawn *spawn;
 	struct crypto_alg *alg;
 	unsigned long alignmask;
 	int err;
@@ -230,10 +231,16 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		return err;
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_MASK);
-	if (IS_ERR(alg))
-		return PTR_ERR(alg);
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+	spawn = shash_instance_ctx(inst);
+
+	err = crypto_grab_cipher(spawn, shash_crypto_instance(inst),
+				 crypto_attr_alg_name(tb[1]), 0, 0);
+	if (err)
+		goto out;
+	alg = crypto_spawn_cipher_alg(spawn);
 
 	switch (alg->cra_blocksize) {
 	case 16:
@@ -241,19 +248,12 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 		break;
 	default:
 		err = -EINVAL;
-		goto out_put_alg;
+		goto out;
 	}
 
-	inst = shash_alloc_instance("cmac", alg);
-	err = PTR_ERR(inst);
-	if (IS_ERR(inst))
-		goto out_put_alg;
-
-	err = crypto_init_spawn(shash_instance_ctx(inst), alg,
-				shash_crypto_instance(inst),
-				CRYPTO_ALG_TYPE_MASK);
+	err = crypto_inst_setname(shash_crypto_instance(inst), tmpl->name, alg);
 	if (err)
-		goto out_free_inst;
+		goto out;
 
 	alignmask = alg->cra_alignmask;
 	inst->alg.base.cra_alignmask = alignmask;
@@ -281,13 +281,9 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.setkey = crypto_cmac_digest_setkey;
 
 	err = shash_register_instance(tmpl, inst);
-	if (err) {
-out_free_inst:
+out:
+	if (err)
 		shash_free_instance(shash_crypto_instance(inst));
-	}
-
-out_put_alg:
-	crypto_mod_put(alg);
 	return err;
 }
 
-- 
2.24.1

