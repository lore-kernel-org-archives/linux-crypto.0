Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712ABE78486
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Oct 2023 20:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbjJAUOK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Oct 2023 16:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235349AbjJAUOJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Oct 2023 16:14:09 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377C0D8
        for <linux-crypto@vger.kernel.org>; Sun,  1 Oct 2023 13:14:06 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-3248aa5cf4eso3367333f8f.1
        for <linux-crypto@vger.kernel.org>; Sun, 01 Oct 2023 13:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1696191244; x=1696796044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S5gdKKBRI8HMjzMvfQFYDp6loku3qgrG9OQcfyEaG8Y=;
        b=ENJDV8FQI78y78EglS69TxeGxUl/zickH6M2Iw6RqqbDpzVNH7ywqOc5FryAzAQdfo
         ZuP6zHwaHwnf9HCfsz5CXh+tLxz8PoFvscwLEhbefPx5QVjoqX1KmXP9n66dKz6ryxYH
         tCBDYgkx/1R4SI9HKVh7zok8NHyvmXXBhttmuKc2StwabPKDrwAu4t+zMA+MnSGPHcbN
         /FDW1HCcs3EItuOQZMIUejk/TFYTXVC8XTMOe2/xCNarO96Cby/kcjhqiFRQAIUG3o/m
         aLACJyFofk8zJxiqT66akr6qKK844hmkDnJtn3RluPm/n3jIbt6JmDgtmIkfKdkxSSMo
         VLTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696191244; x=1696796044;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S5gdKKBRI8HMjzMvfQFYDp6loku3qgrG9OQcfyEaG8Y=;
        b=kYQkhB6Fokmj9+9MLU87ngYBptncWcqX/EFsLLhEQy1CMfdzNCiD1MRVrEtJ0ZyA+a
         Ne6d7HjrbZsLb5OwZlB1Q0m4vt80pH8caZpMr1YWCLjY2EHD09pWyT8UCL/AnaR6mBxb
         NV4UO/U259iWjRFTh1vkrt8YStqTIqWh0e6RhYF9Ad8X7fdAj7xttnDVGO2Hy+smuz9H
         Ma6vY62ynrvEwcG+JU5qQZLwoEkHqwgWNDCgRtZ7+UyqN1fa+OCstLJ02GHW5yTnIfPC
         3Qrix+n4hdNIvBLSk+FCb3lUxa0V+NXfxS8t49BtZFuD/BE5u8fJ7v6JJYn7CEfpQwvw
         lLVA==
X-Gm-Message-State: AOJu0Yw++jgFaawOUVV5a9BijpOcQkgYa/7VLf3bZYuN4uiUAIOaSGLD
        ulhETXyFp5FQDSO9q6qlLWlYPQ==
X-Google-Smtp-Source: AGHT+IF8bQPLl/XkMjCK1GATpgLR3obNH1Yh0AnESH4KmxjbQ0tap497/YPYQvdhCNXwcL8NlYsgvQ==
X-Received: by 2002:a5d:63cb:0:b0:319:6e3f:d5f0 with SMTP id c11-20020a5d63cb000000b003196e3fd5f0mr9162433wrw.44.1696191244674;
        Sun, 01 Oct 2023 13:14:04 -0700 (PDT)
Received: from arnold.baylibre (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j6-20020a5d6046000000b003259b068ba6sm6141665wrt.7.2023.10.01.13.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Oct 2023 13:14:03 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     andrew@aj.id.au, davem@davemloft.net, herbert@gondor.apana.org.au,
        joel@jms.id.au, john.allen@amd.com, neal_liu@aspeedtech.com,
        thomas.lendacky@amd.com
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] crypto: Move akcipher_request_cast helper to crypto header
Date:   Sun,  1 Oct 2023 20:13:57 +0000
Message-Id: <20231001201357.2052949-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is already 2 driver implementing their own akcipher_request_cast.
In the future there will be also rockchip and allwinner driver that will
need this.
This is sufficient to move it in crypto headers.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/aspeed/aspeed-acry.c | 6 ------
 drivers/crypto/ccp/ccp-crypto-rsa.c | 6 ------
 include/crypto/akcipher.h           | 7 +++++++
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-acry.c b/drivers/crypto/aspeed/aspeed-acry.c
index 247c568aa8df..ecb6e984367b 100644
--- a/drivers/crypto/aspeed/aspeed-acry.c
+++ b/drivers/crypto/aspeed/aspeed-acry.c
@@ -137,12 +137,6 @@ enum aspeed_rsa_key_mode {
 	ASPEED_RSA_DATA_MODE,
 };
 
-static inline struct akcipher_request *
-	akcipher_request_cast(struct crypto_async_request *req)
-{
-	return container_of(req, struct akcipher_request, base);
-}
-
 static int aspeed_acry_do_fallback(struct akcipher_request *req)
 {
 	struct crypto_akcipher *cipher = crypto_akcipher_reqtfm(req);
diff --git a/drivers/crypto/ccp/ccp-crypto-rsa.c b/drivers/crypto/ccp/ccp-crypto-rsa.c
index a14f85512cf4..32c9f524f3d5 100644
--- a/drivers/crypto/ccp/ccp-crypto-rsa.c
+++ b/drivers/crypto/ccp/ccp-crypto-rsa.c
@@ -19,12 +19,6 @@
 
 #include "ccp-crypto.h"
 
-static inline struct akcipher_request *akcipher_request_cast(
-	struct crypto_async_request *req)
-{
-	return container_of(req, struct akcipher_request, base);
-}
-
 static inline int ccp_copy_and_save_keypart(u8 **kpbuf, unsigned int *kplen,
 					    const u8 *buf, size_t sz)
 {
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 670508f1dca1..4b6e610db18d 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -498,4 +498,11 @@ static inline int crypto_akcipher_set_priv_key(struct crypto_akcipher *tfm,
 
 	return alg->set_priv_key(tfm, key, keylen);
 }
+
+static inline struct akcipher_request *
+	akcipher_request_cast(struct crypto_async_request *req)
+{
+	return container_of(req, struct akcipher_request, base);
+}
+
 #endif
-- 
2.41.0

