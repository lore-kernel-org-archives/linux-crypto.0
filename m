Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD57C47404
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 15:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 547972053B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 15:20:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c9r2HWfJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbfJGPUx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 11:20:53 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38081 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbfJGPUx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 11:20:53 -0400
Received: by mail-qk1-f193.google.com with SMTP id u186so12947159qkc.5;
        Mon, 07 Oct 2019 08:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2XCAaj09dK9PFMXyIfqQJxhCJ1/sGcx1oaMzSLYOyzU=;
        b=c9r2HWfJ2JP2aHcQEm5jXuT3Y/mgUr2wKANfK1AyOhsDWEaenY1CnitFOjhsbcSRBT
         S6daY+BV6iblJnHKW9ETaQhNNRSibq9hvg9sBIXOlyRo68iGG/wzvnxLQUvNxoZJN+2c
         62TUOMfKrNR9eRF3j3ZCp5+7voKcqxCTwADOhOVMRMCCReNiSalKL0hSNx0UgN0JyuwF
         ZnJAykWAVAgUtF3aWVjqMwWyaBFO+bHPw6OsuGFczZ2iYaffiL+70A4r4BRupDn3rv+w
         Q0shGg8vIBIr6a2Ay3HDUrhUVC1y81p0n5frQ0bObbsXEXE9/C4sOFiRlhc/XeIzDtAw
         g0hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=2XCAaj09dK9PFMXyIfqQJxhCJ1/sGcx1oaMzSLYOyzU=;
        b=HfmuubfpjXwPRg5mliFr3eaM6vfA0o5P3k9xSKuXbYYo2Q622/uFWsksAliU+Q1x/W
         oz4+7CX9fN+eb4t2MzoV8dwSmcXt1InrvOayPnH0juX+Ryk6bhECe3ijQRmZ59GmsDD7
         vOxusv7oOAUSzNdCS84l3ccNYKDzw6+0UTjZ1u3C8prcp0BH/fCw2w5d7tgnWdlqM+dh
         8BGZZEpkPyICOiC4eQqUbmf58jax3xZ4uCAlHMesJ1FCc2F4V5a6ENLyEfScBf0fFBJj
         IlTwldWymfRyn/Jkzgg7Uo0UrUfudj3omIY8gtdrLDrc4I6FrUqlH1+O+6Qfc+QdSk1O
         66ig==
X-Gm-Message-State: APjAAAUUiSzdBueZAIjPJS4X/eti9Yfum0tGGOGnDI1lU2BY/mnqb5qr
        eWcAHDiiPxb4QSbJRpvUQHw=
X-Google-Smtp-Source: APXvYqxjrrymmH4+uWeXv9AswdZK3ZCmEZ6MFpdaPlUexTXm1g46iohpHZkEynqVbiwm2FyGR2odCQ==
X-Received: by 2002:a37:5cc1:: with SMTP id q184mr24265246qkb.212.1570461651900;
        Mon, 07 Oct 2019 08:20:51 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id c185sm7602621qkf.122.2019.10.07.08.20.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 08:20:51 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Mon, 7 Oct 2019 11:20:49 -0400
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 5.4 regression fix] x86/boot: Provide memzero_explicit
Message-ID: <20191007152049.GA384920@rani.riverdale.lan>
References: <20191007134724.4019-1-hdegoede@redhat.com>
 <20191007140022.GA29008@gmail.com>
 <1dc3c53d-785e-f9a4-1b4c-3374c94ae0a7@redhat.com>
 <20191007142230.GA117630@gmail.com>
 <2982b666-e310-afb7-40eb-e536ce95e23d@redhat.com>
 <20191007144600.GB59713@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191007144600.GB59713@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 07, 2019 at 04:46:00PM +0200, Ingo Molnar wrote:
