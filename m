Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6645D39768C;
	Tue,  7 Jul 2026 05:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402644; cv=none; b=oc2WCmPCjPd0T+v4AgANwNGkXvnVb3MG6UHqWWpEVCH+vERB3YAIT63v2aUUJt7p02RUOsnjOKmmi7rohLGJ2oMaRydkFMGqWwWndxYlnM/KYA/3x2wCRwUlMszSXlXmocU31uVreamlUDA4ySXyAHo7JR9mRLJH48byvJmbnXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402644; c=relaxed/simple;
	bh=ET8NMntbZDDc2lWt3QmZtwTOf1bwHna5VzCm8lpwn/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMsHsOkn3S/CH9rThaleUOrr29R4NPF1Cm1Sn70Fmng6lHGflaJY6lzwULkId6mQo++AGbJSHcEY6SrkOTv7L2s/3OEJ517W95Dxrun0RPx6z2GhdGbItt6LE9y5PJ20rLR242VA1bFy8Xpv8Vq478Ob14hjWgaQb5XjhcnzE+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TVt2rFhE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TVt2rFhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B711F000E9;
	Tue,  7 Jul 2026 05:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402642;
	bh=VFzo0Ibg3juz9F8W2byufaOTQ0sy3UmTLs0ydI762uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVt2rFhEmhaTQ3sJAm7tJ12uw6pXaEPVL3ypNkntElv0+4zaTl8yuoX8R0mgDVCZ0
	 K2fFKdluTNyjyj8RNcr4CuAxQk5aDcitswj7jNnkZY3CfcX+EWDiG5FjGEfOrqkg2H
	 c8WYBKQKmmiOST9Kx3PnGNrwx+Rn8PlztV1VOG0Wo8Ch8t5RuqhR7nVRfbN6yilqYI
	 6zXPM/fLcOrri46iL1QzrhCU1Uw2V6z20JErN87HpY42B5zDT+E8KkbAom6OadiK/T
	 39zZPbMg7swuHLUr/n4EJKGR8BMX749ZTQeAqaiXhcTFGCMkJY15JzLDDWNM2/D2ni
	 W0wODx3hGINJQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 23/33] wifi: mac80211: Use AES-CTR library in fils_aead.c
Date: Mon,  6 Jul 2026 22:34:53 -0700
Message-ID: <20260707053503.209874-24-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260707053503.209874-1-ebiggers@kernel.org>
References: <20260707053503.209874-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that there's a library API for AES-CTR, use it instead of a
"ctr(aes)" crypto_skcipher in aes_siv_encrypt() and aes_siv_decrypt().
This significantly simplifies the code.

Further simplify both aes_siv_encrypt() and aes_siv_decrypt() by
memmove()ing the source data to the destination buffer (which is offset
by 16 bytes from the source), then doing AES-CTR in-place.  This
eliminates the need for the temporary buffer in aes_siv_encrypt(), or to
rely on an unsupported overlapped operation in aes_siv_decrypt().  The
latter was technically a bug, though presumably it worked accidentally.

Finally, also fix the auth tag verification to use crypto_memneq().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/mac80211/Kconfig     |  1 +
 net/mac80211/fils_aead.c | 90 ++++++++++++----------------------------
 2 files changed, 27 insertions(+), 64 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index d6bc295e23a1..8fe97e63ff39 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -4,6 +4,7 @@ config MAC80211
 	depends on CFG80211
 	select CRYPTO
 	select CRYPTO_LIB_AES_CBC_MACS
+	select CRYPTO_LIB_AES_CTR
 	select CRYPTO_LIB_ARC4
 	select CRYPTO_AES
 	select CRYPTO_CCM
diff --git a/net/mac80211/fils_aead.c b/net/mac80211/fils_aead.c
index d2f4a17eab99..1084c3d0a0e7 100644
--- a/net/mac80211/fils_aead.c
+++ b/net/mac80211/fils_aead.c
@@ -5,7 +5,7 @@
  */
 
 #include <crypto/aes-cbc-macs.h>
-#include <crypto/skcipher.h>
+#include <crypto/aes-ctr.h>
 #include <crypto/utils.h>
 
 #include "ieee80211_i.h"
