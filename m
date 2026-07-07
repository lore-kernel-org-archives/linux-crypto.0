Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DAF39901C;
	Tue,  7 Jul 2026 05:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402645; cv=none; b=lJUuklWrgIN840EJtc2nUS9yoa4TKB1AKOmVN5CmRd9ocQ9ZlctbexSex32suC/ANy+JzXQ9tblNHWzyQK+nhFEWXNZ9aJV6022mIBzfQVuh/hoBPrLW6FGj2KP3V52qjXi0teo77TPojqHW8H8IMyLULtdXa8HHVdz6GfRLBt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402645; c=relaxed/simple;
	bh=gkXaw9N9wAie3VPpL05KyvPuErzRjQtEFc5xqNcGmpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dieLpre4mV25FQF1AzYTr+BGbyXPye0rwJKsKW+KzFFfg8tBEtFFbYNCMybMirLrV0KHv45u8tvI4TqIrcqkStC/lu+uePRVijhvZ7rnJh1f8/OYwtZsASMOAs2EI3mrPOgBuTdSW4A4u/4GQ+IM3ocuqIeWTSZcyRtqrbG0CvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lpJQDCa/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lpJQDCa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D561F00AC4;
	Tue,  7 Jul 2026 05:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402642;
	bh=O6NkYemSwG02BxKncJa6aoWVaATKt7kOwIDrUSdbhuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lpJQDCa/cJnnemDqeKEAtUYXl2/nBjKTGxKknXXKHDBcP3d9HHYETapThi71p0sWh
	 6qC6ccqcHuTtaGZG6aYyVEtB8/mnYzQzdWklV9gkJN4F6jYUyE601tZvgtCZMtBiuR
	 2AZAwTChotj6fNmFsR7T96KvF4KjGSiPvzCdWkEGPfUGgU17oKxmvsssu4x3URNH1R
	 dxhI2YBD00HRRkBKWPYpvLLITFfhoZ9JTw3eOmvQK+7J639EzS0nn3OD9Q723teWe1
	 p3+0GoQSrjMImAFJoY/b3Di7LpbbSgv4pkyqO77RO2Gk9C9EqXdze0rbqvF0PW5PNE
	 M5mVslqMNLMYQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 24/33] wifi: mac80211: Use AES-GCM library for GMAC suite
Date: Mon,  6 Jul 2026 22:34:54 -0700
Message-ID: <20260707053503.209874-25-ebiggers@kernel.org>
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

Now that there's a library API for AES-GCM (of which AES-GMAC is a
special case), for implementing the GMAC cipher suite use it instead of
a "gcm(aes)" crypto_aead.  This significantly simplifies the code and
eliminates per-skb heap allocations.

As a bonus, ieee80211_crypto_aes_gmac_decrypt() no longer needs to
allocate 'mic' on the heap, since it no longer needs to be representable
as a scatterlist for crypto_aead.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/mac80211/Kconfig    |  1 +
 net/mac80211/aes_gmac.c | 85 ++++++++---------------------------------
 net/mac80211/aes_gmac.h | 10 ++---
 net/mac80211/key.c      | 11 ++----
 net/mac80211/key.h      |  3 +-
 net/mac80211/wpa.c      | 12 ++----
 6 files changed, 29 insertions(+), 93 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 8fe97e63ff39..32808c5de0fb 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -5,6 +5,7 @@ config MAC80211
 	select CRYPTO
 	select CRYPTO_LIB_AES_CBC_MACS
 	select CRYPTO_LIB_AES_CTR
+	select CRYPTO_LIB_AES_GCM
 	select CRYPTO_LIB_ARC4
 	select CRYPTO_AES
 	select CRYPTO_CCM
diff --git a/net/mac80211/aes_gmac.c b/net/mac80211/aes_gmac.c
index 811a83d8d525..722d8983bb5c 100644
--- a/net/mac80211/aes_gmac.c
+++ b/net/mac80211/aes_gmac.c
@@ -6,89 +6,34 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/err.h>
-#include <crypto/aead.h>
-#include <crypto/aes.h>
+#include <crypto/aes-gcm.h>
 
 #include <net/mac80211.h>
-#include "key.h"
 #include "aes_gmac.h"
 
