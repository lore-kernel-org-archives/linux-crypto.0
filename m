Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B43C4346A
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9720214F1
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgIUIAr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:00:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:57374 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgIUH7k (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6E74BB525;
        Mon, 21 Sep 2020 08:00:09 +0000 (UTC)
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
Subject: [RFC PATCH 35/41] random: improve the APT's statistical power
Date:   Mon, 21 Sep 2020 09:58:51 +0200
Message-Id: <20200921075857.4424-36-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Adapative Proportion Test as specified by NIST SP800-90B counts how
often the first sample value in a sequence of n samples occurs among the
remaining n - 1 ones and will report failure if the result is unexpectedly
large. The intention is to capture cases where a noise source's actual
min-entropy falls below the one estimated during the validation process.
Note that, assuming i.i.d., a decrease in per-IRQ min-entropy corresponds
to an increase in the maximum probability among all possible sample values,
per the definition of min-entropy.

For example, consider the maximum supported per-IRQ min-entropy estimate of
H=1, which corresponds to a maximum probability of p = 2^-H = 50% among all
possible sample values. Now, if the actual entropy degraded to H/2, it
would mean that some sample value's likelihood had increased to ~70%. The
ability of the APT to detect this degradation is limited by the way it's
currently implemented: a prerequisite for successfully reporting a
sequence of n samples as bad is to find the offending sample value at the
leading position. Thus, the power of the APT is always limited by the
probability of the offending sample value, i.e. 70% in this example, no
matter how large the total number n of examined of samples is.

This can be improved upon by taking advantage of the fact that only values
of H <= 1 are currently supported for the per-IRQ entropy estimate. It
follows that the maximum probability among all sample values would increase
to > 1/2 in case the actual min-entropy happened to fall below the assumed
value. If we were to examine a sequence of n1 samples, the expected number
of occurrences of the offending sample value would be > 1/2 * n1 (again
assuming i.i.d). For example, for an actual entropy of H/2, with H=1 as
above, the probability to find 4 or more samples of the same value among a
sequence of n1 = 7 events would be ~88%, which is an improvement over the
70% from above.

So partition the total number of samples n = 128/H to examine from the APT
into two parts, n1 and n2, such that n = n1 + n2 with n1 odd. Rather than
simply picking the first sample value to subsequently search for in the
remaining n-1 events, make the APT to run a "presearch" on the first n1
samples in order to find the value occurring more than n1 / 2 times, if
there is such one. Make the APT then continue as usual: let it search the
remaining n2 samples for the found candidate value, count the number of
occurrences and report failure if a certain threshold is reached.

Of course, new thresholds should be installed in order to gain optimal
statistical power from the second phase while still maintaining a false
positive rate of 2^-16 as before. An exhaustive search among all
possibilities for the different choices of n1 and supported per-IRQ
min-entropies revealed that n1 = 7 is optimal for n = 128 (H = 1) and
close to the resp. optimum for larger n, i.e. smaller H. With this choice,
the new presearch scheme yields new thresholds ("c") and probabilities to
detect a entropy degradations to H/2 ("power") as tabulated below:

   H     n   c    power
   --------------------
      1  128   83 64.7%
    1/2  256  205 79.1%
    1/4  512  458 81.6%
    1/8 1024  968 84.0%
   1/16 2048 1991 84.9%
   1/32 4096 4038 86.9%
   1/64 8192 8134 86.4%

Compare this to the former numbers for the original implementation:

   H     n   c    power
   --------------------
      1  128   87 52.5%
    1/2  256  210 67.5%
    1/4  512  463 76.7%
    1/8 1024  973 82.8%
   1/16 2048 1997 82.6%
   1/32 4096 4044 85.8%
   1/64 8192 8140 85.8%

So for smaller values of H, i.e. for H <= 1/8, the improvement isn't really
impressive, but that was to be expected. OTOH, for the larger Hs, that is
for the per-IRQ entropies estimated for systems with a high resolution
get_cycles(), there is a clear advantage over the old scheme.

Implement the described presearch for finding the sample value occurring
more than half of the times among the first n1=7 events in a sequence of
n=128/H samples to examine, if there is such one. Rather than maintaining
individual per-CPU counters for the 2^8 possible sample values each, count
the numbers of ones at the eight resp. bit positions. Note that if some
sample value has indeed been observed more than half of the time, it will
dominate all these bit counters and its value can be unambiguously restored
from them, which is all that is needed.

For better reviewability, represent the eight bit counters as an array of
eight u8's at struct health_test and implement the bit counting as well
as the final candidate extraction in the most naive way. A follow-up patch
will sequeeze the counters into a single u32 and also optimize the bit
counting and candidate extraction performance-wise.

Implement the new health_apt_presearch_update() for updating the presearch
bit counters. Call it from health_test_apt() on the first n1=7 samples.

Implement the new health_apt_presearch_finalize() for restoring the
candidate from the presearch bit counters. Call it from health_test_apt()
once the n1'th event in a sequence has been processed and the presearch
phase is to be concluded.

Make health_test_apt() search for the candidate value as determined by
the presearch phase among the sequence's remaining n2 = n - n1 samples.
Adapt the failure thresholds to the now slightly smaller n2 values.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 58 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 131302cbc495..75a103f24fea 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -881,8 +881,13 @@ static void discard_queued_entropy(struct entropy_store *r,
 
 struct health_test {
 	unsigned short apt_event_count;
-	unsigned short apt_candidate_count;
-	u8 apt_candidate;
+	union {
+		u8 apt_presearch_bit_counters[8];
+		struct {
+			unsigned short apt_candidate_count;
+			u8 apt_candidate;
+		};
+	};
 
 	u8 previous_sample;
 };
@@ -895,9 +900,44 @@ enum health_result {
 };
 
 /* Adaptive Proportion Test */
+#define HEALTH_APT_PRESEARCH_EVENT_COUNT 7
+
+static void health_apt_presearch_update(struct health_test *h, u8 sample_delta)
+{
+	int i;
+
+	for (i = 0; i < 8; ++i) {
+		h->apt_presearch_bit_counters[i] = sample_delta & 0x1;
+		sample_delta >>= 1;
+	}
+}
+
+static void health_apt_presearch_finalize(struct health_test *h)
+{
+	int i;
+
+	/*
+	 * If some event octet occurred more than half of the time,
+	 * i.e. more than HEALTH_APT_PRESEARCH_EVENT_COUNT / 2 times,
+	 * then its value can be restored unambigiously from the eight
+	 * ->apt_presearch_bit_counters each holding the count of 1s
+	 * encountered at the corresponding bit positions.
+	 */
+	h->apt_candidate = 0;
+	for (i = 0; i < 8; ++i) {
+		if (h->apt_presearch_bit_counters[i] >=
+		    (HEALTH_APT_PRESEARCH_EVENT_COUNT + 1) / 2) {
+			h->apt_candidate |= 1 << i;
+		}
+	}
+	h->apt_candidate_count = 0;
+};
+
 static void health_apt_reset(struct health_test *h)
 {
 	h->apt_event_count = 0;
+	memset(h->apt_presearch_bit_counters, 0,
+		sizeof(h->apt_presearch_bit_counters));
 }
 
 static enum health_result
@@ -911,16 +951,18 @@ health_test_apt(struct health_test *h, unsigned int event_entropy_shift,
 	 * values of event_entropy_shift each, should have probability
 	 * <= 2^-16.
 	 */
-	static const unsigned int c[] = {87, 210, 463, 973, 1997, 4044, 8140};
+	static const unsigned int c[] = {83, 205, 458, 968, 1991, 4038, 8134};
+
+	BUILD_BUG_ON(HEALTH_APT_PRESEARCH_EVENT_COUNT != 7);
 
-	if (!h->apt_event_count) {
-		h->apt_event_count = 1;
-		h->apt_candidate = sample_delta;
-		h->apt_candidate_count = 0;
+	++h->apt_event_count;
+	if (unlikely(h->apt_event_count <= HEALTH_APT_PRESEARCH_EVENT_COUNT)) {
+		health_apt_presearch_update(h, sample_delta);
+		if (h->apt_event_count == HEALTH_APT_PRESEARCH_EVENT_COUNT)
+			health_apt_presearch_finalize(h);
 		return health_queue;
 	}
 
-	++h->apt_event_count;
 	if (unlikely(h->apt_candidate == sample_delta &&
 		     ++h->apt_candidate_count == c[event_entropy_shift])) {
 		health_apt_reset(h);
-- 
2.26.2

