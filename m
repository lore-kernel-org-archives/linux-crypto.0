Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23032C31E46
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 23:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC26120872
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 23:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZJd6DKeD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405298AbfFKXJt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 19:09:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43081 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404669AbfFKXJt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 19:09:49 -0400
Received: by mail-wr1-f65.google.com with SMTP id p13so4696947wru.10
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jun 2019 16:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NaiILqgzAo1oM2kDQ2vG7b0YVf55acSEfY/Ju2B3Oi8=;
        b=ZJd6DKeD1AzxELcM7gSOw56dlK9S+YNKBJusK8wo0dJlJzkqnq01vXncEmLd66Rlhd
         p0owB7NGeTVvPzaKGK71o5HaQXrKxn4UaQOaiD65m0qMkG4nRSvpsgQ9DkTs1GEzZqt0
         Hd4opH3CPAjuhphznsiP0v4cluxkU4OeyU6cyoaKKg6VCrkLkXc2TJ91YAlImJtBYqIK
         XxOnVyAtkopQfjQCRpikcGGPQyiS4sHwZeHwFWBqA3e6HNImDW/bpRqtDlwpiAp1WBsu
         LEbnaBUBJdagwwHKFpKxE3TEG2JR8q2yyRN8413dS7PN8SX3FXk9rhcAcArC+TvB7iGW
         /ELg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NaiILqgzAo1oM2kDQ2vG7b0YVf55acSEfY/Ju2B3Oi8=;
        b=c6uaOvwHI9JS/47kZ3P0SaqG5ar3HxwPQwhdLiN2/QPcxnE97VIZEkzKbzTp5sJ20Q
         vT7ravQJN+19oKdXJBLq2VckVZkSdRC/K44U6fAArl5hNvbppxNoLPciFB0k7FP8tgws
         juM3sC9wdkRQzObiZJAIz7X3txrgp7beny6lt3dOF9KF/yeQbPkLYDaxn5iowAhSIysG
         m1xl0bPBVOIzAw8MqhF87ucSa9ZK0kLZoKkQP41rAqSOGE4t8UuB+CntywTgXzefeHvR
         PtSCeG98cbt39iwNOJvOwJ4MBQ/M87kd3hjRZ6M+V8ztTvbgOcEorUxzt444LVBMrqh9
         6nqw==
X-Gm-Message-State: APjAAAWBcy8+CjaCGPgBPplGrEZKbQVdehyctaM6kliYbvvwq19G8wA1
        Fn6ToMwEeHM5tuZoIc9gOdxboFzjGIZ3B17c
X-Google-Smtp-Source: APXvYqz0vAupCaglK3So8sMvX8sCkO3+sv1s/56CrOC8Of3hAfo/WEiUydM++e88l4oLl3T7dOqLfw==
X-Received: by 2002:a05:6000:1289:: with SMTP id f9mr13404989wrx.125.1560294586194;
        Tue, 11 Jun 2019 16:09:46 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:24bb:7f31:25fe:43a7])
        by smtp.gmail.com with ESMTPSA id g11sm10827813wrq.89.2019.06.11.16.09.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 16:09:45 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v4 2/7] net/mac80211: move WEP handling to ARC4 library interface
Date:   Wed, 12 Jun 2019 01:09:33 +0200
Message-Id: <20190611230938.19265-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611230938.19265-1-ard.biesheuvel@linaro.org>
References: <20190611230938.19265-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The WEP code in the mac80211 subsystem currently uses the crypto
API to access the arc4 (RC4) cipher, which is overly complicated,
and doesn't really have an upside in this particular case, since
ciphers are always synchronous and therefore always implemented in
software. Given that we have no accelerated software implementations
either, it is much more straightforward to invoke a generic library
interface directly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 net/mac80211/Kconfig       |  2 +-
 net/mac80211/cfg.c         |  4 +-
 net/mac80211/ieee80211_i.h |  4 +-
 net/mac80211/key.h         |  1 +
 net/mac80211/main.c        |  6 +--
 net/mac80211/mlme.c        |  3 +-
 net/mac80211/tkip.c        |  8 ++--
 net/mac80211/tkip.h        |  4 +-
 net/mac80211/wep.c         | 49 ++++----------------
 net/mac80211/wep.h         |  5 +-
 net/mac80211/wpa.c         |  4 +-
 11 files changed, 30 insertions(+), 60 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 0227cce9685e..0c93b1b7a826 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -3,7 +3,7 @@ config MAC80211
 	tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
 	depends on CFG80211
 	select CRYPTO
