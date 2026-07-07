Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB6B39D3FD;
	Tue,  7 Jul 2026 05:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402645; cv=none; b=d9hBFnfHIogd3NZUVKOPp2ySToLnmMIHtNB+0LtrY63p20O0HwLBKnxaIuLbHJK0cgc5nA51Muwkc3FZkFiAy17OWL3wYZidvakBE3qQM1/OVIaD5GfymSpxVqQRbKRXSIj2eSs0hLkN5l/4hlfDNEGEeF4BMxREFIGE/NzWLA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402645; c=relaxed/simple;
	bh=l3j4pSy3S/BpwJM75f6uUvEbQ/N02745UutOqGu9ryI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFr4gyHZK37LRDQE+eF58qcNZg6dDgaZzWrMLrRqvQ7af38eaHeUO9WO9aLX+6RrfmxFZ1Ps12XJng+nPaAXla1zsm80milc/txmoPPqbmUGTHE181kA7xc+MI1+8cU/WSLbEwD+hyWIRgbXNJOOFk6V20ck30NUyv5alOWsOPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ieZTTq+H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ieZTTq+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10A71F00A3F;
	Tue,  7 Jul 2026 05:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402642;
	bh=rEYnScAUX3cf0uH1kOuenh+JKSqVYZOK5DL91ioYZ2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ieZTTq+H2WIFoaa0wrk+ZuhFidfULOjGTLj2PiNYMgmMHh2u3RbnvZQ24FVMwkl74
	 cfZY8Cb/tu2Vk+QK97xNA2SV2Cg2GSJ8THeJ23VDQljB/grpH9pAL/jXQo8FNLkofz
	 SU5/F4hBhbcHIjdCv/f3Tn0OQrgpd6MaoivWXMvK3YuJKW22qZObOwKO3gWkpL2e8N
	 sCZHAJ3ACueylixqrUCzcv9xj9XRcrSXdgE6vNDedauDWdTl9jgKVUKEqdFiHp53/h
	 BVHBNiRe8qKxtZJWvN0ZNVACyYQbLuuzT361jasXZvRBGx/w3jr09tvJYM25bGvUpH
	 Ifm7XItqZclnw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 25/33] wifi: mac80211: Use crypto libraries for GCMP and CCMP suites
Date: Mon,  6 Jul 2026 22:34:55 -0700
Message-ID: <20260707053503.209874-26-ebiggers@kernel.org>
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

Now that there are library APIs for AES-GCM and AES-CCM, for the GCMP
and CCMP cipher suites use them instead of "gcm(aes)" and "ccm(aes)"
crypto_aeads.  This significantly simplifies the code and eliminates
per-skb heap allocations.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/mac80211/Kconfig    |   5 +-
 net/mac80211/Makefile   |   1 -
 net/mac80211/aead_api.c | 113 ----------------------------------------
 net/mac80211/aead_api.h |  23 --------
 net/mac80211/aes_ccm.h  |  39 +++++---------
 net/mac80211/aes_gcm.h  |  38 +++++---------
 net/mac80211/key.c      |  31 ++++-------
 net/mac80211/key.h      |   5 +-
 net/mac80211/wpa.c      |  11 ++--
 9 files changed, 45 insertions(+), 221 deletions(-)
 delete mode 100644 net/mac80211/aead_api.c
 delete mode 100644 net/mac80211/aead_api.h

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 32808c5de0fb..5658f089d915 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -2,14 +2,11 @@
 config MAC80211
 	tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
 	depends on CFG80211
-	select CRYPTO
 	select CRYPTO_LIB_AES_CBC_MACS
+	select CRYPTO_LIB_AES_CCM
 	select CRYPTO_LIB_AES_CTR
 	select CRYPTO_LIB_AES_GCM
 	select CRYPTO_LIB_ARC4
-	select CRYPTO_AES
-	select CRYPTO_CCM
-	select CRYPTO_GCM
 	select CRC32
 	help
 	  This option enables the hardware independent IEEE 802.11
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 36f1e3e2222b..2ae7a57565cd 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -7,7 +7,6 @@ mac80211-y := \
 	driver-ops.o \
 	sta_info.o \
 	wep.o \
