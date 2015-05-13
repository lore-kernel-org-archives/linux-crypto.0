From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v6 1/5] random: Blocking API for accessing nonblocking_pool
Date: Wed, 13 May 2015 21:54:41 +0200
Message-ID: <34087343.u7K3uzbyiZ@tachyon.chronox.de>
References: <1921857.OvxEu6y28S@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1921857.OvxEu6y28S@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The added API calls provide a synchronous function call
get_blocking_random_bytes where the caller is blocked until
the nonblocking_pool is initialized.

CC: Andreas Steffen <andreas.steffen@strongswan.org>
CC: Theodore Ts'o <tytso@mit.edu>
CC: Sandy Harris <sandyinchina@gmail.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c  | 14 ++++++++++++++
 include/linux/random.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9cd6968..6f71354 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1245,6 +1245,20 @@ void get_random_bytes(void *buf, int nbytes)
 EXPORT_SYMBOL(get_random_bytes);
 
 /*
+ * Equivalent function to get_random_bytes with the difference that this
+ * function blocks the request until the nonblocking_pool is initialized.
+ */
+void get_blocking_random_bytes(void *buf, int nbytes)
+{
+	if (unlikely(nonblocking_pool.initialized == 0))
+		wait_event_interruptible(urandom_init_wait,
+					 nonblocking_pool.initialized);
+	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
+}
+EXPORT_SYMBOL(get_blocking_random_bytes);
+
+
+/*
  * This function will use the architecture-specific hardware random
  * number generator if it is available.  The arch-specific hw RNG will
  * almost certainly be faster than what we can do in software, but it
diff --git a/include/linux/random.h b/include/linux/random.h
index b05856e..0926d78 100644
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
