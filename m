Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C8DCCA486
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 14:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbiF3OhM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 10:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237183AbiF3Ogz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 10:36:55 -0400
Received: from mail-m973.mail.163.com (mail-m973.mail.163.com [123.126.97.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 503791AF23;
        Thu, 30 Jun 2022 07:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=h5I54
        kNsTH2s2ciOHexU+iZ2FEzVCsqPdcPCraazqQE=; b=k8mK5acHl6BxS0WeZ+zlm
        7RGujFIQVV/Z0t4Z+Eogm/b1syR4ekTjLKHf6oHPYaBn5x+6Ly/X0UA5TIPjo1aY
        rDo4rEiF1qaSRJb3syij1USHKvDzVB8SiCXcQdbtgONeJa7rk6BfBW+RvpmBYxAI
        YjNl7erT6ehR/5LBACporY=
Received: from localhost.localdomain (unknown [123.112.69.106])
        by smtp3 (Coremail) with SMTP id G9xpCgCHJJbFs71ikcHHMg--.62175S4;
        Thu, 30 Jun 2022 22:31:53 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] crypto: hisilicon/sec - fix inconsistent argument
Date:   Thu, 30 Jun 2022 22:31:32 +0800
Message-Id: <20220630143132.2180469-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: G9xpCgCHJJbFs71ikcHHMg--.62175S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrKFykXrWDAw13urWruF1fXrb_yoWDJFg_ua
        yUCF13Zr4UGw4qqw17tFZYvF1Yvw1rWF1fZF43try3t3yqvr4YgF1rZrs8CF4UC3yj9ryY
        9ws7Gw18ZFyUWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRZYFCPUUUUU==
X-Originating-IP: [123.112.69.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/xtbBORkwjF-POQcyywAAsL
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The argument passed to sec_queue_aw_alloc() should be
SEC_QUEUE_AW_FROCE_NOALLOC instead of SEC_QUEUE_AR_FROCE_NOALLOC.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/crypto/hisilicon/sec/sec_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_drv.c b/drivers/crypto/hisilicon/sec/sec_drv.c
index c8de1b51c843..e75851326c1e 100644
--- a/drivers/crypto/hisilicon/sec/sec_drv.c
+++ b/drivers/crypto/hisilicon/sec/sec_drv.c
@@ -892,7 +892,7 @@ bool sec_queue_can_enqueue(struct sec_queue *queue, int num)
 static void sec_queue_hw_init(struct sec_queue *queue)
 {
 	sec_queue_ar_alloc(queue, SEC_QUEUE_AR_FROCE_NOALLOC);
-	sec_queue_aw_alloc(queue, SEC_QUEUE_AR_FROCE_NOALLOC);
+	sec_queue_aw_alloc(queue, SEC_QUEUE_AW_FROCE_NOALLOC);
 	sec_queue_ar_pkgattr(queue, 1);
 	sec_queue_aw_pkgattr(queue, 1);
 
-- 
2.25.1

