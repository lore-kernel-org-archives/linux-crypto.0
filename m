Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 633BCC433E3
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 14:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 384C1206F4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 14:23:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bvjdJ21p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgGPOX1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 10:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgGPOX1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 10:23:27 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E38C061755
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2020 07:23:26 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id a11so5221162ilk.0
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2020 07:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zQ0xjpI0vG5oFqTgSbxC2NSTZZvPf7JfMPx/oFvK/sY=;
        b=bvjdJ21pkvQ0V99GYPtySBcflLUMEGHbluwVOOvVdw27yrIjVCLyfN+ATLHG3A0V+6
         yhMGY2raXOtRYrPVQD3rkrC6db97ugF7IWfc4PSm9Acvpg/cCGDnh2FwNAKO3ip0g65k
         sDJuO6RnRjpN+SxYedxvmApI02aTTYV6Z2A3nwWAvXfJhKHPbfwHEQo3Tg3siDhsFoS7
         zeKbfm95tJBxvMlquWXCMmzb+t/K3kEjUMJYcTDDqNOjjQrfkTxvkpiccKQH+cZPq7NQ
         68TxqGqyXAFB9RpYX7aJwwAzjfivKjsS5f6SQWr52+UYzztwI8iZlB8DlcFX2Gd5ZXCx
         OUWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zQ0xjpI0vG5oFqTgSbxC2NSTZZvPf7JfMPx/oFvK/sY=;
        b=iZyxq6xcUfAyv4oYPKt7X82mucLg95e9VA9GtkUJtMxFs1nBN5+FCPj+Refi42Ihg1
         DvQeghLckZQEos9l4oKzOygPwrHuZfDJwzRFtcUFOYEQIc8/cWL7GN9Xi2Hbpg9HO7sS
         cgHde3/+wYDngcrqKqsP4zxTM/8mbwF6h6fwxvEvycS0pDC1cpqA+pfviqgwW51kXmMO
         AXDUctrLHoiA7plEstgWYs/sk/YIJcHUISRu5J6tD1UEieB1C6BWOZs0LyN/tP8zl6O0
         O5T4i3RWWfmCkI5SB4U+L+RdaX5jOhGWiOX9dGH+FCWJZewxQI/p+ChQ9Aa1YutXPJQZ
         xsQA==
X-Gm-Message-State: AOAM533JIi/qeczjqVEGVciv5OvIhc3/BmFUkhC3K9hskjth9KGeT7vR
        fwGGHr+ReYMQQjbmf7wwKAeAkbkLX1nAS79aevv20A==
X-Google-Smtp-Source: ABdhPJwOYLT9zQCrT/TYs2e33bVjxz/0foOxd3FIesEOrVo8ItrVzJg2SrYNJ/IZUIG/zwyzMY9w0KUjTs/DGkgdOCM=
X-Received: by 2002:a92:d84d:: with SMTP id h13mr5140869ilq.102.1594909405881;
 Thu, 16 Jul 2020 07:23:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200713164857.1031117-1-lenaptr@google.com> <20200713164857.1031117-2-lenaptr@google.com>
 <20200713171045.GA722906@gmail.com>
In-Reply-To: <20200713171045.GA722906@gmail.com>
From:   Elena Petrova <lenaptr@google.com>
Date:   Thu, 16 Jul 2020 15:23:14 +0100
Message-ID: <CABvBcwY44BPa+TaDwxWaEogpg3Kdkq8o9cR5gSqNGF-o6d3jrw@mail.gmail.com>
Subject: Re: [PATCH 1/1] crypto: af_alg - add extra parameters for DRBG interface
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thank you for the review, Eric, I'll address your comments in v2.

On Mon, 13 Jul 2020 at 18:10, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Just some bike-shedding:
>
> On Mon, Jul 13, 2020 at 05:48:57PM +0100, Elena Petrova wrote:
> > Extending the userspace RNG interface:
> >   1. adding ALG_SET_DRBG_ENTROPY setsockopt option for entropy input;
> >   2. using sendmsg syscall for specifying the additional data.
> >
> > Signed-off-by: Elena Petrova <lenaptr@google.com>
>
> A cover letter shouldn't really be used for a single patch.
> Just put the details here in the commit message.

Ack

> > diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
> > index 087c0ad09d38..c3d1667db367 100644
> > --- a/crypto/algif_rng.c
> > +++ b/crypto/algif_rng.c
> > @@ -53,8 +53,24 @@ struct rng_ctx {
> >  #define MAXSIZE 128
> >       unsigned int len;
> >       struct crypto_rng *drng;
> > +     u8 *addtl;
> > +     size_t addtl_len;
> >  };
> >
> > +struct rng_parent_ctx {
> > +     struct crypto_rng *drng;
> > +     u8 *entropy;
> > +};
> > +
> > +static void reset_addtl(struct rng_ctx *ctx)
> > +{
> > +     if (ctx->addtl) {
> > +             kzfree(ctx->addtl);
> > +             ctx->addtl = NULL;
> > +     }
> > +     ctx->addtl_len = 0;
> > +}
>
> It's recommended to prefix function names.  So, reset_addtl => rng_reset_addtl.

Ack

