Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA4DC0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 087642054F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZO6ze/ol"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbfHERBn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:01:43 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38249 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728871AbfHERBn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:01:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so52370665wmj.3
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4lxZDOC1Y58KLeO9JczYkAO5RiRWd4BeTfNyToHmZ4o=;
        b=ZO6ze/ol/eQ0vv70bom72+XEPx6eeRUUYDjetdlgBhcUNj0oe85LMq/bpFH2wyRdDJ
         hz1z26e/Yo8TyS2iVqtJAaEPeXEYFhFHSKI0JHLGLJNnNIwgOu/vyiwLTMDo77/lctFF
         j7TaDAghiPZx/MKL4Ro/odSUY9CIewLAu+RtPVr2qLsyadHkbHqNF13w8GMvS8HoPe0p
         FmMWa2vIIKolwK5ywRHDxOwQinvjz6vAqKfAewIm73AEOzAFju00eqBPrl5WvpnxcGMj
         buc1QCY+OY8fql43nbXOALWRQqt2Pfkq96qGGas1bV7ip+ZkwG+lLrUcp+jhMLbaGKQo
         k6ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4lxZDOC1Y58KLeO9JczYkAO5RiRWd4BeTfNyToHmZ4o=;
        b=EjtTqXS+0qQG7yHFKuRLFf7MQbjHlKnxWmIYygkv4dwNZo6TDZKi2VvtsDum8HdB9S
         vJOX+38RDQIwQfktll1BSNFUAWTj8rhgOWnEe6p8Gt9SB0NNf+UO+fcw0hae3RZCqNaz
         CSUZkobnLF+kbs4QB0f3YKeQa3OBeNNcX5LcKsWeYfskesZSq3AOteK1YhVKsInJiUP3
         S9HDbaVvwKOSsh8mjpPA2EatzgUoD6y3cyEU+GBZfScpAH4Sz7S95uDr1AUveJp93w/i
         WCDsjkO6MPT1LjnmdxRmQSPDPJuvd5d8PkBscjiLEmW7TCRoQsdJe4eJVeLgQ8vvol1e
         keiA==
X-Gm-Message-State: APjAAAVOpRLuvBBf06zMIjcVaaOJTHGQVlBcbAUbN8RZFdEosj9eYYt7
        9hBokuzC887AvphABUnrAL1+aRliFERl1Q==
X-Google-Smtp-Source: APXvYqxaeHtuoIM5bH6Swrm/BUPrfK73viNJmXVjNEdEwKkdEYlEv00ck0ujzmJyJpTk0R1BhSk7tA==
X-Received: by 2002:a1c:7c08:: with SMTP id x8mr19555680wmc.19.1565024501264;
        Mon, 05 Aug 2019 10:01:41 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.01.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:01:40 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 11/30] crypto: hifn/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:18 +0300
Message-Id: <20190805170037.31330-12-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/hifn_795x.c | 29 +++++---------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 5c3f02e4aece..7cb750c34e37 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -21,7 +21,7 @@
 #include <linux/ktime.h>
 
 #include <crypto/algapi.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 static char hifn_pll_ref[sizeof("extNNN")] = "ext";
 module_param_string(hifn_pll_ref, hifn_pll_ref, sizeof(hifn_pll_ref), 0444);
@@ -1942,22 +1942,11 @@ static int hifn_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
 	struct hifn_context *ctx = crypto_tfm_ctx(tfm);
 	struct hifn_device *dev = ctx->dev;
+	int err;
 
-	if (len > HIFN_MAX_CRYPT_KEY_LENGTH) {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -1;
-	}
-
-	if (len == HIFN_DES_KEY_LENGTH) {
-		u32 tmp[DES_EXPKEY_WORDS];
-		int ret = des_ekey(tmp, key);
-
-		if (unlikely(ret == 0) &&
-		    (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-			return -EINVAL;
-		}
-	}
+	err = crypto_des_verify_key(tfm, key);
+	if (err)
+		return err;
 
 	dev->flags &= ~HIFN_FLAG_OLD_KEY;
 
@@ -1972,15 +1961,11 @@ static int hifn_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 {
 	struct hifn_context *ctx = crypto_ablkcipher_ctx(cipher);
 	struct hifn_device *dev = ctx->dev;
-	u32 flags;
 	int err;
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (err)
 		return err;
-	}
 
 	dev->flags &= ~HIFN_FLAG_OLD_KEY;
 
-- 
2.17.1

