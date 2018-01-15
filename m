From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC] AF_ALG AIO and IV
Date: Mon, 15 Jan 2018 14:15:42 +0100
Message-ID: <2894022.U2pY25BtWW@tauon.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <2353138.AYbjlSPjUL@tauon.chronox.de> <20180115125927.00007520@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, harsh@chelsio.com,
        linuxarm@huawei.com
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58292 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030453AbeAONPo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jan 2018 08:15:44 -0500
In-Reply-To: <20180115125927.00007520@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 15. Januar 2018, 13:59:27 CET schrieb Jonathan Cameron:

Hi Jonathan,
> > 
> > But there may be hardware that cannot/will not track such dependencies.
> > Yet, it has multiple hardware queues. Such hardware can still handle
> > parallel requests when they are totally independent from each other. For
> > such a case, AF_ALG currently has no support, because it lacks the
> > support for setting multiple IVs for the multiple concurrent calls.
> 
> Agreed, something like your new support is needed - I just suspect we need
> a level between one socket one iv chain and every IOCB with own IV and
> right now the only way to hit that balance is to have a separate socket
> for each IV chain.  Not exactly efficient use of resources though it will
> work.

How would you propose such support via AF_ALG? Wouldn't it be possible to 
arrange the IOVEC array in user space appropriately before calling the AF_ALG 
interface? In this case, I would still see that the current AF_ALG (plus the 
patch) would support all use cases I am aware of.

> > > So the only one left is the case 3 above where the hardware is capable
> > > of doing the dependency tracking.
> > > 
> > > We can support that in two ways but one is rather heavyweight in terms
> > > of
> > > resources.
> > > 
> > > 1) Whenever we want to allocate a new context we spin up a new socket
> > > and
> > > effectively associate a single IV with that (and it's chained updates)
> > > much
> > > like we do in the existing interface.
> > 
> > I would not like that because it is too heavyweight. Moreover, considering
> > the kernel crypto API logic, a socket is the user space equivalent of a
> > TFM. I.e. for setting an IV, you do not need to re-instantiate a TFM.
> 
> Agreed, though as I mention above if you have multiple processes you
> probably want to give them their own resources anyway (own socket and
> probably hardware queue if you can spare one) so as to avoid denial of
> service from one to another.

That is for sure, different processes shall never share a socket as otherwise 
one can obtain data belonging to the other which would violate process 
isolation.

> > > 2) We allow a token based tracking of IVs.  So userspace code maintains
> > > a counter and tags ever message and the initial IV setup with that
> > > counter.
> > 
> > I think the option I offer with the patch, we have an even more
> > lightweight
> > approach.
> 
> Except that I think you have to go all the way back to userspace - unless I
> am missing the point - you can't have multiple elements of a stream queued
> up. Performance will stink if you have a small number of contexts and can't
> keep the processing engines busy.  At the moment option 1 here is the only
> way to implement this.

What AF_ALG should do is to enable different vendors like yourself to use the 
most appropriate solution. AF_ALG shall not limit users in any way.

Thus, AF_ALG allows multiple sockets, if desired. It allows a stream usage 
with one setiv call applicable to multiple cipher operations. And with the 
offered patch it would allow multiple concurrent and yet independent cipher 
operations. Whichever use case is right for you, AF_ALG should not block you 
from applying it. Yet, what is good for you may not be good for others. Thus, 
these others may implement a different usage strategy for AF_ALG. The good 
thing is that this strategy is defined by user space.

In case you see a use case that is prevented by AF_ALG, it would be great to 
hear about it to see whether we can support it.

Ciao
Stephan
