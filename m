Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56DAAC0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26F782054F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZxWYPB0J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbfHERBg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:01:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36738 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728871AbfHERBg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:01:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id g67so69612330wme.1
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XCfq0cibkHau/c01ce7pT9k2NNgLItL6s6kRL+GZ0sg=;
        b=ZxWYPB0JbZ63jNF90t31kYWxWInvUzFns9iIdrBnjJ9VOvQ8O0i3pjYdJ08edr3C4r
         gkPcBsr7ZSmbb48Sd5i8Jf12Cg7lHXMPZgVaM2uW4lMFplB3jvxWSV3ZZQtZxO4Nlc6R
         FlkWEeDKxYt1iU9FXHlp6hCT0pvCJ9XATk6kYVM0NJ1VE/afZRGvU4RHZmXyVRzSimZV
         j7s/fCJJ3brDJeLzdcwt/tEc5raoavH4s1gKBTgp46IbIGrQ8yr49kyJpjd9N34VUjjJ
         dLiIm2kQ8ztoGzytlBLsXsIZOaEQg0PDHwdF/BiBJv+e3Xj5IEesR8Nx1Jr7rcmbbDKc
         wv2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XCfq0cibkHau/c01ce7pT9k2NNgLItL6s6kRL+GZ0sg=;
        b=Zo+VxpOqL6DvOlpLBhGn0vW7ydKGhgCQLb4phSaVb0KgEi6xPvJRDOgXm12zAYKYiv
         McHzMPbgUAuLjiU8C3e/l+4JMCE+w3lfQHN++JRvQyPTNsU3eeLX+V0KvUeL1/cffe4f
         myQ52DLm+O9qv3itzbkv1+Q3y+TmGrY27JXac8ZChuPZKXSNKd+LDeJ6CT3so4Kt005W
         o3wv5UgzcZ3MwQ/9oZaTCpONjMdFr3PF9masRAL2E3avP82vFssx761IZLP4Dk32tu/D
         lI7Q4/uAcoe0cL2Oegh5uvGtlxVTKemkXnfThiWNDoPdFD3YHtDMdgiM3+Rg0XIEmExr
         L51A==
X-Gm-Message-State: APjAAAUH+CCmubH+03uS96p+UrGub8Wgj4p6qZ62B6ycCCj8nA90DQzC
        o+ldDZURujRBJa57HW6AIhy/dLJSPzTP/g==
X-Google-Smtp-Source: APXvYqzPp7C3TiwzxFww7wM4clV8A73cweUOwKhnmHijfmJt0Me+WJ8G7hW5PAuATdIDXn3HU6F6mQ==
X-Received: by 2002:a7b:c7cb:: with SMTP id z11mr17844972wmk.24.1565024494514;
        Mon, 05 Aug 2019 10:01:34 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.01.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:01:33 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 09/30] crypto: ccp/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:16 +0300
Message-Id: <20190805170037.31330-10-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/ccp/ccp-crypto-des3.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-des3.c b/drivers/crypto/ccp/ccp-crypto-des3.c
index 5f05f834c7cd..cbcdf1b5971f 100644
--- a/drivers/crypto/ccp/ccp-crypto-des3.c
+++ b/drivers/crypto/ccp/ccp-crypto-des3.c
@@ -14,7 +14,7 @@
 #include <linux/crypto.h>
 #include <crypto/algapi.h>
 #include <crypto/scatterwalk.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 #include "ccp-crypto.h"
 
@@ -39,11 +39,10 @@ static int ccp_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ablkcipher_tfm(tfm));
 	struct ccp_crypto_ablkcipher_alg *alg =
 		ccp_crypto_ablkcipher_alg(crypto_ablkcipher_tfm(tfm));
-	u32 *flags = &tfm->base.crt_flags;
 	int err;
 
-	err = __des3_verify_key(flags, key);
-	if (unlikely(err))
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(tfm), key);
+	if (err)
 		return err;
 
 	/* It's not clear that there is any support for a keysize of 112.
-- 
2.17.1

