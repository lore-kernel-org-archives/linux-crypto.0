Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18076C43466
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D393C20BED
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgIUIAx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:00:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:57440 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbgIUH7k (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C5D09B523;
        Mon, 21 Sep 2020 08:00:04 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Roman Drahtmueller <draht@schaltsekun.de>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Torsten Duwe <duwe@suse.de>, Petr Tesarik <ptesarik@suse.cz>,
        Nicolai Stange <nstange@suse.de>
Subject: [RFC PATCH 27/41] random: increase per-IRQ event entropy estimate if in FIPS mode
Date:   Mon, 21 Sep 2020 09:58:43 +0200
Message-Id: <20200921075857.4424-28-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

NIST SP800-90C prohibits the use of multiple correlated entropy sources.
However, add_interrupt_randomness(), add_disk_randomness() and
add_input_randomness() are clearly not independent and an upcoming patch
will make the latter two to stop contributing any entropy to the global
balance if fips_enabled is on.

With the current parameter settings, it can be assumed that
add_disk_randomness() resp. add_input_randomness() are the dominating
contributors to the overall entropy reserve for some common workloads: both
more or less estimate the entropy per event to equal the width of the
minimum out of the first, second and third jiffes deltas to the previous
occurrence.

add_interrupt_randomness() on the other hand only attributes one single bit
entropy to a full batch of 64 IRQ events (or once a second if that
completes earlier).

Thus, the upcoming exclusion of two potent entropy sources should somehow
be compensated for.

Stephan Müller worked around this very problem in his "LRNG" proposal ([1])
by increasing the entropy estimate per IRQ event. Namely, in case a
get_cycles() with instruction granularity is available, he estimated one
bit of entropy per IRQ event and (IIRC) 1/10 bits otherwise. I haven't
tested this claim myself, in particular not on smaller devices. But for the
sake of moving the development of this RFC series forward, I'll assume it
as granted and hereby postulate that

  The lower eight bits of the differences between get_cycles() from two
  successive IRQ events on the same CPU carry
  - one bit of min-entropy in case a get_cycles() with instruction
    granularity is available and
  - 1/8 bit of min-entropy in case get_cycles() is still non-trivial, but
    has a lower resolution.

In particular this is assumed to be true for highly periodic interrupts
like those issued for e.g. USB microframes and on all supported
architectures. In the former case, the underlying source of randomness is
believed to follow the same principles as for the Jitter RNGs resp.
try_to_generate_entropy(): diffences in RAM vs. CPU clockings and
unpredictability of cache states to a certain extent.

Notes:
- NIST SP800-90B requires a means to access raw samples for validation
  purposes. Implementation of such an interface is deliberately not part
  of this RFC series here, but would necessarily be subject of future work.
  So there would be a means to at least validate these assumptions.
- The choice of 1/8 over the 1/10 from the LRNG patchset has been made
  because it's a power of two and I suppose that the estimate of 1/10
  had been quite arbitrary anyway. Replacement of the 1/8 by smaller
  powers of two down to 1/64 will be supported throughout this patch
  series.

Some health tests as required by NIST SP800-90B will be implemented later
in this series. In order to allow for dynamically decreasing the assessed
entropy on a per-CPU basis upon health test failures, make it an attibute
of the per-CPU struct fast_pool. That is, introduce a new integer field
->event_entropy_shift to struct fast_pool. The estimated entropy per
IRQ sample will be calculated as 2^-event_entropy_shift. Initialize it
statically with -1 to indicate that runtime initialization hasn't happened
yet. Introduce fast_pool_init_accounting() which gets called
unconditionally from add_interrupt_randomness() for doing the necessary
runtime initializations once, i.e. if ->event_entropy_shift is
still found to be negative. Implement it with the help of the also new
min_irq_event_entropy_shift(), which will return the initial
->event_entropy_shift value as determined according to the rules from
above. That is, depending on the have_highres_cycle_ctr, the result is
eiher zero or three. Note that have_highres_cycle_ctr will only get
properly initialized from rand_initialize() if fips_enabled is set, but
->event_entropy_shift will also only ever get accessed in this case.

Finally, for the case tha fips_enabled is set, make
add_interrupt_randomness() to estimate the amount of entropy transferred
from the fast_pool into the global input_pool as
fast_pool_entropy(->count, ->event_entropy_shift), rather than only one
single bit. Remember that fast_pool_entropy() calculates the amount of
entropy contained in a fast_pool, based on the total number of events mixed
into it and the estimated entropy per event.

[1] https://lkml.kernel.org/r/5695397.lOV4Wx5bFT@positron.chronox.de

Suggested-by: Stephan Müller <smueller@chronox.de>
Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 50 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 5 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index ac36c56dd135..8f79e90f2429 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -615,6 +615,7 @@ struct fast_pool {
 	unsigned long	last;
 	unsigned short	reg_idx;
 	unsigned char	count;
+	int		event_entropy_shift;
 };
 
 /*
@@ -1509,7 +1510,9 @@ void add_input_randomness(unsigned int type, unsigned int code,
 }
 EXPORT_SYMBOL_GPL(add_input_randomness);
 
-static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
+static DEFINE_PER_CPU(struct fast_pool, irq_randomness) = {
+	.event_entropy_shift = -1,
+};
 
 #ifdef ADD_INTERRUPT_BENCH
 static unsigned long avg_cycles, avg_deviation;
@@ -1599,6 +1602,32 @@ static unsigned int fast_pool_entropy(unsigned int num_events,
 	return result >> event_entropy_shift;
 }
 
+static inline int min_irq_event_entropy_shift(void)
+{
+	if (static_branch_likely(&have_highres_cycle_ctr)) {
+		/*
+		 * If a cycle counter with a good enough resolution is
+		 * available, estimate the entropy per IRQ event to
+		 * be no more than 2^-0 == 1 bit.
+		 */
+		return 0;
+	}
+
+	/*
+	 * Otherwise return an estimate upper bound of
+	 * 2^-3 == 1/8 bit per event.
+	 */
+	return 3;
+}
+
+static inline void fast_pool_init_accounting(struct fast_pool *f)
+{
+	if (likely(f->event_entropy_shift >= 0))
+		return;
+
+	f->event_entropy_shift = min_irq_event_entropy_shift();
+}
+
 void add_interrupt_randomness(int irq, int irq_flags)
 {
 	struct entropy_store	*r;
@@ -1610,6 +1639,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	__u64			ip;
 	bool			reseed;
 	struct queued_entropy	q = { 0 };
+	unsigned int		nfrac;
 
 	if (cycles == 0)
 		cycles = get_reg(fast_pool, regs);
@@ -1644,13 +1674,23 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	if (!spin_trylock(&r->lock))
 		return;
 
-	fast_pool->last = now;
-	fast_pool->count = 0;
-	/* award one bit for the contents of the fast pool */
-	__queue_entropy(r, &q, 1 << ENTROPY_SHIFT);
+	fast_pool_init_accounting(fast_pool);
+
+	if (!fips_enabled) {
+		/* award one bit for the contents of the fast pool */
+		nfrac = 1 << ENTROPY_SHIFT;
+	} else {
+		nfrac = fast_pool_entropy(fast_pool->count,
+					  fast_pool->event_entropy_shift);
+	}
+	__queue_entropy(r, &q, nfrac);
 	__mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool));
 	reseed = __dispatch_queued_entropy_fast(r, &q);
 	spin_unlock(&r->lock);
+
+	fast_pool->last = now;
+	fast_pool->count = 0;
+
 	if (reseed)
 		crng_reseed(&primary_crng, r);
 }
-- 
2.26.2

