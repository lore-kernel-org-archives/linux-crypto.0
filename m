Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9032141325B
	for <linux-crypto@vger.kernel.org>; Thu,  7 May 2026 14:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778164943; cv=none; b=dZa4X6NIUg0cf1VURglbxjrALdxA4yb1D8tQPM+iDYGCpy3O1dCzNVLTba+xPmbDYUt/9DYc8w1fixUhriqdGcoGFi+agYLku+iiRxg9wzHOU43rV/FmZSTsL6ao59dmjUExi8/UMvUpgdF5uMdRX0Ahi9sPUDMCJ0oClHscNa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778164943; c=relaxed/simple;
	bh=j+6PCvRTp7SKVC0FT4iIhWmOSLwnJZVWRVkYosMNe5g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hrtW1TrGlQTlg0YdiWa6RA2rwEEskrxd2rQg6gp+H+SOExI7fGMqSv5yfjQR5RloKmqAUEdm/XsAvVSpfrjG+K8xwGWf/v4V/t9Z2AkrydL2lTY3v5GzH+rX5oH8+T11WnolngPOlQBHlOcF8DDKRx2815hOT4gsQNQzqaQWDro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=fV0dpV/t; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="fV0dpV/t"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 5339C1A3566;
	Thu,  7 May 2026 14:42:20 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 2929960644;
	Thu,  7 May 2026 14:42:20 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0E01A108194EB;
	Thu,  7 May 2026 16:42:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778164939; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=EPpVeeYRNfJpuG0W8Z2Qz9u0mF8TkZfJzfXE8v1oTgw=;
	b=fV0dpV/t1N5DHZemuQr8eEbAuT23/nNXS6tHJjFA9cjW4l8cXeNo1yVJ9NMiKOPhMtpJdM
	4sQiEL1UzjEot5pwG+MdHRk30V9t8vxZ16iCjJOY1G/0eEay9pEVLm9r0PRvL6FIgj1vbi
	rq9HF61xYb+4at1sOWV1VQlUHdardBdWrPonPa2ZfKP+tTFOMd/NReRyNKm/FiUDF596ai
	cAN6NJmH6EMw8MtpkR6Y+cQHIzNK5Bw045p1Pcimg4ivQL3UKNoXeLWXUcpK7gYW0JAMCJ
	ZPOAnRsOtuSKxHInnQQnjC/un4L+bthbDgT3+LEr0ykAuXZNRdfJTAtvmivoKA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 07 May 2026 16:41:54 +0200
Subject: [PATCH v3 08/11] crypto: talitos/hash - drop workqueue mechanism
 for SEC1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-8-c98d7589b942@bootlin.com>
References: <20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-0-c98d7589b942@bootlin.com>
In-Reply-To: <20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-0-c98d7589b942@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
 David Howells <dhowells@redhat.com>, 
 Kim Phillips <kim.phillips@freescale.com>, 
 Christophe Leroy <chleroy@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Paul Louvel <paul.louvel@bootlin.com>, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778164923; l=5598;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=j+6PCvRTp7SKVC0FT4iIhWmOSLwnJZVWRVkYosMNe5g=;
 b=icD8Uu9DauD9AuKCQw2a7OKmDOvXnJSFZ5ut44g5/7pqJHeCefetRTAt1H9Bfm10qdlUx+MDJ
 cLfQCGPxadKARw89Mq0Hdt+MMU+xqzk+9BvIYEwbhtpMHThW6GLj8Je
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Now that SEC1 hash uses hardware descriptor chaining instead of a
workqueue to process requests exceeding TALITOS1_MAX_DATA_LEN, the
workqueue code is no longer needed.

Remove sec1_ahash_process_remaining(), the related fields from
talitos_ahash_req_ctx (request_bufsl, areq, request_sl,
remaining_ahash_request_bytes, current_ahash_request_bytes,
sec1_ahash_process_remaining), the dead code in ahash_done(), and
simplify ahash_process_req() to call ahash_process_req_one() directly
with the original areq->src and areq->nbytes.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos.c | 80 +++++-------------------------------------------
 1 file changed, 7 insertions(+), 73 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 883115d66fc4..1f497930800b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -12,7 +12,6 @@
  * All rights reserved.
  */
 
