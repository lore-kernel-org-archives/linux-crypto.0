From: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: Is kernel optimized with dead store removal?
Date: Thu, 25 Feb 2010 17:06:07 +0100
Message-ID: <19334.40943.479593.304961@pilspetsen.it.uu.se>
References: <4B85A49E.6000803@gmail.com>
	<19334.22971.970220.245930@pilspetsen.it.uu.se>
	<4B8693B9.3060102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Mikael Pettersson <mikpe@it.uu.se>,
	lkml <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fanny.its.uu.se ([130.238.4.241]:51762 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932559Ab0BYQGR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Feb 2010 11:06:17 -0500
In-Reply-To: <4B8693B9.3060102@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Roel Kluin writes:
 > 
 > >  >  Does this optimization also occur during compilation of the Linux
 > >  >  kernel?
 > 
 > > Any such dead store removal is up to the compiler and the lifetime
 > > of the object being clobbered. For 'auto' objects the optimization
 > > is certainly likely.
 > > 
 > > This is only a problem if the memory (a thread stack, say) is recycled
 > > and leaked uninitialized to user-space, but such bugs are squashed
 > > fairly quickly upon discovery.
 > 
 > Thanks for comments,
 > 
 > In the sha1_update() case I don't know whether the stack is recycled and
 > leaked - it may be dependent on the calling function, but isn't it
 > vulnerable?

It's only vulnerable if the data leaks to a less trusted domain.
There is no domain crossing in your user-space example.
In the kernel case, the domain crossing would be as I wrote: leaking
recycled and uninitialized memory to user-space (and those leaks of
uninitialized memory are frowned upon and quickly fixed when discovered).
