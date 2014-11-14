From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 01/16] crypto: caam - Remove unnecessary
 smp_read_barrier_depends()
Date: Thu, 13 Nov 2014 18:58:21 -0600
Message-ID: <20141113185821.2d40f2decabaa7fac13cb816@freescale.com>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
	<1415906662-4576-2-git-send-email-bobby.prani@gmail.com>
	<20141113201001.GQ4460@linux.vnet.ibm.com>	<546527D0.9040806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <paulmck@linux.vnet.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Horia Geanta <horia.geanta@freescale.com>,
	Michael Neuling <mikey@neuling.org>,
	"Wolfram Sang" <wsa@the-dreams.de>,
	Cristian Stoica <cristian.stoica@freescale.com>, open list:
	CRYPTO API <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>, ;
To: Pranith Kumar <bobby.prani@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0105.outbound.protection.outlook.com ([65.55.169.105]:46708
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934582AbaKNBDm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Nov 2014 20:03:42 -0500
In-Reply-To: <546527D0.9040806@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 13 Nov 2014 16:51:12 -0500
Pranith Kumar <bobby.prani@gmail.com> wrote:

> On 11/13/2014 03:10 PM, Paul E. McKenney wrote:
> > On Thu, Nov 13, 2014 at 02:24:07PM -0500, Pranith Kumar wrote:
> >> Recently lockless_dereference() was added which can be used in place of
> >> hard-coding smp_read_barrier_depends(). The following PATCH makes the change.
> >>
> >> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> >> ---
> >>  drivers/crypto/caam/jr.c | 3 ---
> >>  1 file changed, 3 deletions(-)
> >>
> >> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> >> index bae20d8..9b3ef1bc 100644
> >> --- a/drivers/crypto/caam/jr.c
> >> +++ b/drivers/crypto/caam/jr.c
> >> @@ -181,8 +181,6 @@ static void caam_jr_dequeue(unsigned long devarg)
> >>  		for (i = 0; CIRC_CNT(head, tail + i, JOBR_DEPTH) >= 1; i++) {
> >>  			sw_idx = (tail + i) & (JOBR_DEPTH - 1);
> >>
> >> -			smp_read_barrier_depends();
> >> -
> > 
> > Did you mean to add a lockless_dereference() somewhere?  I would guess
> > that one is required on the load into sw_idx before the "for" loop,
> > but I cannot claim to be familiar with this code.
> 
> No, I could not understand why the barrier was here in the first place. The change log does not reflect the subject line.
> 
> sw_idx is a local variable and is used to index the entinfo array. It does not seem like the barrier is needed. If not a comment saying why could be added I guess.

I likely misinterpreted the "read index before reading contents at
that index" instructions in early circular buffer documentation, and
left it in for the benefit of the doubt.  Now it looks to me it's not
necessary, given both sw_idx and tail are just being computed within
a lock, and removing both barriers doesn't affect the compiler
output, so:

Reviewed-by: Kim Phillips <kim.phillips@freescale.com>

Thanks,

Kim
