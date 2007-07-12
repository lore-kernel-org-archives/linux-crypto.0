From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC 1/2] SPU-AES support (kernel side)
Date: Thu, 12 Jul 2007 12:16:08 +0200
Message-ID: <20070712101608.GC24117@Chamillionaire.breakpoint.cc>
References: <20070712073716.GB23840@Chamillionaire.breakpoint.cc> <E1I8teV-0005Ch-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60561 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673AbXGLKQK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Jul 2007 06:16:10 -0400
Content-Disposition: inline
In-Reply-To: <E1I8teV-0005Ch-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-07-12 16:03:55 [+0800]:

>Sebastian Siewior <bigeasy@breakpoint.cc> wrote:
>>
>> Limit means you want me to drop requests after a certain limit (i.e.
>> when my queue is full)?
>
>Yep, there's no point in holding onto lots of requests if the
>hardware simply can't catch up.
Makes sense.

>> I would have to start an extra thread that removes requests from
>> crypto_enqueue_request and enqueues them into kspu_enqueue_work_item.
>
>I'm probably missing something but why couldn't you pull the requests
>from crypto_enqueue_request in the same place where you pull requests
>currently? In other words couldn't you just pull both queues?

I used your crypto_enqueue_request in first place and decided against
because it got a little too complex for me:
If I enqueue directly on a SPU from crypto_enqueue_request than it
means that every non-process context user must implement a thread for
doing this. Additionally I must add locks to ensure that two different
users are not writing requests at the same time. After the request has
been written to the SPU I have to start the SPU (kick off a thread).
And now little more complex. Before the SPU can be switched on, I must
make sure that atleast a specific amout of requests is in queue and fill
up if necessary (here is allready my second user). For doing this I must
hold the same locks (same like for enqueue on SPU) so I must either
unlock them and regain the locks again or duplicate some code.
Right now, all the implementation specific details are taken care of my
KSPU implementation. There are no locks required (except that one SPU
specifc lock which must be hold anyway) because KSPU is the only part of
the code that may write the requests. Once the request is written to
the SPU, the SPU can be started immediately (if it is not running
allready what is known).

>Cheers,

Cheers,
Sebastian
