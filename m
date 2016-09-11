From: Stephan Mueller <smueller@chronox.de>
Subject: Re: algif_aead: AIO broken with more than one iocb
Date: Sun, 11 Sep 2016 15:41:32 +0200
Message-ID: <6610027.GT1Ckz3spu@positron.chronox.de>
References: <6245755.LbXSUvPjJL@positron.chronox.de> <CAH8yC8knD0U4-BhgzkUfyHMm-KyNyDCx-3PPqQOm0bdVh4qjiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47928 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756123AbcIKNlk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Sep 2016 09:41:40 -0400
In-Reply-To: <CAH8yC8knD0U4-BhgzkUfyHMm-KyNyDCx-3PPqQOm0bdVh4qjiA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 11. September 2016, 08:43:00 CEST schrieb Jeffrey Walton:

Hi Jeffrey,

> > The AIO support for algif_aead is broken when submitting more than one
> > iocb.
> > The break happens in aead_recvmsg_async at the following code:
> I think the kernel needs to take a half step back, and add the missing
> self tests and test cases to be more proactive in detecting breaks
> earlier. Speaking first hand, some of these breaks have existed for
> months.
> 
> I don't take the position you can't break things. I believe you can't
> make an omelet without breaking eggs; and if you're not breaking
> something, then you're probably not getting anything done. The
> engineering defect is not detecting the break.

The testing that is implemented for libkcapi should cover almost all code 
paths of AF_ALG in the kernel. However, I just added the AIO support to the 
library in the last few days as this logic is not straight forward. Thus these 
issues show up now.

If you wish to analyze the AIO support more, I can certainly push my current 
development branch of libkcapi to my github tree so that you would have a 
working AIO user space component.

Ciao
Stephan
