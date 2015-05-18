From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing nonblocking_pool
Date: Mon, 18 May 2015 07:32:01 +0200
Message-ID: <3672239.xqA2RrDaZY@tachyon.chronox.de>
References: <1921857.OvxEu6y28S@tachyon.chronox.de> <34087343.u7K3uzbyiZ@tachyon.chronox.de> <20150515064626.GA16704@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34813 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbbERFcF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 May 2015 01:32:05 -0400
In-Reply-To: <20150515064626.GA16704@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 15. Mai 2015, 14:46:26 schrieb Herbert Xu:

Hi Herbert,

> On Wed, May 13, 2015 at 09:54:41PM +0200, Stephan Mueller wrote:
> >  /*
> > 
> > + * Equivalent function to get_random_bytes with the difference that this
> > + * function blocks the request until the nonblocking_pool is initialized.
> > + */
> > +void get_blocking_random_bytes(void *buf, int nbytes)
> > +{
> > +	if (unlikely(nonblocking_pool.initialized == 0))
> > +		wait_event_interruptible(urandom_init_wait,
> > +					 nonblocking_pool.initialized);
> > +	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
> 
> So what if the wait was interrupted? You are going to extract
> entropy from an empty pool.
> 
> Anyway, you still haven't addressed my primary concern with this
> model which is the potential for dead-lock.  Sleeping for an open
> period of time like this in a work queue is bad form.  It may also
> lead to dead-locks if whatever you're waiting for happened to use
> the same work thread.
> 
> That's why I think you should simply provide a function and data
> pointer which random.c can then stash onto a list to call when
> the pool is ready.

Thanks for the hint to the list. Before handing in another formal patch, may i ask for checking the following approach? I would think that this one should cover your concerns.

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9cd6968..9bc2a57 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -409,6 +409,19 @@ static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
 static DECLARE_WAIT_QUEUE_HEAD(urandom_init_wait);
 static struct fasync_struct *fasync;
 
+static LIST_HEAD(random_wait_list);
+static DEFINE_MUTEX(random_wait_list_mutex);
+struct random_work {
+	struct list_head	list;
+	struct work_struct	rw_work;
+	void			*rw_buf;
+	int			rw_len;
+	void			*rw_private;
+	void			(*rw_cb)(void *buf, int buflen,
+					 void *private);
+};
+static void process_random_waiters(void);
+
 /**********************************************************************
  *
  * OS independent entropy store.   Here are the functions which handle
@@ -660,6 +673,7 @@ retry:
 		r->entropy_total = 0;
 		if (r == &nonblocking_pool) {
 			prandom_reseed_late();
+			process_random_waiters();
 			wake_up_interruptible(&urandom_init_wait);
 			pr_notice("random: %s pool is initialized\n", r->name);
 		}
@@ -1778,3 +1792,64 @@ void add_hwgenerator_randomness(const char *buffer, size_t count,
 	credit_entropy_bits(poolp, entropy);
 }
 EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
+
+static void process_random_waiters(void)
+{
+	struct random_work *rw = NULL;
+
+	mutex_lock(&random_wait_list_mutex);
+	while (!list_empty(&random_wait_list)) {
+		rw = list_first_entry(&random_wait_list, struct random_work,
+				      list);
+		list_del(&rw->list);
+		schedule_work(&rw->rw_work);
+	}
+	mutex_unlock(&random_wait_list_mutex);
+}
+
+static void get_blocking_random_bytes_work(struct work_struct *work)
+{
+	struct random_work *rw = container_of(work, struct random_work,
+					      rw_work);
+
+	get_random_bytes(rw->rw_buf, rw->rw_len);
+	rw->rw_cb(rw->rw_buf, rw->rw_len, rw->rw_private);
+	kfree(rw);
+}
+
+/*
+ * Equivalent function to get_random_bytes with the difference that this
+ * function blocks the request until the nonblocking_pool is initialized.
+ */
+int get_blocking_random_bytes_cb(void *buf, int nbytes, void *private,
+				 void (*cb)(void *buf, int buflen,
+					    void *private))
+{
+	struct random_work *rw = NULL;
+	int ret = 0;
+
+	mutex_lock(&random_wait_list_mutex);
+	list_for_each_entry(rw, &random_wait_list, list)
+		if (buf == rw->rw_buf)
+			goto out;
+
+	rw = kmalloc(sizeof(struct random_work), GFP_KERNEL);
+	if (!rw) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	INIT_WORK(&rw->rw_work, get_blocking_random_bytes_work);
+	rw->rw_buf = buf;
+	rw->rw_len = nbytes;
+	rw->rw_private = private;
+	rw->rw_cb = cb;
+	list_add_tail(&rw->list, &random_wait_list);
+
+out:
+	mutex_unlock(&random_wait_list_mutex);
+	if (nonblocking_pool.initialized)
+		process_random_waiters();
+
+	return ret;
+}
+EXPORT_SYMBOL(get_blocking_random_bytes_cb);
diff --git a/include/linux/random.h b/include/linux/random.h
index b05856e..b57525f 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -15,6 +15,9 @@ extern void add_interrupt_randomness(int irq, int irq_flags);
 
 extern void get_random_bytes(void *buf, int nbytes);
 extern void get_random_bytes_arch(void *buf, int nbytes);
+extern int get_blocking_random_bytes_cb(void *buf, int nbytes, void *private,
+					void (*cb)(void *buf, int buflen,
+						   void *private));
 void generate_random_uuid(unsigned char uuid_out[16]);
 extern int random_int_secret_init(void);
 
-- 
2.1.0



-- 
Ciao
Stephan
