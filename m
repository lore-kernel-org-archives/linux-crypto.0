From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [ANNOUNCE] 3.18.7-rt1
Date: Mon, 16 Feb 2015 19:13:36 +0100
Message-ID: <20150216181336.GJ21649@linutronix.de>
References: <20150216111822.GA21649@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: LKML <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
	John Kacur <jkacur@redhat.com>, 'NeilBrown <neilb@suse.de>,
	'@linutronix.de, 'Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:39085 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbbBPSNs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Feb 2015 13:13:48 -0500
Content-Disposition: inline
In-Reply-To: <20150216111822.GA21649@linutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Sebastian Andrzej Siewior | 2015-02-16 12:18:22 [+0100]:

>Known issues:
>
>      - xor / raid_pq
>        I had max latency jumping up to 67563us on one CPU while the next
>        lower max was 58us. I tracked it down to module's init code of
>        xor and raid_pq. Both disable preemption while measuring the
>        measuring the performance of the individual implementation.

The patch at the bottom gets rid of it.

How important is this preempt_disable() and how likely is that we could
use precomputed priority lists of function instead this of this runtime
check? XOR already prefers AVX based-xor if available and numbers/test
at runtime could be removed.
Is there a case where SSE worse on CPU X better than MMX and this is why
we do it?

diff --git a/crypto/xor.c b/crypto/xor.c
index 35d6b3a..19e20f5 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -70,7 +70,7 @@ do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
 	tmpl->next = template_list;
 	template_list = tmpl;
 
-	preempt_disable();
+	preempt_disable_nort();
 
 	/*
 	 * Count the number of XORs done during a whole jiffy, and use
@@ -94,7 +94,7 @@ do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
 			max = count;
 	}
 
-	preempt_enable();
+	preempt_enable_nort();
 
 	speed = max * (HZ * BENCH_SIZE / 1024);
 	tmpl->speed = speed;
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 7d0e5cd..e9920d4 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -142,7 +142,7 @@ static inline const struct raid6_calls *raid6_choose_gen(
 
 			perf = 0;
 
-			preempt_disable();
+			preempt_disable_nort();
 			j0 = jiffies;
 			while ((j1 = jiffies) == j0)
 				cpu_relax();
@@ -151,7 +151,7 @@ static inline const struct raid6_calls *raid6_choose_gen(
 				(*algo)->gen_syndrome(disks, PAGE_SIZE, *dptrs);
 				perf++;
 			}
-			preempt_enable();
+			preempt_enable_nort();
 
 			if (perf > bestperf) {
 				bestperf = perf;


Sebastian