-	aead_api.o \
 	wpa.o \
 	scan.o offchannel.o \
 	ht.o agg-tx.o agg-rx.o \
diff --git a/net/mac80211/aead_api.c b/net/mac80211/aead_api.c
deleted file mode 100644
index b00d6f5b33f4..000000000000
--- a/net/mac80211/aead_api.c
+++ /dev/null
@@ -1,113 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright 2003-2004, Instant802 Networks, Inc.
- * Copyright 2005-2006, Devicescape Software, Inc.
- * Copyright 2014-2015, Qualcomm Atheros, Inc.
- *
- * Rewrite: Copyright (C) 2013 Linaro Ltd <ard.biesheuvel@linaro.org>
- */
-
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/err.h>
-#include <linux/scatterlist.h>
-#include <crypto/aead.h>
-
-#include "aead_api.h"
-
-int aead_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad, size_t aad_len,
-		 u8 *data, size_t data_len, u8 *mic)
-{
-	size_t mic_len = crypto_aead_authsize(tfm);
-	struct scatterlist sg[3];
-	struct aead_request *aead_req;
-	int reqsize = sizeof(*aead_req) + crypto_aead_reqsize(tfm);
-	u8 *__aad;
-	int ret;
-
-	aead_req = kzalloc(reqsize + aad_len, GFP_ATOMIC);
-	if (!aead_req)
-		return -ENOMEM;
-
-	__aad = (u8 *)aead_req + reqsize;
-	memcpy(__aad, aad, aad_len);
-
-	sg_init_table(sg, 3);
-	sg_set_buf(&sg[0], __aad, aad_len);
-	sg_set_buf(&sg[1], data, data_len);
-	sg_set_buf(&sg[2], mic, mic_len);
-
-	aead_request_set_tfm(aead_req, tfm);
-	aead_request_set_crypt(aead_req, sg, sg, data_len, b_0);
-	aead_request_set_ad(aead_req, sg[0].length);
-
-	ret = crypto_aead_encrypt(aead_req);
-	kfree_sensitive(aead_req);
-
-	return ret;
-}
-
-int aead_decrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad, size_t aad_len,
-		 u8 *data, size_t data_len, u8 *mic)
-{
-	size_t mic_len = crypto_aead_authsize(tfm);
-	struct scatterlist sg[3];
-	struct aead_request *aead_req;
-	int reqsize = sizeof(*aead_req) + crypto_aead_reqsize(tfm);
-	u8 *__aad;
-	int err;
-
-	if (data_len == 0)
-		return -EINVAL;
-
-	aead_req = kzalloc(reqsize + aad_len, GFP_ATOMIC);
-	if (!aead_req)
-		return -ENOMEM;
-
-	__aad = (u8 *)aead_req + reqsize;
-	memcpy(__aad, aad, aad_len);
-
-	sg_init_table(sg, 3);
-	sg_set_buf(&sg[0], __aad, aad_len);
-	sg_set_buf(&sg[1], data, data_len);
-	sg_set_buf(&sg[2], mic, mic_len);
-
-	aead_request_set_tfm(aead_req, tfm);
-	aead_request_set_crypt(aead_req, sg, sg, data_len + mic_len, b_0);
-	aead_request_set_ad(aead_req, sg[0].length);
-
-	err = crypto_aead_decrypt(aead_req);
-	kfree_sensitive(aead_req);
-
-	return err;
-}
-
-struct crypto_aead *
-aead_key_setup_encrypt(const char *alg, const u8 key[],
-		       size_t key_len, size_t mic_len)
-{
-	struct crypto_aead *tfm;
-	int err;
-
-	tfm = crypto_alloc_aead(alg, 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(tfm))
-		return tfm;
-
-	err = crypto_aead_setkey(tfm, key, key_len);
-	if (err)
-		goto free_aead;
-	err = crypto_aead_setauthsize(tfm, mic_len);
-	if (err)
-		goto free_aead;
-
-	return tfm;
-
-free_aead:
-	crypto_free_aead(tfm);
-	return ERR_PTR(err);
-}
-
-void aead_key_free(struct crypto_aead *tfm)
-{
-	crypto_free_aead(tfm);
-}
diff --git a/net/mac80211/aead_api.h b/net/mac80211/aead_api.h
deleted file mode 100644
index 7d463b80926a..000000000000
--- a/net/mac80211/aead_api.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-
-#ifndef _AEAD_API_H
-#define _AEAD_API_H
-
-#include <crypto/aead.h>
-#include <linux/crypto.h>
-
-struct crypto_aead *
-aead_key_setup_encrypt(const char *alg, const u8 key[],
-		       size_t key_len, size_t mic_len);
-
-int aead_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
-		 size_t aad_len, u8 *data,
-		 size_t data_len, u8 *mic);
-
-int aead_decrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
-		 size_t aad_len, u8 *data,
-		 size_t data_len, u8 *mic);
-
-void aead_key_free(struct crypto_aead *tfm);
-
-#endif /* _AEAD_API_H */
diff --git a/net/mac80211/aes_ccm.h b/net/mac80211/aes_ccm.h
index 96256193cf49..f8d5e9cbf0dc 100644
--- a/net/mac80211/aes_ccm.h
+++ b/net/mac80211/aes_ccm.h
@@ -7,39 +7,26 @@
 #ifndef AES_CCM_H
 #define AES_CCM_H
 
