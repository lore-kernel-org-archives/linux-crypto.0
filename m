Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A164FC31E45
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 23:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AE8720872
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 23:09:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IAYd2yE7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407947AbfFKXJw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 19:09:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43086 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404669AbfFKXJv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 19:09:51 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so4697008wru.10
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jun 2019 16:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m6lrx96N+/HTU2cRYNepLqRT1HXoGD2ZJBZ5Rjzicn4=;
        b=IAYd2yE7uLIkXSx1AbP0/RxZdmrVhO3G70eJypgZyLFMr4mDN+owMR/Ub8fYn+2N7B
         DwiLaJ1lfDs1UxPtxIaRnPz0fAiTZfJHbGN/oxr3Y102QQf408l0ArIN/oHTcLKrS72i
         2Nl56OMEyL77bQBo3++xDTWh5LvDU6AmgQofxeKJeDZ+MYlYZ9kxaPbv01zgJFsAP8Gl
         Yqz5taSjXzoXs0oL1HcJY2XU/1hdyQLUPtRBTnfX+4gUTBaNV5th+hvxVPkoeGv6hnn7
         AH42QuDzt0MDP139cU38akAY1Z+mZcuvwm7xRvB7YZVW8ueAKJl7dkXkuVSP1euA1qmD
         gJdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m6lrx96N+/HTU2cRYNepLqRT1HXoGD2ZJBZ5Rjzicn4=;
        b=sJWPK0JsTWlBJw5qZVbh/+p2RiX03RIvjDeq7/4HS1BoN3y/HGXY4OWIJ2qIWY5+dP
         IwQgq+Wt3lm+BLQ5Sxt/LGU9Uabv0SrJ8M9bUWxzwSNTeE70lLz9idWFIwcvBbfvma1F
         4sAp8s7YC3yL0G0cMNNveiqjkJ25++H6Lkywf3jN9tJz6VlCxGvy6Gdi1USqccQ2i0oU
         MnQWP9JYlZMQpgz3pY4I6QFYLPG86g0E1m8z5UgvBxUWShCc0QmbDau3zM28wXOq2Y2X
         56xezUwjGcUj/2S7SJT30EVnABc5R9T6YH39l7a8eNvWdHEy7sJ388CkhDKkFYhp6eue
         NahQ==
X-Gm-Message-State: APjAAAXBeq40c45Bvl7IfIfHE6Y3IyGvp9CaqY1vJvvo+ja8mHZ5iaUf
        yqP/ZzmFZGcrbtAuJ692fkHlJOpFDQmhdx/W
X-Google-Smtp-Source: APXvYqxaj9JzxXHCZf2WK4ZiFqe21Q/j/iEyKh1FPLS8PvcZZRT16BgyRK8IIrHTLlJXtqhp9s9d3w==
X-Received: by 2002:a05:6000:181:: with SMTP id p1mr28182832wrx.247.1560294588640;
        Tue, 11 Jun 2019 16:09:48 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:24bb:7f31:25fe:43a7])
        by smtp.gmail.com with ESMTPSA id g11sm10827813wrq.89.2019.06.11.16.09.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 16:09:47 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v4 4/7] net/lib80211: move TKIP handling to ARC4 library code
Date:   Wed, 12 Jun 2019 01:09:35 +0200
Message-Id: <20190611230938.19265-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611230938.19265-1-ard.biesheuvel@linaro.org>
References: <20190611230938.19265-1-ard.biesheuvel@linaro.org>
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
 net/wireless/lib80211_crypt_tkip.c | 48 +++++++-------------
 1 file changed, 17 insertions(+), 31 deletions(-)

diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index 11eaa5956f00..0fd155c4e0a6 100644
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
 
@@ -142,11 +133,9 @@ static void lib80211_tkip_deinit(void *priv)
 	struct lib80211_tkip_data *_priv = priv;
 	if (_priv) {
 		crypto_free_shash(_priv->tx_tfm_michael);
-		crypto_free_cipher(_priv->tx_tfm_arc4);
 		crypto_free_shash(_priv->rx_tfm_michael);
-		crypto_free_cipher(_priv->rx_tfm_arc4);
 	}
-	kfree(priv);
+	kzfree(priv);
 }
 
 static inline u16 RotR1(u16 val)
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

