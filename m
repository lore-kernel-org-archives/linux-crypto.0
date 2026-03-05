Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821712882C5
	for <linux-crypto@vger.kernel.org>; Thu,  5 Mar 2026 06:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772691619; cv=none; b=sUFOpgAyqk/is9e9o7iJZMWfE9izubCOrR0jb89+DUvhSK+xcdJPMhcgFmeZLgUJUYM2eW/dYAtIrqbMr29UFuAB4MWo5c0FI4gUxjqQfUThBGKveMKAJ9cjAPXsCaJl7Ve0T6blAnENZzAkfIXjRRAy+5PtH4ma1a+qSTeXfj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772691619; c=relaxed/simple;
	bh=JYoVtqT+TlZivIYwGhB+s6D+2mX7bsKlbpZgEZw3dRA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=WrUsNk43q8EOntoaDAjArG0K9hbykMWAdwQLo9X7dh8Pu7j0CX3OWSNV+75CpLHXN1bIQKsMlVFZyqHz8gK2a8tnd1PFYCFKpI7s5ZEnu02rXQ+wJkA/mLo97Ij7i+QgRUUPJZMSsUqscjypPLJwTQJbBXFdRvncQetmb1Mz2hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1772690949-1eb14e7586273a0001-Xm9f1P
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx2.zhaoxin.com with ESMTP id a56iC6VahJp61GyC (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Thu, 05 Mar 2026 14:09:09 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Thu, 5 Mar
 2026 14:09:08 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85]) by
 ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85%7]) with mapi id
 15.01.2507.059; Thu, 5 Mar 2026 14:09:08 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from [10.32.65.156] (10.32.65.156) by ZXBJMBX02.zhaoxin.com
 (10.29.252.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Thu, 5 Mar
 2026 09:37:01 +0800
Message-ID: <220d9651-3edc-4dc1-9086-e3482d2d5da3@zhaoxin.com>
Date: Thu, 5 Mar 2026 09:37:01 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
Subject: Re: [PATCH v3 2/3] lib/crypto: x86/sha1: PHE Extensions optimized
 SHA1 transform function
To: Eric Biggers <ebiggers@kernel.org>
X-ASG-Orig-Subj: Re: [PATCH v3 2/3] lib/crypto: x86/sha1: PHE Extensions optimized
 SHA1 transform function
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <Jason@zx2c4.com>,
	<ardb@kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <CobeChen@zhaoxin.com>,
	<TonyWWang-oc@zhaoxin.com>, <YunShen@zhaoxin.com>, <GeorgeXue@zhaoxin.com>,
	<LeoLiu-oc@zhaoxin.com>, <HansHu@zhaoxin.com>
References: <20260116071513.12134-1-AlanSong-oc@zhaoxin.com>
 <20260116071513.12134-3-AlanSong-oc@zhaoxin.com>
 <20260118003120.GF74518@quark>
In-Reply-To: <20260118003120.GF74518@quark>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 3/5/2026 2:09:07 PM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1772690949
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 6466
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -0.94
X-Barracuda-Spam-Status: No, SCORE=-0.94 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=DATE_IN_PAST_03_06, DATE_IN_PAST_03_06_2
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.155397
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.01 DATE_IN_PAST_03_06     Date: is 3 to 6 hours before Received: date
	1.08 DATE_IN_PAST_03_06_2   DATE_IN_PAST_03_06_2

On 1/18/2026 8:31 AM, Eric Biggers wrote:
> 
> On Fri, Jan 16, 2026 at 03:15:12PM +0800, AlanSong-oc wrote:
>> Zhaoxin CPUs have implemented the SHA(Secure Hash Algorithm) as its CPU
>> instructions by PHE(Padlock Hash Engine) Extensions, including XSHA1,
>> XSHA256, XSHA384 and XSHA512 instructions.
>>
>> With the help of implementation of SHA in hardware instead of software,
>> can develop applications with higher performance, more security and more
>> flexibility.
>>
>> This patch includes the XSHA1 instruction optimized implementation of
>> SHA-1 transform function.
>>
>> Signed-off-by: AlanSong-oc <AlanSong-oc@zhaoxin.com>
> 
> Please include the information I've asked for (benchmark results, test
> results, and link to the specification) directly in the commit message.

Sorry for missing the link to the specification in the commit message.
I will include the benchmark results, test results, and the link to the
specification directly in the commit message in the next version of the
patch, rather than in the cover letter.

>> +#if IS_ENABLED(CONFIG_CPU_SUP_ZHAOXIN)
>> +#define PHE_ALIGNMENT 16
>> +static void sha1_blocks_phe(struct sha1_block_state *state,
>> +                          const u8 *data, size_t nblocks)
> 
> The IS_ENABLED(CONFIG_CPU_SUP_ZHAOXIN) should go in the CPU feature
> check, so that the code will be parsed regardless of the setting.  That
> reduces the chance that future changes will cause compilation errors.

