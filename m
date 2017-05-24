From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 12/13] crypto: omap-sham: fix closing of hash with separate finalize call
Date: Wed, 24 May 2017 10:35:33 +0300
Message-ID: <1495611334-15039-13-git-send-email-t-kristo@ti.com>
References: <1495611334-15039-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:51602 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966667AbdEXHg1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 03:36:27 -0400
In-Reply-To: <1495611334-15039-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently there is an interesting corner case failure with omap-sham
driver, if the finalize call is done separately with no data, but
all previous data has already been processed. In this case, it is not
possible to close the hash with the hardware without providing any data,
so we get incorrect results. Fix this by adjusting the size of data
sent to the hardware crypto engine in case the non-final data size falls
on the block size boundary, by reducing the amount of data sent by one
full block. This makes it sure that we always have some data available
for the finalize call and we can close the hash properly.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
Reported-by: Aparna Balasubramanian <aparnab@ti.com>
---
 drivers/crypto/omap-sham.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index c65b49b..d8305dd 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -750,7 +750,10 @@ static int omap_sham_align_sgs(struct scatterlist *sg,
 	if (final)
 		new_len = DIV_ROUND_UP(new_len, bs) * bs;
 	else
-		new_len = new_len / bs * bs;
+		new_len = (new_len - 1) / bs * bs;
+
+	if (nbytes != new_len)
+		list_ok = false;
 
 	while (nbytes > 0 && sg_tmp) {
 		n++;
@@ -846,6 +849,8 @@ static int omap_sham_prepare_request(struct ahash_request *req, bool update)
 			xmit_len = DIV_ROUND_UP(xmit_len, bs) * bs;
 		else
 			xmit_len = xmit_len / bs * bs;
+	} else if (!final) {
+		xmit_len -= bs;
 	}
 
 	hash_later = rctx->total - xmit_len;
@@ -1137,7 +1142,7 @@ static int omap_sham_handle_queue(struct omap_sham_dev *dd,
 	ctx = ahash_request_ctx(req);
 
 	err = omap_sham_prepare_request(req, ctx->op == OP_UPDATE);
-	if (err)
+	if (err || !ctx->total)
 		goto err1;
 
 	dev_dbg(dd->dev, "handling new req, op: %lu, nbytes: %d\n",
-- 
1.9.1
