Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F8B5C433FF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8B19218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f4UvRqf4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbfHOJBl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:41 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35678 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730760AbfHOJBk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:40 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so684297wmg.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R/dzAswTxDJO+r8Mbwq2UP3hHo6TATLahJ6svsPcZRM=;
        b=f4UvRqf4+mjlADq2VxXANUTyDi5GrfIcG7c4f+rAhM7Dr1CUb2up6E7xokErP3ybxz
         BKPTTshAW5JM4FncbNS97X4IBsJo1CTscysjrswleBA50xJt0zidkf6spTf0RXZ1vUbU
         5U9zji5FZA2OUksccM0PpcNEne4c2NxQ+W88yoJpBTF0eyFCz4Dt0LpGvrf6rr8dYQUB
         XFnWjUb8cPX0jtvsrRECXyfRbOG7Dk3n/ywI9aT56AyQzOabK5Il49S1OzNF52qLbCeT
         98wsgUxpcoemlvkJVT6qos8flcMQWeOtboWR/PfSXJk3ZBYv8dwo3v6ow906t8v9HWMe
         MgKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R/dzAswTxDJO+r8Mbwq2UP3hHo6TATLahJ6svsPcZRM=;
        b=NW09pFjqLCpSjV6lzLKUSEuVL7fG3KErHvasnT+O4IownAB637hqUO8HpIvs+RLEYt
         LNK+tvPRvWt0PeWNSKhfJ0J1k3HeZdR7RQIThkaW9AsAgvw0cEEMvkS0TtiXro3KAUyn
         sTwM/8O7ALgcJHdHj35k3t+jfLt3FchzsmnNb+jPVoG5qiIwkmzTcb8MD7dCv47EUH3h
         Rm4I95WVuURhBWUyEZO9n6n5phkBA/hkwGXdevab0TEKHO97wSu87US9Ju8lYd36gtX/
         vKbaVvpi10I6XI6yzRqCrdWkUxOyzEnUAGwnl2eyNKZOwoCzjebl72nJxxxBEp5ZGNTu
         NwuA==
X-Gm-Message-State: APjAAAUWf7SoknoAm+EMLZ5N6REuHmtb/3p/wKS+VWkHMF90u9mUBBBv
        mIig/C5edLAseyp2t/ezjYnXCnSNXzmrgdsf
X-Google-Smtp-Source: APXvYqylaXa3NiZRVFSU6h1RvaoCQADx4XtbKOWT0SX/Kxabei0hMgIa50kfTq54sFb/V0G0AkxNoA==
X-Received: by 2002:a1c:2ec6:: with SMTP id u189mr1654567wmu.67.1565859698755;
        Thu, 15 Aug 2019 02:01:38 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:38 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 08/30] crypto: nitrox/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:00:50 +0300
Message-Id: <20190815090112.9377-9-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
index 7e4a5e69085e..3cdce1f0f257 100644
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
+	return verify_skcipher_des3_key(cipher, key) ?:
 	       nitrox_skcipher_setkey(cipher, 0, key, keylen);
 }
 
-- 
2.17.1

