From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: add optional continuous repetition test to
	entropy store based rngs
Date: Thu, 4 Jun 2009 20:04:56 -0400
Message-ID: <20090605000456.GA10883@localhost.localdomain>
References: <20090604195030.GA11300@hmsreliant.think-freely.org> <1244146450.22069.216.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net
To: Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37856 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbZFEAFH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Jun 2009 20:05:07 -0400
Content-Disposition: inline
In-Reply-To: <1244146450.22069.216.camel@calx>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 04, 2009 at 03:14:10PM -0500, Matt Mackall wrote:
> On Thu, 2009-06-04 at 15:50 -0400, Neil Horman wrote:
> > FIPS-140 requires that all random number generators implement continuous self
> > tests in which each extracted block of data is compared against the last block
> > for repetition.  The ansi_cprng implements such a test, but it would be nice if
> > the hw rng's did the same thing.  Obviously its not something thats always
> > needed, but it seems like it would be a nice feature to have on occasion.  I've
> > written the below patch which allows individual entropy stores to be flagged as
> > desiring a continuous test to be run on them as is extracted.  By default this
> > option is off, but is enabled in the event that fips mode is selected during
> > bootup.
> > 
> > Neil
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > 
> > diff --git a/crypto/internal.h b/crypto/internal.h
> > index fc76e1f..150d389 100644
> > --- a/crypto/internal.h
> > +++ b/crypto/internal.h
> > @@ -26,12 +26,6 @@
> >  #include <linux/rwsem.h>
> >  #include <linux/slab.h>
> >  
> > -#ifdef CONFIG_CRYPTO_FIPS
> > -extern int fips_enabled;
> > -#else
> > -#define fips_enabled 0
> > -#endif
> > -
> >  /* Crypto notification events. */
> >  enum {
> >  	CRYPTO_MSG_ALG_REQUEST,
> > diff --git a/drivers/char/random.c b/drivers/char/random.c
> > index 8c74448..fbdfc70 100644
> > --- a/drivers/char/random.c
> > +++ b/drivers/char/random.c
> > @@ -250,6 +250,8 @@
> >  #include <asm/irq.h>
> >  #include <asm/io.h>
> >  
> > +#include <crypto/algapi.h>
> > +
> 
> I think we'd rather not make random.c incestuous with crypto/.
> 
Not sure what to do about this.  The intent is to provide the external reference
to the fips_enabled flag (which is either defined as an extern in or #defined to
0 dependent on CONFIG_CRYPTO_FIPS).  I can cut'n'paste the code block from the
include file and put it in here, but that seems like a worse solution to me.
Let me know your thoughts, and I can change this accordingly.

As for the other comments, they all seem good to me, let me know what you want
to do about the above, and I'll respin/repost the patch for you

Thanks!
Neil

