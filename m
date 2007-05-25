From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 25 May 2007 14:20:37 +0400
Message-ID: <20070525102035.GA10069@2ka.mipt.ru>
References: <20070522125828.GB8424@2ka.mipt.ru> <20070525081417.GA26691@gondor.apana.org.au> <20070525085509.GA3808@2ka.mipt.ru> <20070525093532.GA29422@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:46128 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbXEYKUr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2007 06:20:47 -0400
Received: from 2ka.mipt.ru (localhost [127.0.0.1])
	by 2ka.mipt.ru (8.13.8/8.13.8) with ESMTP id l4PAKcYU006937
	for <linux-crypto@vger.kernel.org>; Fri, 25 May 2007 14:20:40 +0400
Received: (from johnpol@localhost)
	by 2ka.mipt.ru (8.13.8/8.12.1/Submit) id l4PAKcqH006936
	for linux-crypto@vger.kernel.org; Fri, 25 May 2007 14:20:38 +0400
Content-Disposition: inline
In-Reply-To: <20070525093532.GA29422@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, May 25, 2007 at 11:35:32AM +0200, Sebastian Siewior (linux-crypto@ml.breakpoint.cc) wrote:
> * Evgeniy Polyakov | 2007-05-25 12:55:10 [+0400]:
> 
> >Well, it is just hardware queue increase, so essentially for correct
> >work it should return -EBUSY in case driver does not accept requests
> >anymore (no matter if they are pushed into hardware or linked into
> >backlog queue). According to sleeping with CRYPTO_TFM_REQ_MAY_BACKLOG -
> >what about ipsec, where it is not allowed to sleep?
> 
> Can't you the drop packet than and hope further packets will arrive
> slowly or is the packet allready ACKed and you are not allowed to lose
> it?

It is quite normal to lose packets in network stack - NIC's queue is
limited too and hardware can drop packets whatever it likes.
TCP will just retransmit the packet, and no one cares about UDP.

In case of dm-crypt situation is different - first, it sets may-sleep
flag, which basically means that it can not fail. But if it fails, block
io request is completed with -EIO error.
Essentially this will be dropped down to bio_end_io, which does not get
into account error, but checks if bio is uptodate, appropriate bit is
not set when bio is completed with error.

So, dm-crypt will fail and will not try to process that block again, 
if crypto returns error. In acrypto I put a queue length as parameter 
to crypto device (crypto_alg in cryptoapi) structure, and acrypto 
load balancer always selected device which does have a space in the 
queue. I think something similar should be created for cryptoapi, so 
that even if device has higher prio it should not be selected until 
there is a place in its queue. Software implementation has infinite 
queue of course. In such case we do not need to have backlog queue,
which can be overflown too.

> Sebastian

-- 
	Evgeniy Polyakov
