Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0ADC43218
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 13:48:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 443D720896
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 13:48:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TutfpOMq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389926AbfFKNsC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 09:48:02 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37942 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388299AbfFKNsC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 09:48:02 -0400
Received: by mail-wm1-f68.google.com with SMTP id s15so3019008wmj.3
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jun 2019 06:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h11UGXC77nWA4rTdnJxsAlZsGimBDhlsPa3AUVrAjDI=;
        b=TutfpOMqEcfZAruOCoYI7FuGfW4rYqI6J+pl7gHaBBYpWaIOrvnhWoXJ0PARHidzBJ
         gePL9pqS3HqSyXJzT41TEkJMcl5Z4eG590tGJm5YiffIEVMFqrV7Gixpws2S7z6Q/v/S
         jCnhF4h2pF/nALBno5smDMdMrmCpHd+4cON//PfonPyOS4j9MTJXthQxCsVP0c5iIRh7
         XHOpi3wKGRJh29yKIWeU0cl9euo9eMt0P4+E+4XWcd1zpoUNOzaNPTYVxG7jcdb3g61A
         c+LtcIElc2u+RRm/QO2PViM5/FiJdsJ+rvylyHU24Yk2nW+TiMSClauS/b2/l1M9jKYS
         agUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h11UGXC77nWA4rTdnJxsAlZsGimBDhlsPa3AUVrAjDI=;
        b=iDNnkLTMh9K/andgemDTJvt+h0RgbK9o27FJOGKNGqnl3keZp3t39mluMXd4KdKxKW
         eDgXA1WYsbNYrLomd8DBDt9gu6ygI7FES/11Qqku8Miyzvt5OW6GrGojGb8/i/ey3TXl
         /UFiISRiAJExfqtPxYwtVQK5BrZ3adFzth/mwMeNsL7Bjv6OFLhzRCcZmrXohiL01j1i
         YpmkAY5H3sdt7N8Dg2m0uaam7Ba5yavorF+o95PY8OKAotJAwRxNtexNsG7BXNap0W3s
         cqSzEsvPrgVF7pUJx7LGD9Oix28qgxuyqG/nGdPjipzGo2iwanVJf3d49NdvPcM8XWnp
         b0kg==
X-Gm-Message-State: APjAAAUzIBFS2m9AGo8ii9mRaFN3ANfUwfUQn1BEoTIxrwuzHMvnBHFo
        bIPPJpsM0Uz4ulsAS2vMcSejtIR71kt4d6DU
X-Google-Smtp-Source: APXvYqyc69FjcYXQG6bodHA7dLaVaQryvKlHFV8haoR2MVgUWtp2lH7uG3jb04sue+YNm4YLEsibwA==
X-Received: by 2002:a05:600c:2507:: with SMTP id d7mr17396893wma.2.1560260879383;
        Tue, 11 Jun 2019 06:47:59 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:24bb:7f31:25fe:43a7])
        by smtp.gmail.com with ESMTPSA id o126sm3964305wmo.31.2019.06.11.06.47.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 06:47:58 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v3 4/7] net/lib80211: move TKIP handling to ARC4 library code
Date:   Tue, 11 Jun 2019 15:47:47 +0200
Message-Id: <20190611134750.2974-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611134750.2974-1-ard.biesheuvel@linaro.org>
References: <20190611134750.2974-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The crypto API abstraction is not very useful for invoking ciphers
directly, especially in the case of arc4, which only has a generic
implementation in C. So let's invoke the library code directly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 net/wireless/lib80211_crypt_tkip.c | 46 +++++++-------------
 1 file changed, 16 insertions(+), 30 deletions(-)

diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index 11eaa5956f00..02841825bf73 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -13,6 +13,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/err.h>
+#include <linux/fips.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -29,6 +30,7 @@
 #include <linux/ieee80211.h>
 #include <net/iw_handler.h>
 
+#include <crypto/arc4.h>
 #include <crypto/hash.h>
 #include <linux/crypto.h>
 #include <linux/crc32.h>
