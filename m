From: Raj Ammanur <rammanur@arista.com>
Subject: Re: [PATCH] crypto: aesni-intel - avoid IPsec re-ordering
Date: Mon, 18 Jan 2016 23:26:04 -0800
Message-ID: <CAMFBXfk=u_QYTdz0+P1WoNwuGN1xBaw0Ff2Y_XvLdQnKTasOcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:33019 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbcASH0G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jan 2016 02:26:06 -0500
Received: by mail-wm0-f49.google.com with SMTP id 123so79219680wmz.0
        for <linux-crypto@vger.kernel.org>; Mon, 18 Jan 2016 23:26:05 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi

I just signed up on this list a few days ago and couldn't find a way to do a
reply on the original thread. Apologies in advance, if this ends up creating
a new thread, I just created a new mail with same subject and last message
on this thread as a reply.

First, I would like to report that we are also seeing problem where IPSec
packets are getting queued up to the workqueue for async processing because
of the FPU not being available. Since there are also a lot of input pkts, by the
time xfrm_input() is invoked again after the async operation is completed, the
IPsec pkts are either out of sequence or out of the replay window, since the
replay window has advanced. We are using IPSec tunnel between two
switches connected over a Long Fat Network and have sender and receiver
servers connected to the two ends of the tunnel. Because of  the TCP
receiver receiving  pkts either out of order or not receiving pkts because of
dropped pkts, this is causing significant drop in TCP throughtput on Long Fat
Networks, where  the network latency is high.

I have a few questions.

1. I see that patch was submitted and modifications suggested. Since then, I
don't see an update on the thread in the archives. Is there a latest
patch available
for the problem reported originally on this issue ? If so, I would
like to try it.

2. When the pkts are put on the async work queue, the queue size is initialized
as 100 in cryptd_init_queue() in crypto/cryptd.c. Does anyone know how/why
100 was picked ?

3. In cryptd_queue_worker(), the backlog->complete() callback is invoked with
-EINPROGRESS. In net/ipv4/esp4.c, there is no handling for EINPROGRESS
in esp_input_done()/esp_input_done2(). Am I reading the code correctly and
is there any expectation that ESP should support backlog and have backlog
handling ? Currently, the pkt just gets dropped as the EINPROGRESS is treated
as nexthdr and hence is invalid.

Thanks in advance,
--Raj



> Herbert Xu <herbert <at> gondor.apana.org.au> writes:
>
> >
> > On Thu, Nov 20, 2014 at 08:59:44AM +0100, Steffen Klassert wrote:
> > >
> > > Sure, but could be an option if this is really a rare case.
> >
> > Well it's rare but when it does hit it'll probably be there all
> > the time for that system.  IOW you either have no apps using the
> > FPU, but when you do, it's probably going to be hogging it.
> >
> > > Anyway, I don't mind too much about the solution as long as we
> > > get it to work :)
> >
> > :)
> >
> > Cheers,
>
>
> Hi Herbert
>
> Is there an official "blessed" patch for this re-ordering problem?
> I saw some issues raised in the thread with the patch that Ming Liu had
> provided?
>
> Thanks
> -sunderam
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@xxxxxxxxxxxxxxx
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