-	select CRYPTO_ARC4
+	select CRYPTO_LIB_ARC4
 	select CRYPTO_AES
 	select CRYPTO_CCM
 	select CRYPTO_GCM
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a1973a26c7fc..3fae902937fd 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <net/net_namespace.h>
 #include <linux/rcupdate.h>
+#include <linux/fips.h>
 #include <linux/if_ether.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
@@ -402,9 +403,8 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_TKIP:
 	case WLAN_CIPHER_SUITE_WEP104:
-		if (IS_ERR(local->wep_tx_tfm))
+		if (WARN_ON_ONCE(fips_enabled))
 			return -EINVAL;
-		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_CCMP_256:
 	case WLAN_CIPHER_SUITE_AES_CMAC:
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 073a8235ae1b..412da8cfbc36 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1258,8 +1258,8 @@ struct ieee80211_local {
 
 	struct rate_control_ref *rate_ctrl;
 
-	struct crypto_cipher *wep_tx_tfm;
-	struct crypto_cipher *wep_rx_tfm;
+	struct arc4_ctx wep_tx_ctx;
+	struct arc4_ctx wep_rx_ctx;
 	u32 wep_iv;
 
 	/* see iface.c */
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index f06fbd03d235..6c5bbaebd02c 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -14,6 +14,7 @@
 #include <linux/list.h>
 #include <linux/crypto.h>
 #include <linux/rcupdate.h>
+#include <crypto/arc4.h>
 #include <net/mac80211.h>
 
 #define NUM_DEFAULT_KEYS 4
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 2b608044ae23..93c4a2d0623e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -13,6 +13,7 @@
 
 #include <net/mac80211.h>
 #include <linux/module.h>
+#include <linux/fips.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/types.h>
@@ -733,8 +734,7 @@ EXPORT_SYMBOL(ieee80211_alloc_hw_nm);
 
 static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 {
-	bool have_wep = !(IS_ERR(local->wep_tx_tfm) ||
-			  IS_ERR(local->wep_rx_tfm));
+	bool have_wep = !fips_enabled; /* FIPS does not permit the use of RC4 */
 	bool have_mfp = ieee80211_hw_check(&local->hw, MFP_CAPABLE);
 	int n_suites = 0, r = 0, w = 0;
 	u32 *suites;
@@ -1301,7 +1301,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
  fail_rate:
 	rtnl_unlock();
 	ieee80211_led_exit(local);
-	ieee80211_wep_free(local);
  fail_flows:
 	destroy_workqueue(local->workqueue);
  fail_workqueue:
@@ -1358,7 +1357,6 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 
 	destroy_workqueue(local->workqueue);
 	wiphy_unregister(local->hw.wiphy);
-	ieee80211_wep_free(local);
 	ieee80211_led_exit(local);
 	kfree(local->int_scan_req);
 }
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b7a9fe3d5fcb..048a07b101b4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/fips.h>
 #include <linux/if_ether.h>
 #include <linux/skbuff.h>
 #include <linux/if_arp.h>
@@ -5038,7 +5039,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 		auth_alg = WLAN_AUTH_OPEN;
 		break;
 	case NL80211_AUTHTYPE_SHARED_KEY:
-		if (IS_ERR(local->wep_tx_tfm))
+		if (fips_enabled)
 			return -EOPNOTSUPP;
 		auth_alg = WLAN_AUTH_SHARED_KEY;
 		break;
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index b3622823bad2..96b87fc7122e 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -222,7 +222,7 @@ EXPORT_SYMBOL(ieee80211_get_tkip_p2k);
  * @payload_len is the length of payload (_not_ including IV/ICV length).
  * @ta is the transmitter addresses.
  */
-int ieee80211_tkip_encrypt_data(struct crypto_cipher *tfm,
+int ieee80211_tkip_encrypt_data(struct arc4_ctx *ctx,
 				struct ieee80211_key *key,
 				struct sk_buff *skb,
 				u8 *payload, size_t payload_len)
@@ -231,7 +231,7 @@ int ieee80211_tkip_encrypt_data(struct crypto_cipher *tfm,
 
 	ieee80211_get_tkip_p2k(&key->conf, skb, rc4key);
 
-	return ieee80211_wep_encrypt_data(tfm, rc4key, 16,
+	return ieee80211_wep_encrypt_data(ctx, rc4key, 16,
 					  payload, payload_len);
 }
 
@@ -239,7 +239,7 @@ int ieee80211_tkip_encrypt_data(struct crypto_cipher *tfm,
  * beginning of the buffer containing IEEE 802.11 header payload, i.e.,
  * including IV, Ext. IV, real data, Michael MIC, ICV. @payload_len is the
  * length of payload, including IV, Ext. IV, MIC, ICV.  */
-int ieee80211_tkip_decrypt_data(struct crypto_cipher *tfm,
+int ieee80211_tkip_decrypt_data(struct arc4_ctx *ctx,
 				struct ieee80211_key *key,
 				u8 *payload, size_t payload_len, u8 *ta,
 				u8 *ra, int only_iv, int queue,
@@ -297,7 +297,7 @@ int ieee80211_tkip_decrypt_data(struct crypto_cipher *tfm,
 
 	tkip_mixing_phase2(tk, &rx_ctx->ctx, iv16, rc4key);
 
-	res = ieee80211_wep_decrypt_data(tfm, rc4key, 16, pos, payload_len - 12);
+	res = ieee80211_wep_decrypt_data(ctx, rc4key, 16, pos, payload_len - 12);
  done:
 	if (res == TKIP_DECRYPT_OK) {
 		/*
diff --git a/net/mac80211/tkip.h b/net/mac80211/tkip.h
index a1bcbfbefe7c..798583056201 100644
--- a/net/mac80211/tkip.h
+++ b/net/mac80211/tkip.h
@@ -13,7 +13,7 @@
 #include <linux/crypto.h>
 #include "key.h"
 
-int ieee80211_tkip_encrypt_data(struct crypto_cipher *tfm,
+int ieee80211_tkip_encrypt_data(struct arc4_ctx *ctx,
 				struct ieee80211_key *key,
 				struct sk_buff *skb,
 				u8 *payload, size_t payload_len);
@@ -24,7 +24,7 @@ enum {
 	TKIP_DECRYPT_INVALID_KEYIDX = -2,
 	TKIP_DECRYPT_REPLAY = -3,
 };
-int ieee80211_tkip_decrypt_data(struct crypto_cipher *tfm,
+int ieee80211_tkip_decrypt_data(struct arc4_ctx *ctx,
 				struct ieee80211_key *key,
 				u8 *payload, size_t payload_len, u8 *ta,
 				u8 *ra, int only_iv, int queue,
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index bfe9ed9f4c48..9f5673736967 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -30,30 +30,9 @@ int ieee80211_wep_init(struct ieee80211_local *local)
 	/* start WEP IV from a random value */
 	get_random_bytes(&local->wep_iv, IEEE80211_WEP_IV_LEN);
 
-	local->wep_tx_tfm = crypto_alloc_cipher("arc4", 0, 0);
-	if (IS_ERR(local->wep_tx_tfm)) {
-		local->wep_rx_tfm = ERR_PTR(-EINVAL);
-		return PTR_ERR(local->wep_tx_tfm);
-	}
-
-	local->wep_rx_tfm = crypto_alloc_cipher("arc4", 0, 0);
-	if (IS_ERR(local->wep_rx_tfm)) {
-		crypto_free_cipher(local->wep_tx_tfm);
-		local->wep_tx_tfm = ERR_PTR(-EINVAL);
-		return PTR_ERR(local->wep_rx_tfm);
-	}
-
 	return 0;
 }
 
-void ieee80211_wep_free(struct ieee80211_local *local)
-{
-	if (!IS_ERR(local->wep_tx_tfm))
-		crypto_free_cipher(local->wep_tx_tfm);
-	if (!IS_ERR(local->wep_rx_tfm))
-		crypto_free_cipher(local->wep_rx_tfm);
-}
-
 static inline bool ieee80211_wep_weak_iv(u32 iv, int keylen)
 {
 	/*
@@ -131,21 +110,17 @@ static void ieee80211_wep_remove_iv(struct ieee80211_local *local,
 /* Perform WEP encryption using given key. data buffer must have tailroom
  * for 4-byte ICV. data_len must not include this ICV. Note: this function
  * does _not_ add IV. data = RC4(data | CRC32(data)) */
-int ieee80211_wep_encrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
+int ieee80211_wep_encrypt_data(struct arc4_ctx *ctx, u8 *rc4key,
 			       size_t klen, u8 *data, size_t data_len)
 {
 	__le32 icv;
-	int i;
-
-	if (IS_ERR(tfm))
-		return -1;
 
 	icv = cpu_to_le32(~crc32_le(~0, data, data_len));
 	put_unaligned(icv, (__le32 *)(data + data_len));
 
-	crypto_cipher_setkey(tfm, rc4key, klen);
-	for (i = 0; i < data_len + IEEE80211_WEP_ICV_LEN; i++)
-		crypto_cipher_encrypt_one(tfm, data + i, data + i);
+	arc4_setkey(ctx, rc4key, klen);
+	arc4_crypt(ctx, data, data, data_len + IEEE80211_WEP_ICV_LEN);
+	memzero_explicit(ctx, sizeof(*ctx));
 
 	return 0;
 }
@@ -184,7 +159,7 @@ int ieee80211_wep_encrypt(struct ieee80211_local *local,
 	/* Add room for ICV */
 	skb_put(skb, IEEE80211_WEP_ICV_LEN);
 
-	return ieee80211_wep_encrypt_data(local->wep_tx_tfm, rc4key, keylen + 3,
+	return ieee80211_wep_encrypt_data(&local->wep_tx_ctx, rc4key, keylen + 3,
 					  iv + IEEE80211_WEP_IV_LEN, len);
 }
 
@@ -192,18 +167,14 @@ int ieee80211_wep_encrypt(struct ieee80211_local *local,
 /* Perform WEP decryption using given key. data buffer includes encrypted
  * payload, including 4-byte ICV, but _not_ IV. data_len must not include ICV.
  * Return 0 on success and -1 on ICV mismatch. */
-int ieee80211_wep_decrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
+int ieee80211_wep_decrypt_data(struct arc4_ctx *ctx, u8 *rc4key,
 			       size_t klen, u8 *data, size_t data_len)
 {
 	__le32 crc;
-	int i;
-
-	if (IS_ERR(tfm))
-		return -1;
 
-	crypto_cipher_setkey(tfm, rc4key, klen);
-	for (i = 0; i < data_len + IEEE80211_WEP_ICV_LEN; i++)
-		crypto_cipher_decrypt_one(tfm, data + i, data + i);
+	arc4_setkey(ctx, rc4key, klen);
+	arc4_crypt(ctx, data, data, data_len + IEEE80211_WEP_ICV_LEN);
+	memzero_explicit(ctx, sizeof(*ctx));
 
 	crc = cpu_to_le32(~crc32_le(~0, data, data_len));
 	if (memcmp(&crc, data + data_len, IEEE80211_WEP_ICV_LEN) != 0)
@@ -256,7 +227,7 @@ static int ieee80211_wep_decrypt(struct ieee80211_local *local,
 	/* Copy rest of the WEP key (the secret part) */
 	memcpy(rc4key + 3, key->conf.key, key->conf.keylen);
 
-	if (ieee80211_wep_decrypt_data(local->wep_rx_tfm, rc4key, klen,
+	if (ieee80211_wep_decrypt_data(&local->wep_rx_ctx, rc4key, klen,
 				       skb->data + hdrlen +
 				       IEEE80211_WEP_IV_LEN, len))
 		ret = -1;
diff --git a/net/mac80211/wep.h b/net/mac80211/wep.h
index 9615749d1f65..3644f4a5bb87 100644
--- a/net/mac80211/wep.h
+++ b/net/mac80211/wep.h
@@ -17,13 +17,12 @@
 #include "key.h"
 
 int ieee80211_wep_init(struct ieee80211_local *local);
-void ieee80211_wep_free(struct ieee80211_local *local);
-int ieee80211_wep_encrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
+int ieee80211_wep_encrypt_data(struct arc4_ctx *ctx, u8 *rc4key,
 				size_t klen, u8 *data, size_t data_len);
 int ieee80211_wep_encrypt(struct ieee80211_local *local,
 			  struct sk_buff *skb,
 			  const u8 *key, int keylen, int keyidx);
-int ieee80211_wep_decrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
+int ieee80211_wep_decrypt_data(struct arc4_ctx *ctx, u8 *rc4key,
 			       size_t klen, u8 *data, size_t data_len);
 
 ieee80211_rx_result
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 58d0b258b684..02e8ab7b2b4c 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -242,7 +242,7 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	/* Add room for ICV */
 	skb_put(skb, IEEE80211_TKIP_ICV_LEN);
 
-	return ieee80211_tkip_encrypt_data(tx->local->wep_tx_tfm,
+	return ieee80211_tkip_encrypt_data(&tx->local->wep_tx_ctx,
 					   key, skb, pos, len);
 }
 
@@ -293,7 +293,7 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 	if (status->flag & RX_FLAG_DECRYPTED)
 		hwaccel = 1;
 
-	res = ieee80211_tkip_decrypt_data(rx->local->wep_rx_tfm,
+	res = ieee80211_tkip_decrypt_data(&rx->local->wep_rx_ctx,
 					  key, skb->data + hdrlen,
 					  skb->len - hdrlen, rx->sta->sta.addr,
 					  hdr->addr1, hwaccel, rx->security_idx,
-- 
2.20.1

