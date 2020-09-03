Return-Path: <SRS0=A9EK=CM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B23CC433E2
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 06:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E388206EB
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 06:38:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DjWvBbFY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgICGiU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Sep 2020 02:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgICGiS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Sep 2020 02:38:18 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA0BC061244;
        Wed,  2 Sep 2020 23:38:18 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id e33so1325018pgm.0;
        Wed, 02 Sep 2020 23:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JzV2OCqdKiJejSLxD4j9h8uaxc1ywBPDynMdu8MGQD4=;
        b=DjWvBbFYKTwUUrwMgdbDVts6nrIF8n3LkmmGUcaTH6wk12ytUSDtsZbPyPNZ7KhN0f
         BrB1VJ4PEHIvsRS6C9N2moXz/bDtABmEyI3AN4Nt6Yp91seZ5xzZmjU/cfyK4x26Dsw+
         bU7Zwt6alhzP2UPw44N2BYQugdPZtbIw1HkAhXu50B+589L36cVRG9L/zQQEoVlH1hH8
         sD7UCa+ohys2MGiDwRKvy/xmF54NLOiSwGmHaKLi8NmK0zKrXjKe6iAn85M4ELq4CwM1
         gdCLz/M2tozNB8PHn8c+Krhkcve81QtjPMp8JNJ/NAURYpCDvdkLGY/Fk/THyWnsJe/z
         NieQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JzV2OCqdKiJejSLxD4j9h8uaxc1ywBPDynMdu8MGQD4=;
        b=T3V+1MFICDl3q1+So/L9ZxAdPAecFlG3MZT102YlrmPuUg8a5CSc+8mVw10o9CIiYA
         tQ15Tx5DPHuV7L1QUPnIY9G+h9fu5StUcO4PvoMFkAfQW2LgpREfteTU0CAuEAV+3DCz
         xyOoYy7xNzfc4b+yZLC6DaO0zTxjumZ1/E/v8nJYVtn3GkZkYQSTLggXRtHNu4PGxkIS
         mhvIugZnAHs+YeiAWm0xpo9vGwLqINWLxgqF2lnlv8BGCiMt2HnuGrkhnVk29HaMf/Gl
         q2ClVyu0QLQ3PzkcRAgtdqUT7ffCq0E9JFnHxsVpioMBK69LC054shMspLnuoZQwuO+z
         VI0w==
X-Gm-Message-State: AOAM532Xp0sry40UI5ZnORG14FYJviQY9zh20p9U4EbOBMSoyWdDOsdz
        jzSnkCOnkYjAfSSJHsUI2yI=
X-Google-Smtp-Source: ABdhPJwvJwxeHbddcSMcrw6WNHCMlw8KxZuhNo8a0SYjKuYQMzszVqwi+fMa7X3GuTG5ROpaCUGtqQ==
X-Received: by 2002:a63:8448:: with SMTP id k69mr1697129pgd.69.1599115097868;
        Wed, 02 Sep 2020 23:38:17 -0700 (PDT)
Received: from localhost.localdomain ([218.247.215.252])
        by smtp.gmail.com with ESMTPSA id e123sm1754835pfh.167.2020.09.02.23.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 23:38:17 -0700 (PDT)
From:   Xiaoliang Pang <dawning.pang@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        matthias.bgg@gmail.com, swboyd@chromium.org, yuehaibing@huawei.com,
        tianjia.zhang@linux.alibaba.com, ryder.lee@mediatek.com
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        dawning.pang@gmail.com
Subject: [PATCH] cypto: mediatek - fix leaks in mtk_desc_ring_alloc
Date:   Thu,  3 Sep 2020 14:38:00 +0800
Message-Id: <20200903063800.27288-1-dawning.pang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In the init loop, if an error occurs in function 'dma_alloc_coherent',
then goto the err_cleanup section,
in the cleanup loop, after run i--, 
the struct mtk_ring rising[i] will not be released,
causing a memory leak

Signed-off-by: Xiaoliang Pang <dawning.pang@gmail.com>
---
 drivers/crypto/mediatek/mtk-platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/mediatek/mtk-platform.c b/drivers/crypto/mediatek/mtk-platform.c
index 7e3ad085b5bd..05d341e4a696 100644
--- a/drivers/crypto/mediatek/mtk-platform.c
+++ b/drivers/crypto/mediatek/mtk-platform.c
@@ -469,7 +469,7 @@ static int mtk_desc_ring_alloc(struct mtk_cryp *cryp)
 	return 0;
 
 err_cleanup:
-	for (; i--; ) {
+	for (; i >= 0; --i) {
 		dma_free_coherent(cryp->dev, MTK_DESC_RING_SZ,
 				  ring[i]->res_base, ring[i]->res_dma);
 		dma_free_coherent(cryp->dev, MTK_DESC_RING_SZ,
-- 
2.17.1

