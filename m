Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF671C4360C
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 02:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E7932082F
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 02:42:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Ly8deA0h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbfI3CmW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Sep 2019 22:42:22 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:44183 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728755AbfI3CmW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Sep 2019 22:42:22 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 2a434cd0
        for <linux-crypto@vger.kernel.org>;
        Mon, 30 Sep 2019 01:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=5Vsj6EXf0jjuUV8wzSrKzacZD/I=; b=Ly8deA
        0hY4MSQuTheWCk3bmmN21Sjy3I48IOn71+eHa55jX16q+7HZt7tbFKc4z96WzkOu
        zGWhPv2JO3nUhxxL+hO6JmfDMS2xTWdS821s5IKBZfkVeCSBmbtlawmn8P5viXp6
        PT6yFj62EHLORtVyPjTWGYHETLRcSTTYJ/6Y3YMcdQCOnF2ngiUQ0+9yTq+yUXMu
        BL28GyI1sLi/GlUzg2r4JUA2B++BYQeIpnhj3mgLfkROB+D568HTC0Sfk+FO7fPr
        w2Xjz5QYMKLjyceyr+1gSkuSoKxgHkyJVR+f1Z3QCZVFOxRyjg0BGB/QOqwWE3UC
        JvDHwerwmpBxE9Ww==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 36046498 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 30 Sep 2019 01:55:59 +0000 (UTC)
Received: by mail-oi1-f179.google.com with SMTP id m16so9821796oic.5
        for <linux-crypto@vger.kernel.org>; Sun, 29 Sep 2019 19:42:18 -0700 (PDT)
X-Gm-Message-State: APjAAAVfQQtnF1haWGsPeqVBZ9wy0DbNrkhpWpo2Hf4REuR1+sSiZegu
        CYN/VafFaY3fNpo7foP7RKbSh0yjPqFbxu8G014=
X-Google-Smtp-Source: APXvYqwLF+Z7w3gXasKuLLqyupaAjaq1ZtsrS9U+xQ2bzeQ6aNm4VKt/omJ+RR9Jb1U8RiIeyWwI0yDKS/koJ/s8VBY=
X-Received: by 2002:a54:4807:: with SMTP id j7mr15044988oij.122.1569811337466;
 Sun, 29 Sep 2019 19:42:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190929173850.26055-1-ard.biesheuvel@linaro.org> <20190929173850.26055-12-ard.biesheuvel@linaro.org>
In-Reply-To: <20190929173850.26055-12-ard.biesheuvel@linaro.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 30 Sep 2019 04:42:06 +0200
X-Gmail-Original-Message-ID: <CAHmME9q=72-iKnHh0nB2+mO3uNoUerOVoHDY=eBKSoPB32XSsA@mail.gmail.com>
Message-ID: <CAHmME9q=72-iKnHh0nB2+mO3uNoUerOVoHDY=eBKSoPB32XSsA@mail.gmail.com>
Subject: Re: [RFC PATCH 11/20] crypto: BLAKE2s - x86_64 implementation
To:     Sebastian Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
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
        Martin Willi <martin@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Sebastian, Thomas,

Take a look at the below snippet from this patch.

I had previously put quite some effort into the simd_get, simd_put,
simd_relax mechanism, so that the simd state could be persisted during
both several calls to the same function and within long loops like
below, with simd_relax existing to reenable preemption briefly if
things were getting out of hand. Ard got rid of this and has moved the
kernel_fpu_begin and kernel_fpu_end calls into the inner loop:

On Sun, Sep 29, 2019 at 7:39 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> +       for (;;) {
> +               const size_t blocks = min_t(size_t, nblocks,
> +                                           PAGE_SIZE / BLAKE2S_BLOCK_SIZE);
> +
> +               kernel_fpu_begin();
> +               if (IS_ENABLED(CONFIG_AS_AVX512) && blake2s_use_avx512)
> +                       blake2s_compress_avx512(state, block, blocks, inc);
> +               else
> +                       blake2s_compress_avx(state, block, blocks, inc);
> +               kernel_fpu_end();
> +
> +               nblocks -= blocks;
> +               if (!nblocks)
> +                       break;
> +               block += blocks * BLAKE2S_BLOCK_SIZE;
> +       }
> +       return true;
> +}

I'm wondering if on modern kernels this is actually fine and whether
my simd_get/put/relax thing no longer has a good use case.
Specifically, I recall last year there were a lot of patches and
discussions about doing FPU register restoration lazily -- on context
switch or the like. Did those land? Did the theory of action work out
in the end?

Regards,
Jason
