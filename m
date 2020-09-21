Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFE1C43463
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51CE620BED
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgIUIBb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:01:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:56798 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbgIUH7j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 60A82B535;
        Mon, 21 Sep 2020 08:00:12 +0000 (UTC)
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
Subject: [RFC PATCH 40/41] random: trigger startup health test on any failure of the health tests
Date:   Mon, 21 Sep 2020 09:58:56 +0200
Message-Id: <20200921075857.4424-41-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The startup health tests to be executed at boot as required by NIST 800-90B
consist of running the contiuous health tests, i.e. the Adaptive Proportion
Test (APT) and the Repetition Count Test (RCT), until a certain amount
of noise samples have been examined. In case of test failure during this
period, the startup tests would get restarted by means of reinitializing
the fast_pool's ->warmup member with the original number of total samples
to examine during startup.

A future patch will enable dynamically switching from the initial H=1 or
1/8 per-IRQ min-entropy estimates to lower values upon health test
failures in order to keep those systems going where these more or less
arbitrary per-IRQ entropy estimates turn out to simply be wrong. It is
certainly desirable to restart the startup health tests upon such a switch.

In order to keep the upcoming code comprehensible, move the startup test
restart logic from health_test_process() into add_interrupt_randomness().
For simplicity, make add_interrupt_randomness() trigger a startup test on
each health test failure. Note that there's a change in behaviour: up to
now, only the bootime startup tests would have restarted themselves upon
failure, whereas now even a failure of the continuous health tests can
potentially trigger a startup test long after boot.

Note that as it currently stands, rerunning the full startup tests after
the crng has received its initial seed has the only effect to inhibit
entropy dispatch for a while and thus, to potentially delay those best
effort crng reseeds during runtime. As reseeds never reduce a crng state's
entropy, this behaviour is admittedly questionable. However, further
patches introducing forced reseeds might perhaps become necessary in the
future, c.f. the specification of "reseed_interval" in NIST SP800-90A.
Thus, it's better to keep the startup health test restart logic consistent
for now.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 86dd87588b1b..bb79dcb96882 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1098,8 +1098,6 @@ health_test_process(struct health_test *h, unsigned int event_entropy_shift,
 		 * Something is really off, get_cycles() has become
 		 * (or always been) a constant.
 		 */
-		if (h->warmup)
-			health_test_reset(h, event_entropy_shift);
 		return health_discard;
 	}
 
@@ -1110,8 +1108,6 @@ health_test_process(struct health_test *h, unsigned int event_entropy_shift,
 	 */
 	apt = health_test_apt(h, event_entropy_shift, sample_delta);
 	if (unlikely(h->warmup) && --h->warmup) {
-		if (apt == health_discard)
-			health_test_reset(h, event_entropy_shift);
 		/*
 		 * Don't allow the caller to dispatch until warmup
 		 * has completed.
@@ -1928,6 +1924,14 @@ void add_interrupt_randomness(int irq, int irq_flags)
 			health_test_process(&fast_pool->health,
 					    fast_pool->event_entropy_shift,
 					    cycles);
+		if (unlikely(health_result == health_discard)) {
+			/*
+			 * Oops, something's odd. Restart the startup
+			 * tests.
+			 */
+			health_test_reset(&fast_pool->health,
+					  fast_pool->event_entropy_shift);
+		}
 	}
 
 	if (unlikely(crng_init == 0)) {
-- 
2.26.2

