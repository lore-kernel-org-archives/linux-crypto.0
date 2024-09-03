Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCA218562A
	for <linux-crypto@vger.kernel.org>; Tue,  3 Sep 2024 12:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725367246; cv=none; b=DC1BQ3r90U0lctlQnlH0+bfhpsKvPcgJnVBVE9LVD04Vx3vr0TSyz0e+XPl41GddZHabmHxq7bvDCoGclxTTheiTYLHAGfpJSsl1Y4lVhKOzYmhw4KnF+TGzcqMsZT/hTb+EsjRo+AH64uyjrHngUtlX3Eq1SPTmf7xqYmpZs+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725367246; c=relaxed/simple;
	bh=CnBw/heyk7znfRmkKpRRRtyzVJvNqjtxbgKbwGRRAIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LQZPPK5Vo841vMg2aPHNnPkx3scQBtTrDUZA7njIg6gK52Aqk17+5FINgD86JT6Eqgl72WSoA3dqGgwISrOmEd3OGQSwIg5m7nd2dcbAeHWy/zqM2tVt2X/IDeVphTpX+gJh9B91yHVfGxC1y1D+3E5RrVUMhGcnvQed4w0JWj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xOXKrOqT; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xOXKrOqT"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-714287e4083so4683449b3a.2
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2024 05:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725367244; x=1725972044; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yUGGQ9ImI247lYjlcFtHRPSSQvm60y4/z52ybd97SrE=;
        b=xOXKrOqTDE16LN8sBu4clqN3AQ26kO110rU0Oc0nRjbQ7gn+uPLvbCCip+MF0Dl/EM
         Aj4hU0u9OIPyIZJz+7npxHziHf1MSvPoIpZkMH1bsXW6Ri54aXaVDgkWML/U/hnCscDf
         G6rpnkgXgZAmHtorzsTPPiUIyGbfb3BzqJFvRKd8/ER6KYOG9DsQhbNnB9V23/ThLkqE
         +WDyraZES46weiRvaBxISF40cr+Pw8Qhi/AnVYsD3OY1idAG+m5sQMVY1v1vl2V8RQ9R
         i8/5DIoEoGRa14jcgB/86qUlOP72+npu/4oWVfa5iGREu2q+2BUFtwWbIs6U1Erq6crd
         DOOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725367244; x=1725972044;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yUGGQ9ImI247lYjlcFtHRPSSQvm60y4/z52ybd97SrE=;
        b=tAVIaigUX/HKd4tyMsBcUWsqYzujlAA0oQ2dft/aDhKjAkyaBWNB+q2BzZiYt/Jm38
         a1CB9UBrXbJ0ryDQ+VnYPR3eMIyVeylITySf9fGhv4jzFT949lwNbqt9oPPJvgRYaAU9
         c3cmZKNBpv9VM4plNG5f8ma4DPqLY3A/a+bbEq/sv2RJH2LnIpEqqP3k9+QZYJoO1ypd
         5MPinfyaYJtn5FiYO/7ajGeh/M8HzmBxfYS4Ss1zUn8T7ZNJ+FOh2KkZhlkjLzvLDzZ8
         Hnwq6cIxujqlSQBCqpe6hMwNrRj54RnUMC59iQ/45kC3OXFz0azuyYqUN/8vwjbn4oNH
         ndGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXE2zi2Z2PTfGiQSB0/v5xHwUNBhAQejnB8ceV5VWKPGGwcR9gukAgdqOm1Fsx/NICk4eQlCyAxOIF9YNg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrULPcHNWkDST82xxc1rzb0Tubpf91gpZAt6LuuLdsEsZrfXSc
	MefMUPQyBPNzko5ftiwVOvc6pb0ujizY8VRlaUhiTDkEZG7SBlwcxF8CFsX4Ys8=
X-Google-Smtp-Source: AGHT+IGlAqTnpJOXV4pzKKv9xpFNk15m6UQWOxuGZ9DHLvskw4I/S/YUXO4evHAz9gHKMkkK4SaWTA==
X-Received: by 2002:a05:6a21:318b:b0:1ce:cbcf:aaa9 with SMTP id adf61e73a8af0-1cecdfdea62mr14891766637.36.1725367243637;
        Tue, 03 Sep 2024 05:40:43 -0700 (PDT)
