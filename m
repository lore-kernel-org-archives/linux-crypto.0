From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/5] sha3 fixes and new implementation for arm64
Date: Tue, 16 Jan 2018 08:44:39 +0000
Message-ID: <CAKv+Gu99FyvYeePiUG4dN5nxiXb1JPewzk57dC6BSR_h82GzAw@mail.gmail.com>
References: <20180112131522.25663-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu9QYve=Tq+mBsmtSgbSi9n8Fsbdh2kiZCG-yM6GZ7+2gg@mail.gmail.com> <20180116084145.5r3ofxfnr6xhzgsm@capper-debian.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Steve Capper <steve.capper@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, jgarzik@redhat.com,
        nd <nd@arm.com>
To: Steve Capper <steve.capper@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:39805 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbeAPIok (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jan 2018 03:44:40 -0500
Received: by mail-io0-f194.google.com with SMTP id b198so13291927iof.6
        for <linux-crypto@vger.kernel.org>; Tue, 16 Jan 2018 00:44:40 -0800 (PST)
In-Reply-To: <20180116084145.5r3ofxfnr6xhzgsm@capper-debian.cambridge.arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 16 January 2018 at 08:41, Steve Capper <steve.capper@arm.com> wrote:
> On Fri, Jan 12, 2018 at 03:13:56PM +0000, Ard Biesheuvel wrote:
>> On 12 January 2018 at 13:15, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> > Add an implementation of SHA3 to arm64 using the new special instructions (#4)
>> >
>> > In preparation of that, fix a bug in the SHA3 and refactor it a bit so it
>> > can serve as a fallback for the other code. Also, add some new test vectors
>> > to get better test coverage.
>> >
>> > Ard Biesheuvel (5):
>> >   crypto/generic: sha3 - fixes for alignment and big endian operation
>> >   crypto/generic: sha3 - simplify code
>> >   crypto/generic: sha3 - export init/update/final routines
>> >   crypto/arm64: sha3 - new implementation based on special instructions
>>
>> Forgot to mention: this is an RFT for patch #4, as it has not been
>> validated against a real implementation, only against my own QEMU
>> code.
>
> Hi Ard,
> I have tested this patch set applied to 4.15-rc7 running in a model.
>
> I used the following tcrypt modes:
> 48, 49, 50, 51, 111, 112, 113, 114, 187, 188, 322, 323, 324, 325, 418,
> 419, 420 and 421.
>
> Also, I added some logic to double check that sha3_ce_transform(.)
> was being called rather than sha3_scalar_transform(.).
> (Because both the scalar and ce code paths are contained in the
> sha3-x-arm64 drivers).
>
> So, please feel free to add for the series:
> Tested-by: Steve Capper <steve.capper@arm.com>
>

Thanks Steve!
