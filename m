Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A30C2D0DB
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4F9C21775
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588291;
	bh=hZFeqYAzEsmlkEGrVH+RMJl1s1c118MVu3XWCo3kdLY=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=iadPXwWyKZQ/9mU8d1xd7W13TgvitsdwEJinM0asfOES8uPl2xr8+5yI6VCVqYIZ7
	 Ft6gKgcIyJzmtk3RJYCIsLjnUAWMQOIU6ah/EER3g5M2UOuCwbOH8GeZN8U105hnJ+
	 9oc8vBqfJh1lGju7lHNdpGw7EvnCid6DbJqgPerI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfL2C6K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbfL2C6G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:06 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70CA5218AC
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588285;
        bh=hZFeqYAzEsmlkEGrVH+RMJl1s1c118MVu3XWCo3kdLY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KmKR0L70zCJPdIKNLOBCP/G0PYK8f83V4pkYBm2t73XMz7HMpw9ppsPfmaDOyV+A9
         CqpIEVhQBbyfarOg+hYV3j65EH+Er2UBeBJe0Vi3gyBrMbmeTnTCioVM01J3oTzWnH
         bvJ24wIm3Srrnh6+pv4VLt9HBBMPYqlZCW/R1qz4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 07/28] crypto: akcipher - pass instance to crypto_grab_akcipher()
Date:   Sat, 28 Dec 2019 20:56:53 -0600
Message-Id: <20191229025714.544159-8-ebiggers@kernel.org>
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

Initializing a crypto_akcipher_spawn currently requires:

1. Set spawn->base.inst to point to the instance.
2. Call crypto_grab_akcipher().

But there's no reason for these steps to be separate, and in fact this
unneeded complication has caused at least one bug, the one fixed by
commit 6db43410179b ("crypto: adiantum - initialize crypto_spawn::inst")

So just make crypto_grab_akcipher() take the instance as an argument.

To keep the function call from getting too unwieldy due to this extra
argument, also introduce a 'mask' variable into pkcs1pad_create().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/akcipher.c                  |  6 ++++--
 crypto/rsa-pkcs1pad.c              |  8 +++++---
 include/crypto/internal/akcipher.h | 12 +++---------
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 7d5cf4939423..84ccf9b02bbe 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -90,9 +90,11 @@ static const struct crypto_type crypto_akcipher_type = {
 	.tfmsize = offsetof(struct crypto_akcipher, base),
 };
 
-int crypto_grab_akcipher(struct crypto_akcipher_spawn *spawn, const char *name,
-			 u32 type, u32 mask)
+int crypto_grab_akcipher(struct crypto_akcipher_spawn *spawn,
+			 struct crypto_instance *inst,
+			 const char *name, u32 type, u32 mask)
 {
+	spawn->base.inst = inst;
 	spawn->base.frontend = &crypto_akcipher_type;
 	return crypto_grab_spawn(&spawn->base, name, type, mask);
 }
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 0aa489711ec4..176b63afec8d 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -598,6 +598,7 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	const struct rsa_asn1_template *digest_info;
 	struct crypto_attr_type *algt;
+	u32 mask;
 	struct akcipher_instance *inst;
 	struct pkcs1pad_inst_ctx *ctx;
 	struct crypto_akcipher_spawn *spawn;
@@ -613,6 +614,8 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AKCIPHER) & algt->mask)
 		return -EINVAL;
 
+	mask = crypto_requires_sync(algt->type, algt->mask);
+
 	rsa_alg_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(rsa_alg_name))
 		return PTR_ERR(rsa_alg_name);
@@ -636,9 +639,8 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 	spawn = &ctx->spawn;
 	ctx->digest_info = digest_info;
 
-	crypto_set_spawn(&spawn->base, akcipher_crypto_instance(inst));
-	err = crypto_grab_akcipher(spawn, rsa_alg_name, 0,
-			crypto_requires_sync(algt->type, algt->mask));
+	err = crypto_grab_akcipher(spawn, akcipher_crypto_instance(inst),
+				   rsa_alg_name, 0, mask);
 	if (err)
 		goto out_free_inst;
 
diff --git a/include/crypto/internal/akcipher.h b/include/crypto/internal/akcipher.h
index d6c8a42789ad..8d3220c9ab77 100644
--- a/include/crypto/internal/akcipher.h
+++ b/include/crypto/internal/akcipher.h
@@ -78,15 +78,9 @@ static inline void *akcipher_instance_ctx(struct akcipher_instance *inst)
 	return crypto_instance_ctx(akcipher_crypto_instance(inst));
 }
 
-static inline void crypto_set_akcipher_spawn(
-		struct crypto_akcipher_spawn *spawn,
-		struct crypto_instance *inst)
-{
-	crypto_set_spawn(&spawn->base, inst);
-}
-
-int crypto_grab_akcipher(struct crypto_akcipher_spawn *spawn, const char *name,
-		u32 type, u32 mask);
+int crypto_grab_akcipher(struct crypto_akcipher_spawn *spawn,
+			 struct crypto_instance *inst,
+			 const char *name, u32 type, u32 mask);
 
 static inline struct crypto_akcipher *crypto_spawn_akcipher(
 		struct crypto_akcipher_spawn *spawn)
-- 
2.24.1

