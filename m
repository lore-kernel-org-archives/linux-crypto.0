From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [RFC 2/3] crypto, keysize fixup crypto API intern calls
Date: Tue, 9 Oct 2007 19:50:31 +0200
Message-ID: <E1IfejP-0005Eh-Qx@Chamillionaire.breakpoint.cc>
References: <20071010164400.GA19471@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.3.4"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54607 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754941AbXJJQsZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Oct 2007 12:48:25 -0400
In-Reply-To: <20071010164400.GA19471@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is a multi-part message in MIME format.
--------------1.5.3.4
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


Fix the core crypto API and add keysize parameter.
---
 crypto/authenc.c   |    7 ++++---
 crypto/cbc.c       |    4 ++--
 crypto/cryptd.c    |    8 ++++----
 crypto/cryptomgr.c |    2 +-
 crypto/hmac.c      |    4 ++--
 crypto/lrw.c       |    4 ++--
 crypto/pcbc.c      |    5 +++--
 crypto/xcbc.c      |    4 ++--
 crypto/xts.c       |    4 ++--
 9 files changed, 22 insertions(+), 20 deletions(-)
--------------1.5.3.4
Content-Type: text/x-patch; name="c4661e72f5d5e1ce489d85ea8cf3a2b1c0a14ff5.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="c4661e72f5d5e1ce489d85ea8cf3a2b1c0a14ff5.diff"

diff --git a/crypto/authenc.c b/crypto/authenc.c
index f1802f1..6d25171 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -278,7 +278,8 @@ static void crypto_authenc_exit_tfm(struct crypto_tfm *tfm)
 	crypto_free_ablkcipher(ctx->enc);
 }
 
-static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
+static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb,
+		u32 keysize)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *auth;
@@ -292,7 +293,7 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 	if (err)
 		return ERR_PTR(err);
 
