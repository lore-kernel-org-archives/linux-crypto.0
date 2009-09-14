From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH]: fix repetition test for hardware RNG to be FIPS
	compliant
Date: Sun, 13 Sep 2009 22:04:41 -0400
Message-ID: <20090914020441.GA10970@localhost.localdomain>
References: <20090912164411.GA4735@localhost.localdomain> <20090913121734.GA23157@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59074 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZINCEu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 13 Sep 2009 22:04:50 -0400
Content-Disposition: inline
In-Reply-To: <20090913121734.GA23157@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Sep 13, 2009 at 02:17:34PM +0200, Sebastian Andrzej Siewior wrote:
> * Neil Horman | 2009-09-12 12:44:11 [-0400]:
> 
> >diff --git a/drivers/char/random.c b/drivers/char/random.c
> >index d8a9255..6700248 100644
> >--- a/drivers/char/random.c
> >+++ b/drivers/char/random.c
> >@@ -399,6 +399,12 @@ module_param(debug, bool, 0644);
> >  * storing entropy in an entropy pool.
> >  *
> >  **********************************************************************/
> >+#define EXTRACT_SIZE 10
> >+#define REP_CHECK_BLOCK_COPIED 1
> >+struct repetition_check {
> >+	__u8 last_data[EXTRACT_SIZE];
> >+	__u8 flags;
> >+};
> This struct should have 11 bytes and is only used in FIPS enabled mode.
> 
> > struct entropy_store;
> > struct entropy_store {
> >@@ -414,7 +420,7 @@ struct entropy_store {
> > 	unsigned add_ptr;
> > 	int entropy_count;
> > 	int input_rotate;
> >-	__u8 *last_data;
> >+	struct repetition_check *rep;
> > };
> so just a pointer to 11 bytes
> 
> > static __u32 input_pool_data[INPUT_POOL_WORDS];
> >@@ -714,7 +720,6 @@ void ad
> > 
> >-#define EXTRACT_SIZE 10
> > 
> > /*********************************************************************
> >  *
> >@@ -856,18 +861,24 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
> > 	__u8 tmp[EXTRACT_SIZE];
> > 	unsigned long flags;
> > 
> >+repeat_extract:
> > 	xfer_secondary_pool(r, nbytes);
> > 	nbytes = account(r, nbytes, min, reserved);
> > 
> > 	while (nbytes) {
> > 		extract_buf(r, tmp);
> > 
> >-		if (r->last_data) {
> >+		if (r->rep) {
> > 			spin_lock_irqsave(&r->lock, flags);
> >-			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
> >+			if ((r->rep->flags & REP_CHECK_BLOCK_COPIED) &&
> >+			    !memcmp(tmp, r->rep->last_data, EXTRACT_SIZE))
> > 				panic("Hardware RNG duplicated output!\n");
> >-			memcpy(r->last_data, tmp, EXTRACT_SIZE);
> >+			memcpy(r->rep->last_data, tmp, EXTRACT_SIZE);
> > 			spin_unlock_irqrestore(&r->lock, flags);
> >+			if (!(r->rep->flags & REP_CHECK_BLOCK_COPIED)) {
> >+				r->rep->flags |= REP_CHECK_BLOCK_COPIED;
> >+				goto repeat_extract;
> >+			}
> > 		}
> > 		i = min_t(int, nbytes, EXTRACT_SIZE);
> > 		memcpy(buf, tmp, i);
> >@@ -952,8 +963,10 @@ static void init_std_data(struct entropy_store *r)
> > 	mix_pool_bytes(r, &now, sizeof(now));
> > 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
> > 	/* Enable continuous test in fips mode */
> >-	if (fips_enabled)
> >-		r->last_data = kmalloc(EXTRACT_SIZE, GFP_KERNEL);
> >+	if (fips_enabled) {
> >+		r->rep = kmalloc(sizeof(struct repetition_check), GFP_KERNEL);
> and we alloc this 11 bytes via kmalloc. The smallest allocation is
> afaik 32 bytes. The three pools (input_pool, blocking_pool,
> nonblocking_pool) are in data seg so it probably does not hurt if you
> add the extra 10 bytes there. The advantage:
> - you don't have to deal with -ENOMEM. Otherwise it could be possible
>   that you not doing anything special in fips_mode
> - you go OOM if the user is using RNDCLEARPOOL ioctl(). Slowly but you
>   do.
> 
Ok, fair enough.  I'll rework it to all be inline and repost shortly.
Neil

