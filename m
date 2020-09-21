Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E34C43466
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 502B7214F1
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgIUIBI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:01:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:57542 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgIUH7j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D4E8DB52D;
        Mon, 21 Sep 2020 08:00:08 +0000 (UTC)
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
Subject: [RFC PATCH 34/41] random: implement the "Adaptive Proportion" NIST SP800-90B health test
Date:   Mon, 21 Sep 2020 09:58:50 +0200
Message-Id: <20200921075857.4424-35-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

NIST SP800-90B requires an implementation of the "Adaptive Proportion"
health test (APT) or similar for detecting noise source entropy
degradations.

This tests works by counting how many times the first sample value in a
sequence of n events occurs among the remaining n-1 samples. The test will
reject if this number exceeds a certain threshold.

With a min-entropy estimate of H=2^-event_entropy_shift per IRQ event, the
probability of observing any particular sample value is bounded by
p <= 2^-H. Assuming i.i.d., the number of occurences of such a sample
value among n - 1 events follows the binomial distribution with parameters
n - 1 and p. The probability to observe up to k occurences of a given
sample value is not less than that distribution's CDF F(n - 1, p, k) at
point k, per the definition of CDFs and the fact that
F(n - 1, p1, k) >= F(n - 1, p2, k) for p1 <= p2 in the particular case of
Binomial distributions. It follows that an upper bound on the probability
of observing the same value c or more times among n - 1 consecutive samples
is given by 1 - F(n - 1, p, c - 1). In conclusion, the probability of false
positives is <= p * (1 - F(n - 1, p, c - 1)) for the Adaptive Proportion
test.

NIST SP800-90B recommends to set n to either 512 or 1024 and to choose a
cut-off value c such that the probability of false positives is <= 2^-20.
However, assuming an estimated per-IRQ entropy of 1 bit, it would take
1024/128 == 8 minimum crng seed sizes worth of entropy before the APT
eventually completes and the accumulated entropy may get released to the
global reserve. Thus, it is desirable to set n such that the APT will
complete within 128 bits worth of entropy, i.e. to n = 128 / H. However,
for such relatively small values of n, an upper bound as small as 2^-20
for the false positives probability would make the test's statistical
power, i.e. the capability to detect degraded noise sources, plummet to
uselessness. Note that add_interrupt_randomness() will continue to
unconditionally mix all events into the fast_pools, independent of the
APT's outcome. Thus, allowing for a higher probability of false positives
cannot change the output distribution, but only potentially affect the
entropy accounting. Choose an upper bound of 2^-16 for the probability of
false positives.

The resulting cut-off values for the different supported values of per-IRQ
entropy estimates are tabulated below. The "power" column lists the
probabilities (again for i.i.d.) that the APT would report a failure in
case the actual entropy has degraded to one half of the assumed estimate.

   H     n   c    power
   --------------------
      1  128   87 52.5%
    1/2  256  210 67.5%
    1/4  512  463 76.7%
    1/8 1024  973 82.8%
   1/16 2048 1997 82.6%
   1/32 4096 4044 85.8%
   1/64 8192 8140 85.8%

Add a couple of new fields to struct health_test for storing the required
APT state to struct health_test:
 - ->apt_event_count: total number of samples processed by the currently
     pending APT,
 - ->apt_candidate: the sample value whose number of occurences the
     currently pending APT is counting,
 - ->apt_candidate_count: the number of occurences of ->apt_candidate
     the currently pending APT has encountered so far.

Implement the APT logic and wrap it in a new function, health_test_apt().
Invoke it from health_test_process().

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 56 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 33f9b7b59f92..131302cbc495 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -880,6 +880,10 @@ static void discard_queued_entropy(struct entropy_store *r,
 }
 
 struct health_test {
+	unsigned short apt_event_count;
+	unsigned short apt_candidate_count;
+	u8 apt_candidate;
+
 	u8 previous_sample;
 };
 
@@ -890,8 +894,56 @@ enum health_result {
 	health_discard,
 };
 
+/* Adaptive Proportion Test */
+static void health_apt_reset(struct health_test *h)
+{
+	h->apt_event_count = 0;
+}
+
+static enum health_result
+health_test_apt(struct health_test *h, unsigned int event_entropy_shift,
+		u8 sample_delta)
+{
+	unsigned int n = 128 << event_entropy_shift;
+	/*
+	 * Observing some particular sample value more often than
+	 * these thresholds, specified for the different possible
+	 * values of event_entropy_shift each, should have probability
+	 * <= 2^-16.
+	 */
+	static const unsigned int c[] = {87, 210, 463, 973, 1997, 4044, 8140};
+
+	if (!h->apt_event_count) {
+		h->apt_event_count = 1;
+		h->apt_candidate = sample_delta;
+		h->apt_candidate_count = 0;
+		return health_queue;
+	}
+
+	++h->apt_event_count;
+	if (unlikely(h->apt_candidate == sample_delta &&
+		     ++h->apt_candidate_count == c[event_entropy_shift])) {
+		health_apt_reset(h);
+		return health_discard;
+	} else if (c[event_entropy_shift] - h->apt_candidate_count >
+		   n - h->apt_event_count) {
+		/*
+		 * The currently pending APT might not have seen all n
+		 * events yet, but it's already known by now that it
+		 * can't fail anymore. Note that the above condition
+		 * also coverts the case h->apt_event_count == n.
+		 */
+		health_apt_reset(h);
+		return health_dispatch;
+	}
+
+	return health_queue;
+}
+
 static void health_test_reset(struct health_test *h)
-{}
+{
+	health_apt_reset(h);
+}
 
 static enum health_result
 health_test_process(struct health_test *h, unsigned int event_entropy_shift,
@@ -907,7 +959,7 @@ health_test_process(struct health_test *h, unsigned int event_entropy_shift,
 	sample_delta = sample - h->previous_sample;
 	h->previous_sample = sample;
 
-	return health_none;
+	return health_test_apt(h, event_entropy_shift, sample_delta);
 }
 
 struct fast_pool {
-- 
2.26.2

