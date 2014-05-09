From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH resend 00/15] arm64 crypto roundup
Date: Fri, 9 May 2014 08:37:58 +0200
Message-ID: <CAKv+Gu8iYzPUWfwLJJtPCGWKROV5EKSP-NA90F+PyVecorOL9g@mail.gmail.com>
References: <1398959381-8126-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140507144554.GC17253@arm.com>
	<CAKv+Gu-sLaDJxFcvXwD93qdzyTuPCNL0DXbRp2BKb8U=8Q8c2A@mail.gmail.com>
	<760C2409-2C8F-45B7-8EC0-220545D0B51B@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"steve.capper@linaro.org" <steve.capper@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:35408 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaEIGiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 May 2014 02:38:00 -0400
Received: by mail-la0-f41.google.com with SMTP id e16so114587lan.14
        for <linux-crypto@vger.kernel.org>; Thu, 08 May 2014 23:37:58 -0700 (PDT)
In-Reply-To: <760C2409-2C8F-45B7-8EC0-220545D0B51B@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 8 May 2014 23:50, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On 8 May 2014, at 12:22, Ard Biesheuvel <ard.biesheuvel@linaro.org> w=
rote:
>> On 7 May 2014 16:45, Catalin Marinas <catalin.marinas@arm.com> wrote=
:
>>> On Thu, May 01, 2014 at 04:49:32PM +0100, Ard Biesheuvel wrote:
>>>> This is a repost of the arm64 crypto patches that I have posted to=
 the LAKML
>>>> over the past months. They have now been verified on actual hardwa=
re
>>>> (Cortex-A57) so if there are no remaining issues I would like to p=
ropose them
>>>> for 3.16.
>>>>
>>>> Ard Biesheuvel (15):
>>>>  asm-generic: allow generic unaligned access if the arch supports =
it
>>>>  arm64: add abstractions for FPSIMD state manipulation
>>>>  arm64: defer reloading a task's FPSIMD state to userland resume
>>>>  arm64: add support for kernel mode NEON in interrupt context
>>>>  arm64/crypto: SHA-1 using ARMv8 Crypto Extensions
>>>>  arm64/crypto: SHA-224/SHA-256 using ARMv8 Crypto Extensions
>>>>  arm64/crypto: GHASH secure hash using ARMv8 Crypto Extensions
>>>>  arm64/crypto: AES using ARMv8 Crypto Extensions
>>>>  arm64/crypto: AES in CCM mode using ARMv8 Crypto Extensions
>>>>  arm64: pull in <asm/simd.h> from asm-generic
>>>>  arm64/crypto: AES-ECB/CBC/CTR/XTS using ARMv8 NEON and Crypto
>>>>    Extensions
>>>>  arm64/crypto: add shared macro to test for NEED_RESCHED
>>>>  arm64/crypto: add voluntary preemption to Crypto Extensions SHA1
>>>>  arm64/crypto: add voluntary preemption to Crypto Extensions SHA2
>>>>  arm64/crypto: add voluntary preemption to Crypto Extensions GHASH
>>>
>>> There are about 5 patches that make sense to me ;) and apart from a=
 few
>>> minor comments they look fine.
>>>
>>> There are the other 10 crypto patches that are beyond my knowledge.=
 Do
>>> you know anyone who could do a sanity check on them? Are there any =
tests
>>> that would show the correctness of the implementation?
>>
>> I will re-send the 3 FPSIMD patches separately with your review
>> comments addressed.
>
> Thanks. If you get another acked/reviewed-by tag on the rest of the
> patches it=E2=80=99s even better (I plan to get the series in for 3.1=
6, after
> we do some tests internally as well).
>

@Herbert, Jussi: care to share your opinion on the SHAx, GHASH and AES
patches above? Herbert has already acked the ccm patch, but Catalin is
requesting for more review and/or acknowledgements before merging
these patches for arm64.

Regards,
Ard.
