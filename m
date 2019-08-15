Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A432C31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FA2D218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IEp159/Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbfHOJBm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:42 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40047 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfHOJBm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:42 -0400
Received: by mail-wr1-f65.google.com with SMTP id c3so1585145wrd.7
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HhUKouWNp9h+l5wh7+WhctAuQYAkznLninjkXL0AAyY=;
        b=IEp159/Y7J/EXvoFz1s9k/NwH0TYmv3D0I3GC759SfNO7UosM8Y4YZXjmQ8bOLNQdx
         9nBAGlhpKa99mySwcy4AAYmKfr49cmk6Zskug7+ixwbZzBXdi7ZEpkZmiLms0JPkDEVM
         Munb7WTAqVcj+QLoU7ps9pA7HZfpkZZmPJF8OHrKOhcg7UAUvlSmb8Hd9PDwwvm7m6tM
         nsh+T9B0YlEcJOKBs49beYXjnNc1QqPcFfB4j0K4RN/awK3EYeckyRjrBCLNS+MJ+7td
         tFFsKoECpm/Q/fbaNPzpKZT84G0YKGH7wcHxAvmkBi2MhLy7HiQPTspCITctZ1OOBGiE
         DztA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HhUKouWNp9h+l5wh7+WhctAuQYAkznLninjkXL0AAyY=;
        b=IDS8CI22Wa09fasKCAFzaI4LmPb1XKGXe7mYJi7HXzygmV0M1obCrM6qggoR/kKU7M
         FAfEfIhuJqUVzoPs2NgrOERAgQTMmDeH6WvqHy4zTbGn/bq/tCB1TJQLWIlt1q+60Tap
         lyAmhxWgubhcDC0hmng6pvh3WeMD0H+ntHpNQx1o2Gnv6qq2GAQHreDMitsAwrLbJoXZ
         ag0tnJpypUAdoHhVlNjxXQpY8iCXgtQ3xxzw1TyMv6X+QpbdJM7RTvFijnc1xDD0gbXp
         diTkuK8qLGlbUGHpOUGr7DeMSbHjJG7sSJYqUgpQ7zKvQyuV5JbjAOwbfd0OowW7Sx5U
         pGrw==
X-Gm-Message-State: APjAAAUPhcWluroa1tke2DjPMbZC02PmuvyHQHmn7EagAY2k53jkCKGm
        VCNqMhwUFJTzws2d+/PNXrwzirutlFuUgV0l
X-Google-Smtp-Source: APXvYqxOwpmTaZgFZlubStFpzdOcd+ntqtf0qKkOT33+AqB0iAHTjYSVLv8zZO4yGmQIjspUSrQchQ==
X-Received: by 2002:adf:fc81:: with SMTP id g1mr4243087wrr.78.1565859700422;
        Thu, 15 Aug 2019 02:01:40 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:39 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 09/30] crypto: ccp/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:00:51 +0300
Message-Id: <20190815090112.9377-10-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/ccp/ccp-crypto-des3.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-des3.c b/drivers/crypto/ccp/ccp-crypto-des3.c
index 5f05f834c7cd..d2c49b2f0323 100644
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
+	err = verify_ablkcipher_des3_key(tfm, key);
+	if (err)
 		return err;
 
 	/* It's not clear that there is any support for a keysize of 112.
-- 
2.17.1

