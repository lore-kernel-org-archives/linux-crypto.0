From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: random: Wake up all getrandom(2) callers when pool is ready
Date: Thu, 21 May 2015 15:17:39 -0400
Message-ID: <20150521191739.GP2871@thunk.org>
References: <3340545.QDDPvU7BuN@tachyon.chronox.de>
 <12904468.qCSNRrkb6t@tachyon.chronox.de>
 <20150520214408.GA17264@gondor.apana.org.au>
 <9182932.rX0DhQWPrJ@tachyon.chronox.de>
 <20150521081953.GA22301@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>, pebolle@tiscali.nl,
	andreas.steffen@strongswan.org, sandyinchina@gmail.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50976 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702AbbEUTRq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 15:17:46 -0400
Content-Disposition: inline
In-Reply-To: <20150521081953.GA22301@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 21, 2015 at 04:19:54PM +0800, Herbert Xu wrote:
> On Thu, May 21, 2015 at 09:55:17AM +0200, Stephan Mueller wrote:
> >
> > So, I will create a 2nd wait queue in random.c for uninterruptible waits, 
> > change the get_blocking_random_bytes back to void and use wait_event to wait 
> > for the initialization.
> 
> Hold your horses.  You don't need a second queue, you just need to
> change wake_up_interruptible to wake_up.
> 
> Hmm, in fact shouldn't this be wake_up_all? Otherwise what are the
> other getrandom(2) callers going to do? Ted?

Yes, this should definitely be wake_up_all()

							- Ted
