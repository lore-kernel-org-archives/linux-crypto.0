Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 894DEC43463
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62C6F20BED
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgIUIBI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:01:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:57940 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbgIUH7j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E0F6EB533;
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
Subject: [RFC PATCH 41/41] random: lower per-IRQ entropy estimate upon health test failure
Date:   Mon, 21 Sep 2020 09:58:57 +0200
Message-Id: <20200921075857.4424-42-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, if fips_enabled is set, a per-IRQ min-entropy estimate of
either 1 bit or 1/8 bit is assumed, depending on whether a high resolution
get_cycles() is available or not. The statistical NIST SP800-90B startup
health tests are run on a certain amount of noise samples and are intended
to reject in case this hypothesis turns out to be wrong, i.e. if the
actual min-entropy is smaller. As long as the startup tests haven't
finished, entropy dispatch and thus, the initial crng seeding, is
inhibited. On test failure, the startup tests would restart themselves
from the beginning.

It follows that in case a system's actual per-IRQ min-entropy is smaller
than the more or less arbitrarily assessed 1 bit or 1/8 bit resp., there
will be a good chance that the initial crng seed will never complete.
AFAICT, such a situation could potentially prevent certain userspace
daemons like OpenSSH from loading.

In order to still be able to make any progress, make
add_interrupt_randomness() lower the per-IRQ min-entropy by one half upon
each health test failure, but only until the minimum supported value of
1/64 bits has been reached. Note that health test failures will cause a
restart of the startup health tests already and thus, a certain number of
additional noise samples resp. IRQ events will have to get examined by the
health tests before the initial crng seeding can take place. This number
of fresh events required is reciprocal to the estimated per-IRQ
min-entropy H: for the Adaptive Proportion Test (APT) it equals ~128 / H.
It follows that this patch won't be of much help for embedded systems or
VMs with poor IRQ rates at boot time, at least not without manual
intervention. But there aren't many options left when fips_enabled is set.

With respect to NIST SP800-90B conformance, this patch enters kind of a
gray area: NIST SP800-90B has no notion of such a dynamically adjusted
min-entropy estimate. Instead, it is assumed that some fixed value has been
estimated based on general principles and subsequently validated in the
course of the certification process. However, I would argue that if a
system had successfully passed certification for 1 bit or 1/8 bit resp. of
estimated min-entropy per sample, it would automatically be approved for
all smaller values as well. Had we started out with such a lower value
passing the health tests from the beginning, the latter would never have
complained in the first place and the system would have come up just fine.

Finally, note that all statistical tests have a non-zero probability of
false positives and so do the NIST SP800-90B health tests. In order to not
keep the estimated per-IRQ entropy at a smaller level than necessary for
forever after spurious health test failures, make
add_interrupt_randomness() attempt to double it again after a certain
number of successful health test passes at the degraded entropy level have
been completed. This threshold should not be too small in order to avoid
excessive entropy accounting loss due to continuously alternating between
a too large per-IRQ entropy estimate and the next smaller value. For now,
choose a value of five as a compromise between quick recovery and limiting
said accounting loss.

So, introduce a new member ->good_tests to struct fast_pool for keeping
track of the number of successfult health test passes. Make
add_interrupt_randomness() increment it upon successful healh test
completion and reset it to zero on failures. Make
add_interrupt_randomness() double the current min-entropy estimate and
restart the startup health in case ->good_tests is > 4 and the entropy
had previously been lowered.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index bb79dcb96882..24c09ba9d7d0 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1126,6 +1126,7 @@ struct fast_pool {
 	bool		dispatch_needed : 1;
 	bool		discard_needed : 1;
 	int		event_entropy_shift;
+	unsigned int		good_tests;
 	struct queued_entropy	q;
 	struct health_test	health;
 };
@@ -1926,9 +1927,13 @@ void add_interrupt_randomness(int irq, int irq_flags)
 					    cycles);
 		if (unlikely(health_result == health_discard)) {
 			/*
-			 * Oops, something's odd. Restart the startup
-			 * tests.
+			 * Oops, something's odd. Lower the entropy
+			 * estimate and restart the startup tests.
 			 */
+			fast_pool->event_entropy_shift =
+				min_t(unsigned int,
+				      fast_pool->event_entropy_shift + 1, 6);
+			fast_pool->good_tests = 0;
 			health_test_reset(&fast_pool->health,
 					  fast_pool->event_entropy_shift);
 		}
@@ -1951,6 +1956,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 		 * entropy discard request?
 		 */
 		fast_pool->dispatch_needed = !fast_pool->discard_needed;
+		fast_pool->good_tests++;
 		break;
 
 	case health_discard:
@@ -2005,6 +2011,21 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	if (fast_pool->dispatch_needed || health_result == health_none) {
 		reseed = __dispatch_queued_entropy_fast(r, q);
 		fast_pool->dispatch_needed = false;
+
+		/*
+		 * In case the estimated per-IRQ min-entropy had to be
+		 * lowered due to health test failure, but the lower
+		 * value has proven to withstand the tests for some
+		 * time now, try to give the next better value another
+		 * shot.
+		 */
+		if (unlikely((fast_pool->event_entropy_shift >
+			      min_irq_event_entropy_shift())) &&
+		    fast_pool->good_tests > 4) {
+			fast_pool->event_entropy_shift--;
+			health_test_reset(&fast_pool->health,
+					  fast_pool->event_entropy_shift);
+		}
 	} else if (fast_pool->discard_needed) {
 		int dummy;
 
-- 
2.26.2

