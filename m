Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9487C39DBFC
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 21:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785448499; cv=none; b=BKcqpDGGw67S/h2ip6cBKRFgnO1UuOewFCJ2NgyJbTB/hpM/vU7i1UntwZAAR12bN5XXc7IS34XZ26XnhGFl0aEM9ZceP41hupkh017jB4cBS+QA2YwSielX8hCtmnUgmQRptqfECsIrCg/uJHKVRXxwNaMK9DV+PaFof8MYetI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785448499; c=relaxed/simple;
	bh=6fqu9I7GNzFqRL61SzrwLnuQA7GCPPUae5cAvh8qLa8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Fblq+t1MCQj1VI+RqD9IcNudlU314g145aDzAXp3mH3ND6pjjU2i9jV7APFu3s3bYKdNrIXXflJ5rMsQQfVuM6VY8LeHJ94uTkeGvblzOPI87hISK09VBo0+ZKgrL9upSrQWAHqd9tEUuWsySA/48LQj8ZLV4mE6qtw75QkupY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tMTN3X5G; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tMTN3X5G"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4954df200ddso1717955e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 14:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785448495; x=1786053295; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9MhVSyy908oKVXOA9GHZs4sFwB1vQiUyi91R5soAEto=;
        b=tMTN3X5GwodmpJ4EvmpGvMiRwmgq3qzdLvJ6H1PHi78tlXn685MkCru3YoDflMnchd
         aNBmwyAQ4ahrt4sNlMuDn3O7cBRLU69CJvqe4C59IXpgzYuTpP1vmiIFVRozSs6Ee/h+
         HAeC/LDTvAEWKekwEzQ1U5xJ8ZGJyp56L7/TRiPdxGHm/0mO702LqXq5/TogWL4FfRAv
         8bI2XZ0gCTkh8gaiLXM7YwiBq98oGZERGBznRnhbM8g155p82/O8GPGKi+OjrcUxUHhl
         2nBKHPoWNI/8EDDrJENDGahHq+0u14BGGiqhnj3A2lTSHN3LVfG+KorDadnSNtOMFNN5
         mYyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785448495; x=1786053295;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9MhVSyy908oKVXOA9GHZs4sFwB1vQiUyi91R5soAEto=;
        b=DxtUCGIRp9UGGkoMrBqaDFM7D1lNY4qjNfzgcUvCxGgmRbF8DQdcISi/DpJFvU149A
         e/LI+NkoUhQU4IBJvUEecesF4LsV+x/eRPRioIZYTBtarEDCFMTegG8tKO8UPl4zOxi+
         bh7kRNrpi4X6BAu6AZh1Qu1EQLtfxZ4SVLhySR2AEbz7ojhYJHhUKq/OW8sx+i4mCTrr
         201ChjCKgZWlDuUqZba0HcxYhZOEeRraOexWaOyk0rnG1/cSWFG1tjjRyKDnP2ZIHqZy
         H1ASyarKu+xE9tPaAnH/0IdQVX8uD+wJj+Tb5qhiWTRYLHPOwozhwGrkm7leKstncBUY
         gptw==
X-Forwarded-Encrypted: i=1; AHgh+Rp5NmdqYhmCYpHA8bb9aGqAoArl8F2uqmTaV2BMFwj5LnfDj2mhyFi5kuiWnpeo8C2bsouwGBaI3kNwYLs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhWa49h0fVJdXTtFqmeEyazUSIvD3i5I2SpvEsmZfYPqdUq5fi
	v+4FhKJyjTGo82Y4FiX4ZnfQtIsFCe7sE3LJSTW03BdKewYYLUieLTVa