-#include "aead_api.h"
+#include <asm/byteorder.h>
+#include <crypto/aes-ccm.h>
 
 #define CCM_AAD_LEN	32
 
-static inline struct crypto_aead *
-ieee80211_aes_key_setup_encrypt(const u8 key[], size_t key_len, size_t mic_len)
+static inline int ieee80211_aes_ccm_encrypt(const struct aes_ccm_key *key,
+					    const u8 *b_0, const u8 *aad,
+					    u8 *data, size_t data_len, u8 *mic)
 {
-	return aead_key_setup_encrypt("ccm(aes)", key, key_len, mic_len);
+	return aes_ccm_encrypt(data, mic, data, data_len, aad + 2,
+			       be16_to_cpup((__be16 *)aad), b_0 + 1, 13, key);
 }
 
-static inline int
-ieee80211_aes_ccm_encrypt(struct crypto_aead *tfm,
-			  u8 *b_0, u8 *aad, u8 *data,
-			  size_t data_len, u8 *mic)
+static inline int ieee80211_aes_ccm_decrypt(const struct aes_ccm_key *key,
+					    const u8 *b_0, const u8 *aad,
+					    u8 *data, size_t data_len,
+					    const u8 *mic)
 {
-	return aead_encrypt(tfm, b_0, aad + 2,
-			    be16_to_cpup((__be16 *)aad),
-			    data, data_len, mic);
-}
-
-static inline int
-ieee80211_aes_ccm_decrypt(struct crypto_aead *tfm,
-			  u8 *b_0, u8 *aad, u8 *data,
-			  size_t data_len, u8 *mic)
-{
-	return aead_decrypt(tfm, b_0, aad + 2,
-			    be16_to_cpup((__be16 *)aad),
-			    data, data_len, mic);
-}
-
-static inline void ieee80211_aes_key_free(struct crypto_aead *tfm)
-{
-	return aead_key_free(tfm);
+	return aes_ccm_decrypt(data, data, mic, data_len, aad + 2,
+			       be16_to_cpup((__be16 *)aad), b_0 + 1, 13, key);
 }
 
 #endif /* AES_CCM_H */
diff --git a/net/mac80211/aes_gcm.h b/net/mac80211/aes_gcm.h
index b14093b2f7a9..ba13617aeb75 100644
--- a/net/mac80211/aes_gcm.h
+++ b/net/mac80211/aes_gcm.h
@@ -6,38 +6,26 @@
 #ifndef AES_GCM_H
 #define AES_GCM_H
 
-#include "aead_api.h"
+#include <asm/byteorder.h>
+#include <crypto/aes-gcm.h>
 
 #define GCM_AAD_LEN	32
 