@@ -64,9 +66,9 @@ struct lib80211_tkip_data {
 
 	int key_idx;
 
-	struct crypto_cipher *rx_tfm_arc4;
+	struct arc4_ctx rx_ctx_arc4;
+	struct arc4_ctx tx_ctx_arc4;
 	struct crypto_shash *rx_tfm_michael;
-	struct crypto_cipher *tx_tfm_arc4;
 	struct crypto_shash *tx_tfm_michael;
 
 	/* scratch buffers for virt_to_page() (crypto API) */
@@ -93,30 +95,21 @@ static void *lib80211_tkip_init(int key_idx)
 {
 	struct lib80211_tkip_data *priv;
 
+	if (fips_enabled)
+		return NULL;
+
 	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
 		goto fail;
 
 	priv->key_idx = key_idx;
 
-	priv->tx_tfm_arc4 = crypto_alloc_cipher("arc4", 0, 0);
-	if (IS_ERR(priv->tx_tfm_arc4)) {
-		priv->tx_tfm_arc4 = NULL;
-		goto fail;
-	}
-
 	priv->tx_tfm_michael = crypto_alloc_shash("michael_mic", 0, 0);
 	if (IS_ERR(priv->tx_tfm_michael)) {
 		priv->tx_tfm_michael = NULL;
 		goto fail;
 	}
 
-	priv->rx_tfm_arc4 = crypto_alloc_cipher("arc4", 0, 0);
-	if (IS_ERR(priv->rx_tfm_arc4)) {
-		priv->rx_tfm_arc4 = NULL;
-		goto fail;
-	}
-
 	priv->rx_tfm_michael = crypto_alloc_shash("michael_mic", 0, 0);
 	if (IS_ERR(priv->rx_tfm_michael)) {
 		priv->rx_tfm_michael = NULL;
@@ -128,9 +121,7 @@ static void *lib80211_tkip_init(int key_idx)
       fail:
 	if (priv) {
 		crypto_free_shash(priv->tx_tfm_michael);
-		crypto_free_cipher(priv->tx_tfm_arc4);
 		crypto_free_shash(priv->rx_tfm_michael);
-		crypto_free_cipher(priv->rx_tfm_arc4);
 		kfree(priv);
 	}
 
@@ -142,9 +133,7 @@ static void lib80211_tkip_deinit(void *priv)
 	struct lib80211_tkip_data *_priv = priv;
 	if (_priv) {
 		crypto_free_shash(_priv->tx_tfm_michael);
-		crypto_free_cipher(_priv->tx_tfm_arc4);
 		crypto_free_shash(_priv->rx_tfm_michael);
-		crypto_free_cipher(_priv->rx_tfm_arc4);
 	}
 	kfree(priv);
 }
@@ -345,7 +334,6 @@ static int lib80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	int len;
 	u8 rc4key[16], *pos, *icv;
 	u32 crc;
-	int i;
 
 	if (tkey->flags & IEEE80211_CRYPTO_TKIP_COUNTERMEASURES) {
 		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -370,9 +358,9 @@ static int lib80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	icv[2] = crc >> 16;
 	icv[3] = crc >> 24;
 
-	crypto_cipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
-	for (i = 0; i < len + 4; i++)
-		crypto_cipher_encrypt_one(tkey->tx_tfm_arc4, pos + i, pos + i);
+	arc4_setkey(&tkey->tx_ctx_arc4, rc4key, 16);
+	arc4_crypt(&tkey->tx_ctx_arc4, pos, pos, len + 4);
+
 	return 0;
 }
 
@@ -400,7 +388,6 @@ static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	u8 icv[4];
 	u32 crc;
 	int plen;
-	int i;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 
@@ -453,9 +440,8 @@ static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 	plen = skb->len - hdr_len - 12;
 
-	crypto_cipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
-	for (i = 0; i < plen + 4; i++)
-		crypto_cipher_decrypt_one(tkey->rx_tfm_arc4, pos + i, pos + i);
+	arc4_setkey(&tkey->rx_ctx_arc4, rc4key, 16);
+	arc4_crypt(&tkey->rx_ctx_arc4, pos, pos, plen + 4);
 
 	crc = ~crc32_le(~0, pos, plen);
 	icv[0] = crc;
@@ -640,17 +626,17 @@ static int lib80211_tkip_set_key(void *key, int len, u8 * seq, void *priv)
 	struct lib80211_tkip_data *tkey = priv;
 	int keyidx;
 	struct crypto_shash *tfm = tkey->tx_tfm_michael;
-	struct crypto_cipher *tfm2 = tkey->tx_tfm_arc4;
+	struct arc4_ctx *tfm2 = &tkey->tx_ctx_arc4;
 	struct crypto_shash *tfm3 = tkey->rx_tfm_michael;
-	struct crypto_cipher *tfm4 = tkey->rx_tfm_arc4;
+	struct arc4_ctx *tfm4 = &tkey->rx_ctx_arc4;
 
 	keyidx = tkey->key_idx;
 	memset(tkey, 0, sizeof(*tkey));
 	tkey->key_idx = keyidx;
 	tkey->tx_tfm_michael = tfm;
-	tkey->tx_tfm_arc4 = tfm2;
+	tkey->tx_ctx_arc4 = *tfm2;
 	tkey->rx_tfm_michael = tfm3;
-	tkey->rx_tfm_arc4 = tfm4;
+	tkey->rx_ctx_arc4 = *tfm4;
 	if (len == TKIP_KEY_LEN) {
 		memcpy(tkey->key, key, TKIP_KEY_LEN);
 		tkey->key_set = 1;
-- 
2.20.1

