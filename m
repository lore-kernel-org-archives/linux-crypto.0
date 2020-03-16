Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CC0C0044D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 06:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB63B20674
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 06:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbgCPGD5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 02:03:57 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:12453 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbgCPGD5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 02:03:57 -0400
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02G63bvK002765;
        Sun, 15 Mar 2020 23:03:47 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     manojmalviya@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH Crypto 1/2] chcr: Fixes a hang issue during driver registration
Date:   Mon, 16 Mar 2020 11:33:17 +0530
Message-Id: <20200316060318.20896-2-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.26.0.rc1.11.g30e9940
In-Reply-To: <20200316060318.20896-1-ayush.sawal@chelsio.com>
References: <20200316060318.20896-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This issue occurs only when multiadapters are present.Hang
happens because assign_chcr_device returns u_ctx pointer of
adapter which is not yet initialized as for this adapter cxgb_up
is not been called yet.

The last_dev pointer is used to determine u_ctx pointer and it
is initialized two times in chcr_uld_add in chcr_dev_add respectively.

The fix here is don't initialize the last_dev pointer during
chcr_uld_add. Only assign to value to it when the adapter's
initialization is completed i.e in chcr_dev_add.

Fixes: fef4912b66d62 ("crypto: chelsio - Handle PCI shutdown event")
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/crypto/chelsio/chcr_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index 6e02254c007a..850a3f4e837b 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -125,8 +125,6 @@ static void chcr_dev_init(struct uld_ctx *u_ctx)
 	atomic_set(&dev->inflight, 0);
 	mutex_lock(&drv_data.drv_mutex);
 	list_add_tail(&u_ctx->entry, &drv_data.inact_dev);
-	if (!drv_data.last_dev)
-		drv_data.last_dev = u_ctx;
 	mutex_unlock(&drv_data.drv_mutex);
 }
 
-- 
2.26.0.rc1.11.g30e9940