-static inline int ieee80211_aes_gcm_encrypt(struct crypto_aead *tfm,
-					    u8 *j_0, u8 *aad,  u8 *data,
-					    size_t data_len, u8 *mic)
+static inline void ieee80211_aes_gcm_encrypt(const struct aes_gcm_key *key,
+					     const u8 *j_0, const u8 *aad,
+					     u8 *data, size_t data_len, u8 *mic)
 {
-	return aead_encrypt(tfm, j_0, aad + 2,
-			    be16_to_cpup((__be16 *)aad),
-			    data, data_len, mic);
+	aes_gcm_encrypt(data, mic, data, data_len, aad + 2,
+			be16_to_cpup((__be16 *)aad), j_0, key);
 }
 
-static inline int ieee80211_aes_gcm_decrypt(struct crypto_aead *tfm,
-					    u8 *j_0, u8 *aad, u8 *data,
-					    size_t data_len, u8 *mic)
+static inline int ieee80211_aes_gcm_decrypt(const struct aes_gcm_key *key,
+					    const u8 *j_0, const u8 *aad,
+					    u8 *data, size_t data_len,
+					    const u8 *mic)
 {
-	return aead_decrypt(tfm, j_0, aad + 2,
-			    be16_to_cpup((__be16 *)aad),
-			    data, data_len, mic);
-}
-
-static inline struct crypto_aead *
-ieee80211_aes_gcm_key_setup_encrypt(const u8 key[], size_t key_len)
-{
-	return aead_key_setup_encrypt("gcm(aes)", key,
-				      key_len, IEEE80211_GCMP_MIC_LEN);
-}
-
-static inline void ieee80211_aes_gcm_key_free(struct crypto_aead *tfm)
-{
-	return aead_key_free(tfm);
+	return aes_gcm_decrypt(data, data, mic, data_len, aad + 2,
+			       be16_to_cpup((__be16 *)aad), j_0, key);
 }
 
 #endif /* AES_GCM_H */
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 48404097e4f1..8c8a82d91bf2 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -652,10 +652,9 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		 * Initialize AES key state here as an optimization so that
 		 * it does not need to be initialized for every packet.
 		 */
