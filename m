Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD85C43463
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35C2B20EDD
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgIUH7i (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:59:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:58044 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgIUH7a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A4C55B524;
        Mon, 21 Sep 2020 08:00:03 +0000 (UTC)
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
Subject: [RFC PATCH 25/41] random: probe cycle counter resolution at initialization
Date:   Mon, 21 Sep 2020 09:58:41 +0200
Message-Id: <20200921075857.4424-26-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

An upcoming patch will change the entropy estimate per
add_interrupt_randomness() event for fips_enabled based on whether
random_get_entropy() resp. get_cycles() is able to capture individual
instructions.

For example, x86's TSC would qualify, whereas I've seen cycle counters on
e.g. a Raspberry PI 2B with an advertised resolution of only 52ns even
though the CPU had been clocked at 1GHz. And then there's possibly hardware
which doesn't have a cycle counter at all and where get_cycles() would
always return the same constant.

Make rand_initialize() probe the cycle counter resolution.

Introduce a new static_key have_highres_cycle_ctr, indicicating whether
or not the system's cycle counter is able to capture individual
instructions. Initially it's set to true. Introduce
probe_cycle_ctr_resolution() and call it from rand_initialize().
Make probe_cycle_ctr_resolution() compare 16 successive
random_get_entropy() values and disable have_highres_cycle_ctr in case
the same value has been read two times in a row. As have_highres_cycle_ctr
will be only accessed if fips_enabled is true, make it return early in
case it's not set.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index aaddee4e4ab1..a985ceb22c7c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -335,6 +335,7 @@
 #include <linux/syscalls.h>
 #include <linux/completion.h>
 #include <linux/uuid.h>
+#include <linux/jump_label.h>
 #include <crypto/chacha.h>
 #include <crypto/sha.h>
 
@@ -478,6 +479,8 @@ static struct ratelimit_state urandom_warning =
 
 static int ratelimit_disable __read_mostly;
 
+static DEFINE_STATIC_KEY_TRUE(have_highres_cycle_ctr);
+
 module_param_named(ratelimit_disable, ratelimit_disable, int, 0644);
 MODULE_PARM_DESC(ratelimit_disable, "Disable random ratelimit suppression");
 
@@ -2170,6 +2173,31 @@ static void __init init_std_data(struct entropy_store *r)
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
 }
 
+static void probe_cycle_ctr_resolution(void)
+{
+	cycles_t prev;
+	int i;
+
+	if (!fips_enabled)
+		return;
+
+	/*
+	 * Check if the cycle counter has insn granularity (or at
+	 * least close to).
+	 */
+	prev = random_get_entropy();
+	for (i = 0; i < 16; ++i) {
+		cycles_t next;
+
+		next = random_get_entropy();
+		if (next == prev) {
+			static_branch_disable(&have_highres_cycle_ctr);
+			return;
+		}
+		prev = next;
+	}
+}
+
 /*
  * Note that setup_arch() may call add_device_randomness()
  * long before we get here. This allows seeding of the pools
@@ -2182,6 +2210,7 @@ static void __init init_std_data(struct entropy_store *r)
  */
 int __init rand_initialize(void)
 {
+	probe_cycle_ctr_resolution();
 	init_std_data(&input_pool);
 	crng_initialize_primary(&primary_crng);
 	crng_global_init_time = jiffies;
-- 
2.26.2

