From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 2/5] random: conditionally compile code depending on LRNG
Date: Fri, 29 Apr 2016 08:23:16 +0200
Message-ID: <2045487.BqpNCVykYa@positron.chronox.de>
References: <2346517.m8UHYeMDSf@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Ted Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	sandyinchina@gmail.com, Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	joe@perches.com, Pavel Machek <pavel@ucw.cz>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54102 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbcD2GZt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 02:25:49 -0400
In-Reply-To: <2346517.m8UHYeMDSf@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When selecting the LRNG for compilation, disable the legacy /dev/random
implementation.

The LRNG is a drop-in replacement for the legacy /dev/random which
implements the same in-kernel and user space API. Only the hooks of
/dev/random into other parts of the kernel need to be disabled.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c  | 8 ++++++++
 include/linux/genhd.h  | 5 +++++
 include/linux/random.h | 7 ++++++-
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b583e53..92c2174 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -267,6 +267,8 @@
 #include <asm/irq_regs.h>
 #include <asm/io.h>
 
+#ifndef CONFIG_CRYPTO_LRNG
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/random.h>
 
@@ -1620,6 +1622,7 @@ SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 	}
 	return urandom_read(NULL, buf, count, NULL);
 }
+#endif	/* CONFIG_CRYPTO_LRNG */
 
 /***************************************************************
  * Random UUID interface
@@ -1647,6 +1650,7 @@ EXPORT_SYMBOL(generate_random_uuid);
  *
  ********************************************************************/
 
+#ifndef CONFIG_CRYPTO_LRNG
 #ifdef CONFIG_SYSCTL
 
 #include <linux/sysctl.h>
@@ -1784,6 +1788,8 @@ struct ctl_table random_table[] = {
 };
 #endif 	/* CONFIG_SYSCTL */
 
+#endif	/* CONFIG_CRYPTO_LRNG */
+
 static u32 random_int_secret[MD5_MESSAGE_BYTES / 4] ____cacheline_aligned;
 
 int random_int_secret_init(void)
@@ -1859,6 +1865,7 @@ randomize_range(unsigned long start, unsigned long end, unsigned long len)
 	return PAGE_ALIGN(get_random_int() % range + start);
 }
 
+#ifndef CONFIG_CRYPTO_LRNG
 /* Interface for in-kernel drivers of true hardware RNGs.
  * Those devices may produce endless random bits and will be throttled
  * when our pool is full.
@@ -1878,3 +1885,4 @@ void add_hwgenerator_randomness(const char *buffer, size_t count,
 	credit_entropy_bits(poolp, entropy);
 }
 EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
+#endif	/* CONFIG_CRYPTO_LRNG */
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 5c70676..962c82f 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -450,8 +450,13 @@ extern void disk_flush_events(struct gendisk *disk, unsigned int mask);
 extern unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask);
 
 /* drivers/char/random.c */
+#ifdef CONFIG_CRYPTO_LRNG
+#define add_disk_randomness(disk) do {} while (0)
+#define rand_initialize_disk(disk) do {} while (0)
+#else
 extern void add_disk_randomness(struct gendisk *disk);
 extern void rand_initialize_disk(struct gendisk *disk);
+#endif
 
 static inline sector_t get_start_sect(struct block_device *bdev)
 {
diff --git a/include/linux/random.h b/include/linux/random.h
index 9c29122..4d9fa6e 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -17,10 +17,15 @@ struct random_ready_callback {
 	struct module *owner;
 };
 
-extern void add_device_randomness(const void *, unsigned int);
 extern void add_input_randomness(unsigned int type, unsigned int code,
 				 unsigned int value);
 extern void add_interrupt_randomness(int irq, int irq_flags);
+#ifdef CONFIG_CRYPTO_LRNG
+#define add_device_randomness(buf, nbytes) do {} while (0)
+#else	/* CONFIG_CRYPTO_LRNG */
+extern void add_device_randomness(const void *, unsigned int);
+#define lrng_irq_process()
+#endif	/* CONFIG_CRYPTO_LRNG */
 
 extern void get_random_bytes(void *buf, int nbytes);
 extern int add_random_ready_callback(struct random_ready_callback *rdy);
-- 
2.5.5
