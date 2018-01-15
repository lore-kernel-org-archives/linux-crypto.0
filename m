From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [RFC] AF_ALG AIO and IV
Date: Mon, 15 Jan 2018 14:42:58 +0000
Message-ID: <20180115144258.00002dbe@huawei.com>
References: <2118226.LQArbCsRu5@tauon.chronox.de>
        <2894022.U2pY25BtWW@tauon.chronox.de>
        <20180115142538.00007d3d@huawei.com>
        <9541120.PIfOYyT9eV@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <harsh@chelsio.com>,
        <linuxarm@huawei.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4201 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933300AbeAOOne (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jan 2018 09:43:34 -0500
In-Reply-To: <9541120.PIfOYyT9eV@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 15 Jan 2018 15:31:42 +0100
Stephan Mueller <smueller@chronox.de> wrote:

> Am Montag, 15. Januar 2018, 15:25:38 CET schrieb Jonathan Cameron:
> 
> Hi Jonathan,
> 
> > On Mon, 15 Jan 2018 14:15:42 +0100
> > 
> > Stephan Mueller <smueller@chronox.de> wrote:  
> > > Am Montag, 15. Januar 2018, 13:59:27 CET schrieb Jonathan Cameron:
> > > 
> > > Hi Jonathan,
> > >   
> > > > > But there may be hardware that cannot/will not track such
> > > > > dependencies.
> > > > > Yet, it has multiple hardware queues. Such hardware can still handle
> > > > > parallel requests when they are totally independent from each other.
> > > > > For
> > > > > such a case, AF_ALG currently has no support, because it lacks the
> > > > > support for setting multiple IVs for the multiple concurrent calls.  
> > > > 
> > > > Agreed, something like your new support is needed - I just suspect we
> > > > need
> > > > a level between one socket one iv chain and every IOCB with own IV and
> > > > right now the only way to hit that balance is to have a separate socket
> > > > for each IV chain.  Not exactly efficient use of resources though it
> > > > will
> > > > work.  
> > > 
> > > How would you propose such support via AF_ALG?
> > > Wouldn't it be possible to
> > > arrange the IOVEC array in user space appropriately before calling the
> > > AF_ALG interface? In this case, I would still see that the current AF_ALG
> > > (plus the patch) would support all use cases I am aware of.  
> > 
> > I'm not sure how that would work, but maybe I'm missing something - are you
> > suggesting we could contrive the situation where the kernel side can tell
> > it is getting the same IV multiple times and hence know that it should chain
> > it?  We are talking streaming here - we don't have the data for the later
> > elements when the first ones are queued up.
> > 
> > One approach to handling token based IV - where the token refers to an IV
> > without being it's value would be to add another flag similar to the one
> > you used for inline IV.  
> 
> What about:
> 
> sendmsg(IV, data)
> sendmsg(data)
> ..
> AIO recvmsg with multiple IOCBs
> AIO recvmsg with multiple IOCBs
> ..
> sendmsg(IV, data)
> ..
> 
> This implies, however, that before the sendmsg with the second IV is sent, all 
> AIO operations from the first invocation would need to be finished.

Yes that works fine, but rather restricts the flow - you would end up waiting
until you could concatenate a bunch of data in userspace so as to trade
off against the slow down whenever you need to synchronize back up to userspace.

> > 
> > You would then set the IV as you have done, but also provide a magic value
> > by which to track the chain.  Later IOCBs using the same IV chain would
> > just provide the magic token.
> > 
> > You'd also need some way of retiring the IV eventually once you were done
> > with it or ultimately you would run out of resources.  
> 
> Let me think about that approach a bit.
> 
> > > 
> > > What AF_ALG should do is to enable different vendors like yourself to use
> > > the most appropriate solution. AF_ALG shall not limit users in any way.  
> > Agreed, but we also need to have some consistency for userspace to have some
> > awareness of what it should be using.  Last thing we want is lots of higher
> > level software having to have knowledge of the encryption hardware
> > underneath. Hence I think we should keep the options to the minimum
> > possible or put the burden on drivers that must play well with all options
> > (be it not as efficiently for the ones that work badly for them).
> >   
> > > Thus, AF_ALG allows multiple sockets, if desired. It allows a stream usage
> > > with one setiv call applicable to multiple cipher operations. And with the
> > > offered patch it would allow multiple concurrent and yet independent
> > > cipher
> > > operations. Whichever use case is right for you, AF_ALG should not block
> > > you from applying it. Yet, what is good for you may not be good for
> > > others. Thus, these others may implement a different usage strategy for
> > > AF_ALG. The good thing is that this strategy is defined by user space.
> > > 
> > > In case you see a use case that is prevented by AF_ALG, it would be great
> > > to hear about it to see whether we can support it.  
> > 
> > The usecase isn't blocked, but if you have hardware that is doing the IV
> > management then it is not efficiently handled.  Either
> > 1) You move the chaining up to userspace - throughput on a given chain will
> >    be awful - basically all the advantages of AIO are gone - fine if you
> > know you only care about bandwidth with lots of separate IV chains.  
> 
> This sounds not like the right path.
> > 
> > 2) You open a socket per IV chain and eat resources.  
> 
> Ok, AF_ALG allows this.

That was my plan before this discussion started.  Ugly but works without
any AF_ALG changes.

We can probably play some internal games to make this not as bad as it
initially seems, but still not nice.

Jonathan
> > 
> > Jonathan
> >   
> > > Ciao
> > > Stephan  
> 
> 
> 
> Ciao
> Stephan
> 
> 
