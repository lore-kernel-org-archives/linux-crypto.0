From: Andy Polyakov <appro@openssl.org>
Subject: Re: [PATCH v3] crypto: arm64/sha2: integrate OpenSSL implementations
 of SHA256/SHA512
Date: Sun, 13 Nov 2016 22:47:34 +0100
Message-ID: <75340ad1-0632-b853-c993-5097b98abf77@openssl.org>
References: <1478953953-11523-1-git-send-email-ard.biesheuvel@linaro.org>
 <20161112221520.GD24127@arm.com>
 <CAKv+Gu_Y-ik0L9mh4z-g3fHKjPt780_znCQNU-jAwXifLgAo4A@mail.gmail.com>
 <c8306030-d4eb-fea7-441a-3476cd308496@openssl.org>
 <CAKv+Gu8ouGT31ZqtiX5dFk-QnezjdNHOnP9ErbTDg70tVUU+YA@mail.gmail.com>
 <c82fd8f0-5c0e-74d9-fbf3-b2a5c0dc3a1c@openssl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Catalin Marinas <catalin.marinas@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mta.openssl.org ([194.97.150.230]:52847 "EHLO mta.openssl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753926AbcKMVrj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2016 16:47:39 -0500
In-Reply-To: <c82fd8f0-5c0e-74d9-fbf3-b2a5c0dc3a1c@openssl.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>>>>> Looking at the generated code, I see references to __ARMEB__ and
>>>> __ILP32__.
>>>>> The former is probably a bug,
>>>
>>> Oh! You mean that it should be __AARCH64EB__/__AARCH64EL__!
>>
>> Indeed:
>>
>> $ aarch64-linux-gnu-gcc -dM -E  - <<<""   |grep AARCH
>> #define __AARCH64_CMODEL_SMALL__ 1
>> #define __AARCH64EL__ 1
>>
>> $ aarch64-linux-gnu-gcc -dM -E -mbig-endian - <<<""   |grep AARCH
>> #define __AARCH64_CMODEL_SMALL__ 1
>> #define __AARCH64EB__ 1
> 
> As it turns out it wasn't really an overlook, at least not in OpenSSL
> context, as I force __ARMEB__/__ARMEL__ in 64-bit build through
> arm_arch.h, which in turn is shared between 32- and 64-bit builds. But
> shared code should be preferred to be self-sufficient. It doesn't mean
> that it won't be fixed, only that it wasn't really a bug in OpenSSL context.
> 

https://github.com/openssl/openssl/pull/1914.
