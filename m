Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6222C282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 07:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 880092084C
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 07:48:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="A3tRzfQU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbfAYHso (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 02:48:44 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40745 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfAYHsn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 02:48:43 -0500
Received: by mail-io1-f66.google.com with SMTP id k2so7014690iog.7
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 23:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9KQ4D/VMCjgV8L/LGDfb0EIfdVa2OsRhqD76smr04P0=;
        b=A3tRzfQUTuFxnAHGQPsDKw0+HglXq/lR1zbdU1g7AoqmGeRDR9Iz9Y6e+mXw06cHKs
         fEnK9JDPm9nQwjj7rWqaDvQ9Xyang2jad8oQlc/cDFncpxlEYku//N+CwXo4Gc3PAe4Y
         1hMyqjd+wa/Soj94IpsvGJM2jD3MqHLWEp90c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9KQ4D/VMCjgV8L/LGDfb0EIfdVa2OsRhqD76smr04P0=;
        b=bXnVhJvEECQw0sV6IHNgVoM+qR9UzoU1ZRFGbMwYxDOoZUzGHO+SJppHLImmtogXNR
         6oGFWM19BGApsucqCPpq2e4suX/44oZMSh6vvt+BvBA7MCcFVzUZGWYhVRb+FsX/F8C5
         zb/QYG4Bw7/zuq7oYVEYcGXToeGyi7MUryOkvOnVMz7cjCNNqJq8YczcuFMmv9S4GZb9
         nMBpni0TWHuSujMkQKdiGJGABZoJlLEIhzMKpIk6kI4wtADks1oJ2eNERMVXc3I4VEA9
         wjDpW6S4PVrNuef7I6NSx23OW2k/QjjG1TcPNI2gYq1iwss0D7SSyD2Thgh6Z2VreHtR
         PhuQ==
X-Gm-Message-State: AHQUAuaudpCsNsnaqsgZFJKryk9gj8pKW9Mb0LYKfTKpALv08bkyGqxZ
        Z4QmMr7pN/b+O7lUk4JkbmhkT8ubZ9ZrfTDcpiadcw==
X-Google-Smtp-Source: AHgI3IY+kZoHX9DZ7Fw7qYZOH9lZyvWWBOtFh7Lbyv7uhycPI5thUuA9BgXirJOTyFLVHSDwDee3Og++OEhaFLAOjxg=
X-Received: by 2002:a6b:5d01:: with SMTP id r1mr5631292iob.170.1548402522526;
 Thu, 24 Jan 2019 23:48:42 -0800 (PST)
MIME-Version: 1.0
References: <20190124182712.7142-1-ard.biesheuvel@linaro.org>
 <20190124182712.7142-2-ard.biesheuvel@linaro.org> <20190125072234.GB700@sol.localdomain>
In-Reply-To: <20190125072234.GB700@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 25 Jan 2019 08:48:31 +0100
Message-ID: <CAKv+Gu864GTrA36dTTmNsriCpbj-eghS-9fRSA=DMGvFUW8nxw@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: arm/crct10dif - revert to C code for short inputs
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 25 Jan 2019 at 08:22, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Jan 24, 2019 at 07:27:11PM +0100, Ard Biesheuvel wrote:
> > The SIMD routine ported from x86 used to have a special code path
> > for inputs < 16 bytes, which got lost somewhere along the way.
> > Instead, the current glue code aligns the input pointer to permit
> > the NEON routine to use special versions of the vld1 instructions
> > that assume 16 byte alignment, but this could result in inputs of
> > less than 16 bytes to be passed in. This not only fails the new
> > extended tests that Eric has implemented, it also results in the
> > code reading before the input pointer, which could potentially
> > result in crashes when dealing with less than 16 bytes of input
> > at the start of a page which is preceded by an unmapped page.
> >
> > So update the glue code to only invoke the NEON routine if the
> > input is more than 16 bytes.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> Can you add proper tags?
>
> Fixes: 1d481f1cd892 ("crypto: arm/crct10dif - port x86 SSE implementation to ARM")
> Cc: <stable@vger.kernel.org> # v4.10+
>

Ah yes, thanks for digging that up.

> Just double checking as I don't have a system immediately available to run this
> one on -- I assume it passes with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y now?
>

Yes.

