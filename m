Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B25245022
	for <linux-crypto@vger.kernel.org>; Tue,  1 Jul 2025 06:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751350182; cv=none; b=H7t9pV6DgAVqBYk70ztwdMphVfJ8gS+Np1dR7v0cF+nk3GqCgjzoRDan3/Iz7UQ+XoHiCaTkJ8bCPaPY2mUtwIEMMJBIwAK1+Nl65/ivkpPkmNwlz43T4DZh+AYaPVYp17mEQWvVj/TTmFPOy6yAyTz/ytO+DlnPDfQBOYAbqwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751350182; c=relaxed/simple;
	bh=sZn1KgN8tgaYqNBol75eRQI21Lp06foomJyqYe+MuVA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CkrT3UutzLLKVJIbBmzswAUaCZqtAgupZ2fUT42Q08eMrolBofedpB/UXWMgr5y+hUTRwJsskW9UYYNSEk9A6ceUL2xv3xRwIi5ErBzl1g7kl/mCDxVQNP+Oya/DlgqaMJSkepZETyxcbUR/hefYVonWNA2uxOMixg7H33LbjH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=jVlGCc7S; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=BrpUd7oo; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="jVlGCc7S";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="BrpUd7oo"
Date: Tue, 1 Jul 2025 08:09:36 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1751350178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=EiFSlrqpPfW1qkmBUTfWyy6a5h5zZAAmZJTwZwnI47E=;
	b=jVlGCc7SFyom6K2ufBasnRNTrgiDWKOW32UWYUV1Laq9qW4yMqmP9b2WqYUzjQybuI5BAP
	8EKN++Z19IewDxxLpce0wb+j4cb+WCWuTAv7PzXL1i8T4cJ0Y+5NqOUgFGWEds/lh5Us5z
	PQMrW2RGFPcjs3T5S1UQW1tmyYdUQHL5Su/ekvhISG1O6CFwnVLebI5gy0TMaY3174MHy/
	uwN9YjBDrfNMihxCAoolPsy49OZmdXndc1GZk3KL8Q3DT9unILIn6UF7CAXRglXeWx9bvv
	h16pYGFZb9606s+QAHwCv3GUZaQ17tZUuIiT4xrIBMNt/tpzbY4eEzcIj3iVFA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1751350178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=EiFSlrqpPfW1qkmBUTfWyy6a5h5zZAAmZJTwZwnI47E=;
	b=BrpUd7oofoVsBct+x62gPKUUOB96Aba7Tubgz/ZlqFAwyfbSHvPPl+59Mo3/yG0O8o37Ln
	KypoegolQc3qkgDg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-crypto@vger.kernel.org, linux-rt-devel@lists.linux.dev
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Cc: 
	Thomas Gleinxer <tglx@linutronix.de>;
Subject: [PATCH] cryptd: Use nested-BH locking for cryptd_cpu_queue
Message-ID: <20250701060936.r4gtQv9v@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

cryptd_queue::cryptd_cpu_queue is a per-CPU variable and relies on
disabled BH for its locking. Without per-CPU locking in
local_bh_disable() on PREEMPT_RT this data structure requires explicit
locking.

Add a local_lock_t to the struct cryptd_cpu_queue and use
local_lock_nested_bh() for locking. This change adds only lockdep
coverage and does not alter the functional behaviour for !PREEMPT_RT.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

This patch requires a prerequisite for __local_lock_nested_bh() which
has been made available at
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git local-lock-for-net

It can be pulled in so that the crypto bits are independent of the TIP
tree.

 crypto/cryptd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 5bb6f8d88cc2e..efff54e707cb5 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -34,6 +34,7 @@ MODULE_PARM_DESC(cryptd_max_cpu_qlen, "Set cryptd Max queue depth");
 static struct workqueue_struct *cryptd_wq;
 
 struct cryptd_cpu_queue {
+	local_lock_t bh_lock;
 	struct crypto_queue queue;
 	struct work_struct work;
 };
@@ -110,6 +111,7 @@ static int cryptd_init_queue(struct cryptd_queue *queue,
 		cpu_queue = per_cpu_ptr(queue->cpu_queue, cpu);
 		crypto_init_queue(&cpu_queue->queue, max_cpu_qlen);
 		INIT_WORK(&cpu_queue->work, cryptd_queue_worker);
+		local_lock_init(&cpu_queue->bh_lock);
 	}
 	pr_info("cryptd: max_cpu_qlen set to %d\n", max_cpu_qlen);
 	return 0;
@@ -135,6 +137,7 @@ static int cryptd_enqueue_request(struct cryptd_queue *queue,
 	refcount_t *refcnt;
 
 	local_bh_disable();
+	local_lock_nested_bh(&queue->cpu_queue->bh_lock);
 	cpu_queue = this_cpu_ptr(queue->cpu_queue);
 	err = crypto_enqueue_request(&cpu_queue->queue, request);
 
@@ -151,6 +154,7 @@ static int cryptd_enqueue_request(struct cryptd_queue *queue,
 	refcount_inc(refcnt);
 
 out:
+	local_unlock_nested_bh(&queue->cpu_queue->bh_lock);
 	local_bh_enable();
 
 	return err;
@@ -169,8 +173,10 @@ static void cryptd_queue_worker(struct work_struct *work)
 	 * Only handle one request at a time to avoid hogging crypto workqueue.
 	 */
 	local_bh_disable();
+	__local_lock_nested_bh(&cpu_queue->bh_lock);
 	backlog = crypto_get_backlog(&cpu_queue->queue);
 	req = crypto_dequeue_request(&cpu_queue->queue);
+	__local_unlock_nested_bh(&cpu_queue->bh_lock);
 	local_bh_enable();
 
 	if (!req)
-- 
2.50.0

