Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80883C43465
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54CA0214F1
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIUH7u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:59:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:57622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbgIUH71 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2A891B510;
        Mon, 21 Sep 2020 08:00:00 +0000 (UTC)
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
Subject: [RFC PATCH 19/41] random: reintroduce arch_has_random() + arch_has_random_seed()
Date:   Mon, 21 Sep 2020 09:58:35 +0200
Message-Id: <20200921075857.4424-20-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A future patch will introduce support for making up for a certain amount
of lacking entropy in crng_reseed() by means of arch_get_random_long()
or arch_get_random_seed_long() respectively.

However, before even the tiniest bit of precious entropy is withdrawn from
the input_pool, it should be checked if whether the current arch even
has support for these.

Reintroduce arch_has_random() + arch_has_random_seed() and implement
them for arm64, powerpc, s390 and x86 as appropriate (yeah, I know this
should go in separate commits, but this is part of a RFC series).

Note that this more or less reverts commits
  647f50d5d9d9 ("linux/random.h: Remove arch_has_random,
                 arch_has_random_seed")
  cbac004995a0 ("powerpc: Remove arch_has_random, arch_has_random_seed")
  5e054c820f59 ("s390: Remove arch_has_random, arch_has_random_seed")
  5f2ed7f5b99b ("x86: Remove arch_has_random, arch_has_random_seed")

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 arch/arm64/include/asm/archrandom.h   | 25 ++++++++++++++++++-------
 arch/powerpc/include/asm/archrandom.h | 12 +++++++++++-
 arch/s390/include/asm/archrandom.h    | 14 ++++++++++++--
 arch/x86/include/asm/archrandom.h     | 18 ++++++++++++++----
 include/linux/random.h                |  8 ++++++++
 5 files changed, 63 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/archrandom.h b/arch/arm64/include/asm/archrandom.h
index 44209f6146aa..055d18713db7 100644
--- a/arch/arm64/include/asm/archrandom.h
+++ b/arch/arm64/include/asm/archrandom.h
@@ -26,17 +26,13 @@ static inline bool __arm64_rndr(unsigned long *v)
 	return ok;
 }
 
-static inline bool __must_check arch_get_random_long(unsigned long *v)
-{
-	return false;
-}
 
-static inline bool __must_check arch_get_random_int(unsigned int *v)
+static inline bool arch_has_random(void)
 {
 	return false;
 }
 
-static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
+static inline bool arch_has_random_seed(void)
 {
 	/*
 	 * Only support the generic interface after we have detected
@@ -44,7 +40,22 @@ static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 	 * cpufeature code and with potential scheduling between CPUs
 	 * with and without the feature.
 	 */
-	if (!cpus_have_const_cap(ARM64_HAS_RNG))
+	return cpus_have_const_cap(ARM64_HAS_RNG);
+}
+
+static inline bool __must_check arch_get_random_long(unsigned long *v)
+{
+	return false;
+}
+
+static inline bool __must_check arch_get_random_int(unsigned int *v)
+{
+	return false;
+}
+
+static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
+{
+	if (!arch_has_random_seed())
 		return false;
 
 	return __arm64_rndr(v);
diff --git a/arch/powerpc/include/asm/archrandom.h b/arch/powerpc/include/asm/archrandom.h
index 9a53e29680f4..47c2d74e7244 100644
--- a/arch/powerpc/include/asm/archrandom.h
+++ b/arch/powerpc/include/asm/archrandom.h
@@ -6,6 +6,16 @@
 
 #include <asm/machdep.h>
 
+static inline bool arch_has_random(void)
+{
+	return false;
+}
+
+static inline bool arch_has_random_seed(void)
+{
+	return ppc_md.get_random_seed;
+}
+
 static inline bool __must_check arch_get_random_long(unsigned long *v)
 {
 	return false;
@@ -18,7 +28,7 @@ static inline bool __must_check arch_get_random_int(unsigned int *v)
 
 static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 {
-	if (ppc_md.get_random_seed)
+	if (arch_has_random_seed())
 		return ppc_md.get_random_seed(v);
 
 	return false;
diff --git a/arch/s390/include/asm/archrandom.h b/arch/s390/include/asm/archrandom.h
index de61ce562052..18973845634c 100644
--- a/arch/s390/include/asm/archrandom.h
+++ b/arch/s390/include/asm/archrandom.h
@@ -21,6 +21,16 @@ extern atomic64_t s390_arch_random_counter;
 
 bool s390_arch_random_generate(u8 *buf, unsigned int nbytes);
 
+static inline bool arch_has_random(void)
+{
+	return false;
+}
+
+static inline bool arch_has_random_seed(void)
+{
+	return static_branch_likely(&s390_arch_random_available);
+}
+
 static inline bool __must_check arch_get_random_long(unsigned long *v)
 {
 	return false;
@@ -33,7 +43,7 @@ static inline bool __must_check arch_get_random_int(unsigned int *v)
 
 static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 {
-	if (static_branch_likely(&s390_arch_random_available)) {
+	if (arch_has_random_seed()) {
 		return s390_arch_random_generate((u8 *)v, sizeof(*v));
 	}
 	return false;
@@ -41,7 +51,7 @@ static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 
 static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
 {
-	if (static_branch_likely(&s390_arch_random_available)) {
+	if (arch_has_random_seed()) {
 		return s390_arch_random_generate((u8 *)v, sizeof(*v));
 	}
 	return false;
diff --git a/arch/x86/include/asm/archrandom.h b/arch/x86/include/asm/archrandom.h
index ebc248e49549..030f46c9e310 100644
--- a/arch/x86/include/asm/archrandom.h
+++ b/arch/x86/include/asm/archrandom.h
@@ -70,24 +70,34 @@ static inline bool __must_check rdseed_int(unsigned int *v)
  */
 #ifdef CONFIG_ARCH_RANDOM
 
+static inline bool arch_has_random(void)
+{
+	return static_cpu_has(X86_FEATURE_RDRAND);
+}
+
+static inline bool arch_has_random_seed(void)
+{
+	return static_cpu_has(X86_FEATURE_RDSEED);
+}
+
 static inline bool __must_check arch_get_random_long(unsigned long *v)
 {
-	return static_cpu_has(X86_FEATURE_RDRAND) ? rdrand_long(v) : false;
+	return arch_has_random() ? rdrand_long(v) : false;
 }
 
 static inline bool __must_check arch_get_random_int(unsigned int *v)
 {
-	return static_cpu_has(X86_FEATURE_RDRAND) ? rdrand_int(v) : false;
+	return arch_has_random() ? rdrand_int(v) : false;
 }
 
 static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 {
-	return static_cpu_has(X86_FEATURE_RDSEED) ? rdseed_long(v) : false;
+	return arch_has_random_seed() ? rdseed_long(v) : false;
 }
 
 static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
 {
-	return static_cpu_has(X86_FEATURE_RDSEED) ? rdseed_int(v) : false;
+	return arch_has_random_seed() ? rdseed_int(v) : false;
 }
 
 extern void x86_init_rdrand(struct cpuinfo_x86 *c);
diff --git a/include/linux/random.h b/include/linux/random.h
index f45b8be3e3c4..d4653422a0c7 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -120,6 +120,14 @@ unsigned long randomize_page(unsigned long start, unsigned long range);
 #ifdef CONFIG_ARCH_RANDOM
 # include <asm/archrandom.h>
 #else
+static inline bool arch_has_random(void)
+{
+	return false;
+}
+static inline bool arch_has_random_seed(void)
+{
+	return false;
+}
 static inline bool __must_check arch_get_random_long(unsigned long *v)
 {
 	return false;
-- 
2.26.2

