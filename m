Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3952517AA;
	Sat, 22 Nov 2025 19:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763840568; cv=none; b=XLSWfz/x1gneME6ZGAJbspjO2RpTWskMaIdPdXHdJi0VfJnZc6UaLy2oEBEYz/eqqD/SUbgNiIvo78ZHAxIOnIHZNZ2ZC5MDY6trQr7mvIC67FzgUqQdl96B3SDK7LpUKUahCMGja7C5n8E72s2XQq08gJai0a9V3ZflMesLH3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763840568; c=relaxed/simple;
	bh=A0WyYi2lZQmont5/W5lXFNTEABW9r6Yh7AxifpLgpHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZ1p5w2FX4tp/2AllGxZA7rU5SC51yz2ddBcXsQZyk+iCDWOcIFG5JnX6sGH3dt76so+7GcbjVQrNwryoBLx0ff5ZRacKqCnloxq18/JSXA+YFqvUJ1zRo/COLCb4gtaQ2J+2pyNAMJ93z8RGfurddCHScwMnLVkNGCFEtIXWPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SX/V+Btg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SX/V+Btg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B40C16AAE;
	Sat, 22 Nov 2025 19:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763840568;
	bh=A0WyYi2lZQmont5/W5lXFNTEABW9r6Yh7AxifpLgpHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SX/V+Btg4q5K3hk+7wzT/8Q/z1zB6Jogpb9MUOWA2wKxPM9Rm/awRD+ZYhZtsDj7X
	 Alt/MNeSncN4czeJmQhdWxGhqvULVJliFOHF0xC9zH5PfiYnSkU+ErTfmtna6ikQ9T
	 MUCgDdSIzzZ+UQ6KJiwKydvf3Bfe3d1pBo01FISUOb8mcDkYKAjr38cvpcIRXFjBJ/
	 vxKezOVeQrDqAth5vgi6TIeLP/G5JC71or/QG1rZFjCGQ3BGtGW6n/Ut52xSEkmFrr
	 vAn2AhghCEbMDhmYa4VsjYui8m9uUiejRsB3qoJ2/2rJd3qPKVK4mVxYqfsNARH24M
	 2wIniPmpbQ0Wg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6/6] lib/crypto: sha2: Add at_least decoration to fixed-size array params
Date: Sat, 22 Nov 2025 11:42:06 -0800
Message-ID: <20251122194206.31822-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251122194206.31822-1-ebiggers@kernel.org>
References: <20251122194206.31822-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the at_least (i.e. 'static') decoration to the fixed-size array
parameters of the sha2 library functions.  This causes clang to warn
when a too-small array of known size is passed.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/sha2.h | 53 +++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
index e5dafb935cc8..7bb8fe169daf 100644
--- a/include/crypto/sha2.h
+++ b/include/crypto/sha2.h
@@ -188,21 +188,21 @@ static inline void sha224_update(struct sha224_ctx *ctx,
  *
  * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
  *
  * Context: Any context.
  */
-void sha224_final(struct sha224_ctx *ctx, u8 out[SHA224_DIGEST_SIZE]);
+void sha224_final(struct sha224_ctx *ctx, u8 out[at_least SHA224_DIGEST_SIZE]);
 
 /**
  * sha224() - Compute SHA-224 message digest in one shot
  * @data: the message data
  * @len: the data length in bytes
  * @out: (output) the resulting SHA-224 message digest
  *
  * Context: Any context.
  */
-void sha224(const u8 *data, size_t len, u8 out[SHA224_DIGEST_SIZE]);
+void sha224(const u8 *data, size_t len, u8 out[at_least SHA224_DIGEST_SIZE]);
 
 /**
  * struct hmac_sha224_key - Prepared key for HMAC-SHA224
  * @key: private
  */
@@ -285,11 +285,12 @@ static inline void hmac_sha224_update(struct hmac_sha224_ctx *ctx,
  *
  * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
  *
  * Context: Any context.
  */
-void hmac_sha224_final(struct hmac_sha224_ctx *ctx, u8 out[SHA224_DIGEST_SIZE]);
+void hmac_sha224_final(struct hmac_sha224_ctx *ctx,
+		       u8 out[at_least SHA224_DIGEST_SIZE]);
 
 /**
  * hmac_sha224() - Compute HMAC-SHA224 in one shot, using a prepared key
  * @key: the prepared HMAC key
  * @data: the message data
@@ -299,11 +300,12 @@ void hmac_sha224_final(struct hmac_sha224_ctx *ctx, u8 out[SHA224_DIGEST_SIZE]);
  * If you're using the key only once, consider using hmac_sha224_usingrawkey().
  *
  * Context: Any context.
  */
 void hmac_sha224(const struct hmac_sha224_key *key,
-		 const u8 *data, size_t data_len, u8 out[SHA224_DIGEST_SIZE]);
+		 const u8 *data, size_t data_len,
+		 u8 out[at_least SHA224_DIGEST_SIZE]);
 
 /**
  * hmac_sha224_usingrawkey() - Compute HMAC-SHA224 in one shot, using a raw key
  * @raw_key: the raw HMAC-SHA224 key
  * @raw_key_len: the key length in bytes.  All key lengths are supported.
@@ -316,11 +318,11 @@ void hmac_sha224(const struct hmac_sha224_key *key,
  *
  * Context: Any context.
  */
 void hmac_sha224_usingrawkey(const u8 *raw_key, size_t raw_key_len,
 			     const u8 *data, size_t data_len,
-			     u8 out[SHA224_DIGEST_SIZE]);
+			     u8 out[at_least SHA224_DIGEST_SIZE]);
 
 /**
  * struct sha256_ctx - Context for hashing a message with SHA-256
  * @ctx: private
  */
