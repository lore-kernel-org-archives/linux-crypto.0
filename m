From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH stable 3.10.y 07/18] crypto: skcipher - Add crypto_skcipher_has_setkey
Date: Thu, 27 Oct 2016 17:29:40 +0300
Message-ID: <1477578591-28924-8-git-send-email-aryabinin@virtuozzo.com>
References: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Willy Tarreau <w@1wt.eu>, <stable@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit a1383cd86a062fc798899ab20f0ec2116cce39cb upstream.

This patch adds a way for skcipher users to determine whether a key
is required by a transform.

Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 crypto/ablkcipher.c    | 2 ++
 crypto/blkcipher.c     | 1 +
 include/linux/crypto.h | 8 ++++++++
 3 files changed, 11 insertions(+)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index ebcec74..2b6dd74 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -379,6 +379,7 @@ static int crypto_init_ablkcipher_ops(struct crypto_tfm *tfm, u32 type,
 	}
 	crt->base = __crypto_ablkcipher_cast(tfm);
 	crt->ivsize = alg->ivsize;
+	crt->has_setkey = alg->max_keysize;
 
 	return 0;
 }
@@ -460,6 +461,7 @@ static int crypto_init_givcipher_ops(struct crypto_tfm *tfm, u32 type,
 	crt->givdecrypt = alg->givdecrypt ?: no_givdecrypt;
 	crt->base = __crypto_ablkcipher_cast(tfm);
 	crt->ivsize = alg->ivsize;
+	crt->has_setkey = alg->max_keysize;
 
 	return 0;
 }
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index a79e7e9..37af08e 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -458,6 +458,7 @@ static int crypto_init_blkcipher_ops_async(struct crypto_tfm *tfm)
 	}
 	crt->base = __crypto_ablkcipher_cast(tfm);
 	crt->ivsize = alg->ivsize;
+	crt->has_setkey = alg->max_keysize;
 
 	return 0;
 }
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 2b00d92..61dd0b1 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -354,6 +354,7 @@ struct ablkcipher_tfm {
 
 	unsigned int ivsize;
 	unsigned int reqsize;
+	bool has_setkey;
 };
 
 struct aead_tfm {
@@ -664,6 +665,13 @@ static inline int crypto_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 	return crt->setkey(crt->base, key, keylen);
 }
 
+static inline bool crypto_ablkcipher_has_setkey(struct crypto_ablkcipher *tfm)
+{
+	struct ablkcipher_tfm *crt = crypto_ablkcipher_crt(tfm);
+
+	return crt->has_setkey;
+}
+
 static inline struct crypto_ablkcipher *crypto_ablkcipher_reqtfm(
 	struct ablkcipher_request *req)
 {
-- 
2.7.3
