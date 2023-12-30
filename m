Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B807224E7
	for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 09:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707815819; cv=none; b=Y3Mq5phlauebwlu4rnxYlcDtsKATeL/UPEq7tGLSkwqo8ObwAsMBzvqg1pdg7JtRp/QcJsri5fofTmfVlQxh/WKqQFifTEV/h1hlNwUWhdEhGrDluCzgnxgNODvwXIhaexO4yVz6RcacE2m/CGKMy/fb7EAXqABR9h95JD4tZQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707815819; c=relaxed/simple;
	bh=TGZVNy4JzPdWyI91BJAjew8ujYQwq54sQggREcfWfw4=;
	h=Message-Id:In-Reply-To:References:From:Date:Subject:To; b=lfsPnBxyTsdr7PwxEW5kGase7gYpLJ6TqDX/pEsUv+RJLL+mVY6LEJ44+FO3qHJidxXgbpojG31QMYkVzvee58wBe+C7x1xaHk7UABPcSE2Cm2aGhgYMKiLrysxAPmPYZtj2hIHYMI3BwdOSXZFkvlrEwdbsK6wh4lnhaKcGAZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rZouL-00D1uM-8l; Tue, 13 Feb 2024 17:16:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Feb 2024 17:17:07 +0800
Message-Id: <c6382ec09c1e724e54b9842aaf82e609071b0503.1707815065.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1707815065.git.herbert@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sat, 30 Dec 2023 15:16:51 +0800
Subject: [PATCH 14/15] crypto: lskcipher - Export incremental interface
 internally
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Export the incremental interface internally so that composite
algorithms such as adiantum can use it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/lskcipher.c                 | 45 +++++++++++++++++++++---------
 include/crypto/internal/skcipher.h | 42 ++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+), 13 deletions(-)

diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index 00ea963a2d2d..e8b97e4fd579 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -87,8 +87,9 @@ EXPORT_SYMBOL_GPL(crypto_lskcipher_setkey);
 
 static int crypto_lskcipher_crypt_unaligned(
 	struct crypto_lskcipher *tfm, const u8 *src, u8 *dst, unsigned len,
-	u8 *iv, int (*crypt)(struct crypto_lskcipher *tfm, const u8 *src,
-			     u8 *dst, unsigned len, u8 *iv, u32 flags))
+	u8 *iv, u32 flags,
+	int (*crypt)(struct crypto_lskcipher *tfm, const u8 *src,
+		     u8 *dst, unsigned len, u8 *iv, u32 flags))
 {
 	unsigned statesize = crypto_lskcipher_statesize(tfm);
 	unsigned ivsize = crypto_lskcipher_ivsize(tfm);
@@ -120,7 +121,7 @@ static int crypto_lskcipher_crypt_unaligned(
 			chunk &= ~(cs - 1);
 
 		memcpy(p, src, chunk);
-		err = crypt(tfm, p, p, chunk, tiv, CRYPTO_LSKCIPHER_FLAG_FINAL);
+		err = crypt(tfm, p, p, chunk, tiv, flags);
 		if (err)
 			goto out;
 
@@ -140,7 +141,7 @@ static int crypto_lskcipher_crypt_unaligned(
 }
 
 static int crypto_lskcipher_crypt(struct crypto_lskcipher *tfm, const u8 *src,
-				  u8 *dst, unsigned len, u8 *iv,
+				  u8 *dst, unsigned len, u8 *iv, u32 flags,
 				  int (*crypt)(struct crypto_lskcipher *tfm,
 					       const u8 *src, u8 *dst,
 					       unsigned len, u8 *iv,
@@ -153,18 +154,18 @@ static int crypto_lskcipher_crypt(struct crypto_lskcipher *tfm, const u8 *src,
 	if (((unsigned long)src | (unsigned long)dst | (unsigned long)iv) &
 	    alignmask) {
 		ret = crypto_lskcipher_crypt_unaligned(tfm, src, dst, len, iv,
-						       crypt);
+						       flags, crypt);
 		goto out;
 	}
 
-	ret = crypt(tfm, src, dst, len, iv, CRYPTO_LSKCIPHER_FLAG_FINAL);
+	ret = crypt(tfm, src, dst, len, iv, flags);
 
 out:
 	return crypto_lskcipher_errstat(alg, ret);
 }
 
-int crypto_lskcipher_encrypt(struct crypto_lskcipher *tfm, const u8 *src,
-			     u8 *dst, unsigned len, u8 *iv)
+int crypto_lskcipher_encrypt_ext(struct crypto_lskcipher *tfm, const u8 *src,
+				 u8 *dst, unsigned len, u8 *iv, u32 flags)
 {
 	struct lskcipher_alg *alg = crypto_lskcipher_alg(tfm);
 
@@ -175,12 +176,13 @@ int crypto_lskcipher_encrypt(struct crypto_lskcipher *tfm, const u8 *src,
 		atomic64_add(len, &istat->encrypt_tlen);
 	}
 
-	return crypto_lskcipher_crypt(tfm, src, dst, len, iv, alg->encrypt);
+	return crypto_lskcipher_crypt(tfm, src, dst, len, iv, flags,
+				      alg->encrypt);
 }
-EXPORT_SYMBOL_GPL(crypto_lskcipher_encrypt);
+EXPORT_SYMBOL_GPL(crypto_lskcipher_encrypt_ext);
 
-int crypto_lskcipher_decrypt(struct crypto_lskcipher *tfm, const u8 *src,
-			     u8 *dst, unsigned len, u8 *iv)
+int crypto_lskcipher_decrypt_ext(struct crypto_lskcipher *tfm, const u8 *src,
+				 u8 *dst, unsigned len, u8 *iv, u32 flags)
 {
 	struct lskcipher_alg *alg = crypto_lskcipher_alg(tfm);
 
@@ -191,7 +193,24 @@ int crypto_lskcipher_decrypt(struct crypto_lskcipher *tfm, const u8 *src,
 		atomic64_add(len, &istat->decrypt_tlen);
 	}
 
-	return crypto_lskcipher_crypt(tfm, src, dst, len, iv, alg->decrypt);
+	return crypto_lskcipher_crypt(tfm, src, dst, len, iv, flags,
+				      alg->decrypt);
+}
+EXPORT_SYMBOL_GPL(crypto_lskcipher_decrypt_ext);
+
+int crypto_lskcipher_encrypt(struct crypto_lskcipher *tfm, const u8 *src,
+			     u8 *dst, unsigned len, u8 *iv)
+{
+	return crypto_lskcipher_encrypt_ext(tfm, src, dst, len, iv,
+					    CRYPTO_LSKCIPHER_FLAG_FINAL);
+}
+EXPORT_SYMBOL_GPL(crypto_lskcipher_encrypt);
+
+int crypto_lskcipher_decrypt(struct crypto_lskcipher *tfm, const u8 *src,
+			     u8 *dst, unsigned len, u8 *iv)
+{
+	return crypto_lskcipher_decrypt_ext(tfm, src, dst, len, iv,
+					    CRYPTO_LSKCIPHER_FLAG_FINAL);
 }
 EXPORT_SYMBOL_GPL(crypto_lskcipher_decrypt);
 
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 1e35e7719b22..0d43153f3cd2 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -90,6 +90,48 @@ struct skcipher_walk {
 	unsigned int alignmask;
 };
 
+/**
+ * crypto_lskcipher_encrypt_ext() - encrypt plaintext with continuation
+ * @tfm: lskcipher handle
+ * @src: source buffer
+ * @dst: destination buffer
+ * @len: number of bytes to process
+ * @siv: IV + state for the cipher operation.  The length of the IV must
+ *	 comply with the IV size defined by crypto_lskcipher_ivsize.  The
+ *	 IV is then followed with a buffer with the length as specified by
+ *	 crypto_lskcipher_statesize.
+ * @flags: Indicates whether this is a continuation and/or final operation.
+ *
+ * Encrypt plaintext data using the lskcipher handle with continuation.
+ *
+ * Return: >=0 if the cipher operation was successful, if positive
+ *	   then this many bytes have been left unprocessed;
+ *	   < 0 if an error occurred
+ */
+int crypto_lskcipher_encrypt_ext(struct crypto_lskcipher *tfm, const u8 *src,
+				 u8 *dst, unsigned len, u8 *siv, u32 flags);
+
+/**
+ * crypto_lskcipher_decrypt_ext() - decrypt ciphertext with continuation
+ * @tfm: lskcipher handle
+ * @src: source buffer
+ * @dst: destination buffer
+ * @len: number of bytes to process
+ * @siv: IV + state for the cipher operation.  The length of the IV must
+ *	 comply with the IV size defined by crypto_lskcipher_ivsize.  The
+ *	 IV is then followed with a buffer with the length as specified by
+ *	 crypto_lskcipher_statesize.
+ * @flags: Indicates whether this is a continuation and/or final operation.
+ *
+ * Decrypt ciphertext data using the lskcipher handle with continuation.
+ *
+ * Return: >=0 if the cipher operation was successful, if positive
+ *	   then this many bytes have been left unprocessed;
+ *	   < 0 if an error occurred
+ */
+int crypto_lskcipher_decrypt_ext(struct crypto_lskcipher *tfm, const u8 *src,
+				 u8 *dst, unsigned len, u8 *siv, u32 flags);
+
 static inline struct crypto_instance *skcipher_crypto_instance(
 	struct skcipher_instance *inst)
 {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

