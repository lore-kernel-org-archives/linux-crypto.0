From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: scompress - eliminate percpu scratch buffers
Date: Fri, 21 Jul 2017 14:09:39 +0100
Message-ID: <CAKv+Gu9h0VrDs30T0KE95BtGbL0rbksnJG_x87Vr_CObLo+szQ@mail.gmail.com>
References: <20170720114000.13840-1-ard.biesheuvel@linaro.org> <20170721124255.GA19913@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33934 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751400AbdGUNJk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 09:09:40 -0400
Received: by mail-io0-f178.google.com with SMTP id l7so22399909iof.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jul 2017 06:09:40 -0700 (PDT)
In-Reply-To: <20170721124255.GA19913@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 21 July 2017 at 13:42, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Jul 20, 2017 at 12:40:00PM +0100, Ard Biesheuvel wrote:
>> The scompress code unconditionally allocates 2 per-CPU scratch buffers
>> of 128 KB each, in order to avoid allocation overhead in the async
>> wrapper that encapsulates the synchronous compression algorithm, since
>> it may execute in atomic context.
>
> The whole point of pre-allocation is that we cannot allocate 128K
> (or 64K as it was before scomp) at run-time, and in particular,
> for IPsec which runs in softirq path.  Am I missing something?
>

Right. And is req->dst guaranteed to be assigned in that case? Because
crypto_scomp_sg_alloc() happily allocates pages and kmalloc()s the
scatterlist if req->dst == NULL.

Is there any way we could make these scratch buffers part of the
request structure instead? Or at least defer allocating them until the
first call to crypto_scomp_init_tfm()? And on top of that, we should
probably only use the per-CPU scratch buffers if
CRYPTO_TFM_REQ_MAY_SLEEP is cleared, because in that case, we are not
pre-emptible to begin with, and the concern does not apply.
