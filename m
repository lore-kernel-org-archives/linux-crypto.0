Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B891C2D0CE
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6F562464B
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024087;
	bh=hZFeqYAzEsmlkEGrVH+RMJl1s1c118MVu3XWCo3kdLY=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=f74Hf/g8TewD2HEGv/6kBMUHRVRQZIPEMoXGueRzd3sOAubYiW53jZutETF88I28g
	 Ik6To5WcvwZck7yM+kqLVphxvMPV/5J+11bzaKJt1+FNWrU7g6x9E8M5eIg9WAl0EO
	 iH0DmjluXAzj4QN7DqIWmu5xzUywEMa4W0oFsSV0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgACEB0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:01:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:33508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726792AbgACEB0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:01:26 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 775C822314
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024085;
        bh=hZFeqYAzEsmlkEGrVH+RMJl1s1c118MVu3XWCo3kdLY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pHnb8Gt25df9fCc8Np1J48BYikvAS/0ujnFEVW/9c6u+Bg5Xpo1f1IgzvOYCGHF7v
         hmcOKoPhGJ22dTaCdrv6f7VAXCP8LJxAU6fyFLDLZyMU+G/h/K1Cx6aSG/OOGNEfoV
         vv3xGW0c6VE6EAKRPKtByvNkUC56NWbEPDfLelOk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 07/28] crypto: akcipher - pass instance to crypto_grab_akcipher()
Date:   Thu,  2 Jan 2020 19:58:47 -0800
Message-Id: <20200103035908.12048-8-ebiggers@kernel.org>
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

