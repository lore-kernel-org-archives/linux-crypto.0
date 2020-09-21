Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA005C43466
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F3CE2158C
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgIUH7u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:59:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:57144 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgIUH71 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E0FA9B516;
        Mon, 21 Sep 2020 08:00:01 +0000 (UTC)
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
Subject: [RFC PATCH 22/41] random: introduce arch_has_sp800_90b_random_seed()
Date:   Mon, 21 Sep 2020 09:58:38 +0200
Message-Id: <20200921075857.4424-23-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

NIST SP800-90C allows for the combination of multiple SP800-90B entropy
sources by concatenating their individual outputs together, c.f.
sec. 5.3.4 and also the constructions in 10.3.1 from the second draft.

We're already doing exactly that when reseeding the primary CRNG from the
input pool and possibly from arch_get_random_seed_long() +
arch_get_random_long(). The input pool will be moved gradually towards
SP800-90B compliance with future patches. Provide a means for the random
driver to check whether arch_get_random_seed_long() is also a full entropy
source conforming to NIST SP800-90B.

Note that I couldn't find any explicit statement in the specs that would
allow for using NRBGs as defined by SP800-90C as a drop-in replacement for
"entropy sources" in the sense of SP800-90B. In particular there is no
statement that NRBGs may be combined with other SP800-90B entropy sources.
However, NRBGs always provide stronger guarantees in that they provide
certain protection against silent failure of backing entropy sources. Thus,
I think it would be perfectly acceptable to combine SP800-90C NRBGs, i.e.
ARMv8's RNDRRS or x86's RDSEED with other entropy sources.

Introduce arch_has_sp800_90b_random_seed().
- Make the generic stub return false.
- Make the arm64 variant return false as well: the current
  arch_get_random_seed_long() is based on RNDR, not RNDRRS.
- Make it return false on powerpc and s390, too.
- Let arch_has_sp800_90b_random_seed() return true on x86 if the CPU has
  RDSEED support.
Yes, I know, one change per patch, but this is part of a RFC series.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 arch/arm64/include/asm/archrandom.h   | 10 +++++++++-
 arch/powerpc/include/asm/archrandom.h |  5 +++++
 arch/s390/include/asm/archrandom.h    |  5 +++++
 arch/x86/include/asm/archrandom.h     |  8 ++++++++
 include/linux/random.h                |  9 +++++++++
 5 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/archrandom.h b/arch/arm64/include/asm/archrandom.h
index 055d18713db7..db7813c79b3e 100644
--- a/arch/arm64/include/asm/archrandom.h
+++ b/arch/arm64/include/asm/archrandom.h
@@ -42,7 +42,15 @@ static inline bool arch_has_random_seed(void)
 	 */
 	return cpus_have_const_cap(ARM64_HAS_RNG);
 }
-
+static inine bool arch_has_sp800_90b_random_seed(void)
+{
+	/*
+	 * Section K.12.1 from the Arm Architecture Reference Manual
+	 * Armv8" (DDI0487F) sounds like RNDRRS could qualify as a
+	 * NIST SP800-90C NRBG, but we're currently using RNDR only.
+	 */
+	return false;
+}
 static inline bool __must_check arch_get_random_long(unsigned long *v)
 {
 	return false;
diff --git a/arch/powerpc/include/asm/archrandom.h b/arch/powerpc/include/asm/archrandom.h
index 47c2d74e7244..ba0f816d9750 100644
--- a/arch/powerpc/include/asm/archrandom.h
+++ b/arch/powerpc/include/asm/archrandom.h
@@ -16,6 +16,11 @@ static inline bool arch_has_random_seed(void)
 	return ppc_md.get_random_seed;
 }
 
+static inline bool arch_has_sp800_90b_random_seed(void)
+{
+	return false;
+}
+
 static inline bool __must_check arch_get_random_long(unsigned long *v)
 {
 	return false;
diff --git a/arch/s390/include/asm/archrandom.h b/arch/s390/include/asm/archrandom.h
index 18973845634c..1ee7f9e4b255 100644
--- a/arch/s390/include/asm/archrandom.h
+++ b/arch/s390/include/asm/archrandom.h
@@ -31,6 +31,11 @@ static inline bool arch_has_random_seed(void)
 	return static_branch_likely(&s390_arch_random_available);
 }
 
+static inline bool arch_has_sp800_90b_random_seed(void)
+{
+	return false;
+}
+
 static inline bool __must_check arch_get_random_long(unsigned long *v)
 {
 	return false;
diff --git a/arch/x86/include/asm/archrandom.h b/arch/x86/include/asm/archrandom.h
index 030f46c9e310..94d4ee8c9e45 100644
--- a/arch/x86/include/asm/archrandom.h
+++ b/arch/x86/include/asm/archrandom.h
@@ -80,6 +80,14 @@ static inline bool arch_has_random_seed(void)
 	return static_cpu_has(X86_FEATURE_RDSEED);
 }
 
+static inline bool arch_has_sp800_90b_random_seed(void)
+{
+	/*
+	 * According to the Intel SDM, rdseed is NIST SP800-90B
+	 * compliant.
+	 */
+	return arch_has_random_seed();
+}
 static inline bool __must_check arch_get_random_long(unsigned long *v)
 {
 	return arch_has_random() ? rdrand_long(v) : false;
diff --git a/include/linux/random.h b/include/linux/random.h
index d4653422a0c7..933f5daa4a1c 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -128,6 +128,15 @@ static inline bool arch_has_random_seed(void)
 {
 	return false;
 }
+/*
+ * Whether or not arch_get_random_seed_long() qualifies as a NIST
+ * SP800-90B compliant entropy source providing full entropy output.
+ * NIST SP800-90C NRBG's are probably fine, too.
+ */
+static inline bool arch_has_sp800_90b_random_seed(void)
+{
+	return false;
+}
 static inline bool __must_check arch_get_random_long(unsigned long *v)
 {
 	return false;
-- 
2.26.2

