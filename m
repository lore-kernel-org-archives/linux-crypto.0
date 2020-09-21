Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3C1C43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA0BA20EDD
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgIUIBH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:01:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:57622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726584AbgIUH7j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0A838B530;
        Mon, 21 Sep 2020 08:00:10 +0000 (UTC)
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
Subject: [RFC PATCH 36/41] random: optimize the APT's presearch
Date:   Mon, 21 Sep 2020 09:58:52 +0200
Message-Id: <20200921075857.4424-37-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Adaptive Proportion Test's presearch phase is supposed to determine the
sample value occurring more than half of the times among the first n1=7
events in a sequence, if there is any such one.

To this end, it maintains eight counters at struct health_test for counting
the numbers of ones observed at each of the eight resp. bit positions
within the sample values' octets. The idea is that if any sample value had
been encountered more than half of the time, it would dominate all these
counters and its value could be restored unambiguously from them.

For better reviewability, this had been implemented in the most
straightforward way:
- the counters had been represented as an array of eight u8s at struct
  health_test and
- both, the counter updating as well as the candidate extracion code had
  been implemented by means of a loop over the eight bit positions.

As this is all accessed from add_interrupt_randomness(), optimizations
won't harm. In particular, using a total of eight bytes for the bit
counters is wasteful and can be reduced to half of that, optimizing the
size of struct health_test, which in turn is stored as part of the per-CPU
struct fast_pool.

For counts up to n1=7, 3 bits would suffice. Rather than using an array of
eight u8s, store the bit counter within an u32's eight four-bit nibbles.

Even though it probably won't matter on average in practice, because the
APT presearch is run only for a small fraction of all IRQ events, reduce
the number of instructions issued from the bit counter maintenance and
candidate extraction code as well. If nothing else, this can potentially
reduce the maximum IRQ latency by a few cycles.

Namely, make the bit counter updating code in health_apt_presearch_update()
spread the eight bits from the input sample evenly across an u32. That is,
the bit at position i will end up at position 4*i. This can be achieved
within five binops and four shifts. This intermediate value can then get
subsequently added in a single operation to the "packed" bit counters kept
in struct health_test in order to conclude the operation.

As for the final candidate extraction in health_apt_presearch_finalize(),
remember that the i'th counter needs to get compared against
n1 / 2 = 7 / 2 in order to restore the i'th bit from the resulting
candidate value. The condition that one such bit counter is >= 4 is
equivalent to testing its bit at the 2nd position, counted from zero.
Thus, (->apt_presearch_bit_counters & 0x44444444) >> 2
will yield a value where the LSB from the i'th nibble, equals the i'th bit
from the result and everything else is unset. The final result can then be
obtained by "shrinking" this intermediate representation back into an u8.
In total, the candidate extraction can be achieved within a sequence of
seven binops and six shifts.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 71 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 53 insertions(+), 18 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 75a103f24fea..2c744d2a9b26 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -882,7 +882,7 @@ static void discard_queued_entropy(struct entropy_store *r,
 struct health_test {
 	unsigned short apt_event_count;
 	union {
-		u8 apt_presearch_bit_counters[8];
+		u32 apt_presearch_bit_counters;
 		struct {
 			unsigned short apt_candidate_count;
 			u8 apt_candidate;
@@ -904,40 +904,75 @@ enum health_result {
 
 static void health_apt_presearch_update(struct health_test *h, u8 sample_delta)
 {
-	int i;
+	u32 encoded;
 
-	for (i = 0; i < 8; ++i) {
-		h->apt_presearch_bit_counters[i] = sample_delta & 0x1;
-		sample_delta >>= 1;
-	}
+	/*
+	 * Encode the sample octet by "widening" it into 8
+	 * nibbles. That is, bit i from the source will be assigned to
+	 * bit 4*i in the result. All other bits are set to zero.
+	 */
+	encoded = sample_delta;
+	encoded = (encoded & 0xf) | ((encoded >> 4) << 16);
+	encoded |= (encoded << 6);
+	encoded |= (encoded << 3);
+	encoded &= 0x11111111;
+
+	/*
+	 * The nibbles from ->apt_presearch_bit_counters, each
+	 * counting the number of occurences of 1s at the
+	 * corresponding bit position, don't overflow into each other.
+	 */
+	BUILD_BUG_ON(ilog2(HEALTH_APT_PRESEARCH_EVENT_COUNT) >= 4);
+	h->apt_presearch_bit_counters += encoded;
 }
 
 static void health_apt_presearch_finalize(struct health_test *h)
 {
-	int i;
+	u32 majority, decoded;
 
 	/*
 	 * If some event octet occurred more than half of the time,
 	 * i.e. more than HEALTH_APT_PRESEARCH_EVENT_COUNT / 2 times,
 	 * then its value can be restored unambigiously from the eight
-	 * ->apt_presearch_bit_counters each holding the count of 1s
-	 * encountered at the corresponding bit positions.
+	 * ->apt_presearch_bit_counters nibbles each holding the count
+	 * of 1s encountered at the corresponding bit positions.
+	 *
+	 * Because HEALTH_APT_PRESEARCH_EVENT_COUNT is a power of two
+	 * minus one, the condition
+	 * nibble >=  HEALTH_APT_PRESEARCH_EVENT_COUNT / 2
+	 * is true iff the nibble's bit at postion
+	 * ilog2(HEALTH_APT_PRESEARCH_EVENT_COUNT) is set.
 	 */
-	h->apt_candidate = 0;
-	for (i = 0; i < 8; ++i) {
-		if (h->apt_presearch_bit_counters[i] >=
-		    (HEALTH_APT_PRESEARCH_EVENT_COUNT + 1) / 2) {
-			h->apt_candidate |= 1 << i;
-		}
-	}
+	BUILD_BUG_ON(!is_power_of_2(HEALTH_APT_PRESEARCH_EVENT_COUNT + 1));
+#define MAJORITY_BIT ilog2(HEALTH_APT_PRESEARCH_EVENT_COUNT)
+#define SHL_AND_OR(a, shl) ((a) | ((a) << shl))
+#define SET_ALL_NIBBLES_TO(to) SHL_AND_OR(SHL_AND_OR(SHL_AND_OR(to, 16), 8), 4)
+#define MAJORITY_MASK SET_ALL_NIBBLES_TO(1 << MAJORITY_BIT)
+	majority = (h->apt_presearch_bit_counters & MAJORITY_MASK);
+	majority >>= MAJORITY_BIT;
+#undef MAJORITY_MASK
+#undef SET_ALL_NIBBLES_TO
+#undef MAJORITY_BIT
+
+	/*
+	 * Reverse the encoding from health_apt_update_presearch().
+	 * That is, "shrink" the eight nibbles back into an octet such
+	 * that the result's i'th bit is set to the i'th nibble's LSB.
+	 */
+	decoded = majority;
+	decoded |= (decoded >> 3);
+	decoded |= (decoded >> 3);
+	decoded |= (decoded >> 3);
+	decoded = (((decoded >> 16) << 4) | (decoded & 0xf)) & 0xff;
+
+	h->apt_candidate = decoded;
 	h->apt_candidate_count = 0;
 };
 
 static void health_apt_reset(struct health_test *h)
 {
 	h->apt_event_count = 0;
-	memset(h->apt_presearch_bit_counters, 0,
-		sizeof(h->apt_presearch_bit_counters));
+	h->apt_presearch_bit_counters = 0;
 }
 
 static enum health_result
-- 
2.26.2