Received: from ?IPV6:2804:1b3:a7c3:e912:70fc:7517:c1b8:1256? ([2804:1b3:a7c3:e912:70fc:7517:c1b8:1256])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-715e5773733sm8377099b3a.217.2024.09.03.05.40.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2024 05:40:41 -0700 (PDT)
Message-ID: <4b00162c-c654-4f57-a712-fc3d3163eeb7@linaro.org>
Date: Tue, 3 Sep 2024 09:40:36 -0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] arm64: vdso: wire up getrandom() vDSO
 implementation
To: Ard Biesheuvel <ardb@kernel.org>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Eric Biggers <ebiggers@kernel.org>,
 Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20240902161912.2751-1-adhemerval.zanella@linaro.org>
 <20240902161912.2751-3-adhemerval.zanella@linaro.org>
 <CAMj1kXGddK5pkVUM0Gx5OZStpOhYEYQteRk-pPtZZZiDAn0wiw@mail.gmail.com>
Content-Language: en-US
From: Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
Organization: Linaro
In-Reply-To: <CAMj1kXGddK5pkVUM0Gx5OZStpOhYEYQteRk-pPtZZZiDAn0wiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 02/09/24 17:57, Ard Biesheuvel wrote:
> Hi Adhemerval,
> 
> I have just a couple of more points below, on the BE handling in the asm.
> 
> On Mon, 2 Sept 2024 at 18:19, Adhemerval Zanella
> <adhemerval.zanella@linaro.org> wrote:
>>
>> Hook up the generic vDSO implementation to the aarch64 vDSO data page.
>> The _vdso_rng_data required data is placed within the _vdso_data vvar
>> page, by using a offset larger than the vdso_data.
>>
>> The vDSO function requires a ChaCha20 implementation that does not write
>> to the stack, and that can do an entire ChaCha20 permutation.  The one
>> provided uses NEON on the permute operation, with a fallback to the
>> syscall for chips that do not support AdvSIMD.
>>
>> This also passes the vdso_test_chacha test along with
>> vdso_test_getrandom. The vdso_test_getrandom bench-single result on
>> Neoverse-N1 shows:
>>
>>    vdso: 25000000 times in 0.783884250 seconds
>>    libc: 25000000 times in 8.780275399 seconds
>> syscall: 25000000 times in 8.786581518 seconds
>>
>> A small fixup to arch/arm64/include/asm/mman.h was required to avoid
>> pulling kernel code into the vDSO, similar to what's already done in
>> arch/arm64/include/asm/rwonce.h.
>>
>> Signed-off-by: Adhemerval Zanella <adhemerval.zanella@linaro.org>
>> ---
>>  arch/arm64/Kconfig                         |   1 +
>>  arch/arm64/include/asm/mman.h              |   6 +-
>>  arch/arm64/include/asm/vdso.h              |   6 +
>>  arch/arm64/include/asm/vdso/getrandom.h    |  50 ++++++
>>  arch/arm64/include/asm/vdso/vsyscall.h     |  10 ++
>>  arch/arm64/kernel/vdso.c                   |   6 -
>>  arch/arm64/kernel/vdso/Makefile            |  25 ++-
>>  arch/arm64/kernel/vdso/vdso                |   1 +
>>  arch/arm64/kernel/vdso/vdso.lds.S          |   4 +
>>  arch/arm64/kernel/vdso/vgetrandom-chacha.S | 178 +++++++++++++++++++++
>>  arch/arm64/kernel/vdso/vgetrandom.c        |  15 ++
>>  tools/arch/arm64/vdso                      |   1 +
>>  tools/include/linux/compiler.h             |   4 +
>>  tools/testing/selftests/vDSO/Makefile      |   3 +-
>>  14 files changed, 294 insertions(+), 16 deletions(-)
>>  create mode 100644 arch/arm64/include/asm/vdso/getrandom.h
>>  create mode 120000 arch/arm64/kernel/vdso/vdso
>>  create mode 100644 arch/arm64/kernel/vdso/vgetrandom-chacha.S
>>  create mode 100644 arch/arm64/kernel/vdso/vgetrandom.c
>>  create mode 120000 tools/arch/arm64/vdso
>>
> ...
>> diff --git a/arch/arm64/kernel/vdso/vgetrandom-chacha.S b/arch/arm64/kernel/vdso/vgetrandom-chacha.S
>> new file mode 100644
>> index 000000000000..4e5f9c349522
>> --- /dev/null
>> +++ b/arch/arm64/kernel/vdso/vgetrandom-chacha.S
>> @@ -0,0 +1,178 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +#include <linux/linkage.h>
>> +#include <asm/cache.h>
>> +#include <asm/assembler.h>
>> +
>> +       .text
>> +
>> +#define state0         v0
>> +#define state1         v1
>> +#define state2         v2
>> +#define state3         v3
>> +#define copy0          v4
>> +#define copy0_q                q4
>> +#define copy1          v5
>> +#define copy2          v6
>> +#define copy3          v7
>> +#define copy3_d                d7
>> +#define one_d          d16
>> +#define one_q          q16
>> +#define one_v          v16
>> +#define tmp            v17
>> +#define rot8           v18
>> +
>> +/*
>> + * ARM64 ChaCha20 implementation meant for vDSO.  Produces a given positive
>> + * number of blocks of output with nonce 0, taking an input key and 8-bytes
>> + * counter.  Importantly does not spill to the stack.
>> + *
>> + * This implementation avoids d8-d15 because they are callee-save in user
>> + * space.
>> + *
>> + * void __arch_chacha20_blocks_nostack(uint8_t *dst_bytes,
>> + *                                    const uint8_t *key,
>> + *                                    uint32_t *counter,
>> + *                                    size_t nblocks)
>> + *
>> + *     x0: output bytes
>> + *     x1: 32-byte key input
>> + *     x2: 8-byte counter input/output
>> + *     x3: number of 64-byte block to write to output
>> + */
>> +SYM_FUNC_START(__arch_chacha20_blocks_nostack)
>> +
>> +       /* copy0 = "expand 32-byte k" */
>> +       mov_q           x8, 0x3320646e61707865
>> +       mov_q           x9, 0x6b20657479622d32
>> +       mov             copy0.d[0], x8
>> +       mov             copy0.d[1], x9
>> +
>> +       /* copy1,copy2 = key */
>> +       ld1             { copy1.4s, copy2.4s }, [x1]
>> +       /* copy3 = counter || zero nonce  */
>> +       ldr             copy3_d, [x2]
>> +CPU_BE( rev64          copy3.4s, copy3.4s)
>> +
> 
> This loads 2 u32s as a single u64, and then swaps them if we are running on BE.
> So better to just use
> 
>   ld1 {copy3.2s}, [x2]
> 
> here, and drop the CPU_BE() special case.

