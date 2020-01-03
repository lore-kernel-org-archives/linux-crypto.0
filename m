Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB1C7C2D0CE
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C353F22314
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024308;
	bh=CG0VvO0tf9L0WTD6lTGljzfh/+VIu6IlaUwE/ooGNiU=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=e5NOSzlDfjhSpJa6/ulJ3544w6yEqSfqBAUSJnqctO6XWCIufV38fT4FuhLCe8knv
	 ojDNWVX52utO+erjTqtC00Bizc7xjQGRx7X3iCFYds8gpCoGnWLav/jWyqPUHTmNwb
	 62mvZYdz2gZQHWC6JX8mdXOj6/DzB3Xleo2xd8hU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgACEFI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:05:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726504AbgACEFH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:05:07 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3090522314
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024306;
        bh=CG0VvO0tf9L0WTD6lTGljzfh/+VIu6IlaUwE/ooGNiU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dwLQnlZNe6uKQW4robOf3dL2ri7aCx9oCnhfrliNTsO1XKtknyVXxCO93XnsGPEj2
         9CgrHKP/VSx4l/AJNya7FEPMaiHH8v9Z3I5UJftx8cKqmmcMcnm0LEyQsQGAB75CXn
         X3IGoxLEymLUtixGY4HyO7hEfPif5XgbRF9hLxq0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 2/6] crypto: geniv - convert to new way of freeing instances
Date:   Thu,  2 Jan 2020 20:04:36 -0800
Message-Id: <20200103040440.12375-3-ebiggers@kernel.org>
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

Convert the "seqiv" template to the new way of freeing instances where a
->free() method is installed to the instance struct itself.  Also remove
the unused implementation of the old way of freeing instances from the
"echainiv" template, since it's already using the new way too.

In doing this, also simplify the code by making the helper function
aead_geniv_alloc() install the ->free() method, instead of making seqiv
and echainiv do this themselves.  This is analogous to how
skcipher_alloc_instance_simple() works.

This will allow removing support for the old way of freeing instances.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/echainiv.c               | 20 ++++----------------
 crypto/geniv.c                  | 15 ++++++++-------
 crypto/seqiv.c                  | 20 ++++----------------
 include/crypto/internal/geniv.h |  1 -
 4 files changed, 16 insertions(+), 40 deletions(-)

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index a49cbf7b0929..4a2f02baba14 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -133,29 +133,17 @@ static int echainiv_aead_create(struct crypto_template *tmpl,
 	inst->alg.base.cra_ctxsize = sizeof(struct aead_geniv_ctx);
 	inst->alg.base.cra_ctxsize += inst->alg.ivsize;
 
-	inst->free = aead_geniv_free;
-
 	err = aead_register_instance(tmpl, inst);
-	if (err)
-		goto free_inst;
-
-out:
-	return err;
-
+	if (err) {
 free_inst:
-	aead_geniv_free(inst);
-	goto out;
-}
-
-static void echainiv_free(struct crypto_instance *inst)
-{
-	aead_geniv_free(aead_instance(inst));
+		inst->free(inst);
+	}
+	return err;
 }
 
 static struct crypto_template echainiv_tmpl = {
 	.name = "echainiv",
 	.create = echainiv_aead_create,
-	.free = echainiv_free,
 	.module = THIS_MODULE,
 };
 
diff --git a/crypto/geniv.c b/crypto/geniv.c
index 7afa48414f3a..dbcc640274cd 100644
--- a/crypto/geniv.c
+++ b/crypto/geniv.c
@@ -32,6 +32,12 @@ static int aead_geniv_setauthsize(struct crypto_aead *tfm,
 	return crypto_aead_setauthsize(ctx->child, authsize);
 }
 
+static void aead_geniv_free(struct aead_instance *inst)
+{
+	crypto_drop_aead(aead_instance_ctx(inst));
+	kfree(inst);
+}
+
 struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 				       struct rtattr **tb, u32 type, u32 mask)
 {
@@ -100,6 +106,8 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	inst->alg.ivsize = ivsize;
 	inst->alg.maxauthsize = maxauthsize;
 
+	inst->free = aead_geniv_free;
+
 out:
 	return inst;
 
@@ -112,13 +120,6 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 }
 EXPORT_SYMBOL_GPL(aead_geniv_alloc);
 
-void aead_geniv_free(struct aead_instance *inst)
-{
-	crypto_drop_aead(aead_instance_ctx(inst));
-	kfree(inst);
-}
-EXPORT_SYMBOL_GPL(aead_geniv_free);
-
 int aead_init_geniv(struct crypto_aead *aead)
 {
 	struct aead_geniv_ctx *ctx = crypto_aead_ctx(aead);
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 96d222c32acc..f124b9b54e15 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -18,8 +18,6 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 
-static void seqiv_free(struct crypto_instance *inst);
-
 static void seqiv_aead_encrypt_complete2(struct aead_request *req, int err)
 {
 	struct aead_request *subreq = aead_request_ctx(req);
@@ -159,15 +157,11 @@ static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_ctxsize += inst->alg.ivsize;
 
 	err = aead_register_instance(tmpl, inst);
-	if (err)
-		goto free_inst;
-
-out:
-	return err;
-
+	if (err) {
 free_inst:
-	aead_geniv_free(inst);
-	goto out;
+		inst->free(inst);
+	}
+	return err;
 }
 
 static int seqiv_create(struct crypto_template *tmpl, struct rtattr **tb)
@@ -184,15 +178,9 @@ static int seqiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	return seqiv_aead_create(tmpl, tb);
 }
 
-static void seqiv_free(struct crypto_instance *inst)
-{
-	aead_geniv_free(aead_instance(inst));
-}
-
 static struct crypto_template seqiv_tmpl = {
 	.name = "seqiv",
 	.create = seqiv_create,
-	.free = seqiv_free,
 	.module = THIS_MODULE,
 };
 
diff --git a/include/crypto/internal/geniv.h b/include/crypto/internal/geniv.h
index 0108c0c7b2ed..229d37681a9d 100644
--- a/include/crypto/internal/geniv.h
+++ b/include/crypto/internal/geniv.h
@@ -21,7 +21,6 @@ struct aead_geniv_ctx {
 
 struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 				       struct rtattr **tb, u32 type, u32 mask);
-void aead_geniv_free(struct aead_instance *inst);
 int aead_init_geniv(struct crypto_aead *tfm);
 void aead_exit_geniv(struct crypto_aead *tfm);
 
-- 
2.24.1