> > +static int rng_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
> > +{
> > +     int err;
> > +     struct alg_sock *ask = alg_sk(sock->sk);
> > +     struct rng_ctx *ctx = ask->private;
> > +
> > +     reset_addtl(ctx);
> > +     ctx->addtl = kzalloc(len, GFP_KERNEL);
> > +     if (!ctx->addtl)
> > +             return -ENOMEM;
>
> Shouldn't the length be limited here?
>
> Also, kmalloc would be sufficient since the memcpy_from_msg() immediately below
> initializes the memory.

Good point, I'll use the same limit as for the recv(). Ack kzalloc/kmalloc.

> > +
> > +     err = memcpy_from_msg(ctx->addtl, msg, len);
> > +     if (err) {
> > +             reset_addtl(ctx);
> > +             return err;
> > +     }
> > +     ctx->addtl_len = len;
> > +
> > +     return 0;
> > +}
>
> >  static void *rng_bind(const char *name, u32 type, u32 mask)
> >  {
> > -     return crypto_alloc_rng(name, type, mask);
> > +     struct rng_parent_ctx *pctx;
> > +     void *err_ptr;
> > +
> > +     pctx = kzalloc(sizeof(*pctx), GFP_KERNEL);
> > +     if (!pctx)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     pctx->drng = crypto_alloc_rng(name, type, mask);
> > +     if (!IS_ERR(pctx->drng))
> > +             return pctx;
> > +
> > +     err_ptr = pctx->drng;
> > +     kfree(pctx);
> > +     return err_ptr;
> >  }
>
> The error handling here is weird.  It would be more conventional to do something
> like:
>
> static void *rng_bind(const char *name, u32 type, u32 mask)
> {
>         struct rng_parent_ctx *pctx;
>         struct crypto_rng *rng;
>
>         pctx = kzalloc(sizeof(*pctx), GFP_KERNEL);
>         if (!pctx)
>                 return ERR_PTR(-ENOMEM);
>
>         rng = crypto_alloc_rng(name, type, mask);
>         if (IS_ERR(rng)) {
>                 kfree(pctx);
>                 return ERR_CAST(rng);
>         }
>
>         pctx->drng = rng;
>         return pctx;
> }

Thanks, I will use your variant.

> >  static void rng_release(void *private)
> >  {
> > -     crypto_free_rng(private);
> > +     struct rng_parent_ctx *pctx = private;
> > +     if (unlikely(!pctx))
> > +             return;
>
> There should be a blank line between declarations and statements.

Ack

> > +     crypto_free_rng(pctx->drng);
> > +     if (pctx->entropy)
> > +             kzfree(pctx->entropy);
>
> No need to check for NULL before calling kzfree().

Ack

> > +static int rng_setentropy(void *private, const u8 *entropy, unsigned int len)
> > +{
> > +     struct rng_parent_ctx *pctx = private;
> > +     u8 *kentropy = NULL;
> > +
> > +     if (pctx->entropy)
> > +             return -EINVAL;
> > +
> > +     if (entropy && len) {
>
> Best to check just 'len', so that users get an error as expected if they
> accidentally pass entry=NULL len=nonzero.

Ack

> > +             kentropy = kzalloc(len, GFP_KERNEL);
> > +             if (!kentropy)
> > +                     return -ENOMEM;
> > +             if (copy_from_user(kentropy, entropy, len)) {
> > +                     kzfree(kentropy);
> > +                     return -EFAULT;
> > +             }
>
> This can use memdup_user().  Also, should there be a length limit?

Alright, changed to memdup_user() and added the same limit as in send and recv.

> > +     }
> > +
> > +     crypto_rng_alg(pctx->drng)->set_ent(pctx->drng, kentropy, len);
> > +     pctx->entropy = kentropy;
>
> pctx->entropy could just be a bool 'has_entropy', right?  The actual value
> doesn't need to be saved.

I need to keep the pointer to free it after use. DRBG saves the
pointer in one of its internal structures, but doesn't do any memory
management. So I had to either change drbg code to deal with the
memory, or save the pointer somewhere inside the socket. I opted for
the latter.

> > +static int rng_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
> > +{
> > +     int err;
> > +     struct alg_sock *ask = alg_sk(sock->sk);
> > +     struct rng_ctx *ctx = ask->private;
> > +
> > +     reset_addtl(ctx);
> > +     ctx->addtl = kzalloc(len, GFP_KERNEL);
> > +     if (!ctx->addtl)
> > +             return -ENOMEM;
> > +
> > +     err = memcpy_from_msg(ctx->addtl, msg, len);
> > +     if (err) {
> > +             reset_addtl(ctx);
> > +             return err;
> > +     }
> > +     ctx->addtl_len = len;
> > +
> > +     return 0;
> > +}
>
> This is also missing any sort of locking, both between concurrent calls to
> rng_sendmsg(), and between rng_sendmsg() and rng_recvmsg().
>
> lock_sock() would solve the former.  I'm not sure what should be done about
> rng_recvmsg().  It apparently relies on the crypto_rng doing its own locking,
> but maybe it should just use lock_sock() too.

Thanks, I've added lock_sock() to both.

> - Eric
