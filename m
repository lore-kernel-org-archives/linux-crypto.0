Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6653C0044D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 06:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C38A520679
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 06:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729449AbgCPGEH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 02:04:07 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:41459 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbgCPGEH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 02:04:07 -0400
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02G63bvL002765;
        Sun, 15 Mar 2020 23:04:01 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     manojmalviya@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH Crypto 2/2] chcr: Fixes a deadlock between rtnl_lock and uld_mutex
Date:   Mon, 16 Mar 2020 11:33:18 +0530
Message-Id: <20200316060318.20896-3-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.26.0.rc1.11.g30e9940
In-Reply-To: <20200316060318.20896-1-ayush.sawal@chelsio.com>
References: <20200316060318.20896-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The locks are taken in this order during driver registration
(uld_mutex), at: cxgb4_register_uld.part.14+0x49/0xd60 [cxgb4]
(rtnl_mutex), at: rtnetlink_rcv_msg+0x2db/0x400
(uld_mutex), at: cxgb_up+0x3a/0x7b0 [cxgb4]
(rtnl_mutex), at: chcr_add_xfrmops+0x83/0xa0 [chcr](stucked here)

To avoid this now the netdev features are updated after the
cxgb4_register_uld is completed.

Fixes: 6dad4e8ab3ec6 ("chcr: Add support for Inline IPSec")
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/crypto/chelsio/chcr_core.c  | 32 ++++++++++++++++++++++++-----
 drivers/crypto/chelsio/chcr_ipsec.c |  2 --
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index 850a3f4e837b..7e24c4881c34 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -37,6 +37,10 @@ static chcr_handler_func work_handlers[NUM_CPL_CMDS] = {
 	[CPL_FW6_PLD] = cpl_fw6_pld_handler,
 };
 
+#ifdef CONFIG_CHELSIO_IPSEC_INLINE
+static void update_netdev_features(void);
+#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
+
 static struct cxgb4_uld_info chcr_uld_info = {
 	.name = DRV_MODULE_NAME,
 	.nrxq = MAX_ULD_QSETS,
@@ -200,10 +204,6 @@ static void *chcr_uld_add(const struct cxgb4_lld_info *lld)
 	}
 	u_ctx->lldi = *lld;
 	chcr_dev_init(u_ctx);
-#ifdef CONFIG_CHELSIO_IPSEC_INLINE
-	if (lld->crypto & ULP_CRYPTO_IPSEC_INLINE)
-		chcr_add_xfrmops(lld);
-#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
 out:
 	return u_ctx;
 }
@@ -281,6 +281,24 @@ static int chcr_uld_state_change(void *handle, enum cxgb4_state state)
 	return ret;
 }
 
+#ifdef CONFIG_CHELSIO_IPSEC_INLINE
+static void update_netdev_features(void)
+{
+	struct uld_ctx *u_ctx, *tmp;
+
+	mutex_lock(&drv_data.drv_mutex);
+	list_for_each_entry_safe(u_ctx, tmp, &drv_data.inact_dev, entry) {
+		if (u_ctx->lldi.crypto & ULP_CRYPTO_IPSEC_INLINE)
+			chcr_add_xfrmops(&u_ctx->lldi);
+	}
+	list_for_each_entry_safe(u_ctx, tmp, &drv_data.act_dev, entry) {
+		if (u_ctx->lldi.crypto & ULP_CRYPTO_IPSEC_INLINE)
+			chcr_add_xfrmops(&u_ctx->lldi);
+	}
+	mutex_unlock(&drv_data.drv_mutex);
+}
+#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
+
 static int __init chcr_crypto_init(void)
 {
 	INIT_LIST_HEAD(&drv_data.act_dev);
@@ -289,7 +307,11 @@ static int __init chcr_crypto_init(void)
 	mutex_init(&drv_data.drv_mutex);
 	drv_data.last_dev = NULL;
 	cxgb4_register_uld(CXGB4_ULD_CRYPTO, &chcr_uld_info);
-
+#ifdef CONFIG_CHELSIO_IPSEC_INLINE
+	rtnl_lock();
+	update_netdev_features();
+	rtnl_unlock();
+#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
 	return 0;
 }
 
diff --git a/drivers/crypto/chelsio/chcr_ipsec.c b/drivers/crypto/chelsio/chcr_ipsec.c
index 9da0f93a330b..9fd3b9d1ec2f 100644
--- a/drivers/crypto/chelsio/chcr_ipsec.c
+++ b/drivers/crypto/chelsio/chcr_ipsec.c
@@ -99,9 +99,7 @@ void chcr_add_xfrmops(const struct cxgb4_lld_info *lld)
 		netdev->xfrmdev_ops = &chcr_xfrmdev_ops;
 		netdev->hw_enc_features |= NETIF_F_HW_ESP;
 		netdev->features |= NETIF_F_HW_ESP;
-		rtnl_lock();
 		netdev_change_features(netdev);
-		rtnl_unlock();
 	}
 }
 
-- 
2.26.0.rc1.11.g30e9940

