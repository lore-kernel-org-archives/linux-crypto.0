From: Raj Ammanur <rammanur@arista.com>
Subject: Re: [PATCH] crypto: aesni-intel - avoid IPsec re-ordering
Date: Wed, 20 Jan 2016 00:31:46 -0800
Message-ID: <CAMFBXfkS_maZVwpEcUF+gUU9Q74tKKcxFiS+Oe3FBXnrrxyFAA@mail.gmail.com>
References: <CAMFBXfk=u_QYTdz0+P1WoNwuGN1xBaw0Ff2Y_XvLdQnKTasOcw@mail.gmail.com>
	<20160119074343.GA7753@gondor.apana.org.au>
	<CAMFBXfkgjTtBX4sePTr30WenzDgw=h0yp8fp17de=ao+8AT=Mg@mail.gmail.com>
	<20160120032537.GA18992@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37610 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbcATIbt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Jan 2016 03:31:49 -0500
Received: by mail-wm0-f46.google.com with SMTP id n5so16561943wmn.0
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jan 2016 00:31:47 -0800 (PST)
In-Reply-To: <20160120032537.GA18992@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Thanks very much for your prompt replies. Please see inline..

On Tue, Jan 19, 2016 at 7:25 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Jan 19, 2016 at 09:39:51AM -0800, Raj Ammanur wrote:
>> Thanks a bunch Herbert. I will try out the patch when you make it available.
>>
>>
>> Are there any thoughts for these other questions from you or anyone
>> else on the list, more
>> importantly regarding backlog handling in ESP ?
>>
>>
>> 2. When the pkts are put on the async work queue, the queue size is initialized
>> as 100 in cryptd_init_queue() in crypto/cryptd.c. Does anyone know how/why
>> 100 was picked ?
>
> This should probably be increased to match NAPI queue lengths.


RAJ: ok. would it also be useful to be able to set the length as a module
load time parameter?

>
>> 3. In cryptd_queue_worker(), the backlog->complete() callback is invoked with
>> -EINPROGRESS. In net/ipv4/esp4.c, there is no handling for EINPROGRESS
>> in esp_input_done()/esp_input_done2(). Am I reading the code correctly and
>> is there any expectation that ESP should support backlog and have backlog
>> handling ? Currently, the pkt just gets dropped as the EINPROGRESS is treated
>> as nexthdr and hence is invalid.
>
> IPsec does not use crypto backlogging so complete should never be
> called with EINPROGRESS.  If the queue length is exceeded the
> packet will be dropped.
>

RAJ: hmm, thats true, yes.

so, is the below description, that you wrote in one of your email replies,
the solution for which you are going to create a patch?

> So what I'm thinking of is to have the softirq path forcibly regain
> control from cryptd where possible.  This is tricky because cryptd
> might be in the middle of processing a request.  So that's why I'd
> like to disable softirqs while we're processing a request.



thanks
--Raj



> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
