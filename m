Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B6930FC10
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 09:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768210632; cv=none; b=B/5bJaZACERd0H/itPZEU+nXW9fAWChTuZxntq7hPUsQToIWjtRoK1lBNfIKUwac1uZj5Sh6WaRMsLXvY4osPUoE25uMjrGdoYyzsPZyhsBBT36cbfi9Dl56WFbYXtg30Gkm2pFANkDjuXUW7Wqtd9ROWJHPR/ICv9Y3+LHQzRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768210632; c=relaxed/simple;
	bh=s/0soxVLS7I9bDruxcwpW+pBGMdGAmBDH2ApMDWqxFk=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=SH31u4zwL1sUnb1qBI1qzGDtH5KY6txC6d5TgffKnas0HlpavLwswRU5b7LJE3xHEa8RZrsKz8u4zIr1I4C9sf6bPwDH90sfNyuJdRbTGUztdGgzgV3itbsSVl30EsemnD6r7kspw80U9HZtDfU5VmCWI0JZxXheh8v/wnNzt4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1768209497-1eb14e7c010f250001-Xm9f1P
Received: from ZXSHMBX2.zhaoxin.com (ZXSHMBX2.zhaoxin.com [10.28.252.164]) by mx2.zhaoxin.com with ESMTP id 48sW1qyJ7ZrIAkxQ (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Mon, 12 Jan 2026 17:18:17 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX2.zhaoxin.com
 (10.28.252.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Mon, 12 Jan
 2026 17:18:17 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85]) by
 ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85%7]) with mapi id
 15.01.2507.059; Mon, 12 Jan 2026 17:18:17 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from [10.32.65.156] (10.32.65.156) by ZXBJMBX02.zhaoxin.com
 (10.29.252.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Mon, 12 Jan
 2026 17:12:34 +0800
Message-ID: <7aa1603d-6520-414a-a2a1-3a5289724814@zhaoxin.com>
Date: Mon, 12 Jan 2026 17:12:01 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
Subject: Re: [PATCH v2 1/2] lib/crypto: x86/sha1: PHE Extensions optimized
 SHA1 transform function
To: Eric Biggers <ebiggers@kernel.org>
X-ASG-Orig-Subj: Re: [PATCH v2 1/2] lib/crypto: x86/sha1: PHE Extensions optimized
 SHA1 transform function
CC: <herbert@gondor.apana.org.au>, <Jason@zx2c4.com>, <ardb@kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<CobeChen@zhaoxin.com>, <TonyWWang-oc@zhaoxin.com>, <YunShen@zhaoxin.com>,
	<GeorgeXue@zhaoxin.com>, <LeoLiu-oc@zhaoxin.com>, <HansHu@zhaoxin.com>,
	<x86@kernel.org>
References: <cover.1766131281.git.AlanSong-oc@zhaoxin.com>
 <aa8ed72a109480887bdb3f3b36af372eadf0e499.1766131281.git.AlanSong-oc@zhaoxin.com>
 <20251219181805.GA1797@sol>
In-Reply-To: <20251219181805.GA1797@sol>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 1/12/2026 5:18:16 PM
X-Barracuda-Connect: ZXSHMBX2.zhaoxin.com[10.28.252.164]
X-Barracuda-Start-Time: 1768209497
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 8403
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.152921
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

On 12/20/2025 2:18 AM, Eric Biggers wrote:
> 
> [+Cc x86@kernel.org]
> 
> On Fri, Dec 19, 2025 at 04:03:05PM +0800, AlanSong-oc wrote:
>> diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
>> index d2845b214..069069377 100644
>> --- a/lib/crypto/Makefile
>> +++ b/lib/crypto/Makefile
>> @@ -205,7 +205,8 @@ endif
>>  libsha1-$(CONFIG_SPARC) += sparc/sha1_asm.o
>>  libsha1-$(CONFIG_X86) += x86/sha1-ssse3-and-avx.o \
>>                        x86/sha1-avx2-asm.o \
>> -                      x86/sha1-ni-asm.o
>> +                      x86/sha1-ni-asm.o \
>> +                      x86/sha1-phe-asm.o
>>  endif # CONFIG_CRYPTO_LIB_SHA1_ARCH
>>
>>  ################################################################################
>> diff --git a/lib/crypto/x86/sha1-phe-asm.S b/lib/crypto/x86/sha1-phe-asm.S
>> new file mode 100644
>> index 000000000..eff086104
>> --- /dev/null
>> +++ b/lib/crypto/x86/sha1-phe-asm.S
>> @@ -0,0 +1,71 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * PHE Extensions optimized implementation of a SHA-1 update function
>> + *
>> + * This file is provided under a dual BSD/GPLv2 license.  When using or
>> + * redistributing this file, you may do so under either license.
>> + *
>> + * GPL LICENSE SUMMARY
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of version 2 of the GNU General Public License as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + *
>> + * BSD LICENSE
>> + *
>> + * Redistribution and use in source and binary forms, with or without
>> + * modification, are permitted provided that the following conditions
>> + * are met:
>> + *
>> + *   * Redistributions of source code must retain the above copyright
>> + *     notice, this list of conditions and the following disclaimer.
>> + *   * Redistributions in binary form must reproduce the above copyright
>> + *     notice, this list of conditions and the following disclaimer in
>> + *     the documentation and/or other materials provided with the
>> + *     distribution.
>> + *   * Neither the name of Intel Corporation nor the names of its
>> + *     contributors may be used to endorse or promote products derived
>> + *     from this software without specific prior written permission.
>> + *
>> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
>> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
>> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
>> + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
>> + * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
>> + * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
>> + * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
>> + * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
>> + * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
>> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
>> + * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>> + *
>> + */
>> +
>> +#include <linux/linkage.h>
>> +
>> +/*
>> + * PHE Extensions optimized implementation of a SHA-1 block function
>> + *
>> + * This function takes a pointer to the current SHA-1 state, a pointer to the
>> + * input data, and the number of 64-byte blocks to process.  The number of
>> + * blocks to process is assumed to be nonzero.  Once all blocks have been
>> + * processed, the state is updated with the new state.  This function only
>> + * processes complete blocks.  State initialization, buffering of partial
>> + * blocks, and digest finalization are expected to be handled elsewhere.
>> + *
>> + * void sha1_transform_phe(u8 *state, const u8 *data, size_t nblocks)
>> + */
>> +.text
>> +SYM_FUNC_START(sha1_transform_phe)
>> +     mov             $-1, %rax
>> +     mov             %rdx, %rcx
>> +
>> +     .byte   0xf3,0x0f,0xa6,0xc8
>> +
>> +     RET
>> +SYM_FUNC_END(sha1_transform_phe)
> 
> Please make this an inline asm statement instead of using a .S file.
> It's just one instruction.

I will implement XSHA1 and XSHA256 instructions supported by the inline
asm statement in the next version of the patch.

> 
>> +#define PHE_ALIGNMENT 16
>> +asmlinkage void sha1_transform_phe(u8 *state, const u8 *data, size_t nblocks);
>> +static void sha1_blocks_phe(struct sha1_block_state *state,
>> +                          const u8 *data, size_t nblocks)
>> +{
>> +     /*
>> +      * XSHA1 requires %edi to point to a 32-byte, 16-byte-aligned
>> +      * buffer on Zhaoxin processors.
>> +      */
> 
> What is the largest 'nblocks' that the instruction supports?

According to the instruction specification, the maximum input data size
for the XSHA1 and XSHA256 instructions is limited by the maximum value
of CX, ECX, or RCX, depending on the operation mode. Accordingly, the
maximum value of 'nblocks'is subject to the same limitation.

> What happens if the instruction is interrupted partway through?  Does
> the CPU correctly resume it in all cases?

The specification states that XSHA1 and XSHA256 instructions are
interruptible. If an interrupt or exception occurs during execution,
the instruction can be correctly resumed after the interrupt or
exception has been handled.

> Is it supported in both 32-bit and 64-bit modes?  Your patch doesn't
> check for CONFIG_64BIT.  Should it?  New optimized assembly code
> generally should be 64-bit only.

The XSHA1 and XSHA256 are supported in both 32-bit and 64-bit modes.
Since newly optimized assembly code is typically 64-bit only, and XSHA1
and XSHA256 fully support 64-bit mode, an explicit CONFIG_64BIT check
should not required.

> Where is this instruction specified?  Please add a comment that links to
> the specification.

The instruction specification is available at the following
link.(https://gitee.com/openzhaoxin/zhaoxin_specifications/blob/20260112/ZX_Padlock_Reference.pdf)

> 
>> +     u8 buf[32 + PHE_ALIGNMENT - 1];
>> +     u8 *dst = PTR_ALIGN(&buf[0], PHE_ALIGNMENT);
>> +
>> +     memcpy(dst, (u8 *)(state), SHA1_DIGEST_SIZE);
>> +     sha1_transform_phe(dst, data, nblocks);
>> +     memcpy((u8 *)(state), dst, SHA1_DIGEST_SIZE);
>> +}
> 
> The casts to 'u8 *' are unnecessary.

I will eliminate the unnecessary cast in the next version of the patch.

>> +
>>  static void sha1_blocks(struct sha1_block_state *state,
>>                       const u8 *data, size_t nblocks)
>>  {
>> @@ -59,6 +76,9 @@ static void sha1_mod_init_arch(void)
>>  {
>>       if (boot_cpu_has(X86_FEATURE_SHA_NI)) {
>>               static_call_update(sha1_blocks_x86, sha1_blocks_ni);
>> +     } else if (boot_cpu_has(X86_FEATURE_PHE) && boot_cpu_has(X86_FEATURE_PHE_EN)) {
>> +             if (cpu_data(0).x86 >= 0x07)
>> +                     static_call_update(sha1_blocks_x86, sha1_blocks_phe);
> 
> Check IS_ENABLED(CONFIG_CPU_SUP_ZHAOXIN) first, so that the code gets
> compiled out when support for Zhaoxin CPUs isn't included in the kernel.
> 
> There are hardly any mentions of 'cpu_data(0).x86' in the kernel.  I
> think you mean 'boot_cpu_data.x86', which is used much more frequently.

I will add CONFIG_CPU_SUP_ZHAOXIN check in the relevant code paths and
use 'boot_cpu_data.x86' to identify the CPU family instead of
'cpu_data(0).x86.'

> What is the difference between X86_FEATURE_PHE and X86_FEATURE_PHE_EN,
> and why are both needed?
> 
> All these comments apply to the SHA-256 patch too.

The X86_FEATURE_PHE indicates the presence of the XSHA1 and XSHA256
instructions, whereas the X86_FEATURE_PHE_EN indicates that these
instructions are enabled for normal use. Surely, all of the suggestions
mentioned above will also apply to the SHA-256 patch.

Please accept my apologies for the delayed response due to
administrative procedures. Thank you for your review and valuable
suggestions.

Best Regards
AlanSong-oc
