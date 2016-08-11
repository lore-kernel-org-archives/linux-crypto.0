From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v6 2/5] random: conditionally compile code depending on LRNG
Date: Thu, 11 Aug 2016 14:25:17 +0200
Message-ID: <1680213.fEivGm0usC@positron.chronox.de>
References: <4723196.TTQvcXsLCG@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Ted Tso <tytso@mit.edu>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4723196.TTQvcXsLCG@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
index 3efb3bf..730a12e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -270,6 +270,8 @@
 #include <asm/irq_regs.h>
 #include <asm/io.h>
 
+#ifndef CONFIG_CRYPTO_LRNG
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/random.h>
 
@@ -1898,6 +1900,7 @@ SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 	}
 	return urandom_read(NULL, buf, count, NULL);
 }
+#endif	/* CONFIG_CRYPTO_LRNG */
 
 /********************************************************************
  *
@@ -1905,6 +1908,7 @@ SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
  *
  ********************************************************************/
 
+#ifndef CONFIG_CRYPTO_LRNG
 #ifdef CONFIG_SYSCTL
 
 #include <linux/sysctl.h>
@@ -2042,6 +2046,8 @@ struct ctl_table random_table[] = {
 };
 #endif 	/* CONFIG_SYSCTL */
 
+#endif	/* CONFIG_CRYPTO_LRNG */
+
 static u32 random_int_secret[MD5_MESSAGE_BYTES / 4] ____cacheline_aligned;
 
 int random_int_secret_init(void)
@@ -2119,6 +2125,7 @@ randomize_range(unsigned long start, unsigned long end, unsigned long len)
 	return PAGE_ALIGN(get_random_int() % range + start);
 }
 
+#ifndef CONFIG_CRYPTO_LRNG
 /* Interface for in-kernel drivers of true hardware RNGs.
  * Those devices may produce endless random bits and will be throttled
  * when our pool is full.
@@ -2143,3 +2150,4 @@ void add_hwgenerator_randomness(const char *buffer, size_t count,
 	credit_entropy_bits(poolp, entropy);
 }
 EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
+#endif	/* CONFIG_CRYPTO_LRNG */
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 1dbf52f..387770d1 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -437,8 +437,13 @@ extern void disk_flush_events(struct gendisk *disk, unsigned int mask);
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
index 3d6e981..fd39c11 100644
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
2.7.4
