From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6.25 patch] drivers/crypto/hifn_795x.c: fix 64bit division
Date: Thu, 28 Feb 2008 10:02:44 +0200
Message-ID: <20080228080244.GA29269@cs181133002.pp.htv.fi>
References: <20080226122100.GB22699@deprecation.cyrius.com> <20080226153421.GB10717@cs181133002.pp.htv.fi> <20080226185240.GA2521@2ka.mipt.ru> <20080226160439.5941cc31.akpm@linux-foundation.org> <20080227062207.GB10603@cs181133002.pp.htv.fi> <20080226224719.6994a3bf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Martin Michlmayr <tbm@cyrius.com>,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ralf Baechle <ralf@linux-mips.org>,
	linux-crypto@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:41943 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759137AbYB1ID5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Feb 2008 03:03:57 -0500
Content-Disposition: inline
In-Reply-To: <20080226224719.6994a3bf.akpm@linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 26, 2008 at 10:47:19PM -0800, Andrew Morton wrote:
>...
> Something like this:

Generally agreed, but

> --- a/include/linux/delay.h~a
> +++ a/include/linux/delay.h
> @@ -7,10 +7,12 @@
>   * Delay routines, using a pre-computed "loops_per_jiffy" value.
>   */
>  
> -extern unsigned long loops_per_jiffy;
> +#include <linux/kernel.h>
>  
>  #include <asm/delay.h>
>  
> +extern unsigned long loops_per_jiffy;
> +
>...

this part of your patch breaks m68k:

<--  snip  -->

...
  CC      init/main.o
In file included from 
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/delay.h:12,
                 from 
/home/bunk/linux/kernel-2.6/git/linux-2.6/init/main.c:19:
include2/asm/delay.h: In function '__const_udelay':
include2/asm/delay.h:33: error: 'loops_per_jiffy' undeclared (first use in this function)
include2/asm/delay.h:33: error: (Each undeclared identifier is reported only once
include2/asm/delay.h:33: error: for each function it appears in.)
make[2]: *** [init/main.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
