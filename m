From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v5 1/2] crypto: skcipher AF_ALG - overhaul memory management
Date: Thu, 16 Mar 2017 09:55:17 +0100
Message-ID: <13069331.7r3bo5pPcW@positron.chronox.de>
References: <2523592.mde6d2a8Lg@positron.chronox.de> <16908830.B9gcyeAhPX@positron.chronox.de> <20170316083922.GA11653@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58076 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751279AbdCPJEp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 05:04:45 -0400
In-Reply-To: <20170316083922.GA11653@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 16. März 2017, 09:39:23 CET schrieb Herbert Xu:

Hi Herbert,

> On Fri, Feb 17, 2017 at 11:31:41PM +0100, Stephan Müller wrote:
> > +	} else {
> > +		/* Synchronous operation */
> > +		skcipher_request_set_callback(&areq->req,
> > +					      CRYPTO_TFM_REQ_MAY_SLEEP |
> > +					      CRYPTO_TFM_REQ_MAY_BACKLOG,
> > +					      af_alg_complete,
> > +					      &ctx->completion);
> > +		err = af_alg_wait_for_completion(ctx->enc ?
> > +					crypto_skcipher_encrypt(&areq->req) :
> > +					crypto_skcipher_decrypt(&areq->req),
> > +						 &ctx->completion);
> > +	}
> 
> This is now outside of the loop for the sync case.  The purpose
> of the loop in the sync case was to segment the data when we get
> a very large SG list that does not fit inside a single call.
> 
> Or did I miss something?

The while loop present in the skcipher_recvmsg_sync present in the current 
upstream kernel operates on ctx->rsgl. That data structure is defined as:

struct af_alg_sgl {
        struct scatterlist sg[ALG_MAX_PAGES + 1];
        struct page *pages[ALG_MAX_PAGES];
        unsigned int npages;
};

I.e. recvmsg operates on at most 16 SGs where each can take one page of data. 
Thus, if a user provides more data than 16 pages, such while loop would make 
much sense.

The patch proposed here is not limited on a fixed set of 16 SGs in the RX-SGL. 
The recvmsg code path allocates the required amount of SGLs space: 

        /* convert iovecs of output buffers into RX SGL */
        while (len < ctx->used && iov_iter_count(&msg->msg_iter)) {
                struct skcipher_rsgl *rsgl;
...
                        rsgl = sock_kmalloc(sk, sizeof(*rsgl), GFP_KERNEL);
...

struct skcipher_rsgl uses the af_alg_sgl data structure with its 16 SG 
entries. But now you can have arbitrary numbers of af_alg_sgl instances up to 
the memory provided by sock_kmalloc. I.e. recvmsg can now operate on multiples 
of af_alg_sgl in one go.

With this approach I thought that the while loop could be a thing of the past, 
considering that this is also the approach taken in skcipher_recvmsg_async 
that is present in the current upstream code base.

> 
> Overall I like this patch.

Thank you very much.
> 
> Thanks,


Ciao
Stephan
