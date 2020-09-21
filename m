Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C2CC43463
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C1F320EDD
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgIUIBI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:01:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:56892 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbgIUH7j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3CEE4B532;
        Mon, 21 Sep 2020 08:00:11 +0000 (UTC)
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
Subject: [RFC PATCH 38/41] random: enable NIST SP800-90B startup tests
Date:   Mon, 21 Sep 2020 09:58:54 +0200
Message-Id: <20200921075857.4424-39-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

NIST SP800-90B, section 4.3 requires an entropy source to inhibit output
until the so-called "startup" tests have completed. These "startup" test
shall process at least 1024 consecutive samples by means of the continuous
health tests, i.e. the already implemented Repetition Count Test (RCT) and
Adaptive Proportion Test (APT).

Introduce a new field ->warmup to struct health_test. Initialize it to 1024
from health_test_reset(). Make health_test_process() decrement ->warmup
once per event processed without test failure, but reset ->warmup to the
intitial value upon failure. Prevent health_test_process() from returning
health_dispatch as long as ->warmup hasn't dropped to zero. This will cause
the caller, i.e. add_interrupt_randomness(), to not dispatch any entropy to
the global balance until the startup tests have finished.

Note that this change will delay the initial seeding of the primary_crng,
especially for those values of the estimated per-IRQ min-entropy H where
the mimimum of 1024 events from above is by several factors larger than
128/H, the number of events to be processed by a single APT run. That
would only affect systems running with fips_enabled though and there's
simply no way to avoid it without violating the specs.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 54ee082ca4a8..bd8c24e433d0 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -880,6 +880,7 @@ static void discard_queued_entropy(struct entropy_store *r,
 }
 
 struct health_test {
+	unsigned short warmup;
 	unsigned short apt_event_count;
 	union {
 		u32 apt_presearch_bit_counters;
@@ -1059,6 +1060,13 @@ health_test_apt(struct health_test *h, unsigned int event_entropy_shift,
 
 static void health_test_reset(struct health_test *h)
 {
+	/*
+	 * Don't dispatch until at least 1024 events have been
+	 * processed by the continuous health tests as required by
+	 * NIST SP800-90B for the startup tests.
+	 */
+	h->warmup = 1024;
+
 	health_apt_reset(h);
 }
 
@@ -1067,7 +1075,7 @@ health_test_process(struct health_test *h, unsigned int event_entropy_shift,
 		    u8 sample)
 {
 	u8 sample_delta;
-	enum health_result rct;
+	enum health_result rct, apt;
 
 	/*
 	 * The min-entropy estimate has been made for the lower eight
@@ -1083,6 +1091,8 @@ health_test_process(struct health_test *h, unsigned int event_entropy_shift,
 		 * Something is really off, get_cycles() has become
 		 * (or always been) a constant.
 		 */
+		if (h->warmup)
+			health_test_reset(h);
 		return health_discard;
 	}
 
@@ -1091,7 +1101,18 @@ health_test_process(struct health_test *h, unsigned int event_entropy_shift,
 	 * don't care about whether the RCT needs to consume more
 	 * samples to complete.
 	 */
-	return health_test_apt(h, event_entropy_shift, sample_delta);
+	apt = health_test_apt(h, event_entropy_shift, sample_delta);
+	if (unlikely(h->warmup) && --h->warmup) {
+		if (apt == health_discard)
+			health_test_reset(h);
+		/*
+		 * Don't allow the caller to dispatch until warmup
+		 * has completed.
+		 */
+		return apt == health_dispatch ? health_queue : apt;
+	}
+
+	return apt;
 }
 
 struct fast_pool {
-- 
2.26.2

