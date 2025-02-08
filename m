Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F421ACED2;
	Sat,  8 Feb 2025 09:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739005654; cv=none; b=QFEB4d3L7tCaVlkGiqDC9eTb4QxBHYQu9K1mPetY6AZlcwwoelqi85rICmhEX15z6NY7NYpx92ETzA49vcbdVLexNUzRrxm8Zo5ZouYT+u+Djh+S5fdLVKywqvGKd6WNzW2AYPVJWilHb56y5VQHuTxgijPrzr5aUByAkDY3l9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739005654; c=relaxed/simple;
	bh=gmgM6qnspJyPPeEevFrxQ1pNgNpJZeT3J5KPCPHoxJY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qVkGbSkmWw8SAPJ/+rewFq//5SMj6rueMPXwPh08ksY/MhjR+hWS4pbMVC959G06J2k1A8ILhDLsE3XIu/IRICmpTLTScZgX0cRUljWtlLMx4eyiiIAPoM5ujqVYeJM5JrvSWmgeiVwIZZSd+xJ0vj9QqzH79mE5xFx78IMh528=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jNE//WYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jNE//WYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C85C4CEE4;
	Sat,  8 Feb 2025 09:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739005653;
	bh=gmgM6qnspJyPPeEevFrxQ1pNgNpJZeT3J5KPCPHoxJY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jNE//WYTwvHx/IhLAAUoKdBRV72fk5L1AJK+94O6VXv7ASOCK/GVIumAflkasico7
	 1bCCI05chAl0Y//nbWQa/+s7UKbW1bsoep0PtrAnC570r2KLOg8kaBDes2WLG9Lrlu
	 ooNBrOsGYHARCidy6YRkCzgCiNiMEwIiT2brnHL1efo10AZe+OapwAs37rrysSMFbr
	 dPW5cr1/xAoxTK/VlZFJnaMqvkumc7ntNpZgqMR1d0Ytd2nuRXlrkNOh2x637el8nN
	 z/EJRj+rETRHS2c1Xtv9LQULIHgP1iy5A8OAvvnsZSH0Owe6f+JKXFdjsEzKwof83c
	 m+cXy/Y7TrAYQ==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-54504a6955aso335789e87.2;
        Sat, 08 Feb 2025 01:07:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUDcb3ftvI20/h3GFB57XCkhZmKXrTVOCAxKkCMcD33U5pJOLsgxCMXC3ED/fq1n855jqvV5269yCV6aqo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZqbWyImB998yC//rSZdyDC9MMwdGcTe6SgYrlAh8Ql6iTN4ty
	IXJ/ze0BOeSkfqeeun26OR2F2OEHo/k0MQKUaqax39B4VuPnkRsdcdbqQCWXXcmeHYjnNzbQwn2
	eQaoi43ru1jOLxUYbp2TDraPeiBg=
X-Google-Smtp-Source: AGHT+IE3u++5lGokgNRf6tmGJPH5GO+cGJmOpvDQOzBK3oD6bKz/N+lFkmeKLuQ/gzZx4lxiY5tyxjRBERb5aHVInBc=
X-Received: by 2002:a05:6512:b9a:b0:540:1f7d:8b9c with SMTP id
 2adb3069b0e04-54414ae5fd6mr2479683e87.45.1739005651496; Sat, 08 Feb 2025
 01:07:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250208035213.109836-1-ebiggers@kernel.org>