> Another comment below:
>
> > ---
> >  arch/arm/crypto/crct10dif-ce-core.S | 20 ++++++++---------
> >  arch/arm/crypto/crct10dif-ce-glue.c | 23 +++++---------------
> >  2 files changed, 16 insertions(+), 27 deletions(-)
> >
> > diff --git a/arch/arm/crypto/crct10dif-ce-core.S b/arch/arm/crypto/crct10dif-ce-core.S
> > index ce45ba0c0687..3fd13d7c842c 100644
> > --- a/arch/arm/crypto/crct10dif-ce-core.S
> > +++ b/arch/arm/crypto/crct10dif-ce-core.S
> > @@ -124,10 +124,10 @@ ENTRY(crc_t10dif_pmull)
> >       vext.8          q10, qzr, q0, #4
> >
> >       // receive the initial 64B data, xor the initial crc value
> > -     vld1.64         {q0-q1}, [arg2, :128]!
> > -     vld1.64         {q2-q3}, [arg2, :128]!
> > -     vld1.64         {q4-q5}, [arg2, :128]!
> > -     vld1.64         {q6-q7}, [arg2, :128]!
> > +     vld1.64         {q0-q1}, [arg2]!
> > +     vld1.64         {q2-q3}, [arg2]!
> > +     vld1.64         {q4-q5}, [arg2]!
> > +     vld1.64         {q6-q7}, [arg2]!
> >  CPU_LE(      vrev64.8        q0, q0                  )
> >  CPU_LE(      vrev64.8        q1, q1                  )
> >  CPU_LE(      vrev64.8        q2, q2                  )
> > @@ -150,7 +150,7 @@ CPU_LE(   vrev64.8        q7, q7                  )
> >       veor.8          q0, q0, q10
> >
> >       adr             ip, rk3
> > -     vld1.64         {q10}, [ip, :128]       // xmm10 has rk3 and rk4
> > +     vld1.64         {q10}, [ip]     // xmm10 has rk3 and rk4
>
> This one is loading static data that is 16 byte aligned, so the :128 can be kept
> here.  Same in the two other places below that load from [ip].
>

OK, will change that back.

> >
> >       //
> >       // we subtract 256 instead of 128 to save one instruction from the loop
> > @@ -167,7 +167,7 @@ CPU_LE(   vrev64.8        q7, q7                  )
> >  _fold_64_B_loop:
> >
> >       .macro          fold64, reg1, reg2
> > -     vld1.64         {q11-q12}, [arg2, :128]!
> > +     vld1.64         {q11-q12}, [arg2]!
> >
> >       vmull.p64       q8, \reg1\()h, d21
> >       vmull.p64       \reg1, \reg1\()l, d20
> > @@ -203,13 +203,13 @@ CPU_LE( vrev64.8        q12, q12                )
> >       // constants
> >
> >       adr             ip, rk9
> > -     vld1.64         {q10}, [ip, :128]!
> > +     vld1.64         {q10}, [ip]!
> >
> >       .macro          fold16, reg, rk
> >       vmull.p64       q8, \reg\()l, d20
> >       vmull.p64       \reg, \reg\()h, d21
> >       .ifnb           \rk
> > -     vld1.64         {q10}, [ip, :128]!
> > +     vld1.64         {q10}, [ip]!
> >       .endif
> >       veor.8          q7, q7, q8
> >       veor.8          q7, q7, \reg
> > @@ -238,7 +238,7 @@ _16B_reduction_loop:
> >       vmull.p64       q7, d15, d21
> >       veor.8          q7, q7, q8
> >
> > -     vld1.64         {q0}, [arg2, :128]!
> > +     vld1.64         {q0}, [arg2]!
> >  CPU_LE(      vrev64.8        q0, q0          )
> >       vswp            d0, d1
> >       veor.8          q7, q7, q0
> > @@ -335,7 +335,7 @@ _less_than_128:
> >       vmov.i8         q0, #0
> >       vmov            s3, arg1_low32          // get the initial crc value
> >
> > -     vld1.64         {q7}, [arg2, :128]!
> > +     vld1.64         {q7}, [arg2]!
> >  CPU_LE(      vrev64.8        q7, q7          )
> >       vswp            d14, d15
> >       veor.8          q7, q7, q0
> > diff --git a/arch/arm/crypto/crct10dif-ce-glue.c b/arch/arm/crypto/crct10dif-ce-glue.c
> > index d428355cf38d..14c19c70a841 100644
> > --- a/arch/arm/crypto/crct10dif-ce-glue.c
> > +++ b/arch/arm/crypto/crct10dif-ce-glue.c
> > @@ -35,26 +35,15 @@ static int crct10dif_update(struct shash_desc *desc, const u8 *data,
> >                           unsigned int length)
> >  {
> >       u16 *crc = shash_desc_ctx(desc);
> > -     unsigned int l;
> >
> > -     if (!may_use_simd()) {
> > -             *crc = crc_t10dif_generic(*crc, data, length);
> > +     if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && may_use_simd()) {
> > +             kernel_neon_begin();
> > +             *crc = crc_t10dif_pmull(*crc, data, length);
> > +             kernel_neon_end();
> >       } else {
> > -             if (unlikely((u32)data % CRC_T10DIF_PMULL_CHUNK_SIZE)) {
> > -                     l = min_t(u32, length, CRC_T10DIF_PMULL_CHUNK_SIZE -
> > -                               ((u32)data % CRC_T10DIF_PMULL_CHUNK_SIZE));
> > -
> > -                     *crc = crc_t10dif_generic(*crc, data, l);
> > -
> > -                     length -= l;
> > -                     data += l;
> > -             }
> > -             if (length > 0) {
> > -                     kernel_neon_begin();
> > -                     *crc = crc_t10dif_pmull(*crc, data, length);
> > -                     kernel_neon_end();
> > -             }
> > +             *crc = crc_t10dif_generic(*crc, data, length);
> >       }
> > +
> >       return 0;
> >  }
> >
> > --
> > 2.17.1
> >
