Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C281BC3A5A2
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B9F822DBF
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:35:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SMUxmMqA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbfIDCfq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 22:35:46 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46463 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbfIDCfp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 22:35:45 -0400
Received: by mail-pl1-f195.google.com with SMTP id t1so594139plq.13;
        Tue, 03 Sep 2019 19:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+aCoTyAZq4seXeFgHdkNVujIOOXIGfZdUZjUTxRnOZM=;
        b=SMUxmMqAIY1WN9/3k3mlL3l2Yzd7jJU5ppxBEG6GWDsenDmSo01JOxBFxRCSK5ahuT
         zorODh4g8Ff4lDs+tV4BjCYQPoK3YRgnV+NQKJsUnyO367EI5EJA6tMKO352upN5KNyD
         4/f1Hgu24ZwdZBLWCbihDXjyRhKV8DFHP5C19rUOpYwbj3U26Vu9en4exETIT6MpvZiy
         f398GEo6QASN1nddxrFHjeeEqIlVlvvEowtbOAf/WSi59gZ3OrHrEEcRUE5QT63qhsIB
         AznOzCQo5RX3YP4FwFMCaSe5h3jLgTVMZTHPMqGdbjGKXcstczSCPzEtCsWlcXHpGpm8
         Sbaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+aCoTyAZq4seXeFgHdkNVujIOOXIGfZdUZjUTxRnOZM=;
        b=kpiBHlzdI+y2hFS/DudV54SACtuuP81ZrrQFlt8nTa0iEoK7tI9uk9361aSzQ+tTnk
         GGHPAVSG1GuMcL/ZXNJNdq36hIX6PofWvx2R0K6qzbIbc5gRIGK0JEdW4hzX0xLDrYMb
         T8sxvdyjosvK7rKj72ASDS1pc8GgUD+EsvCY5AtRptub0fAkvQ3qWOO+Rb9tpha62NUT
         W6bexUWxBJ/SEJbgIdCN3IkglR68p6d9GRDXagFQA1P/6f+aAZBtMlhPt69HGbNO+OSc
         fL+PtlMUYMCZYw1CfbheKdTDixzbgSrx5MtC87fQd+a79txNf9mJUUUlihiVACE7IcVg
         c4Eg==
X-Gm-Message-State: APjAAAUdrGRZWpo6AKME4p1WDUzCUhCnUffup/Xk7JAWubD0VrES2l12
        kryOSrSEhWMRcRUZlU5gL5lOCUG9lAI=
X-Google-Smtp-Source: APXvYqydA6JXAS/WhUxQ3k++ihkagpTBo4PkpFPjs+D1DpDP+ZvmTu8rQyRF7N6qvhN+KBr3FYuZAw==
X-Received: by 2002:a17:902:9686:: with SMTP id n6mr37418102plp.113.1567564544354;
        Tue, 03 Sep 2019 19:35:44 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id i74sm7480250pfe.28.2019.09.03.19.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 19:35:43 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] crypto: caam - populate platform devices last
Date:   Tue,  3 Sep 2019 19:35:13 -0700
Message-Id: <20190904023515.7107-11-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904023515.7107-1-andrew.smirnov@gmail.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
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
 drivers/crypto/caam/ctrl.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 4a84c2701311..d101c28d3d1f 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -748,12 +748,6 @@ static int caam_probe(struct platform_device *pdev)
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
@@ -906,6 +900,13 @@ static int caam_probe(struct platform_device *pdev)
 	debugfs_create_blob("tdsk", S_IRUSR | S_IRGRP | S_IROTH, ctrlpriv->ctl,
 			    &ctrlpriv->ctl_tdsk_wrap);
 #endif
+
+	ret = devm_of_platform_populate(dev);
+	if (ret) {
+		dev_err(dev, "JR platform devices creation error\n");
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.21.0

