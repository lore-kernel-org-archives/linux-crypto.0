From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 3/4] DRBG: Fix format string for debugging statements
Date: Sun, 29 Jun 2014 06:54:40 +0200
Message-ID: <1601229.MmpOW11t3g@myon.chronox.de>
References: <4927386.WYHrRe3NJm@myon.chronox.de> <4311965.FMe9YfRAnU@myon.chronox.de> <1404013999.9064.50.camel@joe-AO725>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:56864 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaF2Ezx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Jun 2014 00:55:53 -0400
Received: from myon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S222> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Sun, 29 Jun 2014 06:54:47 +0200
In-Reply-To: <1404013999.9064.50.camel@joe-AO725>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 28. Juni 2014, 20:53:19 schrieb Joe Perches:

Hi Joe,

> On Sun, 2014-06-29 at 05:46 +0200, Stephan Mueller wrote:
> > Am Sonntag, 29. Juni 2014, 12:24:02 schrieb Stephen Rothwell:
> > 
> > Hi Stephen,
> > 
> > > Hi Stephan,
> > > 
> > > On Sat, 28 Jun 2014 22:01:46 +0200 Stephan Mueller <smueller@chronox.de>
> > 
> > wrote:
> > > > @@ -1987,8 +1987,9 @@ static int __init drbg_init(void)
> > > > 
> > > >  	if (ARRAY_SIZE(drbg_cores) * 2 > ARRAY_SIZE(drbg_algs)) {
> > > >  	
> > > >  		pr_info("DRBG: Cannot register all DRBG types"
> > > > 
> > > > -			"(slots needed: %lu, slots available: %lu)\n",
> > > > -			ARRAY_SIZE(drbg_cores) * 2, 
ARRAY_SIZE(drbg_algs));
> > > > +			"(slots needed: %u, slots available: %u)\n",
> > > > +			(unsigned int)ARRAY_SIZE(drbg_cores) * 2,
> > > > +			(unsigned int)ARRAY_SIZE(drbg_algs));
> > > 
> > > Doesn't ARRAY_SIZE() always return a size_t?  In which case surely we
> > > need no casts, but need to us %zu in the format string.
> > 
> > Unfortunately not at all. On my x86_64, I get the compiler warning that
> > ARRAY_SIZE is a long unsigned int without the cast.
> 
> This should fix that.
> ---
>  include/linux/kernel.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 6e3d497..58bc57d 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -51,7 +51,8 @@
>  #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), 
(a)))
>  #define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
> 
> -#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
> __must_be_array(arr)) +#define ARRAY_SIZE(arr)				
		\
> +	(sizeof(arr) / sizeof((arr)[0]) + (size_t)__must_be_array(arr))
> 
>  /*
>   * This looks more complex than it should be. But we need to


Sure, that fixes it such that I need to use %zu in the format string.

But wouldn't that change have riple effects to all use cases of ARRAY_SIZE at 
least on 32 bit systems (i.e. current implementation returns a 32 bit integer, 
but the new version returns a 64 bit integer)? If so, I am wondering whether 
this change can be made with this oneliner.

Ciao
Stephan
-- 
| Cui bono? |
