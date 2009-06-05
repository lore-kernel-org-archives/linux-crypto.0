From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: add optional continuous repetition test to
	entropy store based rngs
Date: Thu, 4 Jun 2009 21:48:16 -0400
Message-ID: <20090605014816.GA15462@localhost.localdomain>
References: <20090604195030.GA11300@hmsreliant.think-freely.org> <1244146450.22069.216.camel@calx> <20090605000456.GA10883@localhost.localdomain> <20090605003006.GA5236@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48855 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZFEBsd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Jun 2009 21:48:33 -0400
Content-Disposition: inline
In-Reply-To: <20090605003006.GA5236@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 05, 2009 at 10:30:06AM +1000, Herbert Xu wrote:
> On Thu, Jun 04, 2009 at 08:04:56PM -0400, Neil Horman wrote:
> >
> > Not sure what to do about this.  The intent is to provide the external reference
> > to the fips_enabled flag (which is either defined as an extern in or #defined to
> > 0 dependent on CONFIG_CRYPTO_FIPS).  I can cut'n'paste the code block from the
> > include file and put it in here, but that seems like a worse solution to me.
> > Let me know your thoughts, and I can change this accordingly.
> 
> You can put the fips flag into its own header file, e.g., linux/fips.h.
> 

Ok, that seems like a reasonable idea.  new patch below
Change Notes:

1) Moved fips_enabled flag into its own header, included in all the appropriate
places

2) removed flags field from entropy store, keying continuous test on the
non-null status of the last_data pointer


FIPS-140 requires that all random number generators implement continuous self
tests in which each extracted block of data is compared against the last block
for repetition.  The ansi_cprng implements such a test, but it would be nice if
the hw rng's did the same thing.  Obviously its not something thats always
needed, but it seems like it would be a nice feature to have on occasion. I've
written the below patch which allows individual entropy stores to be flagged as
desiring a continuous test to be run on them as is extracted.  By default this
option is off, but is enabled in the event that fips mode is selected during
bootup.

Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


crypto/internal.h     |    7 +------
drivers/char/random.c |   14 ++++++++++++++
include/linux/fips.h  |   10 ++++++++++
3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/crypto/internal.h b/crypto/internal.h
index fc76e1f..769b713 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -25,12 +25,7 @@
 #include <linux/notifier.h>
 #include <linux/rwsem.h>
 #include <linux/slab.h>
-
-#ifdef CONFIG_CRYPTO_FIPS
-extern int fips_enabled;
-#else
-#define fips_enabled 0
-#endif
+#include <linux/fips.h>
 
 /* Crypto notification events. */
 enum {
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 8c74448..d8a9255 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -240,6 +240,7 @@
 #include <linux/spinlock.h>
 #include <linux/percpu.h>
 #include <linux/cryptohash.h>
+#include <linux/fips.h>
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 # include <linux/irq.h>
@@ -413,6 +414,7 @@ struct entropy_store {
 	unsigned add_ptr;
 	int entropy_count;
 	int input_rotate;
+	__u8 *last_data;
 };
 
 static __u32 input_pool_data[INPUT_POOL_WORDS];
@@ -852,12 +854,21 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 {
 	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
+	unsigned long flags;
 
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, min, reserved);
 
 	while (nbytes) {
 		extract_buf(r, tmp);
+
+		if (r->last_data) {
+			spin_lock_irqsave(&r->lock, flags);
+			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
+				panic("Hardware RNG duplicated output!\n");
+			memcpy(r->last_data, tmp, EXTRACT_SIZE);
+			spin_unlock_irqrestore(&r->lock, flags);
+		}
 		i = min_t(int, nbytes, EXTRACT_SIZE);
 		memcpy(buf, tmp, i);
 		nbytes -= i;
@@ -940,6 +951,9 @@ static void init_std_data(struct entropy_store *r)
 	now = ktime_get_real();
 	mix_pool_bytes(r, &now, sizeof(now));
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
+	/* Enable continuous test in fips mode */
+	if (fips_enabled)
+		r->last_data = kmalloc(EXTRACT_SIZE, GFP_KERNEL);
 }
 
 static int rand_initialize(void)
diff --git a/include/linux/fips.h b/include/linux/fips.h
new file mode 100644
index 0000000..f8fb07b
--- /dev/null
+++ b/include/linux/fips.h
@@ -0,0 +1,10 @@
+#ifndef _FIPS_H
+#define _FIPS_H
+
+#ifdef CONFIG_CRYPTO_FIPS
+extern int fips_enabled;
+#else
+#define fips_enabled 0
+#endif
+
+#endif
> Cheers,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
