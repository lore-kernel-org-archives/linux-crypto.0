Received: from mta1.migadu.com (out-160.mta1.migadu.com [95.215.58.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88153346E44
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 14:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787840522; cv=none; b=anU1halHCO98jGQ3uio8jejoBLZPV+kFzkWN2XE1bMrdj1vgys7lpIo/Ciqu782aGO1SBCEqi/i/Yifx7x1TOEAYVjs6bnc8PVpnXwjNdq31p9osD91oMr/5nfRlfh8LZmZ5oY7+9HYwKA/vbMzSzLSyXRky3gczejxiYdo4TOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787840522; c=relaxed/simple;
	bh=8wLCDmXDF7DPuapA5Jj+j3NkJgks2+k18q3akLPinvA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fzDBSomUhTdX8bmb0d/KQNWHV9yNiuuL6Of1WQ303Eq/huKlur+mWVRY7QizxI1fsm1hHNlDChaLn4cpUCodPMKe/UOfgaSqouwtc0a7xn4zOMFjz2J9WMIpSRv8jukUECZpQL09sfpYT4D7u+opPN4cgrh04e852L8N8rasQR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wOqKJ5/l; arc=none smtp.client-ip=95.215.58.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wOqKJ5/l"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8wLCDmXDF7DPuapA5Jj+j3NkJgks2+k18q3akLPinvA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787840518; v=1; x=1788445318;
 b=wOqKJ5/l41LwzLIpLLLXhOqvwB3OxMQq1KUS2U3i7GJsZRhCzwDtQwkBCWmA3Q5kUHx8JdJc
 XtkSkZXnbtnnt4DJgIMtKTxmetBSaPmwrQWOSHJ5ATNbrgQ3jns/mhPAlzhVpvZjadU4DtCBliM
 JXkYf73KhUCCqggwbFThU01U=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a2b0f75b2f75a3d7;
	Thu, 27 Aug 2026 14:21:48 +0000
X-Mizu-Trace-ID: a2b0f75b2f75a3d7
X-Migadu-Flow: FLOW_OUT
Message-ID: <c8d71171-9b4c-418a-a48d-c18bb20da52f@linux.dev>
Date: Thu, 27 Aug 2026 15:21:44 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] zstd: probe the CPU for BMI2 support once, not per
 context
To: Eric Biggers <ebiggers@kernel.org>
Cc: dsterba@suse.com, linux-kernel@vger.kernel.org, terrelln@fb.com,
 linux-crypto@vger.kernel.org, yosry@kernel.org, hannes@cmpxchg.org,
 nphamcs@gmail.com, chengming.zhou@linux.dev, shakeel.butt@linux.dev,
 kernel-team@meta.com
References: <20260826122558.2662013-1-usama.arif@linux.dev>
 <20260827023943.GA2327@sol>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260827023943.GA2327@sol>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 27/08/2026 03:39, Eric Biggers wrote:
> On Wed, Aug 26, 2026 at 05:25:35AM -0700, Usama Arif wrote:
>> zstd picks between BMI2 and generic code paths at runtime, and issues
>> CPUID to decide every time a compression or decompression context is set
>> up. The answer cannot change while the kernel is running.
>>
>> It is not a cold path: squashfs calls zstd_init_dstream() for every block
>> it decompresses, and erofs, btrfs, f2fs and crypto/zstd all initialise a
>> context per operation. Each probe is two serializing CPUID instructions
>> on x86.
>>
>> Patch 1 routes ZSTD_initStaticCCtx() through ZSTD_cpuSupportsBmi2()
>> instead of open-coding the probe, which also fixes it testing for BMI2
>> without BMI1 - the bodies it selects are tagged
>> TARGET_ATTRIBUTE("lzcnt,bmi,bmi2"), so both are needed. No CPU in the
>> field implements BMI2 without BMI1, so this is latent. Patch 2 skips the
>> probe when DYNAMIC_BMI2 is 0, where every consumer ignores the flag
>> anyway. Patch 3 caches the result.
>>
>> A 4 KiB crypto_acomp benchmark [1] in a one-vCPU KVM guest, twelve boots
>> of nine 30,000-operation rounds, median per-round mean over 108 rounds:
>>
>>                     compress     decompress
>>   unpatched         16,756 ns     3,455 ns
>>   patched           13,646 ns     1,002 ns
>>                     -3,110 ns    -2,452 ns
>>                      (18.6%)      (71.0%)
>>
>> The main reason is because CPUID is an unconditional VM exit.
>>
>> [1] https://gist.github.com/uarif1/5cf02f0e22c23f0d1b3d84348f12914c
>>  
>> Usama Arif (3):
>>   zstd: use ZSTD_cpuSupportsBmi2() in ZSTD_initStaticCCtx()
>>   zstd: skip the BMI2 probe when dynamic BMI2 dispatch is disabled
>>   zstd: probe the CPU for BMI2 support only once
>>
>>  lib/zstd/common/zstd_internal.h   | 22 ++++++++++++++++++++--
>>  lib/zstd/compress/zstd_compress.c |  2 +-
>>  2 files changed, 21 insertions(+), 3 deletions(-)
> 
> Why not just use cpu_feature_enabled(X86_FEATURE_BMI2), which compiles
> down to a static branch?  All these issues are caused by lib/zstd/ using
> its own custom CPU feature detection code, instead of the normal CPU
> feature detection code that the rest of the kernel uses.
> 
> - Eric


The only issue I saw with that was that zstd is a standalone library that
is imported, so I am not sure how using cpu_feature_enabled() would work
for the maintainers. If the maintainers are happy with it, I think the
below patch is much better.


From 0b21d945f579cbb5e41b92b4c9306e9d5bac84f1 Mon Sep 17 00:00:00 2001
From: Usama Arif <usama.arif@linux.dev>
Date: Thu, 27 Aug 2026 05:34:41 -0700
Subject: [PATCH] zstd: use kernel CPU feature detection on x86

Zstd currently probes CPUID while initializing each compression or
decompression context. This bypasses the x86 feature policy used by the
rest of the kernel and repeats a serializing instruction sequence for
every context.

Use cpu_feature_enabled() in the normal x86 compressor and decompressor
objects. Check ABM, BMI1, and BMI2 because the dispatched functions are
compiled with lzcnt, bmi, and bmi2. The checks are alternatives-patched
at boot.

The effect is especially visible under virtualization, where CPUID
normally causes a VM exit. A 4 KiB crypto_acomp benchmark was run in
one-vCPU KVM guests. Comparing the unpatched baseline with this
three-patch series, the median reported ns/op values were:

                         before    after
  compression            16,777   13,635 ns/op  (-18.7%)
  decompression           3,454    1,006 ns/op  (-70.9%)

Keep the existing raw CPUID fallback for preboot and other builds which
cannot use the normal x86 feature infrastructure. Also retain the early
return when dynamic dispatch is disabled.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 lib/zstd/Makefile               |  5 +++++
 lib/zstd/common/zstd_internal.h | 18 ++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/lib/zstd/Makefile b/lib/zstd/Makefile
index be218b5e0ed59..db1d1439f5447 100644
--- a/lib/zstd/Makefile
+++ b/lib/zstd/Makefile
@@ -42,3 +42,8 @@ zstd_common-y := \
 		common/error_private.o \
 		common/fse_decompress.o \
 		common/zstd_common.o \
+
+ifeq ($(CONFIG_X86),y)
+CFLAGS_compress/zstd_compress.o += -DZSTD_USE_KERNEL_CPU_FEATURES
+CFLAGS_decompress/zstd_decompress.o += -DZSTD_USE_KERNEL_CPU_FEATURES
+endif
diff --git a/lib/zstd/common/zstd_internal.h b/lib/zstd/common/zstd_internal.h
index 41f190b533209..f7d3bca650747 100644
--- a/lib/zstd/common/zstd_internal.h
+++ b/lib/zstd/common/zstd_internal.h
@@ -31,6 +31,11 @@
 #include "fse.h"
 #include "huf.h"
 #include <linux/xxhash.h>                /* XXH_reset, update, digest */
+
+/* Use the kernel's CPU feature policy in normal x86 kernel builds. */
+#if defined(ZSTD_USE_KERNEL_CPU_FEATURES)
+#include <asm/cpufeature.h>
+#endif
 #define ZSTD_TRACE 0
 
 /* ---- static assert (debug) --- */
@@ -311,12 +316,17 @@ size_t ZSTD_decodeSeqHeaders(ZSTD_DCtx* dctx, int* nbSeqPtr,
  */
 MEM_STATIC int ZSTD_cpuSupportsBmi2(void)
 {
-#if DYNAMIC_BMI2
-    ZSTD_cpuid_t cpuid = ZSTD_cpuid();
-    return ZSTD_cpuid_bmi1(cpuid) && ZSTD_cpuid_bmi2(cpuid);
-#else
+#if !DYNAMIC_BMI2
     /* Nothing looks at the flag in this configuration. */
     return 0;
+#elif defined(ZSTD_USE_KERNEL_CPU_FEATURES)
+    return cpu_feature_enabled(X86_FEATURE_ABM) &&
+           cpu_feature_enabled(X86_FEATURE_BMI1) &&
+           cpu_feature_enabled(X86_FEATURE_BMI2);
+#else
+    ZSTD_cpuid_t cpuid = ZSTD_cpuid();
+    return ZSTD_cpuid_bmi1(cpuid) &&
+           ZSTD_cpuid_bmi2(cpuid);
 #endif
 }
 
-- 
2.53.0-Meta


