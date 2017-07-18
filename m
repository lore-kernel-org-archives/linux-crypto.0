From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 2/2] crypto: arm64/ghash - add NEON accelerated
 fallback for 64-bit PMULL
Date: Tue, 18 Jul 2017 10:56:54 +0100
Message-ID: <CAKv+Gu8qeaL+YdWNtOhV7tGM3s3eykwAh6Vf2stB5nHpMYoHyQ@mail.gmail.com>
References: <20170704234319.8398-1-ard.biesheuvel@linaro.org>
 <20170704234319.8398-2-ard.biesheuvel@linaro.org> <20170718094946.GA6347@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Steve Capper <steve.capper@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:34906 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751592AbdGRJ4z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 05:56:55 -0400
Received: by mail-io0-f178.google.com with SMTP id k71so10557138iod.2
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 02:56:55 -0700 (PDT)
In-Reply-To: <20170718094946.GA6347@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 18 July 2017 at 10:49, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Jul 05, 2017 at 12:43:19AM +0100, Ard Biesheuvel wrote:
>> Implement a NEON fallback for systems that do support NEON but have
>> no support for the optional 64x64->128 polynomial multiplication
>> instruction that is part of the ARMv8 Crypto Extensions. It is based
>> on the paper "Fast Software Polynomial Multiplication on ARM Processors
>> Using the NEON Engine" by Danilo Camara, Conrado Gouvea, Julio Lopez and
>> Ricardo Dahab (https://hal.inria.fr/hal-01506572), but has been reworked
>> extensively for the AArch64 ISA.
>>
>> On a low-end core such as the Cortex-A53 found in the Raspberry Pi3, the
>> NEON based implementation is 4x faster than the table based one, and
>> is time invariant as well, making it less vulnerable to timing attacks.
>> When combined with the bit-sliced NEON implementation of AES-CTR, the
>> AES-GCM performance increases by ~2x (from 58 to 30 cycles per byte).
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> This patch does not apply against cryptodev.
>

Yeah, it implements a non-SIMD fallback which depends on the AES
refactor series.
