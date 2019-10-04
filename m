Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89610C47404
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EF5620700
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:53:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="o4BjnRjJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388743AbfJDNxJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:53:09 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:36251 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388270AbfJDNxJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 09:53:09 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 97685176
        for <linux-crypto@vger.kernel.org>;
        Fri, 4 Oct 2019 13:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=wcwVvtTlIWh12R9ulVoov8VPc7g=; b=o4BjnR
        jJBHIdtEaZC8/M8PLzCTVc/FI+kkmacCQ6IAW6hM5rglQz6tdZxAT+TpJobFOppY
        Lhqx/M8gXSsP4qKCyUfH7RRhdudXTxAduJgZOeFdmqwpFMX5Ru8m+ndoH3Dy4V1K
        LSyB/MgKRMKX490X9lLk287OcfCjlmTeJknHRs7cgpSV5y8FyvokMXJkZz0E/lQp
        F1G5YR2xzE93xcn5vxvi/KBHIIPcYjzx9RtPbvtMl2tVgbg+NdZAw05g3cd5rXid
        wg/p1xnDdrWS5MkxjJclVnjnwpdIfL157TZv3bI91W9Rkc+HCustQV+zO+YXA1Iu
        aVxWdwGBihLoywtQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8843cd2f (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 4 Oct 2019 13:06:12 +0000 (UTC)
Received: by mail-ot1-f48.google.com with SMTP id e11so5347319otl.5
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 06:53:06 -0700 (PDT)
X-Gm-Message-State: APjAAAWScRMmLW/dKJaXA05YcCTgKe6/+svCOcUcag978j2zpdfFIv+T
        qhG3ifsKocjdKJxto5UTTy1jCf1QDlSJB8Mnd/0=
X-Google-Smtp-Source: APXvYqyvfJGhcedjiu5OaTs1wbDqc8DtFenzVlaOJvFpe2xMKmYuQ98tG5Px30K5KSqwqL86wLPWnLGHWQxMbgm0Xq8=
X-Received: by 2002:a9d:3476:: with SMTP id v109mr11080540otb.179.1570197185350;
 Fri, 04 Oct 2019 06:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org> <20191002141713.31189-5-ard.biesheuvel@linaro.org>
In-Reply-To: <20191002141713.31189-5-ard.biesheuvel@linaro.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 4 Oct 2019 15:52:52 +0200
X-Gmail-Original-Message-ID: <CAHmME9p3a-sNp_MmMKxX7z9PsTi3DdUrVtX=X4vhr_ep=KdCJw@mail.gmail.com>
Message-ID: <CAHmME9p3a-sNp_MmMKxX7z9PsTi3DdUrVtX=X4vhr_ep=KdCJw@mail.gmail.com>
Subject: Re: [PATCH v2 04/20] crypto: arm/chacha - expose ARM ChaCha routine
 as library function
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
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

On Wed, Oct 2, 2019 at 4:17 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> Expose the accelerated NEON ChaCha routine directly as a symbol
> export so that users of the ChaCha library can use it directly.

Eric had some nice code for ChaCha for certain ARM cores that lived in
Zinc as chacha20-unrolled-arm.S. This code became active for certain
cores where NEON was bad and for cores with no NEON. The condition for
it was:

        switch (read_cpuid_part()) {
       case ARM_CPU_PART_CORTEX_A7:
       case ARM_CPU_PART_CORTEX_A5:
               /* The Cortex-A7 and Cortex-A5 do not perform well with the NEON
                * implementation but do incredibly with the scalar one and use
                * less power.
                */
               break;
       default:
               chacha20_use_neon = elf_hwcap & HWCAP_NEON;
       }

...

        for (;;) {
               if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && chacha20_use_neon &&
                   len >= CHACHA20_BLOCK_SIZE * 3 && simd_use(simd_context)) {
                       const size_t bytes = min_t(size_t, len, PAGE_SIZE);

                       chacha20_neon(dst, src, bytes, ctx->key, ctx->counter);
                       ctx->counter[0] += (bytes + 63) / 64;
                       len -= bytes;
                       if (!len)
                               break;
                       dst += bytes;
                       src += bytes;
                       simd_relax(simd_context);
               } else {
                       chacha20_arm(dst, src, len, ctx->key, ctx->counter);
                       ctx->counter[0] += (len + 63) / 64;
                       break;
               }
       }

It's another instance in which the generic code was totally optimized
out of Zinc builds.

Did these changes make it into the existing tree?
