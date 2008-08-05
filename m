From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API -V2.
Date: Tue, 5 Aug 2008 16:04:08 +0300
Message-ID: <20080805130408.GD25371@cs181140183.pp.htv.fi>
References: <1217937403.3641.8.camel@localhost.localdomain> <20080805123944.GA22680@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Austin Zhang <austin_zhang@linux.intel.com>, dwmw2@infradead.org,
	davem@davemloft.net, randy.dunlap@oracle.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:47585 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760224AbYHENas (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Aug 2008 09:30:48 -0400
Content-Disposition: inline
In-Reply-To: <20080805123944.GA22680@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 05, 2008 at 08:39:44PM +0800, Herbert Xu wrote:
> Hi Austin:
> 
> On Tue, Aug 05, 2008 at 07:56:43AM -0400, Austin Zhang wrote:
> > Revised by comments:
> > Move hardware feature detect into module init;
> > Revise dependency in Kconfig;
> > Revise variable type;
> > Add information output while module loading failed; 
> >  
> > 
> > >From NHM processor onward, Intel processors can support hardware
> > accelerated
> > CRC32c algorithm with the new CRC32 instruction in SSE 4.2 instruction
> > set.
> > The patch detects the availability of the feature, and chooses the most
> > proper
> > way to calculate CRC32c checksum.
> > Byte code instructions are used for compiler compatibility.
> > No MMX / XMM registers is involved in the implementation.
> > 
> > Signed-off-by: Austin Zhang <austin.zhang@intel.com>
> > Signed-off-by: Kent Liu <kent.liu@intel.com>
> 
> I tried to apply your patch but it doesn't work:
> 
> $ git apply --check --whitespace=error-all ~/p
> fatal: patch fragment without header at line 34: @@ -0,0 +1,190 @@
> $
> 
> Looks like your mail client has folded all the lines.
>...

Documentation/email-clients.txt contains a section explaining what to do 
in Evolution.

> And here.
> 
> Thanks,

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

