Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 539A9C432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 12:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6B4764F6F
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 12:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhCRMpB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 08:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbhCRMoh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 08:44:37 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9514DC06175F
        for <linux-crypto@vger.kernel.org>; Thu, 18 Mar 2021 05:44:37 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id g20so3459404wmk.3
        for <linux-crypto@vger.kernel.org>; Thu, 18 Mar 2021 05:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V3/tc0Yb6jrNSgFN3wzJjGp740jB6twjzIpO+YKSzDo=;
        b=aUM2L0+pi/1cI3jATJQAlraEb4KXpWG+rU4TizHnfrUYZmIvpEP1xfkQTgcwNHdZyh
         UflbNqAPANaQe+LcS+pKV+QUJBY1LIkBcDTVlvZD3LgH1jBv8XjM5189zmcTYS+2r1yZ
         lQ7IukKrv8o6znuYrXHAI/u3dD2ie7xA10DBvncwPPfxftToByDADIn4HP55yajJ5yWJ
         EWK21J1WinSmihtJY0Nmv8oMSe7aL+REVU0Qob68rN8H7dD3OKJ9amNVmumeEja9ykQ1
         lljl/7MDjS1zdbF0VTxlOF6dSdcOrMLHnKHDPegRPxfqKCxZsOFJ1noMeQsZMgSbftNL
         ZEQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V3/tc0Yb6jrNSgFN3wzJjGp740jB6twjzIpO+YKSzDo=;
        b=To4S4Koz2P4BGfMSNC52G1ZGmpQ2GXMpVsI88p2yGqK5CtmXKHrTElqHYwErgz8gvv
         mOgDrtlGajiRIQOqJXzgsSdqcnW7KLvHeY8wdZYI2r5ORrIJvOKSmLe4ZbJkaTFeISbm
         q9CPzmSodRCiXk19949xNpzVjbXredpFR+cOgDg5+UMPLBgmon0IlgA7bJaSdSzCJUSI
         HON5d6zGK/xG4VTZnt5Fnb0Y20iOi/6qgFh6CL2Nj0IF/kaA88xFlR9qumoiCtDlg3zd
         fHF+ErK2PZSWgYGJMNyq4/LzDVsQ7hwapQar5I0UUBDGplfXWJGIcSmE37Pjr0r9G29A
         4n6Q==
X-Gm-Message-State: AOAM532AmlXvMDS36Ol10tTbfpBcZwL9lssAe/AisYx+RJwJ02HbA6X7
        f2CVYZJSa01889qJu3Kljxd58A==
X-Google-Smtp-Source: ABdhPJyKR338FNSwiovSQH97gzw+u/TywpTayrlftICyjXcQzKH05FqBFmP+pXqU11eWzlEYaNL3+g==
X-Received: by 2002:a1c:7210:: with SMTP id n16mr3403759wmc.13.1616071476358;
        Thu, 18 Mar 2021 05:44:36 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id q15sm2813900wrx.56.2021.03.18.05.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 05:44:36 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 06/10] crypto: atmel-ecc: Struct headers need to start with keyword 'struct'
Date:   Thu, 18 Mar 2021 12:44:18 +0000
Message-Id: <20210318124422.3200180-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210318124422.3200180-1-lee.jones@linaro.org>
References: <20210318124422.3200180-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/crypto/atmel-ecc.c:41: warning: cannot understand function prototype: 'struct atmel_ecdh_ctx '

Cc: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/atmel-ecc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 515946c99394e..333fbefbbccbd 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -26,7 +26,7 @@
 static struct atmel_ecc_driver_data driver_data;
 
 /**
- * atmel_ecdh_ctx - transformation context
+ * struct atmel_ecdh_ctx - transformation context
  * @client     : pointer to i2c client device
  * @fallback   : used for unsupported curves or when user wants to use its own
  *               private key.
-- 
2.27.0

