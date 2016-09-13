From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3] crypto: only call put_page on referenced and used pages
Date: Tue, 13 Sep 2016 13:27:34 +0200
Message-ID: <6581903.GBJMzZudEe@tauon.atsec.com>
References: <13399079.xub8KL5p6S@positron.chronox.de> <1794862.SeMhQgguHO@positron.chronox.de> <20160913100816.GA30804@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47946 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751541AbcIML1j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 07:27:39 -0400
In-Reply-To: <20160913100816.GA30804@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 13. September 2016, 18:08:16 CEST schrieb Herbert Xu:

Hi Herbert,

> This patch appears to be papering over a real bug.
> 
> The async path should be exactly the same as the sync path, except
> that we don't wait for completion.  So the question is why are we
> getting this crash here for async but not sync?

At least one reason is found in skcipher_recvmsg_async with the following code 
path:

 if (txbufs == tx_nents) {
                        struct scatterlist *tmp;
                        int x;
                        /* Ran out of tx slots in async request
                         * need to expand */
                        tmp = kcalloc(tx_nents * 2, sizeof(*tmp),
                                      GFP_KERNEL);
                        if (!tmp)
                                goto free;

                        sg_init_table(tmp, tx_nents * 2);
                        for (x = 0; x < tx_nents; x++)
                                sg_set_page(&tmp[x], sg_page(&sreq->tsg[x]),
                                            sreq->tsg[x].length,
                                            sreq->tsg[x].offset);
                        kfree(sreq->tsg);
                        sreq->tsg = tmp;
                        tx_nents *= 2;
                        mark = true;
                }


==> the code allocates twice the amount of the previously existing memory, 
copies the existing SGs over, but does not set the remaining SGs to anything. 
If the caller provides less pages than the number of allocated SGs, some SGs 
are unset. Hence, the deallocation must not do anything with the yet 
uninitialized SGs.

Ciao
Stephan
