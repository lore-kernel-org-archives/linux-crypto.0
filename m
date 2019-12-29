Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19E0C2D0D1
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 21:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 774B3207FD
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 21:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577656206;
	bh=pecumluERrj6IQvcKL5LGhcfUBRFtThn7EhHkKMq+nU=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LWmGLpLqH/RUp/spbORrFq2UlraeW3/ViUc168BoYlKenCzCY3x5Kcsou3EuaiT4b
	 l5VdJMpPEXF9X8gGyfF3pdglUbbRr5fwCKjj+jvBy1KEY0ujp4XY8ub3rYu7mpKkm/
	 Sl2lplqO5tU+Gn2g0pfxHo5VIs1E8PfbPdrW3YIo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfL2VuF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Dec 2019 16:50:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:55502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbfL2VuF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Dec 2019 16:50:05 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84E6F207FF
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 21:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577656204;
        bh=pecumluERrj6IQvcKL5LGhcfUBRFtThn7EhHkKMq+nU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pyhNcWk8XdU5dd00CfYx3ioqYUBzQcWOVTG50Iu95LjjqMOoK9AEMEcyY6Mjtky07
         jrelJH8YITRHgQqrCe+jxT2b+fMD+6HZhkYgx4kQso0E9c9eDBK/1VKwI/6hJ2UoFd
         VZkFpx51YvXBeN6QA2yADlUFRDG007+QuNdx5AlY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 3/6] crypto: cryptd - convert to new way of freeing instances
Date:   Sun, 29 Dec 2019 15:48:27 -0600
Message-Id: <20191229214830.260965-4-ebiggers@kernel.org>
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

Convert the "cryptd" template to the new way of freeing instances, where
a ->free() method is installed to the instance struct itself.  This
replaces the weakly-typed method crypto_template::free().

This will allow removing support for the old way of freeing instances.

Note that the 'default' case in cryptd_free() was already unreachable.
So, we aren't missing anything by keeping only the ahash and aead parts.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/cryptd.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 2b4c39a8fd80..7e8d2baee1b5 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -640,6 +640,14 @@ static int cryptd_hash_import(struct ahash_request *req, const void *in)
 	return crypto_shash_import(desc, in);
 }
 
+static void cryptd_hash_free(struct ahash_instance *inst)
+{
+	struct hashd_instance_ctx *ctx = ahash_instance_ctx(inst);
+
+	crypto_drop_shash(&ctx->spawn);
+	kfree(inst);
+}
+
 static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 			      struct cryptd_queue *queue)
 {
@@ -690,6 +698,8 @@ static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 		inst->alg.setkey = cryptd_hash_setkey;
 	inst->alg.digest = cryptd_hash_digest_enqueue;
 
+	inst->free = cryptd_hash_free;
+
 	err = ahash_register_instance(tmpl, inst);
 out:
 	if (err) {
@@ -817,6 +827,14 @@ static void cryptd_aead_exit_tfm(struct crypto_aead *tfm)
 	crypto_free_aead(ctx->child);
 }
 
+static void cryptd_aead_free(struct aead_instance *inst)
+{
+	struct aead_instance_ctx *ctx = aead_instance_ctx(inst);
+
+	crypto_drop_aead(&ctx->aead_spawn);
+	kfree(inst);
+}
+
 static int cryptd_create_aead(struct crypto_template *tmpl,
 		              struct rtattr **tb,
 			      struct cryptd_queue *queue)
@@ -866,6 +884,8 @@ static int cryptd_create_aead(struct crypto_template *tmpl,
 	inst->alg.encrypt = cryptd_aead_encrypt_enqueue;
 	inst->alg.decrypt = cryptd_aead_decrypt_enqueue;
 
+	inst->free = cryptd_aead_free;
+
 	err = aead_register_instance(tmpl, inst);
 	if (err) {
 out_drop_aead:
@@ -898,31 +918,9 @@ static int cryptd_create(struct crypto_template *tmpl, struct rtattr **tb)
 	return -EINVAL;
 }
 
-static void cryptd_free(struct crypto_instance *inst)
-{
-	struct cryptd_instance_ctx *ctx = crypto_instance_ctx(inst);
-	struct hashd_instance_ctx *hctx = crypto_instance_ctx(inst);
-	struct aead_instance_ctx *aead_ctx = crypto_instance_ctx(inst);
-
-	switch (inst->alg.cra_flags & CRYPTO_ALG_TYPE_MASK) {
-	case CRYPTO_ALG_TYPE_AHASH:
-		crypto_drop_shash(&hctx->spawn);
-		kfree(ahash_instance(inst));
-		return;
-	case CRYPTO_ALG_TYPE_AEAD:
-		crypto_drop_aead(&aead_ctx->aead_spawn);
-		kfree(aead_instance(inst));
-		return;
-	default:
-		crypto_drop_spawn(&ctx->spawn);
-		kfree(inst);
-	}
-}
-
 static struct crypto_template cryptd_tmpl = {
 	.name = "cryptd",
 	.create = cryptd_create,
-	.free = cryptd_free,
 	.module = THIS_MODULE,
 };
 
-- 
2.24.1