I will address this problem using the approach you described below in
the next version of the patch.

> 
>> +     /*
>> +      * XSHA1 requires %edi to point to a 32-byte, 16-byte-aligned
>> +      * buffer on Zhaoxin processors.
>> +      */
> 
> This seems implausible.  In 64-bit mode a pointer can't fit in %edi.  I
> thought you mentioned that this instruction is 64-bit compatible?  You
> may have meant %rdi.
> 
> Interestingly, the spec you provided specifically says the registers
> operated on are %eax, %ecx, %esi, and %edi.
> 
> So assuming the code works, perhaps both the spec and your code comment
> are incorrect?
> 
> These errors don't really confidence in this instruction.

Sorry for the misleading comment. I will correct it in the next version
of the patch. The specification provided earlier uses the 32-bit
register as an example, which doesn't mean the instruction only supports
32-bit mode. The updated specification explicitly clarifies this point
and is available at the following link.
(https://gitee.com/openzhaoxin/zhaoxin_specifications/blob/20260227/ZX_Padlock_Reference.pdf)

> 
>> +     memcpy(dst, state, SHA1_DIGEST_SIZE);
>> +     asm volatile(".byte 0xf3,0x0f,0xa6,0xc8"
>> +                  : "+S"(data), "+D"(dst)
>> +                  : "a"((long)-1), "c"(nblocks));
>> +     memcpy(state, dst, SHA1_DIGEST_SIZE);
> 
> Is the reason for using '.byte' that the GNU and clang assemblers don't
> implement the mnemonic this Zhaoxin-specific instruction?  The spec
> implies that the intended mnemonic is "rep sha1".
> 
> If that's correct, could you add a comment like /* rep sha1 */ so that
> it's clear what the intended instruction is?

The '.byte' directive is used to ensure the correct binary code is
generated, regardless of compiler support, particularly for compilers
that lack the corresponding mnemonic. I will add an appropriate comment
in the next version of the patch to clarify the intended instruction.

> Also, the spec describes all four registers as both input and output
> registers.  Yet your inline asm marks %rax and %rcx as inputs only.

Thank you for pointing this question out.

On the one hand, when the '+' constraint modifier is applied to an
operand, it is treated as both an input and an output operand.
Therefore, %rsi and %rdi are considered input operands as well.

On the other hand, after the instruction executes, the values in %rax,
%rsi, and %rcx are modified. These registers should therefore use the
'+' constraint modifier to inform the compiler that their values are
updated by the assembly code. We cannot rely on clobbers to indicate
that the values of input operands are modified following the suggestion
by gcc manual. However, since %rax is initialized with a constant value,
it does not need the '+' constraint modifier. It should can simply be
specified as an input operand.

In addition, although %rdi itself is not modified by the instruction but
the memory it references may be updated, a "memory" clobber should be
added to notify the compiler about possible memory side effects.

The corrected inline assembly should be written as follows:

    asm volatile(".byte 0xf3,0x0f,0xa6,0xc8" /* REP XSHA1 */
                : "+S"(data), "+c"(nblocks)
                : "a"((long)-1), "D"(dst)
                : "memory");

I will adopt it in the next version of the patch.

>> @@ -59,6 +79,11 @@ static void sha1_mod_init_arch(void)
>>  {
>>       if (boot_cpu_has(X86_FEATURE_SHA_NI)) {
>>               static_call_update(sha1_blocks_x86, sha1_blocks_ni);
>> +#if IS_ENABLED(CONFIG_CPU_SUP_ZHAOXIN)
>> +     } else if (boot_cpu_has(X86_FEATURE_PHE_EN)) {
>> +             if (boot_cpu_data.x86 >= 0x07)
>> +                     static_call_update(sha1_blocks_x86, sha1_blocks_phe);
>> +#endif
> 
> I think it should be:
> 
>         } else if (IS_ENABLED(CONFIG_CPU_SUP_ZHAOXIN) &&
>                    boot_cpu_has(X86_FEATURE_PHE_EN) &&
>                    boot_cpu_data.x86 >= 0x07) {
>                         static_call_update(sha1_blocks_x86, sha1_blocks_phe);
> 
> ... so (a) the code will be parsed even when !CONFIG_CPU_SUP_ZHAOXIN,
> and (b) functions won't be unnecessarily disabled when
> boot_cpu_has(X86_FEATURE_PHE_EN) && boot_cpu_data.x86 < 0x07).

Thanks for the suggestion, that makes more sense.

Using #if and #endif for conditional compilation is a poor choice, as it
prevents the code from being properly parsed. It is more efficient to
include CPU family checks directly in the condition.

> 
> As before, all these comments apply to the SHA-256 patch too.

Surely, I will also apply all of the suggestions mentioned above to the
SHA-256 patch.

Please accept my apologies for the delayed response due to
administrative procedures and the recent holidays. Thank you for your
review and valuable suggestions.

Best Regards
AlanSong-oc


