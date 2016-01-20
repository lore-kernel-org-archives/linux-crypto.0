From: Raj Ammanur <rammanur@arista.com>
Subject: Re: [PATCH] crypto: aesni-intel - avoid IPsec re-ordering
Date: Wed, 20 Jan 2016 09:30:18 -0800
Message-ID: <CAMFBXfk+Ej4QHuqvs-Sxaz3s4+yZiXcvvf_6-cOUOa4OH0ewNQ@mail.gmail.com>
References: <CAMFBXfk=u_QYTdz0+P1WoNwuGN1xBaw0Ff2Y_XvLdQnKTasOcw@mail.gmail.com>
	<20160119074343.GA7753@gondor.apana.org.au>
	<CAMFBXfkgjTtBX4sePTr30WenzDgw=h0yp8fp17de=ao+8AT=Mg@mail.gmail.com>
	<20160120032537.GA18992@gondor.apana.org.au>
	<CAMFBXfkS_maZVwpEcUF+gUU9Q74tKKcxFiS+Oe3FBXnrrxyFAA@mail.gmail.com>
	<20160120083806.GA20214@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38527 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934015AbcATRaU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Jan 2016 12:30:20 -0500
Received: by mail-wm0-f54.google.com with SMTP id b14so41141026wmb.1
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jan 2016 09:30:19 -0800 (PST)
In-Reply-To: <20160120083806.GA20214@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 20, 2016 at 12:38 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Wed, Jan 20, 2016 at 12:31:46AM -0800, Raj Ammanur wrote:
>>
>> RAJ: ok. would it also be useful to be able to set the length as a module
>> load time parameter?
>
> That would be a bad interface.  If we wanted to have an adjustable
> limit it needs to be set by the entity that is creating the tfm,
> i.e., IPsec.
>


RAJ: Agreed, but it also has been useful for me for testing/debugging to be
able to specify the size to a KLM, since the other stuff is built into
the kernel.
We atleast got rid of the dup acks, although the out of order pkts still remain.

>> RAJ: hmm, thats true, yes.
>>
>> so, is the below description, that you wrote in one of your email replies,
>> the solution for which you are going to create a patch?
>>
>> > So what I'm thinking of is to have the softirq path forcibly regain
>> > control from cryptd where possible.  This is tricky because cryptd
>> > might be in the middle of processing a request.  So that's why I'd
>> > like to disable softirqs while we're processing a request.
>
> Yes.
>

RAJ: Will wait for the patch to take a look and try it out and test
it.  Sincerely appreciate it.

thanks
--Raj

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
