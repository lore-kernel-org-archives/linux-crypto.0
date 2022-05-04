Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B75BC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  4 May 2022 15:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343747AbiEDPLQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 May 2022 11:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351796AbiEDPLP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 May 2022 11:11:15 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C01A222A3
        for <linux-crypto@vger.kernel.org>; Wed,  4 May 2022 08:07:38 -0700 (PDT)
Date:   Wed, 4 May 2022 17:07:36 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651676857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=KszxlE4B8Pm/V8KfDnWJmcbPmgg7bKJHJz4sjANiRqg=;
        b=0iaoabmX/xxdE+8FB6N0BNC+z+PP/Sq5qUZON6eRgy13t90dljlV8i4BaLLQdFQHY+2duk
        YrzLC4FfpaOI5GkazZUyNKXtdttVCXuWs1W0cRj9m+sujKp98H0v3MDfRXGdVHqd2vcf2y
        8oahXpkw2Kuze/v9d6ysmLaNyFzdZA8Rmti9exsiIJwgI1je+f65LFELBi384QxVH6Ucay
        p+I6J1PuCbJIO1K/h6ZsZJU3pQJxcex+EygMs+5MsDAq6jqYsjjMGbzmu8RspSiHc/9NU4
        yYsS3TcKSx5YtTtvTeS3G9uAYGJKRpC+PyA+RNvq+Qj7cUzaFp4QaAS1EsnmZw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651676857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=KszxlE4B8Pm/V8KfDnWJmcbPmgg7bKJHJz4sjANiRqg=;
        b=1r0qlin2txysN1vn+lxqHZPWEIqP8akJsoSUcJLAAQYFEb5BSZKdIB8n27K1X2+FHpKgdH
        ZgPXhOrY8NKHBkAw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] crypto: cryptd - Protect per-CPU resource by disabling BH.
Message-ID: <YnKWuLQZdPwSdRTh@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The access to cryptd_queue::cpu_queue is synchronized by disabling
preemption in cryptd_enqueue_request() and disabling BH in
cryptd_queue_worker(). This implies that access is allowed from BH.

If cryptd_enqueue_request() is invoked from preemptible context _and_
soft interrupt then this can lead to list corruption since
cryptd_enqueue_request() is not protected against access from
soft interrupt.

Replace get_cpu() in cryptd_enqueue_request() with local_bh_disable()
to ensure BH is always disabled.
Remove preempt_disable() from cryptd_queue_worker() since it is not
needed because local_bh_disable() ensures synchronisation.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 crypto/cryptd.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index a1bea0f4baa88..668095eca0faf 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -39,6 +39,10 @@ struct cryptd_cpu_queue {
 };
 
 struct cryptd_queue {
+	/*
+	 * Protected by disabling BH to allow enqueueing from softinterrupt and
+	 * dequeuing from kworker (cryptd_queue_worker()).
+	 */
 	struct cryptd_cpu_queue __percpu *cpu_queue;
 };
 
@@ -125,28 +129,28 @@ static void cryptd_fini_queue(struct cryptd_queue *queue)
 static int cryptd_enqueue_request(struct cryptd_queue *queue,
 				  struct crypto_async_request *request)
 {
-	int cpu, err;
+	int err;
 	struct cryptd_cpu_queue *cpu_queue;
 	refcount_t *refcnt;
 
-	cpu = get_cpu();
+	local_bh_disable();
 	cpu_queue = this_cpu_ptr(queue->cpu_queue);
 	err = crypto_enqueue_request(&cpu_queue->queue, request);
 
 	refcnt = crypto_tfm_ctx(request->tfm);
 
 	if (err == -ENOSPC)
-		goto out_put_cpu;
+		goto out;
 
-	queue_work_on(cpu, cryptd_wq, &cpu_queue->work);
+	queue_work_on(smp_processor_id(), cryptd_wq, &cpu_queue->work);
 
 	if (!refcount_read(refcnt))
-		goto out_put_cpu;
+		goto out;
 
 	refcount_inc(refcnt);
 
-out_put_cpu:
-	put_cpu();
+out:
+	local_bh_enable();
 
 	return err;
 }
@@ -162,15 +166,10 @@ static void cryptd_queue_worker(struct work_struct *work)
 	cpu_queue = container_of(work, struct cryptd_cpu_queue, work);
 	/*
 	 * Only handle one request at a time to avoid hogging crypto workqueue.
-	 * preempt_disable/enable is used to prevent being preempted by
-	 * cryptd_enqueue_request(). local_bh_disable/enable is used to prevent
-	 * cryptd_enqueue_request() being accessed from software interrupts.
 	 */
 	local_bh_disable();
-	preempt_disable();
 	backlog = crypto_get_backlog(&cpu_queue->queue);
 	req = crypto_dequeue_request(&cpu_queue->queue);
-	preempt_enable();
 	local_bh_enable();
 
 	if (!req)
-- 
2.36.0

