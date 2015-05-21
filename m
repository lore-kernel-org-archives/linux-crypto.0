From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v9 3/5] crypto: drbg - add async seeding operation
Date: Thu, 21 May 2015 09:55:17 +0200
Message-ID: <9182932.rX0DhQWPrJ@tachyon.chronox.de>
References: <3340545.QDDPvU7BuN@tachyon.chronox.de> <12904468.qCSNRrkb6t@tachyon.chronox.de> <20150520214408.GA17264@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150520214408.GA17264@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 21. Mai 2015, 05:44:08 schrieb Herbert Xu:

Hi Herbert,

> On Wed, May 20, 2015 at 10:03:45PM +0200, Stephan Mueller wrote:
> >> @@ -1487,6 +1514,7 @@ unlock:
> >   */
> >  
> >  static int drbg_uninstantiate(struct drbg_state *drbg)
> >  {
> > 
> > +	cancel_work_sync(&drbg->seed_work);
> 
> This will just block until the work is done, i.e., until the
> pool is ready.  It's no different to an uninterruptible sleep.
> 
> So either just do an uninterruptible sleep, or allow the async
> seed to fail.

I think I found the issue: we cannot put interruptible and noninterruptible 
sleeps onto the same wait queue. With my initial tests, I put the 
uninterruptible sleep onto urandom_init_wait where also interruptible sleeps 
are put onto.

So, I will create a 2nd wait queue in random.c for uninterruptible waits, 
change the get_blocking_random_bytes back to void and use wait_event to wait 
for the initialization.
> 
> Cheers,


-- 
Ciao
Stephan
