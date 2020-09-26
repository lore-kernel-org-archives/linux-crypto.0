Return-Path: <SRS0=CR7J=DD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BE4C4727F
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Sep 2020 10:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7672C238E5
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Sep 2020 10:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601116024;
	bh=/9CtSjxFQfSsddr24DMLGCw8WbTrj3ejM5RVjJ3ZANw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=GndZxE5tuhldNnPTDUU1ABQFxphEn8L8+3IVAQ5hXOrvpAUi9uYYjTSgF/F5IweU0
	 OjoGwQ4qN0eWPsmOLAfw0IQj0vtzB7cNAa8YfAZWQoutRRgeY1KthsPqJ2NoRDVxyD
	 rf3NoHeY3jnl26+GG7s8n+RVi5RAqkEx+f7Gyqcw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgIZK1D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 26 Sep 2020 06:27:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgIZK1B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Sep 2020 06:27:01 -0400
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A859238EE;
        Sat, 26 Sep 2020 10:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601116020;
        bh=/9CtSjxFQfSsddr24DMLGCw8WbTrj3ejM5RVjJ3ZANw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0iiZ9/JKV0Q40qTMk+STOwH8vSE2/AmyRQcRXMcF5veebm5WS1deY2cRr9M2CbU/y
         20QJaNOYa4eDKHORE/FtwjlrKkexEB6AzyOfSdz1aCrNMap7k5+eVR7eUl08+EhsnM
         7PzjNqDLA3PDvRVRfQ1mygImdW3fOVdSuel4hmO8=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        David Laight <David.Laight@aculab.com>
Subject: [PATCH v2 2/2] crypto: xor - use ktime for template benchmarking
Date:   Sat, 26 Sep 2020 12:26:51 +0200
Message-Id: <20200926102651.31598-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200926102651.31598-1-ardb@kernel.org>
References: <20200926102651.31598-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, we use the jiffies counter as a time source, by staring at
it until a HZ period elapses, and then staring at it again and perform
as many XOR operations as we can at the same time until another HZ
period elapses, so that we can calculate the throughput. This takes
longer than necessary, and depends on HZ, which is undesirable, since
HZ is system dependent.

Let's use the ktime interface instead, and use it to time a fixed
number of XOR operations, which can be done much faster, and makes
the time spent depend on the performance level of the system itself,
which is much more reasonable. To ensure that we have the resolution
we need even on systems with 32 kHz time sources, while not spending too
much time in the benchmark on a slow CPU, let's switch to 3 attempts of
800 repetitions each: that way, we will only misidentify algorithms that
perform within 10% of each other as the fastest if they are faster than
10 GB/s to begin with, which is not expected to occur on systems with
such coarse clocks.

On ThunderX2, I get the following results:

Before:

  [72625.956765] xor: measuring software checksum speed
  [72625.993104]    8regs     : 10169.000 MB/sec
  [72626.033099]    32regs    : 12050.000 MB/sec
  [72626.073095]    arm64_neon: 11100.000 MB/sec
  [72626.073097] xor: using function: 32regs (12050.000 MB/sec)

After:

  [72599.650216] xor: measuring software checksum speed
  [72599.651188]    8regs           : 10491 MB/sec
  [72599.652006]    32regs          : 12345 MB/sec
  [72599.652871]    arm64_neon      : 11402 MB/sec
  [72599.652873] xor: using function: 32regs (12345 MB/sec)

Link: https://lore.kernel.org/linux-crypto/20200923182230.22715-3-ardb@kernel.org/
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/xor.c | 38 +++++++++-----------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/crypto/xor.c b/crypto/xor.c
index b42c38343733..a0badbc03577 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -76,49 +76,43 @@ static int __init register_xor_blocks(void)
 }
 #endif
 
-#define BENCH_SIZE (PAGE_SIZE)
+#define BENCH_SIZE	4096
+#define REPS		800U
 
 static void __init
 do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
 {
 	int speed;
-	unsigned long now, j;
-	int i, count, max;
+	int i, j, count;
+	ktime_t min, start, diff;
 
 	tmpl->next = template_list;
 	template_list = tmpl;
 
 	preempt_disable();
 
-	/*
-	 * Count the number of XORs done during a whole jiffy, and use
-	 * this to calculate the speed of checksumming.  We use a 2-page
-	 * allocation to have guaranteed color L1-cache layout.
-	 */
-	max = 0;
-	for (i = 0; i < 5; i++) {
-		j = jiffies;
-		count = 0;
-		while ((now = jiffies) == j)
-			cpu_relax();
-		while (time_before(jiffies, now + 1)) {
+	min = (ktime_t)S64_MAX;
+	for (i = 0; i < 3; i++) {
+		start = ktime_get();
+		for (j = 0; j < REPS; j++) {
 			mb(); /* prevent loop optimzation */
 			tmpl->do_2(BENCH_SIZE, b1, b2);
 			mb();
 			count++;
 			mb();
 		}
-		if (count > max)
-			max = count;
+		diff = ktime_sub(ktime_get(), start);
+		if (diff < min)
+			min = diff;
 	}
 
 	preempt_enable();
 
-	speed = max * (HZ * BENCH_SIZE / 1024);
+	// bytes/ns == GB/s, multiply by 1000 to get MB/s [not MiB/s]
+	speed = (1000 * REPS * BENCH_SIZE) / (unsigned int)ktime_to_ns(min);
 	tmpl->speed = speed;
 
-	printk(KERN_INFO "   %-10s: %5d.%03d MB/sec\n", tmpl->name,
-	       speed / 1000, speed % 1000);
+	pr_info("   %-16s: %5d MB/sec\n", tmpl->name, speed);
 }
 
 static int __init
@@ -158,8 +152,8 @@ calibrate_xor_blocks(void)
 		if (f->speed > fastest->speed)
 			fastest = f;
 
-	printk(KERN_INFO "xor: using function: %s (%d.%03d MB/sec)\n",
-	       fastest->name, fastest->speed / 1000, fastest->speed % 1000);
+	pr_info("xor: using function: %s (%d MB/sec)\n",
+	       fastest->name, fastest->speed);
 
 #undef xor_speed
 
-- 
2.17.1