-int ieee80211_aes_gmac(struct crypto_aead *tfm, const u8 *aad, u8 *nonce,
-		       const u8 *data, size_t data_len, u8 *mic)
+int ieee80211_aes_gmac(const struct aes_gcm_key *key, const u8 *aad,
+		       const u8 *nonce, const u8 *data, size_t data_len,
+		       u8 *mic)
 {
-	struct scatterlist sg[5];
-	u8 *zero, *__aad, iv[AES_BLOCK_SIZE];
-	struct aead_request *aead_req;
-	int reqsize = sizeof(*aead_req) + crypto_aead_reqsize(tfm);
+	static const u8 zero[IEEE80211_GMAC_MIC_LEN];
+	struct aes_gcm_ctx ctx;
 	const __le16 *fc;
-	int ret;
 
 	if (data_len < IEEE80211_GMAC_MIC_LEN)
 		return -EINVAL;
 
-	aead_req = kzalloc(reqsize + IEEE80211_GMAC_MIC_LEN + GMAC_AAD_LEN,
-			   GFP_ATOMIC);
-	if (!aead_req)
-		return -ENOMEM;
-
-	zero = (u8 *)aead_req + reqsize;
-	__aad = zero + IEEE80211_GMAC_MIC_LEN;
-	memcpy(__aad, aad, GMAC_AAD_LEN);
+	aes_gcm_init(&ctx, nonce, key);
+	aes_gcm_auth_update(&ctx, aad, GMAC_AAD_LEN);
 
 	fc = (const __le16 *)aad;
 	if (ieee80211_is_beacon(*fc)) {
 		/* mask Timestamp field to zero */
-		sg_init_table(sg, 5);
-		sg_set_buf(&sg[0], __aad, GMAC_AAD_LEN);
-		sg_set_buf(&sg[1], zero, 8);
-		sg_set_buf(&sg[2], data + 8,
-			   data_len - 8 - IEEE80211_GMAC_MIC_LEN);
-		sg_set_buf(&sg[3], zero, IEEE80211_GMAC_MIC_LEN);
-		sg_set_buf(&sg[4], mic, IEEE80211_GMAC_MIC_LEN);
-	} else {
-		sg_init_table(sg, 4);
-		sg_set_buf(&sg[0], __aad, GMAC_AAD_LEN);
-		sg_set_buf(&sg[1], data, data_len - IEEE80211_GMAC_MIC_LEN);
-		sg_set_buf(&sg[2], zero, IEEE80211_GMAC_MIC_LEN);
-		sg_set_buf(&sg[3], mic, IEEE80211_GMAC_MIC_LEN);
+		aes_gcm_auth_update(&ctx, zero, 8);
+		data += 8;
+		data_len -= 8;
 	}
-
-	memcpy(iv, nonce, GMAC_NONCE_LEN);
-	memset(iv + GMAC_NONCE_LEN, 0, sizeof(iv) - GMAC_NONCE_LEN);
-	iv[AES_BLOCK_SIZE - 1] = 0x01;
-
-	aead_request_set_tfm(aead_req, tfm);
-	aead_request_set_crypt(aead_req, sg, sg, 0, iv);
-	aead_request_set_ad(aead_req, GMAC_AAD_LEN + data_len);
-
-	ret = crypto_aead_encrypt(aead_req);
-	kfree_sensitive(aead_req);
-
-	return ret;
-}
-
-struct crypto_aead *ieee80211_aes_gmac_key_setup(const u8 key[],
-						 size_t key_len)
-{
-	struct crypto_aead *tfm;
-	int err;
-
-	tfm = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(tfm))
-		return tfm;
-
-	err = crypto_aead_setkey(tfm, key, key_len);
-	if (!err)
-		err = crypto_aead_setauthsize(tfm, IEEE80211_GMAC_MIC_LEN);
-	if (!err)
-		return tfm;
-
-	crypto_free_aead(tfm);
-	return ERR_PTR(err);
-}
-
-void ieee80211_aes_gmac_key_free(struct crypto_aead *tfm)
-{
-	crypto_free_aead(tfm);
+	aes_gcm_auth_update(&ctx, data, data_len - IEEE80211_GMAC_MIC_LEN);
+	aes_gcm_auth_update(&ctx, zero, IEEE80211_GMAC_MIC_LEN);
+	aes_gcm_encrypt_final(&ctx, mic);
+	return 0;
 }
diff --git a/net/mac80211/aes_gmac.h b/net/mac80211/aes_gmac.h
index 206136b60bca..f31bdfbecf3c 100644
--- a/net/mac80211/aes_gmac.h
+++ b/net/mac80211/aes_gmac.h
@@ -6,15 +6,13 @@
 #ifndef AES_GMAC_H
 #define AES_GMAC_H
 
-#include <linux/crypto.h>
+#include <crypto/aes-gcm.h>
 
 #define GMAC_AAD_LEN	20
 #define GMAC_NONCE_LEN	12
 
