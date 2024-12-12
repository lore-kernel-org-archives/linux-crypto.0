Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CF31D79B4
	for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2024 21:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734038956; cv=none; b=jfj2kukbPtm1WdOSMi3fhgU1A5ZRTIwjEi+c8gnWNk9JZoY+q2M1lJY1r2F8uKZyX77YHJhg6uignXmENNIzHUkLSUVvfW4bE6l62+zCsuJj1QMnor8aUqhHIaegApcBfrCtpikCtWTvz5/oSprF84oKU9EZmzwGlroVgTg3PnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734038956; c=relaxed/simple;
	bh=irQS/qqvaIZjrLrFc9t6oh6P4EtcoJVwxiXnHqisG2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQdBLVuPdt10FskgAb8FxjDydfw0LnTMF8xAfHneu/mbn5uPtfXJwh0JpzLN/TarwkL0TcRjpqpIhEFRrwQtBcM723Ltn+CYkpLs4+k1ZRibk2bAQH6g1AGTK7fwW3ZeXW+e2sSg+vWLOWec+3FkdjDPhRSLqP/LyvlJZ5divVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=slWTMyhm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="slWTMyhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE8BC4CED3;
	Thu, 12 Dec 2024 21:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734038956;
	bh=irQS/qqvaIZjrLrFc9t6oh6P4EtcoJVwxiXnHqisG2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slWTMyhmhrX+evPy+y5P3BlUjmJzDRB4u2Ww/EhLp97PUN2NXfzBCF7/xftYFJsU8
	 5CpQyfbPPuFOrNRrQE4If9PJCT577o9SMl8bVDPca+fo8CxXtDF9l4l66JxqkjUylL
	 VUdlpBVNEtWbNtmcvIU2Gl2EAx0NMe2UAEMOVAL6Nz5fR5BI/RdrLBd8tQsUAmTf6O
	 AK0UNvfxBaEyF0N4ybs0wx+j/CartZkPWW4K6YDtQ2z4RNKg0L2MtSzDQ0uZ7zkjiQ
	 wls/QiFKL9JqeXCCMaprBwph9hYEXm25Pk8TvtNYLQ8fB3YMlDjo+LAmm1O14mnTpf
	 8UCez49v6rFsA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH v2 6/8] crypto: x86/aes-xts - change len parameter to int
Date: Thu, 12 Dec 2024 13:28:43 -0800
Message-ID: <20241212212845.40333-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212212845.40333-1-ebiggers@kernel.org>
References: <20241212212845.40333-1-ebiggers@kernel.org>
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
index 903b894e5f48..c4e8ba6ed61d 100644
--- a/arch/x86/crypto/aes-xts-avx-x86_64.S
+++ b/arch/x86/crypto/aes-xts-avx-x86_64.S
@@ -765,11 +765,11 @@ SYM_FUNC_END(aes_xts_encrypt_iv)
 
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
index fbf43482e1f5..11e95fc62636 100644
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

