From: Raj Ammanur <rammanur@arista.com>
Subject: Re: [PATCH] crypto: aesni-intel - avoid IPsec re-ordering
Date: Tue, 19 Jan 2016 09:39:51 -0800
Message-ID: <CAMFBXfkgjTtBX4sePTr30WenzDgw=h0yp8fp17de=ao+8AT=Mg@mail.gmail.com>
References: <CAMFBXfk=u_QYTdz0+P1WoNwuGN1xBaw0Ff2Y_XvLdQnKTasOcw@mail.gmail.com>
	<20160119074343.GA7753@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35263 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbcASRjx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jan 2016 12:39:53 -0500
Received: by mail-wm0-f51.google.com with SMTP id r129so100156326wmr.0
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jan 2016 09:39:53 -0800 (PST)
In-Reply-To: <20160119074343.GA7753@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks a bunch Herbert. I will try out the patch when you make it available.


Are there any thoughts for these other questions from you or anyone
else on the list, more
importantly regarding backlog handling in ESP ?


2. When the pkts are put on the async work queue, the queue size is initialized
as 100 in cryptd_init_queue() in crypto/cryptd.c. Does anyone know how/why
100 was picked ?

3. In cryptd_queue_worker(), the backlog->complete() callback is invoked with
-EINPROGRESS. In net/ipv4/esp4.c, there is no handling for EINPROGRESS
in esp_input_done()/esp_input_done2(). Am I reading the code correctly and
is there any expectation that ESP should support backlog and have backlog
handling ? Currently, the pkt just gets dropped as the EINPROGRESS is treated
as nexthdr and hence is invalid.



On Mon, Jan 18, 2016 at 11:43 PM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> Raj Ammanur <rammanur@arista.com> wrote:
>>
>> First, I would like to report that we are also seeing problem where IPSec
>> packets are getting queued up to the workqueue for async processing because
>> of the FPU not being available. Since there are also a lot of input pkts, by the
>> time xfrm_input() is invoked again after the async operation is completed, the
>> IPsec pkts are either out of sequence or out of the replay window, since the
>> replay window has advanced. We are using IPSec tunnel between two
>> switches connected over a Long Fat Network and have sender and receiver
>> servers connected to the two ends of the tunnel. Because of  the TCP
>> receiver receiving  pkts either out of order or not receiving pkts because of
>> dropped pkts, this is causing significant drop in TCP throughtput on Long Fat
>> Networks, where  the network latency is high.
>
> Thanks for the reminder.  I will try to post a patch for this soon.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
