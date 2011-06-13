From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 1/5] random: add new clocksource entropy interface
Date: Mon, 13 Jun 2011 18:06:54 -0400
Message-ID: <1308002818-27802-2-git-send-email-jarod@redhat.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>, Matt Mackall <mpm@selenic.com>,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685Ab1FMWHn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2011 18:07:43 -0400
In-Reply-To: <1308002818-27802-1-git-send-email-jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a new interface for adding entropy data to the random number
generator. The low-order byte of a delta between successive clocksource
reads is mixed into the pool, with one bit per bytes of data mixed in
credited to the entropy pool.

CC: Matt Mackall <mpm@selenic.com>
CC: "Venkatesh Pallipadi (Venki)" <venki@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>
CC: John Stultz <johnstul@us.ibm.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/char/random.c  |   28 ++++++++++++++++++++++++++++
 include/linux/random.h |    1 +
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d4ddeba..03626c3 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -129,6 +129,7 @@
  *                                unsigned int value);
  * 	void add_interrupt_randomness(int irq);
  * 	void add_disk_randomness(struct gendisk *disk);
+ * 	void add_clocksource_randomness(int delta);
  *
  * add_input_randomness() uses the input layer interrupt timing, as well as
  * the event type information from the hardware.
@@ -147,6 +148,12 @@
  * seek times do not make for good sources of entropy, as their seek
  * times are usually fairly consistent.
  *
+ * add_clocksource_randomness() uses time deltas between period reads
+ * of high-precision clocksources. The Linux kernel scheduler has no
+ * absolute guarantees of execution time, its best-effort, and we can
+ * be certain there will be entirely random variation in the actual
+ * deltas, at least at the nanosecond level for high-precision timers.
+ *
  * All of these routines try to estimate how many bits of randomness a
  * particular randomness source.  They do this by keeping track of the
  * first and second order deltas of the event timings.
@@ -722,6 +729,27 @@ void add_disk_randomness(struct gendisk *disk)
 }
 #endif
 
+void add_clocksource_randomness(int clock_delta)
+{
+	/* only mix in the low byte */
+	u8 mix = clock_delta & 0xff;
+
+	DEBUG_ENT("clock event %u\n", mix);
+
+	preempt_disable();
+	if (input_pool.entropy_count > trickle_thresh &&
+	    (__get_cpu_var(trickle_count)++ & 0xfff))
+		goto out;
+
+	mix_pool_bytes(&input_pool, &mix, sizeof(mix));
+	/* Only credit one bit per byte to be conservative */
+	credit_entropy_bits(&input_pool, sizeof(mix));
+
+out:
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(add_clocksource_randomness);
+
 /*********************************************************************
  *
  * Entropy extraction routines
diff --git a/include/linux/random.h b/include/linux/random.h
index fb7ab9d..9e303dd 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -53,6 +53,7 @@ extern void rand_initialize_irq(int irq);
 extern void add_input_randomness(unsigned int type, unsigned int code,
 				 unsigned int value);
 extern void add_interrupt_randomness(int irq);
+extern void add_clocksource_randomness(int delta);
 
 extern void get_random_bytes(void *buf, int nbytes);
 void generate_random_uuid(unsigned char uuid_out[16]);
-- 
1.7.1
