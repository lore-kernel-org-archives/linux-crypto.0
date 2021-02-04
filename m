Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1930AC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D414464DBA
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235692AbhBDLRW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235714AbhBDLMR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 06:12:17 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D88C06121E
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 03:10:18 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id j11so2752303wmi.3
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 03:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PLs7LqNAnAgmBAtmZ421+3eJ35mH5VQmNcNQ6hrZ2jk=;
        b=w/YWwwHoBalPlN40RqolDputHUgs7ltrteDMkwSbm450sjnKe1GilEIqQfKOXYqVwT
         p6puBv8aesKr6hgfHUiv1B8b86YehM3QV2FYexzTjV/OqgDNe4CH8gsM8XEhHE5Z0wXs
         z1ywor6NhTVY05+bdkOpo0gNIEXWZ+NckY194k9i6cdc+Gqaa2StQ9lDAcdaTUSthi+d
         D7qBXrPlPKs2HVbkCFG4TyjQbVEyV00Q2Vz16RnI/HC856+Y0STTCBN5AiOyulcpTvOc
         UQo2UFGhjJM4dMBVOLVpGSBR3ogP1goMVoSma2uWn7PL4yVKWH2s4mNnyK3SyjSdav6s
         yuKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PLs7LqNAnAgmBAtmZ421+3eJ35mH5VQmNcNQ6hrZ2jk=;
        b=OG8voaQECwuk4XHzkdSVoCbwF03Zvlgj/s4MVzAhfvjo8Y3B2var18VrHOn7FeJati
         83xBtlu5RD0/3H3Z1M2NE56o2/p/hTnylwQH+Y16hNBqVgHaN05RRkA396WQR6BY1akl
         Op91Mv9SaHoGvPCj2qU0SrGDERIZ+w5/zZs9+WTQxc3rHLONh36hCLfveE4oO6y2RPT2
         9BirLN7jNc2NMUdODnaKEC/e9PT40of6Ow31yjXHAIYQLZkmkf2MphgGZ3KuTd4lCRYZ
         XJP0KSga7lrpat14Tex9MlF+kK9ONgRxZVDat+codRJdapBL4IEq08PL+1C2i/VhLEQe
         RcOQ==
X-Gm-Message-State: AOAM530ve/F0/hGXhrGdDjJyokIjO6AyHgJsHaxZi8WQr0Cgmet6cmrp
        NpgQgXI3En2zTK8DQyI+dVmnIA==
X-Google-Smtp-Source: ABdhPJwJkNyvrnalG1Avr6T8KZZg+DzNeFqzqCm+eQXMQLyMgzq5Tvxx/4+S0HlsUpBPvunszAe/Ng==
X-Received: by 2002:a1c:3587:: with SMTP id c129mr6949813wma.76.1612437017719;
        Thu, 04 Feb 2021 03:10:17 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id y18sm7696218wrt.19.2021.02.04.03.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 03:10:17 -0800 (PST)
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
Subject: [PATCH 12/20] crypto: atmel-ecc: Struct headers need to start with keyword 'struct'
Date:   Thu,  4 Feb 2021 11:09:52 +0000
Message-Id: <20210204111000.2800436-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204111000.2800436-1-lee.jones@linaro.org>
References: <20210204111000.2800436-1-lee.jones@linaro.org>
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
index 9bd8e5167be34..66a31e5739f4c 100644
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
2.25.1

