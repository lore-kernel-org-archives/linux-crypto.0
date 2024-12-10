Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A8F22C373
	for <linux-crypto@vger.kernel.org>; Tue, 10 Dec 2024 23:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733875150; cv=none; b=e1r6TyqiqsyUoqVJbhjQSC1NHBmwOz3SovjsKH12hP5GjewQWOAaZg/0uA00yy90fJVovoQ22azeZqK9ZIeg6DnMPIOzDTvH548UzF6Z91lxybBpx8sORP9th7YHOumZ/zXlUmkpPLeltXwzp4m6AElF9F1r+nwxsc7t48W6C8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733875150; c=relaxed/simple;
	bh=qeaRCPBXqIDZP/J2KL40Si6lLr3Xq+los47PzgXgjVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtZ5CYyvJHiMNt13sn8Pgqexd2Uh1eMBMEnVDA70BzyVMjtC+hvLufXTMiSXU0h/gwMfQ8Vjh9jdKKbowowiQ0RkkL1aZdcs07eVpPtkCEOQP73q3wbW2752IuQ9YSCj+AaO0SdakVlUeK+TkS7f3H9D8ubUAqRHuZzYS3IkPiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RBHtDYrH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RBHtDYrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4007AC4CEE0;
	Tue, 10 Dec 2024 23:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733875150;
	bh=qeaRCPBXqIDZP/J2KL40Si6lLr3Xq+los47PzgXgjVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBHtDYrH5MPG3sXdB8ZsGKNRkXwd5FC8xN+7Vpc7KrULsu+hNGOhIjHuB3i+DLlCj
	 /luXmM9E+kAL3GP0TKDlqhlInNA+JWW1u3IRUnLPtGQkBHBRzuVuJF6A6Azo4ewvAU
	 Uskt/ypWm+I5W40+UEdPSBlzdrOFz2S3g7sy+cQkAgM603VtxwiaKyITmxJ1ZzysFW
	 epQRGtrS7HrC+neMLxcgB7Bn3yyma5Cm7YtcREBBI+cs2nf6DGvE9HykjUtEOA9Yvg
	 w4+XWGHZuYZ3TuUhwN+kYvxRAQC0r3I4gXZy/VI/VvuT0rjLkR1kj2n+dsUphgyE/Z
	 WFX4V4TSbNevg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH 6/7] crypto: x86/aes-xts - change len parameter to int
Date: Tue, 10 Dec 2024 15:58:33 -0800
Message-ID: <20241210235834.40862-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241210235834.40862-1-ebiggers@kernel.org>
References: <20241210235834.40862-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

The AES-XTS assembly code currently treats the length as signed, since
this saves a few instructions in the loop compared to treating it as
unsigned.  Therefore update the type to make this clear.  (It is not
actually passed any values larger than PAGE_SIZE.)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aes-xts-avx-x86_64.S |  2 +-
 arch/x86/crypto/aesni-intel_glue.c   | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/aes-xts-avx-x86_64.S b/arch/x86/crypto/aes-xts-avx-x86_64.S
index a94f02b7c5b47..bb3d0dfeca575 100644
--- a/arch/x86/crypto/aes-xts-avx-x86_64.S
+++ b/arch/x86/crypto/aes-xts-avx-x86_64.S
@@ -777,11 +777,11 @@ SYM_FUNC_END(aes_xts_encrypt_iv)
 
 // Below are the actual AES-XTS encryption and decryption functions,
 // instantiated from the above macro.  They all have the following prototype:
 //
 // void (*xts_crypt_func)(const struct crypto_aes_ctx *key,
-//			  const u8 *src, u8 *dst, unsigned int len,
+//			  const u8 *src, u8 *dst, int len,
 //			  u8 tweak[AES_BLOCK_SIZE]);
 //
 // |key| is the data key.  |tweak| contains the next tweak; the encryption of
 // the original IV with the tweak key was already done.  This function supports
 // incremental computation, but |len| must always be >= 16 (AES_BLOCK_SIZE), and
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index fbf43482e1f5e..11e95fc62636e 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -503,11 +503,11 @@ static int xts_setkey_aesni(struct crypto_skcipher *tfm, const u8 *key,
 }
 
 typedef void (*xts_encrypt_iv_func)(const struct crypto_aes_ctx *tweak_key,
 				    u8 iv[AES_BLOCK_SIZE]);
 typedef void (*xts_crypt_func)(const struct crypto_aes_ctx *key,
-			       const u8 *src, u8 *dst, unsigned int len,
+			       const u8 *src, u8 *dst, int len,
 			       u8 tweak[AES_BLOCK_SIZE]);
 
 /* This handles cases where the source and/or destination span pages. */
 static noinline int
 xts_crypt_slowpath(struct skcipher_request *req, xts_crypt_func crypt_func)
@@ -622,18 +622,18 @@ static void aesni_xts_encrypt_iv(const struct crypto_aes_ctx *tweak_key,
 {
 	aesni_enc(tweak_key, iv, iv);
 }
 
 static void aesni_xts_encrypt(const struct crypto_aes_ctx *key,
-			      const u8 *src, u8 *dst, unsigned int len,
+			      const u8 *src, u8 *dst, int len,
 			      u8 tweak[AES_BLOCK_SIZE])
 {
 	aesni_xts_enc(key, dst, src, len, tweak);
 }
 
 static void aesni_xts_decrypt(const struct crypto_aes_ctx *key,
-			      const u8 *src, u8 *dst, unsigned int len,
+			      const u8 *src, u8 *dst, int len,
 			      u8 tweak[AES_BLOCK_SIZE])
 {
 	aesni_xts_dec(key, dst, src, len, tweak);
 }
 
@@ -788,14 +788,14 @@ asmlinkage void aes_xts_encrypt_iv(const struct crypto_aes_ctx *tweak_key,
 
 #define DEFINE_XTS_ALG(suffix, driver_name, priority)			       \
 									       \
 asmlinkage void								       \
 aes_xts_encrypt_##suffix(const struct crypto_aes_ctx *key, const u8 *src,      \
-			 u8 *dst, unsigned int len, u8 tweak[AES_BLOCK_SIZE]); \
+			 u8 *dst, int len, u8 tweak[AES_BLOCK_SIZE]);	       \
 asmlinkage void								       \
 aes_xts_decrypt_##suffix(const struct crypto_aes_ctx *key, const u8 *src,      \
-			 u8 *dst, unsigned int len, u8 tweak[AES_BLOCK_SIZE]); \
+			 u8 *dst, int len, u8 tweak[AES_BLOCK_SIZE]);	       \
 									       \
 static int xts_encrypt_##suffix(struct skcipher_request *req)		       \
 {									       \
 	return xts_crypt(req, aes_xts_encrypt_iv, aes_xts_encrypt_##suffix);   \
 }									       \
-- 
2.47.1

