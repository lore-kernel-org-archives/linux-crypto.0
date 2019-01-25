Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FBEEC282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 07:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A12E217D7
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 07:49:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="LUY3hEdb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbfAYHts (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 02:49:48 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:37531 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfAYHts (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 02:49:48 -0500
Received: by mail-it1-f194.google.com with SMTP id b5so8487882iti.2
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 23:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/pADXBfQMBB0ZhOXN56Df7WzUKfxqN8DN7uguFJDGBI=;
        b=LUY3hEdbRMUIs72HUlLQ4Z45esUjzJ7KuDxlRqy1cGqcci5WEcLlr4pGxl7HXTV6oN
         PHJRzu/8bpkfjD1laSn4x6AHJXjXq9P5/N0XZYeJZx+Cp042TlBVns3e0wpvecWqz+2W
         rpkd5JjTLB8BAzpNvFFtgcWcXolFDHwjFOsig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/pADXBfQMBB0ZhOXN56Df7WzUKfxqN8DN7uguFJDGBI=;
        b=kWOSI47p1tUuB57xKjaEx1TbaFdYu2qc+7DQ0Tf+TgVSobCAN4IpidBUO4bUPdIwFF
         nKiN4dVnVQFJgRRsshCmGB4baFuuRX9UDjUSdq62VBafhQ+kXH0rfMN8phOjGODwITNh
         6fj48+0AV1pVJSo5jbOzrQXRDK7J16M5lWBDiUcf/JyFgVg8/0Zl5vTh3pLixW6tvdXA
         ygjWKj06H80Scm8nUkNTJjOXW5K9howgckK6CH7JJtbPwGGpg0p5rvMrRUoheSKxSalx
         ilvzD/8JpiI5Eqz4LTkpLz3+9gPjRjDQSqrtFJkHkGeHbFp6fE0Ir5Lv2NtMj9BlTNl0
         yPFw==
X-Gm-Message-State: AJcUukdP6/jl1EJZp/Hd2fS1Okw7IBdXahdUZmX3hK3iMG2BI+23w2QQ
        AqmZSa8aeUzOjTC2zHtwwUqcUxm2BFvQJnDdHlr0Sg==
X-Google-Smtp-Source: ALg8bN4dFevJSD2Sh54TewH77Sv/BehSnrO6i++8XF/4am8+FiTXqOneIsnFhuW3fZmPA5wKBpClJXk6aPJbxu2UkZE=
X-Received: by 2002:a24:edc4:: with SMTP id r187mr3875676ith.158.1548402587357;
 Thu, 24 Jan 2019 23:49:47 -0800 (PST)
MIME-Version: 1.0
References: <20190124182712.7142-1-ard.biesheuvel@linaro.org>
 <20190124182712.7142-3-ard.biesheuvel@linaro.org> <20190125072948.GC700@sol.localdomain>
In-Reply-To: <20190125072948.GC700@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 25 Jan 2019 08:49:36 +0100
Message-ID: <CAKv+Gu_=NOiATKH1LgWYggBsfAUBU3DkDyFPv8NG=DgtA+sQyQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: arm64/crct10dif - revert to C code for short inputs
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

On Fri, 25 Jan 2019 at 08:29, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Jan 24, 2019 at 07:27:12PM +0100, Ard Biesheuvel wrote:
> > The SIMD routine ported from x86 used to have a special code path
> > for inputs < 16 bytes, which got lost somewhere along the way.
> > Instead, the current glue code aligns the input pointer to permit
> > the NEON routine to use special versions of the vld1 instructions
> > that assume 16 byte alignment, but this could result in inputs of
> > less than 16 bytes to be passed in.
>
> This description doesn't quite match the patch since the arm64 version of the
> assembly doesn't use any alignment specifiers.  I take it that actually means
> the alignment in the glue code wasn't necessary in the first place?
>

Not for correctness, but it could affect performance.

> > This not only fails the new
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
> Can you add:
>
> Fixes: 6ef5737f3931 ("crypto: arm64/crct10dif - port x86 SSE implementation to arm64")
> Cc: stable@vger.kernel.org
>

Will do

> > ---
> >  arch/arm64/crypto/crct10dif-ce-glue.c | 25 +++++---------------
> >  1 file changed, 6 insertions(+), 19 deletions(-)
> >
> > diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
> > index b461d62023f2..567c24f3d224 100644
> > --- a/arch/arm64/crypto/crct10dif-ce-glue.c
> > +++ b/arch/arm64/crypto/crct10dif-ce-glue.c
> > @@ -39,26 +39,13 @@ static int crct10dif_update(struct shash_desc *desc, const u8 *data,
> >                           unsigned int length)
> >  {
> >       u16 *crc = shash_desc_ctx(desc);
> > -     unsigned int l;
> >
> > -     if (unlikely((u64)data % CRC_T10DIF_PMULL_CHUNK_SIZE)) {
> > -             l = min_t(u32, length, CRC_T10DIF_PMULL_CHUNK_SIZE -
> > -                       ((u64)data % CRC_T10DIF_PMULL_CHUNK_SIZE));
> > -
> > -             *crc = crc_t10dif_generic(*crc, data, l);
> > -
> > -             length -= l;
> > -             data += l;
> > -     }
> > -
> > -     if (length > 0) {
> > -             if (may_use_simd()) {
> > -                     kernel_neon_begin();
> > -                     *crc = crc_t10dif_pmull(*crc, data, length);
> > -                     kernel_neon_end();
> > -             } else {
> > -                     *crc = crc_t10dif_generic(*crc, data, length);
> > -             }
> > +     if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && may_use_simd()) {
> > +             kernel_neon_begin();
> > +             *crc = crc_t10dif_pmull(*crc, data, length);
> > +             kernel_neon_end();
> > +     } else {
> > +             *crc = crc_t10dif_generic(*crc, data, length);
> >       }
> >
> >       return 0;
> > --
> > 2.17.1
> >
