Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D2D7C31E44
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 23:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6BCC20872
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 23:09:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ego+R3yL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407946AbfFKXJw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 19:09:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44379 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407944AbfFKXJt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 19:09:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id b17so14781735wrq.11
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jun 2019 16:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OwqgljQ1B81ow4cCya6JJaWKyb9eZkcUJZbKrShyt74=;
        b=ego+R3yLJjqYVtyUtNrsfCkWcown+rLk6UiEMaUUHboV16q9o9u6eUIx0pPbTGUl78
         s6l9Eu2dLFAUXEJSrIG7rQ61m8dSJTtKMZpGXd9Lgq2sYQ2Hxv0PYjiVM6KiIVw3ZZN9
         ID6Vfmj69tmcxnAFhIfTX+OPddLrTow8v5bwRUSP/5Cqn3IW6ovVvxbtFdoYxzWBP4cH
         yG/1DomuX7SwXvJfGcoN5JZMLi0Y724gkGMCMmvwc6QfJCeClju1uT5MKaO0fU4u9RPS
         iN2Jd/S/SyT8tgfJtjpnSt4nG99xaUsy3Jodom3iaoq0SzmQlFYjCf/drbf+HQLfQMVz
         h4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OwqgljQ1B81ow4cCya6JJaWKyb9eZkcUJZbKrShyt74=;
        b=W7LiGRXOY/aU+KpkJNiMur3YOrLW7BHV3tvpAeTYfonAX8rBluwC0kBfd+zUn+kHa/
         D6dAU54g+TdTwNYvvHO9IkbzSc9pIj9sil6RhcsmpADejEFAsK59zLAKxTE1RR647Snl
         +G4lWYWBiulCfbqJ9ZjQa1Yqam7HccZ4cp7tS0GF8+Ab3dW4R4cnwrT3j989FT1J/p4H
         0nQSlu3zC/NB+A1u9gnIpeKsDsLLVlsFNZvk3C2J6gu60sk8balGB8r4qLRji0hgo6gf
         43TJl1PLDCEh0Rk/5ooRzRV3G1D2m/BjneUybZpucyjryRwKc98JsvdrLPZfFIC+ikkn
         Zkgw==
X-Gm-Message-State: APjAAAWPEkP/wDdFTuvVCUFwbdG2jflbe5m1XfTp44Whmub6eaYkZshi
        OStLcyQtP25fFHT0D8z/2WHWAUsxwDauxmco
X-Google-Smtp-Source: APXvYqwe0qh5KCdEObXGrwrG8XcYiFPBSNgBk9/cJ1qN2P+HkqhsOumLiyz4IItU+OrOlbkJcRGUKA==
X-Received: by 2002:a05:6000:1c9:: with SMTP id t9mr26667190wrx.187.1560294587363;
        Tue, 11 Jun 2019 16:09:47 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:24bb:7f31:25fe:43a7])
        by smtp.gmail.com with ESMTPSA id g11sm10827813wrq.89.2019.06.11.16.09.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 16:09:46 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v4 3/7] net/lib80211: move WEP handling to ARC4 library code
Date:   Wed, 12 Jun 2019 01:09:34 +0200
Message-Id: <20190611230938.19265-4-ard.biesheuvel@linaro.org>
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
 net/wireless/Kconfig              |  1 +
 net/wireless/lib80211_crypt_wep.c | 51 +++++---------------
 2 files changed, 14 insertions(+), 38 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 6310ddede220..6d9c48cea07e 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -213,6 +213,7 @@ config LIB80211
 
 config LIB80211_CRYPT_WEP
 	tristate
+	select CRYPTO_LIB_ARC4
 
 config LIB80211_CRYPT_CCMP
 	tristate
diff --git a/net/wireless/lib80211_crypt_wep.c b/net/wireless/lib80211_crypt_wep.c
index 20c1ad63ad44..04e4d66ea19d 100644
--- a/net/wireless/lib80211_crypt_wep.c
+++ b/net/wireless/lib80211_crypt_wep.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/fips.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -22,7 +23,7 @@
 
 #include <net/lib80211.h>
 
