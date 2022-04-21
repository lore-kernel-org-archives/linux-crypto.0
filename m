Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF193C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Apr 2022 21:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442274AbiDUWCg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Apr 2022 18:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442261AbiDUWCf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Apr 2022 18:02:35 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3896E4EDD8
        for <linux-crypto@vger.kernel.org>; Thu, 21 Apr 2022 14:59:44 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id c15so7354844ljr.9
        for <linux-crypto@vger.kernel.org>; Thu, 21 Apr 2022 14:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3OrvLHf3GpuhOpGqRZvIaFvfjcZtxElifjkh9a5e/RY=;
        b=MkcoCbSM3rFOOlEq6X9/xjYiCMXQ6iJCCXzJMz2dflZ+OwjqRSb6V2RZucfs0g6ZY3
         hQoB6pIzzIfzgSba02fM78n4ykQbxE7Z1l0V/AFtmrFarHc9GjwzCl+G/Y7wmGlLyp3X
         HOu3pmW6GK7ibPxi03I3X4q7rX2vEQoWOyoT5lFTlfGNlVnTQFMhQZZxlFgkt3BxPiJ/
         Hy8FkgoMgsbVYI4l/b9OUUQcbYArrGDPVgYXoVtx1uoJtKjdFCGe6sy63XBKDxEPzs/A
         OC2mysrOaK+zj2yAMaEDLrljDv887pT6ngNVQwgBUYJnCR8PDg47xwu2cSXenK9obKXh
         JqLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3OrvLHf3GpuhOpGqRZvIaFvfjcZtxElifjkh9a5e/RY=;
        b=3LAR4DU0pFGKdA2KmZeVRz9yYVRtjjlMCYjMj/kyScOwR1OuoNzyryxU7I4K5/jHjl
         nOcMW5Pv8a13LYx3pjwTOuyO3F1dSUfqqri4McXJq5yKoNyycvQ4cP6oerN6ga4Abkm+
         nYIjLveEscJmQ68892AD9mHky1beXI2w1vZyuVm8IUkMkbCFYF4PAh2JfQLsfcP6o/vo
         QL1WD94P6XoALVMLDKnmTJJ9//gnJIrRJaCx0d/dLrj5VF+GpyjGJ5Kv5VvXWT45488E
         FbTK+36n1kdXr07/7PdrBIoiDh/EboVC4X2qMQ51WZnxX4L2jXwshh425HbCI1yVcT6S
         +JAw==
X-Gm-Message-State: AOAM532vivrFDXG2NzkHRQMZnifMYyKg+HwS3FP6bYrkZ7Zpv4LUu0yz
        2+2dnF69o6eFkr0VCFrRVhentGQd1E0Vcu8IYIaCLg==
X-Google-Smtp-Source: ABdhPJzDWtgoQlxNqH2HzoWtEGAm6VfPZIcTXa2M7zOv/y3eVXW30mWsbk+MwLyOUowcuNidOQi+mLqONCVn1oWVa5U=
X-Received: by 2002:a05:651c:b2c:b0:24d:c72b:ebb4 with SMTP id
 b44-20020a05651c0b2c00b0024dc72bebb4mr925411ljr.190.1650578382287; Thu, 21
 Apr 2022 14:59:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220412172816.917723-1-nhuck@google.com> <20220412172816.917723-5-nhuck@google.com>
 <Yl3+wqeOw2/jRgOC@sol.localdomain>
