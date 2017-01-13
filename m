From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Subject: Re: [RFC PATCH 5/6] crypto: aesni-intel - Add bulk request support
Date: Fri, 13 Jan 2017 12:27:28 +0100
Message-ID: <CAAUqJDuAJqGxqnXPUC4OEh2=oTHU4O6LHrXu7rK6jZni-hueoQ@mail.gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com> <c32a28630157c619ac2a7c851be586e72f193c68.1484215956.git.omosnacek@gmail.com>
 <20170113031933.GA4956@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33402 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751424AbdAML1v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 06:27:51 -0500
Received: by mail-lf0-f68.google.com with SMTP id k62so5281458lfg.0
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jan 2017 03:27:50 -0800 (PST)
In-Reply-To: <20170113031933.GA4956@zzz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Eric,

2017-01-13 4:19 GMT+01:00 Eric Biggers <ebiggers3@gmail.com>:
> To what extent does the performance benefit of this patchset result from just
> the reduced numbers of calls to kernel_fpu_begin() and kernel_fpu_end()?
>
> If it's most of the benefit, would it make any sense to optimize
> kernel_fpu_begin() and kernel_fpu_end() instead?
>
> And if there are other examples besides kernel_fpu_begin/kernel_fpu_end where
> the bulk API would provide a significant performance boost, can you mention
> them?

In the case of AES-NI ciphers, this is the only benefit. However, this
change is not intended solely (or primarily) for AES-NI ciphers, but
also for other drivers that have a high per-request overhead.

This patchset is in fact a reaction to Binoy Jayan's efforts (see
[1]). The problem with small requests to HW crypto drivers comes up
for example in Qualcomm's Android [2], where they actually hacked
together their own version of dm-crypt (called 'dm-req-crypt'), which
in turn used a driver-specific crypto mode, which does the IV
generation on its own, and thereby is able to process several sectors
at once. The goal is to extend the crypto API so that vendors don't
have to roll out their own workarounds to have efficient disk
encryption.

> Interestingly, the arm64 equivalent to kernel_fpu_begin()
> (kernel_neon_begin_partial() in arch/arm64/kernel/fpsimd.c) appears to have an
> optimization where the SIMD registers aren't saved if they were already saved.
> I wonder why something similar isn't done on x86.

AFAIK, there can't be done much about the kernel_fpu_* functions, see e.g. [3].

Regards,
Ondrej

[1] https://lkml.org/lkml/2016/12/20/111
[2] https://nelenkov.blogspot.com/2015/05/hardware-accelerated-disk-encryption-in.html
[3] https://lkml.org/lkml/2016/12/21/354

>
> Eric
