From: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in  sha1_update()
Date: Fri, 26 Feb 2010 16:46:34 +0100
Message-ID: <19335.60634.75667.480609@pilspetsen.it.uu.se>
References: <4B8692E3.9030509@gmail.com>
	<20100225.071759.98314060.davem@davemloft.net>
	<25e057c01002250731q68bb9e28ld009163f2a009f48@mail.gmail.com>
	<87sk8oqkil.fsf@basil.nowhere.org>
	<19335.55478.733896.68829@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <andi@firstfloor.org>,
	roel kluin <roel.kluin@gmail.com>,
	David Miller <davem@davemloft.net>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
To: Mikael Pettersson <mikpe@it.uu.se>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fanny.its.uu.se ([130.238.4.241]:55477 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965085Ab0BZPqq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Feb 2010 10:46:46 -0500
In-Reply-To: <19335.55478.733896.68829@pilspetsen.it.uu.se>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mikael Pettersson writes:
 > Andi Kleen writes:
 >  > roel kluin <roel.kluin@gmail.com> writes:
 >  > 
 >  > >> And it's wrong because the reason the memset() is there seems to be
 >  > >> to clear out key information that might exist kernel stack so that
 >  > >> it's more difficult for rogue code to get at things.
 >  > >
 >  > > If the memset is optimized away then the clear out does not occur. Do you
 >  > > know a different way to fix this? I observed this with:
 >  > 
 >  > You could always cast to volatile before memsetting?
 > 
 > I tried that and it doesn't work. Furthermore passing a volatile void *
 > to a function expecting a void * provokes a compiler warning.
 > 
 > I currently think that defining and using
 > 
 > void secure_bzero(void *p, size_t n)
 > {
 > 	memset(p, 0, n);
 > 	/* We need for this memset() to be performed even if *p
 > 	 * is about to disappear (a local auto variable going out
 > 	 * of scope or some dynamic memory being kfreed()).
 > 	 * Thus we need to fake a "use" of *p here.
 > 	 * barrier() achieves that effect, and much more.
 > 	 * TODO: find a better alternative to barrier() here.
 > 	 */
 > 	barrier();

Instead of barrier(), this works with gcc-3.2.3 up to gcc-4.4.3
for the purpose of making the memset() not disappear:

	{
		struct s { char c[n]; };
		asm("" : : "m"(*(struct s *)p));
	}

Every byte in the [p,p+n[ range must be used. If you only use the
first byte, via e.g. asm("" :: "m"(*(char*)p)), then the compiler
_will_ skip scrubbing bytes beyond the first.

An explicit loop that uses each byte individually also works, but
results in awful code with older compilers.

 > }
