From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v9 3/5] crypto: drbg - add async seeding operation
Date: Thu, 21 May 2015 08:10:13 +0200
Message-ID: <23102012.0an2QbkQix@tachyon.chronox.de>
References: <3340545.QDDPvU7BuN@tachyon.chronox.de> <12904468.qCSNRrkb6t@tachyon.chronox.de> <20150520214408.GA17264@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58135 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbbEUGKQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 02:10:16 -0400
In-Reply-To: <20150520214408.GA17264@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
> 
The cancel operation is needed as otherwise my drbg context handle will be 
removed by the crypto API during the sleep. That is the whole reason why 
wait_event_interruptible is used.

So, even when using an uninterruptible sleep, the crypto API has no knowledge 
about it and I have to serialize the destruction code path with the async 
callback.

-- 
Ciao
Stephan