@@ -361,21 +363,21 @@ static inline void sha256_update(struct sha256_ctx *ctx,
  *
  * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
  *
  * Context: Any context.
  */
-void sha256_final(struct sha256_ctx *ctx, u8 out[SHA256_DIGEST_SIZE]);
+void sha256_final(struct sha256_ctx *ctx, u8 out[at_least SHA256_DIGEST_SIZE]);
 
 /**
  * sha256() - Compute SHA-256 message digest in one shot
  * @data: the message data
  * @len: the data length in bytes
  * @out: (output) the resulting SHA-256 message digest
  *
  * Context: Any context.
  */
-void sha256(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE]);
+void sha256(const u8 *data, size_t len, u8 out[at_least SHA256_DIGEST_SIZE]);
 
 /**
  * sha256_finup_2x() - Compute two SHA-256 digests from a common initial
  *		       context.  On some CPUs, this is faster than sequentially
  *		       computing each digest.
@@ -388,12 +390,13 @@ void sha256(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE]);
  * @out2: (output) the second SHA-256 message digest
  *
  * Context: Any context.
  */
 void sha256_finup_2x(const struct sha256_ctx *ctx, const u8 *data1,
-		     const u8 *data2, size_t len, u8 out1[SHA256_DIGEST_SIZE],
-		     u8 out2[SHA256_DIGEST_SIZE]);
+		     const u8 *data2, size_t len,
+		     u8 out1[at_least SHA256_DIGEST_SIZE],
+		     u8 out2[at_least SHA256_DIGEST_SIZE]);
 
 /**
  * sha256_finup_2x_is_optimized() - Check if sha256_finup_2x() is using a real
  *				    interleaved implementation, as opposed to a
  *				    sequential fallback
@@ -486,11 +489,12 @@ static inline void hmac_sha256_update(struct hmac_sha256_ctx *ctx,
  *
  * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
  *
  * Context: Any context.
  */
-void hmac_sha256_final(struct hmac_sha256_ctx *ctx, u8 out[SHA256_DIGEST_SIZE]);
+void hmac_sha256_final(struct hmac_sha256_ctx *ctx,
+		       u8 out[at_least SHA256_DIGEST_SIZE]);
 
 /**
  * hmac_sha256() - Compute HMAC-SHA256 in one shot, using a prepared key
  * @key: the prepared HMAC key
  * @data: the message data
@@ -500,11 +504,12 @@ void hmac_sha256_final(struct hmac_sha256_ctx *ctx, u8 out[SHA256_DIGEST_SIZE]);
  * If you're using the key only once, consider using hmac_sha256_usingrawkey().
  *
  * Context: Any context.
  */
 void hmac_sha256(const struct hmac_sha256_key *key,
-		 const u8 *data, size_t data_len, u8 out[SHA256_DIGEST_SIZE]);
+		 const u8 *data, size_t data_len,
+		 u8 out[at_least SHA256_DIGEST_SIZE]);
 
 /**
  * hmac_sha256_usingrawkey() - Compute HMAC-SHA256 in one shot, using a raw key
  * @raw_key: the raw HMAC-SHA256 key
  * @raw_key_len: the key length in bytes.  All key lengths are supported.
@@ -517,11 +522,11 @@ void hmac_sha256(const struct hmac_sha256_key *key,
  *
  * Context: Any context.
  */
 void hmac_sha256_usingrawkey(const u8 *raw_key, size_t raw_key_len,
 			     const u8 *data, size_t data_len,
-			     u8 out[SHA256_DIGEST_SIZE]);
+			     u8 out[at_least SHA256_DIGEST_SIZE]);
 
 /* State for the SHA-512 (and SHA-384) compression function */
 struct sha512_block_state {
 	u64 h[8];
 };
