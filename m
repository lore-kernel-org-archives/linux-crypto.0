Received: from mta0.migadu.com (out-132.mta0.migadu.com [91.218.175.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360693E6DDA
	for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 12:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788178166; cv=none; b=CivAXvIYe/K75pOO+ICDDwhL44Z5HfCSFgPBghILHazsIT16m0J4w1+mRHtccwdmnpmrTAA+LONAuCADCGQkJl+2TvrhdnSPRLf0fDT47c832RtdY9IIgmm8/En8oWl7VIFiuLaoVr2VIYM+mAq/9JkXKJp3YwTgRYoKeXN2TdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788178166; c=relaxed/simple;
	bh=VY8BIT8QfLkUraG1i9FG2AkXjeQpQZ1ABuZnQEaNl2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q0BX9BFVHqc0IrVnxtlJuPKheqxKK8Hsx4g1Ok4foBmcuQATQiDKmVBbvTUfuHgKOyYRy3krwgnNmnaTbHf4RLR7XioL08L3bZgPklpNp9+QA6Z+48qYJYq/WZMyB09w7k9ZEaaUd1m/nlepuTy3UsXFhO2lrhPeX0j4/7Wwwdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o9qzV6/t; arc=none smtp.client-ip=91.218.175.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o9qzV6/t"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VY8BIT8QfLkUraG1i9FG2AkXjeQpQZ1ABuZnQEaNl2Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788178160; v=1; x=1788782960;
 b=o9qzV6/tIH6KZWL3kHJGaaPbSF0mLI5CZg+mHplYXUQBrtenJebU+rWAcFS9pVzt6wiC+aMz
 u37kvPMClZL8+m+urIbjQbBQF98MlGeVasm7aBPFRJQvdpLdq/6YViHIYNfbcMayq0t46G5HLtp
 tp1ImABeks9qczC4zGUmYQ6U=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2c443c59b6b9db85;
	Mon, 31 Aug 2026 12:09:10 +0000
X-Mizu-Trace-ID: 2c443c59b6b9db85
X-Migadu-Flow: FLOW_OUT
Message-ID: <bed66f22-8bf1-4328-a400-d214e15693e2@linux.dev>
Date: Mon, 31 Aug 2026 13:09:09 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] zstd: use cpu_feature_enabled() for in-kernel BMI2
 dispatch
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dsterba@suse.com, linux-kernel@vger.kernel.org, terrelln@fb.com,
 terrelln@meta.com, linux-crypto@vger.kernel.org, yosry@kernel.org,
 ebiggers@kernel.org, hannes@cmpxchg.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, shakeel.butt@linux.dev, kernel-team@meta.com
References: <20260830222100.2706175-1-usama.arif@linux.dev>
 <20260830222100.2706175-3-usama.arif@linux.dev>
 <CAHk-=wg3d5HUkgdWq4Ac74xoUDU_BiHTC_ONacwYFoXnMQZ7Pw@mail.gmail.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAHk-=wg3d5HUkgdWq4Ac74xoUDU_BiHTC_ONacwYFoXnMQZ7Pw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 31/08/2026 00:06, Linus Torvalds wrote:
> On Sun, 30 Aug 2026 at 15:21, Usama Arif <usama.arif@linux.dev> wrote:
>>
>> Add ZSTD_USE_BMI2() and use it at every runtime BMI2/default selector.
> 
> Thanks, this looks sane to me.
> 
> I do still react to a couple of places. Notably, this part (repeated a
> couple of times):
> 
>> +#if !defined(ZSTD_USE_KERNEL_CPU_FEATURES)
>>      cctx->bmi2 = ZSTD_cpuSupportsBmi2();
>> +#endif
> 
> should probably be an "set state" macro the same way ZSTD_USE_BMI2()
> is now a "get state" macro.
> 

Ack, have added ZSTD_SET_BMI2():

#if !DYNAMIC_BMI2
#  define ZSTD_USE_BMI2(bmi2) 0
#  define ZSTD_SET_BMI2(state, value) do { } while (0)
#elif defined(ZSTD_USE_KERNEL_CPU_FEATURES)
#  define ZSTD_USE_BMI2(bmi2) cpu_feature_enabled(X86_FEATURE_BMI2)
#  define ZSTD_SET_BMI2(state, value) do { } while (0)
#else
#  define ZSTD_USE_BMI2(bmi2) (bmi2)
#  define ZSTD_SET_BMI2(state, value) do { (state) = (value); } while (0)
#endif

will use above in next revision.
> And:
> 
>> +ccflags-$(CONFIG_X86) += -DZSTD_USE_KERNEL_CPU_FEATURES
> 
> We don't have anything like this for any other ZSTD defines, so my gut
> feel is that either this is in the wrong place, and it should be in
> something like
> 
>    lib/zstd/common/zstd_deps.h
> 
> which already has kernel-specific stuff in it, or it should just use
> #ifdef __KERNEL__ like we use elsewhere for things that are also used
> by user space.
> 

Ack, removed it from the Makefile for next revision.

__KERNEL__ alone was insufficient because it is also defined for the x86
compressed boot code. That environment defines __DISABLE_EXPORTS and cannot
use the normal alternatives infrastructure, so it retains zstd’s raw-CPUID
path.

I have added 

#if defined(__KERNEL__) && defined(CONFIG_X86) && \
    !defined(__DISABLE_EXPORTS)
#define ZSTD_USE_KERNEL_CPU_FEATURES
#endif

in lib/zstd/common/zstd_deps.h for the next revision.


> The whole situation with ZSTD configuration is a bit strange. I note
> that there are things like ZSTD_ARCH_ARM_NEON that the kernel never
> uses.
> 
> Why is "DYNAMIC_BMI2" a settimg but things like that
> ZSTD_ARCH_X86_SSE2 and ZSTD_ARCH_ARM_NEON are never set? This all
> looks messy.
> 

DYNAMIC_BMI2 is defined in lib/zstd/common/portability_macros.h.

ZSTD_ARCH_X86_SSE2 and ZSTD_ARCH_ARM_NEON are upstream zstd configuration
knobs. The kernel import is generated with ZSTD_NO_INTRINSICS [1], so their
automatic definitions are disabled even though some guarded references
remain in the imported source. The kernel cannot use SSE/NEON transparently
because that requires architecture-specific SIMD/FPU state management, whereas
BMI2 operates only on general-purpose registers.

[1] https://github.com/facebook/zstd/blob/dev/contrib/linux-kernel/Makefile#L30

> Or is there some hidden config I didn't find?
> 
> Strange.
> 
>              Linus

