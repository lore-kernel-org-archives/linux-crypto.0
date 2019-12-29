Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09CDFC2D0D1
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D59942176D
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588290;
	bh=0vNHIZX9OwAd9DVxrmZBP86/gccnDaja2AgRLONIP5Q=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=IuHaUV2s4HaLT+GopdvhfXTWDibduipr67LyKXXzTCtfay5Sp9iQEEog32KJVal3p
	 e/0tUkkgnAJkkVkxpBh8YxtdnEcssbgwYFWDS+hqwlnly9x+L9S+4hwc46rNT47+yr
	 GbnNO0E+U0TzaUAswCOfxbKpDBJknwfWUMCH3wkQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfL2C6J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbfL2C6J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:09 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FCA7222C3
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588288;
        bh=0vNHIZX9OwAd9DVxrmZBP86/gccnDaja2AgRLONIP5Q=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZTXEcNe7rdBXcLP4utvJ8DAukSLbw5tOPWG7hOr44vNIHg334ZAUHtW5eTx57e6cW
         xh6ScuA6P8nadIKrlOmmzxwnyLiEQqvvP2vXyqc6wTlDEk0osOxvcM/F3CgtVLtYUL
         oF4rpVq2vPACvyY1s7VWbn18BwYeQpo4VOCn9Rkg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 14/28] crypto: hmac - use crypto_grab_shash() and simplify error paths
Date:   Sat, 28 Dec 2019 20:57:00 -0600
Message-Id: <20191229025714.544159-15-ebiggers@kernel.org>
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

Make the hmac template use the new function crypto_grab_shash() to
initialize its shash spawn.

This is needed to make all spawns be initialized in a consistent way.

This required making hmac_create() allocate the instance directly rather
than use shash_alloc_instance().

Also simplify the error handling by taking advantage of crypto_drop_*()
now accepting (as a no-op) spawns that haven't been initialized yet, and
by taking advantage of crypto_grab_*() now handling ERR_PTR() names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/hmac.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 685e49953605..1e6b175ce361 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -165,6 +165,7 @@ static void hmac_exit_tfm(struct crypto_shash *parent)
 static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct shash_instance *inst;
+	struct crypto_shash_spawn *spawn;
 	struct crypto_alg *alg;
 	struct shash_alg *salg;
 	int err;
@@ -175,31 +176,32 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		return err;
 
-	salg = shash_attr_alg(tb[1], 0, 0);
-	if (IS_ERR(salg))
-		return PTR_ERR(salg);
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+	spawn = shash_instance_ctx(inst);
+
+	err = crypto_grab_shash(spawn, shash_crypto_instance(inst),
+				crypto_attr_alg_name(tb[1]), 0, 0);
+	if (err)
+		goto out;
+	salg = crypto_spawn_shash_alg(spawn);
 	alg = &salg->base;
 
 	/* The underlying hash algorithm must not require a key */
 	err = -EINVAL;
 	if (crypto_shash_alg_needs_key(salg))
-		goto out_put_alg;
+		goto out;
 
 	ds = salg->digestsize;
 	ss = salg->statesize;
 	if (ds > alg->cra_blocksize ||
 	    ss < alg->cra_blocksize)
-		goto out_put_alg;
-
-	inst = shash_alloc_instance("hmac", alg);
-	err = PTR_ERR(inst);
-	if (IS_ERR(inst))
-		goto out_put_alg;
+		goto out;
 
-	err = crypto_init_shash_spawn(shash_instance_ctx(inst), salg,
-				      shash_crypto_instance(inst));
+	err = crypto_inst_setname(shash_crypto_instance(inst), tmpl->name, alg);
 	if (err)
-		goto out_free_inst;
+		goto out;
 
 	inst->alg.base.cra_priority = alg->cra_priority;
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
@@ -223,13 +225,9 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.exit_tfm = hmac_exit_tfm;
 
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

