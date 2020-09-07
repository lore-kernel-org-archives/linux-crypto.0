Return-Path: <SRS0=lAP7=CQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 001C6C433E2
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 02:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2D3D20796
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 02:10:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VvJP719f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgIGCKG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Sep 2020 22:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgIGCKA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Sep 2020 22:10:00 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3740C061573;
        Sun,  6 Sep 2020 19:09:59 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y6so1316752plt.9;
        Sun, 06 Sep 2020 19:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tgNahNYZMXrtXJeygjsMjzSrNWcxFP6xVcE3T4mcxQI=;
        b=VvJP719f8QWQzVGJalFHZZYMi8hRnozPNRGRWB+0qU7ISvLSjCGN+kaeYEAfQnZMye
         bjBxceSghaxIqi/nyyaR3nXWPxV1PbwDkXMei2gv0ul7scY0lumpayZBugh0JyNG2v0a
         E9zi19sZFzKED0H+p7+/Ii7+5tLXkmr98qT73yjGOlcMugMDVwB0GXP0NILMXw76HsIz
         SbWfXuev6KtS/BWjoGCLbUkGb3JstMzNEcrKDrjBI/+T1xNc88VrtytQKO3ojGBu0Jv/
         fVSY2ncosrUc/vLxJh91fAxSqsedrjW089Mo0CUVgd92nuP8ULLigzCYxF2GiWoK+Nmz
         yWOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tgNahNYZMXrtXJeygjsMjzSrNWcxFP6xVcE3T4mcxQI=;
        b=LrfpscL5RweMvVmt76VgxNi9fLe/sNRJOlPla5dHjGtlRavFS5dGku8m8YDxPN5DuF
         H7TCBblsJ9KW4goOR0aJnPClOsHGTtepulRKziibHo1kVQmfWgqfVYAL9d8eets1WZW2
         EEBcYTQoELruX05J+KR394W6o0GdECMMjkcYX91IFT435ky++dflyRlhxfcYuYgRCna9
         T+yWTTHE2eK5/6Apg0bhMOu1FH9FaCApcIl5DfmQ3ECxMDvWEvsFVlcitTk9+WAg/K47
         7L9LAOpCT/WQaynAyISnJarQ25Rn0zfdlh/OZPud+WJDTbbMkPX0Ihb0zsvuFM4/WoLD
         UkQg==
X-Gm-Message-State: AOAM531s300EltZYFpsaB+ISENb4bcaOQvZ0uftK9jgnT+lfI9+aH/zG
        heXJArjoU/dceXaIp3pS6Rs=
X-Google-Smtp-Source: ABdhPJzL7EIeH3Kz/+E0cbeLhXES4APxDig/pgqS0vdAE0hr9pcBEymgTwUsjmk7EfzYu8WMVrFykg==
X-Received: by 2002:a17:902:ee0b:: with SMTP id z11mr17858138plb.268.1599444598464;
        Sun, 06 Sep 2020 19:09:58 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-52-163-24.us-west-1.compute.amazonaws.com. [13.52.163.24])
        by smtp.gmail.com with ESMTPSA id z23sm10531125pgv.57.2020.09.06.19.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2020 19:09:57 -0700 (PDT)
From:   Xiaoliang Pang <dawning.pang@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        matthias.bgg@gmail.com, swboyd@chromium.org, yuehaibing@huawei.com,
        tianjia.zhang@linux.alibaba.com, ryder.lee@mediatek.com
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        dawning.pang@gmail.com
Subject: [PATCH v3] cypto: mediatek - fix leaks in mtk_desc_ring_alloc
Date:   Mon,  7 Sep 2020 10:09:39 +0800
Message-Id: <20200907020939.6817-1-dawning.pang@gmail.com>
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
index 7e3ad085b5bd..ebb3bdef0dbe 100644
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
+	}while(i--);
 	return err;
 }
 
-- 
2.17.1

