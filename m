Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B335CC43462
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Apr 2021 12:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91849610FA
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Apr 2021 12:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240486AbhDPMXm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Apr 2021 08:23:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36176 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243385AbhDPMXl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Apr 2021 08:23:41 -0400
Received: from mail-ed1-f70.google.com ([209.85.208.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lXNVE-0006ms-82
        for linux-crypto@vger.kernel.org; Fri, 16 Apr 2021 12:23:16 +0000
Received: by mail-ed1-f70.google.com with SMTP id w15-20020a056402268fb02903828f878ec5so6898548edd.5
        for <linux-crypto@vger.kernel.org>; Fri, 16 Apr 2021 05:23:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xuRrK2sERCiDBtlFETS0bmY5iva8IGRiUD4dm9TuXd4=;
        b=CQz+sf8MElFUaBJzJQ8X+HlWRac6QFfbxLkM8Jvm+BMKiI393RJV3Tbbq23gwZkhJs
         NDGaZ0TsNDlKY3984DrT6CUEw7x9qyjq6PuHuH3JNIGk+c1zxAos6RnPKdeBFRLR0xNn
         Q00sN7t8SPQG0DZhppGO6PwxseW7GL3BfT8D04vr3wb27pPsnX3FZokaPDXfeistU0hY
         goJkArHjVGSfivmEzYfmuvRAlQv/6U6Wi4xgu1v2YewD27vrazYr8ykPntcUX+lXEIxv
         2L23JdnXfmI6acr5diwRyH4PNGcolwKOHomwLY2xzNYv4sar9C5ho3WJTOH/cI1GL0Qw
         Xrrg==
X-Gm-Message-State: AOAM530EdmBTJ7MUo+zei0mJ0nXtdespZtDWtIOrwpyQxv/TII1UnMM8
        I8gwvSiKLKymuQAFPAYFpBi43OWuVRZjnZeDK/2wiBI8fG+yEjcpXJ6KhjoRT681YSIpaifX8lO
        bDKGeKgyPuE/XtQHYDGl3agJL/Nm+G+MkKKkQsGsmOg==
X-Received: by 2002:a17:906:9a81:: with SMTP id ag1mr8040924ejc.464.1618575795987;
        Fri, 16 Apr 2021 05:23:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdnin0iDK9J8ErpoBD20g+6ncHdztuhrSzlgqmrf2izOZ21roWcd7CEU6qe6bfTPxitKVrkw==
X-Received: by 2002:a17:906:9a81:: with SMTP id ag1mr8040914ejc.464.1618575795818;
        Fri, 16 Apr 2021 05:23:15 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-192-147.adslplus.ch. [188.155.192.147])
        by smtp.gmail.com with ESMTPSA id i25sm2328924edr.68.2021.04.16.05.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 05:23:15 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] crypto: s5p-sss - remove unneeded local variable initialization
Date:   Fri, 16 Apr 2021 14:23:10 +0200
Message-Id: <20210416122311.223076-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416122311.223076-1-krzysztof.kozlowski@canonical.com>
References: <20210416122311.223076-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The initialization of 'err' local variable is not needed as it is
shortly after overwritten.

Addresses-Coverity: Unused value
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/crypto/s5p-sss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index d613bd557016..8c310816deab 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -2156,7 +2156,7 @@ static struct skcipher_alg algs[] = {
 static int s5p_aes_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	int i, j, err = -ENODEV;
+	int i, j, err;
 	const struct samsung_aes_variant *variant;
 	struct s5p_aes_dev *pdata;
 	struct resource *res;
-- 
2.25.1

