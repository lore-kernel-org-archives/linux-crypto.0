Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE30E1A285
	for <linux-crypto@vger.kernel.org>; Sun,  2 Aug 2026 07:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785656743; cv=none; b=QER4Rpwy59XQuMoEPiEBlpOUFrE1MGqcHxw5dSEHm3yzBFxwawAQZYv++v+crbo46ovF/d2u9O/TdxRoeSNQarjMRSpxiOsSmp3OEM7rcDu0NsZJp3LFTjnowZMyY3V3RD/dTx2MSH+l2hg/TJQmNY964x26nqCP2YQLEd2163o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785656743; c=relaxed/simple;
	bh=KlKD0lgFd0qizGthSsbb2KaYcDdWPOSMwzi/U417HXU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ohb0B4VWS2u1Iq+2YqIshpe0eLMNONTQ2tJS5AAmN3uAuJBOHqkC3rfFooHzbwFcO1CRiz/IBMW3XdN/YYYlLZxzDRkr8a+zz4AMsW2RZ6qi1Pnw2TvJ2aYVVIeThPgKwaDTGslNK+Z5gYoFLmRmyW3XUGj5mvHvcbYYChcE9g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VfJGX9lJ; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VfJGX9lJ"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47f3b39f2a1so1691541f8f.2
        for <linux-crypto@vger.kernel.org>; Sun, 02 Aug 2026 00:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785656740; x=1786261540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sO6B+Ly12nusdmWB1fOu2fySmQ6NQ459JxTMOq+zkvU=;
        b=VfJGX9lJ1gASTctadDNEL95MdRJKoaba3v4lXs/TuTNkbugJFGClfQlQKHtrsu4ecV
         k1vwrHI1YAUf0YaDYh9NgNXOxg31UhPGHCmxE6Fe18T11Sh89wYiFCJbRvGNb9sMWHzz
         rDECXIgPj0uFMRK2JA0Mgjj/kp8FJGqqDSiZN7rChxwBMHF11gvSdEr63pO3s1rF6/q/
         /tUNOXyOXAeZfLgLTAMXh39NipL7KepWDDJhtWykEN8u7lSOLQ2b2QZJVxFFN7deF2VU
         ntK6ggQmi2xvK0LTtQ9M1FiwNaPWANm9BTKqbVzxH29NJLsWVD5oEEMfgv2s7c4lA6me
         nWRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785656740; x=1786261540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sO6B+Ly12nusdmWB1fOu2fySmQ6NQ459JxTMOq+zkvU=;
        b=CSXovdeY3SUnSVr2jEilb8pmsKhVW2oksJi+LnOXaI/n8fIYIUh5QRab42dd8GOWe+
         a+8LAqUdVAImQzCLL7VGKYyEDcM78utZq3aZCmRTvu+rDOZmH3UHX2iBwPi5d1Z8INbC
         kiBTruwgjVQbaWCLQgEWE+hvka0scyLOm/ZVl/1QsunQFs6HixXR1FMZwdPZiHsYr3LB
         Vnps9ay97epWhfXEr1jOKNFA+BdaSMugsTdFw5VTfphE1+/VDmZ0V/J0mo61p2jpmul7
         loNJWT6B3g3WTiECS0l2jbYc1yW6V7IaslGDAej1jIcN5kZW13++p4yrN3rVpCJeMR7W
         JLJw==
X-Gm-Message-State: AOJu0YyEL5B5hxOVuzs+8D/mHVg1L633c/oZTUYIf/DBmyMiA5MQ+DYt
	ua49P5c8q4n+PXT+Z7tVEbA6R54lguUA41N5r9r0gxzDAauaSFpnQei2AVdxcNjH
X-Gm-Gg: AR+sD11kFmMyJRun45bobnjnTNbm7M8HTx6zBd6imN8Hu67Eh0uMoHQbV1diDqlVW4j
	XzguQ+MQ2zU49CJIBfOsTzat4i8+FGCjFP4Yq8mPXqJHuQqZV0IEsfKIYHVHygScayte0P0nmF7
	ESV4Ecx1+lv5f1LxgILT76tSwupWme4jH/gLBdlC5pamgpndRxrjXVwPGb88Q1Xr2uYTmSKCtIC
	z8VZ7CtN6UBbSanfmT70l9qHXkVCsQ5+Cva6RcVLho8Jnx/hqTsutIxzObHYFIAfpcRUluc7QxC
	iRsHF+tijAfwndBvSzd7bjcdI+1EkZ//sOSSRo8/Op3pofOs89XysppPUYx5/KKz8+AO5m8hAO2
	4lHiN7alfe+Kkg+5bUusux+0t1csZFCOK2b8Mz80Hlr0cEJpnG7CdwAtQLufw+OU+GnKfue+NAA
	GZJJcKFaUB+3XS1Qx3DAS50tXjug6QFSySASotx8KhDvxRKyWwEquQddKvRxuOvrCpMB0=
