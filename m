From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] add include/asm-avr32/xor.h
Date: Tue, 15 Apr 2008 01:01:29 +0300
Message-ID: <20080414220129.GH26885@cs181133002.pp.htv.fi>
References: <20080414141632.GA6695@cs181133002.pp.htv.fi> <20080414181140.GA813@Chamillionaire.breakpoint.cc> <20080414181536.GZ6695@cs181133002.pp.htv.fi> <20080414214640.GA2282@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: hskinnemoen@atmel.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, shannon.nelson@intel.com,
	dan.j.williams@intel.com
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:33004 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbYDNWCg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Apr 2008 18:02:36 -0400
Content-Disposition: inline
In-Reply-To: <20080414214640.GA2282@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 14, 2008 at 11:46:40PM +0200, Sebastian Siewior wrote:
> * Adrian Bunk | 2008-04-14 21:15:36 [+0300]:
> 
> >> >601f75e99c076c16e2648f4860cac4fc6ce187ea diff --git a/include/asm-avr32/xor.h b/include/asm-avr32/xor.h
> >> >new file mode 100644
> >> >index 0000000..99c87aa
> >> >--- /dev/null
> >> >+++ b/include/asm-avr32/xor.h
> >> >@@ -0,0 +1,6 @@
> >> >+#ifndef _ASM_XOR_H
> >> >+#define _ASM_XOR_H
> >> >+
> >> >+#include <asm-generic/xor.h>
> >> >+
> >> >+#endif
> >> 
> >> What about providing <linux/xor.h> which includes the right file from
> >> asm/ or asm-generic/ depending on HAVE_.* ?
> >
> >Where's the advantage?
> 
> This week you are going through avr32. The same fixup is required for
> blackfin or cris if my ls isn't lying.

Could be, these arre the two archs I did for different reasons not 
include when I tried allmodconfig on all archs.

> So either you fix every arch
> with this missing include or you provide a generic include and every
> arch that provides a private xor.h includes it. From what I can see
> almost every arch includes the generic except for x86 & sparc

You didn't see that the following architectures also have their own 
versions:
- alpha
- arm
- ia64
- sparc64

> so most
> xor.h files are identical copies and this is probably as bad as a
> trailing white space :)

I'm not sure whether it's worth spending my time discussing whether 
adding a config variable to 6 architectures is really better than
adding trivial headers to 3 architectures...

> Sebastian

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

