Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88621C2D0DB
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F3C421927
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588287;
	bh=T3wXyJUd3JddE1g429EumTNn10IDMcTcuSRCr0rOByY=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hb3y/t35EapTSwXMWwwu6DVMJ+YzmRQTfNdByilK573dRISlYbufkT1eN1zOeMwG3
	 PanA3rTqoUSVdAz0hYG+PF9slyRwAbrFsobZzT3NJA5OBYkjoXGM0gQWIIcPIAbE01
	 RDbpkfhSQgCoklyBn8xeG/l4Mas8K/gBJ4JBcZSA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfL2C6G (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbfL2C6G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:06 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF72F21744
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588286;
        bh=T3wXyJUd3JddE1g429EumTNn10IDMcTcuSRCr0rOByY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=yDg6hTByckX1LzSjnviPhGf6i6rGnDkADtvQ5wormu1uj3wTvU7xy7jyKyzuIagiK
         qYr+L0FV9Pr3SwxFYft5MvOqlvhKNt9DpHqwR3qgSSVFB4MVHX9SRPhOZ73RqwFSN3
         iNF2AJfrvd4UVKG/pc8PTSTAcIitCTSIYKIRXYcs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 08/28] crypto: algapi - pass instance to crypto_grab_spawn()
Date:   Sat, 28 Dec 2019 20:56:54 -0600
Message-Id: <20191229025714.544159-9-ebiggers@kernel.org>
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

Currently, crypto_spawn::inst is first used temporarily to pass the
instance to crypto_grab_spawn().  Then crypto_init_spawn() overwrites it
with crypto_spawn::next, which shares the same union.  Finally,
crypto_spawn::inst is set again when the instance is registered.

Make this less convoluted by just passing the instance as an argument to
crypto_grab_spawn() instead.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/adiantum.c       |  6 +++---
 crypto/aead.c           |  3 +--
 crypto/akcipher.c       |  3 +--
 crypto/algapi.c         |  6 +++---
 crypto/skcipher.c       |  3 +--
 include/crypto/algapi.h | 10 ++--------
 6 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index aaf8a66f871c..9e44180111c8 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -550,9 +550,9 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	streamcipher_alg = crypto_spawn_skcipher_alg(&ictx->streamcipher_spawn);
 
 	/* Block cipher, e.g. "aes" */
-	crypto_set_spawn(&ictx->blockcipher_spawn,
-			 skcipher_crypto_instance(inst));
-	err = crypto_grab_spawn(&ictx->blockcipher_spawn, blockcipher_name,
+	err = crypto_grab_spawn(&ictx->blockcipher_spawn,
+				skcipher_crypto_instance(inst),
+				blockcipher_name,
 				CRYPTO_ALG_TYPE_CIPHER, CRYPTO_ALG_TYPE_MASK);
 	if (err)
 		goto out_drop_streamcipher;
diff --git a/crypto/aead.c b/crypto/aead.c
index c7135e00b8ea..02a0db076d7e 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -211,9 +211,8 @@ int crypto_grab_aead(struct crypto_aead_spawn *spawn,
 		     struct crypto_instance *inst,
 		     const char *name, u32 type, u32 mask)
 {
-	spawn->base.inst = inst;
 	spawn->base.frontend = &crypto_aead_type;
-	return crypto_grab_spawn(&spawn->base, name, type, mask);
+	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_grab_aead);
 
diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 84ccf9b02bbe..eeed6c151d2f 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -94,9 +94,8 @@ int crypto_grab_akcipher(struct crypto_akcipher_spawn *spawn,
 			 struct crypto_instance *inst,
 			 const char *name, u32 type, u32 mask)
 {
-	spawn->base.inst = inst;
 	spawn->base.frontend = &crypto_akcipher_type;
-	return crypto_grab_spawn(&spawn->base, name, type, mask);
+	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_grab_akcipher);
 
diff --git a/crypto/algapi.c b/crypto/algapi.c
index a5223c5f2275..a25ce02918f8 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -714,8 +714,8 @@ int crypto_init_spawn2(struct crypto_spawn *spawn, struct crypto_alg *alg,
 }
 EXPORT_SYMBOL_GPL(crypto_init_spawn2);
 
-int crypto_grab_spawn(struct crypto_spawn *spawn, const char *name,
-		      u32 type, u32 mask)
+int crypto_grab_spawn(struct crypto_spawn *spawn, struct crypto_instance *inst,
+		      const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
 	int err;
@@ -729,7 +729,7 @@ int crypto_grab_spawn(struct crypto_spawn *spawn, const char *name,
 		return PTR_ERR(alg);
 
 	spawn->dropref = true;
-	err = crypto_init_spawn(spawn, alg, spawn->inst, mask);
+	err = crypto_init_spawn(spawn, alg, inst, mask);
 	if (err)
 		crypto_mod_put(alg);
 	return err;
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index e5083dccccdc..a9418a7e80a9 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -761,9 +761,8 @@ int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn,
 			 struct crypto_instance *inst,
 			 const char *name, u32 type, u32 mask)
 {
-	spawn->base.inst = inst;
 	spawn->base.frontend = &crypto_skcipher_type;
-	return crypto_grab_spawn(&spawn->base, name, type, mask);
+	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_grab_skcipher);
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 5022cada4fc6..2779c8d34ba9 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -116,20 +116,14 @@ int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
 int crypto_init_spawn2(struct crypto_spawn *spawn, struct crypto_alg *alg,
 		       struct crypto_instance *inst,
 		       const struct crypto_type *frontend);
-int crypto_grab_spawn(struct crypto_spawn *spawn, const char *name,
-		      u32 type, u32 mask);
+int crypto_grab_spawn(struct crypto_spawn *spawn, struct crypto_instance *inst,
+		      const char *name, u32 type, u32 mask);
 
 void crypto_drop_spawn(struct crypto_spawn *spawn);
 struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
 				    u32 mask);
 void *crypto_spawn_tfm2(struct crypto_spawn *spawn);
 
-static inline void crypto_set_spawn(struct crypto_spawn *spawn,
-				    struct crypto_instance *inst)
-{
-	spawn->inst = inst;
-}
-
 struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb);
 int crypto_check_attr_type(struct rtattr **tb, u32 type);
 const char *crypto_attr_alg_name(struct rtattr *rta);
-- 
2.24.1

