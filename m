Return-Path: <SRS0=QXJz=CX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E53C43461
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 03:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57434221E3
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 03:01:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DvJv456x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgINDBb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Sep 2020 23:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgINDBa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Sep 2020 23:01:30 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D404FC06174A;
        Sun, 13 Sep 2020 20:01:29 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g29so10380873pgl.2;
        Sun, 13 Sep 2020 20:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lyLNdA4xrXocOcTdyl66Bfsi09lJXmV7xTXnFfeHCDE=;
        b=DvJv456xq70FIh5msQ6QNCM81uLc+IEpVUr7p8Swoi4KEfwBDw43z0YQ7OXV5eZsFy
         zfyrMccjxhHJJgYVDU6ueLCfDi5lCCouphN1wGJDoybglGNNjMbgqFu1agaUco4gTYIw
         7xWxzXfocqvrs7PNrvjZ58oTNFa2IMxwgh+aZCxCpVQFToaYBbq+n6I8QgNJDLhctyzo
         Pm6du+DSKZuoEQitd0etqJHqXABXx+mpirdd+b+XsUgqj+LnS9afJpZt+IOFxa5zgpyl
         ZC7YgLKK9UCx6RkmytedEA0OFAcyFles175yeSZgfVTTg3v3gyp7fSs/CjIbCKR9J90h
         +nxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lyLNdA4xrXocOcTdyl66Bfsi09lJXmV7xTXnFfeHCDE=;
        b=NCGZZuwxCS2byOenin87/pE84RDYW6183F29UrlzJ39f4GDd8bPQVk1vUImfgUyQVN
         B/LsG8gXLhGjRA+pmlZVfueKrb4t8WeRGrZJEz4sc3l8S9B7p1oGB4RIOoH7QT5/7jkm
         6BZLzccm5Xf19JCKxp90IblLIcI05Zd0r28ZfhxzWDfd+E+tLa4VK2NjT8Xf8a2A7poQ
         6816meNM2Bo6UVWKMYm3MhMgOeFCz0o2MH8aqsnp05cunUYAhJ+JKjBRLKgQBrf+kbrN
         02WYkbqK5mmOmasP8a3h2e9063iQG4ba2Y6u/0bJVsRmCJFqwCO+12Qq86b1h7ry+TY0
         AOcg==
X-Gm-Message-State: AOAM532itk/3//VeHF/AON/b90oloM2KC/8xc9O1nX2wqDEVukm4kggT
        gUWxPJxBADsRICv8ROeadTU=
X-Google-Smtp-Source: ABdhPJyQG67+KJ6O9daScNbPgx0CN+jeuxOa0ZZSYpf4iwF5/ESDGcgFhCq5LDsJIhUz8X4B23YV/Q==
X-Received: by 2002:a17:902:9f86:: with SMTP id g6mr11822108plq.32.1600052489155;
        Sun, 13 Sep 2020 20:01:29 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-52-163-24.us-west-1.compute.amazonaws.com. [13.52.163.24])
        by smtp.gmail.com with ESMTPSA id z18sm8474265pfn.186.2020.09.13.20.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2020 20:01:28 -0700 (PDT)
From:   Xiaoliang Pang <dawning.pang@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        matthias.bgg@gmail.com, swboyd@chromium.org, yuehaibing@huawei.com,
        tianjia.zhang@linux.alibaba.com, ryder.lee@mediatek.com
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        dawning.pang@gmail.com
Subject: [PATCH v6] cypto: mediatek - fix leaks in mtk_desc_ring_alloc
Date:   Mon, 14 Sep 2020 11:00:51 +0800
Message-Id: <20200914030051.16956-1-dawning.pang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In the init loop, if an error occurs in function 'dma_alloc_coherent',
then goto the err_cleanup section, after run i--,
in the array ring, the struct mtk_ring with index i will not be released,
causing memory leaks

Fixes: 785e5c616c849 ("crypto: mediatek - Add crypto driver support for some MediaTek chips")
Cc: Ryder Lee <ryder.lee@mediatek.com>
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

