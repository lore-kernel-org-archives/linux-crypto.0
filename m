From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 13/17] crypto: inside-secure - acknowledge the result requests all at once
Date: Thu, 14 Dec 2017 15:26:55 +0100
Message-ID: <20171214142659.16987-14-antoine.tenart@free-electrons.com>
References: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36771 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753164AbdLNOaI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Dec 2017 09:30:08 -0500
In-Reply-To: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patches moves the result request acknowledgment from a per request
process to acknowledging all the result requests handled at once.

Suggested-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index db7ad9d3eeed..36c9a72c47b1 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -600,7 +600,7 @@ static inline void safexcel_handle_result_descriptor(struct safexcel_crypto_priv
 {
 	struct safexcel_request *sreq;
 	struct safexcel_context *ctx;
-	int ret, i, nreq, ndesc = 0, done;
+	int ret, i, nreq, ndesc = 0, tot_descs = 0, done;
 	bool should_complete;
 
 	nreq = readl(priv->base + EIP197_HIA_RDR(ring) + EIP197_HIA_xDR_PROC_COUNT);
@@ -622,13 +622,9 @@ static inline void safexcel_handle_result_descriptor(struct safexcel_crypto_priv
 		if (ndesc < 0) {
 			kfree(sreq);
 			dev_err(priv->dev, "failed to handle result (%d)", ndesc);
-			goto requests_left;
+			goto acknowledge;
 		}
 
-		writel(EIP197_xDR_PROC_xD_PKT(1) |
-		       EIP197_xDR_PROC_xD_COUNT(ndesc * priv->config.rd_offset),
-		       priv->base + EIP197_HIA_RDR(ring) + EIP197_HIA_xDR_PROC_COUNT);
-
 		if (should_complete) {
 			local_bh_disable();
 			sreq->req->complete(sreq->req, ret);
@@ -636,6 +632,14 @@ static inline void safexcel_handle_result_descriptor(struct safexcel_crypto_priv
 		}
 
 		kfree(sreq);
+		tot_descs += ndesc;
+	}
+
+acknowledge:
+	if (i) {
+		writel(EIP197_xDR_PROC_xD_PKT(i) |
+		       EIP197_xDR_PROC_xD_COUNT(tot_descs * priv->config.rd_offset),
+		       priv->base + EIP197_HIA_RDR(ring) + EIP197_HIA_xDR_PROC_COUNT);
 	}
 
 requests_left:
-- 
2.14.3
