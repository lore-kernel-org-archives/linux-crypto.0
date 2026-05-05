Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280F054654;
	Tue,  5 May 2026 21:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778015930; cv=none; b=Q1Hy+n/vypaMP8ZndswkOiJytGVUjqQGKX3XLOF4h5unhOObSUbD6atYIh1kwL9e5Iipvn4i4lMHox64tC8eLxmhupuYSTX6Hjd7xiSa8ztIBl9Za90MY/Yz7ABhGkqYr7EE8Zl+b2Kg+DV+rb4y32fHcXQbJVeHJR/+SaZnOTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778015930; c=relaxed/simple;
	bh=DTyuledXpz3dtM/s34YMa3lk7TYREhD0lrhXeqVXdcE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D9dUnhDrTOv29FlKlL6nJBm4LS1cWfAptbJ+I4UoEON/CyFVcomEzn5c6kiFKnKIeXyo5tU68FTVSLn3/EwMXPoEjvfiLKdM7/0K0T19+3/W1Ogf3wuO44wgmOVIPcukNnbHKz3VKCZ1TMQIqbhQJEVtbJ1HSou5V/OnAJklYvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=cBXaSzLB; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="cBXaSzLB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=MFlnx+suph9LoDhZWJOLP5qGCfdaeQ2pIC+DpBdNYQ8=; t=1778015929; x=1779225529; 
	b=cBXaSzLBbTnLgZnmWWZPNTv/+Pf+0cj9YAAHMLBoIx2fXa+Fglmlo/bqyjGp7ab6ZFNv63md3fQ
	68gEzAubjhAi3CCBsdKDP3KD9GMj2Lee2O3DIqJsOqdJS3u0CxdRA9PpzdXd1BPnJTUj4vB0fp9Y+
	wigXSDQc20JhAWtk/J5UxEz50vKKwuvv087MRi+irI3HGEXi2bAfEF/pDwSxpCtGX12ZJLimadz7T
	Q7BeYAej1Idr841ii9Xq22m7I2/f42vItfArDb1StEwKimzcxLxSSK66EeeHxw6XWZi4E7XDyD98V
	GCUFxhOo7kq9DgH+hvD2TYetBjXVXzmjXd/g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wKNAD-0000000H1AH-2iUo;
	Tue, 05 May 2026 23:18:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] wifi: mac80211: use aesgcm library
Date: Tue,  5 May 2026 23:18:38 +0200
Message-ID: <20260505211841.669767-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Instead of dynamically allocating the gcm(aes) algorithm, use
the library. This is faster and avoids the extra allocation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/Kconfig   |  2 +-
 net/mac80211/aes_gcm.h | 39 +++++++++++++++++----------------------
 net/mac80211/key.c     | 11 +++--------
 net/mac80211/key.h     |  3 ++-
 net/mac80211/wpa.c     |  9 +++++----
 5 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index d6bc295e23a1..b51050257c01 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -5,9 +5,9 @@ config MAC80211
 	select CRYPTO
 	select CRYPTO_LIB_AES_CBC_MACS
 	select CRYPTO_LIB_ARC4
+	select CRYPTO_LIB_AESGCM
 	select CRYPTO_AES
 	select CRYPTO_CCM
-	select CRYPTO_GCM
 	select CRC32
 	help
 	  This option enables the hardware independent IEEE 802.11
diff --git a/net/mac80211/aes_gcm.h b/net/mac80211/aes_gcm.h
index b14093b2f7a9..8124b81412c8 100644
--- a/net/mac80211/aes_gcm.h
+++ b/net/mac80211/aes_gcm.h
@@ -6,38 +6,33 @@
 #ifndef AES_GCM_H
 #define AES_GCM_H
 
-#include "aead_api.h"
+#include <crypto/gcm.h>
 
 #define GCM_AAD_LEN	32
 
-static inline int ieee80211_aes_gcm_encrypt(struct crypto_aead *tfm,
-					    u8 *j_0, u8 *aad,  u8 *data,
-					    size_t data_len, u8 *mic)
+static inline void ieee80211_aes_gcm_encrypt(struct aesgcm_ctx *ctx,
+					     u8 *j_0, u8 *aad,  u8 *data,
+					     size_t data_len, u8 *mic)
 {
-	return aead_encrypt(tfm, j_0, aad + 2,
-			    be16_to_cpup((__be16 *)aad),
-			    data, data_len, mic);
+	aesgcm_encrypt(ctx, data, data, data_len,
+		       aad + 2, be16_to_cpup((__be16 *)aad),
+		       j_0, mic);
 }
 
