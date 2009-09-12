From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH]: fix repetition test for hardware RNG to be FIPS compliant
Date: Sat, 12 Sep 2009 12:44:11 -0400
Message-ID: <20090912164411.GA4735@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52159 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbZILQoR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Sep 2009 12:44:17 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey all-
	A while back I implemented a repetition check in the hardware RNG to
make it FIPS compliant.  It was just pointed out to me that there was an item in
the requirement that I missed.  Namely, when operating in FIPS mode, the RNG
should save the first n bit block that it produces for use in the repetition
check, but not return it to the caller (opting instead to return the next n bit
block which passes the repetiiton check instead.  This patch corrects that.

Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 random.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)


diff --git a/drivers/char/random.c b/drivers/char/random.c
index d8a9255..6700248 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -399,6 +399,12 @@ module_param(debug, bool, 0644);
  * storing entropy in an entropy pool.
  *
  **********************************************************************/
+#define EXTRACT_SIZE 10
+#define REP_CHECK_BLOCK_COPIED 1
+struct repetition_check {
+	__u8 last_data[EXTRACT_SIZE];
+	__u8 flags;
+};
 
 struct entropy_store;
 struct entropy_store {
@@ -414,7 +420,7 @@ struct entropy_store {
 	unsigned add_ptr;
 	int entropy_count;
 	int input_rotate;
-	__u8 *last_data;
+	struct repetition_check *rep;
 };
 
 static __u32 input_pool_data[INPUT_POOL_WORDS];
@@ -714,7 +720,6 @@ void add_disk_randomness(struct gendisk *disk)
 }
 #endif
 
-#define EXTRACT_SIZE 10
 
 /*********************************************************************
  *
@@ -856,18 +861,24 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 	__u8 tmp[EXTRACT_SIZE];
 	unsigned long flags;
 
+repeat_extract:
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, min, reserved);
 
 	while (nbytes) {
 		extract_buf(r, tmp);
 
-		if (r->last_data) {
+		if (r->rep) {
 			spin_lock_irqsave(&r->lock, flags);
-			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
+			if ((r->rep->flags & REP_CHECK_BLOCK_COPIED) &&
+			    !memcmp(tmp, r->rep->last_data, EXTRACT_SIZE))
 				panic("Hardware RNG duplicated output!\n");
-			memcpy(r->last_data, tmp, EXTRACT_SIZE);
+			memcpy(r->rep->last_data, tmp, EXTRACT_SIZE);
 			spin_unlock_irqrestore(&r->lock, flags);
+			if (!(r->rep->flags & REP_CHECK_BLOCK_COPIED)) {
+				r->rep->flags |= REP_CHECK_BLOCK_COPIED;
+				goto repeat_extract;
+			}
 		}
 		i = min_t(int, nbytes, EXTRACT_SIZE);
 		memcpy(buf, tmp, i);
@@ -952,8 +963,10 @@ static void init_std_data(struct entropy_store *r)
 	mix_pool_bytes(r, &now, sizeof(now));
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
 	/* Enable continuous test in fips mode */
-	if (fips_enabled)
-		r->last_data = kmalloc(EXTRACT_SIZE, GFP_KERNEL);
+	if (fips_enabled) {
+		r->rep = kmalloc(sizeof(struct repetition_check), GFP_KERNEL);
+		r->rep->flags = 0;
+	}
 }
 
 static int rand_initialize(void)
