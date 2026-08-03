Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9A630BF4F
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 08:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785745946; cv=pass; b=RS+lsUWfU1/h6NRwSEbRTaRexzqzfTtHY3NRyTHf/X3Mo8NcVC+GZFXe5Upitk9KpiV/em3Lr27fpLftghKG7LKVr+sQVUHSqua+0BVFntcNTXk2XGCcAgIY6oZCWM3/XXD+3WeKh5oohpqez+DcO0255L1UJmITQZX+71WRVQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785745946; c=relaxed/simple;
	bh=xYYHChe17nP8+m29jDvjKXwh04GS3X3rOdU2gwJuP44=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jdQ8N36WPBvvRUar144Y2m1Dw/sbsZFEQCmVQ70PkhHpLTnQYiXR2k5srHtPVe3+oJ68jhdEfAXdzC4nF5IUjEa2Mi1GrCYKZ94RYCjDIcyrErrdaeB5sM0exQYhp1EaJGEJNB5O01AZ2mx4PIAbIZcDheqpUSnJEc5IMz7M7+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jO38H2s2; arc=pass smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jO38H2s2"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-6679d88abdcso4385344d50.2
        for <linux-crypto@vger.kernel.org>; Mon, 03 Aug 2026 01:32:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785745943; cv=none;
        d=google.com; s=arc-20260327;
        b=HkCSnADkHox2suOUDzPI9OQH6sueNMFmcTtuV2DRI4iGrJC3WTxLUvMFsaFJyztZpa
         hhxn3+uApvY5zktXqbjjKU4nnSVAdLbakqamAvDw2hZ0BJnwRoC9C76lyhSsC02/TjhU
         p0dyqU67fJmLPB4+vxFN276TPqSQuWesigdtdE1r2ITQwUhuUjYOQdONDJc25dCOKoha
         1xxVf0w8qbtuoh5vOgHW+VfD4Tc8HtWQYIivf+/GnI9LTZ0xQT+TU5bVzFc8agdNll9P
         t7AuDap36sKYcUDSgLq0jzL42swGcrbTiz0kORssKfP+Dw6lGlg2D7TTYLNI4tGADc8R
         M72w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=XZ0D5QeK4G3jR4XXSuQ5o1U+5KXDkz0QLmZML4R0I1o=;
        fh=O2ZAyWs7NG09bqGXz4DdPu3NH8hAQV89K8EkeBuoOAg=;
        b=JUW1IOHtV3qeTfhS7SZ+O0WejrOL0eiw2X3kjvzYlWnSg3Od7buOBzNN0H9DD7tuVn
         VMuS0GOFqZs41a5FppRZ1qbkGeo/7sRsm+5EtrzAO+FfjsXCBhg8/KRS3y9TdzU0s3C6
         s6F3038tRWDDSjGTLxfHSaU1cvqR9x3ycRhtCPiFvJAHTni5WUSoNz+Xpt+TmmmER+dg
         MKx8akcdKCsqA1lTU0AgQF136hkII99PCWbSt9ffLRmi4iU2QwiK4cUEUBRZi5f4U7Fq
         Xx10M8dcFMLpppXsN7S7+1icKhNgH8+dKdaiKSxWxyNdTLcR7vIsUlBUExBq5WqVPkQU
         fgLQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785745943; x=1786350743; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XZ0D5QeK4G3jR4XXSuQ5o1U+5KXDkz0QLmZML4R0I1o=;
        b=jO38H2s2VRSNHd6YhFq4Xw1OG3fUPCpqaG3UviEcHH15UBH23UyoHeJZg4pXqkPVi1
         L6L2eKLohUzvtD3G9MRI4W//cWmshE96lpgfC4ZXROoSOv0y368faysGjVrrsj5NJTy4
         jrk27MSg1gsx3kkuJkgUP+WJJg7LC5micBoUEosqjKDCexdu7SChFYXddBs28hOWIuQf
         0uhTrIQfc3AAwmTRBbmtFfzeuowPrzjbEtprNTjRp0xh5o5wFPdJfJtqqPvYB+6shdDM
         xVZ/kbSetfVVGavEqaMliyH5AE0gEM0IiV4i5DygslZQIWWGFAxO32ptNbDX6htQSJC7
         dJrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785745943; x=1786350743;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XZ0D5QeK4G3jR4XXSuQ5o1U+5KXDkz0QLmZML4R0I1o=;
        b=U2Giq1NMJWw+AA8yyBs10BFVXNPy4GsaqQ5HHknz60v1dRqLgcNG05dkn+i7LlcOk4
         yNlvoqQ4l4LQ2PR0fGdegKI65zGKANdIT7AARs3ezNc95Jybuld6AeteCmXDslQqgL2L
         aDuvPi/wvxOeuWhxFGus2gkOwifi6f+N4BfXxvxoU4v5ypBES2EwQfPZcQmI1lVnzGiS
         171B3c5E8/8mRmu1OJQJxQx0RJdSm+6d5QE0N3BRUjhV+DLAnedfiPal+oyo/lhVw4hx
         8deajZMLN846n8LK3gSRlbl32fCFSHW0ZFy67GIrXmDbG9mmESrc6HvfoWIuMMwP9nAZ
         H5Dw==