Ack.

> 
>> +       movi            one_v.2s, #1
>> +       uzp1            one_v.4s, one_v.4s, one_v.4s
>> +
>> +.Lblock:
>> +       /* copy state to auxiliary vectors for the final add after the permute.  */
>> +       mov             state0.16b, copy0.16b
>> +       mov             state1.16b, copy1.16b
>> +       mov             state2.16b, copy2.16b
>> +       mov             state3.16b, copy3.16b
>> +
>> +       mov             w4, 20
>> +.Lpermute:
>> +       /*
>> +        * Permute one 64-byte block where the state matrix is stored in the four NEON
>> +        * registers state0-state3.  It performs matrix operations on four words in parallel,
>> +        * but requires shuffling to rearrange the words after each round.
>> +        */
>> +
>> +.Ldoubleround:
>> +       /* state0 += state1, state3 = rotl32(state3 ^ state0, 16) */
>> +       add             state0.4s, state0.4s, state1.4s
>> +       eor             state3.16b, state3.16b, state0.16b
>> +       rev32           state3.8h, state3.8h
>> +
>> +       /* state2 += state3, state1 = rotl32(state1 ^ state2, 12) */
>> +       add             state2.4s, state2.4s, state3.4s
>> +       eor             tmp.16b, state1.16b, state2.16b
>> +       shl             state1.4s, tmp.4s, #12
>> +       sri             state1.4s, tmp.4s, #20
>> +
>> +       /* state0 += state1, state3 = rotl32(state3 ^ state0, 8) */
>> +       add             state0.4s, state0.4s, state1.4s
>> +       eor             tmp.16b, state3.16b, state0.16b
>> +       shl             state3.4s, tmp.4s, #8
>> +       sri             state3.4s, tmp.4s, #24
>> +
>> +       /* state2 += state3, state1 = rotl32(state1 ^ state2, 7) */
>> +       add             state2.4s, state2.4s, state3.4s
>> +       eor             tmp.16b, state1.16b, state2.16b
>> +       shl             state1.4s, tmp.4s, #7
>> +       sri             state1.4s, tmp.4s, #25
>> +
>> +       /* state1[0,1,2,3] = state1[1,2,3,0] */
>> +       ext             state1.16b, state1.16b, state1.16b, #4
>> +       /* state2[0,1,2,3] = state2[2,3,0,1] */
>> +       ext             state2.16b, state2.16b, state2.16b, #8
>> +       /* state3[0,1,2,3] = state3[1,2,3,0] */
>> +       ext             state3.16b, state3.16b, state3.16b, #12
>> +
>> +       /* state0 += state1, state3 = rotl32(state3 ^ state0, 16) */
>> +       add             state0.4s, state0.4s, state1.4s
>> +       eor             state3.16b, state3.16b, state0.16b
>> +       rev32           state3.8h, state3.8h
>> +
>> +       /* state2 += state3, state1 = rotl32(state1 ^ state2, 12) */
>> +       add             state2.4s, state2.4s, state3.4s
>> +       eor             tmp.16b, state1.16b, state2.16b
>> +       shl             state1.4s, tmp.4s, #12
>> +       sri             state1.4s, tmp.4s, #20
>> +
>> +       /* state0 += state1, state3 = rotl32(state3 ^ state0, 8) */
>> +       add             state0.4s, state0.4s, state1.4s
>> +       eor             tmp.16b, state3.16b, state0.16b
>> +       shl             state3.4s, tmp.4s, #8
>> +       sri             state3.4s, tmp.4s, #24
>> +
>> +       /* state2 += state3, state1 = rotl32(state1 ^ state2, 7) */
>> +       add             state2.4s, state2.4s, state3.4s
>> +       eor             tmp.16b, state1.16b, state2.16b
>> +       shl             state1.4s, tmp.4s, #7
>> +       sri             state1.4s, tmp.4s, #25
>> +
>> +       /* state1[0,1,2,3] = state1[3,0,1,2] */
>> +       ext             state1.16b, state1.16b, state1.16b, #12
>> +       /* state2[0,1,2,3] = state2[2,3,0,1] */
>> +       ext             state2.16b, state2.16b, state2.16b, #8
>> +       /* state3[0,1,2,3] = state3[1,2,3,0] */
>> +       ext             state3.16b, state3.16b, state3.16b, #4
>> +
>> +       subs            w4, w4, #2
>> +       b.ne            .Ldoubleround
>> +
>> +       /* output0 = state0 + state0 */
>> +       add             state0.4s, state0.4s, copy0.4s
>> +CPU_BE( rev32          state0.16b, state0.16b)
>> +       /* output1 = state1 + state1 */
>> +       add             state1.4s, state1.4s, copy1.4s
>> +CPU_BE( rev32          state1.16b, state1.16b)
>> +       /* output2 = state2 + state2 */
>> +       add             state2.4s, state2.4s, copy2.4s
>> +CPU_BE( rev32          state2.16b, state2.16b)
>> +       /* output2 = state3 + state3 */
>> +       add             state3.4s, state3.4s, copy3.4s
>> +CPU_BE( rev32          state3.16b, state3.16b)
>> +       st1             { state0.4s - state3.4s }, [x0]
>> +
> 
> If the u32s shouldn't be swabbed for BE, you should simply be able to do
> 
> st1 {state0.16b - state3.16b}, [x0]
> 
> here, and drop the CPU_BE(*).

Ack.

> 
>> +       /*
>> +        * ++copy3.counter, the 'add' clears the upper half of the SIMD register
>> +        * which is the expected behaviour here.
>> +        */
>> +       add             copy3_d, copy3_d, one_d
>> +
>> +       /* output += 64, --nblocks */
>> +       add             x0, x0, 64
>> +       subs            x3, x3, #1
>> +       b.ne            .Lblock
>> +
>> +       /* counter = copy3.counter */
>> +CPU_BE( rev64          copy3.4s, copy3.4s)
>> +       str             copy3_d, [x2]
>> +
> 
> ... and this could be
> 
> st1 {copy3.2s}, [x2]

Ack.

I just sent a v5 with your proposed suggestions, thanks!

> 
>> +       /* Zero out the potentially sensitive regs, in case nothing uses these again. */
>> +       movi            state0.16b, #0
>> +       movi            state1.16b, #0
>> +       movi            state2.16b, #0
>> +       movi            state3.16b, #0
>> +       movi            copy1.16b, #0
>> +       movi            copy2.16b, #0
>> +       ret
>> +SYM_FUNC_END(__arch_chacha20_blocks_nostack)
>> +
>> +emit_aarch64_feature_1_and
