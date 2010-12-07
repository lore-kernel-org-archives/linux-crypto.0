From: Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH] crypto: padlock: fix for non-64byte aligned data
Date: Tue, 7 Dec 2010 11:41:41 +0100
Message-ID: <20101207104141.GA24946@orbit.nwl.cc>
References: <1288893036-31704-1-git-send-email-phil@nwl.cc>
 <20101104184606.GA1994@gondor.apana.org.au>
 <20101105141238.GG29793@orbit.nwl.cc>
 <20101202061441.GA22378@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
	Nico Erfurth <ne@erfurth.eu>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orbit.nwl.cc ([91.121.169.95]:56829 "EHLO orbit.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab0LGKlm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Dec 2010 05:41:42 -0500
Content-Disposition: inline
In-Reply-To: <20101202061441.GA22378@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Thu, Dec 02, 2010 at 02:14:41PM +0800, Herbert Xu wrote:
> > Yes, it does, but triggering the bug is not really trivial. I've had
> > best results with a speed testing tool using the asynchronous interface,
> > memory corruption occured in each run. The same tool operating
> > synchronously doesn't crash as soon, but having three or more instances
> > running in parallel yields the same result.
> > 
> > This problem is so racey, a simple printk statement at the beginning of
> > padlock_xcrypt_ecb() fixes it. Enclosing the same function's content in
> > lock_kernel()/unlock_kernel() statements helps as well.
> 
> Interesting.  Do you have preemption enabled?

Yes, CONFIG_PREEMPT is active in my test system's kernel.

> Can you share the test program with us?

You can get it along with the actual cryptodev-implementation at
http://repo.or.cz/w/cryptodev-linux.git. I've been testing with speed.c
and async_speed.c, both can be found inside the examples directory.

Greetings, Phil
