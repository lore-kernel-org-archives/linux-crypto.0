From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] arm64: SHA-224/SHA-256 using ARMv8 Crypto Extensions
Date: Thu, 27 Mar 2014 14:23:41 +0100
Message-ID: <CAKv+Gu9NJaq049MbT2soL=1DEUwUEvCgHo2jKLNtVW_3D6QzEA@mail.gmail.com>
References: <1395326886-5866-1-git-send-email-ard.biesheuvel@linaro.org>
	<201403242136.20547.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Steve Capper <steve.capper@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59361 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498AbaC0NXn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Mar 2014 09:23:43 -0400
Received: by mail-lb0-f174.google.com with SMTP id u14so2600139lbd.33
        for <linux-crypto@vger.kernel.org>; Thu, 27 Mar 2014 06:23:42 -0700 (PDT)
In-Reply-To: <201403242136.20547.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 24 March 2014 21:36, Marek Vasut <marex@denx.de> wrote:
> On Thursday, March 20, 2014 at 03:48:06 PM, Ard Biesheuvel wrote:
>> This patch adds support for the SHA-224 and SHA-256 hash algorithms using
>> the NEON based SHA-256 instructions that were introduced in ARM v8.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>
> [...]
>
>> + * Copyright (c) Alan Smithee.
>
> Email contact is missing here.
>
> [...]
>

Actually, this is mostly copied from the original sha1_generic.c. In
fact, my current v2 (which I will post shortly) has been reworked to
such an extent that I am contemplating dropping this attribution
altogether.

>> +static int sha224_init(struct shash_desc *desc)
>> +{
>> +     struct sha256_state *sctx = shash_desc_ctx(desc);
>> +
>> +     *sctx = (struct sha256_state){
>
> This cast is interesting, I don't quite understand it. Can you please explain
> that to me ?
>

http://gcc.gnu.org/onlinedocs/gcc/Compound-Literals.html

>> +             .state = {
>> +                     SHA224_H0, SHA224_H1, SHA224_H2, SHA224_H3,
>> +                     SHA224_H4, SHA224_H5, SHA224_H6, SHA224_H7,
>> +             }
>> +     };
>> +     return 0;
>> +}
>
> [...]
>
>> +static int sha224_final(struct shash_desc *desc, u8 *out)
>> +{
>> +     struct sha256_state *sctx = shash_desc_ctx(desc);
>> +     __be32 *dst = (__be32 *)out;
>> +     int i;
>> +
>> +     sha2_final(desc);
>> +
>> +     for (i = 0; i < SHA224_DIGEST_SIZE / sizeof(*dst); i++)
>> +             dst[i] = cpu_to_be32(sctx->state[i]);
>
> Won't this cause unaligned access if *dst is not aligned to 32 bytes ?
>

arm64 does not care about that, but I agree it would be better (and
more explicit) to use put_unaligned() here, and leave it up to the
architecture to allow it or work around it.
WIll update that in v2.

Thanks for the review.

-- 
Ard.
