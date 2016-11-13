From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3] crypto: arm64/sha2: integrate OpenSSL implementations
 of SHA256/SHA512
Date: Sun, 13 Nov 2016 21:05:18 +0000
Message-ID: <CAKv+Gu8ouGT31ZqtiX5dFk-QnezjdNHOnP9ErbTDg70tVUU+YA@mail.gmail.com>
References: <1478953953-11523-1-git-send-email-ard.biesheuvel@linaro.org>
 <20161112221520.GD24127@arm.com> <CAKv+Gu_Y-ik0L9mh4z-g3fHKjPt780_znCQNU-jAwXifLgAo4A@mail.gmail.com>
 <c8306030-d4eb-fea7-441a-3476cd308496@openssl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Catalin Marinas <catalin.marinas@arm.com>
To: Andy Polyakov <appro@openssl.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:35536 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934756AbcKMVFU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2016 16:05:20 -0500
Received: by mail-it0-f54.google.com with SMTP id c20so43667368itb.0
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2016 13:05:20 -0800 (PST)
In-Reply-To: <c8306030-d4eb-fea7-441a-3476cd308496@openssl.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 13 November 2016 at 15:12, Andy Polyakov <appro@openssl.org> wrote:
>> (+ Andy)
>>
>> ...
>>>
>>> Looking at the generated code, I see references to __ARMEB__ and
>> __ILP32__.
>>> The former is probably a bug,
>
> Oh! You mean that it should be __AARCH64EB__/__AARCH64EL__!

Indeed:

$ aarch64-linux-gnu-gcc -dM -E  - <<<""   |grep AARCH
#define __AARCH64_CMODEL_SMALL__ 1
#define __AARCH64EL__ 1

$ aarch64-linux-gnu-gcc -dM -E -mbig-endian - <<<""   |grep AARCH
#define __AARCH64_CMODEL_SMALL__ 1
#define __AARCH64EB__ 1

-- 
Ard.