X-Received: by 2002:a5d:5f48:0:b0:47e:1d9a:1123 with SMTP id ffacd0b85a97d-47fd729fcddmr13697292f8f.3.1785656739854;
        Sun, 02 Aug 2026 00:45:39 -0700 (PDT)
Received: from arbab-X395 ([103.125.177.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41d17f2sm25143069f8f.2.2026.08.02.00.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 00:45:39 -0700 (PDT)
From: Arbab Haider <arbabhaider649@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	Arbab Haider <arbabhaider649@gmail.com>
Subject: [PATCH v3] crypto: hisilicon/sec - Fix element drop and UAF in sec_send_request()
Date: Sun,  2 Aug 2026 12:45:34 +0500
Message-ID: <20260802074534.353727-1-arbabhaider649@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The capacity check in sec_alg_skcipher_crypto() only verified that the
hardware queue could accept all steps or that the softqueue had
capacity, but failed to account for the case where softqueue already
has pending entries. When softqueue is non-empty, all new entries must
go to softqueue (to preserve cipher chaining ordering), even if the
hardware queue has available capacity.

This means the check could pass via hardware capacity, yet the first
element goes to hardware and subsequent elements go to softqueue -
which might be full. kfifo_put() silently returns 0 on a full fifo,
so those elements are dropped and the request never completes.

Fix by:

- Replacing the capacity check with correct logic that accounts
  for all three queueing scenarios.

- Making sec_send_request() void and checking both sec_queue_send()
  and kfifo_put() with WARN_ON_ONCE. A return value is not returned
  to the caller because a mid-loop error after partial queuing would
  cause the caller's err_free_elements path to free elements still
  referenced by the hardware shadow array or softqueue (UAF). The
  corrected capacity check guarantees these paths are unreachable.

- Factoring the corrected capacity check into sec_can_send_request()
  and applying it to the backlog re-queue path in
  sec_alg_skcipher_alg_callback() as well, which previously used the
  same flawed check. If the hardware queue could accept the whole
  request but the softqueue could not hold the remaining elements,
  the re-queue would queue the first element to hardware and then
  drop the tail elements on a full softqueue, hanging the request.

Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
Signed-off-by: Arbab Haider <arbabhaider649@gmail.com>
---
 drivers/crypto/hisilicon/sec/sec_algs.c | 84 ++++++++++++++-----------
 1 file changed, 48 insertions(+), 36 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 85eecbb40e7e..e12206989f63 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -381,10 +381,9 @@ static void sec_alg_free_el(struct sec_request_el *el,
 }
 
 /* queuelock must be held */
-static int sec_send_request(struct sec_request *sec_req, struct sec_queue *queue)
+static void sec_send_request(struct sec_request *sec_req, struct sec_queue *queue)
 {
 	struct sec_request_el *el, *temp;
-	int ret = 0;
 
 	mutex_lock(&sec_req->lock);
 	list_for_each_entry_safe(el, temp, &sec_req->elements, head) {
@@ -400,22 +399,36 @@ static int sec_send_request(struct sec_request *sec_req, struct sec_queue *queue
 		 */
 		if (!queue->havesoftqueue ||
 		    (kfifo_is_empty(&queue->softqueue) &&
-		     sec_queue_empty(queue))) {
-			ret = sec_queue_send(queue, &el->req, sec_req);
-			if (ret == -EAGAIN) {
-				/* Wait unti we can send then try again */
-				/* DEAD if here - should not happen */
-				ret = -EBUSY;
-				goto err_unlock;
-			}
-		} else {
-			kfifo_put(&queue->softqueue, el);
-		}
+		     sec_queue_empty(queue)))
+			WARN_ON_ONCE(sec_queue_send(queue, &el->req,
+						    sec_req));
+		else
+			WARN_ON_ONCE(!kfifo_put(&queue->softqueue, el));
 	}
-err_unlock:
 	mutex_unlock(&sec_req->lock);
+}
 
-	return ret;
+/*
+ * Check whether a request of @steps elements can be queued without
+ * exceeding the capacity of the hardware and software queues.
+ *
+ * When the softqueue has pending entries, all new entries must go to
+ * the softqueue to preserve ordering.  When both queues are empty the
+ * first entry goes to hardware and the rest to the softqueue (if
+ * enabled).
+ *
+ * queuelock must be held.
+ */
+static bool sec_can_send_request(struct sec_queue *queue, unsigned int steps)
+{
+	if (!queue->havesoftqueue)
+		return sec_queue_can_enqueue(queue, steps);
+
+	if (!kfifo_is_empty(&queue->softqueue) || !sec_queue_empty(queue))
+		return kfifo_avail(&queue->softqueue) > steps;
+
+	return sec_queue_can_enqueue(queue, 1) &&
+	       kfifo_avail(&queue->softqueue) >= steps - 1;
 }
 
 static void sec_skcipher_alg_callback(struct sec_bd_info *sec_resp,
@@ -498,11 +511,8 @@ static void sec_skcipher_alg_callback(struct sec_bd_info *sec_resp,
 		backlog_req = list_first_entry(&ctx->backlog,
 					       typeof(*backlog_req),
 					       backlog_head);
-		if (sec_queue_can_enqueue(ctx->queue,
-		    backlog_req->num_elements) ||
-		    (ctx->queue->havesoftqueue &&
-		     kfifo_avail(&ctx->queue->softqueue) >
-		     backlog_req->num_elements)) {
+		if (sec_can_send_request(ctx->queue,
+					 backlog_req->num_elements)) {
 			sec_send_request(backlog_req, ctx->queue);
 			crypto_request_complete(backlog_req->req_base,
 						-EINPROGRESS);
@@ -713,7 +723,7 @@ static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
 	struct sec_queue *queue = ctx->queue;
 	struct sec_request *sec_req = skcipher_request_ctx(skreq);
 	struct sec_dev_info *info = queue->dev_info;
-	int i, ret, steps;
+	int i, ret = 0, steps;
 	size_t *split_sizes;
 	struct scatterlist **splits_in;
 	struct scatterlist **splits_out = NULL;
@@ -790,28 +800,32 @@ static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
 
 	/*
 	 * Only attempt to queue if the whole lot can fit in the queue -
-	 * we can't successfully cleanup after a partial queing so this
+	 * we can't successfully cleanup after a partial queuing so this
 	 * must succeed or fail atomically.
 	 *
-	 * Big hammer test of both software and hardware queues - could be
-	 * more refined but this is unlikely to happen so no need.
+	 * When the softqueue has pending entries, all new entries must
+	 * go to the softqueue to preserve ordering.  When both queues
+	 * are empty the first entry goes to hardware and the rest to
+	 * the softqueue (if enabled).
 	 */
 
 	/* Grab a big lock for a long time to avoid concurrency issues */
 	spin_lock_bh(&queue->queuelock);
 
 	/*
-	 * Can go on to queue if we have space in either:
-	 * 1) The hardware queue and no software queue
-	 * 2) The software queue
-	 * AND there is nothing in the backlog.  If there is backlog we
-	 * have to only queue to the backlog queue and return busy.
+	 * Can go on to queue if we have space for everything upfront.
+	 * If there is backlog we must queue to the backlog and return busy.
 	 */
-	if ((!sec_queue_can_enqueue(queue, steps) &&
-	     (!queue->havesoftqueue ||
-	      kfifo_avail(&queue->softqueue) > steps)) ||
-	    !list_empty(&ctx->backlog)) {
+	if (!list_empty(&ctx->backlog)) {
+		ret = -EBUSY;
+		goto backlog;
+	}
+
+	if (!sec_can_send_request(queue, steps))
 		ret = -EBUSY;
+
+	if (ret) {
+backlog:
 		if ((skreq->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
 			list_add_tail(&sec_req->backlog_head, &ctx->backlog);
 			spin_unlock_bh(&queue->queuelock);
@@ -821,10 +835,8 @@ static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
 		spin_unlock_bh(&queue->queuelock);
 		goto err_free_elements;
 	}
-	ret = sec_send_request(sec_req, queue);
+	sec_send_request(sec_req, queue);
 	spin_unlock_bh(&queue->queuelock);
-	if (ret)
-		goto err_free_elements;
 
 	ret = -EINPROGRESS;
 out:
-- 
2.53.0

