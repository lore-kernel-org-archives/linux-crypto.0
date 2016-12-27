From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 5/8] random: remove variable limit
Date: Tue, 27 Dec 2016 23:40:59 +0100
Message-ID: <13861626.tTeaaQ9jhE@positron.chronox.de>
References: <3254875.f5A5oHPdxF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55042 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754599AbcL0Wno (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 17:43:44 -0500
In-Reply-To: <3254875.f5A5oHPdxF@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The variable limit was used to identify the nonblocking pool's unlimited
random number generation. As the nonblocking pool is a thing of the
past, remove the limit variable and any conditions around it (i.e.
preserve the branches for limit == 1).

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c | 30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 8d4d720..d19108c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -466,7 +466,6 @@ struct entropy_store {
 	int entropy_count;
 	int entropy_total;
 	unsigned int initialized:1;
-	unsigned int limit:1;
 	unsigned int last_data_init:1;
 	__u8 last_data[EXTRACT_SIZE];
 };
@@ -484,7 +483,6 @@ static __u32 blocking_pool_data[OUTPUT_POOL_WORDS] __latent_entropy;
 static struct entropy_store input_pool = {
 	.poolinfo = &poolinfo_table[0],
 	.name = "input",
-	.limit = 1,
 	.lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
 	.pool = input_pool_data
 };
@@ -492,7 +490,6 @@ static struct entropy_store input_pool = {
 static struct entropy_store blocking_pool = {
 	.poolinfo = &poolinfo_table[1],
 	.name = "blocking",
-	.limit = 1,
 	.pull = &input_pool,
 	.lock = __SPIN_LOCK_UNLOCKED(blocking_pool.lock),
 	.pool = blocking_pool_data,
@@ -1212,15 +1209,6 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 	    r->entropy_count > r->poolinfo->poolfracbits)
 		return;
 
-	if (r->limit == 0 && random_min_urandom_seed) {
-		unsigned long now = jiffies;
-
-		if (time_before(now,
-				r->last_pulled + random_min_urandom_seed * HZ))
-			return;
-		r->last_pulled = now;
-	}
-
 	_xfer_secondary_pool(r, nbytes);
 }
 
@@ -1228,8 +1216,6 @@ static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 {
 	__u32	tmp[OUTPUT_POOL_WORDS];
 
-	/* For /dev/random's pool, always leave two wakeups' worth */
-	int rsvd_bytes = r->limit ? 0 : random_read_wakeup_bits / 4;
 	int bytes = nbytes;
 
 	/* pull at least as much as a wakeup */
@@ -1240,7 +1226,7 @@ static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 	trace_xfer_secondary_pool(r->name, bytes * 8, nbytes * 8,
 				  ENTROPY_BITS(r), ENTROPY_BITS(r->pull));
 	bytes = extract_entropy(r->pull, tmp, bytes,
-				random_read_wakeup_bits / 8, rsvd_bytes);
+				random_read_wakeup_bits / 8, 0);
 	mix_pool_bytes(r, tmp, bytes);
 	credit_entropy_bits(r, bytes*8);
 }
@@ -1268,7 +1254,7 @@ static void push_to_pool(struct work_struct *work)
 static size_t account(struct entropy_store *r, size_t nbytes, int min,
 		      int reserved)
 {
-	int entropy_count, orig;
+	int entropy_count, orig, have_bytes;
 	size_t ibytes, nfrac;
 
 	BUG_ON(r->entropy_count > r->poolinfo->poolfracbits);
@@ -1277,14 +1263,12 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 retry:
 	entropy_count = orig = ACCESS_ONCE(r->entropy_count);
 	ibytes = nbytes;
-	/* If limited, never pull more than available */
-	if (r->limit) {
-		int have_bytes = entropy_count >> (ENTROPY_SHIFT + 3);
+	/* never pull more than available */
+	have_bytes = entropy_count >> (ENTROPY_SHIFT + 3);
 
-		if ((have_bytes -= reserved) < 0)
-			have_bytes = 0;
-		ibytes = min_t(size_t, ibytes, have_bytes);
-	}
+	if ((have_bytes -= reserved) < 0)
+		have_bytes = 0;
+	ibytes = min_t(size_t, ibytes, have_bytes);
 	if (ibytes < min)
 		ibytes = 0;
 
-- 
2.9.3