X-Gm-Gg: AR+sD11nWxNo+xIix6rVGKj7RsvgzHr+d6XVgJpjSnGCSluQwCLTjN07QmRj1mTrs8Z
	CQRzsnomC3/9ppZMMyL1fvQdWCbrX088j1RkreqFIKD4HP5TPq+NiE8uO1R9UN5gZrLqNG5CK3+
	axmfHA5Ihns+iZtcME4bnlpI2T6suy4BzwTqkVUuh9E1CKN9GWEs0siHawXe8MvKVs1hFdbyjiT
	kUyz+vHBg7aT88am2+9AjckcbpPc6hWtgB9IxvI26IC6HhCKGU2ofhd4TEWieR8hXu/uHOIVbmx
	cc0nyw7GWR5BS/qw19xs1Klrcy/Kyt/X/J8ZudfRufGa0Uv/ofYlgUTzcoZQLDqPcYWl6/rWSCz
	U+irXWdTRq+K0VoPm207tkaqekBixoQWd5fvtr83PRnnEQHy5D2l1ujIf97eVMr206Zh0ua+yxh
	USZ3RtblPS9apdLvLPRK7zqYb5OJnol7IX1YrAxwuOALwcZrZtHViPrdqiuHk8UwI=
X-Received: by 2002:a05:600c:5294:b0:493:f6f0:d66b with SMTP id 5b1f17b1804b1-49800e6b596mr57020155e9.1.1785448494975;
        Thu, 30 Jul 2026 14:54:54 -0700 (PDT)
Received: from arbab-X395 ([14.1.106.106])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fc892cc6asm10872033f8f.18.2026.07.30.14.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 14:54:54 -0700 (PDT)
From: Arbab Haider <arbabhaider649@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Arbab Haider <arbabhaider649@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: hisilicon/sec - Fix element drop and UAF in sec_send_request()
Date: Fri, 31 Jul 2026 02:54:48 +0500
Message-ID: <20260730215449.299311-1-arbabhaider649@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The capacity check in sec_alg_skcipher_crypto() only verified that the
hardware queue could accept all steps or that the softqueue had
capacity, but failed to account for the case where softqueue already
has pending entries. When softqueue is non-empty, all new entries must
go to softqueue (to preserve cipher chaining ordering), even if the
hardware queue has available capacity.

This means the check could pass via hardware capacity, yet the first
element goes to hardware and subsequent elements go to softqueue —
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

Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
Signed-off-by: Arbab Haider <arbabhaider649@gmail.com>
---
 drivers/crypto/hisilicon/sec/sec_algs.c | 65 ++++++++++++++-----------
 1 file changed, 37 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 85eecbb40e7e..ce1dd95455ff 100644
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
@@ -401,21 +400,17 @@ static int sec_send_request(struct sec_request *sec_req, struct sec_queue *queue
 		if (!queue->havesoftqueue ||
 		    (kfifo_is_empty(&queue->softqueue) &&
 		     sec_queue_empty(queue))) {
-			ret = sec_queue_send(queue, &el->req, sec_req);
-			if (ret == -EAGAIN) {
-				/* Wait unti we can send then try again */
-				/* DEAD if here - should not happen */
-				ret = -EBUSY;
-				goto err_unlock;
-			}
+			if (WARN_ON_ONCE(sec_queue_send(queue, &el->req,
+							sec_req)))
+				/* Should not happen with proper capacity check */
+				;
 		} else {
-			kfifo_put(&queue->softqueue, el);
+			if (WARN_ON_ONCE(!kfifo_put(&queue->softqueue, el)))
+				/* Should not happen with proper capacity check */
+				;
 		}
 	}
-err_unlock:
 	mutex_unlock(&sec_req->lock);
-
-	return ret;
 }
 
 static void sec_skcipher_alg_callback(struct sec_bd_info *sec_resp,
@@ -790,28 +785,44 @@ static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
 
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
 		ret = -EBUSY;
+		goto backlog;
+	}
+
+	if (!queue->havesoftqueue) {
+		if (!sec_queue_can_enqueue(queue, steps))
+			ret = -EBUSY;
+	} else if (!kfifo_is_empty(&queue->softqueue) ||
+		   !sec_queue_empty(queue)) {
+		/* All entries must go to the softqueue */
+		if (kfifo_avail(&queue->softqueue) <= steps)
+			ret = -EBUSY;
+	} else {
+		/* First to hardware, rest to softqueue */
+		if (!sec_queue_can_enqueue(queue, 1) ||
+		    kfifo_avail(&queue->softqueue) < steps - 1)
+			ret = -EBUSY;
+	}
+
+	if (ret) {
+backlog:
 		if ((skreq->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
 			list_add_tail(&sec_req->backlog_head, &ctx->backlog);
 			spin_unlock_bh(&queue->queuelock);
@@ -821,10 +832,8 @@ static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
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

