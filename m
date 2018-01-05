From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: INFO: task hung in aead_recvmsg
Date: Fri, 5 Jan 2018 13:35:55 -0800
Message-ID: <20180105213555.GC44929@gmail.com>
References: <001a1140b8307b0439055ffc7872@google.com>
 <CACT4Y+bgQ02e2=A0HpsRQbC6RFRi8N+GvhYfmCg+EuAXHHafxA@mail.gmail.com>
 <20171223202942.GB10162@zzz.localdomain>
 <20171230083744.vuclnbs677tj7pi2@gauss3.secunet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Vyukov <dvyukov@google.com>,
        syzbot
        <bot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        syzkaller-bugs@googlegroups.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:43921 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753131AbeAEVf7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jan 2018 16:35:59 -0500
Content-Disposition: inline
In-Reply-To: <20171230083744.vuclnbs677tj7pi2@gauss3.secunet.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 30, 2017 at 09:37:44AM +0100, Steffen Klassert wrote:
> On Sat, Dec 23, 2017 at 02:29:42PM -0600, Eric Biggers wrote:
> > [+Cc Steffen Klassert <steffen.klassert@secunet.com>]
> > 
> > 
> > I was able to reproduce this by trying to use 'pcrypt' recursively.  I am not
> > 100% sure it is the exact same bug, but it probably is.  Here is a C reproducer:
> > 
> > 	#include <linux/if_alg.h>
> > 	#include <sys/socket.h>
> > 	#include <unistd.h>
> > 
> > 	int main()
> > 	{
> > 		struct sockaddr_alg addr = {
> > 			.salg_type = "aead",
> > 			.salg_name = "pcrypt(pcrypt(rfc4106-gcm-aesni))",
> > 		};
> > 		int algfd, reqfd;
> > 		char buf[32] = { 0 };
> > 
> > 		algfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
> > 		bind(algfd, (void *)&addr, sizeof(addr));
> > 		setsockopt(algfd, SOL_ALG, ALG_SET_KEY, buf, 20);
> > 
> > 		reqfd = accept(algfd, 0, 0);
> > 		write(reqfd, buf, 32);
> > 		read(reqfd, buf, 16);
> > 	}
> > 
> > It seems the problem is that all 'pcrypt' instances use the same
> > 'padata_instance', which completes works in the order they are submitted.  But
> > with nested use, the outer work is submitted before the inner work, so the inner
> > work isn't allowed to complete until the outer work does, which deadlocks
> > because actually the inner work needs to complete first.
> > 
> > What a mess.  Maybe there should be a separate 'padata_instance' per pcrypt
> > instance?  Or maybe there should be a way for an algorithm to declare that it
> > can only appear in the stack one time?  
> 
> Having two nested pcrypt templates in one algorithm instance
> does not make so much sense in the first place. I thought
> that the crypto layer would refuse to build an instance
> with two nested templates of the same type.
> 
> At least for pcrypt, refusing such instantiations would
> be the correct behaviour. Are there any other templates
> where a nested use would make sense?

Maybe.  But either way, I don't see a straightforward way to prevent it
currently.  In particular, the links from an instance to its inner algorithms
are stored in the crypto_instance_ctx() which has a template-specific format, so
it isn't currently possible to recursively search an instance to check whether a
particular template is present.  We could perhaps add such links in a standard
format, though...

Eric
