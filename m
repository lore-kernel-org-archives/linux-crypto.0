Return-Path: <SRS0=Quof=CU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7290C43461
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 09:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A25C21D40
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 09:43:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="unk6p8hI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725784AbgIKJnw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Sep 2020 05:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgIKJnr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Sep 2020 05:43:47 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5351AC061573;
        Fri, 11 Sep 2020 02:43:47 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b124so6868748pfg.13;
        Fri, 11 Sep 2020 02:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bJ0up8YgWBaqrOdwt3l9bHaiRijlj1VCPYtRtI0qJWc=;
        b=unk6p8hIjiC+Xy2cAWNQ+FwnWVQAXbmC2you+SpVd20dAZ8obZsGYAQKCVaBSy9OK8
         JHyRT7E1tmBScUZyoFBeLii2fRjIqhakeCWOXcUinoFh+ynxxZUL/tYQxwk415PHubz5
         DxORYp3zBkfOQZyQgoB88jOq5BqZPYT74hLwwpIp8mysWpJjKRbhhhjTx5/fWnfqkYQ1
         IkQbhTp6wRcLrLpzAKmOjUUrwVDb4nLuLejV1X0Cob877LGwJ4G+hulP1JyMtWg3/S3O
         IwRbIzxKRKqnv0d+ZDTM4OJIQD/VzFo3nCEJBc4Uxs/GQG9cXZdajJXQ3jfX6Ar+2Aiq
         zfdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bJ0up8YgWBaqrOdwt3l9bHaiRijlj1VCPYtRtI0qJWc=;
        b=d2TUqokFq6AuVlwb1NbNPeXWfTZdk3qU6ufwNyN5sDBGRBj0ZOFcHbZfPY8cFkn/XR
         oCwfCPuV4UyypTpiFAVpRFYaTi5Y+sIQCNZUOAnPvrS6aVRn/XCQ/oGUV5GpBGh6eCg5
         rIQd5fET1Aozv5sa6O9UmjEaZVD1PdxLYxes9RGTpEAjQOvW/6rEkqhfoNbWLKhjmTWG
         OVWXjz74pU83GEzG2db7RSMoa7+VBUa6EOTS8BhJsThWuFTTv9UP692KI83ReDUvNEx1
         QE30r+TkLqWJ6TnLaPO9hTAkVpSKrxRj41092317FK9LkMNeTKqHoGGJpa5mMkLi5LtT
         qP5g==
X-Gm-Message-State: AOAM532pu6uPt4Tvo+PBhLPwrsGvx5FIBcUOScx6hGqLNwRRqjTtPkJY
        5GuzQe5vZ5LLBdhaDw7JYV4=
X-Google-Smtp-Source: ABdhPJzXu4H8xGMfnslGYi4xCEqJAOoGiXoEoV4zSW7z85Vk/I/jabX/VAiG8RfZGqqR9EPj9C9Ltw==
X-Received: by 2002:a17:902:7fc7:: with SMTP id t7mr1208270plb.159.1599817426171;
        Fri, 11 Sep 2020 02:43:46 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-52-163-24.us-west-1.compute.amazonaws.com. [13.52.163.24])
        by smtp.gmail.com with ESMTPSA id h35sm1477260pgl.31.2020.09.11.02.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 02:43:45 -0700 (PDT)
From:   Xiaoliang Pang <dawning.pang@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        matthias.bgg@gmail.com, swboyd@chromium.org, yuehaibing@huawei.com,
        tianjia.zhang@linux.alibaba.com, ryder.lee@mediatek.com
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        dawning.pang@gmail.com
Subject: [PATCH v4] cypto: mediatek - fix leaks in mtk_desc_ring_alloc
Date:   Fri, 11 Sep 2020 17:43:33 +0800
Message-Id: <20200911094333.3584-1-dawning.pang@gmail.com>
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
 drivers/crypto/mediatek/mtk-platform.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-platform.c b/drivers/crypto/mediatek/mtk-platform.c
index 7e3ad085b5bd..654a6ba4bf17 100644
--- a/drivers/crypto/mediatek/mtk-platform.c
+++ b/drivers/crypto/mediatek/mtk-platform.c
@@ -469,13 +469,13 @@ static int mtk_desc_ring_alloc(struct mtk_cryp *cryp)
 	return 0;
 
 err_cleanup:
-	for (; i--; ) {
+	do {
 		dma_free_coherent(cryp->dev, MTK_DESC_RING_SZ,
 				  ring[i]->res_base, ring[i]->res_dma);
 		dma_free_coherent(cryp->dev, MTK_DESC_RING_SZ,
 				  ring[i]->cmd_base, ring[i]->cmd_dma);
 		kfree(ring[i]);
-	}
+	} while(i--);
 	return err;
 }
 
-- 
2.17.1

