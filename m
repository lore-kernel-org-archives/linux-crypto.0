Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF49E776F4
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 03:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjJCDok (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 23:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJCDok (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 23:44:40 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B25B8
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 20:44:36 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qnWKl-002wQR-QN; Tue, 03 Oct 2023 11:44:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Oct 2023 11:44:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 01/16] crypto: arc4 - Convert from skcipher to lskcipher
Date:   Tue,  3 Oct 2023 11:43:18 +0800
Message-Id: <20231003034333.1441826-2-herbert@gondor.apana.org.au>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231003034333.1441826-1-herbert@gondor.apana.org.au>
References: <20231003034333.1441826-1-herbert@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace skcipher implementation with lskcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/arc4.c    | 60 +++++++++++++++++++-----------------------------
 crypto/testmgr.c |  2 +-
 2 files changed, 24 insertions(+), 38 deletions(-)

diff --git a/crypto/arc4.c b/crypto/arc4.c
index 3254dcc34368..eb3590dc9282 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -7,7 +7,6 @@
  * Jon Oberheide <jon@oberheide.org>
  */
 
-#include <crypto/algapi.h>
 #include <crypto/arc4.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/init.h>
@@ -15,33 +14,24 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 
-static int crypto_arc4_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
+static int crypto_arc4_setkey(struct crypto_lskcipher *tfm, const u8 *in_key,
 			      unsigned int key_len)
 {
-	struct arc4_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct arc4_ctx *ctx = crypto_lskcipher_ctx(tfm);
 
 	return arc4_setkey(ctx, in_key, key_len);
 }
 
-static int crypto_arc4_crypt(struct skcipher_request *req)
+static int crypto_arc4_crypt(struct crypto_lskcipher *tfm, const u8 *src,
+			     u8 *dst, unsigned nbytes, u8 *iv, bool final)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct arc4_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	int err;
+	struct arc4_ctx *ctx = crypto_lskcipher_ctx(tfm);
 
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while (walk.nbytes > 0) {
-		arc4_crypt(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			   walk.nbytes);
-		err = skcipher_walk_done(&walk, 0);
-	}
-
-	return err;
+	arc4_crypt(ctx, dst, src, nbytes);
+	return 0;
 }
 
-static int crypto_arc4_init(struct crypto_skcipher *tfm)
+static int crypto_arc4_init(struct crypto_lskcipher *tfm)
 {
 	pr_warn_ratelimited("\"%s\" (%ld) uses obsolete ecb(arc4) skcipher\n",
 			    current->comm, (unsigned long)current->pid);
@@ -49,33 +39,29 @@ static int crypto_arc4_init(struct crypto_skcipher *tfm)
 	return 0;
 }
 
-static struct skcipher_alg arc4_alg = {
-	/*
-	 * For legacy reasons, this is named "ecb(arc4)", not "arc4".
-	 * Nevertheless it's actually a stream cipher, not a block cipher.
-	 */
-	.base.cra_name		=	"ecb(arc4)",
-	.base.cra_driver_name	=	"ecb(arc4)-generic",
-	.base.cra_priority	=	100,
-	.base.cra_blocksize	=	ARC4_BLOCK_SIZE,
-	.base.cra_ctxsize	=	sizeof(struct arc4_ctx),
-	.base.cra_module	=	THIS_MODULE,
-	.min_keysize		=	ARC4_MIN_KEY_SIZE,
-	.max_keysize		=	ARC4_MAX_KEY_SIZE,
-	.setkey			=	crypto_arc4_setkey,
-	.encrypt		=	crypto_arc4_crypt,
-	.decrypt		=	crypto_arc4_crypt,
-	.init			=	crypto_arc4_init,
+static struct lskcipher_alg arc4_alg = {
+	.co.base.cra_name		=	"arc4",
+	.co.base.cra_driver_name	=	"arc4-generic",
+	.co.base.cra_priority		=	100,
+	.co.base.cra_blocksize		=	ARC4_BLOCK_SIZE,
+	.co.base.cra_ctxsize		=	sizeof(struct arc4_ctx),
+	.co.base.cra_module		=	THIS_MODULE,
+	.co.min_keysize			=	ARC4_MIN_KEY_SIZE,
+	.co.max_keysize			=	ARC4_MAX_KEY_SIZE,
+	.setkey				=	crypto_arc4_setkey,
+	.encrypt			=	crypto_arc4_crypt,
+	.decrypt			=	crypto_arc4_crypt,
+	.init				=	crypto_arc4_init,
 };
 
 static int __init arc4_init(void)
 {
-	return crypto_register_skcipher(&arc4_alg);
+	return crypto_register_lskcipher(&arc4_alg);
 }
 
 static void __exit arc4_exit(void)
 {
-	crypto_unregister_skcipher(&arc4_alg);
+	crypto_unregister_lskcipher(&arc4_alg);
 }
 
 subsys_initcall(arc4_init);
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index aed4a6bf47ad..5d5aee597eeb 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4963,7 +4963,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(arc4)",
-		.generic_driver = "ecb(arc4)-generic",
+		.generic_driver = "arc4-generic",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(arc4_tv_template)
-- 
2.39.2

