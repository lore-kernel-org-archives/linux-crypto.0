Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712F13A0E80;
	Tue,  7 Jul 2026 05:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402645; cv=none; b=G6kKO2ovAkaEfbMXHbHTX7Fi+nl+E5xYE8z9Y6ugGpwn9SQiB/KZoXSB+WlbNOrZn2xQNSLjaobxSPgvfgfFoFQMm096Rnhz3yE6JKebW0z/mMvt5A+xqQzbTr1BaGbCyHUW8wdf8hz6Hpc32he13/BS66jyFf82rG9zWy6aXCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402645; c=relaxed/simple;
	bh=dITPzCXNXrJ4vZl5OhTOQT86SaFx7ZHlTkbzfFCwBUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcgXVXo0zLLC4YE48/1fOV16TN/esQj03UIHVrW/rN6oAzN1UmjruP7umqsjLjPW3Npg6iPTZLJsRWp/wNYbELAg5Q2lC8I9D4wWMHK3wLHjRkpSQmLohXDabq/hDXIXJvSuM5LWQ+5YPcl9J6ZgMqkxDOI3dGLPegoK79toX3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KUWU/NN3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KUWU/NN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A8F1F00ACA;
	Tue,  7 Jul 2026 05:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402643;
	bh=XMzpF89IIQhd7C85S/chYiiKI4PoFEDPrRzDNCXOfhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUWU/NN38g4YvcCaKwz5h0siUT1kxuHlqte+1hU3aEuHUkFDIxbuzO0IPQWhFKdnk
	 cvkjlV/OLaOpHWIRNtCR2mCAU8v5wW5sRoZrMTWXpstpqJXINHmYHcy4rk9ZvzDRX3
	 Z6kFdMRgTWGG5KdXZZnaWA4zSK7kPEk3+gVADYGhVcQiA3ZBE3uqVbb0FB4KpHlFFc
	 vPwyRYGzoX703Pcx0HDkdpoFZMs9iGGrP+ToJsB767N6rTZUdXZjt+XYcORgZT5N7o
	 QiBsD2PoMhkSnQk/ZRBVCnmb2oKcO+PC5ys82B+JrWWOVhyjKIVBTd+EhN6hzdZ5ca
	 uP2SKT+nsIUhg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 27/33] wifi: ipw2x00: Use AES-CCM library
Date: Mon,  6 Jul 2026 22:34:57 -0700
Message-ID: <20260707053503.209874-28-ebiggers@kernel.org>
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

Now that there's a library API for AES-CCM, use it instead of a
"ccm(aes)" crypto_aead.

This significantly simplifies the code:

- Dynamic memory allocations go away, including ones during Tx and Rx.

- The additional authenticated data is now just constructed on the
  stack, as it no longer needs to be representable in a scatterlist.

- The AES-CCM library supports variable-length nonces via the
  self-explanatory nonce_len parameter, so for the needed 13-byte nonce
  just use that instead of the odd workaround used by "ccm(aes)" where
  the nonce was prefixed with a byte containing '14 - nonce_len'.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/Kconfig    |   2 +-
 .../intel/ipw2x00/libipw_crypto_ccmp.c        | 117 +++++-------------
 2 files changed, 29 insertions(+), 90 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/Kconfig b/drivers/net/wireless/intel/ipw2x00/Kconfig
index b508f14542d5..a1073d34f634 100644
--- a/drivers/net/wireless/intel/ipw2x00/Kconfig
+++ b/drivers/net/wireless/intel/ipw2x00/Kconfig
@@ -153,8 +153,8 @@ config LIBIPW
 	tristate
 	depends on PCI && CFG80211
 	select WIRELESS_EXT
-	select CRYPTO
 	select CRYPTO_LIB_ARC4
+	select CRYPTO_LIB_AES_CCM
 	select CRC32
 	help
 	This option enables the hardware independent IEEE 802.11
diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_crypto_ccmp.c b/drivers/net/wireless/intel/ipw2x00/libipw_crypto_ccmp.c
index 631a4dd86cab..aa6dce7acba1 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_crypto_ccmp.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_crypto_ccmp.c
@@ -19,15 +19,14 @@
 #include <asm/string.h>
 #include <linux/wireless.h>
 #include <linux/ieee80211.h>
-#include <linux/crypto.h>
-#include <crypto/aead.h>
+#include <crypto/aes-ccm.h>
 #include "libipw.h"
 
