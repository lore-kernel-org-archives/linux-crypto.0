From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v10 1/5] random: Blocking API for accessing nonblocking_pool
Date: Mon, 25 May 2015 15:08:47 +0200
Message-ID: <5691886.EWbBAFVTrP@tachyon.chronox.de>
References: <1818200.UPNYCFQzYg@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58232 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbbEYNLF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 May 2015 09:11:05 -0400
In-Reply-To: <1818200.UPNYCFQzYg@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The added API calls provide a synchronous function call
get_blocking_random_bytes where the caller is blocked until
the nonblocking_pool is initialized.

CC: Andreas Steffen <andreas.steffen@strongswan.org>
CC: Theodore Ts'o <tytso@mit.edu>
CC: Sandy Harris <sandyinchina@gmail.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c  | 12 ++++++++++++
 include/linux/random.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9cd6968..0bb7cb2 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1245,6 +1245,18 @@ void get_random_bytes(void *buf, int nbytes)
 EXPORT_SYMBOL(get_random_bytes);
 
 /*
+ * Equivalent function to get_random_bytes with the difference that this
+ * function blocks the request until the nonblocking_pool is initialized.
+ */
+void get_blocking_random_bytes(void *buf, int nbytes)
+{
+	if (unlikely(nonblocking_pool.initialized == 0))
+		wait_event(urandom_init_wait, nonblocking_pool.initialized);
+	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
+}
+EXPORT_SYMBOL(get_blocking_random_bytes);
+
+/*
  * This function will use the architecture-specific hardware random
  * number generator if it is available.  The arch-specific hw RNG will
  * almost certainly be faster than what we can do in software, but it
diff --git a/include/linux/random.h b/include/linux/random.h
index b05856e..796267d 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -14,6 +14,7 @@ extern void add_input_randomness(unsigned int type, unsigned int code,
 extern void add_interrupt_randomness(int irq, int irq_flags);
 
 extern void get_random_bytes(void *buf, int nbytes);
+extern void get_blocking_random_bytes(void *buf, int nbytes);
 extern void get_random_bytes_arch(void *buf, int nbytes);
 void generate_random_uuid(unsigned char uuid_out[16]);
 extern int random_int_secret_init(void);
-- 
2.1.0
