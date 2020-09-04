Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A60D9C28E83
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 09:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F7F7205CB
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 09:42:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gAzMbl9T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729975AbgIDJm6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 05:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729731AbgIDJmx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 05:42:53 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2316FC061244;
        Fri,  4 Sep 2020 02:42:52 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d19so4040066pgl.10;
        Fri, 04 Sep 2020 02:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=k2pP6uCXGE3hf4kIKSJ0TViSAKe2ZDHRqtthemQoyUE=;
        b=gAzMbl9TqqnXyIRD4TGx12WtzlcUX32PTT1eW7BqLXqe/HdTdxT+emMOtGKKg2tS3H
         jFqZlQ5OqWNgNqx+/n7a4Q7Te6jcGhHPYbSig/rg2q5PObd6SajiemVm3ewlGqpfu644
         5Blfjst9QQT95RzWlLfk9rJvA94vL8w91xs3/BfC+cs37CHNKHlvmbiRivIvL6icBMYZ
         JCrLsfugmAhujtWhAVmimv1MhdKlmKFUmobeCz/rdamM0xqc2Ggn0qP5zHOi6nfqCp95
         yhOTIjgyy9U+EiWIZUcO0Vvsm3M+xsIAlm2y1B/5Ok9NgAQ0PLF8eHwBNjoTR2+EB6oE
         5RVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=k2pP6uCXGE3hf4kIKSJ0TViSAKe2ZDHRqtthemQoyUE=;
        b=quzCPOGu3tOzjrB21MDjEy5l8e6bFxA+/c71ALk/bM+C7QhrEqzyEgbdGPjDdpz5VA
         5ftspYFE3GMvadFttzfZUUQGF4KAQq6lvzNenqyDtS4pMkZp8sXzovW53hke0O7+6Xd6
         Iju5CRJhlZ5i89UDNjd8/D6WBMiRKUnjm5namghZtuVh4t1DbT/ajZSdLR9jXgfxyMZE
         /vS1cf9b/N0a60wpsp03XrIvGiu07r+6hG8CEL3MjmkM5Pc3dPqfeBuL1WAJ0akiMfjt
         n6GH8/fJ3MGxhJJZBfY1m0P15M5yt9mhb9C12Cew1dI/k8rHhjxNNujNiOfCksKhSxqo
         46ZQ==
X-Gm-Message-State: AOAM532rAxdYHml6QQZNBNxorXy8rOdSerK3ww5biS4ZylmaSHZfj3v3
        zswWfqB6cUtrPl5iLEIh1wI=
X-Google-Smtp-Source: ABdhPJxL3L6K5Vdob33AgTHPTkGlZCq/T3PVfZsknGNaQ4ivB+nB3Am35D+EDOqj9Yl1PfZqpKP8Eg==
X-Received: by 2002:aa7:8010:: with SMTP id j16mr7428036pfi.210.1599212571903;
        Fri, 04 Sep 2020 02:42:51 -0700 (PDT)
Received: from localhost.localdomain ([218.247.215.252])
        by smtp.gmail.com with ESMTPSA id a7sm6256342pfd.194.2020.09.04.02.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 02:42:51 -0700 (PDT)
From:   Xiaoliang Pang <dawning.pang@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        matthias.bgg@gmail.com, swboyd@chromium.org, yuehaibing@huawei.com,
        tianjia.zhang@linux.alibaba.com, ryder.lee@mediatek.com
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        dawning.pang@gmail.com
Subject: [PATCH v2] cypto: mediatek - fix leaks in mtk_desc_ring_alloc
Date:   Fri,  4 Sep 2020 17:42:33 +0800
Message-Id: <20200904094233.11624-1-dawning.pang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In the init loop, if an error occurs in function 'dma_alloc_coherent',
then goto the err_cleanup section,
in the cleanup loop,
the struct mtk_ring rising[i] will not be released,
causing a memory leak

Signed-off-by: Xiaoliang Pang <dawning.pang@gmail.com>
---
 drivers/crypto/mediatek/mtk-platform.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-platform.c b/drivers/crypto/mediatek/mtk-platform.c
index 05d341e4a696..ebb3bdef0dbe 100644
--- a/drivers/crypto/mediatek/mtk-platform.c
+++ b/drivers/crypto/mediatek/mtk-platform.c
@@ -469,13 +469,13 @@ static int mtk_desc_ring_alloc(struct mtk_cryp *cryp)
 	return 0;
 
 err_cleanup:
-	for (; i >= 0; --i) {
+	do {
 		dma_free_coherent(cryp->dev, MTK_DESC_RING_SZ,
 				  ring[i]->res_base, ring[i]->res_dma);
 		dma_free_coherent(cryp->dev, MTK_DESC_RING_SZ,
 				  ring[i]->cmd_base, ring[i]->cmd_dma);
 		kfree(ring[i]);
-	}
+	}while(i--);
 	return err;
 }
 
-- 
2.17.1

