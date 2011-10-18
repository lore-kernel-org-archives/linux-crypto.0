From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] talitos: handle descriptor not found in error path
Date: Tue, 18 Oct 2011 11:17:00 -0500
Message-ID: <20111018111700.75b79365.kim.phillips@freescale.com>
References: <20110924191649.a42c86d2.kim.phillips@freescale.com>
	<20111018073613.GA13923@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <svens@stackframe.org>, <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:7577
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933002Ab1JRQRz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 12:17:55 -0400
In-Reply-To: <20111018073613.GA13923@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 18 Oct 2011 09:36:18 +0200
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Kim Phillips <kim.phillips@freescale.com> wrote:
> > The CDPR (Current Descriptor Pointer Register) can be unreliable
> > when trying to locate an offending descriptor.  Handle that case by
> > (a) not OOPSing, and (b) reverting to the machine internal copy of
> > the descriptor header in order to report the correct execution unit
> > error.
> > 
> > Note: printing all execution units' ISRs is not effective because it
> > results in an internal time out (ITO) error and the EU resetting its
> > ISR value (at least when specifying an invalid key length on an SEC
> > 2.2/MPC8313E).
> > 
> > Reported-by: Sven Schnelle <svens@stackframe.org>
> > Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> > ---
> > please test, as it seems I cannot reproduce the descriptor not found
> > case.
> 
> So what's the verdict Kim, should I take this patch or not?

sure - I've verified it does at least satisfy Sven's shouldn't-oops
comment.

btw, can you take a look at applying this also?:

http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg05996.html

It makes IPSec AH work for async crypto implementations.

Thanks,

Kim
