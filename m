From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/8] [CRYPTO] ccm: Add setauthsize
Date: Mon, 17 Dec 2007 18:31:18 +0800
Message-ID: <E1J4DFm-00039H-00@gondolin.me.apana.org.au>
References: <20071217103037.GA11988@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4842 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760300AbXLQKb1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Dec 2007 05:31:27 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J4DFn-0008VT-SU
	for <linux-crypto@vger.kernel.org>; Mon, 17 Dec 2007 21:31:20 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] ccm: Add setauthsize

We need to provide setauthsize functions to check the validity of the
ICV length requested and more importantly to pass along the ICV length
from rfc4309 to the underlying ccm object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ccm.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 82bcc14..61ab0b9 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -101,6 +101,24 @@ out:
 	return err;
 }
 
+static int crypto_ccm_setauthsize(struct crypto_aead *tfm,
+				  unsigned int authsize)
+{
+	switch (authsize) {
+	case 4:
+	case 6:
+	case 8:
+	case 12:
+	case 14:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int format_input(u8 *info, struct aead_request *req,
 			unsigned int cryptlen)
 {
@@ -531,6 +549,7 @@ static struct crypto_instance *crypto_ccm_alloc_common(struct rtattr **tb,
 	inst->alg.cra_init = crypto_ccm_init_tfm;
 	inst->alg.cra_exit = crypto_ccm_exit_tfm;
 	inst->alg.cra_aead.setkey = crypto_ccm_setkey;
+	inst->alg.cra_aead.setauthsize = crypto_ccm_setauthsize;
 	inst->alg.cra_aead.encrypt = crypto_ccm_encrypt;
 	inst->alg.cra_aead.decrypt = crypto_ccm_decrypt;
 
@@ -642,6 +661,23 @@ static int crypto_rfc4309_setkey(struct crypto_aead *parent, const u8 *key,
 	return err;
 }
 
+static int crypto_rfc4309_setauthsize(struct crypto_aead *parent,
+				      unsigned int authsize)
+{
+	struct crypto_rfc4309_ctx *ctx = crypto_aead_ctx(parent);
+
+	switch (authsize) {
+	case 8:
+	case 12:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return crypto_aead_setauthsize(ctx->child, authsize);
+}
+
 static struct aead_request *crypto_rfc4309_crypt(struct aead_request *req)
 {
 	struct aead_request *subreq = aead_request_ctx(req);
@@ -780,6 +816,7 @@ static struct crypto_instance *crypto_rfc4309_alloc(struct rtattr **tb)
 	inst->alg.cra_exit = crypto_rfc4309_exit_tfm;
 
 	inst->alg.cra_aead.setkey = crypto_rfc4309_setkey;
+	inst->alg.cra_aead.setauthsize = crypto_rfc4309_setauthsize;
 	inst->alg.cra_aead.encrypt = crypto_rfc4309_encrypt;
 	inst->alg.cra_aead.decrypt = crypto_rfc4309_decrypt;
 
