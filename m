From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 1/9] crypto: hash - introduce crypto_hash_alg_has_setkey()
Date: Wed,  3 Jan 2018 11:16:22 -0800
Message-ID: <20180103191630.79917-2-ebiggers3@gmail.com>
References: <20180103191630.79917-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:38830 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeACTS0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jan 2018 14:18:26 -0500
Received: by mail-io0-f194.google.com with SMTP id 87so3150505ior.5
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jan 2018 11:18:26 -0800 (PST)
In-Reply-To: <20180103191630.79917-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Templates that use an shash spawn can use crypto_shash_alg_has_setkey()
to determine whether the underlying algorithm requires a key or not.
But there was no corresponding function for ahash spawns.  Add it.

Note that the new function actually has to support both shash and ahash
algorithms, since the ahash API can be used with either.

Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ahash.c                 | 11 +++++++++++
 include/crypto/internal/hash.h |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 3a35d67de7d9..d2c8895bb2fe 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -649,5 +649,16 @@ struct hash_alg_common *ahash_attr_alg(struct rtattr *rta, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(ahash_attr_alg);
 
+bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg)
+{
+	struct crypto_alg *alg = &halg->base;
+
+	if (alg->cra_type != &crypto_ahash_type)
+		return crypto_shash_alg_has_setkey(__crypto_shash_alg(alg));
+
+	return __crypto_ahash_alg(alg)->setkey != NULL;
+}
+EXPORT_SYMBOL_GPL(crypto_hash_alg_has_setkey);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous cryptographic hash type");
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index c2bae8da642c..27040a46d50a 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -90,6 +90,8 @@ static inline bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
 	return alg->setkey != shash_no_setkey;
 }
 
+bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg);
+
 int crypto_init_ahash_spawn(struct crypto_ahash_spawn *spawn,
 			    struct hash_alg_common *alg,
 			    struct crypto_instance *inst);
-- 
2.15.1.620.gb9897f4670-goog
