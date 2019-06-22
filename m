Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8FEC43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E02D2084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z1utctrf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfFVAb6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:31:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33546 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfFVAb6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:31:58 -0400
Received: by mail-wm1-f67.google.com with SMTP id h19so10135382wme.0
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=skPEgyB6K58F0JFBqiqoUFb0RrK94HT325v0Xt9TX8Q=;
        b=Z1utctrfbMwUyC3wz3j6Et4vmqX1pyhe9NhJdH1Ti5/f46RdZt+RAejlWBoQLdncgg
         BWHgz4iAE23K8g2EYOFWkr5M2JdlijKTmCxLtBPocscVRqaovDI4EFy7yPBy70QqHCiK
         zQy8HVDKQWypSklTUXDol6Z+7mxrXLnZNJVsngh0wqWAgk7kPy2jQSPM1SWy124AZHBM
         z2fOJK4FaypaNn5ipoDB5KzLdZFWsLLah3+i1P5arjzAwBF/grDxGdSyLMeh4Yvn3TTa
         clXnqivhDYf03oCf9t3aJFZ1ZrUfWlWIGkY8x2g+woJ1RurKa2ltArl+wU3GgMPcpUHr
         2vKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=skPEgyB6K58F0JFBqiqoUFb0RrK94HT325v0Xt9TX8Q=;
        b=ffvZmpSN+VMNI2y9Uvl+A6oJnaOEDMXD4ESbPHV6yd42Erh0P+u1R4gxqFcq8ILqm/
         yy//b41DZG5n0g9zbl9/ga1XLx4DsAQkhWfmx5FiazlR2258XRnugk+B7xeN6N18jkc/
         UBt6TDfsrli5doBj6JlJotTXlc/pywyDYypPb91Nmp2teRUBxG87GAT89SaQca/boggJ
         chpAb7gmUw9AZE1RU4VNUfunkf33/OetCNRPSaSp3fU40UoJ56vmvFeCVGSNoTuPY1dB
         f0VX+aTurjkMtIV1bNkb8z/BEkr6cJa8qshJP7Kmz+LZ9QIhJuYGUqlWBgUAtpwT+GHr
         ma8w==
X-Gm-Message-State: APjAAAVzNeDqWVNvpUuFx5HiQEGVClCeNzC0k4Vwla2QusmkFRgCJevJ
        uh30Lns76wvBWzuNya0+Zp5UGnYS+DbdqEd5
X-Google-Smtp-Source: APXvYqy25WwhPTIn1eCpoRa/SXRRtO6gqoNAl8nMh4M6cH1svOorzDlztCyEnR9V5Yj/N+LDDsmE3w==
X-Received: by 2002:a1c:e183:: with SMTP id y125mr5636663wmg.152.1561163515978;
        Fri, 21 Jun 2019 17:31:55 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.31.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:31:55 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 11/30] crypto: hifn/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:30:53 +0200
Message-Id: <20190622003112.31033-12-ard.biesheuvel@linaro.org>
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
 drivers/crypto/hifn_795x.c | 30 +++++---------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index d656be0a142b..3eb1ca59e90c 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -30,7 +30,7 @@
 #include <linux/ktime.h>
 
 #include <crypto/algapi.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 static char hifn_pll_ref[sizeof("extNNN")] = "ext";
 module_param_string(hifn_pll_ref, hifn_pll_ref, sizeof(hifn_pll_ref), 0444);
@@ -1948,25 +1948,13 @@ static void hifn_flush(struct hifn_device *dev)
 static int hifn_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 		unsigned int len)
 {
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
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
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key, len);
+	if (unlikely(err))
+		return err;
 
 	dev->flags &= ~HIFN_FLAG_OLD_KEY;
 
@@ -1981,15 +1969,11 @@ static int hifn_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 {
 	struct hifn_context *ctx = crypto_ablkcipher_ctx(cipher);
 	struct hifn_device *dev = ctx->dev;
-	u32 flags;
 	int err;
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key, len);
+	if (unlikely(err))
 		return err;
-	}
 
 	dev->flags &= ~HIFN_FLAG_OLD_KEY;
 
-- 
2.20.1

