From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 3/4] DRBG: Fix format string for debugging statements
Date: Fri, 04 Jul 2014 09:57:20 -0700
Message-ID: <1404493040.6384.21.camel@joe-AO725>
References: <4927386.WYHrRe3NJm@myon.chronox.de>
	 <10901956.0EDQunEZJL@myon.chronox.de>
	 <20140629122402.0fd014d8@canb.auug.org.au>
	 <4311965.FMe9YfRAnU@myon.chronox.de> <1404013999.9064.50.camel@joe-AO725>
	 <20140704112116.GC25934@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
	linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0205.hostedemail.com ([216.40.44.205]:53877 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752622AbaGDQ5Z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Jul 2014 12:57:25 -0400
In-Reply-To: <20140704112116.GC25934@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2014-07-04 at 14:21 +0300, Dan Carpenter wrote:
> On Sat, Jun 28, 2014 at 08:53:19PM -0700, Joe Perches wrote:
> > On Sun, 2014-06-29 at 05:46 +0200, Stephan Mueller wrote:
> > > Am Sonntag, 29. Juni 2014, 12:24:02 schrieb Stephen Rothwell:
> > > 
> > > Hi Stephen,
> > > 
> > > > Hi Stephan,
> > > > 
> > > > On Sat, 28 Jun 2014 22:01:46 +0200 Stephan Mueller <smueller@chronox.de> 
> > > wrote:
> > > > > @@ -1987,8 +1987,9 @@ static int __init drbg_init(void)
> > > > > 
> > > > >  	if (ARRAY_SIZE(drbg_cores) * 2 > ARRAY_SIZE(drbg_algs)) {
> > > > >  	
> > > > >  		pr_info("DRBG: Cannot register all DRBG types"
> > > > > 
> > > > > -			"(slots needed: %lu, slots available: %lu)\n",
> > > > > -			ARRAY_SIZE(drbg_cores) * 2, ARRAY_SIZE(drbg_algs));
> > > > > +			"(slots needed: %u, slots available: %u)\n",
> > > > > +			(unsigned int)ARRAY_SIZE(drbg_cores) * 2,
> > > > > +			(unsigned int)ARRAY_SIZE(drbg_algs));
> > > > 
> > > > Doesn't ARRAY_SIZE() always return a size_t?  In which case surely we
> > > > need no casts, but need to us %zu in the format string.
> > > 
> > > Unfortunately not at all. On my x86_64, I get the compiler warning that 
> > > ARRAY_SIZE is a long unsigned int without the cast.

It doesn't seem to for 4.8.
Is there some specific gcc version where this occurs?

> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
[]
> > -#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
> > +#define ARRAY_SIZE(arr)						\
> > +	(sizeof(arr) / sizeof((arr)[0]) + (size_t)__must_be_array(arr))
> 
> 
> This change is a no-op isn't it?

Yes, it is.  Dumb idea.
Assuming there's some odd promotion, size_t should have been around the
whole thing
#define ARRAY_SIZE(arr)						\
	((size_t)((sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr)))

> I think Stephen Rothwell's suggestion
> is correct.  In linux-next this was changed to %lu which also works...
> 
> Are there arches %zu and %lu are different?

I get the same output types and error warnings compiling this
either -m32 or -m64

#include <stdio.h>
#include <stdlib.h>

#define typecheck(type, x)			\
({						\
	type __dummy;				\
	typeof(x) __dummy2;			\
	(void)(&__dummy == &__dummy2);		\
	1;					\
})

#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))

#define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
#define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))

int main(int argc, char **argv)
{
	char foo[100];
	size_t array = sizeof(foo);
	typeof (ARRAY_SIZE(foo)) member = ARRAY_SIZE(foo);

	int member1 = ARRAY_SIZE(foo);
	size_t member2 = ARRAY_SIZE(foo);

	typecheck(size_t, member);
	typecheck(int, member);

	typecheck(size_t, member1);
	typecheck(int, member1);

	typecheck(size_t, member2);
	typecheck(int, member2);

	printf("array: %zu, member: %zu\n", array, (int)member);

	return 0;
}
