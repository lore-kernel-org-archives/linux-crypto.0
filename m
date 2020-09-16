Return-Path: <SRS0=gkSk=CZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21DE3C43461
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 23:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E71C822208
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 23:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600299162;
	bh=YveDhBwvoeRGYCRew1QwRj1hZ0CuYNkymKUCujomPgc=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=cguuFhlDH+YMWNWy8eB8wQFuVWkBObux8UsTZTbmIgRGl/YcNJWijZOL0eb9Zbcww
	 5XGQyeb8vH1hbm/AmRJq14TbaDtV6APvoZUMFMWY/K4eRaBqpgBzgFpPcTnT+75OoN
	 89qn6QZjBB15YskDxknQ8VkPvYAI0xnD3HEGjhIQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgIPXch (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Sep 2020 19:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgIPXcg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Sep 2020 19:32:36 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D2AD22207;
        Wed, 16 Sep 2020 23:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600299155;
        bh=YveDhBwvoeRGYCRew1QwRj1hZ0CuYNkymKUCujomPgc=;
        h=From:To:Cc:Subject:Date:From;
        b=JClFuT8e/pJa6a+NWybQFhtn0sLipLrdkUcQJ1S657m9J20YmW3LWgrV0V5DW079t
         VmQ1Csr/q2DDuddWfC2h5TnnQ1JbJLaYnP3dFMJE9JjvRoeHuDyobJ0fQtX8FyTARV
         LX6Ai5++v92JUuYFYN1gwpdjQvpNJtYxkdoeGfZA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] random: use correct memory barriers for crng_node_pool
Date:   Wed, 16 Sep 2020 16:30:42 -0700
Message-Id: <20200916233042.51634-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When a CPU selects which CRNG to use, it accesses crng_node_pool without
a memory barrier.  That's wrong, because crng_node_pool can be set by
another CPU concurrently.  Without a memory barrier, the crng_state that
is used might not appear to be fully initialized.

There's an explicit mb() on the write side, but it's redundant with
cmpxchg() (or cmpxchg_release()) and does nothing to fix the read side.

Implement this correctly by using a cmpxchg_release() +
smp_load_acquire() pair.

Fixes: 1e7f583af67b ("random: make /dev/urandom scalable for silly userspace programs")
Cc: <stable@vger.kernel.org> # v4.8+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/char/random.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 09b1551d4092f..9f1e7a4a0fbbb 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -843,8 +843,8 @@ static void do_numa_crng_init(struct work_struct *work)
 		crng_initialize_secondary(crng);
 		pool[i] = crng;
 	}
-	mb();
-	if (cmpxchg(&crng_node_pool, NULL, pool)) {
+	/* pairs with smp_load_acquire() in select_crng() */
+	if (cmpxchg_release(&crng_node_pool, NULL, pool) != NULL) {
 		for_each_node(i)
 			kfree(pool[i]);
 		kfree(pool);
@@ -857,8 +857,26 @@ static void numa_crng_init(void)
 {
 	schedule_work(&numa_crng_init_work);
 }
+
+static inline struct crng_state *select_crng(void)
+{
+	struct crng_state **pool;
+	int nid = numa_node_id();
+
+	/* pairs with cmpxchg_release() in do_numa_crng_init() */
+	pool = smp_load_acquire(&crng_node_pool);
+	if (pool && pool[nid])
+		return pool[nid];
+
+	return &primary_crng;
+}
 #else
 static void numa_crng_init(void) {}
+
+static inline struct crng_state *select_crng(void)
+{
+	return &primary_crng;
+}
 #endif
 
 /*
@@ -1005,15 +1023,7 @@ static void _extract_crng(struct crng_state *crng,
 
 static void extract_crng(__u8 out[CHACHA_BLOCK_SIZE])
 {
-	struct crng_state *crng = NULL;
-
-#ifdef CONFIG_NUMA
-	if (crng_node_pool)
-		crng = crng_node_pool[numa_node_id()];
-	if (crng == NULL)
-#endif
-		crng = &primary_crng;
-	_extract_crng(crng, out);
+	_extract_crng(select_crng(), out);
 }
 
 /*
@@ -1042,15 +1052,7 @@ static void _crng_backtrack_protect(struct crng_state *crng,
 
 static void crng_backtrack_protect(__u8 tmp[CHACHA_BLOCK_SIZE], int used)
 {
-	struct crng_state *crng = NULL;
-
-#ifdef CONFIG_NUMA
-	if (crng_node_pool)
-		crng = crng_node_pool[numa_node_id()];
-	if (crng == NULL)
-#endif
-		crng = &primary_crng;
-	_crng_backtrack_protect(crng, tmp, used);
+	_crng_backtrack_protect(select_crng(), tmp, used);
 }
 
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
-- 
2.28.0

