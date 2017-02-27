From: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH v2 2/2] crypto: ctr - Propagate NEED_FALLBACK bit
Date: Mon, 27 Feb 2017 09:38:26 -0300
Message-ID: <1488199106-16061-3-git-send-email-marcelo.cerri@canonical.com>
References: <1488199106-16061-1-git-send-email-marcelo.cerri@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:35438 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751395AbdB0Mi6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Feb 2017 07:38:58 -0500
Received: by mail-qk0-f182.google.com with SMTP id u188so94257971qkc.2
        for <linux-crypto@vger.kernel.org>; Mon, 27 Feb 2017 04:38:57 -0800 (PST)
In-Reply-To: <1488199106-16061-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When requesting a fallback algorithm, we should propagate the
NEED_FALLBACK bit when search for the underlying algorithm.

This will prevents drivers from allocating unnecessary fallbacks that
are never called. For instance, currently the vmx-crypto driver will use
the following chain of calls when calling the fallback implementation:

p8_aes_ctr -> ctr(p8_aes) -> aes-generic

However p8_aes will always delegate its calls to aes-generic. With this
patch, p8_aes_ctr will be able to use ctr(aes-generic) directly as its
fallback. The same applies to aes_s390.

Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
---
 crypto/ctr.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index a4f4a89..477d922 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -181,15 +181,24 @@ static void crypto_ctr_exit_tfm(struct crypto_tfm *tfm)
 static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
 {
 	struct crypto_instance *inst;
+	struct crypto_attr_type *algt;
 	struct crypto_alg *alg;
+	u32 mask;
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
 	if (err)
 		return ERR_PTR(err);
 
-	alg = crypto_attr_alg(tb[1], CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_MASK);
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return ERR_CAST(algt);
+
+	mask = CRYPTO_ALG_TYPE_MASK |
+		crypto_requires_off(algt->type, algt->mask,
+				    CRYPTO_ALG_NEED_FALLBACK);
+
+	alg = crypto_attr_alg(tb[1], CRYPTO_ALG_TYPE_CIPHER, mask);
 	if (IS_ERR(alg))
 		return ERR_CAST(alg);
 
@@ -350,6 +359,8 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	struct skcipher_alg *alg;
 	struct crypto_skcipher_spawn *spawn;
 	const char *cipher_name;
+	u32 mask;
+
 	int err;
 
 	algt = crypto_get_attr_type(tb);
@@ -367,12 +378,14 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	if (!inst)
 		return -ENOMEM;
 
+	mask = crypto_requires_sync(algt->type, algt->mask) |
+		crypto_requires_off(algt->type, algt->mask,
+				    CRYPTO_ALG_NEED_FALLBACK);
+
 	spawn = skcipher_instance_ctx(inst);
 
 	crypto_set_skcipher_spawn(spawn, skcipher_crypto_instance(inst));
-	err = crypto_grab_skcipher(spawn, cipher_name, 0,
-				   crypto_requires_sync(algt->type,
-							algt->mask));
+	err = crypto_grab_skcipher(spawn, cipher_name, 0, mask);
 	if (err)
 		goto err_free_inst;
 
-- 
2.7.4