-#include <linux/workqueue.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
@@ -952,13 +951,6 @@ struct talitos_ahash_req_ctx {
 	unsigned int nbuf;
 	struct scatterlist bufsl[2];
 	struct scatterlist *psrc;
-
-	struct scatterlist request_bufsl[2];
-	struct ahash_request *areq;
-	struct scatterlist *request_sl;
-	unsigned int remaining_ahash_request_bytes;
-	unsigned int current_ahash_request_bytes;
-	struct work_struct sec1_ahash_process_remaining;
 };
 
 struct talitos_export_state {
@@ -1840,18 +1832,6 @@ static void ahash_done(struct device *dev,
 	free_edesc_list_from(areq, edesc);
 
 	ahash_request_complete(areq, err);
-
-	return;
-
-	req_ctx->remaining_ahash_request_bytes -=
-		req_ctx->current_ahash_request_bytes;
-
-	if (!req_ctx->remaining_ahash_request_bytes) {
-		ahash_request_complete(areq, 0);
-		return;
-	}
-
-	schedule_work(&req_ctx->sec1_ahash_process_remaining);
 }
 
 /*
@@ -2044,12 +2024,12 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 
 	if (!req_ctx->last_request && (nbytes + req_ctx->nbuf <= blocksize)) {
 		/* Buffer up to one whole block */
-		nents = sg_nents_for_len(req_ctx->request_sl, nbytes);
+		nents = sg_nents_for_len(areq->src, nbytes);
 		if (nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
 			return nents;
 		}
-		sg_copy_to_buffer(req_ctx->request_sl, nents,
+		sg_copy_to_buffer(areq->src, nents,
 				  ctx_buf + req_ctx->nbuf, nbytes);
 		req_ctx->nbuf += nbytes;
 		return 0;
@@ -2076,18 +2056,18 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 		sg_init_table(req_ctx->bufsl, nsg);
 		sg_set_buf(req_ctx->bufsl, ctx_buf, req_ctx->nbuf);
 		if (nsg > 1)
-			sg_chain(req_ctx->bufsl, 2, req_ctx->request_sl);
+			sg_chain(req_ctx->bufsl, 2, areq->src);
 		req_ctx->psrc = req_ctx->bufsl;
 	} else
-		req_ctx->psrc = req_ctx->request_sl;
+		req_ctx->psrc = areq->src;
 
 	if (to_hash_later) {
-		nents = sg_nents_for_len(req_ctx->request_sl, nbytes);
+		nents = sg_nents_for_len(areq->src, nbytes);
 		if (nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
 			return nents;
 		}
-		sg_pcopy_to_buffer(req_ctx->request_sl, nents,
+		sg_pcopy_to_buffer(areq->src, nents,
 				   req_ctx->buf[(req_ctx->buf_idx + 1) & 1],
 				      to_hash_later,
 				      nbytes - to_hash_later);
@@ -2106,54 +2086,9 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	return ret;
 }
 
-static void sec1_ahash_process_remaining(struct work_struct *work)
-{
-	struct talitos_ahash_req_ctx *req_ctx =
-		container_of(work, struct talitos_ahash_req_ctx,
-			     sec1_ahash_process_remaining);
-	int err = 0;
-
-	req_ctx->request_sl = scatterwalk_ffwd(req_ctx->request_bufsl,
-					       req_ctx->request_sl, TALITOS1_MAX_DATA_LEN);
-
-	if (req_ctx->remaining_ahash_request_bytes > TALITOS1_MAX_DATA_LEN)
-		req_ctx->current_ahash_request_bytes = TALITOS1_MAX_DATA_LEN;
-	else {
-		req_ctx->current_ahash_request_bytes =
-			req_ctx->remaining_ahash_request_bytes;
-
-		if (req_ctx->last_request)
-			req_ctx->last_desc = 1;
-	}
-
-	err = ahash_process_req_one(req_ctx->areq,
-				    req_ctx->current_ahash_request_bytes);
-
-	if (err != -EINPROGRESS)
-		ahash_request_complete(req_ctx->areq, err);
-}
-
 static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = ctx->dev;
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-
-	req_ctx->areq = areq;
-	req_ctx->request_sl = areq->src;
-	req_ctx->remaining_ahash_request_bytes = nbytes;
-
-	if (is_sec1) {
-		if (req_ctx->last_request)
-			req_ctx->last_desc = 1;
-	}
-
-	req_ctx->current_ahash_request_bytes = nbytes;
-
-	return ahash_process_req_one(req_ctx->areq, nbytes);
+	return ahash_process_req_one(areq, nbytes);
 }
 
 static int ahash_init(struct ahash_request *areq)
@@ -2176,7 +2111,6 @@ static int ahash_init(struct ahash_request *areq)
 	req_ctx->hw_context_size = size;
 	req_ctx->last_request = 0;
 	req_ctx->last_desc = 0;
-	INIT_WORK(&req_ctx->sec1_ahash_process_remaining, sec1_ahash_process_remaining);
 
 	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
 			     DMA_TO_DEVICE);

-- 
2.54.0

