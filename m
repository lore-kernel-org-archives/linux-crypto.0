Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38364C433B4
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Apr 2021 12:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F89C6117A
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Apr 2021 12:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243388AbhDPMXl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Apr 2021 08:23:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36166 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbhDPMXk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Apr 2021 08:23:40 -0400
Received: from mail-ej1-f72.google.com ([209.85.218.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lXNVD-0006mJ-7N
        for linux-crypto@vger.kernel.org; Fri, 16 Apr 2021 12:23:15 +0000
Received: by mail-ej1-f72.google.com with SMTP id re9-20020a170906d8c9b029037ca22d6744so1947284ejb.0
        for <linux-crypto@vger.kernel.org>; Fri, 16 Apr 2021 05:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zyiHnszFk290pFE9xQFpSwJqvg0B5IFpzGvGacwtYN4=;
        b=eMIc8E/Z0+d93SRO7UP2aWM19WWdJbWBFWL0RaZTAAj916Yzm+O+P84iY/WgVj3GuG
         UhSJeNfDmf464nYhzPpW5XIE8+Md1pb6x7AoOUK9F8f708PLHN2JSXeCnJwxcjQ2UX8N
         Ro4bBZ44e/h6UhZqlvnLrCQEGF2Dvi4UIE+t1eq6Gd7yDVaJalg4c3ZvewCS224JBKXb
         g9CYN3nkY5PaNFCxhDLrsVVyrhEeYDTovEovkqkFWh/Jt8JG82XUYPEaYizUGDYm3CdV
         lfoGVdnSJb5smAu2chUDKhipGVRu2vXgFmsppzZwusDh4XbkIXPwzzsXAJNZ/xCfr+6h
         jsnA==
X-Gm-Message-State: AOAM530NI+ZinicozuCu1zKgOr2OsUFikt8GVNFnb8Q/cKk6Uh0O03AH
        LNabw9lhTxW/yrktzz4Ve3PPx0mfngwisqZSaFTRLjR2VHZvZjQ6k1hsy8IblJq6KH4NHvlEmzE
        yISBwTVR2T4d37OVivpIjYVv0sWJ6XaYcVQj3Uxkj9w==
X-Received: by 2002:a17:906:cc88:: with SMTP id oq8mr3697679ejb.66.1618575794966;
        Fri, 16 Apr 2021 05:23:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3zbjnd4HQkCSJYV28UfiRyMLheJIB6t7IsbXsF8yk+dO9xyseBRuNJFTx+2VFeWEOHhu4hw==
X-Received: by 2002:a17:906:cc88:: with SMTP id oq8mr3697662ejb.66.1618575794849;
        Fri, 16 Apr 2021 05:23:14 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-192-147.adslplus.ch. [188.155.192.147])
        by smtp.gmail.com with ESMTPSA id i25sm2328924edr.68.2021.04.16.05.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 05:23:14 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] crypto: s5p-sss - simplify getting of_device_id match data
Date:   Fri, 16 Apr 2021 14:23:09 +0200
Message-Id: <20210416122311.223076-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use of_device_get_match_data() to make the code slightly smaller.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/crypto/s5p-sss.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 8ed08130196f..d613bd557016 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/scatterlist.h>
 
@@ -424,13 +425,9 @@ MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
 static inline const struct samsung_aes_variant *find_s5p_sss_version
 				   (const struct platform_device *pdev)
 {
-	if (IS_ENABLED(CONFIG_OF) && (pdev->dev.of_node)) {
-		const struct of_device_id *match;
+	if (IS_ENABLED(CONFIG_OF) && (pdev->dev.of_node))
+		return of_device_get_match_data(&pdev->dev);
 
-		match = of_match_node(s5p_sss_dt_match,
-					pdev->dev.of_node);
-		return (const struct samsung_aes_variant *)match->data;
-	}
 	return (const struct samsung_aes_variant *)
 			platform_get_device_id(pdev)->driver_data;
 }
-- 
2.25.1