-static inline int ieee80211_aes_gcm_decrypt(struct crypto_aead *tfm,
-					    u8 *j_0, u8 *aad, u8 *data,
-					    size_t data_len, u8 *mic)
+static inline bool ieee80211_aes_gcm_decrypt(struct aesgcm_ctx *ctx,
+					     u8 *j_0, u8 *aad, u8 *data,
+					     size_t data_len, u8 *mic)
 {
-	return aead_decrypt(tfm, j_0, aad + 2,
-			    be16_to_cpup((__be16 *)aad),
-			    data, data_len, mic);
+	return aesgcm_decrypt(ctx, data, data, data_len,
+			      aad + 2, be16_to_cpup((__be16 *)aad),
+			      j_0, mic);
 }
 
-static inline struct crypto_aead *
-ieee80211_aes_gcm_key_setup_encrypt(const u8 key[], size_t key_len)
+static inline int
+ieee80211_aes_gcm_key_setup_encrypt(struct aesgcm_ctx *ctx,
+				    const u8 key[], size_t key_len)
 {
-	return aead_key_setup_encrypt("gcm(aes)", key,
-				      key_len, IEEE80211_GCMP_MIC_LEN);
-}
-
-static inline void ieee80211_aes_gcm_key_free(struct crypto_aead *tfm)
-{
-	return aead_key_free(tfm);
+	return aesgcm_expandkey(ctx, key, key_len, IEEE80211_GCMP_MIC_LEN);
 }
 
 #endif /* AES_GCM_H */
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 4b8965633df3..1a2092aebaf6 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -727,10 +727,9 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		/* Initialize AES key state here as an optimization so that
 		 * it does not need to be initialized for every packet.
 		 */
-		key->u.gcmp.tfm = ieee80211_aes_gcm_key_setup_encrypt(key_data,
-								      key_len);
-		if (IS_ERR(key->u.gcmp.tfm)) {
-			err = PTR_ERR(key->u.gcmp.tfm);
+		err = ieee80211_aes_gcm_key_setup_encrypt(&key->u.gcmp.ctx,
+							  key_data, key_len);
+		if (err) {
 			kfree(key);
 			return ERR_PTR(err);
 		}
@@ -753,10 +752,6 @@ static void ieee80211_key_free_common(struct ieee80211_key *key)
 	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
 		ieee80211_aes_gmac_key_free(key->u.aes_gmac.tfm);
 		break;
-	case WLAN_CIPHER_SUITE_GCMP:
-	case WLAN_CIPHER_SUITE_GCMP_256:
-		ieee80211_aes_gcm_key_free(key->u.gcmp.tfm);
-		break;
 	}
 	kfree_sensitive(key);
 }
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 826e4e9387c5..65450d3474bb 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -13,6 +13,7 @@
 #include <linux/crypto.h>
 #include <linux/rcupdate.h>
 #include <crypto/aes-cbc-macs.h>
+#include <crypto/gcm.h>
 #include <crypto/arc4.h>
 #include <net/mac80211.h>
 
@@ -111,7 +112,7 @@ struct ieee80211_key {
 			 * Management frames.
 			 */
 			u8 rx_pn[IEEE80211_NUM_TIDS + 1][IEEE80211_GCMP_PN_LEN];
-			struct crypto_aead *tfm;
+			struct aesgcm_ctx ctx;
 			u32 replays; /* dot11RSNAStatsGCMPReplays */
 		} gcmp;
 		struct {
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index be3a2e95303c..4440e09c5f80 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -709,8 +709,9 @@ static int gcmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	gcmp_special_blocks(skb, pn, j_0, aad,
 			    key->conf.flags & IEEE80211_KEY_FLAG_SPP_AMSDU,
 			    false);
-	return ieee80211_aes_gcm_encrypt(key->u.gcmp.tfm, j_0, aad, pos, len,
-					 skb_put(skb, IEEE80211_GCMP_MIC_LEN));
+	ieee80211_aes_gcm_encrypt(&key->u.gcmp.ctx, j_0, aad, pos, len,
+				  skb_put(skb, IEEE80211_GCMP_MIC_LEN));
+	return 0;
 }
 
 ieee80211_tx_result
@@ -797,8 +798,8 @@ ieee80211_crypto_gcmp_decrypt(struct ieee80211_rx_data *rx)
 					    key->conf.flags & IEEE80211_KEY_FLAG_SPP_AMSDU,
 					    aad_nonce_computed);
 
-			if (ieee80211_aes_gcm_decrypt(
-				    key->u.gcmp.tfm, j_0, aad,
+			if (!ieee80211_aes_gcm_decrypt(
+				    &key->u.gcmp.ctx, j_0, aad,
 				    skb->data + hdrlen + IEEE80211_GCMP_HDR_LEN,
 				    data_len,
 				    skb->data + skb->len -
-- 
2.53.0