In-Reply-To: <20250208035213.109836-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sat, 8 Feb 2025 10:07:20 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGr38moMGUj-p1m3u=N=RZ7XKfnCfPebd1+rTGgwmJfKQ@mail.gmail.com>
X-Gm-Features: AWEUYZnOzyRcbu7HS6_Dq1Y3G-QaV7QZQ78tzN0zR1_EWz3Z7-Fe3eXD3iqcQa4
Message-ID: <CAMj1kXGr38moMGUj-p1m3u=N=RZ7XKfnCfPebd1+rTGgwmJfKQ@mail.gmail.com>
Subject: Re: [PATCH v3] crypto: x86/aes-ctr - rewrite AESNI+AVX optimized CTR
 and add VAES support
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Sat, 8 Feb 2025 at 04:52, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Delete aes_ctrby8_avx-x86_64.S and add a new assembly file
> aes-ctr-avx-x86_64.S which follows a similar approach to
> aes-xts-avx-x86_64.S in that it uses a "template" to provide AESNI+AVX,
> VAES+AVX2, VAES+AVX10/256, and VAES+AVX10/512 code, instead of just
> AESNI+AVX.  Wire it up to the crypto API accordingly.
>
> This greatly improves the performance of AES-CTR and AES-XCTR on
> VAES-capable CPUs, with the best case being AMD Zen 5 where an over 230%
> increase in throughput is seen on long messages.  Performance on
> non-VAES-capable CPUs remains about the same, and the non-AVX AES-CTR
> code (aesni_ctr_enc) is also kept as-is for now.  There are some slight
> regressions (less than 10%) on some short message lengths on some CPUs;
> these are difficult to avoid, given how the previous code was so heavily
> unrolled by message length, and they are not particularly important.
> Detailed performance results are given in the tables below.
>
> Both CTR and XCTR support is retained.  The main loop remains
> 8-vector-wide, which differs from the 4-vector-wide main loops that are
> used in the XTS and GCM code.  A wider loop is appropriate for CTR and
> XCTR since they have fewer other instructions (such as vpclmulqdq) to
> interleave with the AES instructions.
>
> Similar to what was the case for AES-GCM, the new assembly code also has
> a much smaller binary size, as it fixes the excessive unrolling by data
> length and key length present in the old code.  Specifically, the new
> assembly file compiles to about 9 KB of text vs. 28 KB for the old file.
> This is despite 4x as many implementations being included.
>
> The tables below show the detailed performance results.  The tables show
> percentage improvement in single-threaded throughput for repeated
> encryption of the given message length; an increase from 6000 MB/s to
> 12000 MB/s would be listed as 100%.  They were collected by directly
> measuring the Linux crypto API performance using a custom kernel module.
> The tested CPUs were all server processors from Google Compute Engine
> except for Zen 5 which was a Ryzen 9 9950X desktop processor.
>
> Table 1: AES-256-CTR throughput improvement,
>          CPU microarchitecture vs. message length in bytes:
>
>                      | 16384 |  4096 |  4095 |  1420 |   512 |   500 |
> ---------------------+-------+-------+-------+-------+-------+-------+
> AMD Zen 5            |  232% |  203% |  212% |  143% |   71% |   95% |
> Intel Emerald Rapids |  116% |  116% |  117% |   91% |   78% |   79% |
> Intel Ice Lake       |  109% |  103% |  107% |   81% |   54% |   56% |
> AMD Zen 4            |  109% |   91% |  100% |   70% |   43% |   59% |
> AMD Zen 3            |   92% |   78% |   87% |   57% |   32% |   43% |
> AMD Zen 2            |    9% |    8% |   14% |   12% |    8% |   21% |
> Intel Skylake        |    7% |    7% |    8% |    5% |    3% |    8% |
>
>                      |   300 |   200 |    64 |    63 |    16 |
> ---------------------+-------+-------+-------+-------+-------+
> AMD Zen 5            |   57% |   39% |   -9% |    7% |   -7% |
> Intel Emerald Rapids |   37% |   42% |   -0% |   13% |   -8% |
> Intel Ice Lake       |   39% |   30% |   -1% |   14% |   -9% |
> AMD Zen 4            |   42% |   38% |   -0% |   18% |   -3% |
> AMD Zen 3            |   38% |   35% |    6% |   31% |    5% |
> AMD Zen 2            |   24% |   23% |    5% |   30% |    3% |
> Intel Skylake        |    9% |    1% |   -4% |   10% |   -7% |
>
> Table 2: AES-256-XCTR throughput improvement,
>          CPU microarchitecture vs. message length in bytes:
>
>                      | 16384 |  4096 |  4095 |  1420 |   512 |   500 |
> ---------------------+-------+-------+-------+-------+-------+-------+
> AMD Zen 5            |  240% |  201% |  216% |  151% |   75% |  108% |
> Intel Emerald Rapids |  100% |   99% |  102% |   91% |   94% |  104% |
> Intel Ice Lake       |   93% |   89% |   92% |   74% |   50% |   64% |
> AMD Zen 4            |   86% |   75% |   83% |   60% |   41% |   52% |
> AMD Zen 3            |   73% |   63% |   69% |   45% |   21% |   33% |
> AMD Zen 2            |   -2% |   -2% |    2% |    3% |   -1% |   11% |
> Intel Skylake        |   -1% |   -1% |    1% |    2% |   -1% |    9% |
>
>                      |   300 |   200 |    64 |    63 |    16 |
> ---------------------+-------+-------+-------+-------+-------+
> AMD Zen 5            |   78% |   56% |   -4% |   38% |   -2% |
> Intel Emerald Rapids |   61% |   55% |    4% |   32% |   -5% |
> Intel Ice Lake       |   57% |   42% |    3% |   44% |   -4% |
> AMD Zen 4            |   35% |   28% |   -1% |   17% |   -3% |
> AMD Zen 3            |   26% |   23% |   -3% |   11% |   -6% |
> AMD Zen 2            |   13% |   24% |   -1% |   14% |   -3% |
> Intel Skylake        |   16% |    8% |   -4% |   35% |   -3% |
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>