-		key->u.ccmp.tfm = ieee80211_aes_key_setup_encrypt(
-			key_data, key_len, IEEE80211_CCMP_MIC_LEN);
-		if (IS_ERR(key->u.ccmp.tfm)) {
-			err = PTR_ERR(key->u.ccmp.tfm);
+		err = aes_ccm_preparekey(&key->u.ccmp.key, key_data, key_len,
+					 IEEE80211_CCMP_MIC_LEN);
+		if (err) {
 			kfree(key);
 			return ERR_PTR(err);
 		}
@@ -670,10 +669,9 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		/* Initialize AES key state here as an optimization so that
 		 * it does not need to be initialized for every packet.
 		 */
-		key->u.ccmp.tfm = ieee80211_aes_key_setup_encrypt(
-			key_data, key_len, IEEE80211_CCMP_256_MIC_LEN);
-		if (IS_ERR(key->u.ccmp.tfm)) {
-			err = PTR_ERR(key->u.ccmp.tfm);
+		err = aes_ccm_preparekey(&key->u.ccmp.key, key_data, key_len,
+					 IEEE80211_CCMP_256_MIC_LEN);
+		if (err) {
 			kfree(key);
 			return ERR_PTR(err);
 		}
@@ -729,10 +727,9 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		/* Initialize AES key state here as an optimization so that
 		 * it does not need to be initialized for every packet.
 		 */
-		key->u.gcmp.tfm = ieee80211_aes_gcm_key_setup_encrypt(key_data,
-								      key_len);
-		if (IS_ERR(key->u.gcmp.tfm)) {
-			err = PTR_ERR(key->u.gcmp.tfm);
+		err = aes_gcm_preparekey(&key->u.gcmp.key, key_data, key_len,
+					 IEEE80211_GCMP_MIC_LEN);
+		if (err) {
 			kfree(key);
 			return ERR_PTR(err);
 		}
@@ -746,16 +743,6 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 
 static void ieee80211_key_free_common(struct ieee80211_key *key)
 {
-	switch (key->conf.cipher) {
-	case WLAN_CIPHER_SUITE_CCMP:
-	case WLAN_CIPHER_SUITE_CCMP_256:
-		ieee80211_aes_key_free(key->u.ccmp.tfm);
-		break;
-	case WLAN_CIPHER_SUITE_GCMP:
-	case WLAN_CIPHER_SUITE_GCMP_256:
-		ieee80211_aes_gcm_key_free(key->u.gcmp.tfm);
-		break;
-	}
 	kfree_sensitive(key);
 }
 
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index d2dd2a76fa25..a43db120f61c 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -13,6 +13,7 @@
 #include <linux/crypto.h>
 #include <linux/rcupdate.h>
 #include <crypto/aes-cbc-macs.h>
+#include <crypto/aes-ccm.h>
 #include <crypto/aes-gcm.h>
 #include <crypto/arc4.h>
 #include <net/mac80211.h>
@@ -90,7 +91,7 @@ struct ieee80211_key {
 			 * Management frames.
 			 */
 			u8 rx_pn[IEEE80211_NUM_TIDS + 1][IEEE80211_CCMP_PN_LEN];
-			struct crypto_aead *tfm;
+			struct aes_ccm_key key;
 			u32 replays; /* dot11RSNAStatsCCMPReplays */
 		} ccmp;
 		struct {
@@ -112,7 +113,7 @@ struct ieee80211_key {
 			 * Management frames.
 			 */
 			u8 rx_pn[IEEE80211_NUM_TIDS + 1][IEEE80211_GCMP_PN_LEN];
-			struct crypto_aead *tfm;
+			struct aes_gcm_key key;
 			u32 replays; /* dot11RSNAStatsGCMPReplays */
 		} gcmp;
 		struct {
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index eb4a98537395..db57d383606f 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -492,7 +492,7 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb,
 	ccmp_special_blocks(skb, pn, b_0, aad,
 			    key->conf.flags & IEEE80211_KEY_FLAG_SPP_AMSDU,
 			    false);
-	return ieee80211_aes_ccm_encrypt(key->u.ccmp.tfm, b_0, aad, pos, len,
+	return ieee80211_aes_ccm_encrypt(&key->u.ccmp.key, b_0, aad, pos, len,
 					 skb_put(skb, mic_len));
 }
 
@@ -587,7 +587,7 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx,
 					    aad_nonce_computed);
 
 			if (ieee80211_aes_ccm_decrypt(
-				    key->u.ccmp.tfm, b_0, aad,
+				    &key->u.ccmp.key, b_0, aad,
 				    skb->data + hdrlen + IEEE80211_CCMP_HDR_LEN,
 				    data_len,
 				    skb->data + skb->len - mic_len))
@@ -709,8 +709,9 @@ static int gcmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	gcmp_special_blocks(skb, pn, j_0, aad,
 			    key->conf.flags & IEEE80211_KEY_FLAG_SPP_AMSDU,
 			    false);
-	return ieee80211_aes_gcm_encrypt(key->u.gcmp.tfm, j_0, aad, pos, len,
-					 skb_put(skb, IEEE80211_GCMP_MIC_LEN));
+	ieee80211_aes_gcm_encrypt(&key->u.gcmp.key, j_0, aad, pos, len,
+				  skb_put(skb, IEEE80211_GCMP_MIC_LEN));
+	return 0;
 }
 
 ieee80211_tx_result
@@ -798,7 +799,7 @@ ieee80211_crypto_gcmp_decrypt(struct ieee80211_rx_data *rx)
 					    aad_nonce_computed);
 
 			if (ieee80211_aes_gcm_decrypt(
-				    key->u.gcmp.tfm, j_0, aad,
+				    &key->u.gcmp.key, j_0, aad,
 				    skb->data + hdrlen + IEEE80211_GCMP_HDR_LEN,
 				    data_len,
 				    skb->data + skb->len -
-- 
2.54.0

