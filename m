From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/10] crypto: cryptd - Add setkey/setauthsize functions for AEAD
Date: Thu, 28 May 2015 22:08:01 +0800
Message-ID: <E1YxyTZ-0002Ks-Ol@gondolin.me.apana.org.au>
References: <20150528140311.GA8423@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57725 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbbE1OIF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 10:08:05 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds setkey and setauthsize for cryptd AEAD.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 4264c8d..74c4dcb 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -664,6 +664,24 @@ out_put_alg:
 	return err;
 }
 
+static int cryptd_aead_setkey(struct crypto_aead *parent,
+			      const u8 *key, unsigned int keylen)
+{
+	struct cryptd_aead_ctx *ctx = crypto_aead_ctx(parent);
+	struct crypto_aead *child = ctx->child;
+
+	return crypto_aead_setkey(child, key, keylen);
+}
+
+static int cryptd_aead_setauthsize(struct crypto_aead *parent,
+				   unsigned int authsize)
+{
+	struct cryptd_aead_ctx *ctx = crypto_aead_ctx(parent);
+	struct crypto_aead *child = ctx->child;
+
+	return crypto_aead_setauthsize(child, authsize);
+}
+
 static void cryptd_aead_crypt(struct aead_request *req,
 			struct crypto_aead *child,
 			int err,
@@ -793,8 +811,8 @@ static int cryptd_create_aead(struct crypto_template *tmpl,
 	inst->alg.cra_ctxsize = sizeof(struct cryptd_aead_ctx);
 	inst->alg.cra_init = cryptd_aead_init_tfm;
 	inst->alg.cra_exit = cryptd_aead_exit_tfm;
-	inst->alg.cra_aead.setkey      = alg->cra_aead.setkey;
-	inst->alg.cra_aead.setauthsize = alg->cra_aead.setauthsize;
+	inst->alg.cra_aead.setkey      = cryptd_aead_setkey;
+	inst->alg.cra_aead.setauthsize = cryptd_aead_setauthsize;
 	inst->alg.cra_aead.geniv       = alg->cra_aead.geniv;
 	inst->alg.cra_aead.ivsize      = alg->cra_aead.ivsize;
 	inst->alg.cra_aead.maxauthsize = alg->cra_aead.maxauthsize;
