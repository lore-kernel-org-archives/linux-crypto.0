Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402B732D0E9;
	Mon,  5 Jan 2026 05:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767590109; cv=none; b=mAImCv3A2b4nkKB4NGVgTVZsLIb/0dD4SZXlR5XEkX0GCBya6xDupTZ6DG1gHXhBUZxoE8bjI6OgzMSEwo/hM3FU6GvQDRQbtE09fzJTDK5J/tA7zJ9mkT7U5rJO/tQEoTzXGWTDVQD5x4a16PWHjX5Exp5/mPWQ/5Y+n5PcEW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767590109; c=relaxed/simple;
	bh=pLGtNzAKc0LyxTZ2Mcmb/pp64y+CkxfMTXzhOdP/RaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUtv32m70S4FmcC6UsuCxw17sgq3P5iRUDxAuEoBIVLWQFgbc1KPqIjiMnl9QBgyyOxBFLkxSNqe+njXY0WBjXF/V9wDQcIOWAD2S/+E0D0aCn/j15NrQIwx9eRQnPmkeONEP0EdgUBNxQnXtYf/Ok7Yf5IrbDKNUcl7BUe2AaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MmsZ/qRf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MmsZ/qRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F03C4AF0B;
	Mon,  5 Jan 2026 05:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767590108;
	bh=pLGtNzAKc0LyxTZ2Mcmb/pp64y+CkxfMTXzhOdP/RaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmsZ/qRfKLZytMKJmngb3WeBk7WVifeswTA12xXEF/l57Xl/NJSVBbNUA4cwJNMzn
	 bLUBK10x2R3XWrRzzbm2cxC+XGscGowPV2OAkNqiMiKKOyaF1fuMz8/qw6K24KiA6F
	 oKScxEhEiKwjEgeoI3fbB/Jul9LjMFF9xtMKZVYjrpry0t3ykWEUdm4YdcSXX/TJDF
	 tash1gU50u/+Jr6pw6eTTnRaRac3IodBZOVBFYi9A/5AoHratPyMRbPqNuTCUFy+oD
	 UaO7bLexyNyJFhMS0RxR35euAkapgX8ZUlTnTXAYB9aKd7QBrHsFpPrzLnoKmFcU7R
	 i/TXDkuCc/yig==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 27/36] crypto: chelsio - Use new AES library API
Date: Sun,  4 Jan 2026 21:13:00 -0800
Message-ID: <20260105051311.1607207-28-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260105051311.1607207-1-ebiggers@kernel.org>
References: <20260105051311.1607207-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch from the old AES library functions (which use struct
crypto_aes_ctx) to the new ones (which use struct aes_key and struct
aes_enckey).  In encryption-only use cases, this eliminates the
unnecessary computation and caching of the decryption round keys.  The
new AES en/decryption functions are also much faster and use AES
instructions when supported by the CPU.

Note: aes_encrypt_new() and aes_decrypt_new() will be renamed to
aes_encrypt() and aes_decrypt(), respectively, once all callers of the
old aes_encrypt() and aes_decrypt() have been updated.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/crypto/chelsio/chcr_algo.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 22cbc343198a..b6b97088dfc5 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1026,11 +1026,11 @@ static int chcr_update_tweak(struct skcipher_request *req, u8 *iv,
 			     u32 isfinal)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct ablk_ctx *ablkctx = ABLK_CTX(c_ctx(tfm));
 	struct chcr_skcipher_req_ctx *reqctx = skcipher_request_ctx(req);
-	struct crypto_aes_ctx aes;
+	struct aes_key aes;
 	int ret, i;
 	u8 *key;
 	unsigned int keylen;
 	int round = reqctx->last_req_len / AES_BLOCK_SIZE;
 	int round8 = round / 8;
@@ -1042,24 +1042,24 @@ static int chcr_update_tweak(struct skcipher_request *req, u8 *iv,
 	/* For a 192 bit key remove the padded zeroes which was
 	 * added in chcr_xts_setkey
 	 */
 	if (KEY_CONTEXT_CK_SIZE_G(ntohl(ablkctx->key_ctx_hdr))
 			== CHCR_KEYCTX_CIPHER_KEY_SIZE_192)
-		ret = aes_expandkey(&aes, key, keylen - 8);
+		ret = aes_preparekey(&aes, key, keylen - 8);
 	else
-		ret = aes_expandkey(&aes, key, keylen);
+		ret = aes_preparekey(&aes, key, keylen);
 	if (ret)
 		return ret;
-	aes_encrypt(&aes, iv, iv);
+	aes_encrypt_new(&aes, iv, iv);
 	for (i = 0; i < round8; i++)
 		gf128mul_x8_ble((le128 *)iv, (le128 *)iv);
 
 	for (i = 0; i < (round % 8); i++)
 		gf128mul_x_ble((le128 *)iv, (le128 *)iv);
 
 	if (!isfinal)
-		aes_decrypt(&aes, iv, iv);
+		aes_decrypt_new(&aes, iv, iv);
 
 	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
@@ -3404,11 +3404,11 @@ static int chcr_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 {
 	struct chcr_aead_ctx *aeadctx = AEAD_CTX(a_ctx(aead));
 	struct chcr_gcm_ctx *gctx = GCM_CTX(aeadctx);
 	unsigned int ck_size;
 	int ret = 0, key_ctx_size = 0;
-	struct crypto_aes_ctx aes;
+	struct aes_enckey aes;
 
 	aeadctx->enckey_len = 0;
 	crypto_aead_clear_flags(aeadctx->sw_cipher, CRYPTO_TFM_REQ_MASK);
 	crypto_aead_set_flags(aeadctx->sw_cipher, crypto_aead_get_flags(aead)
 			      & CRYPTO_TFM_REQ_MASK);
@@ -3442,17 +3442,17 @@ static int chcr_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 						0, 0,
 						key_ctx_size >> 4);
 	/* Calculate the H = CIPH(K, 0 repeated 16 times).
 	 * It will go in key context
 	 */
-	ret = aes_expandkey(&aes, key, keylen);
+	ret = aes_prepareenckey(&aes, key, keylen);
 	if (ret) {
 		aeadctx->enckey_len = 0;
 		goto out;
 	}
 	memset(gctx->ghash_h, 0, AEAD_H_SIZE);
-	aes_encrypt(&aes, gctx->ghash_h, gctx->ghash_h);
+	aes_encrypt_new(&aes, gctx->ghash_h, gctx->ghash_h);
 	memzero_explicit(&aes, sizeof(aes));
 
 out:
 	return ret;
 }
-- 
2.52.0

