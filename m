Return-Path: <SRS0=Xb3v=UI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0AADC28EBD
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Jun 2019 11:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99CCF20673
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Jun 2019 11:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DuzTQmf5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbfFILzW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 9 Jun 2019 07:55:22 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37654 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbfFILzS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Jun 2019 07:55:18 -0400
Received: by mail-wr1-f66.google.com with SMTP id v14so6370309wrr.4
        for <linux-crypto@vger.kernel.org>; Sun, 09 Jun 2019 04:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RrqId75ysoE9z88I4uq9u9pu8GvMT3RxAtvppEowQeg=;
        b=DuzTQmf5LsIklRp0smJvKrXxUAxdk1/eUn7byiT81TlJonmNvpjxt1TT/VYq+xolR8
         cKTRTPbnSOjqcpHQUnzzZB/x++8yJdQggr3jLB7Y3uSsO0rwp5Q3695RUDIBROeFnkVd
         OC8m/+DJ47E5MM9xv3/iCuunztKvIn94OfKvgSsU5VpVrumY3U6ir30opJeY72/TpSOG
         4Im/uietlHmLeGPkX7fnhUXw5dh5WCsGWNzhzx8w0EYF3mqCBQzfqf826U66IxUrKxfy
         QbS1a5l29kPuy1u2VKGIYpYDjFy+nhqT8+uvOez3NkNjI6AOTULVhSr+Hk8b2c9d/h+2
         OBYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RrqId75ysoE9z88I4uq9u9pu8GvMT3RxAtvppEowQeg=;
        b=pPh2qvdeghzFGzplf9OPYROdQWNUZVkPXNsDAObZHQ5Wj/ClgxapRCouMbLHwXLXqr
         MRUTpDr2iIA8TOpK7g8+/jJCFnO7zM574BzKno3094JYxej8im4ueexveBoWwVnhNtcA
         HwyYs1Ha22uPNSd5fHhXtK5KL5l+ZQGHcSyDHO3HPqH0PacENebzplrcDF2TW8CqU5C6
         nviyneZJUE+f6zOuTV2yAEfoa15nPhpfCxIciCfzVdZS4lUfLkJC6bmrcC4TT/8BnuYp
         r5EPcQo9A71pXgDtxbXF70IZ6hivruapjYTVgAqn06lMdCHn3gavwi8LD3t2HA9tFisl
         W/SQ==
X-Gm-Message-State: APjAAAXCdZUUrWr7OCqYpXJRQJ80tV3adoCRwcQNG+Nmmsc+tjgkS/8/
        CXbv8CH3cGmo3knquds3xMzBlHeG6Jvyaw==
X-Google-Smtp-Source: APXvYqx2jJmtY4XDAq6ILYjeRnRcWHQdYWF9GOzwWuWy/vTtlmz1i6U8UP8FZ0IX6D1y70GZganrXA==
X-Received: by 2002:a5d:4f8b:: with SMTP id d11mr5519809wru.264.1560081316553;
        Sun, 09 Jun 2019 04:55:16 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:5129:23cd:5870:89d4])
        by smtp.gmail.com with ESMTPSA id r5sm14954317wrg.10.2019.06.09.04.55.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 04:55:15 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2 3/7] net/lib80211: move WEP handling to ARC4 library code
Date:   Sun,  9 Jun 2019 13:55:05 +0200
Message-Id: <20190609115509.26260-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190609115509.26260-1-ard.biesheuvel@linaro.org>
References: <20190609115509.26260-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The crypto API abstraction is not very useful for invoking ciphers
directly, especially in the case of arc4, which only has a generic
implementation in C. So let's invoke the library code directly.

Cc: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 net/wireless/Kconfig              |  1 +
 net/wireless/lib80211_crypt_wep.c | 43 ++++----------------
 2 files changed, 9 insertions(+), 35 deletions(-)

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
index 20c1ad63ad44..3db1b2e6a25a 100644
--- a/net/wireless/lib80211_crypt_wep.c
+++ b/net/wireless/lib80211_crypt_wep.c
@@ -22,7 +22,7 @@
 
 #include <net/lib80211.h>
 
-#include <linux/crypto.h>
+#include <crypto/arc4.h>
 #include <linux/crc32.h>
 
 MODULE_AUTHOR("Jouni Malinen");
@@ -35,8 +35,8 @@ struct lib80211_wep_data {
 	u8 key[WEP_KEY_LEN + 1];
 	u8 key_len;
 	u8 key_idx;
-	struct crypto_cipher *tx_tfm;
-	struct crypto_cipher *rx_tfm;
+	struct crypto_arc4_ctx tx_ctx;
+	struct crypto_arc4_ctx rx_ctx;
 };
 
 static void *lib80211_wep_init(int keyidx)
@@ -45,41 +45,17 @@ static void *lib80211_wep_init(int keyidx)
 
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
 	kfree(priv);
 }
 
@@ -160,10 +136,8 @@ static int lib80211_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	icv[2] = crc >> 16;
 	icv[3] = crc >> 24;
 
-	crypto_cipher_setkey(wep->tx_tfm, key, klen);
-
-	for (i = 0; i < len + 4; i++)
-		crypto_cipher_encrypt_one(wep->tx_tfm, pos + i, pos + i);
+	crypto_arc4_set_key(&wep->tx_ctx, key, klen);
+	crypto_arc4_crypt(&wep->tx_ctx, pos, pos, len + 4);
 
 	return 0;
 }
@@ -202,9 +176,8 @@ static int lib80211_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	/* Apply RC4 to data and compute CRC32 over decrypted data */
 	plen = skb->len - hdr_len - 8;
 
-	crypto_cipher_setkey(wep->rx_tfm, key, klen);
-	for (i = 0; i < plen + 4; i++)
-		crypto_cipher_decrypt_one(wep->rx_tfm, pos + i, pos + i);
+	crypto_arc4_set_key(&wep->rx_ctx, key, klen);
+	crypto_arc4_crypt(&wep->rx_ctx, pos, pos, plen + 4);
 
 	crc = ~crc32_le(~0, pos, plen);
 	icv[0] = crc;
-- 
2.20.1

