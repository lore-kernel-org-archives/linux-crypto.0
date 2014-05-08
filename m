From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH resend 00/15] arm64 crypto roundup
Date: Thu, 8 May 2014 22:50:25 +0100
Message-ID: <760C2409-2C8F-45B7-8EC0-220545D0B51B@arm.com>
References: <1398959381-8126-1-git-send-email-ard.biesheuvel@linaro.org> <20140507144554.GC17253@arm.com> <CAKv+Gu-sLaDJxFcvXwD93qdzyTuPCNL0DXbRp2BKb8U=8Q8c2A@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Will Deacon <Will.Deacon@arm.com>,
	"steve.capper@linaro.org" <steve.capper@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:65261 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbaEHVu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 May 2014 17:50:28 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so407229wib.7
        for <linux-crypto@vger.kernel.org>; Thu, 08 May 2014 14:50:26 -0700 (PDT)
In-Reply-To: <CAKv+Gu-sLaDJxFcvXwD93qdzyTuPCNL0DXbRp2BKb8U=8Q8c2A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 8 May 2014, at 12:22, Ard Biesheuvel <ard.biesheuvel@linaro.org> wro=
te:
> On 7 May 2014 16:45, Catalin Marinas <catalin.marinas@arm.com> wrote:
>> On Thu, May 01, 2014 at 04:49:32PM +0100, Ard Biesheuvel wrote:
>>> This is a repost of the arm64 crypto patches that I have posted to =
the LAKML
>>> over the past months. They have now been verified on actual hardwar=
e
>>> (Cortex-A57) so if there are no remaining issues I would like to pr=
opose them
>>> for 3.16.
>>>=20
>>> Ard Biesheuvel (15):
>>>  asm-generic: allow generic unaligned access if the arch supports i=
t
>>>  arm64: add abstractions for FPSIMD state manipulation
>>>  arm64: defer reloading a task's FPSIMD state to userland resume
>>>  arm64: add support for kernel mode NEON in interrupt context
>>>  arm64/crypto: SHA-1 using ARMv8 Crypto Extensions
>>>  arm64/crypto: SHA-224/SHA-256 using ARMv8 Crypto Extensions
>>>  arm64/crypto: GHASH secure hash using ARMv8 Crypto Extensions
>>>  arm64/crypto: AES using ARMv8 Crypto Extensions
>>>  arm64/crypto: AES in CCM mode using ARMv8 Crypto Extensions
>>>  arm64: pull in <asm/simd.h> from asm-generic
>>>  arm64/crypto: AES-ECB/CBC/CTR/XTS using ARMv8 NEON and Crypto
>>>    Extensions
>>>  arm64/crypto: add shared macro to test for NEED_RESCHED
>>>  arm64/crypto: add voluntary preemption to Crypto Extensions SHA1
>>>  arm64/crypto: add voluntary preemption to Crypto Extensions SHA2
>>>  arm64/crypto: add voluntary preemption to Crypto Extensions GHASH
>>=20
>> There are about 5 patches that make sense to me ;) and apart from a =
few
>> minor comments they look fine.
>>=20
>> There are the other 10 crypto patches that are beyond my knowledge. =
Do
>> you know anyone who could do a sanity check on them? Are there any t=
ests
>> that would show the correctness of the implementation?
>=20
> I will re-send the 3 FPSIMD patches separately with your review
> comments addressed.

Thanks. If you get another acked/reviewed-by tag on the rest of the
patches it=92s even better (I plan to get the series in for 3.16, after
we do some tests internally as well).

Catalin--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
