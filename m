Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3812D389470;
	Mon, 12 Jan 2026 19:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245809; cv=none; b=cviE+jELZsSzqvPLNBXO7Q5IBzDr5jvQCJhb+4yiUeVgnuPimr0SpN5Lki4ZHxkVyrJlupWF58P/ZHgcv9QXYdqIOxfPrEjBEl9fFfo3pWFIzLEf2VuHInfAKwiJXZZ0KzWgnQkdvPoFz5aLNTMZg+j2Kgg8qcEocyqTq3GfqMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245809; c=relaxed/simple;
	bh=xvx6Irt7McLpPRJvPxDb3Q6MTwdCsiaMbdNL/psBoQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvKqJ2kxI/vIpgEddMW8PrDoOAeRKJCHtxvn9DlUwAA2CiciLvPeBgwu+pBoaPXjlsRaZfveJ9dBG/SYNevC92jP8z2cjKmHukidY20Yoja0gUictHdTp/LcBa6MfdcovO6sCEi+sqRmKhQNu+OFNz85Tn26IQZIaYWQhnGov18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ztmz/OJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ztmz/OJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F11C16AAE;
	Mon, 12 Jan 2026 19:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245808;
	bh=xvx6Irt7McLpPRJvPxDb3Q6MTwdCsiaMbdNL/psBoQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ztmz/OJnF9izXz1+11a8n8ue1FadL6xEIAIHmPJpOtWbTN9uLhp38Q5NZMtTNf8aL
	 u+iSqUH9pU6VIiYWo3gzNM1xlS7YKdPMY9mbRVfzMqa37dHo65ZjmMu6p85wAVEdAY
	 bQMwsA23bhIBlPgkuOxsETreww86x/B0/6WYH68Jh94Fyw9pYwW3UUwNKqizt117J0
	 rxn9PbiGHKUJG859mT4+TqPx0KqNAsb4uGSAm+xwEXDfk1F4iQHO7xwvILfXd2sTKF
	 8or8T+eKsv4Mt8hE/RXUc9xdpUYb3qL0VJQMVSdcMV8FUB8VLen/q5RT2A26UjvjRw
	 rPnOlNCQe1Y7w==
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
Subject: [PATCH v2 20/35] chelsio: Use new AES library API
Date: Mon, 12 Jan 2026 11:20:18 -0800
Message-ID: <20260112192035.10427-21-ebiggers@kernel.org>
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
crypto_aes_ctx) to the new ones (which use struct aes_enckey).  This
eliminates the unnecessary computation and caching of the decryption
round keys.  The new AES en/decryption functions are also much faster
and use AES instructions when supported by the CPU.

Note that in addition to the change in the key preparation function and
the key struct type itself, the change in the type of the key struct
results in aes_encrypt() (which is temporarily a type-generic macro)
calling the new encryption function rather than the old one.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 .../ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c  | 4 ++--
 .../ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c    | 8 ++++----
 .../net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c   | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
index 49b57bb5fac1..074717d4bb16 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
@@ -168,11 +168,11 @@ static int ch_ipsec_setkey(struct xfrm_state *x,
 {
 	int keylen = (x->aead->alg_key_len + 7) / 8;
 	unsigned char *key = x->aead->alg_key;
 	int ck_size, key_ctx_size = 0;
 	unsigned char ghash_h[AEAD_H_SIZE];
-	struct crypto_aes_ctx aes;
+	struct aes_enckey aes;
 	int ret = 0;
 
 	if (keylen > 3) {
 		keylen -= 4;  /* nonce/salt is present in the last 4 bytes */
 		memcpy(sa_entry->salt, key + keylen, 4);
@@ -202,11 +202,11 @@ static int ch_ipsec_setkey(struct xfrm_state *x,
 						 key_ctx_size >> 4);
 
 	/* Calculate the H = CIPH(K, 0 repeated 16 times).
 	 * It will go in key context
 	 */
-	ret = aes_expandkey(&aes, key, keylen);
+	ret = aes_prepareenckey(&aes, key, keylen);
 	if (ret) {
 		sa_entry->enckey_len = 0;
 		goto out;
 	}
 	memset(ghash_h, 0, AEAD_H_SIZE);
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 4e2096e49684..b8ebb56de65e 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -74,11 +74,11 @@ static int chcr_ktls_save_keys(struct chcr_ktls_info *tx_info,
 {
 	int ck_size, key_ctx_size, mac_key_size, keylen, ghash_size, ret;
 	unsigned char ghash_h[TLS_CIPHER_AES_GCM_256_TAG_SIZE];
 	struct tls12_crypto_info_aes_gcm_128 *info_128_gcm;
 	struct ktls_key_ctx *kctx = &tx_info->key_ctx;
-	struct crypto_aes_ctx aes_ctx;
+	struct aes_enckey aes;
 	unsigned char *key, *salt;
 
 	switch (crypto_info->cipher_type) {
 	case TLS_CIPHER_AES_GCM_128:
 		info_128_gcm =
@@ -136,17 +136,17 @@ static int chcr_ktls_save_keys(struct chcr_ktls_info *tx_info,
 		       roundup(keylen, 16) + ghash_size;
 	/* Calculate the H = CIPH(K, 0 repeated 16 times).
 	 * It will go in key context
 	 */
 
-	ret = aes_expandkey(&aes_ctx, key, keylen);
+	ret = aes_prepareenckey(&aes, key, keylen);
 	if (ret)
 		goto out;
 
 	memset(ghash_h, 0, ghash_size);
-	aes_encrypt(&aes_ctx, ghash_h, ghash_h);
-	memzero_explicit(&aes_ctx, sizeof(aes_ctx));
+	aes_encrypt(&aes, ghash_h, ghash_h);
+	memzero_explicit(&aes, sizeof(aes));
 
 	/* fill the Key context */
 	if (direction == TLS_OFFLOAD_CTX_DIR_TX) {
 		kctx->ctx_hdr = FILL_KEY_CTX_HDR(ck_size,
 						 mac_key_size,
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
index fab6df21f01c..d84473ca844d 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
@@ -245,11 +245,11 @@ static int chtls_key_info(struct chtls_sock *csk,
 {
 	unsigned char key[AES_MAX_KEY_SIZE];
 	unsigned char *key_p, *salt;
 	unsigned char ghash_h[AEAD_H_SIZE];
 	int ck_size, key_ctx_size, kctx_mackey_size, salt_size;
-	struct crypto_aes_ctx aes;
+	struct aes_enckey aes;
 	int ret;
 
 	key_ctx_size = sizeof(struct _key_ctx) +
 		       roundup(keylen, 16) + AEAD_H_SIZE;
 
@@ -289,11 +289,11 @@ static int chtls_key_info(struct chtls_sock *csk,
 	}
 
 	/* Calculate the H = CIPH(K, 0 repeated 16 times).
 	 * It will go in key context
 	 */
-	ret = aes_expandkey(&aes, key, keylen);
+	ret = aes_prepareenckey(&aes, key, keylen);
 	if (ret)
 		return ret;
 
 	memset(ghash_h, 0, AEAD_H_SIZE);
 	aes_encrypt(&aes, ghash_h, ghash_h);
-- 
2.52.0

