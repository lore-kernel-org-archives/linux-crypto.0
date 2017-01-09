From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: Is the asynchronous hash crypto API asynchronous?
Date: Mon, 09 Jan 2017 16:25:16 +0100
Message-ID: <2729982.uIdpx7mi4e@positron.chronox.de>
References: <CAOtvUMd=EHaFq=AtMePzN9fsoMLszZ0ruAu8KaaP=W=8J7nGUg@mail.gmail.com> <3639236.s9QSuQoh7d@positron.chronox.de> <CAOtvUMfheVHLH6y96+YjScZOYvBJegF6GwuBynR1LEgFt-O4=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55346 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756781AbdAIPZ0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2017 10:25:26 -0500
In-Reply-To: <CAOtvUMfheVHLH6y96+YjScZOYvBJegF6GwuBynR1LEgFt-O4=w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 9. Januar 2017, 14:08:23 CET schrieb Gilad Ben-Yossef:

Hi Gilad,

> Hello Stephen,
> 
> Before getting to business I wish to offer my thanks for hosting the
> kernel crypto documentation on your web site at chronox.de. It has
> proven very useful to me :-)

I am glad that it is helpful.
> 
> On Mon, Jan 9, 2017 at 12:23 PM, Stephan Müller <smueller@chronox.de> wrote:
> > Am Sonntag, 8. Januar 2017, 15:45:37 CET schrieb Gilad Ben-Yossef:
> > 
> > Hi Gilad,
> > 
> >>         ahash_request_set_callback(req, 0, NULL, NULL);
> >> 
> >> Would anyone be kind enough to enlighten me?
> > 
> > The documentation got out of sync with the real world. I will file a patch
> > for that shortly.
> > 
> > The ahash API works identically to the async skcipher API for which you
> > find an example in the api-samples.rst. There you see that with the
> > set_callback, a function is registered that is triggered upon completion
> > of the operation.
> > 
> > Thus, use the callback example you find for skcipher for your ahash
> > operation and you get an async operation.
> 
> Thank you very much for pointing out the skcipher example. It is very
> helpful.
> 
> However, I suspect there is something a miss here beyond documentation:
> 
> There is (quite a lot of) kernel code calling
> ahash_request_set_callback() with a NULL callback and consequently not
> performing any synchronization in the completion of the hashing
> operations.

I think this is legacy, although I cannot say for sure. As of now, there is 
hardly any real ahash implementation out there. The only one I am aware of is 
the sha1-mb/sha256-mb/sha512-mb for x86. There, the kernel would even crash if 
there is a NULL as callback, if I read the code correctly.

For all other implementations, they are synchronous even though you use the 
ahash API. I.e. all of those implementations would not trigger the callback 
function.
> 
> See for example crypt_iv_essiv_init() in drivers/md/dm-crypt.c
> Other similar call sites can be found at block/drbd/drbd_worker.c,
> net/ppp/ppp_mppe.c, net/wireless/intersil/orinoco/mic.c,
> scsi/iscsi_tcp.c, target/iscsi/iscsi_target_login.c
> 
> As far as I could tell the code in crypto/ahash.c does not take any
> special consideration of the case where a NULL call back function has
> been set and at least one of the underlying ahash algorithm provider
> will crash if used like this.

I do not think that the ahash.c code crashes, but look into the sha1-mb 
implementation:

...
                        req = cast_mcryptd_ctx_to_req(req_ctx);
                        if (irqs_disabled())
                                req_ctx->complete(&req->base, ret);
                        else {
                                local_bh_disable();
                                req_ctx->complete(&req->base, ret);
                                local_bh_enable();

...

Here you see the invocation of complete without a check.

> 
> This seems broken to me. I would be very happy to offer to fix the
> broken call sites, if you can only confirm my understanding that
> indeed cases which register a NULL callback are broken and it is not
> just a misunderstanding on my part.


IMHO, the use of a NULL callback works, but should definitely converted to a 
real callback function.
> 
> Many thanks,
> Gilad


Ciao
Stephan
