Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064A1C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Oct 2022 23:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiJQXjE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Oct 2022 19:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiJQXiy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Oct 2022 19:38:54 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF15857FA
        for <linux-crypto@vger.kernel.org>; Mon, 17 Oct 2022 16:38:38 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id bp11so20908933wrb.9
        for <linux-crypto@vger.kernel.org>; Mon, 17 Oct 2022 16:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ab8e8SMdV/PMxntneBmOuTYsu5dIocv7IIIRxn/jwGU=;
        b=AxOFHsoIKvP7ysD7tzrCFiEpFNFKWLTlRj8jM8+8JPqgP6LM7SbMGw5w2QYLqfHWGq
         txOceHGNtwyPyi2DSDUcIRWmvm5hc4w/3f+gFwaZzRKyVD5lx7D+mcjw023+uujfBNVQ
         uLsRGaBA3svAV6n5xS9slXluhHbhOg8F1Ys1lsrmqw22Pz2cjJVWgeu0yGKiCqpflhhD
         VT9VCm2LouZBuunSikA6NEKj/WwZmLt/4y8zj9Gsty4UDYuMXwK6AOEIvDuvh+s6arl+
         uQHSv0fixWyaT/IQIy4YcEOg7g4QLB1pMyh/XCa11ZHx/S9OVn1d0jjQ0+Ifskuci3fw
         wUDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ab8e8SMdV/PMxntneBmOuTYsu5dIocv7IIIRxn/jwGU=;
        b=SxF1d1e+Q7xHqmKN8+FG8E32MAV4lKb4oXjYFJM8vAyzxZZyrcm7wo/nEB4szCahHn
         BBm7C80vY+QjldqdsGBoD2MpNJTLnS9yTkoxeU0zzfbC872Ltpj6hPsyDOCNcrBEvISw
         ewndccSoDFBsFxB226zGs7pt9kmS3zvfye8KdIlmsu+ed9nBcEw8M2/4aYW1XpfNJ609
         nzjdremiRupR7lGjXnkKXdu+dCHIfwcNX5MqYklCzFMjuMVHvpjEbWuSs1tDkkfcJU65
         vAsSw0zrcmOpxuLzY7z04/CP4/73cYu60Zw6FuBSsnZZycOT08tInDfABkDAGTM3hh/y
         FjpQ==
X-Gm-Message-State: ACrzQf36x0Ct5EGHKjF6S2IGdfRP978Z47CQvavuPXIlr9FkfUy6ZF7V
        mav7mAOhNSXVdbNU/AHyYac2WAo6ryUhoEFj7Q0BYA==
X-Google-Smtp-Source: AMsMyM6cDzWa62kol1J9oBTBfz70biRId88baWm1Hx3dZgUJogBdkdCDQVXwT4O1LcvykbnI0RLK2e/sNbGOm2TIx4I=
X-Received: by 2002:a5d:4889:0:b0:22b:214:38dd with SMTP id
 g9-20020a5d4889000000b0022b021438ddmr136371wrq.32.1666049917198; Mon, 17 Oct
 2022 16:38:37 -0700 (PDT)
MIME-Version: 1.0
References: <20221017222620.715153-1-nhuck@google.com> <Y03fBQPM7h7+cfGK@sol.localdomain>
In-Reply-To: <Y03fBQPM7h7+cfGK@sol.localdomain>
From:   Nathan Huckleberry <nhuck@google.com>
Date:   Mon, 17 Oct 2022 16:38:25 -0700
Message-ID: <CAJkfWY5CXFQfSkM=U6u_DdLjDyLDoubqy2FeSZg5k7GBkOTnsQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: x86/polyval - Fix crashes when keys are not
 16-byte aligned
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Bruno Goncalves <bgoncalv@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 17, 2022 at 4:02 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Oct 17, 2022 at 03:26:20PM -0700, Nathan Huckleberry wrote:
> > The key_powers array is not guaranteed to be 16-byte aligned, so using
> > movaps to operate on key_powers is not allowed.
> >
> > Switch movaps to movups.
> >
> > Fixes: 34f7f6c30112 ("crypto: x86/polyval - Add PCLMULQDQ accelerated implementation of POLYVAL")
> > Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
> > Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> > ---
> >  arch/x86/crypto/polyval-clmulni_asm.S | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/crypto/polyval-clmulni_asm.S b/arch/x86/crypto/polyval-clmulni_asm.S
> > index a6ebe4e7dd2b..32b98cb53ddf 100644
> > --- a/arch/x86/crypto/polyval-clmulni_asm.S
> > +++ b/arch/x86/crypto/polyval-clmulni_asm.S
> > @@ -234,7 +234,7 @@
> >
> >       movups (MSG), %xmm0
> >       pxor SUM, %xmm0
> > -     movaps (KEY_POWERS), %xmm1
> > +     movups (KEY_POWERS), %xmm1
> >       schoolbook1_noload
> >       dec BLOCKS_LEFT
> >       addq $16, MSG
>
> I thought that crypto_tfm::__crt_ctx is guaranteed to be 16-byte aligned,
> and that the x86 AES code relies on that property.
>
> But now I see that actually the x86 AES code manually aligns the context.
> See aes_ctx() in arch/x86/crypto/aesni-intel_glue.c.
>
> Did you consider doing the same for polyval?

I'll submit a v2 aligning the tfm_ctx. I think that makes more sense
than working on unaligned keys.

Is there a need to do the same changes on arm64? The keys are also
unaligned there.

>
> If you do prefer this way, it would be helpful to leave a comment for
> schoolbook1_iteration that mentions that the unaligned access support of
> vpclmulqdq is being relied on, i.e. pclmulqdq wouldn't work.
>
> - Eric

Thanks,
Huck
