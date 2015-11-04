From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/7] crypto: marvell: check return value of sg_nents_for_len
Date: Wed,  4 Nov 2015 21:13:33 +0100
Message-ID: <1446668045-8620-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: arno@natisbad.org, boris.brezillon@free-electrons.com,
	clabbe.montjoie@gmail.com, davem@davemloft.net,
	herbert@gondor.apana.org.au, thomas.petazzoni@free-electrons.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37801 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273AbbKDUOZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Nov 2015 15:14:25 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The sg_nents_for_len() function could fail, this patch add a check for
its return value.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/marvell/cipher.c | 8 ++++++++
 drivers/crypto/marvell/hash.c   | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 3df2f4e..78cf6f9 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -400,7 +400,15 @@ static int mv_cesa_ablkcipher_req_init(struct ablkcipher_request *req,
 		return -EINVAL;
 
 	creq->src_nents = sg_nents_for_len(req->src, req->nbytes);
+	if (creq->src_nents < 0) {
+		dev_err(cesa_dev->dev, "Invalid number of src SG");
+		return creq->src_nents;
+	}
 	creq->dst_nents = sg_nents_for_len(req->dst, req->nbytes);
+	if (creq->dst_nents < 0) {
+		dev_err(cesa_dev->dev, "Invalid number of dst SG");
+		return creq->dst_nents;
+	}
 
 	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_OP_CRYPT_ONLY,
 			      CESA_SA_DESC_CFG_OP_MSK);
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index e8d0d71..250c6e5 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -710,6 +710,10 @@ static int mv_cesa_ahash_req_init(struct ahash_request *req, bool *cached)
 		creq->req.base.type = CESA_STD_REQ;
 
 	creq->src_nents = sg_nents_for_len(req->src, req->nbytes);
+	if (creq->src_nents < 0) {
+		dev_err(cesa_dev->dev, "Invalid number of src SG");
+		return creq->src_nents;
+	}
 
 	ret = mv_cesa_ahash_cache_req(req, cached);
 	if (ret)
-- 
2.4.10
