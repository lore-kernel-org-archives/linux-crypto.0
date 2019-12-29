Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66AD6C2D0C0
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 21:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31FD220748
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 21:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577656207;
	bh=2pAoNKI8OJS74mROD6y5dbC2TYjQGU5qgUtm1mv3GIU=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=pvPF+D+l6fger59ZL8KE9B6tw04ajgFB7NFiX75qcX2+FIcJlu3i1DNxliDNtkv54
	 pAz4n7kXFDrrNHRwAvWdXEzlZvIe2gf+eAEkad6WUwAjKzCzWWHUqLcWUq9vXoN5pC
	 UC2Lec5uMhdY/2n1aIOcHfG11+qbBvWf3RD899E8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfL2VuG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Dec 2019 16:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbfL2VuG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Dec 2019 16:50:06 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E34D6208C4
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 21:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577656205;
        bh=2pAoNKI8OJS74mROD6y5dbC2TYjQGU5qgUtm1mv3GIU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=T4thifatZXy77658MXTNx92Ypaahw8Ij0YQ/U6ffW6Mqn4BYz/UJf9sikNr6GESSd
         wiFy49XfEh4MVYb0qOcjR/9k9kd1AoXIHxB3P6nqcnEUtR7KVJeNs/LSSkCEXmjAcY
         BdLhEQkLyNRrJpZEgmr2o/Rtfn//aOZJderYYZJo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 4/6] crypto: shash - convert shash_free_instance() to new style
Date:   Sun, 29 Dec 2019 15:48:28 -0600
Message-Id: <20191229214830.260965-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229214830.260965-1-ebiggers@kernel.org>
References: <20191229214830.260965-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Convert shash_free_instance() and its users to the new way of freeing
instances, where a ->free() method is installed to the instance struct
itself.  This replaces the weakly-typed method crypto_template::free().

This will allow removing support for the old way of freeing instances.

Also give shash_free_instance() a more descriptive name to reflect that
it's only for instances with a single spawn, not for any instance.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ccm.c                   | 5 +++--
 crypto/cmac.c                  | 5 +++--
 crypto/hmac.c                  | 5 +++--
 crypto/shash.c                 | 8 ++++----
 crypto/vmac.c                  | 5 +++--
 crypto/xcbc.c                  | 5 +++--
 include/crypto/internal/hash.h | 2 +-
 7 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 987c4d69948a..40814a00df80 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -938,10 +938,12 @@ static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.final = crypto_cbcmac_digest_final;
 	inst->alg.setkey = crypto_cbcmac_digest_setkey;
 
+	inst->free = shash_free_singlespawn_instance;
+
 	err = shash_register_instance(tmpl, inst);
 out:
 	if (err)
-		shash_free_instance(shash_crypto_instance(inst));
+		shash_free_singlespawn_instance(inst);
 	return err;
 }
 
@@ -949,7 +951,6 @@ static struct crypto_template crypto_ccm_tmpls[] = {
 	{
 		.name = "cbcmac",
 		.create = cbcmac_create,
-		.free = shash_free_instance,
 		.module = THIS_MODULE,
 	}, {
 		.name = "ccm_base",
diff --git a/crypto/cmac.c b/crypto/cmac.c
index cc4f46e2c46f..3fcaa555ee01 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -280,17 +280,18 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.final = crypto_cmac_digest_final;
 	inst->alg.setkey = crypto_cmac_digest_setkey;
 
+	inst->free = shash_free_singlespawn_instance;
+
 	err = shash_register_instance(tmpl, inst);
 out:
 	if (err)
-		shash_free_instance(shash_crypto_instance(inst));
+		shash_free_singlespawn_instance(inst);
 	return err;
 }
 
 static struct crypto_template crypto_cmac_tmpl = {
 	.name = "cmac",
 	.create = cmac_create,
-	.free = shash_free_instance,
 	.module = THIS_MODULE,
 };
 
diff --git a/crypto/hmac.c b/crypto/hmac.c
index 1e6b175ce361..ed1a8b0ee039 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -224,17 +224,18 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.init_tfm = hmac_init_tfm;
 	inst->alg.exit_tfm = hmac_exit_tfm;
 
+	inst->free = shash_free_singlespawn_instance;
+
 	err = shash_register_instance(tmpl, inst);
 out:
 	if (err)
-		shash_free_instance(shash_crypto_instance(inst));
+		shash_free_singlespawn_instance(inst);
 	return err;
 }
 
 static struct crypto_template hmac_tmpl = {
 	.name = "hmac",
 	.create = hmac_create,
-	.free = shash_free_instance,
 	.module = THIS_MODULE,
 };
 
diff --git a/crypto/shash.c b/crypto/shash.c
index 2f6adb49727b..e05e75b0f402 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -590,12 +590,12 @@ int shash_register_instance(struct crypto_template *tmpl,
 }
 EXPORT_SYMBOL_GPL(shash_register_instance);
 
-void shash_free_instance(struct crypto_instance *inst)
+void shash_free_singlespawn_instance(struct shash_instance *inst)
 {
-	crypto_drop_spawn(crypto_instance_ctx(inst));
-	kfree(shash_instance(inst));
+	crypto_drop_spawn(shash_instance_ctx(inst));
+	kfree(inst);
 }
-EXPORT_SYMBOL_GPL(shash_free_instance);
+EXPORT_SYMBOL_GPL(shash_free_singlespawn_instance);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Synchronous cryptographic hash type");
diff --git a/crypto/vmac.c b/crypto/vmac.c
index 5241b183f8df..1554455359d5 100644
--- a/crypto/vmac.c
+++ b/crypto/vmac.c
@@ -662,17 +662,18 @@ static int vmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.final = vmac_final;
 	inst->alg.setkey = vmac_setkey;
 
+	inst->free = shash_free_singlespawn_instance;
+
 	err = shash_register_instance(tmpl, inst);
 out:
 	if (err)
-		shash_free_instance(shash_crypto_instance(inst));
+		shash_free_singlespawn_instance(inst);
 	return err;
 }
 
 static struct crypto_template vmac64_tmpl = {
 	.name = "vmac64",
 	.create = vmac_create,
-	.free = shash_free_instance,
 	.module = THIS_MODULE,
 };
 
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 5fa700ab4387..d6f969389e18 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -239,17 +239,18 @@ static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.final = crypto_xcbc_digest_final;
 	inst->alg.setkey = crypto_xcbc_digest_setkey;
 
+	inst->free = shash_free_singlespawn_instance;
+
 	err = shash_register_instance(tmpl, inst);
 out:
 	if (err)
-		shash_free_instance(shash_crypto_instance(inst));
+		shash_free_singlespawn_instance(inst);
 	return err;
 }
 
 static struct crypto_template crypto_xcbc_tmpl = {
 	.name = "xcbc",
 	.create = xcbc_create,
-	.free = shash_free_instance,
 	.module = THIS_MODULE,
 };
 
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index c550386221bb..89f6f46ab2b8 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -125,7 +125,7 @@ int crypto_register_shashes(struct shash_alg *algs, int count);
 void crypto_unregister_shashes(struct shash_alg *algs, int count);
 int shash_register_instance(struct crypto_template *tmpl,
 			    struct shash_instance *inst);
-void shash_free_instance(struct crypto_instance *inst);
+void shash_free_singlespawn_instance(struct shash_instance *inst);
 
 int crypto_grab_shash(struct crypto_shash_spawn *spawn,
 		      struct crypto_instance *inst,
-- 
2.24.1