-#include <linux/crypto.h>
+#include <crypto/arc4.h>
 #include <linux/crc32.h>
 
 MODULE_AUTHOR("Jouni Malinen");
@@ -35,52 +36,31 @@ struct lib80211_wep_data {
 	u8 key[WEP_KEY_LEN + 1];
 	u8 key_len;
 	u8 key_idx;
-	struct crypto_cipher *tx_tfm;
-	struct crypto_cipher *rx_tfm;
+	struct arc4_ctx tx_ctx;
+	struct arc4_ctx rx_ctx;
 };
 
 static void *lib80211_wep_init(int keyidx)
 {
 	struct lib80211_wep_data *priv;
 
+	if (fips_enabled)
+		return NULL;
+
 	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
-		goto fail;
+		return NULL;
 	priv->key_idx = keyidx;
 
-	priv->tx_tfm = crypto_alloc_cipher("arc4", 0, 0);
-	if (IS_ERR(priv->tx_tfm)) {
-		priv->tx_tfm = NULL;
-		goto fail;
-	}
-
-	priv->rx_tfm = crypto_alloc_cipher("arc4", 0, 0);
-	if (IS_ERR(priv->rx_tfm)) {
-		priv->rx_tfm = NULL;
-		goto fail;
-	}
 	/* start WEP IV from a random value */
 	get_random_bytes(&priv->iv, 4);
 
 	return priv;
-
-      fail:
-	if (priv) {
-		crypto_free_cipher(priv->tx_tfm);
-		crypto_free_cipher(priv->rx_tfm);
-		kfree(priv);
-	}
-	return NULL;
 }
 
 static void lib80211_wep_deinit(void *priv)
 {
-	struct lib80211_wep_data *_priv = priv;
-	if (_priv) {
-		crypto_free_cipher(_priv->tx_tfm);
-		crypto_free_cipher(_priv->rx_tfm);
-	}
-	kfree(priv);
+	kzfree(priv);
 }
 
 /* Add WEP IV/key info to a frame that has at least 4 bytes of headroom */
@@ -132,7 +112,6 @@ static int lib80211_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	u32 crc, klen, len;
 	u8 *pos, *icv;
 	u8 key[WEP_KEY_LEN + 3];
-	int i;
 
 	/* other checks are in lib80211_wep_build_iv */
 	if (skb_tailroom(skb) < 4)
@@ -160,10 +139,8 @@ static int lib80211_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	icv[2] = crc >> 16;
 	icv[3] = crc >> 24;
 
-	crypto_cipher_setkey(wep->tx_tfm, key, klen);
-
-	for (i = 0; i < len + 4; i++)
-		crypto_cipher_encrypt_one(wep->tx_tfm, pos + i, pos + i);
+	arc4_setkey(&wep->tx_ctx, key, klen);
+	arc4_crypt(&wep->tx_ctx, pos, pos, len + 4);
 
 	return 0;
 }
@@ -181,7 +158,6 @@ static int lib80211_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	u32 crc, klen, plen;
 	u8 key[WEP_KEY_LEN + 3];
 	u8 keyidx, *pos, icv[4];
-	int i;
 
 	if (skb->len < hdr_len + 8)
 		return -1;
@@ -202,9 +178,8 @@ static int lib80211_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	/* Apply RC4 to data and compute CRC32 over decrypted data */
 	plen = skb->len - hdr_len - 8;
 
-	crypto_cipher_setkey(wep->rx_tfm, key, klen);
-	for (i = 0; i < plen + 4; i++)
-		crypto_cipher_decrypt_one(wep->rx_tfm, pos + i, pos + i);
+	arc4_setkey(&wep->rx_ctx, key, klen);
+	arc4_crypt(&wep->rx_ctx, pos, pos, plen + 4);
 
 	crc = ~crc32_le(~0, pos, plen);
 	icv[0] = crc;
-- 
2.20.1

