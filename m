Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65ACC39099C
	for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2026 08:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781340519; cv=none; b=Pc9UQuC+GyCbF+t3hqnmlYVGQsy/utwVcpuPGWwQm62DrVTJRDTBLDmJaZTJRu2ZFO3YEbxiYqU6fa4bp5pqFQTpwkMg2pz4soj2sRr6vUkqN5gDshjMHPU/LJohqpLho4TNyscPWl61xiG6XoShO1S9K3/hDhRBCzk1mKXEdik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781340519; c=relaxed/simple;
	bh=IdptGwwcFFFzByTZsszIDzZbl6hQFeR2QSn/bKfyXqM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AlMrHl3VU3L7UGAiNcc6ZuyXKwe0/MfpbCBNsGZFi+Q5zsd76U1mIn/r/Mv4SLwSP3c26oJsZ7zryfIxmlcZN/w/G+M0P3GOzJyFiMO7BuL5Dv/G5E5Uj1l+idrk92AIz5NwakQC2fxWN1oWseyMQHCu6jRr08AJnlXQnxHi68E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OunqXrK2; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OunqXrK2"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490be29c1c5so18661025e9.2
        for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2026 01:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781340514; x=1781945314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R49kX3+mgwJkgpboNL4QAg+sevZ4S4p2C6ehpXxyb+k=;
        b=OunqXrK2plLs8O1Pif3FmJtDmof4Bl9VXxzY1AaLo0dS4k6PfmFRCuc3WIdFT09k4B
         QQsrs3ZKL0/SpWXiK2VQxHm983UkqNUnhAyxQTDAcvCDisjWs6wEz/X9uinT80c74zdk
         +E+Jna+ZvkxWNqvfUifra5um52zPDwKXBJEZ5xuF7u772/8LJKCdAkq6i+6DiZG2nPo0
         TB+hx2mE7Uuc9s8t5q99g7zxjMKTfXPpx6u/9CQn+jmrHHpvKSOlJVo4oBYdX8ys7QZy
         Og+bMBAcKGpC+J0ZRdKONcMssYlVeHErDvVFUFpYBd2w8clKIE+1zlKKb5Ds0Qr6aeZl
         1AjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781340514; x=1781945314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R49kX3+mgwJkgpboNL4QAg+sevZ4S4p2C6ehpXxyb+k=;
        b=bdv+f1PetjBx89PHCTHE+iLZi01bUjfMQtOKrLQJp12HH1n0aQ6RYFZ970IRZbFBrd
         ql1oJHBUsA/CBzEUCyj4ZhRlYXR1vD28v19PMQ8uHnoj/bMu5+fBffK/tqUvtitHugg6
         uCZite6yzV8bBfAFZnjt/ktqMewfO/TGcafadTj8iSkP5TMuwczmae4OsMxHQFVPjVIY
         QFK8zGQ9hIl3lNzjBpRY920gaHRAd9Vg2pMcfl6q0k4RDV64cdPbGEdaKiYd3SEaeb/h
         M71smMWZ6EIuY86I6dJRlZh3aIrTULn51gddTQNBizwyq4sXPsWStvAcbaacxMhtIxQh
         /lUw==
X-Forwarded-Encrypted: i=1; AFNElJ8LgGmRvLGbL+a2nCA7JJZOiC3ag5nWNdoOX0RTHoWtqAmcCwy7gDI1EzPCN6niO30bn9G5Exnwd6lMevo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw19kXvGssFHtIZ1ZwovUFRI9Ziw+TZscbGfo9kbzeYkkK0lbzq
	7jDyn2/DaOExLL9A5FR3VjLoxvtG+/gRwTKXuBtUlWMSUYMm0MM6+P9P
