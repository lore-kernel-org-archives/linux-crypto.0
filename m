From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] random: add random_initialized command line param
Date: Mon, 18 May 2015 18:25:25 +0200
Message-ID: <4206400.x843ypJTc1@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34830 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbbERRy7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 May 2015 13:54:59 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Make the threshold at which the output entropy pools are considered to
be initialized configurable via a kernel command line option. The
current integer value of 128 bits is a good default value. However, some
user groups may want to use different values. For example, the SOGIS
group now requires 125 bits at least (BSI, the participant at that group
used to require 100 bits). NIST moved from 80 bits to 112 bits starting
with 2014.

It is therefore to be expected that in the future, this threshold may
increase for different user groups.

CC: Ted Tso <tytso@mit.edu>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/kernel-parameters.txt |  7 +++++++
 drivers/char/random.c               | 26 +++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 61ab162..bc6c6f1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2965,6 +2965,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	ramdisk_size=	[RAM] Sizes of RAM disks in kilobytes
 			See Documentation/blockdev/ramdisk.txt.
 
+	random_initialized= [KNL] Set the threshold in bits at which the
+			Linux random number generator considers an output
+			entropy pool initialized.
+			Format: <int> (must be >= 112 and <= size of output
+				       entropy pool in bits)
+			Default: 128
+
 	rcu_nocbs=	[KNL]
 			In kernels built with CONFIG_RCU_NOCB_CPU=y, set
 			the specified list of CPUs to be no-callback CPUs.
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9cd6968..cfe4d9b 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -317,6 +317,12 @@ static int random_write_wakeup_bits = 28 * OUTPUT_POOL_WORDS;
 static int random_min_urandom_seed = 60;
 
 /*
+ * Threshold of entropy at which an entropy pool is considered to be
+ * initialized.
+ */
+static int random_initialized_threshold = 128;
+
+/*
  * Originally, we used a primitive polynomial of degree .poolwords
  * over GF(2).  The taps for various sizes are defined below.  They
  * were chosen to be evenly spaced except for the last tap, which is 1
@@ -655,7 +661,8 @@ retry:
 		goto retry;
 
 	r->entropy_total += nbits;
-	if (!r->initialized && r->entropy_total > 128) {
+	if (!r->initialized &&
+	    r->entropy_total > random_initialized_threshold) {
 		r->initialized = 1;
 		r->entropy_total = 0;
 		if (r == &nonblocking_pool) {
@@ -938,6 +945,23 @@ void add_disk_randomness(struct gendisk *disk)
 EXPORT_SYMBOL_GPL(add_disk_randomness);
 #endif
 
+/* Process kernel command-line parameter at boot time. */
+static __init int random_initalized_cmdline(char *str)
+{
+	unsigned long thresh = simple_strtoul(str, NULL, 10);
+
+	if (thresh < 112)
+		thresh = 112;
+	if (thresh > OUTPUT_POOL_WORDS * 32)
+		thresh = OUTPUT_POOL_WORDS * 32;
+	random_initialized_threshold = thresh;
+	pr_notice("random: entropy pool initialization threshold set to %d bits\n",
+		  random_initialized_threshold);
+	return 1;
+}
+
+__setup("random_initialized=", random_initalized_cmdline);
+
 /*********************************************************************
  *
  * Entropy extraction routines
-- 
2.1.0