Very nice results! One remark below.
...
> diff --git a/arch/x86/crypto/aes-ctr-avx-x86_64.S b/arch/x86/crypto/aes-ctr-avx-x86_64.S
> new file mode 100644
> index 0000000000000..25cab1d8e63f9
> --- /dev/null
> +++ b/arch/x86/crypto/aes-ctr-avx-x86_64.S
> @@ -0,0 +1,592 @@
> +/* SPDX-License-Identifier: Apache-2.0 OR BSD-2-Clause */
> +//
> +// Copyright 2025 Google LLC
> +//
> +// Author: Eric Biggers <ebiggers@google.com>
> +//
> +// This file is dual-licensed, meaning that you can use it under your choice of
> +// either of the following two licenses:
> +//
> +// Licensed under the Apache License 2.0 (the "License").  You may obtain a copy
> +// of the License at
> +//
> +//     http://www.apache.org/licenses/LICENSE-2.0
> +//
> +// Unless required by applicable law or agreed to in writing, software
> +// distributed under the License is distributed on an "AS IS" BASIS,
> +// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
> +// See the License for the specific language governing permissions and
> +// limitations under the License.
> +//
> +// or
> +//
> +// Redistribution and use in source and binary forms, with or without
> +// modification, are permitted provided that the following conditions are met:
> +//
> +// 1. Redistributions of source code must retain the above copyright notice,
> +//    this list of conditions and the following disclaimer.
> +//
> +// 2. Redistributions in binary form must reproduce the above copyright
> +//    notice, this list of conditions and the following disclaimer in the
> +//    documentation and/or other materials provided with the distribution.
> +//
> +// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
> +// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> +// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
> +// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
> +// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> +// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
> +// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
> +// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
> +// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
> +// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
> +// POSSIBILITY OF SUCH DAMAGE.
> +//
> +//------------------------------------------------------------------------------
> +//
> +// This file contains x86_64 assembly implementations of AES-CTR and AES-XCTR
> +// using the following sets of CPU features:
> +//     - AES-NI && AVX
> +//     - VAES && AVX2
> +//     - VAES && (AVX10/256 || (AVX512BW && AVX512VL)) && BMI2
> +//     - VAES && (AVX10/512 || (AVX512BW && AVX512VL)) && BMI2
> +//
> +// See the function definitions at the bottom of the file for more information.
> +
> +#include <linux/linkage.h>
> +#include <linux/cfi_types.h>
> +
> +.section .rodata
> +.p2align 4
> +
> +.Lbswap_mask:
> +       .octa   0x000102030405060708090a0b0c0d0e0f
> +
> +.Lctr_pattern:
> +       .quad   0, 0
> +.Lone:
> +       .quad   1, 0
> +.Ltwo:
> +       .quad   2, 0
> +       .quad   3, 0
> +
> +.Lfour:
> +       .quad   4, 0
> +
> +.text
> +
> +// Move a vector between memory and a register.
> +// The register operand must be in the first 16 vector registers.
> +.macro _vmovdqu        src, dst
> +.if VL < 64
> +       vmovdqu         \src, \dst
> +.else
> +       vmovdqu8        \src, \dst
> +.endif
> +.endm
> +
> +// Move a vector between registers.
> +// The registers must be in the first 16 vector registers.
> +.macro _vmovdqa        src, dst
> +.if VL < 64
> +       vmovdqa         \src, \dst
> +.else
> +       vmovdqa64       \src, \dst
> +.endif
> +.endm
> +
> +// Broadcast a 128-bit value from memory to all 128-bit lanes of a vector
> +// register.  The register operand must be in the first 16 vector registers.
> +.macro _vbroadcast128  src, dst
> +.if VL == 16
> +       vmovdqu         \src, \dst
> +.elseif VL == 32
> +       vbroadcasti128  \src, \dst
> +.else
> +       vbroadcasti32x4 \src, \dst
> +.endif
> +.endm
> +
> +// XOR two vectors together.
> +// Any register operands must be in the first 16 vector registers.
> +.macro _vpxor  src1, src2, dst
> +.if VL < 64
> +       vpxor           \src1, \src2, \dst
> +.else
> +       vpxord          \src1, \src2, \dst
> +.endif
> +.endm
> +
> +// Load 1 <= %ecx <= 15 bytes from the pointer \src into the xmm register \dst
> +// and zeroize any remaining bytes.  Clobbers %rax, %rcx, and \tmp{64,32}.
> +.macro _load_partial_block     src, dst, tmp64, tmp32
> +       sub             $8, %ecx                // LEN - 8
> +       jle             .Lle8\@
> +
> +       // Load 9 <= LEN <= 15 bytes.
> +       vmovq           (\src), \dst            // Load first 8 bytes
> +       mov             (\src, %rcx), %rax      // Load last 8 bytes
> +       neg             %ecx
> +       shl             $3, %ecx
> +       shr             %cl, %rax               // Discard overlapping bytes
> +       vpinsrq         $1, %rax, \dst, \dst
> +       jmp             .Ldone\@
> +
> +.Lle8\@:
> +       add             $4, %ecx                // LEN - 4
> +       jl              .Llt4\@
> +
> +       // Load 4 <= LEN <= 8 bytes.
> +       mov             (\src), %eax            // Load first 4 bytes
> +       mov             (\src, %rcx), \tmp32    // Load last 4 bytes
> +       jmp             .Lcombine\@
> +
> +.Llt4\@:
> +       // Load 1 <= LEN <= 3 bytes.
> +       add             $2, %ecx                // LEN - 2
> +       movzbl          (\src), %eax            // Load first byte
> +       jl              .Lmovq\@
> +       movzwl          (\src, %rcx), \tmp32    // Load last 2 bytes
> +.Lcombine\@:
> +       shl             $3, %ecx
> +       shl             %cl, \tmp64
> +       or              \tmp64, %rax            // Combine the two parts
> +.Lmovq\@:
> +       vmovq           %rax, \dst
> +.Ldone\@:
> +.endm
> +
> +// Store 1 <= %ecx <= 15 bytes from the xmm register \src to the pointer \dst.
> +// Clobbers %rax, %rcx, and \tmp{64,32}.
> +.macro _store_partial_block    src, dst, tmp64, tmp32
> +       sub             $8, %ecx                // LEN - 8
> +       jl              .Llt8\@
> +
> +       // Store 8 <= LEN <= 15 bytes.
> +       vpextrq         $1, \src, %rax
> +       mov             %ecx, \tmp32
> +       shl             $3, %ecx
> +       ror             %cl, %rax
> +       mov             %rax, (\dst, \tmp64)    // Store last LEN - 8 bytes
> +       vmovq           \src, (\dst)            // Store first 8 bytes
> +       jmp             .Ldone\@
> +
> +.Llt8\@:
> +       add             $4, %ecx                // LEN - 4
> +       jl              .Llt4\@
> +
> +       // Store 4 <= LEN <= 7 bytes.
> +       vpextrd         $1, \src, %eax
> +       mov             %ecx, \tmp32
> +       shl             $3, %ecx
> +       ror             %cl, %eax
> +       mov             %eax, (\dst, \tmp64)    // Store last LEN - 4 bytes
> +       vmovd           \src, (\dst)            // Store first 4 bytes
> +       jmp             .Ldone\@
> +
> +.Llt4\@:
> +       // Store 1 <= LEN <= 3 bytes.
> +       vpextrb         $0, \src, 0(\dst)
> +       cmp             $-2, %ecx               // LEN - 4 == -2, i.e. LEN == 2?
> +       jl              .Ldone\@
> +       vpextrb         $1, \src, 1(\dst)
> +       je              .Ldone\@
> +       vpextrb         $2, \src, 2(\dst)
> +.Ldone\@:
> +.endm
> +
> +// Prepare the next two vectors of AES inputs in AESDATA\i0 and AESDATA\i1, and
> +// XOR each with the zero-th round key.  Also update LE_CTR if !\final.
> +.macro _prepare_2_ctr_vecs     is_xctr, i0, i1, final=0
> +.if \is_xctr
> +  .if USE_AVX10
> +       _vmovdqa        LE_CTR, AESDATA\i0
> +       vpternlogd      $0x96, XCTR_IV, RNDKEY0, AESDATA\i0
> +  .else
> +       vpxor           XCTR_IV, LE_CTR, AESDATA\i0
> +       vpxor           RNDKEY0, AESDATA\i0, AESDATA\i0
> +  .endif
> +       vpaddq          LE_CTR_INC1, LE_CTR, AESDATA\i1
> +
> +  .if USE_AVX10
> +       vpternlogd      $0x96, XCTR_IV, RNDKEY0, AESDATA\i1
> +  .else
> +       vpxor           XCTR_IV, AESDATA\i1, AESDATA\i1
> +       vpxor           RNDKEY0, AESDATA\i1, AESDATA\i1
> +  .endif
> +.else
> +       vpshufb         BSWAP_MASK, LE_CTR, AESDATA\i0
> +       _vpxor          RNDKEY0, AESDATA\i0, AESDATA\i0
> +       vpaddq          LE_CTR_INC1, LE_CTR, AESDATA\i1
> +       vpshufb         BSWAP_MASK, AESDATA\i1, AESDATA\i1
> +       _vpxor          RNDKEY0, AESDATA\i1, AESDATA\i1
> +.endif
> +.if !\final
> +       vpaddq          LE_CTR_INC2, LE_CTR, LE_CTR
> +.endif
> +.endm
> +
> +// Do all AES rounds on the data in the given AESDATA vectors, excluding the
> +// zero-th and last rounds.
> +.macro _aesenc_loop    vecs

If you make this vecs:vararg, you can drop the "" around the arguments
in the callers.


> +       mov             KEY, %rax
> +1:
> +       _vbroadcast128  (%rax), RNDKEY
> +.irp i, \vecs
> +       vaesenc         RNDKEY, AESDATA\i, AESDATA\i
> +.endr
> +       add             $16, %rax
> +       cmp             %rax, RNDKEYLAST_PTR
> +       jne             1b
> +.endm
> +
> +// Finalize the keystream blocks in the given AESDATA vectors by doing the last
> +// AES round, then XOR those keystream blocks with the corresponding data.
> +// Reduce latency by doing the XOR before the vaesenclast, utilizing the
> +// property vaesenclast(key, a) ^ b == vaesenclast(key ^ b, a).
> +.macro _aesenclast_and_xor     vecs

Same here

> +.irp i, \vecs
> +       _vpxor          \i*VL(SRC), RNDKEYLAST, RNDKEY
> +       vaesenclast     RNDKEY, AESDATA\i, AESDATA\i
> +.endr
> +.irp i, \vecs
> +       _vmovdqu        AESDATA\i, \i*VL(DST)
> +.endr
> +.endm
> +

...