X-Gm-Gg: Acq92OHW/MECINJk1bo6/SOC9gXxZ9VKsZUFKxfrXKykGgqWD/akAPfUr6KX051bTk3
	bVHBACIqmBM4d9KNBW7h7DLVcyK//I2ZYOtri9AAsCw/mD2tqUuHppRd+LL0u8guTYlCl86N0mZ
	UERmVLsygUnZIw2vYCWnXuuBGUrFG3kVTHdQemq0Wo612b1pDC47nlxlQtJpBPBmHXnwG4IgWL6
	nhkk90BxUh8/NtALt4TM/6F99ryG10XShOLQn9djKsZw4NFFkYQ2oH1ezTpLmdQALAHtrTtx9xq
	y0V7kAd1j4zImaMY5ffNONO7KT1a4HizpfilgYuMJk9ZE5iuyHrmosjtYnfl2A7oXGgpnHnwPP/
	urmwnT/lyMuwMZOMYEM4/7X0+5yg/xfhr62FhuRhtIa8QU73G1g32DV9E6tASfn4vy+TJmpEu85
	SfeoarimFbKOM/ynrFEcVYXbOCgAc5GvfZ6LUui2LcsRr0sqLW0M2gKqRbZB9f
X-Received: by 2002:a05:600c:8b31:b0:490:b28d:a6f9 with SMTP id 5b1f17b1804b1-490ec4a8474mr76985055e9.8.1781340513283;
        Sat, 13 Jun 2026 01:48:33 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49220310a58sm64118705e9.4.2026.06.13.01.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 01:48:32 -0700 (PDT)
Date: Sat, 13 Jun 2026 09:48:30 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, Andrea Mazzoleni
 <amadvance@gmail.com>
Subject: Re: [PATCH] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Message-ID: <20260613094830.543833d3@pumpkin>
In-Reply-To: <20260613002704.GA11922@sol>
References: <20260612044034.117442-1-ebiggers@kernel.org>
	<20260612052247.GA8848@lst.de>
	<20260612100432.1f1c8c7a@pumpkin>
	<20260613002704.GA11922@sol>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Jun 2026 17:27:04 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> On Fri, Jun 12, 2026 at 10:04:32AM +0100, David Laight wrote:
> > On Fri, 12 Jun 2026 07:22:47 +0200
> > Christoph Hellwig <hch@lst.de> wrote:
> >   
> > > On Thu, Jun 11, 2026 at 09:40:34PM -0700, Eric Biggers wrote:  
> > > > Add an implementation of xor_gen() using AVX-512.    
> > >   
> > > > Benchmark on AMD Ryzen 9 9950X (Zen 5):    
> > > 
> > > Can you share the benchmark?
> > > 
> > > In my local tree I have ports of the AVX2 and AVX512 implementations
> > > from snapraid (https://github.com/amadvance/snapraid), which in userspace
> > > give really good performance.  On my Laptop with a AMD Ryzen AI 7 PRO 350
> > > (which is a Zen5 with the slower double pumped AVX512 unit), both of
> > > them get over 1GB/s throughput on the snapraid benchmarks.  I've been
> > > holding them back as I don't have a good kernel benchmarking harness,
> > > and it's missing the quirks for old AVX512 or the newer AMD special
> > > cases.  
> > 
> > From my experiments on Intel cpu (and I don't remember the zen-5 being
> > that different - but I've done less testing on it) you don't need to
> > unroll loops very much at all.
> > 
> > A reasonable model seems to be that the uops generated by the instruction
> > decoder get executed when all the prerequisite registers and the required
> > execution unit are available.
> > So for a memory copy (and the xor is basically a copy) the control loop
> > can run way ahead of the read/write instructions.
> > This means you can get the control loop 'for free' and unrolling further
> > makes no/little difference.
> > 
> > Each xor is two memory reads and one memory write.
> > The cpu I was using could only do one write/clock - so you can only do one
> > xor each clock. I think some of the newer ones can to two writes/clock but
> > I'm not sure how many reads/clock they can do - might still be 2, don't
> > think it s 4.
> > So you should be able to get one xor per clock, but I doubt you'll get two
> > (and possibly not even 1.3 - which would require 4 memory accesses per clock).
> > 
> > The best loop construct is the one that uses negative offsets from the
> > end of the buffers, basically:
> > 	buf += len;
> > 	offset = -len;
> > 	do
> > 		f(buf[offset]);
> > 	while (offset += size);
> > that reduces the loop control to just an 'add' and 'jnz' (which can
> > get merged into a single u-op).
> > 
> > The cpu have enough execution units to execute two memory reads,
> > a memory write, an xor the add and jnz every clock.
> > So even the 'rolled up' loop might run at one xor per clock.
> > While I think I got a 'one clock loop' on my zen-5 (testing
> > word-at-a-time strlen) I only managed a two clock loop on the newest
> > Intel cpu I've got (which isn't that new).
> > So put two xor in the loop and it shouldn't be limited by the loop
> > control, but will be limited by the memory accesses instead.
> > 
> > Further unrolling shouldn't help and may make things worse.
> > The Intel cpu have logic to directly forward the result of an
> > ALU instruction into the next few instructions, but after that you can
> > get a stall because of the 'round trip' via the register file.
> > So part way down an unrolled nn(%reg) sequence you can get a stall.
> > An extra 'add $0,%reg' in the middle of the unrolled loop will
> > 'refresh' the register and speed things up.
> > (I hit that with a loop that needed a rather more complicated control
> > structure.)
> > 
> > You definitely need to use the pmc clock counter and data dependencies
> > against the rdpmc instruction to get sensible performance figures.
> > The can reasonably reliably measure down to less than 20 clocks.  
> 
> The version at the end of this email is what you're suggesting, I think.

Looks about right (I wouldn't have found 'vpternlogq $0x96').
Should be read limited on both cpu.
I think zen5 can do two avx-512 reads and (maybe or) two avx-512 writes per clock.
(zen4 reads take two clocks so you might as well use avx-256.)
Sapphire raids might be the same, but I recall some cpu supports 3 reads/clock.

> On Sapphire Rapids and Ryzen 9 9950X it's about the same speed as mine,
> just a few percent slower on Sapphire with src_cnt == 1.

Is that 512 bytes?
The minimum block size for these in 128 bytes.
As you know a smaller block size is generally better if you need to support
arbitrary lengths.

> 
> So we could use it.  It's just a bit fragile since it assumes the loop
> overhead and indexed addressing will never be a bottleneck on any
> current or future CPU.  Unrolling by more gives something more robust
> that "just works", without having to analyze whether the loops are okay
> on each CPU model individually based on microarchitectural details.

Unrolling further is likely to be slower in 'real life' because of the
effects on the I-cache.
Not to mention D-cache effects - the exact cache alignment can matter.
It is also unlikely that future cpu will be significantly slower.

The more usual problem is that some older cpu (usually zen1) ends up
running the code significantly slower than other algorithms.
That might matter for the avx-128 version of this code.

I might try putting these functions through some user-space clock count
measuring code I've written.
You done the hard bit of getting the asm syntax right.

	David


> 
> // SPDX-License-Identifier: GPL-2.0-or-later
> /*
>  * AVX-512 optimized implementation of xor_gen()
>  *
>  * Copyright 2026 Google LLC
>  */
> 
> #include <linux/compiler.h>
> #include <linux/types.h>
> #include <linux/unroll.h>
> #include <asm/fpu/api.h>
> #include "xor_impl.h"
> #include "xor_arch.h"
> 
> static void xor_avx512_2(long bytes, u8 *p0, const u8 *p1)
> {
> 	long i = -bytes; /* Use negative indexing to minimize loop overhead. */
> 
> 	p0 += bytes;
> 	p1 += bytes;
> 	unrolled_none
> 	do {
> 		/* unroll by 2x to reduce loop overhead */
> 		asm volatile("vmovdqa64 (%2,%0), %%zmm0\n"
> 			     "vmovdqa64 64(%2,%0), %%zmm1\n"
> 			     "vpxorq (%2,%1), %%zmm0, %%zmm0\n"
> 			     "vpxorq 64(%2,%1), %%zmm1, %%zmm1\n"
> 			     "vmovdqa64 %%zmm0, (%2,%0)\n"
> 			     "vmovdqa64 %%zmm1, 64(%2,%0)\n"
> 			     :
> 			     : "r"(p0), "r"(p1), "r"(i)
> 			     : "memory");
> 	} while ((i += 128) != 0);
> }
> 
> static void xor_avx512_3(long bytes, u8 *p0, const u8 *p1, const u8 *p2)
> {
> 	long i = -bytes; /* Use negative indexing to minimize loop overhead. */
> 
> 	p0 += bytes;
> 	p1 += bytes;
> 	p2 += bytes;
> 	unrolled_none
> 	do {
> 		/* unroll by 2x to reduce loop overhead */
> 		asm volatile("vmovdqa64 (%3,%0), %%zmm0\n"
> 			     "vmovdqa64 64(%3,%0), %%zmm1\n"
> 			     "vmovdqa64 (%3,%1), %%zmm2\n"
> 			     "vmovdqa64 64(%3,%1), %%zmm3\n"
> 			     "vpternlogq $0x96, (%3,%2), %%zmm2, %%zmm0\n"
> 			     "vpternlogq $0x96, 64(%3,%2), %%zmm3, %%zmm1\n"
> 			     "vmovdqa64 %%zmm0, (%3,%0)\n"
> 			     "vmovdqa64 %%zmm1, 64(%3,%0)\n"
> 			     :
> 			     : "r"(p0), "r"(p1), "r"(p2), "r"(i)
> 			     : "memory");
> 	} while ((i += 128) != 0);
> }
> 
> static void xor_avx512_4(long bytes, u8 *p0, const u8 *p1, const u8 *p2,
> 			 const u8 *p3)
> {
> 	long i = -bytes; /* Use negative indexing to minimize loop overhead. */
> 
> 	p0 += bytes;
> 	p1 += bytes;
> 	p2 += bytes;
> 	p3 += bytes;
> 	unrolled_none
> 	do {
> 		asm volatile("vmovdqa64 (%4,%0), %%zmm0\n"
> 			     "vmovdqa64 (%4,%1), %%zmm1\n"
> 			     "vpxorq (%4,%2), %%zmm0, %%zmm0\n"
> 			     "vpternlogq $0x96, (%4,%3), %%zmm1, %%zmm0\n"
> 			     "vmovdqa64 %%zmm0, (%4,%0)\n"
> 			     :
> 			     : "r"(p0), "r"(p1), "r"(p2), "r"(p3), "r"(i)
> 			     : "memory");
> 	} while ((i += 64) != 0);
> }
> 
> static void xor_avx512_5(long bytes, u8 *p0, const u8 *p1, const u8 *p2,
> 			 const u8 *p3, const u8 *p4)
> {
> 	long i = -bytes; /* Use negative indexing to minimize loop overhead. */
> 
> 	p0 += bytes;
> 	p1 += bytes;
> 	p2 += bytes;
> 	p3 += bytes;
> 	p4 += bytes;
> 	unrolled_none
> 	do {
> 		asm volatile("vmovdqa64 (%5,%0), %%zmm0\n"
> 			     "vmovdqa64 (%5,%1), %%zmm1\n"
> 			     "vpternlogq $0x96, (%5,%2), %%zmm1, %%zmm0\n"
> 			     "vmovdqa64 (%5,%3), %%zmm1\n"
> 			     "vpternlogq $0x96, (%5,%4), %%zmm1, %%zmm0\n"
> 			     "vmovdqa64 %%zmm0, (%5,%0)\n"
> 			     :
> 			     : "r"(p0), "r"(p1), "r"(p2), "r"(p3), "r"(p4),
> 			       "r"(i)
> 			     : "memory");
> 	} while ((i += 64) != 0);
> }
> 
> DO_XOR_BLOCKS(avx512_inner, xor_avx512_2, xor_avx512_3, xor_avx512_4,
> 	      xor_avx512_5);
> 
> /*
>  * Preconditions: bytes is a nonzero multiple of 512, and all buffers are
>  * 64-byte aligned.
>  */
> static void xor_gen_avx512(void *dest, void **srcs, unsigned int src_cnt,
> 			   unsigned int bytes)
> {
> 	kernel_fpu_begin();
> 	xor_gen_avx512_inner(dest, srcs, src_cnt, bytes);
> 	kernel_fpu_end();
> }
> 
> struct xor_block_template xor_block_avx512 = {
> 	.name = "avx512",
> 	.xor_gen = xor_gen_avx512,
> };

