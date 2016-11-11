From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3] crypto: only call put_page on referenced and used pages
Date: Fri, 11 Nov 2016 15:28:27 +0100
Message-ID: <4360758.DiGJTW58Mu@positron.chronox.de>
References: <13399079.xub8KL5p6S@positron.chronox.de> <20160913100816.GA30804@gondor.apana.org.au> <6581903.GBJMzZudEe@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:50878 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932813AbcKKO2i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2016 09:28:38 -0500
In-Reply-To: <6581903.GBJMzZudEe@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 13. September 2016, 13:27:34 CET schrieb Stephan Mueller:

Hi Herbert,

> Am Dienstag, 13. September 2016, 18:08:16 CEST schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > This patch appears to be papering over a real bug.
> > 
> > The async path should be exactly the same as the sync path, except
> > that we don't wait for completion.  So the question is why are we
> > getting this crash here for async but not sync?
> 
> At least one reason is found in skcipher_recvmsg_async with the following
> code path:
> 
>  if (txbufs == tx_nents) {
>                         struct scatterlist *tmp;
>                         int x;
>                         /* Ran out of tx slots in async request
>                          * need to expand */
>                         tmp = kcalloc(tx_nents * 2, sizeof(*tmp),
>                                       GFP_KERNEL);
>                         if (!tmp)
>                                 goto free;
> 
>                         sg_init_table(tmp, tx_nents * 2);
>                         for (x = 0; x < tx_nents; x++)
>                                 sg_set_page(&tmp[x], sg_page(&sreq->tsg[x]),
> sreq->tsg[x].length,
>                                             sreq->tsg[x].offset);
>                         kfree(sreq->tsg);
>                         sreq->tsg = tmp;
>                         tx_nents *= 2;
>                         mark = true;
>                 }
> 
> 
> ==> the code allocates twice the amount of the previously existing memory,
> copies the existing SGs over, but does not set the remaining SGs to
> anything. If the caller provides less pages than the number of allocated
> SGs, some SGs are unset. Hence, the deallocation must not do anything with
> the yet uninitialized SGs.

I looked into the issue a bit deeper. In addition to the aforementioned code, 
the following code seems to be a second culprit:

	tx_nents = skcipher_all_sg_nents(ctx);
	sreq->tsg = kcalloc(tx_nents, sizeof(*sg), GFP_KERNEL);
	if (unlikely(!sreq->tsg))
		goto unlock;
	sg_init_table(sreq->tsg, tx_nents);

Here again, an SGL is initialized, but there are no pages mapped to the SGs.

May I ask you to reconsider this patch as well as the patch "[PATCH] crypto: 
call put_page on used pages only" from September 10 since the current code of 
libkcapi can easily trigger these bugs and lead to a kernel crash.

If you consider the patches papering over the heart of the problem, may I ask 
for suggestions on how the mentioned code should be changed such that the 
issues are removed? If the suggestion is to re-architect the memory handling 
in the async part, may I ask to at least apply the patches for now with the 
goal to have time for re-architecting the async code and yet have no open 
holes that lead to crashes?

Thanks.

Ciao
Stephan
