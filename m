Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2509338A9BF;
	Mon, 12 Jan 2026 19:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245813; cv=none; b=lG7JMvbQrrVQVFdEkfdy/XEwEm5fMTPrt3J+/bLyECtXoCIyc5ku0BCIOvVf1R8CK9NP8BM8QAf7T3zLcvvHghGiRYmbRuJZbSmhgtnEOlC4eZsxLPxkcLMbGM28JOG9zgEQidPRcjz0J7TdpYXrPqm63yCNzKfT8WwbAzmRG7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245813; c=relaxed/simple;
	bh=7I4DcEvD7P+NyOF/LOh0qFaXJ6PJTspoaqEhJ+gX51o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twNrAKP430fqwDpcXJMRIrhtF1oDtw5jw3oyYPXiO1NqPakcVkLyLWorA4NzStUHm/ZvBgrDOxYkm3aQta+zlODN6aFXNjQht34iGykeM2UdANKFxiiNbeb0pGGRN8WKJ0z+KlYz8U1kjhIGx9A/CnregKrFD4Kx5IffZ1FBh0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PymYATdt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PymYATdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE59C19425;
	Mon, 12 Jan 2026 19:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245812;
	bh=7I4DcEvD7P+NyOF/LOh0qFaXJ6PJTspoaqEhJ+gX51o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PymYATdtVCGHtK+IbBx3OFqORWyLECLJGtun3Jj0HzhwQUnp5PEQ2Z9S9x88kkdko
	 jUXgwbgKhfLYl9+rn22YpJ6nMXJhRWGUZMMOnLkD1ttB7pCshIL8f6DatUASbcIJPh
	 w3dt6U3TeqjuUwc+5wzfDRo2vDDVv1aQI42Oz6rzi6v2VG4qwgWSOEOiyhxKhUsghP
	 qepcFLhDk7/7wRQCfEOZKxibmYmQeA/7sqB6KT5TTszT3MkOnTULUKSQI5UqSvt8mP
	 juZKyxZVaIqSygbpdRTz8OnZqX0J+Gxb55kqte5mEeQyVUsERKFlNqc/04wqru1f7+
	 pC3yvHkPsxIVQ==
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
Subject: [PATCH v2 27/35] crypto: chelsio - Use new AES library API
Date: Mon, 12 Jan 2026 11:20:25 -0800
Message-ID: <20260112192035.10427-28-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112192035.10427-1-ebiggers@kernel.org>
References: <20260112192035.10427-1-ebiggers@kernel.org>
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

Note that in addition to the change in the key preparation function and
the key struct type itself, the change in the type of the key struct
results in aes_encrypt() (which is temporarily a type-generic macro)
calling the new encryption function rather than the old one.  Likewise
for decryption.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/crypto/chelsio/chcr_algo.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 22cbc343198a..6dec42282768 100644
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
@@ -1042,13 +1042,13 @@ static int chcr_update_tweak(struct skcipher_request *req, u8 *iv,
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
 	aes_encrypt(&aes, iv, iv);
 	for (i = 0; i < round8; i++)
 		gf128mul_x8_ble((le128 *)iv, (le128 *)iv);
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
@@ -3442,11 +3442,11 @@ static int chcr_gcm_setkey(struct crypto_aead *aead, const u8 *key,
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
-- 
2.52.0

