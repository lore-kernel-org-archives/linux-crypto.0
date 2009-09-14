From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH]: fix repetition test for hardware RNG to be FIPS
	compliant (v2)
Date: Mon, 14 Sep 2009 12:30:43 -0400
Message-ID: <20090914163043.GA27507@hmsreliant.think-freely.org>
References: <20090912164411.GA4735@localhost.localdomain> <20090913121734.GA23157@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39574 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbZINQap (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Sep 2009 12:30:45 -0400
Content-Disposition: inline
In-Reply-To: <20090913121734.GA23157@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ok, version 2 of the patch, taking comments into account

To be fips compliant, RNGs need to preform a continuous test on their output.
Specifically the requirement is that the first block of random data generated in
an RNG be saved to see the comparison test, and never returned to the caller.
This patch augments the continuous test in the hardware RNG to enforce this
requirement, making the hardware RNG fips compliant (when operating in fips
mode).

Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>



 random.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)


diff --git a/drivers/char/random.c b/drivers/char/random.c
index d8a9255..36fb05e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -399,6 +399,14 @@ module_param(debug, bool, 0644);
  * storing entropy in an entropy pool.
  *
  **********************************************************************/
+#define EXTRACT_SIZE 10
+
+#define REP_CHECK_BLOCK_COPIED 1
+
+struct repetition_check {
+	__u8 last_data[EXTRACT_SIZE];
+	__u8 flags;
+};
 
 struct entropy_store;
 struct entropy_store {
@@ -414,7 +422,7 @@ struct entropy_store {
 	unsigned add_ptr;
 	int entropy_count;
 	int input_rotate;
-	__u8 *last_data;
+	struct repetition_check rep;
 };
 
 static __u32 input_pool_data[INPUT_POOL_WORDS];
@@ -714,7 +722,6 @@ void add_disk_randomness(struct gendisk *disk)
 }
 #endif
 
-#define EXTRACT_SIZE 10
 
 /*********************************************************************
  *
@@ -855,19 +862,27 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
 	unsigned long flags;
+	size_t saved_nbytes = nbytes;
 
+repeat_extract:
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, min, reserved);
 
 	while (nbytes) {
 		extract_buf(r, tmp);
 
-		if (r->last_data) {
+		if (fips_enabled) {
 			spin_lock_irqsave(&r->lock, flags);
-			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
+			if ((r->rep.flags & REP_CHECK_BLOCK_COPIED) &&
+			    !memcmp(tmp, r->rep.last_data, EXTRACT_SIZE))
 				panic("Hardware RNG duplicated output!\n");
-			memcpy(r->last_data, tmp, EXTRACT_SIZE);
+			memcpy(r->rep.last_data, tmp, EXTRACT_SIZE);
 			spin_unlock_irqrestore(&r->lock, flags);
+			if (!(r->rep.flags & REP_CHECK_BLOCK_COPIED)) {
+				r->rep.flags |= REP_CHECK_BLOCK_COPIED;
+				nbytes = saved_nbytes;
+				goto repeat_extract;
+			}
 		}
 		i = min_t(int, nbytes, EXTRACT_SIZE);
 		memcpy(buf, tmp, i);
@@ -951,9 +966,6 @@ static void init_std_data(struct entropy_store *r)
 	now = ktime_get_real();
 	mix_pool_bytes(r, &now, sizeof(now));
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
-	/* Enable continuous test in fips mode */
-	if (fips_enabled)
-		r->last_data = kmalloc(EXTRACT_SIZE, GFP_KERNEL);
 }
 
 static int rand_initialize(void)
