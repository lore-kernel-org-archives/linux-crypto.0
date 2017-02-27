From: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH 1/2] crypto: cbc - Propagate NEED_FALLBACK bit
Date: Sun, 26 Feb 2017 22:03:18 -0300
Message-ID: <1488157399-3587-2-git-send-email-marcelo.cerri@canonical.com>
References: <1488157399-3587-1-git-send-email-marcelo.cerri@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:36240 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751284AbdB0BDr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Feb 2017 20:03:47 -0500
Received: by mail-qk0-f180.google.com with SMTP id n186so445834qkb.3
        for <linux-crypto@vger.kernel.org>; Sun, 26 Feb 2017 17:03:46 -0800 (PST)
In-Reply-To: <1488157399-3587-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When requesting a fallback algorithm, we should propagate the
NEED_FALLBACK bit when search for the underlying algorithm.

This will prevents drivers from allocating unnecessary fallbacks that
are never called. For instance, currently the vmx-crypto driver will use
the following chain of calls when calling the fallback implementation:

p8_aes_cbc -> cbc(p8_aes) -> aes-generic

However p8_aes will always delegate its calls to aes-generic. With this
patch, p8_aes_cbc will be able to use cbc(aes-generic) directly as its
fallback. The same applies to aes_s390.

Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
---
 crypto/cbc.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/crypto/cbc.c b/crypto/cbc.c
index bc160a3..7147842 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -108,24 +108,32 @@ static void crypto_cbc_free(struct skcipher_instance *inst)
 static int crypto_cbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct skcipher_instance *inst;
+	struct crypto_attr_type *algt;
 	struct crypto_spawn *spawn;
 	struct crypto_alg *alg;
+	u32 mask;
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER);
 	if (err)
 		return err;
 
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return PTR_ERR(algt);
+
+	mask = CRYPTO_ALG_TYPE_MASK |
+		crypto_requires_off(algt->type, algt->mask,
+				    CRYPTO_ALG_NEED_FALLBACK);
+
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER, mask);
+	if (IS_ERR(alg))
+		return PTR_ERR(alg);
+
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_MASK);
-	err = PTR_ERR(alg);
-	if (IS_ERR(alg))
-		goto err_free_inst;
-
 	spawn = skcipher_instance_ctx(inst);
 	err = crypto_init_spawn(spawn, alg, skcipher_crypto_instance(inst),
 				CRYPTO_ALG_TYPE_MASK);
-- 
2.7.4
