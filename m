Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EAA3C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 067A22133F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j0VC/rm0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfF1Jft (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:35:49 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39537 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfF1Jft (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:35:49 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so8312786wma.4
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mArMgkRrrTiVovX0YGM+hqVcrESzFxDSVfPYZOwfEaQ=;
        b=j0VC/rm0465wbrdiRp6gSb6bwOawU+hPV6Yzs/955GHHfnnuXWaPxGz4KVX/xYMO17
         czaNhguo3ZgXcDEezvwddhJieEo03feKI6Gkawcy568lktrYMB4e9dJHbJooH82vKTB8
         dpUb4S0IE3MbR855h1D542DtaNDYCasGuLQiACUgoUTLqqsPM5iBjETNqkbecjmXbiPm
         e1Uqg4r0oWEVKozRTeRTdZ2GoAAaLJBCXPfGbbi1LMqXfrUP3RmnvL0podEJK7FEsxpm
         /g7iDGQnj+h7vNzlo5XOVUw5B0Odcz1ObG43sorQEu88ZYzoBJuvkw6BbzxPT9J4jffB
         azGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mArMgkRrrTiVovX0YGM+hqVcrESzFxDSVfPYZOwfEaQ=;
        b=T6E+9OaByP1Vyrrn/9GQq9gnNrEZrO7bHfhbShZkIMOJhOIQ1lIHwNXvdfM7SNreDe
         T7Ld9BnFJd2kCGA9bDgPQXnH3hBHI2tIKP+KEV0TaTVVBwmvKRelEgPXQA1QODBoy274
         VLSMHz2h/cTfUxYh3NTpZ72+9bvsGV2dXCIlD2uC+B7sFGj/11I9tMAL1QalbD4OJXVo
         a0xV/50T4TDr00gfxX1TEmqSF36uj0wE4PcWS9T1gHp8+h2aCiapvhp/xmhDRHa+brSx
         E3sUvccvW4GvaDhyeGozA6hxnL0cVGf48X+8sZ+EYHRudpq6ll6qk5ulXpMTck9+QBcm
         QTdQ==
X-Gm-Message-State: APjAAAV6A1s0COh70GjE0DpOuqDNRXpNCmuHnIda/uc7hpQPqHyLaepE
        HOwHdjPsdl7ZsoXR1S3ervuOmLWhsR0c/g==
X-Google-Smtp-Source: APXvYqwuSlX5ZinX0j3ElJO9YRqBQq45X+FWvsnywmR36Ck+Ks7ju+YtlFgnEHB5r0USZHFRWat2kA==
X-Received: by 2002:a05:600c:2409:: with SMTP id 9mr6244159wmp.110.1561714547090;
        Fri, 28 Jun 2019 02:35:47 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:46 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 08/30] crypto: nitrox/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:07 +0200
Message-Id: <20190628093529.12281-9-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
References: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
index 7e4a5e69085e..9d3bd1b589e0 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
@@ -7,7 +7,7 @@
 #include <crypto/aes.h>
 #include <crypto/skcipher.h>
 #include <crypto/ctr.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/xts.h>
 
 #include "nitrox_dev.h"
@@ -257,7 +257,7 @@ static int nitrox_aes_decrypt(struct skcipher_request *skreq)
 static int nitrox_3des_setkey(struct crypto_skcipher *cipher,
 			      const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(cipher, key)) ?:
+	return crypto_des3_ede_verify_key(crypto_skcipher_tfm(cipher), key) ?:
 	       nitrox_skcipher_setkey(cipher, 0, key, keylen);
 }
 
-- 
2.20.1