> 
> * Hans de Goede <hdegoede@redhat.com> wrote:
> 
> > Hi,
> > 
> > On 07-10-2019 16:22, Ingo Molnar wrote:
> > > 
> > > * Hans de Goede <hdegoede@redhat.com> wrote:
> > > 
> > > > Hi,
> > > > 
> > > > On 07-10-2019 16:00, Ingo Molnar wrote:
> > > > > 
> > > > > * Hans de Goede <hdegoede@redhat.com> wrote:
> > > > > 
> > > > > > The purgatory code now uses the shared lib/crypto/sha256.c sha256
> > > > > > implementation. This needs memzero_explicit, implement this.
> > > > > > 
> > > > > > Reported-by: Arvind Sankar <nivedita@alum.mit.edu>
> > > > > > Fixes: 906a4bb97f5d ("crypto: sha256 - Use get/put_unaligned_be32 to get input, memzero_explicit")
> > > > > > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> > > > > > ---
> > > > > > Changes in v2:
> > > > > > - Add barrier_data() call after the memset, making the function really
> > > > > >     explicit. Using barrier_data() works fine in the purgatory (build)
> > > > > >     environment.
> > > > > > ---
> > > > > >    arch/x86/boot/compressed/string.c | 6 ++++++
> > > > > >    1 file changed, 6 insertions(+)
> > > > > > 
> > > > > > diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
> > > > > > index 81fc1eaa3229..654a7164a702 100644
> > > > > > --- a/arch/x86/boot/compressed/string.c
> > > > > > +++ b/arch/x86/boot/compressed/string.c
> > > > > > @@ -50,6 +50,12 @@ void *memset(void *s, int c, size_t n)
> > > > > >    	return s;
> > > > > >    }
> > > > > > +void memzero_explicit(void *s, size_t count)
> > > > > > +{
> > > > > > +	memset(s, 0, count);
> > > > > > +	barrier_data(s);
> > > > > > +}
> > > > > 
> > > > > So the barrier_data() is only there to keep LTO from optimizing out the
> > > > > seemingly unused function?
> > > > 
> > > > I believe that Stephan Mueller (who suggested adding the barrier)
> > > > was also worried about people using this as an example for other
> > > > "explicit" functions which actually might get inlined.
> > > > 
> > > > This is not so much about protecting against LTO as it is against
> > > > protecting against inlining, which in this case boils down to the
> > > > same thing. Also this change makes the arch/x86/boot/compressed/string.c
> > > > and lib/string.c versions identical which seems like a good thing to me
> > > > (except for the code duplication part of it).
> > > > 
> > > > But I agree a comment would be good, how about:
> > > > 
> > > > void memzero_explicit(void *s, size_t count)
> > > > {
> > > > 	memset(s, 0, count);
> > > > 	/* Avoid the memset getting optimized away if we ever get inlined */
> > > > 	barrier_data(s);
> > > > }
> > > 
> > > Well, the standard construct for preventing inlining would be 'noinline',
> > > right? Any reason that wouldn't work?
> > 
> > Good question. I guess the worry is that modern compilers are getting
> > more aggressive with optimizing and then even if not inlined if the
> > function gets compiled in the same scope, then the compiler might
> > still notice it is only every writing to the memory passed in; and
> > then optimize it away of the write happens to memory which lifetime
> > ends immediately afterwards. I mean removing the call is not inlining,
> > so compiler developers might decide that that is still fine to do.
> > 
> > IMHO with trickycode like this is is best to just use the proven
> > version from lib/string.c
> > 
> > I guess I made the comment to specific though, so how about:
> > 
> > void memzero_explicit(void *s, size_t count)
> > {
> > 	memset(s, 0, count);
> > 	/* Tell the compiler to never remove / optimize away the memset */
> > 	barrier_data(s);
> > }
> 
> Ok, I guess this will work.
> 
> Thanks,
> 
> 	Ingo

With the barrier in there, is there any reason to *not* inline the
function? barrier_data() is an asm statement that tells the compiler
that the asm uses the memory that was set to zero, thus preventing it
from removing the memset even if nothing else uses that memory later. A
more detailed comment is there in compiler-gcc.h. I can't see why it
wouldn't work even if it were inlined.

If the function can indeed be inlined, we could just make the common
implementation a macro and avoid duplicating it? As mentioned in another
mail, we otherwise will likely need another duplicate implementation for
arch/s390/purgatory as well.
