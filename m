Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EC53AFB18
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 12:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785415053; cv=none; b=tA0BDdewYUwr9P7UFoNZWEjJxKMMHB723u6MbCIXVswEY5ZO6uL8mCfFroyToXs2oQAAZWwa6yVH7roiFmFQT4Wil0YWVjgr4vSQUBhZSDYjmIC3BfZqf0ubV45ZhbM2HTuKZnaJbZPRn2Hd/eisTly03rOg8NJhzzCWwY4eV1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785415053; c=relaxed/simple;
	bh=DHVZc6Q2g7fFidpehsXl0+aHf092QeZz+fx4jRsuXZk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jrmuvkS08M3DS7iOhdDLWqH+Rb7izz3+DTNzLZPAbE9PWNLCOQItvuwAzLskQbSD+TXzzVULHltD78bUmiEBscXZIW+P5uJFgvJZSO8eiQVhj+aM53BBtwngL4KEa5eQIbiq2tNnH7rHoMpyVok5FUEC4pX3yYudaZ7ApsqzpaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=racasWCw; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="racasWCw"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493b966dd74so12415695e9.3
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 05:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785415050; x=1786019850; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dT02AVOhJF4DtO5AKa37lS8Oi3+0GF2VjriUvi1Tu4s=;
        b=racasWCw2dptKN/82e5mXnczQqnseiFVpjtbaC+6DmxXr+OmU5MXWKMOOvVgSt3mDz
         J/iIzHhpWU2l17NLBLXp2eA8FRv7MfvYOzeqR4MxWgS+2G83XP95Bgvcpc+t4lxJOQ3s
         VBCsmZeLvLlfn6qFEQRePkyBFL59GZ//+OlA08q6YJ2LizTHCFmSel9oJel/P5DdZtBJ
         gHkmMo0yT0s9Pbc4j8pbsQHskeJp3qugj3PawDgaI+fqs5ltY21orCU1Fbh+Tr46I3ZA
         5dgi32YXlMNhhNH3YD+rQ7vUIs6q54GDp8mfXRsZcVliPmR7FjJ2ZRKkiWsHJYB8fn45
         MkLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785415050; x=1786019850;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dT02AVOhJF4DtO5AKa37lS8Oi3+0GF2VjriUvi1Tu4s=;
        b=QbOhnX3Pm3OYYf6UqGKThhua4qqI+7Mv64ivlTqWEWFXprdTSp3XBIPs0Q4gL8KWwA
         O2eX2LVxgYhO6oJE5UeLUqSfwUhG0U3oOY9ExcqKHy8dP+PSaBZwAaPKUj+JIx/CCGaz
         ISiB84V1I93vVHbwFWTDtPfEigEd/yNrm3f5+/sQz55CDBrpqpu5f3IsMqM7pBBsSzbZ
         NbzUMjn7nqOSimSzmJwzKRe+2JF5kfGn5FEkRqmJ9OMlGx3bm2QZl63/YdHnzwaFqSKD
         bsGNpJXazIQ0r9FcVGSxEMP768/5ZNqLew2ZzAWiAcaxsD+7KaY24XFxvwRWsoA/OEX/
         Xxug==
X-Forwarded-Encrypted: i=1; AHgh+Rp+8XgqdHEBJoFqE13fmGMdPl1KlfngxJ1QeWwAuTZ5qRAupJD4rwrC4KffGZMk+v0nnWXrsSRx0yZKHek=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKn/A9s1Mnao8SO4aSiyaR5RXmbZQt9HorI1zpLbV4pJecwzSs
	h+WL+M268RwgrdN6tadLPjCxmdwlRSL3DKIfKWcku/5/YtdAUFj7xkjv
