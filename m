Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27930C43465
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF90820BED
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgIUIAy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:00:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:57144 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbgIUH7j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9E7B9B288;
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
Subject: [RFC PATCH 37/41] random: implement the "Repetition Count" NIST SP800-90B health test
Date:   Mon, 21 Sep 2020 09:58:53 +0200
Message-Id: <20200921075857.4424-38-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The "Repetition Count Test" (RCT) as specified by NIST SP800-90B simply
counts the number of times the same sample value has been observed and
reports failure if an highly unlikely threshold is exceeded. The exact
values of the latter depend on the estimated per-IRQ min-entropy H as well
as on the upper bounds set on the probability of false positives. For the
latter, a maximum value of 2^-20 is recommended and with this value the
threshold can be calculated as 1 + ceil(20 / H). It should be noted that
the RCT has very poor statistical power and is only intended to detect
catastrophic noise source failures, like the get_cycles() in
add_interrupt_randomness() always returning the same constant.

Add the fields needed for maintaining the RCT state to struct health_test:
->rct_previous_delta for storing the previous sample value and ->rct_count
for keeping track of how many times this value has been observed in a row
so far.

Implement the RCT and wrap it in a new function, health_test_rct().

Make the health test entry point, health_test_process(), call it early
before invoking the APT and forward failure reports to the caller. All
other return codes from the RCT are ignored, because
- as said, the statistical power is weak and a positive outcome wouldn't
  tell anything and
- it's not desirable to make the caller, i.e. add_interrupt_randomness(),
  to further queue any entropy once the concurrently running APT has
  signaled a successful completion.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 55 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 2c744d2a9b26..54ee082ca4a8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -890,6 +890,9 @@ struct health_test {
 	};
 
 	u8 previous_sample;
+
+	u8 rct_previous_delta;
+	unsigned short rct_count;
 };
 
 enum health_result {
@@ -899,6 +902,43 @@ enum health_result {
 	health_discard,
 };
 
+/* Repetition count test. */
+static enum health_result
+health_test_rct(struct health_test *h, unsigned int event_entropy_shift,
+		u8 sample_delta)
+{
+	unsigned int c;
+
+	if (likely(sample_delta != h->rct_previous_delta)) {
+		h->rct_previous_delta = sample_delta;
+		h->rct_count = 0;
+		return health_dispatch;
+	}
+
+	h->rct_count++;
+	if (!h->rct_count) {
+		/* Overflow. */
+		h->rct_count = -1;
+	}
+
+	/*
+	 * With a min-entropy of H = 2^-event_entropy_shift bits per
+	 * event, the maximum probability of seing any particular
+	 * sample value (i.e. delta) is bounded by 2^-H. Thus, the
+	 * probability to observe the same events C times in a row is
+	 * less than 2^-((C - 1) * H). Limit the false positive rate
+	 * of the repetition count test to 2^-20, which yields a
+	 * cut-off value of C = 1 + 20/H. Note that the actual number
+	 * of repetitions equals ->rct_count + 1, so this offset by
+	 * one must be accounted for in the comparison below.
+	 */
+	c = 20 << event_entropy_shift;
+	if (h->rct_count >= c)
+		return health_discard;
+
+	return health_queue;
+}
+
 /* Adaptive Proportion Test */
 #define HEALTH_APT_PRESEARCH_EVENT_COUNT 7
 
@@ -1027,6 +1067,7 @@ health_test_process(struct health_test *h, unsigned int event_entropy_shift,
 		    u8 sample)
 {
 	u8 sample_delta;
+	enum health_result rct;
 
 	/*
 	 * The min-entropy estimate has been made for the lower eight
@@ -1036,6 +1077,20 @@ health_test_process(struct health_test *h, unsigned int event_entropy_shift,
 	sample_delta = sample - h->previous_sample;
 	h->previous_sample = sample;
 
+	rct = health_test_rct(h, event_entropy_shift, sample_delta);
+	if (rct == health_discard) {
+		/*
+		 * Something is really off, get_cycles() has become
+		 * (or always been) a constant.
+		 */
+		return health_discard;
+	}
+
+	/*
+	 * Otherwise return whatever the APT returns. In particular,
+	 * don't care about whether the RCT needs to consume more
+	 * samples to complete.
+	 */
 	return health_test_apt(h, event_entropy_shift, sample_delta);
 }
 
-- 
2.26.2

