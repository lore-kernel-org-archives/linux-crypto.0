From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] crypto: api - Add type init function to crypto_tfm
Date: Tue, 13 Jan 2009 16:59:42 +0100
Message-ID: <1231862386-11128-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:47637 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752687AbZAMP7w (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2009 10:59:52 -0500
In-Reply-To: <1231862386-11128-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a type init function to crypto_tfm, so transforms can override the default
action of calling the algorithm's cra_init() method.

This will be used by the "comp" compatibility layer for the "pcomp" type, which
needs to call the algorithm's setup() method, in addition to the cra_init()
method.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/api.c           |   20 ++++++++++++++++----
 include/linux/crypto.h |    1 +
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 9975a7b..939512a 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -379,8 +379,14 @@ struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 	if (err)
 		goto out_free_tfm;
 
-	if (!tfm->exit && alg->cra_init && (err = alg->cra_init(tfm)))
-		goto cra_init_failed;
+	if (!tfm->exit) {
+		if (tfm->init)
+			err = tfm->init(tfm);
+		else if (alg->cra_init)
+			err = alg->cra_init(tfm);
+		if (err)
+			goto cra_init_failed;
+	}
 
 	goto out;
 
@@ -476,8 +482,14 @@ struct crypto_tfm *crypto_create_tfm(struct crypto_alg *alg,
 	if (err)
 		goto out_free_tfm;
 
-	if (!tfm->exit && alg->cra_init && (err = alg->cra_init(tfm)))
-		goto cra_init_failed;
+	if (!tfm->exit) {
+		if (tfm->init)
+			err = tfm->init(tfm);
+		else if (alg->cra_init)
+			err = alg->cra_init(tfm);
+		if (err)
+			goto cra_init_failed;
+	}
 
 	goto out;
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 61b483a..34db6a6 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -484,6 +484,7 @@ struct crypto_tfm {
 		struct rng_tfm rng;
 	} crt_u;
 
+	int (*init)(struct crypto_tfm *tfm);
 	void (*exit)(struct crypto_tfm *tfm);
 	
 	struct crypto_alg *__crt_alg;
-- 
1.6.0.4

