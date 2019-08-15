Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A744C31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 543AA218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Fv/qAauV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730795AbfHOJBq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:46 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41175 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfHOJBq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id j16so1577876wrr.8
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LHJbGYYVd9anPfjjvOncYFmF6xF/5unBiz7afWnI4fY=;
        b=Fv/qAauVGznLCjxaHU1DlupK80IufloW7FEmG0b2QwK+vEM566prg2y7wNmNF7nDz1
         XEX0KtMAEPc5RHIiAVcykpmAOdTqXyxoI3vdDorPaXURnnO8NZVri9/BXqmbOxxUiGd6
         B4nixoybCPftkf685DXwqffd2apiYml4i1TPHwpf36x9+IK9EMG3CTIXcDKYFFyPO46e
         sARtFffmB13EmgcMXx2vQXJt1cM84u2AxwoQdXdQ9HWyQVLPcqMOCidcJLVVBoxLuolp
         sUPu39IecsAP2q6UZv23k432poHNbB2ROmoCnMCkMWUjOKR0mZWtMQi0ugzv0l0ZMhmE
         M+PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LHJbGYYVd9anPfjjvOncYFmF6xF/5unBiz7afWnI4fY=;
        b=lpIiILnLvAouoY1CgGy16i0yr251NkBWiI84eTRt8R0+DoFxBXF6k6l/Xul2FODbrW
         ERbBu521DCOZbzy5FG9Aom8sy5XL63CXFJeMG2a2tjNxhzIDjBXfBPQZ1MG9qw3D+o7S
         bJRRI4te3Mmv3jS7c3jCMXk0beYAKw0p6YD6i8skW835uyZPopgI1/GG+1GFXmDLVfpj
         kx2Xx8labpr6sO0nJF3dAZBWn0Hn+3OKScgdUtWkH7S9usVuOhyX8VUwB8fZfA9OcgBG
         Ta4dPGSgjNpwXRKo2Yr8OFUgoeOKOc7X04+rhnJOXwSUmDSGQzMITEQn4B2bdRPjbPXk
         QHag==
X-Gm-Message-State: APjAAAW1ZOH72uHX/0nCb/rJeBSM7s9HDxbn9PMlywjb6ngpHfFatLrn
        Dzl1hpmS1hkuEw7OgNjuVLJLNteHcrnNpyPY
X-Google-Smtp-Source: APXvYqyGr22/cg69PKfl1rQ1LDwsp2U6qYrwDRizy7TDPUywz3Gag0daUYnk/ACalgLtCTO7GbbxxQ==
X-Received: by 2002:adf:f6d2:: with SMTP id y18mr4228361wrp.102.1565859704608;
        Thu, 15 Aug 2019 02:01:44 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:43 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 11/30] crypto: hifn/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:00:53 +0300
Message-Id: <20190815090112.9377-12-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/hifn_795x.c | 32 +++++---------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 5c3f02e4aece..a18e62df68d9 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -21,7 +21,7 @@
 #include <linux/ktime.h>
 
 #include <crypto/algapi.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 static char hifn_pll_ref[sizeof("extNNN")] = "ext";
 module_param_string(hifn_pll_ref, hifn_pll_ref, sizeof(hifn_pll_ref), 0444);
@@ -1939,25 +1939,13 @@ static void hifn_flush(struct hifn_device *dev)
 static int hifn_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 		unsigned int len)
 {
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
-	struct hifn_context *ctx = crypto_tfm_ctx(tfm);
+	struct hifn_context *ctx = crypto_ablkcipher_ctx(cipher);
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
+	err = verify_ablkcipher_des_key(cipher, key);
+	if (err)
+		return err;
 
 	dev->flags &= ~HIFN_FLAG_OLD_KEY;
 
@@ -1972,15 +1960,11 @@ static int hifn_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 {
 	struct hifn_context *ctx = crypto_ablkcipher_ctx(cipher);
 	struct hifn_device *dev = ctx->dev;
-	u32 flags;
 	int err;
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = verify_ablkcipher_des3_key(cipher, key);
+	if (err)
 		return err;
-	}
 
 	dev->flags &= ~HIFN_FLAG_OLD_KEY;
 
-- 
2.17.1

