Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9779DC4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 681A82070B
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:23:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oGZlViRm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfJDOXs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:23:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37131 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfJDOXr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:23:47 -0400
Received: by mail-wm1-f67.google.com with SMTP id f22so6077457wmc.2
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 07:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3WGYmzEHvQw0B0cgz0N8JTWopZTEatCEZHu/1WAFZ6c=;
        b=oGZlViRmgdIfBGmC1QUMvQnLGE9gpOXsUbnzQx+JD7mONCVE/5u6797xn61VDlI0/o
         p2JATTspRYwQpt5gIFKKqnn5LqNpozXukH/um6DmpZWG6DfXVp/BCovlQc0mQf3oZktM
         sZ4umM2dOcvk8bae1/C+SOyhXj6VMGzZQPPQ6zH7x+UZXvO4ckGYqy+YhX+f2xRQ3Fem
         QLWwQuCfIxR3AWHzWNxwkDuf6yqBN1ztNe6KvMS1NyN8ImFJPivj6wEXyVEjWEGfdypy
         5EsnPW37h6rK5B4l4PiAli6YJwPaT+akkDUOtC3ruAnLXa43UsJPr85HO7yj42mBLC5V
         4NmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3WGYmzEHvQw0B0cgz0N8JTWopZTEatCEZHu/1WAFZ6c=;
        b=X6zd7fIkEVf5X6X7nLPi/rph3+QFCsi4dex9bk3yz59YDM8d3IN3BjgPlnbcY4XPlP
         MCjQgghrd0T/usQW6P/h7xmIM15Xg1/5WVjYdFwoZqyDoOSv3rkjWnDwxLMr4dPzzSkS
         d9EcgtU3YJjlr8bXc56JLVxiFBprWSXo+OK1MPFwWCgQJAWpd9lNTaknt76MMCRhXliw
         5w1jGXhc+NEowI/O9p5IA0CHUB2ZMupqWzCAUD04TC+DwRkuOSS+GphedhNgBeTR56wP
         1jKO3Mu1PWCjb5oxSqLgPCqBdIBrtlcYtMugsWOzB3hn7HX+6MHWwXSX10yUBNJnCJ5q
         MJFA==
X-Gm-Message-State: APjAAAUzRzYHv9IQsFVnOGbcld4zJTtQe9t6+F7b3o6EvBnCmyliBYoi
        lrnobZUJVbXaq4iRfB15IBZLtvOkgYaJsYtZXyp/4Q==
X-Google-Smtp-Source: APXvYqziWplQoG134ULjmrlJWBnYLpq6X/QUhOV4Hj+Q8k/kxLMslUqfquaKYMDa7JqNjO8O7NvpOfGIVoGaPFAfIc4=
X-Received: by 2002:a1c:e906:: with SMTP id q6mr10448718wmc.136.1570199024530;
 Fri, 04 Oct 2019 07:23:44 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-5-ard.biesheuvel@linaro.org> <CAHmME9p3a-sNp_MmMKxX7z9PsTi3DdUrVtX=X4vhr_ep=KdCJw@mail.gmail.com>
In-Reply-To: <CAHmME9p3a-sNp_MmMKxX7z9PsTi3DdUrVtX=X4vhr_ep=KdCJw@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 4 Oct 2019 16:23:32 +0200
Message-ID: <CAKv+Gu8urn0K5pCHr4Y1qJH+8-wcQ=BXAHVSXO9xt4PwZ14xiw@mail.gmail.com>
Subject: Re: [PATCH v2 04/20] crypto: arm/chacha - expose ARM ChaCha routine
 as library function
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
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

On Fri, 4 Oct 2019 at 15:53, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Wed, Oct 2, 2019 at 4:17 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > Expose the accelerated NEON ChaCha routine directly as a symbol
> > export so that users of the ChaCha library can use it directly.
>
> Eric had some nice code for ChaCha for certain ARM cores that lived in
> Zinc as chacha20-unrolled-arm.S. This code became active for certain
> cores where NEON was bad and for cores with no NEON. The condition for
> it was:
>
>         switch (read_cpuid_part()) {
>        case ARM_CPU_PART_CORTEX_A7:
>        case ARM_CPU_PART_CORTEX_A5:
>                /* The Cortex-A7 and Cortex-A5 do not perform well with the NEON
>                 * implementation but do incredibly with the scalar one and use
>                 * less power.
>                 */
>                break;
>        default:
>                chacha20_use_neon = elf_hwcap & HWCAP_NEON;
>        }
>
> ...

How is it relevant whether the boot CPU is A5 or A7? These are bL
little cores that only implement NEON for feature parity with their bl
big counterparts, but CPU intensive tasks are scheduled on big cores,
where NEON performance is much better than scalar.

If we need a policy for this in the kernel, I'd prefer it to be one at
the arch/arm level where we disable kernel mode NEON entirely, either
via a command line option, or via a policy based on the the types of
all CPUs.

>
>         for (;;) {
>                if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && chacha20_use_neon &&
>                    len >= CHACHA20_BLOCK_SIZE * 3 && simd_use(simd_context)) {
>                        const size_t bytes = min_t(size_t, len, PAGE_SIZE);
>
>                        chacha20_neon(dst, src, bytes, ctx->key, ctx->counter);
>                        ctx->counter[0] += (bytes + 63) / 64;
>                        len -= bytes;
>                        if (!len)
>                                break;
>                        dst += bytes;
>                        src += bytes;
>                        simd_relax(simd_context);
>                } else {
>                        chacha20_arm(dst, src, len, ctx->key, ctx->counter);
>                        ctx->counter[0] += (len + 63) / 64;
>                        break;
>                }
>        }
>
> It's another instance in which the generic code was totally optimized
> out of Zinc builds.
>
> Did these changes make it into the existing tree?

I'd like to keep Eric's code, but if it is really that much faster, we
might drop it in arch/arm/lib so it supersedes the builtin code that
/dev/random uses as well.
