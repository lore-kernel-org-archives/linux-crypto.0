From: Hamid Nassiby <h.nassiby@gmail.com>
Subject: Re: Fwd: crypto accelerator driver problems
Date: Sat, 15 Oct 2011 14:56:28 +0330
Message-ID: <CAFuf8QMeLdAPs2fqYwDmLyOW=uyzD82hboYy=Q4uy3f=0bWcTg@mail.gmail.com>
References: <AANLkTinm8uy34ni_4XFLZTcdkndy0B_jeFXag0onxA66@mail.gmail.com>
	<AANLkTin8au=98mmfsaJjOSyJNibk3foZWihj6EGTGWK-@mail.gmail.com>
	<20110126070939.GA18150@gondor.apana.org.au>
	<AANLkTi=m0jVWSqR1FNX9r9HH32LbA0aWJxSQtLd_VszW@mail.gmail.com>
	<20110126233315.GB26664@gondor.apana.org.au>
	<CAFuf8QO1gG2WUMmgywHANBHgBj1D8RV8xkJvMYOdiJSovduG+A@mail.gmail.com>
	<20110705065351.GA31107@gondor.apana.org.au>
	<CAFuf8QPV248w=S06s7mz=vLzYdsrjQ7nvChui-3P3kgMzV8vHA@mail.gmail.com>
	<20111004075755.GV1808@secunet.com>
	<CAFuf8QOCKXOgMyu7FceYRGh_oTw+pt96tasVC19pS1Zzd96mxQ@mail.gmail.com>
	<20111011094222.GB1830@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48230 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab1JOL0a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 15 Oct 2011 07:26:30 -0400
Received: by bkbzt19 with SMTP id zt19so1110775bkb.19
        for <linux-crypto@vger.kernel.org>; Sat, 15 Oct 2011 04:26:28 -0700 (PDT)
In-Reply-To: <20111011094222.GB1830@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/11/11, Steffen Klassert <steffen.klassert@secunet.com> wrote:

>
> I can't tell much when looking at this code snippet. One guess would be
> someone (maybe you) has set the CRYPTO_TFM_REQ_MAY_SLEEP flag, as
> blkcipher_walk_done calls crypto_yield() which in turn might call
> schedule() if this flag is set. prcypt removes this flag explicit.
>

I've not set such a flag.

>
> Basically, the bottom halves are off to keep up with the network softirqs.
> They run with much higher priority and would interrupt the parallel
> workers frequently.
>

Do you mean that with BHs on, we only have some performance degrades?

Thanks for your reply.
Any other idea?