-#define AES_BLOCK_LEN 16
 #define CCMP_HDR_LEN 8
 #define CCMP_MIC_LEN 8
 #define CCMP_TK_LEN 16
 #define CCMP_PN_LEN 6
+#define CCMP_NONCE_LEN 13
 
 struct libipw_ccmp_data {
 	u8 key[CCMP_TK_LEN];
@@ -42,11 +41,7 @@ struct libipw_ccmp_data {
 
 	int key_idx;
 
-	struct crypto_aead *tfm;
-
-	/* scratch buffers for virt_to_page() (crypto API) */
-	u8 tx_aad[2 * AES_BLOCK_LEN];
-	u8 rx_aad[2 * AES_BLOCK_LEN];
+	struct aes_ccm_key ccm_key;
 };
 
 static void *libipw_ccmp_init(int key_idx)
@@ -55,37 +50,20 @@ static void *libipw_ccmp_init(int key_idx)
 
 	priv = kzalloc_obj(*priv, GFP_ATOMIC);
 	if (priv == NULL)
-		goto fail;
+		return NULL;
 	priv->key_idx = key_idx;
 
-	priv->tfm = crypto_alloc_aead("ccm(aes)", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(priv->tfm)) {
-		priv->tfm = NULL;
-		goto fail;
-	}
-
 	return priv;
-
-      fail:
-	if (priv) {
-		if (priv->tfm)
-			crypto_free_aead(priv->tfm);
-		kfree(priv);
-	}
-
-	return NULL;
 }
 
 static void libipw_ccmp_deinit(void *priv)
 {
-	struct libipw_ccmp_data *_priv = priv;
-	if (_priv && _priv->tfm)
-		crypto_free_aead(_priv->tfm);
-	kfree(priv);
+	kfree_sensitive(priv);
 }
 
