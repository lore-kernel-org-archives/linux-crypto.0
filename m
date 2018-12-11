Return-Path: <SRS0=eKEb=OU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:57727 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbeLKKwM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 05:52:12 -0500
From: Harsh Jain <harsh@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        atul.gupta@chelsio.com, indranil@chelsio.com
Cc: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 5/6] crypto:chelsio: Reset counters on cxgb4 Detach
Date: Tue, 11 Dec 2018 16:21:41 +0530
Message-Id: <beb0c0ec53425b33d19b48464453bd1872707bc4.1544520025.git.harsh@chelsio.com>
In-Reply-To: <cover.1544520025.git.harsh@chelsio.com>
References: <cover.1544520025.git.harsh@chelsio.com>
In-Reply-To: <cover.1544520025.git.harsh@chelsio.com>
References: <cover.1544520025.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Reset the counters on receiving detach from Cxgb4.

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chcr_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index f71a979..e04b3e8 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -132,6 +132,8 @@ static void chcr_dev_init(struct uld_ctx *u_ctx)
 
 static int chcr_dev_move(struct uld_ctx *u_ctx)
 {
+	struct adapter *adap;
+
 	 mutex_lock(&drv_data.drv_mutex);
 	if (drv_data.last_dev == u_ctx) {
 		if (list_is_last(&drv_data.last_dev->entry, &drv_data.act_dev))
@@ -144,6 +146,8 @@ static int chcr_dev_move(struct uld_ctx *u_ctx)
 	list_move(&u_ctx->entry, &drv_data.inact_dev);
 	if (list_empty(&drv_data.act_dev))
 		drv_data.last_dev = NULL;
+	adap = padap(&u_ctx->dev);
+	memset(&adap->chcr_stats, 0, sizeof(adap->chcr_stats));
 	atomic_dec(&drv_data.dev_count);
 	mutex_unlock(&drv_data.drv_mutex);
 
-- 
2.1.4
