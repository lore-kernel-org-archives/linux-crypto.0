From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [QUESTION] hash import and request initialization
Date: Tue, 26 Dec 2017 14:21:53 +0200
Message-ID: <CAOtvUMeEw88mYVjb7bDLwGb67aXi2p5e-uRXn0XrDe0uddyT6g@mail.gmail.com>
References: <CAOtvUMdsqEpUSSBZXxHPzuO-84B3VKxRLLN=y1cxfNbt+5qpSQ@mail.gmail.com>
 <20171226030751.GA11758@gondor.apana.org.au> <CAOtvUMfkGgyhCTUpfpegfmR3DNYhvfRN4oHL1tY9RMRh5sfCfQ@mail.gmail.com>
 <20171226104010.GA28275@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f172.google.com ([74.125.82.172]:35696 "EHLO
        mail-ot0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750781AbdLZMVy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Dec 2017 07:21:54 -0500
Received: by mail-ot0-f172.google.com with SMTP id q5so8740497oth.2
        for <linux-crypto@vger.kernel.org>; Tue, 26 Dec 2017 04:21:54 -0800 (PST)
In-Reply-To: <20171226104010.GA28275@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 26, 2017 at 12:40 PM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Tue, Dec 26, 2017 at 11:06:02AM +0200, Gilad Ben-Yossef wrote:
>>
>> The hash state needs to be DMAed in and out of the hardware on each operation
>> and I have no guarantee that the ahash request is allocated from DMAable memory
>> (i.e. AHASH_REQUEST_ON_STACK).
>
> AHASH_REQUEST_ON_STACK cannot possibly be used on an async ahash
> implementation for obvious reasons so this shouldn't be an issue.
>

OK, you lost me on this statement.

See how SKCIPHER_REQUEST_ON_STACK is being used with an asymmetric skcipher
in drivers/md/dm-integrity.c

The case with AHASH_REQUEST_ON_STACK looks symmetric to me.

E.g. why would this dummy code be illegal -

DECLARE_CRYPTO_WAIT(wait);
AHASH_REQUEST_ON_STACK(req, tfm);
sg_init_table(&sg, 1);
sg_set_buf(&sg, buf);

ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP |
                                        CRYPTO_TFM_REQ_MAY_BACKLOG,
                                        crypto_req_done, (void *)wait);

ahash_request_set_crypt(req, &sg, NULL, len);

rc = crypto_ahash_digest(req);

/* do some stuff here, possibly stuff that can sleep */

rc = crypto_wait_req(r, wait);
...

> The construct is simply a compatibility aid for sync-only users
> to use the ahash interface.

Please don't get me wrong, I'm not trying to argue. Simply putting the
internal state in the
request context is the simplest most straight forward thing for me. If
you say I don't need
to worry about it I'm fine with that. I just want to understand why
it's OK so I can understand
the system better.

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