-struct crypto_aead *ieee80211_aes_gmac_key_setup(const u8 key[],
-						 size_t key_len);
-int ieee80211_aes_gmac(struct crypto_aead *tfm, const u8 *aad, u8 *nonce,
-		       const u8 *data, size_t data_len, u8 *mic);
-void ieee80211_aes_gmac_key_free(struct crypto_aead *tfm);
+int ieee80211_aes_gmac(const struct aes_gcm_key *key, const u8 *aad,
+		       const u8 *nonce, const u8 *data, size_t data_len,
+		       u8 *mic);
 
 #endif /* AES_GMAC_H */
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index f45e792abede..48404097e4f1 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -711,10 +711,9 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		/* Initialize AES key state here as an optimization so that
 		 * it does not need to be initialized for every packet.
 		 */
-		key->u.aes_gmac.tfm =
-			ieee80211_aes_gmac_key_setup(key_data, key_len);
-		if (IS_ERR(key->u.aes_gmac.tfm)) {
-			err = PTR_ERR(key->u.aes_gmac.tfm);
+		err = aes_gcm_preparekey(&key->u.aes_gmac.key, key_data,
+					 key_len, IEEE80211_GMAC_MIC_LEN);
+		if (err) {
 			kfree(key);
 			return ERR_PTR(err);
 		}
@@ -752,10 +751,6 @@ static void ieee80211_key_free_common(struct ieee80211_key *key)
 	case WLAN_CIPHER_SUITE_CCMP_256:
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
 		break;
-	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
-	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
-		ieee80211_aes_gmac_key_free(key->u.aes_gmac.tfm);
-		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		ieee80211_aes_gcm_key_free(key->u.gcmp.tfm);
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 826e4e9387c5..d2dd2a76fa25 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -13,6 +13,7 @@
 #include <linux/crypto.h>
 #include <linux/rcupdate.h>
 #include <crypto/aes-cbc-macs.h>
+#include <crypto/aes-gcm.h>
 #include <crypto/arc4.h>
 #include <net/mac80211.h>
 
@@ -100,7 +101,7 @@ struct ieee80211_key {
 		} aes_cmac;
 		struct {
 			u8 rx_pn[IEEE80211_GMAC_PN_LEN];
-			struct crypto_aead *tfm;
+			struct aes_gcm_key key;
 			u32 replays; /* dot11RSNAStatsCMACReplays */
 			u32 icverrors; /* dot11RSNAStatsCMACICVErrors */
 		} aes_gmac;
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index be3a2e95303c..eb4a98537395 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -1007,7 +1007,7 @@ ieee80211_crypto_aes_gmac_encrypt(struct ieee80211_tx_data *tx)
 	bip_ipn_swap(nonce + ETH_ALEN, mmie->sequence_number);
 
 	/* MIC = AES-GMAC(IGTK, AAD || Management Frame Body || MMIE, 128) */
-	if (ieee80211_aes_gmac(key->u.aes_gmac.tfm, aad, nonce,
+	if (ieee80211_aes_gmac(&key->u.aes_gmac.key, aad, nonce,
 			       skb->data + 24, skb->len - 24, mmie->mic) < 0)
 		return TX_DROP;
 
@@ -1021,7 +1021,8 @@ ieee80211_crypto_aes_gmac_decrypt(struct ieee80211_rx_data *rx)
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_key *key = rx->key;
 	struct ieee80211_mmie_16 *mmie;
-	u8 aad[GMAC_AAD_LEN], *mic, ipn[6], nonce[GMAC_NONCE_LEN];
+	u8 aad[GMAC_AAD_LEN], ipn[6], nonce[GMAC_NONCE_LEN];
+	u8 mic[IEEE80211_GMAC_MIC_LEN];
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
 	if (!ieee80211_is_mgmt(hdr->frame_control))
@@ -1052,18 +1053,13 @@ ieee80211_crypto_aes_gmac_decrypt(struct ieee80211_rx_data *rx)
 		memcpy(nonce, hdr->addr2, ETH_ALEN);
 		memcpy(nonce + ETH_ALEN, ipn, 6);
 
-		mic = kmalloc(IEEE80211_GMAC_MIC_LEN, GFP_ATOMIC);
-		if (!mic)
-			return RX_DROP_U_OOM;
-		if (ieee80211_aes_gmac(key->u.aes_gmac.tfm, aad, nonce,
+		if (ieee80211_aes_gmac(&key->u.aes_gmac.key, aad, nonce,
 				       skb->data + 24, skb->len - 24,
 				       mic) < 0 ||
 		    crypto_memneq(mic, mmie->mic, sizeof(mmie->mic))) {
 			key->u.aes_gmac.icverrors++;
-			kfree(mic);
 			return RX_DROP_U_MIC_FAIL;
 		}
-		kfree(mic);
 	}
 
 	memcpy(key->u.aes_gmac.rx_pn, ipn, 6);
-- 
2.54.0