@@ -596,21 +601,21 @@ static inline void sha384_update(struct sha384_ctx *ctx,
  *
  * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
  *
  * Context: Any context.
  */
-void sha384_final(struct sha384_ctx *ctx, u8 out[SHA384_DIGEST_SIZE]);
+void sha384_final(struct sha384_ctx *ctx, u8 out[at_least SHA384_DIGEST_SIZE]);
 
 /**
  * sha384() - Compute SHA-384 message digest in one shot
  * @data: the message data
  * @len: the data length in bytes
  * @out: (output) the resulting SHA-384 message digest
  *
  * Context: Any context.
  */
-void sha384(const u8 *data, size_t len, u8 out[SHA384_DIGEST_SIZE]);
+void sha384(const u8 *data, size_t len, u8 out[at_least SHA384_DIGEST_SIZE]);
 
 /**
  * struct hmac_sha384_key - Prepared key for HMAC-SHA384
  * @key: private
  */
@@ -693,11 +698,12 @@ static inline void hmac_sha384_update(struct hmac_sha384_ctx *ctx,
  *
  * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
  *
  * Context: Any context.
  */
-void hmac_sha384_final(struct hmac_sha384_ctx *ctx, u8 out[SHA384_DIGEST_SIZE]);
+void hmac_sha384_final(struct hmac_sha384_ctx *ctx,
+		       u8 out[at_least SHA384_DIGEST_SIZE]);
 
 /**
  * hmac_sha384() - Compute HMAC-SHA384 in one shot, using a prepared key
  * @key: the prepared HMAC key
  * @data: the message data
@@ -707,11 +713,12 @@ void hmac_sha384_final(struct hmac_sha384_ctx *ctx, u8 out[SHA384_DIGEST_SIZE]);
  * If you're using the key only once, consider using hmac_sha384_usingrawkey().
  *
  * Context: Any context.
  */
 void hmac_sha384(const struct hmac_sha384_key *key,
-		 const u8 *data, size_t data_len, u8 out[SHA384_DIGEST_SIZE]);
+		 const u8 *data, size_t data_len,
+		 u8 out[at_least SHA384_DIGEST_SIZE]);
 
 /**
  * hmac_sha384_usingrawkey() - Compute HMAC-SHA384 in one shot, using a raw key
  * @raw_key: the raw HMAC-SHA384 key
  * @raw_key_len: the key length in bytes.  All key lengths are supported.
@@ -724,11 +731,11 @@ void hmac_sha384(const struct hmac_sha384_key *key,
  *
  * Context: Any context.
  */
 void hmac_sha384_usingrawkey(const u8 *raw_key, size_t raw_key_len,
 			     const u8 *data, size_t data_len,
-			     u8 out[SHA384_DIGEST_SIZE]);
+			     u8 out[at_least SHA384_DIGEST_SIZE]);
 
 /**
  * struct sha512_ctx - Context for hashing a message with SHA-512
  * @ctx: private
  */
@@ -769,21 +776,21 @@ static inline void sha512_update(struct sha512_ctx *ctx,
  *
  * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
  *
  * Context: Any context.
  */
-void sha512_final(struct sha512_ctx *ctx, u8 out[SHA512_DIGEST_SIZE]);
+void sha512_final(struct sha512_ctx *ctx, u8 out[at_least SHA512_DIGEST_SIZE]);
 
 /**
  * sha512() - Compute SHA-512 message digest in one shot
  * @data: the message data
  * @len: the data length in bytes
  * @out: (output) the resulting SHA-512 message digest
  *
  * Context: Any context.
  */
-void sha512(const u8 *data, size_t len, u8 out[SHA512_DIGEST_SIZE]);
+void sha512(const u8 *data, size_t len, u8 out[at_least SHA512_DIGEST_SIZE]);
 
 /**
  * struct hmac_sha512_key - Prepared key for HMAC-SHA512
  * @key: private
  */
@@ -866,11 +873,12 @@ static inline void hmac_sha512_update(struct hmac_sha512_ctx *ctx,
  *
  * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
  *
  * Context: Any context.
  */
-void hmac_sha512_final(struct hmac_sha512_ctx *ctx, u8 out[SHA512_DIGEST_SIZE]);
+void hmac_sha512_final(struct hmac_sha512_ctx *ctx,
+		       u8 out[at_least SHA512_DIGEST_SIZE]);
 
 /**
  * hmac_sha512() - Compute HMAC-SHA512 in one shot, using a prepared key
  * @key: the prepared HMAC key
  * @data: the message data
@@ -880,11 +888,12 @@ void hmac_sha512_final(struct hmac_sha512_ctx *ctx, u8 out[SHA512_DIGEST_SIZE]);
  * If you're using the key only once, consider using hmac_sha512_usingrawkey().
  *
  * Context: Any context.
  */
 void hmac_sha512(const struct hmac_sha512_key *key,
-		 const u8 *data, size_t data_len, u8 out[SHA512_DIGEST_SIZE]);
+		 const u8 *data, size_t data_len,
+		 u8 out[at_least SHA512_DIGEST_SIZE]);
 
 /**
  * hmac_sha512_usingrawkey() - Compute HMAC-SHA512 in one shot, using a raw key
  * @raw_key: the raw HMAC-SHA512 key
  * @raw_key_len: the key length in bytes.  All key lengths are supported.
@@ -897,8 +906,8 @@ void hmac_sha512(const struct hmac_sha512_key *key,
  *
  * Context: Any context.
  */
 void hmac_sha512_usingrawkey(const u8 *raw_key, size_t raw_key_len,
 			     const u8 *data, size_t data_len,
-			     u8 out[SHA512_DIGEST_SIZE]);
+			     u8 out[at_least SHA512_DIGEST_SIZE]);
 
 #endif /* _CRYPTO_SHA2_H */
-- 
2.51.2

