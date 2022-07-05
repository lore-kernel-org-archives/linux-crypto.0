Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD4A1C43334
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 22:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiGEW7Z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 18:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiGEW7Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 18:59:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768941837D
        for <linux-crypto@vger.kernel.org>; Tue,  5 Jul 2022 15:59:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 105EA61D5C
        for <linux-crypto@vger.kernel.org>; Tue,  5 Jul 2022 22:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371ABC341C7;
        Tue,  5 Jul 2022 22:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657061963;
        bh=3sX1g1rhEZ4zGcTWfZ4sugct9Rmu06E0TzvplGJPXM0=;
        h=From:To:Cc:Subject:Date:From;
        b=RSIyu3u7nLo3QvvRktsEdHHXApMi93OdQuFF9dkWD5jCGjcT1Cu2h6dOLtMhiD918
         14YlCm+fkbcdwVEDld9woIOgBgaX5EBsMVB4I251iA3QmHtP2h/Ivay5wgEfUwe9Yn
         ik0RQH/kwHKu18EeNmsF3c5UlQ4WGs+wqAd+KoIWDvX7zDWfycwKJF77WGZUa/Uj/A
         OGwZkSOCpAsB+QN7sa1fz5zpn3QMgSvC+Hb8cHYgvdoLin4Sb4wvwjp9hUgX9ZpZMp
         2C6BWrMS6/g7/Glsm8D7iSEs7exQFCxHOt8XYaFcUKKqxlsan3VI0U/SU7RDnBH59P
         q0ZiWkPOK6SMw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     herbert@gondor.apana.org.au
Cc:     Jakub Kicinski <kuba@kernel.org>, horia.geanta@nxp.com,
        pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH crypto-next] crypto: caam/qi2 - switch to netif_napi_add_tx_weight()
Date:   Tue,  5 Jul 2022 15:58:57 -0700
Message-Id: <20220705225857.923711-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

caam has its own special NAPI weights. It's also a crypto device
so presumably it can't be used for packet Rx. Switch to the (new)
correct API.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: horia.geanta@nxp.com
CC: pankaj.gupta@nxp.com
CC: gaurav.jain@nxp.com
CC: herbert@gondor.apana.org.au
CC: linux-crypto@vger.kernel.org
---
 drivers/crypto/caam/caamalg_qi2.c | 5 +++--
 drivers/crypto/caam/qi.c          | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 6753f0e6e55d..56bbfdfb0d9f 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -5083,8 +5083,9 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 
 		ppriv->net_dev.dev = *dev;
 		INIT_LIST_HEAD(&ppriv->net_dev.napi_list);
-		netif_napi_add(&ppriv->net_dev, &ppriv->napi, dpaa2_dpseci_poll,
-			       DPAA2_CAAM_NAPI_WEIGHT);
+		netif_napi_add_tx_weight(&ppriv->net_dev, &ppriv->napi,
+					 dpaa2_dpseci_poll,
+					 DPAA2_CAAM_NAPI_WEIGHT);
 	}
 
 	return 0;
diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 8163f5df8ebf..1c9450b29583 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -749,8 +749,8 @@ int caam_qi_init(struct platform_device *caam_pdev)
 		net_dev->dev = *qidev;
 		INIT_LIST_HEAD(&net_dev->napi_list);
 
-		netif_napi_add(net_dev, irqtask, caam_qi_poll,
-			       CAAM_NAPI_WEIGHT);
+		netif_napi_add_tx_weight(net_dev, irqtask, caam_qi_poll,
+					 CAAM_NAPI_WEIGHT);
 
 		napi_enable(irqtask);
 	}
-- 
2.36.1

