From: Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [RFC][PATCH] Pseudo-random number generator
Date: Fri, 08 Dec 2006 12:42:15 +0100
Message-ID: <1165578135.5343.15.camel@bender>
References: <1164979155.5882.23.camel@bender>
	 <200612071606.33951.arnd@arndb.de> <1165504796.5607.17.camel@bender>
	 <200612071943.14153.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:2646 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1425412AbWLHLnD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Dec 2006 06:43:03 -0500
To: Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <200612071943.14153.arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 2006-12-07 at 19:43 +0100, Arnd Bergmann wrote:
> On Thursday 07 December 2006 16:19, Jan Glauber wrote:
> > Hm, why is /dev/urandom implemented in the kernel?
> > 
> > It could be done completely in user-space (like libica already does)
> > but I think having a device node where you can read from is the simplest
> > implementation. Also, if we can solve the security flaw we could use it
> > as replacement for /dev/urandom.
> 
> urandom is more useful, because can't be implemented in user space at
> all. /dev/urandom will use the real randomness from the kernel as a seed
> without depleting the entropy pool. How does your /dev/prandom device
> compare to /dev/urandom performance-wise? If it can be made to use
> the same input data and it turns out to be significantly faster, I can
> see some use for it.

The performance of the PRNG without constantly adding entropy is up tp
factor 40 faster than /dev/urandom ;- , depending on the block size of
the read.

With the current patch it performs not so well because of the STCKE loop
before every KMC. I think about removing them and changing the
periodically seed to use get_random_bytes instead.

Jan