In-Reply-To: <Yl3+wqeOw2/jRgOC@sol.localdomain>
From:   Nathan Huckleberry <nhuck@google.com>
Date:   Thu, 21 Apr 2022 16:59:31 -0500
Message-ID: <CAJkfWY51QXF3Mf6jfNc54yRPhR5J9azyaXkkd2=x6Q-RkfdBsA@mail.gmail.com>
Subject: Re: [PATCH v4 4/8] crypto: x86/aesni-xctr: Add accelerated
 implementation of XCTR
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 18, 2022 at 7:13 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Apr 12, 2022 at 05:28:12PM +0000, Nathan Huckleberry wrote:
> > diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
> > index 363699dd7220..ce17fe630150 100644
> > --- a/arch/x86/crypto/aesni-intel_asm.S
> > +++ b/arch/x86/crypto/aesni-intel_asm.S
> > @@ -2821,6 +2821,76 @@ SYM_FUNC_END(aesni_ctr_enc)
> >
> >  #endif
> >
> > +#ifdef __x86_64__
> > +/*
> > + * void aesni_xctr_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
> > + *                 size_t len, u8 *iv, int byte_ctr)
> > + */
> > +SYM_FUNC_START(aesni_xctr_enc)
> > +     FRAME_BEGIN
> > +     cmp $16, LEN
> > +     jb .Lxctr_ret
> > +     shr     $4, %arg6
> > +     movq %arg6, CTR
> > +     mov 480(KEYP), KLEN
> > +     movups (IVP), IV
> > +     cmp $64, LEN
> > +     jb .Lxctr_enc_loop1
> > +.align 4
> > +.Lxctr_enc_loop4:
> > +     movaps IV, STATE1
> > +     vpaddq ONE(%rip), CTR, CTR
> > +     vpxor CTR, STATE1, STATE1
> > +     movups (INP), IN1
> > +     movaps IV, STATE2
> > +     vpaddq ONE(%rip), CTR, CTR
> > +     vpxor CTR, STATE2, STATE2
> > +     movups 0x10(INP), IN2
> > +     movaps IV, STATE3
> > +     vpaddq ONE(%rip), CTR, CTR
> > +     vpxor CTR, STATE3, STATE3
> > +     movups 0x20(INP), IN3
> > +     movaps IV, STATE4
> > +     vpaddq ONE(%rip), CTR, CTR
> > +     vpxor CTR, STATE4, STATE4
> > +     movups 0x30(INP), IN4
> > +     call _aesni_enc4
> > +     pxor IN1, STATE1
> > +     movups STATE1, (OUTP)
> > +     pxor IN2, STATE2
> > +     movups STATE2, 0x10(OUTP)
> > +     pxor IN3, STATE3
> > +     movups STATE3, 0x20(OUTP)
> > +     pxor IN4, STATE4
> > +     movups STATE4, 0x30(OUTP)
> > +     sub $64, LEN
> > +     add $64, INP
> > +     add $64, OUTP
> > +     cmp $64, LEN
> > +     jge .Lxctr_enc_loop4
> > +     cmp $16, LEN
> > +     jb .Lxctr_ret
> > +.align 4
> > +.Lxctr_enc_loop1:
> > +     movaps IV, STATE
> > +     vpaddq ONE(%rip), CTR, CTR
> > +     vpxor CTR, STATE1, STATE1
> > +     movups (INP), IN
> > +     call _aesni_enc1
> > +     pxor IN, STATE
> > +     movups STATE, (OUTP)
> > +     sub $16, LEN
> > +     add $16, INP
> > +     add $16, OUTP
> > +     cmp $16, LEN
> > +     jge .Lxctr_enc_loop1
> > +.Lxctr_ret:
> > +     FRAME_END
> > +     RET
> > +SYM_FUNC_END(aesni_xctr_enc)
> > +
> > +#endif
>
> Sorry, I missed this file.  This is the non-AVX version, right?  That means that
> AVX instructions, i.e. basically anything instruction starting with "v", can't
> be used here.  So the above isn't going to work.  (There might be a way to test
> this with QEMU; maybe --cpu-type=Nehalem without --enable-kvm?)
>
> You could rewrite this without using AVX instructions.  However, polyval-clmulni
> is broken in the same way; it uses AVX instructions without checking whether
> they are available.  But your patchset doesn't aim to provide a non-AVX polyval
> implementation at all.  So even if you got the non-AVX XCTR working, it wouldn't
> be paired with an accelerated polyval.
>
> So I think you should just not provide non-AVX versions for now.  That would
> mean:
>
>         1.) Drop the change to aesni-intel_asm.S
>         2.) Don't register the AES XCTR algorithm unless AVX is available
>             (in addition to AES-NI)

Is there a preferred way to conditionally register xctr? It looks like
aesni-intel_glue.c registers a default implementation for all the
algorithms in the array, then better versions are enabled depending on
cpu features. Should I remove xctr from the list of other algorithms
and register it separately?

>         3.) Don't register polyval-clmulni unless AVX is available
>             (in addition to CLMUL-NI)
>
> - Eric