X-Gm-Gg: AR+sD12b/kDf0EUVWzOWd6qWRn9jXCXZiBI3CMHoMRW+V08K3ZNZIz503oIVRh1Lh7w
	2UfK6T87REwKWXDMGmZMo2ad7SjSVGY0Ah+mlY/GoSbm14fFi3I1asWnOEMkavp376abJiXSze3
	YBs15IK+k7aqMtePsDKAlWYUvEW5Rgq5XpHjyHVjFGpJkFQkQBY8S0K38a6PqPg+dC3XU2QnOX3
	y4UJSuZMu4LM2+1QMvYahSlVOumuSiQLfPJcCcOJMCcqc4csrB+55yq8zJRtbUBPQ7uz99FG2QY
	WGHMkthx9bbfSQ4LTU2DtUW425C6qZ9D83vl4GowzJcaNGK+BBazT9Jbie6a9jjJPwBlSe3lc3W
	0t7v9D/e6fbAjIhA4nB2Ys6LMVwiv3sPlXrOYZ4jhtd9kzRVhcAClIbT8X8I5aBXinNHZvlxWRs
	Bw+dmItVEXNzuRyDYTsJB2nN8/KXfo87EeLdccjSVWWW9HIDU/1IzQ5wd/dDyeKh+9iJqLXf0hr
	e2gxw==
X-Received: by 2002:a05:600c:4e94:b0:496:bbcb:b0bb with SMTP id 5b1f17b1804b1-49800ea0252mr34597875e9.18.1785415049675;
        Thu, 30 Jul 2026 05:37:29 -0700 (PDT)
Received: from arbab-X395.dbs.corp ([110.93.227.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fc88e439asm5406646f8f.11.2026.07.30.05.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 05:37:29 -0700 (PDT)
From: Arbab Haider <arbabhaider649@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Arbab Haider <arbabhaider649@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: hisilicon/sec - Fix use-after-free and unchecked kfifo_put in sec_send_request()
Date: Thu, 30 Jul 2026 17:37:18 +0500
Message-ID: <20260730123718.283971-1-arbabhaider649@gmail.com>
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
hardware queue could accept all elements or that the software queue had
enough space, but failed to account for the case where the software
queue already had pending entries. When the software queue is non-empty,
all new entries must go to the software queue to preserve cipher
chaining ordering, even if the hardware queue has available capacity.

This could lead to two issues:

1. Elements silently dropped from the software queue if
   kfifo_put() returns 0 (queue full), causing the request to never
   complete.

2. Use-after-free if sec_queue_send() returns -EAGAIN after some
   elements were already queued to hardware or software — the error
   path in sec_send_request() returns -EBUSY, and the caller's
   err_free_elements path frees all elements, including those
   referenced by the hardware queue or software queue.

Fix by:

- Checking the return value of kfifo_put() and returning -ENOSPC on
  failure, with a WARN_ON_ONCE since this should not happen with the
  corrected capacity check.

- Catching all errors from sec_queue_send() (not just -EAGAIN) with a
  WARN_ON_ONCE, as this path is unreachable with proper capacity
  accounting.

- Replacing the capacity check with correct logic that accounts for
  the three possible queueing scenarios:
  * Software queue has entries or hardware queue is non-empty: all
    entries go to the software queue → verify software queue capacity
    for all steps.
  * Both queues empty: first entry goes to hardware, rest to software
    → verify hardware can take 1 and software can take steps - 1.
  * No software queue configured: all to hardware → verify hardware
    capacity for all steps.

Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
Signed-off-by: Arbab Haider <arbabhaider649@gmail.com>
---
 drivers/crypto/hisilicon/sec/sec_algs.c | 51 +++++++++++++++++--------
 1 file changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 85eecbb40e7e..6cc08e9a07d0 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -402,14 +402,17 @@ static int sec_send_request(struct sec_request *sec_req, struct sec_queue *queue
 		    (kfifo_is_empty(&queue->softqueue) &&
 		     sec_queue_empty(queue))) {
 			ret = sec_queue_send(queue, &el->req, sec_req);
-			if (ret == -EAGAIN) {
-				/* Wait unti we can send then try again */
-				/* DEAD if here - should not happen */
+			if (ret) {
+				WARN_ON_ONCE(ret == -EAGAIN);
 				ret = -EBUSY;
 				goto err_unlock;
 			}
 		} else {
-			kfifo_put(&queue->softqueue, el);
+			if (!kfifo_put(&queue->softqueue, el)) {
+				WARN_ON_ONCE(1);
+				ret = -ENOSPC;
+				goto err_unlock;
+			}
 		}
 	}
 err_unlock:
@@ -790,28 +793,44 @@ static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
 
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
-- 
2.53.0

