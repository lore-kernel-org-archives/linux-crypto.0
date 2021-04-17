Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220E3C43461
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 13:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 073B561207
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 13:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhDQNZp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Apr 2021 09:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236430AbhDQNZj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Apr 2021 09:25:39 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE11C06138A
        for <linux-crypto@vger.kernel.org>; Sat, 17 Apr 2021 06:25:08 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id q136so10748135qka.7
        for <linux-crypto@vger.kernel.org>; Sat, 17 Apr 2021 06:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CcaW1nPaukhEXiXprBAQ1ypKp3C4X7MmOMiLijl8qRY=;
        b=RjH9XHI2oJOZeUG94wCXHJ5rvdfUHzbvA8lQHKAw7P1yZyToFuJWcLHvmwPIIp/4bb
         jYJCV77wE2D7xJx1JRXgOnge9haXxjrHyJ/uJDBapQTX7JaCoDfFGSbI/IQHKV/7xr6g
         BflkqxHI5R7ImiqgQYw/CuoPIkp+rpi95EbPrRT9PLZcGQJToXpdFA/TRJeEcCdDklNE
         Ye+Sv1KkJgOm+yiqhWi3HAB573wY7A+toq0Z6l5s9T7461ZwxJ2hHmdp6LPbHxInbXOU
         lMrqE8etp2feC8Zj4/cO9gpg1nNE38bSYWNXubCtvjtm3BgyKQqOP1qN2SbomD79uT6x
         2t1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CcaW1nPaukhEXiXprBAQ1ypKp3C4X7MmOMiLijl8qRY=;
        b=JN2MX9wllyzE6ZSANn0PrmTcpcC5XHDeFhiusF7tpNkkHShZXZ7uR66oQThevk/JQ+
         UMoO3hVBQKvf18UX6dyUzL72XQyXO782wOyeTESsQvHvdkbKBx2T5rvfJd/qK9oRsde/
         GTVGSIc/3RjTsdD4aQAVu1hxGvqZ0UoDxnhJnijdDxmXGLOr7wPGbQyOW27S2IRZM5yI
         3qwptI7OgBKUZpsEbOBEwWQWtkNxD07UlJWw5nHcnBp/mQMM2gfoDjTVUPNYTLDeguTr
         Ex7je3IrOVPkfLNuuZnCqQY3LH+winFZuIV38o39ubleztmnkGW9Lf3210JN2Rmw4EwC
         W1Uw==
X-Gm-Message-State: AOAM5335EHme823zFuJh9WeD7jok7M9zdyAfjnV5qseQpORfank8HR+w
        RnaSvOHStbcGVnqph6aSSM9Hwg==
X-Google-Smtp-Source: ABdhPJzelx4Y76P0iNMp6JW6A0mlHIxUhe07/iXKfwepzoJEeRJbMe37kwc1JYFZAe86JM88aIwkSg==
X-Received: by 2002:a05:620a:1391:: with SMTP id k17mr451254qki.274.1618665907188;
        Sat, 17 Apr 2021 06:25:07 -0700 (PDT)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id o25sm1988327qtl.37.2021.04.17.06.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 06:25:06 -0700 (PDT)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [Patch v2 3/7] crypto: qce: Add mode for rfc4309
Date:   Sat, 17 Apr 2021 09:24:59 -0400
Message-Id: <20210417132503.1401128-4-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210417132503.1401128-1-thara.gopinath@linaro.org>
References: <20210417132503.1401128-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

rf4309 is the specification that uses aes ccm algorithms with IPsec
security packets. Add a submode to identify rfc4309 ccm(aes) algorithm
in the crypto driver.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---

v1->v2:
	- Moved up the QCE_ENCRYPT AND QCE_DECRYPT bit positions so that
	  addition of other algorithms in future will not affect these
	  macros.

 drivers/crypto/qce/common.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qce/common.h b/drivers/crypto/qce/common.h
index 3bc244bcca2d..b135440bf72b 100644
--- a/drivers/crypto/qce/common.h
+++ b/drivers/crypto/qce/common.h
@@ -51,9 +51,11 @@
 #define QCE_MODE_CCM			BIT(12)
 #define QCE_MODE_MASK			GENMASK(12, 8)
 
+#define QCE_MODE_CCM_RFC4309		BIT(13)
+
 /* cipher encryption/decryption operations */
-#define QCE_ENCRYPT			BIT(13)
-#define QCE_DECRYPT			BIT(14)
+#define QCE_ENCRYPT			BIT(30)
+#define QCE_DECRYPT			BIT(31)
 
 #define IS_DES(flags)			(flags & QCE_ALG_DES)
 #define IS_3DES(flags)			(flags & QCE_ALG_3DES)
@@ -73,6 +75,7 @@
 #define IS_CTR(mode)			(mode & QCE_MODE_CTR)
 #define IS_XTS(mode)			(mode & QCE_MODE_XTS)
 #define IS_CCM(mode)			(mode & QCE_MODE_CCM)
+#define IS_CCM_RFC4309(mode)		((mode) & QCE_MODE_CCM_RFC4309)
 
 #define IS_ENCRYPT(dir)			(dir & QCE_ENCRYPT)
 #define IS_DECRYPT(dir)			(dir & QCE_DECRYPT)
-- 
2.25.1

