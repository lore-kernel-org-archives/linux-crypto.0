Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7998CA9EA0
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 15:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD658218AE
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 15:30:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oMhXR7Bx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731847AbfJVPah (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 11:30:37 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44038 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732346AbfJVPae (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 11:30:34 -0400
Received: by mail-pl1-f194.google.com with SMTP id q15so8510373pll.11;
        Tue, 22 Oct 2019 08:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o+sow5wxNZdtv/L0uGDR7GrBdlDuvFkYP55JUcWV34M=;
        b=oMhXR7BxM2Ef7uaenq8Y+w8nxSXor07S9bnJu8DVA2Zl5nG96lalkKxypLtiy5CmEs
         ulBbkTKRnZqfjbdE4svnUuiSfe10US5vbqOiJDiyDJOhwIwZ9O9ganX6RfbiBkqpbLpW
         jFuK52vsgimFBwl/wqz4y94lCxmQP9ilvr+0/OFDTQ7l5CIfrfo06qG186LfRvs9D5hk
         o+cxmfS3Rvzi7btLBPPKO1aURn0fyP9LI++KpSwmhfjQ2XmgWS96oardbAbobQheF4n0
         UaMvehJzs3PKT+Urw0/WQVh61osGgtBCGKc4jzETI3Mfvk+tUQkmj4ynx4X1pGFhpKan
         M2Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o+sow5wxNZdtv/L0uGDR7GrBdlDuvFkYP55JUcWV34M=;
        b=FpSopeVQTaAQyf22JforAkvWmnImxrkL1PtUcCt+UfOY0cUrDVrVmAr+h6kn3WPzi+
         a3S7pUZadFDxEsvAg5iJzKGK7kUxsQT2NgJ2Hg1zLD5jDv+ylI5vAgzR+/bKHdDZbwrY
         x4ZLRsoPtsI0dCdq8ZLDeGBjNOKRb5BAAETbpKhU36zOUjl19dza2h4MlIf/dRX4CkrO
         TNScwzO47snFKyBaOm5umaXiaBjSYnsoOx/9FiWgAmxb7Ajk59uqiIxyr7vv+ShfIRQV
         yXZ1KmRsv42KWuE34PP/izjvM5JW/t1rLz2fCAa3pDYxNvxYsQTDaBZCGb7iDlfzVL2m
         slsA==
X-Gm-Message-State: APjAAAXA2TM1pEVY7t/zmKzwOA5Iq6SB/X2FZAiyjCNiGc7KZ2NRY/4Q
        V9SNHpISkz6JLKPCSBaE8xSskz88
X-Google-Smtp-Source: APXvYqxbdGkH+W8KITVj9N4GRuKyKEPK0WjwBct1ALh5sHyuWNw33zHFmP9Lyhiiw99eFC1rFlIyRA==
X-Received: by 2002:a17:902:7481:: with SMTP id h1mr4368071pll.126.1571758233634;
        Tue, 22 Oct 2019 08:30:33 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id z63sm6066128pgb.75.2019.10.22.08.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 08:30:32 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] crypto: caam - populate platform devices last
Date:   Tue, 22 Oct 2019 08:30:13 -0700
Message-Id: <20191022153013.3692-7-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191022153013.3692-1-andrew.smirnov@gmail.com>
References: <20191022153013.3692-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move the call to devm_of_platform_populate() at the end of
caam_probe(), so we won't try to add any child devices until all of
the initialization is finished successfully.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/ctrl.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 0540df59ed8a..d7c3c3805693 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -747,12 +747,6 @@ static int caam_probe(struct platform_device *pdev)
 #endif
 	}
 
-	ret = devm_of_platform_populate(dev);
-	if (ret) {
-		dev_err(dev, "JR platform devices creation error\n");
-		return ret;
-	}
-
 	ring = 0;
 	for_each_available_child_of_node(nprop, np)
 		if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
@@ -905,7 +899,12 @@ static int caam_probe(struct platform_device *pdev)
 	debugfs_create_blob("tdsk", S_IRUSR | S_IRGRP | S_IROTH, ctrlpriv->ctl,
 			    &ctrlpriv->ctl_tdsk_wrap);
 #endif
-	return 0;
+
+	ret = devm_of_platform_populate(dev);
+	if (ret)
+		dev_err(dev, "JR platform devices creation error\n");
+
+	return ret;
 }
 
 static struct platform_driver caam_driver = {
-- 
2.21.0

