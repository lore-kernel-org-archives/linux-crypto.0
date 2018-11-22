Return-Path: <SRS0=unN5=OB=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:49933 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390330AbeKVUjx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Nov 2018 15:39:53 -0500
From: Pan Bian <bianpan2016@163.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [PATCH] crypto: do not free algorithm before using
Date: Thu, 22 Nov 2018 18:00:16 +0800
Message-Id: <1542880816-63838-1-git-send-email-bianpan2016@163.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In multiple functions, the algorithm fields are read after its reference
is dropped through crypto_mod_put. In this case, the algorithm memory
may be freed, resulting in use-after-free bugs. This patch delays the
put operation until the algorithm is never used.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 crypto/cbc.c  | 6 ++++--
 crypto/cfb.c  | 6 ++++--
 crypto/pcbc.c | 6 ++++--
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/crypto/cbc.c b/crypto/cbc.c
index b761b1f..dd5f332 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -140,9 +140,8 @@ static int crypto_cbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	spawn = skcipher_instance_ctx(inst);
 	err = crypto_init_spawn(spawn, alg, skcipher_crypto_instance(inst),
 				CRYPTO_ALG_TYPE_MASK);
-	crypto_mod_put(alg);
 	if (err)
-		goto err_free_inst;
+		goto err_put_alg;
 
 	err = crypto_inst_setname(skcipher_crypto_instance(inst), "cbc", alg);
 	if (err)
@@ -174,12 +173,15 @@ static int crypto_cbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	err = skcipher_register_instance(tmpl, inst);
 	if (err)
 		goto err_drop_spawn;
+	crypto_mod_put(alg);
 
 out:
 	return err;
 
 err_drop_spawn:
 	crypto_drop_spawn(spawn);
+err_put_alg:
+	crypto_mod_put(alg);
 err_free_inst:
 	kfree(inst);
 	goto out;
diff --git a/crypto/cfb.c b/crypto/cfb.c
index a0d68c0..20987d0 100644
--- a/crypto/cfb.c
+++ b/crypto/cfb.c
@@ -286,9 +286,8 @@ static int crypto_cfb_create(struct crypto_template *tmpl, struct rtattr **tb)
 	spawn = skcipher_instance_ctx(inst);
 	err = crypto_init_spawn(spawn, alg, skcipher_crypto_instance(inst),
 				CRYPTO_ALG_TYPE_MASK);
-	crypto_mod_put(alg);
 	if (err)
-		goto err_free_inst;
+		goto err_put_alg;
 
 	err = crypto_inst_setname(skcipher_crypto_instance(inst), "cfb", alg);
 	if (err)
@@ -317,12 +316,15 @@ static int crypto_cfb_create(struct crypto_template *tmpl, struct rtattr **tb)
 	err = skcipher_register_instance(tmpl, inst);
 	if (err)
 		goto err_drop_spawn;
+	crypto_mod_put(alg);
 
 out:
 	return err;
 
 err_drop_spawn:
 	crypto_drop_spawn(spawn);
+err_put_alg:
+	crypto_mod_put(alg);
 err_free_inst:
 	kfree(inst);
 	goto out;
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index ef802f6..8aa1014 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -244,9 +244,8 @@ static int crypto_pcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	spawn = skcipher_instance_ctx(inst);
 	err = crypto_init_spawn(spawn, alg, skcipher_crypto_instance(inst),
 				CRYPTO_ALG_TYPE_MASK);
-	crypto_mod_put(alg);
 	if (err)
-		goto err_free_inst;
+		goto err_put_alg;
 
 	err = crypto_inst_setname(skcipher_crypto_instance(inst), "pcbc", alg);
 	if (err)
@@ -275,12 +274,15 @@ static int crypto_pcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	err = skcipher_register_instance(tmpl, inst);
 	if (err)
 		goto err_drop_spawn;
+	crypto_mod_put(alg);
 
 out:
 	return err;
 
 err_drop_spawn:
 	crypto_drop_spawn(spawn);
+err_put_alg:
+	crypto_mod_put(alg);
 err_free_inst:
 	kfree(inst);
 	goto out;
-- 
2.7.4
