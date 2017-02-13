From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v3] crypto: algapi - make crypto_xor() and crypto_inc()
 alignment agnostic
Date: Mon, 13 Feb 2017 22:55:20 +0100
Message-ID: <CAHmME9o9Rg2bcb1dibAyTUCSYGuzicSU__62P_G9G8ARJkgs=Q@mail.gmail.com>
References: <1486289172-18604-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers3@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:58169 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753095AbdBMVzX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Feb 2017 16:55:23 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 9c3b807a
        for <linux-crypto@vger.kernel.org>;
        Mon, 13 Feb 2017 21:41:14 +0000 (UTC)
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id dafb15f9 (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 13 Feb 2017 21:41:14 +0000 (UTC)
Received: by mail-oi0-f53.google.com with SMTP id s203so58990253oie.1
        for <linux-crypto@vger.kernel.org>; Mon, 13 Feb 2017 13:55:21 -0800 (PST)
In-Reply-To: <1486289172-18604-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Feb 5, 2017 at 11:06 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> +       if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
> +           !((unsigned long)b & (__alignof__(*b) - 1)))

Why not simply use the IS_ALIGNED macro?

Also, are you might consider checking to see if this is a constant, so
that you can avoid an unnecessary branch. Alternatively, if you want
to use the branch, I'd be interested in you writing back saying, "I
tested both cases, and branching is faster than always using the slow
unaligned path."
> +               while (((unsigned long)dst & (relalign - 1)) && len > 0) {

IS_ALIGNED

> +static inline void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
> +{
> +       if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
> +           __builtin_constant_p(size) &&
> +           (size % sizeof(unsigned long)) == 0) {

You can expand this condition to be:

if ( (is_constant(size) && size%sizeof(ulong)==0) &&
(efficient_unaligned || (is_constant(dst) && is_constant(src) &&
is_aligned(dst) && is_aligned(src))) )

It might seem complex, but it all gets compiled out.
