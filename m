Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0167FC4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA298205C9
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:54:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pSVLc3Vn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388697AbfJDNyk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:54:40 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36154 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388673AbfJDNyk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 09:54:40 -0400
Received: by mail-wm1-f65.google.com with SMTP id m18so5960834wmc.1
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 06:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mxiG4+eAUcxTBvy+3WnGcv/0+TrkgFDTxY+qtOGoJvc=;
        b=pSVLc3VnNrEufYC44ZtyypRAY3CXDOOkGEwz8UpWhsvlOUWjyabzJWpX9cJ+kCvJwP
         pLSBaK/PjGe+5sTtYS/kKFwUt7fWdXNMtaJ/8BJ7WjN3yahnZhLNGTXM7I7JklaxUARJ
         rP9XK3TY9RnMYxoo2+LuNB+hYTigXA9aZLlJVETRfu5xeVe7ve5M5aJU/XznlazacHM4
         4wSOHizwNfuO0h1W3bBli+QJe3SVf+QRIvzpKnpCORt8oAYlJDxBXpXdXIstEbQjJF6o
         ywIBwgkJVx6RFRUvp3q70VKJF2adIDVq3YyPtYJ4dPLJR+7Vk1RbmepmjanKvhZMhrq3
         tyyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mxiG4+eAUcxTBvy+3WnGcv/0+TrkgFDTxY+qtOGoJvc=;
        b=I/n10frsNR9LZM68pVfNRhz3xmnOqNX8PV549hiAllUlG21IPb0rfUJ/IbCFqZcVu1
         6FmxCOSXUFbxjVNcFjkKB7ne5RjGdWPhWA5VCKBjx95RX/pL+4khxlmwl/Igi0xWpqQj
         4bz4p5OdDJRqSpPEc2EzpTysCkUdXVYfueVedVcKmJxwlMV2fnXcI79M84Fb17KJpRbZ
         50pNr5QXCYSD7cucQJfddE/jxzmZp3KexbWEUJIopjJLQ2vCwxpomMgI7Ll5QMeiLwRk
         sZcFnJUa/Ldcej95k20d1epq7FRcmwUaNrAyDrX+6zZxKeYJGMBPkJx5ZXErO+wM1BZw
         0y3A==
X-Gm-Message-State: APjAAAVFIo/iIgX6zRILSyVl4lA7u+V/wyaESCns5XF+9OI2Bdgiu38Q
        hyu5yv0ACWC4VpE49FmbXenxumE1xIKRyYVREfE5kQ==
X-Google-Smtp-Source: APXvYqytG2rI9ZknEsW9ECUVcCAqmQ+fqfO9voWoReC1I6h93Qt48+Q4p7qwPUg0msaiOGDYx4z1cWv9CJe42cl7W3E=
X-Received: by 2002:a1c:3cc3:: with SMTP id j186mr10419225wma.119.1570197277832;
 Fri, 04 Oct 2019 06:54:37 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-3-ard.biesheuvel@linaro.org> <20191004133649.GC112631@zx2c4.com>
In-Reply-To: <20191004133649.GC112631@zx2c4.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 4 Oct 2019 15:54:25 +0200
Message-ID: <CAKv+Gu_Di8yC70PpkbJOZuUPr0aGGPsyt=m8Gyu6a_eHEKwaTw@mail.gmail.com>
Subject: Re: [PATCH v2 02/20] crypto: x86/chacha - expose SIMD ChaCha routine
 as library function
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 4 Oct 2019 at 15:36, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Wed, Oct 02, 2019 at 04:16:55PM +0200, Ard Biesheuvel wrote:
> > Wire the existing x86 SIMD ChaCha code into the new ChaCha library
> > interface.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  arch/x86/crypto/chacha_glue.c | 36 ++++++++++++++++++++
> >  crypto/Kconfig                |  1 +
> >  include/crypto/chacha.h       |  6 ++++
> >  3 files changed, 43 insertions(+)
> >
> > diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
> > index bc62daa8dafd..fd9ef42842cf 100644
> > --- a/arch/x86/crypto/chacha_glue.c
> > +++ b/arch/x86/crypto/chacha_glue.c
> > @@ -123,6 +123,42 @@ static void chacha_dosimd(u32 *state, u8 *dst, const u8 *src,
> >       }
> >  }
> >
> > +void hchacha_block(const u32 *state, u32 *stream, int nrounds)
> > +{
> > +     state = PTR_ALIGN(state, CHACHA_STATE_ALIGN);
> > +
> > +     if (!crypto_simd_usable()) {
> > +             hchacha_block_generic(state, stream, nrounds);
> > +     } else {
> > +             kernel_fpu_begin();
> > +             hchacha_block_ssse3(state, stream, nrounds);
> > +             kernel_fpu_end();
> > +     }
> > +}
> > +EXPORT_SYMBOL(hchacha_block);
>
> Please correct me if I'm wrong:
>
> The approach here is slightly different from Zinc. In Zinc, I had one
> entry point that conditionally called into the architecture-specific
> implementation, and I did it inline using #includes so that in some
> cases it could be optimized out.
>
> Here, you override the original symbol defined by the generic module
> from the architecture-specific implementation, and in there you decide
> which way to branch.
>
> Your approach has the advantage that you don't need to #include a .c
> file like I did, an ugly yet very effective approach.
>
> But it has two disadvantages:
>
> 1. For architecture-specific code that _always_ runs, such as the
>   MIPS32r2 implementation of chacha, the compiler no longer has an
>   opportunity to remove the generic code entirely from the binary,
>   which under Zinc resulted in a smaller module.
>

It does. If you don't call hchacha_block_generic() in your code, the
library that exposes it never gets loaded in the first place.

Note that in this particular case, hchacha_block_generic() is exposed
by code that is always builtin so it doesn't matter.

> 2. The inliner can't make optimizations for that call.
>
> Disadvantage (2) might not make much of a difference. Disadvantage (1)
> seems like a bigger deal. However, perhaps the linker is smart and can
> remove the code and symbol? Or if not, is there a way to make the linker
> smart? Or would all this require crazy LTO which isn't going to happen
> any time soon?
