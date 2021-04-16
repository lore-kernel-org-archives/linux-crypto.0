Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8914BC433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Apr 2021 12:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66EB9611AB
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Apr 2021 12:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbhDPMX4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Apr 2021 08:23:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36181 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243401AbhDPMXm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Apr 2021 08:23:42 -0400
Received: from mail-ed1-f69.google.com ([209.85.208.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lXNVF-0006nK-3r
        for linux-crypto@vger.kernel.org; Fri, 16 Apr 2021 12:23:17 +0000
Received: by mail-ed1-f69.google.com with SMTP id s4-20020a0564021644b0290384e9a246a7so3298716edx.7
        for <linux-crypto@vger.kernel.org>; Fri, 16 Apr 2021 05:23:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fzqFDF62IKS/7ZqV+8AeRm9rshpYPcGYLb2VCKEzlxc=;
        b=XVpb+1TfOyfrbohCAEKbEHcFggrZLeD1xLTJBi8+yqrCZNGCOQijORvA8c+V4kWHbM
         tD1fISDOB92GX2t2RsPypMhHe5yR3Zl3fB2LuZTxbXnV0nFNwVlTivwDayILDxMrGE8C
         ChyvdyBpknPcuqE2LgIU+MoFpvv+dZN8HqC4ZP0f/BqjH1usxXH4BKn8DGCA5oVvTHBl
         cPiurdzmrKg8dVN7rUQw1dV6levFKDJgIT/mszFChQkXscOidFTe3TmtlDq5IHtoGXM4
         kVuzaikuR1vXsm4VdXCIjTUES2JGyO2F4hiKrNkJf/o1dzsjNZ1u36E/IkzBbRWmK4s6
         rtqw==
X-Gm-Message-State: AOAM531jrJmPfrzkoMxIeHxOujX+ct7f+e/Vw3pmkVUka/JVJBYEHIQJ
        fMYLfza2xDiMP47gNkpmeyd+2HaGkYJ47imXoA22pyKTCIyaI5a1tZAPK033AhQVhi3khwYY/eT
        RpuJdWlNPe8hBtnhpg9LtHP/jjP/WoR0esCtUtPfoMA==
X-Received: by 2002:a17:906:a052:: with SMTP id bg18mr8164932ejb.18.1618575796876;
        Fri, 16 Apr 2021 05:23:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8rqxe4OShPzOPdaQiMJqPwX4MP+1hJHO+t8/0TCP0lXdUaa3BKe1KRRwEsifKkCWnlacHmg==
X-Received: by 2002:a17:906:a052:: with SMTP id bg18mr8164918ejb.18.1618575796702;
        Fri, 16 Apr 2021 05:23:16 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-192-147.adslplus.ch. [188.155.192.147])
        by smtp.gmail.com with ESMTPSA id i25sm2328924edr.68.2021.04.16.05.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 05:23:16 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] crypto: s5p-sss - consistently use local 'dev' variable in probe()
Date:   Fri, 16 Apr 2021 14:23:11 +0200
Message-Id: <20210416122311.223076-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416122311.223076-1-krzysztof.kozlowski@canonical.com>
References: <20210416122311.223076-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For code readability, the probe() function uses 'dev' variable instead
of '&pdev->dev', so update remaining places.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/crypto/s5p-sss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 8c310816deab..55aa3a71169b 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -2186,14 +2186,14 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	}
 
 	pdata->res = res;
-	pdata->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	pdata->ioaddr = devm_ioremap_resource(dev, res);
 	if (IS_ERR(pdata->ioaddr)) {
 		if (!pdata->use_hash)
 			return PTR_ERR(pdata->ioaddr);
 		/* try AES without HASH */
 		res->end -= 0x300;
 		pdata->use_hash = false;
-		pdata->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+		pdata->ioaddr = devm_ioremap_resource(dev, res);
 		if (IS_ERR(pdata->ioaddr))
 			return PTR_ERR(pdata->ioaddr);
 	}
-- 
2.25.1

