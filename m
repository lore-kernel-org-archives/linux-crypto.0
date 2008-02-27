From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.25 patch] drivers/crypto/hifn_795x.c: fix 64bit division
Date: Tue, 26 Feb 2008 16:04:39 -0800
Message-ID: <20080226160439.5941cc31.akpm@linux-foundation.org>
References: <20080226122100.GB22699@deprecation.cyrius.com>
	<20080226153421.GB10717@cs181133002.pp.htv.fi>
	<20080226185240.GA2521@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Adrian Bunk <bunk@kernel.org>, Martin Michlmayr <tbm@cyrius.com>,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ralf Baechle <ralf@linux-mips.org>,
	linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541AbYB0AKi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Feb 2008 19:10:38 -0500
In-Reply-To: <20080226185240.GA2521@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 26 Feb 2008 21:52:40 +0300 Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> Hi Adrian.
> 
> On Tue, Feb 26, 2008 at 05:34:21PM +0200, Adrian Bunk (bunk@kernel.org) wrote:
> > Using ndelay() with a 64bit variable as parameter can result in build 
> > errors like the following on some 32bit systems when it results in a 
> > 64bit division:
> > 
> > <--  snip  -->
> > 
> >  ...
> >   MODPOST 759 modules
> > ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
> > 
> > <--  snip  -->
> > 
> > Reported by Martin Michlmayr.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Yep, ndelay() uses division, thanks a lot Adrian for spotting this.

hm.  Where?

> Herbert, please apply.
> 
> ACK.

udelay() might be exposed to the same problem.  It would be better to fix
ndelay() and udelay() rather than callers.  It is reasonable to pass a u64
into ndelay() and to expect the build to not explode.

(Geeze macros suck)
