Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C226AC32767
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99179222C3
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024308;
	bh=2bnWq3GcxQnxejHcydrNBGtWPa3vAYsf6XO9pjx2TgY=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=KSwss7QuF+zAansj1UDK09IUzarCMJh0j0xAuntBJ2WmJ79XQaHqByAYqbvWAvCdK
	 2j//2ds+YI7GgxL3GikIlrN72383rdAI9LH35P2TbMVznk8qakt7S7nSF7z9G+F2fp
	 qGd9OFpwfIeeA5pDIdGSwWCscNEFdVFGsIPXka0o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgACEFH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:05:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgACEFH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:05:07 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E9892253D
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024306;
        bh=2bnWq3GcxQnxejHcydrNBGtWPa3vAYsf6XO9pjx2TgY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nPIMXAdJNmH8Pt5NCwRsrhSuiCMsxD/lJ6swKXP1IZMdwDFgfAANLEgY2viCFmcJ0
         FwZ3Fmnyms1ZkLNLw6R5tANNep4IoFzwUgug2mO/RtiC0XihynjY7fwFOfd04AwVYM
         2g0IMDp7Ecm6mglcxDQTlHZipQEJMKLaplvMj6gc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 4/6] crypto: shash - convert shash_free_instance() to new style
Date:   Thu,  2 Jan 2020 20:04:38 -0800
Message-Id: <20200103040440.12375-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200103040440.12375-1-ebiggers@kernel.org>
References: <20200103040440.12375-1-ebiggers@kernel.org>
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
index c7a887565c51..6bb08cee816e 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -939,10 +939,12 @@ static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.final = crypto_cbcmac_digest_final;
 	inst->alg.setkey = crypto_cbcmac_digest_setkey;
 
+	inst->free = shash_free_singlespawn_instance;
+
 	err = shash_register_instance(tmpl, inst);
 	if (err) {
 err_free_inst:
-		shash_free_instance(shash_crypto_instance(inst));
+		shash_free_singlespawn_instance(inst);
 	}
 	return err;
 }
@@ -951,7 +953,6 @@ static struct crypto_template crypto_ccm_tmpls[] = {
 	{
 		.name = "cbcmac",
 		.create = cbcmac_create,
-		.free = shash_free_instance,
 		.module = THIS_MODULE,
 	}, {
 		.name = "ccm_base",
diff --git a/crypto/cmac.c b/crypto/cmac.c
index 58dc644416bb..143a6544c873 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -280,10 +280,12 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.final = crypto_cmac_digest_final;
 	inst->alg.setkey = crypto_cmac_digest_setkey;
 
+	inst->free = shash_free_singlespawn_instance;
+
 	err = shash_register_instance(tmpl, inst);
 	if (err) {
 err_free_inst:
-		shash_free_instance(shash_crypto_instance(inst));
+		shash_free_singlespawn_instance(inst);
 	}
 	return err;
 }
@@ -291,7 +293,6 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 static struct crypto_template crypto_cmac_tmpl = {
 	.name = "cmac",
 	.create = cmac_create,
-	.free = shash_free_instance,
 	.module = THIS_MODULE,
 };
 
diff --git a/crypto/hmac.c b/crypto/hmac.c
index 0a42b7075763..e38bfb948278 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -224,10 +224,12 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.init_tfm = hmac_init_tfm;
 	inst->alg.exit_tfm = hmac_exit_tfm;
 
+	inst->free = shash_free_singlespawn_instance;
+
 	err = shash_register_instance(tmpl, inst);
 	if (err) {
 err_free_inst:
-		shash_free_instance(shash_crypto_instance(inst));
+		shash_free_singlespawn_instance(inst);
 	}
 	return err;
 }
@@ -235,7 +237,6 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
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
index 3841b6e46081..fa8c4a7560a9 100644
--- a/crypto/vmac.c
+++ b/crypto/vmac.c
@@ -662,10 +662,12 @@ static int vmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.final = vmac_final;
 	inst->alg.setkey = vmac_setkey;
 
+	inst->free = shash_free_singlespawn_instance;
+
 	err = shash_register_instance(tmpl, inst);
 	if (err) {
 err_free_inst:
-		shash_free_instance(shash_crypto_instance(inst));
+		shash_free_singlespawn_instance(inst);
 	}
 	return err;
 }
@@ -673,7 +675,6 @@ static int vmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 static struct crypto_template vmac64_tmpl = {
 	.name = "vmac64",
 	.create = vmac_create,
-	.free = shash_free_instance,
 	.module = THIS_MODULE,
 };
 
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 9265e00ea663..598ec88abf0f 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -239,10 +239,12 @@ static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.final = crypto_xcbc_digest_final;
 	inst->alg.setkey = crypto_xcbc_digest_setkey;
 
+	inst->free = shash_free_singlespawn_instance;
+
 	err = shash_register_instance(tmpl, inst);
 	if (err) {
 err_free_inst:
-		shash_free_instance(shash_crypto_instance(inst));
+		shash_free_singlespawn_instance(inst);
 	}
 	return err;
 }
@@ -250,7 +252,6 @@ static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
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