@@ -73,11 +73,8 @@ static int aes_siv_encrypt(const u8 *key, size_t key_len,
 			   size_t len[], u8 *out)
 {
 	u8 v[AES_BLOCK_SIZE];
-	struct crypto_skcipher *tfm2;
-	struct skcipher_request *req;
+	struct aes_enckey aes_key;
 	int res;
-	struct scatterlist src[1], dst[1];
-	u8 *tmp;
 
 	key_len /= 2; /* S2V key || CTR key */
 
@@ -90,12 +87,12 @@ static int aes_siv_encrypt(const u8 *key, size_t key_len,
 	if (res)
 		return res;
 
-	/* Use a temporary buffer of the plaintext to handle need for
-	 * overwriting this during AES-CTR.
+	/*
+	 * Move the plaintext to prepare it for in-place encryption.  This
+	 * avoids needing to copy it into a temporary buffer to prevent it from
+	 * being clobbered by the IV copy or AES-CTR itself when out == plain.
 	 */
-	tmp = kmemdup(plain, plain_len, GFP_KERNEL);
-	if (!tmp)
-		return -ENOMEM;
+	memmove(out + AES_BLOCK_SIZE, plain, plain_len);
 
 	/* IV for CTR before encrypted data */
 	memcpy(out, v, AES_BLOCK_SIZE);
@@ -106,33 +103,14 @@ static int aes_siv_encrypt(const u8 *key, size_t key_len,
 	v[8] &= 0x7f;
 	v[12] &= 0x7f;
 
-	/* CTR */
-
-	tfm2 = crypto_alloc_skcipher("ctr(aes)", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(tfm2)) {
-		kfree(tmp);
-		return PTR_ERR(tfm2);
-	}
-	/* K2 for CTR */
-	res = crypto_skcipher_setkey(tfm2, key + key_len, key_len);
+	/* CTR with K2 */
+	res = aes_prepareenckey(&aes_key, key + key_len, key_len);
 	if (res)
-		goto fail;
-
-	req = skcipher_request_alloc(tfm2, GFP_KERNEL);
-	if (!req) {
-		res = -ENOMEM;
-		goto fail;
-	}
-
-	sg_init_one(src, tmp, plain_len);
-	sg_init_one(dst, out + AES_BLOCK_SIZE, plain_len);
-	skcipher_request_set_crypt(req, src, dst, plain_len, v);
-	res = crypto_skcipher_encrypt(req);
-	skcipher_request_free(req);
-fail:
-	kfree(tmp);
-	crypto_free_skcipher(tfm2);
-	return res;
+		return res;
+	aes_ctr(out + AES_BLOCK_SIZE, out + AES_BLOCK_SIZE, plain_len, v,
+		&aes_key);
+	memzero_explicit(&aes_key, sizeof(aes_key));
+	return 0;
 }
 
 /* Note: addr[] and len[] needs to have one extra slot at the end. */
@@ -141,9 +119,7 @@ static int aes_siv_decrypt(const u8 *key, size_t key_len,
 			   size_t num_elem, const u8 *addr[], size_t len[],
 			   u8 *out)
 {
-	struct crypto_skcipher *tfm2;
-	struct skcipher_request *req;
-	struct scatterlist src[1], dst[1];
+	struct aes_enckey aes_key;
 	size_t crypt_len;
 	int res;
 	u8 frame_iv[AES_BLOCK_SIZE], iv[AES_BLOCK_SIZE];
@@ -164,38 +140,24 @@ static int aes_siv_decrypt(const u8 *key, size_t key_len,
 	iv[8] &= 0x7f;
 	iv[12] &= 0x7f;
 
-	/* CTR */
-
-	tfm2 = crypto_alloc_skcipher("ctr(aes)", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(tfm2))
-		return PTR_ERR(tfm2);
-	/* K2 for CTR */
-	res = crypto_skcipher_setkey(tfm2, key + key_len, key_len);
-	if (res) {
-		crypto_free_skcipher(tfm2);
-		return res;
-	}
-
-	req = skcipher_request_alloc(tfm2, GFP_KERNEL);
-	if (!req) {
-		crypto_free_skcipher(tfm2);
-		return -ENOMEM;
-	}
-
-	sg_init_one(src, iv_crypt + AES_BLOCK_SIZE, crypt_len);
-	sg_init_one(dst, out, crypt_len);
-	skcipher_request_set_crypt(req, src, dst, crypt_len, iv);
-	res = crypto_skcipher_decrypt(req);
-	skcipher_request_free(req);
-	crypto_free_skcipher(tfm2);
+	/* CTR with K2 */
+	res = aes_prepareenckey(&aes_key, key + key_len, key_len);
 	if (res)
 		return res;
+	/*
+	 * aes_ctr(out, iv_crypt + AES_BLOCK_SIZE, ...) is an unsupported
+	 * overlapped operation when out == iv_crypt, so memmove() the data to
+	 * 'out' first to enable standard in-place operation.
+	 */
+	memmove(out, iv_crypt + AES_BLOCK_SIZE, crypt_len);
+	aes_ctr(out, out, crypt_len, iv, &aes_key);
+	memzero_explicit(&aes_key, sizeof(aes_key));
 
 	/* S2V */
 	res = aes_s2v(key /* K1 */, key_len, num_elem, addr, len, check);
 	if (res)
 		return res;
-	if (memcmp(check, frame_iv, AES_BLOCK_SIZE) != 0)
+	if (crypto_memneq(check, frame_iv, AES_BLOCK_SIZE))
 		return -EINVAL;
 	return 0;
 }
-- 
2.54.0

