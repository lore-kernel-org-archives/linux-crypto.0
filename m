From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [RFC][PATCH] RANDOM: ATH9K RNG delivers zero bits of entropy
Date: Sat, 6 Aug 2016 20:16:02 +0000
Message-ID: <20160806201602.GB4511@io.lakedaemon.net>
References: <34197429.2CvoIfft9B@positron.chronox.de>
 <20160806194551.GA4511@io.lakedaemon.net>
 <6481670.KeU7RXkv1k@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, Kalle Valo <kvalo@codeaurora.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pmta2.delivery5.ore.mailhop.org ([54.186.218.12]:51654 "EHLO
	pmta2.delivery5.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbcHFUQH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Aug 2016 16:16:07 -0400
Content-Disposition: inline
In-Reply-To: <6481670.KeU7RXkv1k@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

On Sat, Aug 06, 2016 at 10:03:58PM +0200, Stephan Mueller wrote:
> Am Samstag, 6. August 2016, 19:45:51 CEST schrieb Jason Cooper:
> > On Fri, Aug 05, 2016 at 05:08:14PM +0200, Stephan Mueller wrote:
...
> > > diff --git a/drivers/net/wireless/ath/ath9k/rng.c
> > > b/drivers/net/wireless/ath/ath9k/rng.c index d38e50f..d63dc48 100644
> > > --- a/drivers/net/wireless/ath/ath9k/rng.c
> > > +++ b/drivers/net/wireless/ath/ath9k/rng.c
> > > @@ -92,8 +92,7 @@ static int ath9k_rng_kthread(void *data)
> > > 
> > >  		fail_stats = 0;
> > >  		
> > >  		/* sleep until entropy bits under write_wakeup_threshold */
> > > 
> > > -		add_hwgenerator_randomness((void *)rng_buf, bytes_read,
> > > -					   ATH9K_RNG_ENTROPY(bytes_read));
> > 
> > This is the only use of this macro.  I'd remove the #define on line 25
> > as well.
> 
> My idea for leaving it was that folks who would bring the RNG into the 
> hwrandom framework could reuse the ideas from the original authors.
> 
> What about commenting it out with #if 0 ?

#if 0 is frowned upon.  If that calculation is documented somewhere,
then it can be redone from the spec.  If it isn't, then I'd be curious
to know where it came from.

Perhaps one of the ath9k devs can point to a document containing the
formula?  We could put the reference in a comment.

thx,

Jason.
