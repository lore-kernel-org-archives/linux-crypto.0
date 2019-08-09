Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BBEC433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 17:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B3BA20820
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 17:14:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JThOCfZG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406197AbfHIRN7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 13:13:59 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38747 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfHIRN7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 13:13:59 -0400
Received: by mail-wr1-f66.google.com with SMTP id g17so98905617wrr.5
        for <linux-crypto@vger.kernel.org>; Fri, 09 Aug 2019 10:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jWux70LSUOqxi70F75LLUYpmzPxZo8KQ/xisF7DAohg=;
        b=JThOCfZGJto/yADHt2C7pMpkp515seIe7vi0Csmj3uwYIhdWS75ze1lYxQ93ZhOWR4
         ekO+foPyQScfyE+jx6GUhY6qW14Ja7C5O6Htl2WzDJHooMsz995zpk3aGAlICQlFx4K8
         k+buvo6YrjZ2W1LWPkA5bqYb5VYgraW1UH1bTEwBo/S4UylalfCck1kFkY9SYyMoHnE/
         pLvrQ9nH34+VQ64s7JIWiAUpcTzGfo5hX3i4LDrkiCMdRG0YAt7gMO5mkmYzVR+7Ia0U
         bjG/rSKHHAwPrnGGQvv2ZtRwLSEOknPJvN9XqPMhwtXyFMg5WF8GMWUEswaMw1Xv1AJc
         Uv/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jWux70LSUOqxi70F75LLUYpmzPxZo8KQ/xisF7DAohg=;
        b=XA8wwJL1S13BKxbxQ3nEqdq48HfGeMtBHKpXNLPenKjVggbfAxZCd81OK7QFuCYUUZ
         xJ+pXbuhqgxkuE+LJoW0CYStv0H0KmaRScsLJkqiMCtq35eK2gIO7tf1SVbgdBgEgLKx
         weyKWUy2S2qn5ftX3DWRtob0XVwyFtbjka5yQirYVuy+FMvknX83L2DPbXIOj8MHAvHm
         f5V4ev8pdAXfC3kHUs0RPaTLUtqfewJ7zzJQdgtZg+jE9qNF9/KVKSAEM7g57XnP31V5
         ZmiPlND4QqpSwkNgyZPlzMQ1rrGf6tQge7gp52nJgv607Mnxhc0UpgtUOXeMxlmD5p2I
         Inbw==
X-Gm-Message-State: APjAAAUZz00t6YfF6hbfy+CYESKRj5bQluYluL9LwMr63BRabjV+ogwp
        xXk888aBbcgVsIuWN0Rb+mok0ApfHuuS5XH+1Kkfig==
X-Google-Smtp-Source: APXvYqw3VhsZGfEH6ZfIiiBaPZzVlFPe7hv5b/f6EbaxlV/13Ai44eptRxgQ+MegR8qowhfruqdLC22eW+iJHMo0PBs=
X-Received: by 2002:adf:aa09:: with SMTP id p9mr3450571wrd.174.1565370835788;
 Fri, 09 Aug 2019 10:13:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190809063106.316-1-ard.biesheuvel@linaro.org>
 <MN2PR20MB29733DD62DC12B6C321713A1CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB2973503920A627A165A2B507CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB2973503920A627A165A2B507CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 9 Aug 2019 20:13:47 +0300
Message-ID: <CAKv+Gu_tyUpDKGBcZEY7jhkNfR3mVRsdVU6ggVS1Jqetqu+XRg@mail.gmail.com>
Subject: Re: [PATCH] crypto: xts - add support for ciphertext stealing
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 9 Aug 2019 at 18:00, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of
> > Pascal Van Leeuwen
> > Sent: Friday, August 9, 2019 12:22 PM
> > To: Ard Biesheuvel <ard.biesheuvel@linaro.org>; linux-crypto@vger.kernel.org
> > Cc: herbert@gondor.apana.org.au; ebiggers@kernel.org; Ondrej Mosnacek
> > <omosnace@redhat.com>; Milan Broz <gmazyland@gmail.com>
> > Subject: RE: [PATCH] crypto: xts - add support for ciphertext stealing
> >
> > Ard,
> >
> > Nitpicking: you patch does not fix the comment at the top stating that
> > sector sizes which are not a multiple of 16 bytes are not supported.
> >
> > Otherwise, it works fine over here and I like the way you actually
> > queue up that final cipher call, which largely addresses my performance
> > concerns w.r.t. hardware acceleration :-)
> >
> Actually, I just noticed it did NOT work fine, the first CTS vector (5)
> was failing. Sorry for missing that little detail before.
> Setting cra_blocksize to 1 instead of 16 solves that issue.
>
> Still sure cra_blocksize should be set to 16? Because to me, that doesn't
> make sense for something that is fundamentally NOT a blockcipher.
>

