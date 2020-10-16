Return-Path: <SRS0=63hd=DX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F607C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Oct 2020 08:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09D6620663
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Oct 2020 08:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405226AbgJPIzJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Oct 2020 04:55:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15304 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405225AbgJPIzJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Oct 2020 04:55:09 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 75BA238663DEA170B9E6;
        Fri, 16 Oct 2020 16:54:58 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 16 Oct 2020
 16:54:54 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH -next] crypto: omap-aes - fix the reference count leak of omap device
Date:   Fri, 16 Oct 2020 17:05:36 +0800
Message-ID: <20201016090536.27477-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

pm_runtime_get_sync() will increment  pm usage counter even
when it returns an error code. We should call put operation
in error handling paths of omap_aes_hw_init.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 drivers/crypto/omap-aes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 4fd14d90cc40..70ea5784a024 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -105,6 +105,7 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
 
 	err = pm_runtime_get_sync(dd->dev);
 	if (err < 0) {
+		pm_runtime_put_noidle(dd->dev);
 		dev_err(dd->dev, "failed to get sync: %d\n", err);
 		return err;
 	}
-- 
2.17.1

