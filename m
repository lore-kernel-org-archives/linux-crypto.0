Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD13C2D0CE
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 969A721D7D
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024095;
	bh=V3lijhL1CcRJBGzyQYzwYDpjzE+0JY70cR572uthStI=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=sh8m9Rp2+67CvWq7oXUrUGNyk8tAgXE6TNuksRffV9Bo6x20pGsdAw49V0BqW6ETI
	 uoiZIiLzzpEZ1SUmCATC1PiwiZYkydx9YAsReOJcbWciSjzV6qt7v7Jt0kXeoqP68m
	 Le+tdN06J1IFoSBwa2CMpSwXZECs73y7snJWCqbM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbgACEBe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:01:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727234AbgACEBa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:01:30 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9868E24672
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024089;
        bh=V3lijhL1CcRJBGzyQYzwYDpjzE+0JY70cR572uthStI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=AkSdzzljJGMqe396AU8h5zUQH5mWXMkNoSKBpQ9nERkpzsvobex8bBS/zwEHjAbK6
         IKRkds3PHoCCdf8nu/MZ320LlbmCdNJONn3dknJnIZ+zNxS34BQQihMTfeUToXfQUA
         mEqRtW3BsIDaZDxEJAWSvlpUujdUfdtcIVOQw9M4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 28/28] crypto: algapi - fold crypto_init_spawn() into crypto_grab_spawn()
Date:   Thu,  2 Jan 2020 19:59:08 -0800
Message-Id: <20200103035908.12048-29-ebiggers@kernel.org>
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

Now that crypto_init_spawn() is only called by crypto_grab_spawn(),
simplify things by moving its functionality into crypto_grab_spawn().

In the process of doing this, also be more consistent about when the
spawn and instance are updated, and remove the crypto_spawn::dropref
flag since now it's always set.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algapi.c         | 43 ++++++++++++++---------------------------
 include/crypto/algapi.h |  3 ---
 2 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index f66a4ff57e6e..72592795c7e7 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -629,8 +629,7 @@ int crypto_register_instance(struct crypto_template *tmpl,
 		spawn->inst = inst;
 		spawn->registered = true;
 
-		if (spawn->dropref)
-			crypto_mod_put(spawn->alg);
+		crypto_mod_put(spawn->alg);
 
 		spawn = next;
 	}
@@ -672,47 +671,33 @@ void crypto_unregister_instance(struct crypto_instance *inst)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_instance);
 
-int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
-		      struct crypto_instance *inst, u32 mask)
+int crypto_grab_spawn(struct crypto_spawn *spawn, struct crypto_instance *inst,
+		      const char *name, u32 type, u32 mask)
 {
+	struct crypto_alg *alg;
 	int err = -EAGAIN;
 
 	if (WARN_ON_ONCE(inst == NULL))
 		return -EINVAL;
 
-	spawn->next = inst->spawns;
-	inst->spawns = spawn;
+	/* Allow the result of crypto_attr_alg_name() to be passed directly */
+	if (IS_ERR(name))
+		return PTR_ERR(name);
 
-	spawn->mask = mask;
+	alg = crypto_find_alg(name, spawn->frontend, type, mask);
+	if (IS_ERR(alg))
+		return PTR_ERR(alg);
 
 	down_write(&crypto_alg_sem);
 	if (!crypto_is_moribund(alg)) {
 		list_add(&spawn->list, &alg->cra_users);
 		spawn->alg = alg;
+		spawn->mask = mask;
+		spawn->next = inst->spawns;
+		inst->spawns = spawn;
 		err = 0;
 	}
 	up_write(&crypto_alg_sem);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(crypto_init_spawn);
-
-int crypto_grab_spawn(struct crypto_spawn *spawn, struct crypto_instance *inst,
-		      const char *name, u32 type, u32 mask)
-{
-	struct crypto_alg *alg;
-	int err;
-
-	/* Allow the result of crypto_attr_alg_name() to be passed directly */
-	if (IS_ERR(name))
-		return PTR_ERR(name);
-
-	alg = crypto_find_alg(name, spawn->frontend, type, mask);
-	if (IS_ERR(alg))
-		return PTR_ERR(alg);
-
-	spawn->dropref = true;
-	err = crypto_init_spawn(spawn, alg, inst, mask);
 	if (err)
 		crypto_mod_put(alg);
 	return err;
@@ -729,7 +714,7 @@ void crypto_drop_spawn(struct crypto_spawn *spawn)
 		list_del(&spawn->list);
 	up_write(&crypto_alg_sem);
 
-	if (spawn->dropref && !spawn->registered)
+	if (!spawn->registered)
 		crypto_mod_put(spawn->alg);
 }
 EXPORT_SYMBOL_GPL(crypto_drop_spawn);
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 224c72743cce..c16c50f8dac1 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -82,7 +82,6 @@ struct crypto_spawn {
 	const struct crypto_type *frontend;
 	u32 mask;
 	bool dead;
-	bool dropref;
 	bool registered;
 };
 
@@ -111,8 +110,6 @@ int crypto_register_instance(struct crypto_template *tmpl,
 			     struct crypto_instance *inst);
 void crypto_unregister_instance(struct crypto_instance *inst);
 
-int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
-		      struct crypto_instance *inst, u32 mask);
 int crypto_grab_spawn(struct crypto_spawn *spawn, struct crypto_instance *inst,
 		      const char *name, u32 type, u32 mask);
 void crypto_drop_spawn(struct crypto_spawn *spawn);
-- 
2.24.1