-	auth = crypto_attr_alg(tb[1], CRYPTO_ALG_TYPE_HASH,
+	auth = crypto_attr_alg(tb[1], 0, CRYPTO_ALG_TYPE_HASH,
 			       CRYPTO_ALG_TYPE_HASH_MASK);
 	if (IS_ERR(auth))
 		return ERR_PTR(PTR_ERR(auth));
@@ -302,7 +303,7 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 	if (err)
 		goto out_put_auth;
 
-	enc = crypto_attr_alg(tb[3], CRYPTO_ALG_TYPE_BLKCIPHER,
+	enc = crypto_attr_alg(tb[3], keysize, CRYPTO_ALG_TYPE_BLKCIPHER,
 			      CRYPTO_ALG_TYPE_MASK);
 	inst = ERR_PTR(PTR_ERR(enc));
 	if (IS_ERR(enc))
diff --git a/crypto/cbc.c b/crypto/cbc.c
index 927b854..a182a09 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -283,7 +283,7 @@ static void crypto_cbc_exit_tfm(struct crypto_tfm *tfm)
 	crypto_free_cipher(ctx->child);
 }
 
-static struct crypto_instance *crypto_cbc_alloc(struct rtattr **tb)
+static struct crypto_instance *crypto_cbc_alloc(struct rtattr **tb, u32 ksize)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
@@ -293,7 +293,7 @@ static struct crypto_instance *crypto_cbc_alloc(struct rtattr **tb)
 	if (err)
 		return ERR_PTR(err);
 
-	alg = crypto_get_attr_alg(tb, 0, CRYPTO_ALG_TYPE_CIPHER,
+	alg = crypto_get_attr_alg(tb, ksize, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index a1f3e2e..03221d9 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -230,12 +230,12 @@ out_free_inst:
 }
 
 static struct crypto_instance *cryptd_alloc_blkcipher(
-	struct rtattr **tb, struct cryptd_state *state)
+	struct rtattr **tb, u32 keysize, struct cryptd_state *state)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_BLKCIPHER,
+	alg = crypto_get_attr_alg(tb, keysize, CRYPTO_ALG_TYPE_BLKCIPHER,
 				  CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
@@ -268,7 +268,7 @@ out_put_alg:
 
 static struct cryptd_state state;
 
-static struct crypto_instance *cryptd_alloc(struct rtattr **tb)
+static struct crypto_instance *cryptd_alloc(struct rtattr **tb, u32 keysize)
 {
 	struct crypto_attr_type *algt;
 
@@ -278,7 +278,7 @@ static struct crypto_instance *cryptd_alloc(struct rtattr **tb)
 
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_BLKCIPHER:
-		return cryptd_alloc_blkcipher(tb, &state);
+		return cryptd_alloc_blkcipher(tb, keysize, &state);
 	}
 
 	return ERR_PTR(-EINVAL);
diff --git a/crypto/cryptomgr.c b/crypto/cryptomgr.c
index af358f6..8af7d85 100644
--- a/crypto/cryptomgr.c
+++ b/crypto/cryptomgr.c
@@ -59,7 +59,7 @@ static int cryptomgr_probe(void *data)
 		goto err;
 
 	do {
-		inst = tmpl->alloc(param->tb, param->data.keysize);
+		inst = tmpl->alloc(param->tb, param->type.data.keysize);
 		if (IS_ERR(inst))
 			err = PTR_ERR(inst);
 		else if ((err = crypto_register_instance(tmpl, inst)))
diff --git a/crypto/hmac.c b/crypto/hmac.c
index 2a6e82a..d7e0e33 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -197,7 +197,7 @@ static void hmac_free(struct crypto_instance *inst)
 	kfree(inst);
 }
 
-static struct crypto_instance *hmac_alloc(struct rtattr **tb)
+static struct crypto_instance *hmac_alloc(struct rtattr **tb, u32 keysize)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
@@ -207,7 +207,7 @@ static struct crypto_instance *hmac_alloc(struct rtattr **tb)
 	if (err)
 		return ERR_PTR(err);
 
-	alg = crypto_get_attr_alg(tb, 0, CRYPTO_ALG_TYPE_HASH,
+	alg = crypto_get_attr_alg(tb, keysize, CRYPTO_ALG_TYPE_HASH,
 				  CRYPTO_ALG_TYPE_HASH_MASK);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
diff --git a/crypto/lrw.c b/crypto/lrw.c
index 621095d..c0f73d0 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -228,7 +228,7 @@ static void exit_tfm(struct crypto_tfm *tfm)
 	crypto_free_cipher(ctx->child);
 }
 
-static struct crypto_instance *alloc(struct rtattr **tb)
+static struct crypto_instance *alloc(struct rtattr **tb, u32 keysize)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
@@ -238,7 +238,7 @@ static struct crypto_instance *alloc(struct rtattr **tb)
 	if (err)
 		return ERR_PTR(err);
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
+	alg = crypto_get_attr_alg(tb, keysize, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index c3ed8a1..1dea48c 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -279,7 +279,8 @@ static void crypto_pcbc_exit_tfm(struct crypto_tfm *tfm)
 	crypto_free_cipher(ctx->child);
 }
 
-static struct crypto_instance *crypto_pcbc_alloc(struct rtattr **tb)
+static struct crypto_instance *crypto_pcbc_alloc(struct rtattr **tb,
+		u32 keysize)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
@@ -289,7 +290,7 @@ static struct crypto_instance *crypto_pcbc_alloc(struct rtattr **tb)
 	if (err)
 		return ERR_PTR(err);
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
+	alg = crypto_get_attr_alg(tb, keysize, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 9f502b8..c146f0b 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -288,7 +288,7 @@ static void xcbc_exit_tfm(struct crypto_tfm *tfm)
 	crypto_free_cipher(ctx->child);
 }
 
-static struct crypto_instance *xcbc_alloc(struct rtattr **tb)
+static struct crypto_instance *xcbc_alloc(struct rtattr **tb, u32 keysize)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
@@ -298,7 +298,7 @@ static struct crypto_instance *xcbc_alloc(struct rtattr **tb)
 	if (err)
 		return ERR_PTR(err);
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
+	alg = crypto_get_attr_alg(tb, keysize, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
diff --git a/crypto/xts.c b/crypto/xts.c
index 8eb08bf..e9cc9fa 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -212,7 +212,7 @@ static void exit_tfm(struct crypto_tfm *tfm)
 	crypto_free_cipher(ctx->tweak);
 }
 
-static struct crypto_instance *alloc(struct rtattr **tb)
+static struct crypto_instance *alloc(struct rtattr **tb, u32 keysize)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
@@ -222,7 +222,7 @@ static struct crypto_instance *alloc(struct rtattr **tb)
 	if (err)
 		return ERR_PTR(err);
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
+	alg = crypto_get_attr_alg(tb, keysize, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));

--------------1.5.3.4--
