Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 366F2C2D0D1
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DA15206F4
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588295;
	bh=3yBk4PkrmWcKUwtCUfB+4a5IbcPF+VoajgYXI1ZFhkY=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=neiSfs7Kh9sMP6NUFkzBBo0lnlx6NFtiKSWbwN4RgTXIqGxw0N67UJiAlT7zr8Sai
	 TKDyxYT6I9VhEjBIsrQPvfCapdawotcEBpKhFGgIjqj8IlX7+1N46TyFU5cH1rjZyI
	 Jndkw71fsPRHl9dmrE4JS7XEW216pVR+niY5KK9U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfL2C6O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbfL2C6L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:11 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60A0D2176D
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588291;
        bh=3yBk4PkrmWcKUwtCUfB+4a5IbcPF+VoajgYXI1ZFhkY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=iUxJ9v1THvR+maj6zxE6wZpJ2ZCnQC/je4NJeFKBjgwnsZQDPQgwNAIioLYiZwywT
         Ucy9uOSkiafZ5HIERdZdoBGLYfkR3T3PlbdGR81Zp/dFYd5fuOfCJzcsvVLxU64U1h
         IfTPe6MXY2Dflrm/LvJ8NwHDysG8t+70ZBetu5Bk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 21/28] crypto: cbcmac - use crypto_grab_cipher() and simplify error paths
Date:   Sat, 28 Dec 2019 20:57:07 -0600
Message-Id: <20191229025714.544159-22-ebiggers@kernel.org>
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

Make the cbcmac template use the new function crypto_grab_cipher() to
initialize its cipher spawn.

This is needed to make all spawns be initialized in a consistent way.

This required making cbcmac_create() allocate the instance directly
rather than use shash_alloc_instance().

Also simplify the error handling by taking advantage of crypto_drop_*()
now accepting (as a no-op) spawns that haven't been initialized yet, and
by taking advantage of crypto_grab_*() now handling ERR_PTR() names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ccm.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index f430f3650b52..7deb533c7486 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -898,6 +898,7 @@ static void cbcmac_exit_tfm(struct crypto_tfm *tfm)
 static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct shash_instance *inst;
+	struct crypto_cipher_spawn *spawn;
 	struct crypto_alg *alg;
 	int err;
 
@@ -905,21 +906,20 @@ static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
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
 
-	inst = shash_alloc_instance("cbcmac", alg);
-	err = PTR_ERR(inst);
-	if (IS_ERR(inst))
-		goto out_put_alg;
+	err = crypto_grab_cipher(spawn, shash_crypto_instance(inst),
+				 crypto_attr_alg_name(tb[1]), 0, 0);
+	if (err)
+		goto out;
+	alg = crypto_spawn_cipher_alg(spawn);
 
-	err = crypto_init_spawn(shash_instance_ctx(inst), alg,
-				shash_crypto_instance(inst),
-				CRYPTO_ALG_TYPE_MASK);
+	err = crypto_inst_setname(shash_crypto_instance(inst), tmpl->name, alg);
 	if (err)
-		goto out_free_inst;
+		goto out;
 
 	inst->alg.base.cra_priority = alg->cra_priority;
 	inst->alg.base.cra_blocksize = 1;
@@ -939,13 +939,9 @@ static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.setkey = crypto_cbcmac_digest_setkey;
 
 	err = shash_register_instance(tmpl, inst);
-
-out_free_inst:
+out:
 	if (err)
 		shash_free_instance(shash_crypto_instance(inst));
-
-out_put_alg:
-	crypto_mod_put(alg);
 	return err;
 }
 
-- 
2.24.1

