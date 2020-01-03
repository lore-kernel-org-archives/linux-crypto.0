Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F4DC2D0CE
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 496AF222C3
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgACE5p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:57:45 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:30523 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgACE5p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:57:45 -0500
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0034vXaX002388;
        Thu, 2 Jan 2020 20:57:34 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [Crypto/chcr] Resetting crypto counters during the driver unregister
Date:   Fri,  3 Jan 2020 10:26:51 +0530
Message-Id: <1578027411-32239-1-git-send-email-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/crypto/chelsio/chcr_core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index 029a735..533c37d 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -132,8 +132,6 @@ static void chcr_dev_init(struct uld_ctx *u_ctx)
 
 static int chcr_dev_move(struct uld_ctx *u_ctx)
 {
-	struct adapter *adap;
-
 	 mutex_lock(&drv_data.drv_mutex);
 	if (drv_data.last_dev == u_ctx) {
 		if (list_is_last(&drv_data.last_dev->entry, &drv_data.act_dev))
@@ -146,8 +144,6 @@ static int chcr_dev_move(struct uld_ctx *u_ctx)
 	list_move(&u_ctx->entry, &drv_data.inact_dev);
 	if (list_empty(&drv_data.act_dev))
 		drv_data.last_dev = NULL;
-	adap = padap(&u_ctx->dev);
-	memset(&adap->chcr_stats, 0, sizeof(adap->chcr_stats));
 	atomic_dec(&drv_data.dev_count);
 	mutex_unlock(&drv_data.drv_mutex);
 
@@ -299,17 +295,21 @@ static int __init chcr_crypto_init(void)
 static void __exit chcr_crypto_exit(void)
 {
 	struct uld_ctx *u_ctx, *tmp;
-
+	struct adapter *adap;
+	
 	stop_crypto();
-
 	cxgb4_unregister_uld(CXGB4_ULD_CRYPTO);
 	/* Remove all devices from list */
 	mutex_lock(&drv_data.drv_mutex);
 	list_for_each_entry_safe(u_ctx, tmp, &drv_data.act_dev, entry) {
+		adap = padap(&u_ctx->dev);
+		memset(&adap->chcr_stats, 0, sizeof(adap->chcr_stats));
 		list_del(&u_ctx->entry);
 		kfree(u_ctx);
 	}
 	list_for_each_entry_safe(u_ctx, tmp, &drv_data.inact_dev, entry) {
+		adap = padap(&u_ctx->dev);
+		memset(&adap->chcr_stats, 0, sizeof(adap->chcr_stats));
 		list_del(&u_ctx->entry);
 		kfree(u_ctx);
 	}
-- 
1.8.3.1