Yes. I spotted an issue in the async handling, I'll send out a v2.

> >
> > > -----Original Message-----
> > > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > Sent: Friday, August 9, 2019 8:31 AM
> > > To: linux-crypto@vger.kernel.org
> > > Cc: herbert@gondor.apana.org.au; ebiggers@kernel.org; Ard Biesheuvel
> > > <ard.biesheuvel@linaro.org>; Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; Ondrej
> > > Mosnacek <omosnace@redhat.com>; Milan Broz <gmazyland@gmail.com>
> > > Subject: [PATCH] crypto: xts - add support for ciphertext stealing
> > >
> > > Add support for the missing ciphertext stealing part of the XTS-AES
> > > specification, which permits inputs of any size >= the block size.
> > >
> > > Cc: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> > > Cc: Ondrej Mosnacek <omosnace@redhat.com>
> > > Cc: Milan Broz <gmazyland@gmail.com>
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >
> > Tested-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> >
> Eh ... tested yes ... working ... no ...
>
> > > ---
> > > This is an alternative approach to Pascal's [0]: instead of instantiating
> > > a separate cipher to deal with the tail, invoke the same ECB skcipher used
> > > for the bulk of the data.
> > >
> > > [0] https://lore.kernel.org/linux-crypto/1565245094-8584-1-git-send-email-
> > > pvanleeuwen@verimatrix.com/
> > >
> > >  crypto/xts.c | 148 +++++++++++++++++---
> > >  1 file changed, 130 insertions(+), 18 deletions(-)
> > >
> > > diff --git a/crypto/xts.c b/crypto/xts.c
> > > index 11211003db7e..fc9edc6eb11e 100644
> > > --- a/crypto/xts.c
> > > +++ b/crypto/xts.c
> > > @@ -34,6 +34,7 @@ struct xts_instance_ctx {
> > >
> > >  struct rctx {
> > >     le128 t;
> > > +   struct scatterlist sg[2];
> > >     struct skcipher_request subreq;
> > >  };
> > >
> > > @@ -84,10 +85,11 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
> > >   * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
> > >   * just doing the gf128mul_x_ble() calls again.
> > >   */
> > > -static int xor_tweak(struct skcipher_request *req, bool second_pass)
> > > +static int xor_tweak(struct skcipher_request *req, bool second_pass, bool enc)
> > >  {
> > >     struct rctx *rctx = skcipher_request_ctx(req);
> > >     struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> > > +   const bool cts = (req->cryptlen % XTS_BLOCK_SIZE);
> > >     const int bs = XTS_BLOCK_SIZE;
> > >     struct skcipher_walk w;
> > >     le128 t = rctx->t;
> > > @@ -109,6 +111,20 @@ static int xor_tweak(struct skcipher_request *req, bool
> > second_pass)
> > >             wdst = w.dst.virt.addr;
> > >
> > >             do {
> > > +                   if (unlikely(cts) &&
> > > +                       w.total - w.nbytes + avail < 2 * XTS_BLOCK_SIZE) {
> > > +                           if (!enc) {
> > > +                                   if (second_pass)
> > > +                                           rctx->t = t;
> > > +                                   gf128mul_x_ble(&t, &t);
> > > +                           }
> > > +                           le128_xor(wdst, &t, wsrc);
> > > +                           if (enc && second_pass)
> > > +                                   gf128mul_x_ble(&rctx->t, &t);
> > > +                           skcipher_walk_done(&w, avail - bs);
> > > +                           return 0;
> > > +                   }
> > > +
> > >                     le128_xor(wdst++, &t, wsrc++);
> > >                     gf128mul_x_ble(&t, &t);
> > >             } while ((avail -= bs) >= bs);
> > > @@ -119,17 +135,70 @@ static int xor_tweak(struct skcipher_request *req, bool
> > second_pass)
> > >     return err;
> > >  }
> > >
> > > -static int xor_tweak_pre(struct skcipher_request *req)
> > > +static int xor_tweak_pre(struct skcipher_request *req, bool enc)
> > >  {
> > > -   return xor_tweak(req, false);
> > > +   return xor_tweak(req, false, enc);
> > >  }
> > >
> > > -static int xor_tweak_post(struct skcipher_request *req)
> > > +static int xor_tweak_post(struct skcipher_request *req, bool enc)
> > >  {
> > > -   return xor_tweak(req, true);
> > > +   return xor_tweak(req, true, enc);
> > >  }
> > >
> > > -static void crypt_done(struct crypto_async_request *areq, int err)
> > > +static void cts_done(struct crypto_async_request *areq, int err)
> > > +{
> > > +   struct skcipher_request *req = areq->data;
> > > +   le128 b;
> > > +
> > > +   if (!err) {
> > > +           struct rctx *rctx = skcipher_request_ctx(req);
> > > +
> > > +           scatterwalk_map_and_copy(&b, rctx->sg, 0, XTS_BLOCK_SIZE, 0);
> > > +           le128_xor(&b, &rctx->t, &b);
> > > +           scatterwalk_map_and_copy(&b, rctx->sg, 0, XTS_BLOCK_SIZE, 1);
> > > +   }
> > > +
> > > +   skcipher_request_complete(req, err);
> > > +}
> > > +
> > > +static int cts_final(struct skcipher_request *req,
> > > +                int (*crypt)(struct skcipher_request *req))
> > > +{
> > > +   struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
> > > +   int offset = req->cryptlen & ~(XTS_BLOCK_SIZE - 1);
> > > +   struct rctx *rctx = skcipher_request_ctx(req);
> > > +   struct skcipher_request *subreq = &rctx->subreq;
> > > +   int tail = req->cryptlen % XTS_BLOCK_SIZE;
> > > +   struct scatterlist *sg;
> > > +   le128 b[2];
> > > +   int err;
> > > +
> > > +   sg = scatterwalk_ffwd(rctx->sg, req->dst, offset - XTS_BLOCK_SIZE);
> > > +
> > > +   scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE, 0);
> > > +   memcpy(b + 1, b, tail);
> > > +   scatterwalk_map_and_copy(b, req->src, offset, tail, 0);
> > > +
> > > +   le128_xor(b, &rctx->t, b);
> > > +
> > > +   scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE + tail, 1);
> > > +
> > > +   skcipher_request_set_tfm(subreq, ctx->child);
> > > +   skcipher_request_set_callback(subreq, req->base.flags, cts_done, req);
> > > +   skcipher_request_set_crypt(subreq, sg, sg, XTS_BLOCK_SIZE, NULL);
> > > +
> > > +   err = crypt(subreq);
> > > +   if (err)
> > > +           return err;
> > > +
> > > +   scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE, 0);
> > > +   le128_xor(b, &rctx->t, b);
> > > +   scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE, 1);
> > > +
> > > +   return 0;
> > > +}
> > > +
> > > +static void encrypt_done(struct crypto_async_request *areq, int err)
> > >  {
> > >     struct skcipher_request *req = areq->data;
> > >
> > > @@ -137,47 +206,90 @@ static void crypt_done(struct crypto_async_request *areq, int err)
> > >             struct rctx *rctx = skcipher_request_ctx(req);
> > >
> > >             rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> > > -           err = xor_tweak_post(req);
> > > +           err = xor_tweak_post(req, true);
> > > +
> > > +           if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
> > > +                   err = cts_final(req, crypto_skcipher_encrypt);
> > > +                   if (err == -EINPROGRESS)
> > > +                           return;
> > > +           }
> > >     }
> > >
> > >     skcipher_request_complete(req, err);
> > >  }
> > >
> > > -static void init_crypt(struct skcipher_request *req)
> > > +static void decrypt_done(struct crypto_async_request *areq, int err)
> > > +{
> > > +   struct skcipher_request *req = areq->data;
> > > +
> > > +   if (!err) {
> > > +           struct rctx *rctx = skcipher_request_ctx(req);
> > > +
> > > +           rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> > > +           err = xor_tweak_post(req, false);
> > > +
> > > +           if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
> > > +                   err = cts_final(req, crypto_skcipher_decrypt);
> > > +                   if (err == -EINPROGRESS)
> > > +                           return;
> > > +           }
> > > +   }
> > > +
> > > +   skcipher_request_complete(req, err);
> > > +}
> > > +
> > > +static int init_crypt(struct skcipher_request *req, crypto_completion_t compl)
> > >  {
> > >     struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
> > >     struct rctx *rctx = skcipher_request_ctx(req);
> > >     struct skcipher_request *subreq = &rctx->subreq;
> > >
> > > +   if (req->cryptlen < XTS_BLOCK_SIZE)
> > > +           return -EINVAL;
> > > +
> > >     skcipher_request_set_tfm(subreq, ctx->child);
> > > -   skcipher_request_set_callback(subreq, req->base.flags, crypt_done, req);
> > > +   skcipher_request_set_callback(subreq, req->base.flags, compl, req);
> > >     skcipher_request_set_crypt(subreq, req->dst, req->dst,
> > > -                              req->cryptlen, NULL);
> > > +                              req->cryptlen & ~(XTS_BLOCK_SIZE - 1), NULL);
> > >
> > >     /* calculate first value of T */
> > >     crypto_cipher_encrypt_one(ctx->tweak, (u8 *)&rctx->t, req->iv);
> > > +
> > > +   return 0;
> > >  }
> > >
> > >  static int encrypt(struct skcipher_request *req)
> > >  {
> > >     struct rctx *rctx = skcipher_request_ctx(req);
> > >     struct skcipher_request *subreq = &rctx->subreq;
> > > +   int err;
> > >
> > > -   init_crypt(req);
> > > -   return xor_tweak_pre(req) ?:
> > > -           crypto_skcipher_encrypt(subreq) ?:
> > > -           xor_tweak_post(req);
> > > +   err = init_crypt(req, encrypt_done) ?:
> > > +         xor_tweak_pre(req, true) ?:
> > > +         crypto_skcipher_encrypt(subreq) ?:
> > > +         xor_tweak_post(req, true);
> > > +
> > > +   if (err || likely((req->cryptlen % XTS_BLOCK_SIZE) == 0))
> > > +           return err;
> > > +
> > > +   return cts_final(req, crypto_skcipher_encrypt);
> > >  }
> > >
> > >  static int decrypt(struct skcipher_request *req)
> > >  {
> > >     struct rctx *rctx = skcipher_request_ctx(req);
> > >     struct skcipher_request *subreq = &rctx->subreq;
> > > +   int err;
> > > +
> > > +   err = init_crypt(req, decrypt_done) ?:
> > > +         xor_tweak_pre(req, false) ?:
> > > +         crypto_skcipher_decrypt(subreq) ?:
> > > +         xor_tweak_post(req, false);
> > > +
> > > +   if (err || likely((req->cryptlen % XTS_BLOCK_SIZE) == 0))
> > > +           return err;
> > >
> > > -   init_crypt(req);
> > > -   return xor_tweak_pre(req) ?:
> > > -           crypto_skcipher_decrypt(subreq) ?:
> > > -           xor_tweak_post(req);
> > > +   return cts_final(req, crypto_skcipher_decrypt);
> > >  }
> > >
> > >  static int init_tfm(struct crypto_skcipher *tfm)
> > > --
> > > 2.17.1
> >
> > Regards,
> > Pascal van Leeuwen
> > Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> > www.insidesecure.com
>
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com