X-Forwarded-Encrypted: i=1; AHgh+RrbOJMkupHi+DnTswEQU3nRS/Z4qsudxrmMM3QUMlnq5VaQCvnZssh/ZSp1XFk1LWE1qeDnNpgxdB6qTp8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLC+TTItkyQeN5KDC6vXKwdUtzUOPdXXrAAkXDACpuk4oQGpNb
	evkdmO1s92kWnvdvkphILsDUa8WquE2WafMyxetBTXTOb8SobZQdw4ilGegMxrVV9cq60DOjyez
	cVOCCjKEVaGZuhOot88GFbyAbREVr8UI=
X-Gm-Gg: AR+sD114PdZYwjlruAZLPpkAyzPcos4KqZBzDBNgMTb1/n2bbn6VY4M7oHSE3+FS6qA
	sY3T7w2i+m69LC9tWvG/PfXIMjA9f1BeQ0CTqzB4Rzu5XcLX57Jzm4C/P+9hG7dknaZQadxFd2Z
	pl8IqCWbG28vxhglyZvG1O/1ArxiuONxl+5mg/Nd0A+t1JHzb7sdxKUehWs9iEO8T7tXzT9vHuO
	yqTHgXbziXTHCO2ekQVF1B8suX04r1efw9lJhlodwGR8eTFx8RKT6cimFS2ChuKfZ7DJwnuTx03
	KQzTlGv5v10WgLuvXATQuiDn3hIb7VngpnrgxpfA0hyvjm7JaTg+U70wB1T/M1C1Xj+m3TR9L3e
	eLxZ8H+ZQlCjReF0=
X-Received: by 2002:a53:db0b:0:b0:668:568e:8618 with SMTP id
 956f58d0204a3-6694efde7fdmr8659151d50.1.1785745943383; Mon, 03 Aug 2026
 01:32:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260607112435.42804-1-fabianblatter09@gmail.com> <aknsgpnZsjmLtcT_@gondor.apana.org.au>
In-Reply-To: <aknsgpnZsjmLtcT_@gondor.apana.org.au>
From: Fabian <fabianblatter09@gmail.com>
Date: Mon, 3 Aug 2026 10:32:12 +0200
X-Gm-Features: AUfX_mxdZiCM5ORsrRCViG7N96DwXFPFPFPAZkr8mByG9vHiIfCY4OUze3Tg6bA
Message-ID: <CAGtAT=n+wEp+BLVBo57cx3nYX8Juj5NXvmhU=ueAVshSL1Bd6g@mail.gmail.com>
Subject: Re: [PATCH] crypto: ecc - Optimize vli additive operations using
 compiler builtins
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: lukas@wunner.de, ignat@linux.win, davem@davemloft.net, 
	stefanb@linux.ibm.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 5 Jul 2026 at 07:33, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Sun, Jun 07, 2026 at 01:24:35PM +0200, Fabian Blatter wrote:
> > Replace the software carry flag emulation with compiler builtins.
> >
> > Even the newest compilers struggle with taking advantage of the
> > hardware carry flag. Compiler builtins allow the compiler to
> > much more easily achieve this while still remaining constant-time.
> >
> > This yields an approximately 6-7% performance improvement
> > on the ecc_gen_privkey, ecc_make_pub_key and crypto_ecdh_shared_secret
> > functions on x86_64 on all curve sizes.
> >
> > Additionally, the code becomes much more readable.
> >
> > Signed-off-by: Fabian Blatter <fabianblatter09@gmail.com>
> > ---
> >
> > Hi,
> >
> > I'd like to expand on the benchmarks, compare the generated assembly,
> > and clarify some things.
> >
> >
> > Use of compiler builtins:
> >
> > This patch uses __builtin_addcll, __builtin_subcll when available and
> > otherwise __builtin_uaddll_overflow, __builtin_usubll_overflow. the
> > latter have existed since ancient gcc versions, so no third fallback
> > is needed.
> >
> > I have put the add_carry and sub_borrow inline functions with the
> > preprocessor logic for builtin selection directly in crypto/ecc.c.
> > Please let me know if you would like them to be somewhere else.
> >
> > They do not emit data-dependent branches, and so remain constant-time.
> >
> >
> > Benchmarks:
> >
> > All benchmarks were run single-threaded on my AMD 7700X CPU limited to
> > 5.6Ghz. I have measured both nanoseconds and clock cycles, since their
> > combination can hint at downclocking issues and allows calculation of
> > the clock speed during the benchmark.
> >
> > I have omitted the raw output from the benchmarking code, as they much
> > exceed the 72 character limit.
> >
> > I have calculated the percent differences, included clock speed
> > calculations and relevant summaries.
> >
> >
> > Macro benchmarks:
> >
> > These were run in a virtualized environment using virtme-ng on the
> > compiled linux kernel image compiled with default flags.
> >
> > (the first value is the original time per operation, the second the
> > patched one. cc is short for clock cycles)
> >
> > Curve keypair generation (ecc_gen_privkey + ecc_make_pub_key):
> >
> > P256:
> >  - 646963ns/op -> 600632ns/op = -7.71%
> >  - 2911300cc/op -> 2702854cc/op = -7.71%
> >  - 4.4999Ghz -> 4.5000Ghz = no difference
> >
> > P384:
> >  - 1239160ns/op -> 1153940ns/op = -7.38%
> >  - 5576250cc/op -> 5192749cc/op = -7.38%
> >  - 4.5000Ghz -> 4.5000Ghz = no difference
> >
> > Shared secret generation (crypto_ecdh_shared_secret):
> >
> > P256:
> >  - 320114ns/op -> 297548ns/op = -7.58%
> >  - 1440521cc/op -> 1338972cc/op = -7.58%
> >  - 4.5000Ghz -> 4.5000Ghz = no difference
> >
> > P384:
> >  - 620768ns/op -> 582560ns/op = -6.55%
> >  - 2793467cc/op -> 2621529cc/op = -6.55%
> >  - 4.5000Ghz -> 4.5000Ghz = no difference
> >
> > The benchmarks clearly indicate a roughly 6-7% performance increase on
> > the public API functions. It also appears that virtme-ng limited the
> > clock speed to 4.5Ghz
> >
> >
> > Micro benchmarks:
> >
> > Since the vli additive functions only rely on u64 being defined, these
> > were run without virtualization and with varying compilers and
> > compiler flags.
> >
> > The microbenchmarks show much more mixed results, depending
> > heavily on the compiler and optimization level used.
> >
> > For instance, on gcc and O2, the vli_add present in the
> > patch is actually 25.3% slower than the original one. I have tracked
> > this down to gcc using a weird way to restore the carry flag after
> > each iteration, causing way more dependent instructions, preventing
> > ILP from executing multiple at once.
> >
> > This is quite interesting, since, as far as I know, the kernel compiles
> > with gcc and O2 by default, yet the macro-level benchmarks still show a
> > performance increase. The effect seems to be reversed when crypto/ecc.c
> > gets compiled. Or maybe the linux kernel uses some additional
> > optimization flags, I am unsure.
> >
> > However, most of the time, the patched version outperforms the original
> > one by a wide margin:
> >  - On clang -O2 or -O3, vli_add and vli_uadd show a 4.074x and 5.384x
> >    speedup.
> >  - On gcc, vli_uadd shows a 74% performance increase at O2,
> >    and a 2.07x speedup at O3.
> >
> > The performance profile of vli_sub and vli_usub is almost identical to
> > that of vli_add and vli_uadd.
> >
> >
> > Assembly comparison:
> >
> > I have put together a piece of code on Compiler explorer, to make sure
> > it compiles on old gcc versions, view instructions and play around with
> > compiler settings.
> >
> > If you would like, you can play around yourself here:
> > https://godbolt.org/z/1jT5zesz8
> >
> > When using clang 22.1 at -O3 -march=lunarlake, the difference between
> > the patched and original version is particularly clear. The patched
> > version produces this assembly in the unrolled vli_add loop:
> >
> > mov     rax, qword ptr [rsi + 8*rcx + 16]
> > adc     rax, qword ptr [rdx + 8*rcx + 16]
> > mov     qword ptr [rdi + 8*rcx + 16], rax
> > mov     rax, qword ptr [rsi + 8*rcx + 24]
> > adc     rax, qword ptr [rdx + 8*rcx + 24]
> > mov     qword ptr [rdi + 8*rcx + 24], rax
> > mov     rax, qword ptr [rsi + 8*rcx + 32]
> > adc     rax, qword ptr [rdx + 8*rcx + 32]
> > mov     qword ptr [rdi + 8*rcx + 32], rax
> > mov     rax, qword ptr [rsi + 8*rcx + 40]
> > adc     rax, qword ptr [rdx + 8*rcx + 40]
> > mov     qword ptr [rdi + 8*rcx + 40], rax
> > mov     rax, qword ptr [rsi + 8*rcx + 48]
> > adc     rax, qword ptr [rdx + 8*rcx + 48]
> >
> > This is basically optimal for an inner loop. It's pure adc and mov
> > instructions. The loop counting part is still nowhere near perfect,
> > and still uses setc instructions. But it is still better than what
> > the original version produces with the same compiler and flags:
> >
> > mov     r10, qword ptr [rsi + 8*rcx]
> > lea     r11, [r10 + rax]
> > add     r11, qword ptr [rdx + 8*rcx]
> > xor     ebx, ebx
> > cmp     r11, r10
> > setb    bl
> > cmove   rbx, rax
> > mov     qword ptr [rdi + 8*rcx], r11
> > mov     rax, qword ptr [rsi + 8*rcx + 8]
> > lea     r10, [rax + rbx]
> > add     r10, qword ptr [rdx + 8*rcx + 8]
> > xor     r11d, r11d
> > cmp     r10, rax
> > setb    r11b
> > cmove   r11, rbx
> > mov     qword ptr [rdi + 8*rcx + 8], r10
> > mov     rax, qword ptr [rsi + 8*rcx + 16]
> > lea     r10, [rax + r11]
> > add     r10, qword ptr [rdx + 8*rcx + 16]
> > xor     ebx, ebx
> > cmp     r10, rax
> > setb    bl
> > cmove   rbx, r11
> > mov     qword ptr [rdi + 8*rcx + 16], r10
> > mov     rax, qword ptr [rsi + 8*rcx + 24]
> > lea     r10, [rax + rbx]
> > add     r10, qword ptr [rdx + 8*rcx + 24]
> > xor     r11d, r11d
> > cmp     r10, rax
> > setb    r11b
> > cmove   r11, rbx
> >
> > This is downright horrendous. that entire block of processes only 4
> > limbs, thats 8 instructions per limb! The add instructions
> > are also not adc instructions, showing that the carry flag is
> > being fully emulated. This demonstrates how even on the newest
> > compilers and at the highest optimization level, still cannot
> > generate hardware carry chains without explicit use of builtins.
> >
> > I should note that not just clang 22.1.0 with -O3 -march=lunarlake
> > does this. Gcc and clang show this behaviour on every version i have
> > tested, regardless of target architecture.
> >
> > I am not very familiar with ARM or RISC-V assembly, but looking at
> > compiler explorer, the effect clearly persists, and in the case of
> > RISC-V actually gets much worse.
> >
> > This affects all architectures across all compilers and compiler
> > flags.
> >
> >
> > If you have gotten this far, thank you for reading this and I am looking
> > forward to any feedback! If you would like any changes to this patch,
> > I am very happy to send a v2.
> >
> >  crypto/ecc.c | 98 ++++++++++++++++++++++++++++++++--------------------
> >  1 file changed, 60 insertions(+), 38 deletions(-)
>
> Patch applied.  Thanks.
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


Hi,

So about the rewrite of crypto/ecc.c to a constant-time
Montgomery ladder, I'd like to just make sure it is still on the table.

I also have a few questions about the rewrite:

The paper (https://eprint.iacr.org/2020/956.pdf), which is mentioned
in the conversation Lukas sent, uses a different type of curve
than the current implementation. Is a rewrite using entirely different
elliptic curves intended, or is there some other algorithm that
should be used with the existing NIST curves?

The paper also talks about assembly and how to make
it constant-time by avoiding memory operations
and doing everything in registers. Is it intended
to be an Assembly implementation or is C acceptable?
If it is Assembly, I could only reasonably contribute an x64
version.

Regards,
Fabian
