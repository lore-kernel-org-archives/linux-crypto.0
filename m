From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6.25 patch] drivers/crypto/hifn_795x.c: fix 64bit division
Date: Wed, 27 Feb 2008 08:22:07 +0200
Message-ID: <20080227062207.GB10603@cs181133002.pp.htv.fi>
References: <20080226122100.GB22699@deprecation.cyrius.com> <20080226153421.GB10717@cs181133002.pp.htv.fi> <20080226185240.GA2521@2ka.mipt.ru> <20080226160439.5941cc31.akpm@linux-foundation.org>
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
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33516 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbYB0GXP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Feb 2008 01:23:15 -0500
Content-Disposition: inline
In-Reply-To: <20080226160439.5941cc31.akpm@linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 26, 2008 at 04:04:39PM -0800, Andrew Morton wrote:
> On Tue, 26 Feb 2008 21:52:40 +0300 Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > Hi Adrian.
> > 
> > On Tue, Feb 26, 2008 at 05:34:21PM +0200, Adrian Bunk (bunk@kernel.org) wrote:
> > > Using ndelay() with a 64bit variable as parameter can result in build 
> > > errors like the following on some 32bit systems when it results in a 
> > > 64bit division:
> > > 
> > > <--  snip  -->
> > > 
> > >  ...
> > >   MODPOST 759 modules
> > > ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
> > > 
> > > <--  snip  -->
> > > 
> > > Reported by Martin Michlmayr.
> > > 
> > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > Yep, ndelay() uses division, thanks a lot Adrian for spotting this.
> 
> hm.  Where?
>...

include/linux/delay.h:35

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
