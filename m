Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E521C43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1241C20874
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgIUH7i (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:59:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:58098 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgIUH7b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 32E87B520;
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
Subject: [RFC PATCH 26/41] random: implement support for evaluating larger fast_pool entropies
Date:   Mon, 21 Sep 2020 09:58:42 +0200
Message-Id: <20200921075857.4424-27-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The fast_pools, mixed into from add_interrupt_randomness(), are 128 bits
wide and get awarded at most an entropy value as low as one bit in total.

An upcoming patch will significantly increase the estimated entropy per
event and this will make the fast_pools to receive much larger values
of successively mixed in event entropy.

In analogy to the reasoning in commit 30e37ec516ae ("random: account for
entropy loss due to overwrites"), probabilistic collisions will have to get
accounted for when calculating the total fast_pool entropy.

From said commit, the final fast_pool entropy equals

  e = pool_size * (1 - exp(-num_events * entropy_per_event / pool_size))

Where pool_size is 128 bits in this case and
num_events * entropy_per_event equals the sum of all estimated entropy from
the IRQ events previously mixed in.

Disclaimer: I'm cargo-culting here. That probabilisic overwrites are in
fact an issue sounds plausible after having read e.g. "Balls into Bins" by
M.Raab and A. Steger. But I haven't managed to derive this equation by
myself, nor have I found it in any literature.

Anyway, implement the new fast_pool_entropy() for evaluating the equation
given above by means of a suitable approximation.

add_interrupt_randomness() empties its fast_pool into the global input_pool
whenever the number of accumulated events has reached a threshold of 64
and the input_pool's ->lock is uncontended. Thus, the number of IRQ events
accumulated at the fast_pool can be assumed to be unlikely to exceed
larger factors of 64. The maximum estimate supported for per-IRQ entropy
will be 1 bit and thus, this sets an upper bound on the range where the
approximation is supposed to work well.

At the same time, estimates for the per-IRQ entropy as low as 1/64 bits
should be supported and the approximation should not be too coarse in these
lower regions in order to avoid excessive loss when entropy is likely a
scarce resource anyway.

Apply a piecewise linear approximation to the fast_pool entropy, with
the lengths of the resp. intervals getting doubled with increasing input
values. That is, let the first interval cover 32 bits worth of input
entropy, the next one 64 bits and stop after a final one of length
128 bits. Any input entropy beyond 32 + 64 + 128 bits gets discarded in
order to limit the computations done from interrupt context, but as
outlined above, this is unlikely to matter in practice. The shorter
intervals for the regions of smaller values will improve the accuracy of
the approximation in these areas, i.e. for small estimates for the per-IRQ
entropy.

Note that the new fast_pool_entropy() is not being used anywhere yet, it
will be wired up in an upcoming commit.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 52 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index a985ceb22c7c..ac36c56dd135 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1547,6 +1547,58 @@ static __u32 get_reg(struct fast_pool *f, struct pt_regs *regs)
 	return *ptr;
 }
 
+/*
+ * Calculate the entropy of a fast_pool after num_events IRQ events of
+ * assessed entropy 2^-event_entropy_shift each have been mixed in.
+ */
+static unsigned int fast_pool_entropy(unsigned int num_events,
+				      int event_entropy_shift)
+{
+	unsigned int result, cur, interval_len;
+
+	/*
+	 * Assume that each event fed into the fast_pool
+	 * carries h = 2^-event_entropy_shift bits of entropy.
+	 * In analogy to how entropy deltas are calculated
+	 * in pool_entropy_delta() for the struct entropy_store
+	 * input_pool, a fast_pool which received num_events
+	 * of total entropy num_events * h will contain
+	 * p * (1 - exp(-num_events * h / p)
+	 * bits of entropy, where p equals the poolsize of 128 bits.
+	 *
+	 * Note that most of the time num_events will be ~64, c.f.
+	 * add_interrupt_randomness.  Approximate the resulting
+	 * fast_pool entropy in a piecewise linear manner from below:
+	 * from 0 to 32, from 32 to 96 and from 96 to 224.
+	 * Event entropy above 224 gets simply discarded. For p = 128,
+	 * the calculated fast_pool entropy is ~226 at
+	 * num_events * h == 32, ~540 at 96 and ~846 at 224, all given
+	 * in units of 2^-ENTROPY_SHIFT.
+	 */
+	BUILD_BUG_ON(sizeof(((struct fast_pool *)NULL)->pool) != 16);
+	BUILD_BUG_ON(ENTROPY_SHIFT != 3);
+
+	/* Interval from 0 to 32. */
+	interval_len = 32 << event_entropy_shift;
+	cur = min_t(unsigned int, num_events, interval_len);
+	result = (226 * cur) >> 5; /* shift is for /32 */
+	num_events -= cur;
+
+	/* Interval of length 64 from 32 to 96. */
+	interval_len <<= 1;
+	cur = min_t(unsigned int, num_events, interval_len);
+	result += ((540 - 226) * cur) >> 6; /* shift is for /64 */
+	num_events -= cur;
+
+	/* Interval of length 128 from 96 to 224. */
+	interval_len <<= 1;
+	cur = min_t(unsigned int, num_events, interval_len);
+	result += ((846 - 540) * cur) >> 7; /* shift is for /128 */
+
+	/* Return value is in units of 2^-ENTROPY_SHIFT. */
+	return result >> event_entropy_shift;
+}
+
 void add_interrupt_randomness(int irq, int irq_flags)
 {
 	struct entropy_store	*r;
-- 
2.26.2

