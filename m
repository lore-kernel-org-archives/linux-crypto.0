From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 8/8] random: move FIPS continuous test to output functions
Date: Tue, 27 Dec 2016 23:42:40 +0100
Message-ID: <31553556.eelvSj7Jsg@positron.chronox.de>
References: <3254875.f5A5oHPdxF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55036 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754424AbcL0Wno (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 17:43:44 -0500
In-Reply-To: <3254875.f5A5oHPdxF@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The current lockation of the FIPS continuous self test covers the
input_pool only. However, the FIPS continuous self test shall cover the
output of the random number generator, i.e. the blocking pool and the
ChaCha20 DRNG.

This patch therefore moves the continuous test to the output function
used for /dev/random. In addition, it adds the continuous test to the
ChaCha20 output function.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c | 71 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 43 insertions(+), 28 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 7b72a01..d185d1f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -416,6 +416,8 @@ struct crng_state {
 	__u32		state[16];
 	unsigned long	init_time;
 	spinlock_t	lock;
+	unsigned int last_data_init:1;
+	__u8 last_data[CHACHA20_BLOCK_SIZE];
 };
 
 struct crng_state primary_crng = {
@@ -471,7 +473,7 @@ struct entropy_store {
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 			       size_t nbytes, int min, int rsvd);
 static ssize_t _extract_entropy(struct entropy_store *r, void *buf,
-				size_t nbytes, int fips);
+				size_t nbytes);
 
 static void crng_reseed(struct crng_state *crng, struct entropy_store *r);
 static void push_to_pool(struct work_struct *work);
@@ -775,7 +777,7 @@ static void crng_initialize(struct crng_state *crng)
 	memcpy(&crng->state[0], "expand 32-byte k", 16);
 	if (crng == &primary_crng)
 		_extract_entropy(&input_pool, &crng->state[4],
-				 sizeof(__u32) * 12, 0);
+				 sizeof(__u32) * 12);
 	else
 		get_random_bytes(&crng->state[4], sizeof(__u32) * 12);
 	for (i = 4; i < 16; i++) {
@@ -864,11 +866,25 @@ static void _extract_crng(struct crng_state *crng,
 	    time_after(jiffies, crng->init_time + CRNG_RESEED_INTERVAL))
 		crng_reseed(crng, crng == &primary_crng ? &input_pool : NULL);
 	spin_lock_irqsave(&crng->lock, flags);
+
+	if (fips_enabled && !crng->last_data_init) {
+		crng->last_data_init = 1;
+		chacha20_block(&crng->state[0], out);
+		memcpy(crng->last_data, out, CHACHA20_BLOCK_SIZE);
+	}
+
 	if (arch_get_random_long(&v))
 		crng->state[14] ^= v;
 	chacha20_block(&crng->state[0], out);
 	if (crng->state[12] == 0)
 		crng->state[13]++;
+
+	if (fips_enabled) {
+		if (!memcmp(out, crng->last_data, CHACHA20_BLOCK_SIZE))
+			panic("ChaCha20 RNG duplicated output!\n");
+		memcpy(crng->last_data, out, CHACHA20_BLOCK_SIZE);
+	}
+
 	spin_unlock_irqrestore(&crng->lock, flags);
 }
 
@@ -1356,22 +1372,14 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 }
 
 static ssize_t _extract_entropy(struct entropy_store *r, void *buf,
-				size_t nbytes, int fips)
+				size_t nbytes)
 {
 	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
-	unsigned long flags;
 
 	while (nbytes) {
 		extract_buf(r, tmp);
 
-		if (fips) {
-			spin_lock_irqsave(&r->lock, flags);
-			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
-				panic("Hardware RNG duplicated output!\n");
-			memcpy(r->last_data, tmp, EXTRACT_SIZE);
-			spin_unlock_irqrestore(&r->lock, flags);
-		}
 		i = min_t(int, nbytes, EXTRACT_SIZE);
 		memcpy(buf, tmp, i);
 		nbytes -= i;
@@ -1397,7 +1405,22 @@ static ssize_t _extract_entropy(struct entropy_store *r, void *buf,
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 				 size_t nbytes, int min, int reserved)
 {
+	trace_extract_entropy(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
+	nbytes = account(r, nbytes, min, reserved);
+
+	return _extract_entropy(r, buf, nbytes);
+}
+
+/*
+ * This function extracts randomness from the "entropy pool", and
+ * returns it in a userspace buffer.
+ */
+static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
+				    size_t nbytes)
+{
+	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
+	int large_request = (nbytes > 256);
 	unsigned long flags;
 
 	/* if last_data isn't primed, we need EXTRACT_SIZE extra bytes */
@@ -1416,23 +1439,6 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 		spin_unlock_irqrestore(&r->lock, flags);
 	}
 
-	trace_extract_entropy(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
-	nbytes = account(r, nbytes, min, reserved);
-
-	return _extract_entropy(r, buf, nbytes, fips_enabled);
-}
-
-/*
- * This function extracts randomness from the "entropy pool", and
- * returns it in a userspace buffer.
- */
-static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
-				    size_t nbytes)
-{
-	ssize_t ret = 0, i;
-	__u8 tmp[EXTRACT_SIZE];
-	int large_request = (nbytes > 256);
-
 	trace_extract_entropy_user(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, 0, 0);
@@ -1448,6 +1454,15 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 		}
 
 		extract_buf(r, tmp);
+
+		if (fips_enabled) {
+			spin_lock_irqsave(&r->lock, flags);
+			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
+				panic("Hardware RNG duplicated output!\n");
+			memcpy(r->last_data, tmp, EXTRACT_SIZE);
+			spin_unlock_irqrestore(&r->lock, flags);
+		}
+
 		i = min_t(int, nbytes, EXTRACT_SIZE);
 		if (copy_to_user(buf, tmp, i)) {
 			ret = -EFAULT;
-- 
2.9.3
