Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF95812E6F
	for <linux-crypto@vger.kernel.org>; Sat, 27 Jan 2024 07:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706341824; cv=none; b=mJU4dyLEh9b9rX0J8FVERaQRpV0mGWsb5PB/Kniu6UU6p01cDwdb5IxH0528RdRFPz53gWKEC73HEKvfQdqRllPtx1ZhuoAF5SBaNhaxoTkcolM85wzXdjnxJP/AzTUCWzdVLpIuKZ0U2KsIkIuMTnbhLRxe+o7+YhEdDppANqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706341824; c=relaxed/simple;
	bh=ChJuRuerzeHs0UIpjC6hn9f2X1DSVAMhnBEcG6upaMM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Mn4Ppd1rAXwEWnewhKGSqgeXdI/VKKgqBl3wI4NpkXPzTJ/wgo8J1m6fIPaW7Nq/dP6lb1KmbdRw2v8HocLGinKwnfWRgtvZUmpYsI2/xtaSAeFfrOHPqswtEhgIQPHoGIckH6iElP/RonYX/iY7jSyVqCKK6hOJKjXhqDG/l0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ULuGNuhc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULuGNuhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB6DC433F1
	for <linux-crypto@vger.kernel.org>; Sat, 27 Jan 2024 07:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706341823;
	bh=ChJuRuerzeHs0UIpjC6hn9f2X1DSVAMhnBEcG6upaMM=;
	h=From:To:Subject:Date:From;
	b=ULuGNuhcF0PU00PhkI5EYmQy+MYgkAfo9TeeRPqr6R9O8T6qCepXLCLCEt5o8Mpn/
	 IBv2S0oZoD8Fb8mLl+vUZwwOVVRw6HpEp+m6MIbnSi1W4BuC9pE7/EyKjNXX6aArQB
	 YosRHHfh6ttTptUod/VpvDVI9WV/8pdkTTuueMr3v9ky3kxO8jXhXVy18gvujEMagT
	 osFPzBV+05AfRCqCjYNchV4FsWiADGe/urRiMUjerc8rCdlHAx2mKqyK0MSksz5d+W
	 PFFIR9HdFPvoZhd0O2fSnIOWpwz0mj451r/T7wbXf2YBY5rsaiAIKaJBoYLCb7KSV6
	 RasoKkapeD8zA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: ahash - unexport crypto_hash_alg_has_setkey()
Date: Fri, 26 Jan 2024 23:49:27 -0800
Message-ID: <20240127074927.74282-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since crypto_hash_alg_has_setkey() is only called from ahash.c itself,
make it a static function.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ahash.c                 | 21 ++++++++++-----------
 include/crypto/internal/hash.h |  2 --
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 80c3e5354711e..0ac83f7f701df 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -611,20 +611,30 @@ struct crypto_ahash *crypto_alloc_ahash(const char *alg_name, u32 type,
 	return crypto_alloc_tfm(alg_name, &crypto_ahash_type, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_ahash);
 
 int crypto_has_ahash(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_type_has_alg(alg_name, &crypto_ahash_type, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_has_ahash);
 
+static bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg)
+{
+	struct crypto_alg *alg = &halg->base;
+
+	if (alg->cra_type == &crypto_shash_type)
+		return crypto_shash_alg_has_setkey(__crypto_shash_alg(alg));
+
+	return __crypto_ahash_alg(alg)->setkey != ahash_nosetkey;
+}
+
 struct crypto_ahash *crypto_clone_ahash(struct crypto_ahash *hash)
 {
 	struct hash_alg_common *halg = crypto_hash_alg_common(hash);
 	struct crypto_tfm *tfm = crypto_ahash_tfm(hash);
 	struct crypto_ahash *nhash;
 	struct ahash_alg *alg;
 	int err;
 
 	if (!crypto_hash_alg_has_setkey(halg)) {
 		tfm = crypto_tfm_get(tfm);
@@ -753,23 +763,12 @@ int ahash_register_instance(struct crypto_template *tmpl,
 		return -EINVAL;
 
 	err = ahash_prepare_alg(&inst->alg);
 	if (err)
 		return err;
 
 	return crypto_register_instance(tmpl, ahash_crypto_instance(inst));
 }
 EXPORT_SYMBOL_GPL(ahash_register_instance);
 
-bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg)
-{
-	struct crypto_alg *alg = &halg->base;
-
-	if (alg->cra_type == &crypto_shash_type)
-		return crypto_shash_alg_has_setkey(__crypto_shash_alg(alg));
-
-	return __crypto_ahash_alg(alg)->setkey != ahash_nosetkey;
-}
-EXPORT_SYMBOL_GPL(crypto_hash_alg_has_setkey);
-
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous cryptographic hash type");
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 59c707e4dea46..58967593b6b4d 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -80,22 +80,20 @@ static inline bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
 {
 	return alg->setkey != shash_no_setkey;
 }
 
 static inline bool crypto_shash_alg_needs_key(struct shash_alg *alg)
 {
 	return crypto_shash_alg_has_setkey(alg) &&
 		!(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY);
 }
 
-bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg);
-
 int crypto_grab_ahash(struct crypto_ahash_spawn *spawn,
 		      struct crypto_instance *inst,
 		      const char *name, u32 type, u32 mask);
 
 static inline void crypto_drop_ahash(struct crypto_ahash_spawn *spawn)
 {
 	crypto_drop_spawn(&spawn->base);
 }
 
 static inline struct hash_alg_common *crypto_spawn_ahash_alg(

base-commit: 4d314d27130b674a3687135fe94f44a40f107f76
-- 
2.43.0

