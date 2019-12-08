Return-Path: <SRS0=w3rH=Z6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B792C2D0BE
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Dec 2019 05:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAFDE20700
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Dec 2019 05:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfLHFmy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Dec 2019 00:42:54 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37900 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbfLHFmy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Dec 2019 00:42:54 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1idpLI-0001w2-Sb; Sun, 08 Dec 2019 13:42:52 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1idpLI-0008Rc-L5; Sun, 08 Dec 2019 13:42:52 +0800
Subject: [v2 PATCH 2/3] crypto: padlock-sha - Use init_tfm/exit_tfm interface
References: <20191208054229.h4smagmiuqhxxc6w@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1idpLI-0008Rc-L5@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sun, 08 Dec 2019 13:42:52 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch switches padlock-sha over to the new init_tfm/exit_tfm
interface as opposed to cra_init/cra_exit.  This way the shash API
can make sure that descsize does not exceed the maximum.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/padlock-sha.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index ddf1b549fdca..68a06487a665 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -190,13 +190,11 @@ static int padlock_sha256_final(struct shash_desc *desc, u8 *out)
 	return padlock_sha256_finup(desc, buf, 0, out);
 }
 
-static int padlock_cra_init(struct crypto_tfm *tfm)
+static int padlock_cra_init(struct crypto_shash *hash)
 {
-	struct crypto_shash *hash = __crypto_shash_cast(tfm);
-	const char *fallback_driver_name = crypto_tfm_alg_name(tfm);
-	struct padlock_sha_ctx *ctx = crypto_tfm_ctx(tfm);
+	const char *fallback_driver_name = crypto_shash_alg_name(hash);
+	struct padlock_sha_ctx *ctx = crypto_shash_ctx(hash);
 	struct crypto_shash *fallback_tfm;
-	int err = -ENOMEM;
 
 	/* Allocate a fallback and abort if it failed. */
 	fallback_tfm = crypto_alloc_shash(fallback_driver_name, 0,
@@ -204,21 +202,17 @@ static int padlock_cra_init(struct crypto_tfm *tfm)
 	if (IS_ERR(fallback_tfm)) {
 		printk(KERN_WARNING PFX "Fallback driver '%s' could not be loaded!\n",
 		       fallback_driver_name);
-		err = PTR_ERR(fallback_tfm);
-		goto out;
+		return PTR_ERR(fallback_tfm);
 	}
 
 	ctx->fallback = fallback_tfm;
 	hash->descsize += crypto_shash_descsize(fallback_tfm);
 	return 0;
-
-out:
-	return err;
 }
 
-static void padlock_cra_exit(struct crypto_tfm *tfm)
+static void padlock_cra_exit(struct crypto_shash *hash)
 {
-	struct padlock_sha_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct padlock_sha_ctx *ctx = crypto_shash_ctx(hash);
 
 	crypto_free_shash(ctx->fallback);
 }
@@ -231,6 +225,8 @@ static struct shash_alg sha1_alg = {
 	.final  	=	padlock_sha1_final,
 	.export		=	padlock_sha_export,
 	.import		=	padlock_sha_import,
+	.init_tfm	=	padlock_cra_init,
+	.exit_tfm	=	padlock_cra_exit,
 	.descsize	=	sizeof(struct padlock_sha_desc),
 	.statesize	=	sizeof(struct sha1_state),
 	.base		=	{
@@ -241,8 +237,6 @@ static struct shash_alg sha1_alg = {
 		.cra_blocksize		=	SHA1_BLOCK_SIZE,
 		.cra_ctxsize		=	sizeof(struct padlock_sha_ctx),
 		.cra_module		=	THIS_MODULE,
-		.cra_init		=	padlock_cra_init,
-		.cra_exit		=	padlock_cra_exit,
 	}
 };
 
@@ -254,6 +248,8 @@ static struct shash_alg sha256_alg = {
 	.final  	=	padlock_sha256_final,
 	.export		=	padlock_sha_export,
 	.import		=	padlock_sha_import,
+	.init_tfm	=	padlock_cra_init,
+	.exit_tfm	=	padlock_cra_exit,
 	.descsize	=	sizeof(struct padlock_sha_desc),
 	.statesize	=	sizeof(struct sha256_state),
 	.base		=	{
@@ -264,8 +260,6 @@ static struct shash_alg sha256_alg = {
 		.cra_blocksize		=	SHA256_BLOCK_SIZE,
 		.cra_ctxsize		=	sizeof(struct padlock_sha_ctx),
 		.cra_module		=	THIS_MODULE,
-		.cra_init		=	padlock_cra_init,
-		.cra_exit		=	padlock_cra_exit,
 	}
 };
 
