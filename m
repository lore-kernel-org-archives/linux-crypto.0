From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] crypto: fix error flow of crypto/testmgr.c:test_comp()
Date: Wed, 26 Nov 2008 03:40:32 +0100
Message-ID: <20081126024032.GA21259@elte.hu>
References: <20081125085820.GA11401@elte.hu> <20081125152014.GB29096@gondor.apana.org.au> <20081125171438.GK22504@elte.hu> <20081125.170851.97706149.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:36567 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbYKZCkw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Nov 2008 21:40:52 -0500
Content-Disposition: inline
In-Reply-To: <20081125.170851.97706149.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


* David Miller <davem@davemloft.net> wrote:

> >     fix warning in drivers/net/sky2.c
> >     fix warning in net/sunrpc/svcauth_unix.c
> >     fix warning in security/selinux/netnode.c
> >     fix warning in net/packet/af_packet.c
> >     fix warning in net/rfkill/rfkill.c
> 
> Not applied.  Changing this from a BUG() to a panic() is wrong. 
> BUG() kills the current execution context, and allows the system to 
> potentially continue.  Panic() takes down the entire machine.

Yeah, although in practice a BUG() in some of those places will take 
down the whole machine:

  > >     fix warning in net/packet/af_packet.c

That's packet receive path, holding spinlocks or in other atomic 
context (irq/softirq)? A BUG() will take down the machine as we will 
crash and try to schedule in atomic context.

> The !CONFIG_BUG BUG() definition should be marked in such a way that 
> gcc thinks it is noreturn.  Otherwise BUG() isn't really BUG() 
> anymore.  The other option is to never allow BUG to be disabled or 
> have it always evaluate to a simple bug trap.

Yeah, but note that that's exactly the current behavior (and intent) 
of !CONFIG_BUG: it is not doing anything (it's just an empty macro 
which returns!), and we get those build warnings because the control 
flow becomes undefined. We cannot mark it noreturn because it does 
return.

	Ingo
