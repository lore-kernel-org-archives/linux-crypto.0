From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [RFC] AF_ALG AIO and IV
Date: Mon, 15 Jan 2018 14:25:38 +0000
Message-ID: <20180115142538.00007d3d@huawei.com>
References: <2118226.LQArbCsRu5@tauon.chronox.de>
        <2353138.AYbjlSPjUL@tauon.chronox.de>
        <20180115125927.00007520@huawei.com>
        <2894022.U2pY25BtWW@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <harsh@chelsio.com>,
        <linuxarm@huawei.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:4225 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965498AbeAOO0S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jan 2018 09:26:18 -0500
In-Reply-To: <2894022.U2pY25BtWW@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 15 Jan 2018 14:15:42 +0100
Stephan Mueller <smueller@chronox.de> wrote:

> Am Montag, 15. Januar 2018, 13:59:27 CET schrieb Jonathan Cameron:
> 
> Hi Jonathan,
> > > 
> > > But there may be hardware that cannot/will not track such dependencies.
> > > Yet, it has multiple hardware queues. Such hardware can still handle
> > > parallel requests when they are totally independent from each other. For
> > > such a case, AF_ALG currently has no support, because it lacks the
> > > support for setting multiple IVs for the multiple concurrent calls.  
> > 
> > Agreed, something like your new support is needed - I just suspect we need
> > a level between one socket one iv chain and every IOCB with own IV and
> > right now the only way to hit that balance is to have a separate socket
> > for each IV chain.  Not exactly efficient use of resources though it will
> > work.  
> 
> How would you propose such support via AF_ALG? 
> Wouldn't it be possible to 
> arrange the IOVEC array in user space appropriately before calling the AF_ALG 
> interface? In this case, I would still see that the current AF_ALG (plus the 
> patch) would support all use cases I am aware of.

I'm not sure how that would work, but maybe I'm missing something - are you
suggesting we could contrive the situation where the kernel side can tell
it is getting the same IV multiple times and hence know that it should chain
it?  We are talking streaming here - we don't have the data for the
later elements when the first ones are queued up.

One approach to handling token based IV - where the token refers to an IV without
being it's value would be to add another flag similar to the one you used for
inline IV.

You would then set the IV as you have done, but also provide a magic value by
which to track the chain.  Later IOCBs using the same IV chain would just
provide the magic token.

You'd also need some way of retiring the IV eventually once you were done
with it or ultimately you would run out of resources.

> 
> > > > So the only one left is the case 3 above where the hardware is capable
> > > > of doing the dependency tracking.
> > > > 
> > > > We can support that in two ways but one is rather heavyweight in terms
> > > > of
> > > > resources.
> > > > 
> > > > 1) Whenever we want to allocate a new context we spin up a new socket
> > > > and
> > > > effectively associate a single IV with that (and it's chained updates)
> > > > much
> > > > like we do in the existing interface.  
> > > 
> > > I would not like that because it is too heavyweight. Moreover, considering
> > > the kernel crypto API logic, a socket is the user space equivalent of a
> > > TFM. I.e. for setting an IV, you do not need to re-instantiate a TFM.  
> > 
> > Agreed, though as I mention above if you have multiple processes you
> > probably want to give them their own resources anyway (own socket and
> > probably hardware queue if you can spare one) so as to avoid denial of
> > service from one to another.  
> 
> That is for sure, different processes shall never share a socket as otherwise 
> one can obtain data belonging to the other which would violate process 
> isolation.
> 
> > > > 2) We allow a token based tracking of IVs.  So userspace code maintains
> > > > a counter and tags ever message and the initial IV setup with that
> > > > counter.  
> > > 
> > > I think the option I offer with the patch, we have an even more
> > > lightweight
> > > approach.  
> > 
> > Except that I think you have to go all the way back to userspace - unless I
> > am missing the point - you can't have multiple elements of a stream queued
> > up. Performance will stink if you have a small number of contexts and can't
> > keep the processing engines busy.  At the moment option 1 here is the only
> > way to implement this.  
> 
> What AF_ALG should do is to enable different vendors like yourself to use the 
> most appropriate solution. AF_ALG shall not limit users in any way.

Agreed, but we also need to have some consistency for userspace to have some
awareness of what it should be using.  Last thing we want is lots of higher
level software having to have knowledge of the encryption hardware underneath.
Hence I think we should keep the options to the minimum possible or put the
burden on drivers that must play well with all options (be it not as efficiently
for the ones that work badly for them).

> 
> Thus, AF_ALG allows multiple sockets, if desired. It allows a stream usage 
> with one setiv call applicable to multiple cipher operations. And with the 
> offered patch it would allow multiple concurrent and yet independent cipher 
> operations. Whichever use case is right for you, AF_ALG should not block you 
> from applying it. Yet, what is good for you may not be good for others. Thus, 
> these others may implement a different usage strategy for AF_ALG. The good 
> thing is that this strategy is defined by user space.
> 
> In case you see a use case that is prevented by AF_ALG, it would be great to 
> hear about it to see whether we can support it.
> 

The usecase isn't blocked, but if you have hardware that is doing the IV
management then it is not efficiently handled.  Either
1) You move the chaining up to userspace - throughput on a given chain will
   be awful - basically all the advantages of AIO are gone - fine if you know
   you only care about bandwidth with lots of separate IV chains.

2) You open a socket per IV chain and eat resources.

Jonathan

> Ciao
> Stephan
> 
> 
