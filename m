Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58470C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 16:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 245712082C
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 16:20:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ros1mHbH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730289AbfFLQUM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 12:20:12 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33342 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730820AbfFLQUM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 12:20:12 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so17630293wru.0
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 09:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MmcuGVcj7qdaEHQ7V9/r8J8Ae7Jh8V+6rn5yAhUKefg=;
        b=Ros1mHbHJVGLo7nVmcNl+k9y/xp2TDmFLtnM0eRHKibDkR/OrP023lM9Ijelc3Rqdg
         todeh4aVoN+ZsNbTuS/g0uFqMlqQj0bP/aV4kmCxePn/ZbmbaeWYYFSGNQI/aLHqXhDE
         vQXSDv9mHG+FUQx0EHdJv6RAP0snbilRGvhbUwsnijzmLOcF2jdQaikmcjhUfdLlyf9i
         lHUohsAlxOloQ6i7n8UgrtK/xgWV7wk4xtrxtDv5V6qDQvfcW0pwJpLcYbSnhZNZ2/65
         wkKRst/CCohhvgF9gNn3+gZTwooMuP7W2EdbpyJgD8aaWm6xq1aVwyhsStPQy99GJ1bl
         w2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MmcuGVcj7qdaEHQ7V9/r8J8Ae7Jh8V+6rn5yAhUKefg=;
        b=iaQ/qcZiJ3t9BBO7Uv3GHkHDcKAAl9mGJtYPyPoDhvtASlSHrLe27ASAIdYOtwUT04
         Femu6eNjNY0Qnw1iXfwP6EJpYPmzrEPMpMCSadc3Q+cb78R+qJLOOTg/5/YuN2c6AN9e
         F9aigzieXe9M9L0tO+12yPtSM62MRflcEQZEL3rGHF3+B/XirfBiOuRIie7zGIrsC9+V
         vhs4YCGAyOm+QzKZ5gpOcOMeECN7M4z3hCs0X4iMcnEnX9qmY5k0R8HKzT3wRsHt+FyX
         dM+VHI7lrEwV7AiwUXM1kDVvZFNzRKxVJu0xe1AcxwGnL/OF289XSZLFNxMTjgR1lSBR
         8hSg==
X-Gm-Message-State: APjAAAWyCXizh69X2qggrncDODUh/7Hd63KrhniAz4ix5OjcoVVqPdD3
        ZbLEStkbwp7KYwzf96aP9+0aIgC8NOaWww==
X-Google-Smtp-Source: APXvYqxdwVrV3GOIzWvGrXiUoYsSEPuw7lN9hZJSAdIjliU1pGz0yGZtiy2HTsRfm5wmfAorvMmLxg==
X-Received: by 2002:a5d:4c8c:: with SMTP id z12mr8924471wrs.192.1560356410073;
        Wed, 12 Jun 2019 09:20:10 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id c16sm70172wrr.53.2019.06.12.09.20.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 09:20:09 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v5 4/7] net/lib80211: move TKIP handling to ARC4 library code
Date:   Wed, 12 Jun 2019 18:19:56 +0200
Message-Id: <20190612161959.30478-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612161959.30478-1-ard.biesheuvel@linaro.org>
References: <20190612161959.30478-1-ard.biesheuvel@linaro.org>
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
 net/wireless/Kconfig               |  1 +
 net/wireless/lib80211_crypt_tkip.c | 48 +++++++-------------
 2 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 6d9c48cea07e..578cce4fbe6c 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -220,6 +220,7 @@ config LIB80211_CRYPT_CCMP
 
 config LIB80211_CRYPT_TKIP
 	tristate
+	select CRYPTO_LIB_ARC4
 
 config LIB80211_DEBUG
 	bool "lib80211 debugging messages"
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