-static int ccmp_init_iv_and_aad(const struct ieee80211_hdr *hdr,
-				const u8 *pn, u8 *iv, u8 *aad)
+static int ccmp_init_nonce_and_aad(const struct ieee80211_hdr *hdr,
+				   const u8 *pn, u8 nonce[CCMP_NONCE_LEN],
+				   u8 *aad)
 {
 	u8 *pos, qc = 0;
 	size_t aad_len;
@@ -105,19 +83,11 @@ static int ccmp_init_iv_and_aad(const struct ieee80211_hdr *hdr,
 		aad_len += 2;
 	}
 
-	/* In CCM, the initial vectors (IV) used for CTR mode encryption and CBC
-	 * mode authentication are not allowed to collide, yet both are derived
-	 * from the same vector. We only set L := 1 here to indicate that the
-	 * data size can be represented in (L+1) bytes. The CCM layer will take
-	 * care of storing the data length in the top (L+1) bytes and setting
-	 * and clearing the other bits as is required to derive the two IVs.
-	 */
-	iv[0] = 0x1;
-
 	/* Nonce: QC | A2 | PN */
-	iv[1] = qc;
-	memcpy(iv + 2, hdr->addr2, ETH_ALEN);
-	memcpy(iv + 8, pn, CCMP_PN_LEN);
+	nonce[0] = qc;
+	memcpy(nonce + 1, hdr->addr2, ETH_ALEN);
+	memcpy(nonce + 7, pn, CCMP_PN_LEN);
+	static_assert(7 + CCMP_PN_LEN == CCMP_NONCE_LEN);
 
 	/* AAD:
 	 * FC with bits 4..6 and 11..13 masked to zero; 14 is always one
@@ -184,12 +154,9 @@ static int libipw_ccmp_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct libipw_ccmp_data *key = priv;
 	struct ieee80211_hdr *hdr;
-	struct aead_request *req;
-	struct scatterlist sg[2];
-	u8 *aad = key->tx_aad;
-	u8 iv[AES_BLOCK_LEN];
+	u8 aad[2 * AES_BLOCK_SIZE];
+	u8 nonce[CCMP_NONCE_LEN];
 	int len, data_len, aad_len;
-	int ret;
 
 	if (skb_tailroom(skb) < CCMP_MIC_LEN || skb->len < hdr_len)
 		return -1;
@@ -199,28 +166,16 @@ static int libipw_ccmp_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	if (len < 0)
 		return -1;
 
-	req = aead_request_alloc(key->tfm, GFP_ATOMIC);
-	if (!req)
-		return -ENOMEM;
-
 	hdr = (struct ieee80211_hdr *)skb->data;
-	aad_len = ccmp_init_iv_and_aad(hdr, key->tx_pn, iv, aad);
+	aad_len = ccmp_init_nonce_and_aad(hdr, key->tx_pn, nonce, aad);
 
 	skb_put(skb, CCMP_MIC_LEN);
 
-	sg_init_table(sg, 2);
-	sg_set_buf(&sg[0], aad, aad_len);
-	sg_set_buf(&sg[1], skb->data + hdr_len + CCMP_HDR_LEN,
-		   data_len + CCMP_MIC_LEN);
-
-	aead_request_set_callback(req, 0, NULL, NULL);
-	aead_request_set_ad(req, aad_len);
-	aead_request_set_crypt(req, sg, sg, data_len, iv);
-
-	ret = crypto_aead_encrypt(req);
-	aead_request_free(req);
-
-	return ret;
+	return aes_ccm_encrypt(skb->data + hdr_len + CCMP_HDR_LEN,
+			       skb->data + hdr_len + CCMP_HDR_LEN + data_len,
+			       skb->data + hdr_len + CCMP_HDR_LEN, data_len,
+			       aad, aad_len, nonce, CCMP_NONCE_LEN,
+			       &key->ccm_key);
 }
 
 /*
@@ -249,10 +204,8 @@ static int libipw_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	struct libipw_ccmp_data *key = priv;
 	u8 keyidx, *pos;
 	struct ieee80211_hdr *hdr;
-	struct aead_request *req;
-	struct scatterlist sg[2];
-	u8 *aad = key->rx_aad;
-	u8 iv[AES_BLOCK_LEN];
+	u8 aad[2 * AES_BLOCK_SIZE];
+	u8 nonce[CCMP_NONCE_LEN];
 	u8 pn[6];
 	int aad_len, ret;
 	size_t data_len = skb->len - hdr_len - CCMP_HDR_LEN;
@@ -303,23 +256,11 @@ static int libipw_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 		return -4;
 	}
 
-	req = aead_request_alloc(key->tfm, GFP_ATOMIC);
-	if (!req)
-		return -ENOMEM;
-
-	aad_len = ccmp_init_iv_and_aad(hdr, pn, iv, aad);
-
-	sg_init_table(sg, 2);
-	sg_set_buf(&sg[0], aad, aad_len);
-	sg_set_buf(&sg[1], pos, data_len);
-
-	aead_request_set_callback(req, 0, NULL, NULL);
-	aead_request_set_ad(req, aad_len);
-	aead_request_set_crypt(req, sg, sg, data_len, iv);
-
-	ret = crypto_aead_decrypt(req);
-	aead_request_free(req);
+	aad_len = ccmp_init_nonce_and_aad(hdr, pn, nonce, aad);
 
+	ret = aes_ccm_decrypt(pos, pos, pos + data_len - CCMP_MIC_LEN,
+			      data_len - CCMP_MIC_LEN, aad, aad_len, nonce,
+			      CCMP_NONCE_LEN, &key->ccm_key);
 	if (ret) {
 		net_dbg_ratelimited("CCMP: decrypt failed: STA=%pM (%d)\n",
 				    hdr->addr2, ret);
@@ -341,12 +282,10 @@ static int libipw_ccmp_set_key(void *key, int len, u8 * seq, void *priv)
 {
 	struct libipw_ccmp_data *data = priv;
 	int keyidx;
-	struct crypto_aead *tfm = data->tfm;
 
 	keyidx = data->key_idx;
 	memset(data, 0, sizeof(*data));
 	data->key_idx = keyidx;
-	data->tfm = tfm;
 	if (len == CCMP_TK_LEN) {
 		memcpy(data->key, key, CCMP_TK_LEN);
 		data->key_set = 1;
@@ -358,8 +297,8 @@ static int libipw_ccmp_set_key(void *key, int len, u8 * seq, void *priv)
 			data->rx_pn[4] = seq[1];
 			data->rx_pn[5] = seq[0];
 		}
-		if (crypto_aead_setauthsize(data->tfm, CCMP_MIC_LEN) ||
-		    crypto_aead_setkey(data->tfm, data->key, CCMP_TK_LEN))
+		if (aes_ccm_preparekey(&data->ccm_key, data->key, CCMP_TK_LEN,
+				       CCMP_MIC_LEN))
 			return -1;
 	} else if (len == 0)
 		data->key_set = 0;
-- 
2.54.0

