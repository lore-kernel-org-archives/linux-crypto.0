Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923FFC43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6333F2084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XSaTX3dh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfFVAcC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:32:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42654 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfFVAcA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:32:00 -0400
Received: by mail-wr1-f66.google.com with SMTP id x17so8087954wrl.9
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vApWO3NPTtkZ39m30CStMxAxSIOK9CFxw47NF6Cp5iU=;
        b=XSaTX3dhYLHnsAwzlSHynStn3Vli6o558owwN/zYBthggLpHrs9rvVKdcf0cCJlz/i
         5eLRTZOLv0/QiByvi8tIlPc6pcdMelYtHSbLKJXqI/bj4xFBHxs6XPjzDQut+peTZdxl
         wva+M/bKbkikgNKv5ioPu15S/25i7nz1GNsq2xnOcW6zNhN+7RKcVKI1kc+aRmpkmrW/
         TuPOGFNyMU/377dJyuKLqGXWl+hyvVu8UMoQX50aHiZkR+uU+8vJm6zhhsGyFPlov9KO
         Znk7HYr0XmdEylL1PPVE7a6VVQSpgXON0cw8AIkqnHawy39ppxyDxlm3KbQAbQweWgcE
         hIww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vApWO3NPTtkZ39m30CStMxAxSIOK9CFxw47NF6Cp5iU=;
        b=pIyr5Dcdsk9mrNvGB/lzPlqVgTna12jpcAnQ2+xCfupVfONRpS4GnSsrx6BLOPJ9vx
         keFWzEfGgStWh7RvRA7PZ/oh3F7FrsVfJhWjCb+Rn3UvI8oAPfuRoLjEnRf6gYFxh+xM
         BYVpg/6KAJQr2DKx2/dO11UoljCaVuP/AKK+bl+86pZNw5oHlya7mrDDTlpnTUY1LePM
         F67QLM9QjnQ6FTvni4IRmNbyh7CXhT7q40hNWFZ2PtM57QG/ihSUkv8vBINaJCoKtqQw
         Sihc1vXGDKGcIY85huTXs1CVz0DfkBFPGAOrI2Y5RYZxGclPniVU7hIbifi/2WMcI5EB
         buDA==
X-Gm-Message-State: APjAAAXlj+hQ6zHgebHK2wjRzxAwAtEYfOz5E5+r1rAQPlXJstFrXmI8
        dZk/Fpvv/RD1/N/gPq5zsfu582ywnqofmoSM
X-Google-Smtp-Source: APXvYqzb1a1gQzjVkxJ10/m+e+jb6qyHP7w1ZvQ+gVqnthDVNQS/6T4Py+dxVLYDEMO9paPcIsJvug==
X-Received: by 2002:a5d:5510:: with SMTP id b16mr63602486wrv.267.1561163518061;
        Fri, 21 Jun 2019 17:31:58 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.31.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:31:57 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 13/30] crypto: safexcel/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:30:55 +0200
Message-Id: <20190622003112.31033-14-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 8cdbdbe35681..82cc6f003bc9 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -963,19 +963,11 @@ static int safexcel_des_setkey(struct crypto_skcipher *ctfm, const u8 *key,
 {
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 tmp[DES_EXPKEY_WORDS];
 	int ret;
 
-	if (len != DES_KEY_SIZE) {
-		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
-	ret = des_ekey(tmp, key);
-	if (!ret && (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	ret = crypto_des_verify_key(tfm, key, len);
+	if (unlikely(ret))
+		return ret;
 
 	/* if context exits and key changed, need to invalidate it */
 	if (ctx->base.ctxr_dma)
@@ -1074,7 +1066,7 @@ static int safexcel_des3_ede_setkey(struct crypto_skcipher *ctfm,
 	struct safexcel_cipher_ctx *ctx = crypto_skcipher_ctx(ctfm);
 	int err;
 
-	err = des3_verify_key(ctfm, key);
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(ctfm), key, len);
 	if (unlikely(err))
 		return err;
 
-- 
2.20.1

