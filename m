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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EEE5C43461
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 09:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C71F3221EB
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 09:53:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ey+mNbeC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgIKJx6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Sep 2020 05:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgIKJxz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Sep 2020 05:53:55 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D525EC061573;
        Fri, 11 Sep 2020 02:53:54 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s65so5210070pgb.0;
        Fri, 11 Sep 2020 02:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8V0xBW7DTj25tKrCkSmr/DtXLxDvaz2DIFrG4wH1eVo=;
        b=Ey+mNbeCTGY96r1CKzPPi32hOjx2VLgLJRjWik6lrEOnatSNRNzRlAuyWB4R6M6c61
         yUpAAr249xov8mWH64Scr+XgVY/0oQf0bUDtzf/rkIRnQ+7sY8IRmBwgUU7zZ7zI2Dg1
         8L01CCSPtkV3qmMgZaXrWJZvjHCka1LkKFGi4Z0kTfbgUrEIRoTG+zF+V6bu9Ew8R0cN
         1S+yoK+yzA9HHMEsiwYhEcL6iN2MYX2TaSEHI3HBMT77kvOpP5DuM4VRwAvNvDuly4NP
         z6uICgdESJtQ5RMM6N/uPUoHdzkO/0+YKKvP5gnlBZq6fWdReGIwR8MattrFGzrFohwU
         1ecg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8V0xBW7DTj25tKrCkSmr/DtXLxDvaz2DIFrG4wH1eVo=;
        b=MtlgBais9YduR6rtZQwuPQGXtGlg9WLj1Evwz1MBs13S+npl3lc08G2ipBnxH5EJVB
         9DGgTDaj+VnJZPA9kZeaF7rkXzQVWI8ptKXkW7W6XptdXCLRXJLleOFHTWiB6qgGn1xO
         FaYw49pX4aVIBpwt8nB8Nk66je/oJnhlpljsOg+XXQo7bLMx1awHU8ChyBGn8sSC2mpg
         0TTRHb9cBz2sI+gr1skE7IKU/IU+G07Rwhn6kuKB6edtwhXYPkwIYkEbSYFF6+Dwyl2c
         QLjtVIGwB5Z6Gg9BpzqkTwEIvUg890DC4LE6J90zHZzgII8rjMeAnivdLt77k6cPRYs9
         EQiQ==
X-Gm-Message-State: AOAM5307jNKWJh5PGZ/kOuOJYTOg1jgpj2DBQdHrYjCFASdrnkS62kgM
        CAnFEYvD9IrEs/4mze/wAGs=
X-Google-Smtp-Source: ABdhPJxCsui9XwpDxJW4IYUX9m1QTPkEGom9uMzfEqjjpfE8pSptXn91LdbbhAqmuFXKXyC7G7Wq+Q==
X-Received: by 2002:a62:cecb:: with SMTP id y194mr1420782pfg.106.1599818032695;
        Fri, 11 Sep 2020 02:53:52 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-52-163-24.us-west-1.compute.amazonaws.com. [13.52.163.24])
        by smtp.gmail.com with ESMTPSA id x4sm1790158pff.57.2020.09.11.02.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 02:53:52 -0700 (PDT)
From:   Xiaoliang Pang <dawning.pang@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        matthias.bgg@gmail.com, swboyd@chromium.org, yuehaibing@huawei.com,
        tianjia.zhang@linux.alibaba.com, ryder.lee@mediatek.com
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        dawning.pang@gmail.com
Subject: [PATCH v5] cypto: mediatek - fix leaks in mtk_desc_ring_alloc
Date:   Fri, 11 Sep 2020 17:53:39 +0800
Message-Id: <20200911095339.9970-1-dawning.pang@gmail.com>
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
index 7e3ad085b5bd..f83cead30d8f 100644
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
+	} while (i--);
 	return err;
 }
 
-- 
2.17.1

