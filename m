From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/6] crypto: ARM/arm64 - AES and ChaCha20 updates for v4.11
Date: Mon, 9 Jan 2017 09:21:26 +0000
Message-ID: <CAKv+Gu8=FjE7Gy8enNqAZ2NqaWXmcjf7bu77UcArgbZf8-Giig@mail.gmail.com>
References: <1483381268-12987-1-git-send-email-ard.biesheuvel@linaro.org> <CAKv+Gu8wWW-c6dYcsRtD8LK4nrP=6pQwb63OkJTyGTYhK3Ryyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:38413 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750817AbdAIJV2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2017 04:21:28 -0500
Received: by mail-it0-f44.google.com with SMTP id x2so58802093itf.1
        for <linux-crypto@vger.kernel.org>; Mon, 09 Jan 2017 01:21:28 -0800 (PST)
In-Reply-To: <CAKv+Gu8wWW-c6dYcsRtD8LK4nrP=6pQwb63OkJTyGTYhK3Ryyw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 3 January 2017 at 20:01, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 2 January 2017 at 18:21, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> This series adds SIMD implementations for arm64 and ARM of ChaCha20 (*),
>> and a port of the ARM bit-sliced AES algorithm to arm64, and
>>
>> Patch #1 is a prerequisite for the AES-XTS implementation in #6, which needs
>> a secondary AES transform to generate the initial tweak.
>>
>
> Herbert,
>
> I actually have a scalar AES implementation for arm64 which I could
> use instead, making this patch unnecessary.
>
> I could respin the entire series, or you could simply disregard #1 and
> #6 for now, whichever you prefer.
>

I ended up doing some more work on the scalar and bit sliced AES
implementations for both ARM and arm64, so everything in this series
except the chacha20 patches (#3, #4) is now superseded.
