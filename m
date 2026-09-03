Received: from mta0.migadu.com (out-203.mta0.migadu.com [91.218.175.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B3F490C15
	for <linux-crypto@vger.kernel.org>; Thu,  3 Sep 2026 10:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788432818; cv=none; b=Q68p3GoTrsjne4p9cCp5HkdY02RGlzbB3lhLVwHgkURzsKKiG0AR7FNmvhDnfZqr4gmUsWQHsjdIECl0rLbKsygIMncnDfOVeulC3HRHcgLBzzpyVKBqV+izoyc4ieYHvXmddIVCY271uf+fMAdKne9qK/RL7d3ia+EJ3YNG6Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788432818; c=relaxed/simple;
	bh=VlMMvVJ41d2u+4R9bBTJzfMSe3YQWI02/WQr8XoAc6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WuxEpQEQqf8mgI8+B8liD2xOx8IUhtkLJ8IlP9C9CQZkrvvWKVbbOJoYnkrImBh7COQgDk0vqnIyoKi+kX+yraCwwJTdPuorMlBxpRgo9Jso8v9yF1cGu1+JRXIZHNHlmBFUuRKcc9r0pC/YHeeeCAzunnbfnSNlxZC583OwI6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XfX4Dmay; arc=none smtp.client-ip=91.218.175.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XfX4Dmay"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VlMMvVJ41d2u+4R9bBTJzfMSe3YQWI02/WQr8XoAc6M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788432813; v=1; x=1789037613;
 b=XfX4DmaytqO/An1rjB911Fab3KQBpsPeIfE1gjMRAS7wYDbHITYeNgjj0TmboWCF8OrMfBFW
 /+3uADc5wZyJPWIkGZE+kb+o40v6fCDoSalGCIfGCDfq68Y6rSclYGbOnlqMC9mH3HK/nOWAm31
 qhqD1uTofsEVNgbT8HiOIrh8=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2402af79b84f2c7f;
	Thu, 03 Sep 2026 10:53:23 +0000
X-Mizu-Trace-ID: 2402af79b84f2c7f
X-Migadu-Flow: FLOW_OUT
Message-ID: <5fa70fc4-9b01-4303-85f1-bcffbb877789@linux.dev>
Date: Thu, 3 Sep 2026 11:53:21 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] zstd: use cpu_feature_enabled() for in-kernel BMI2
 dispatch
To: Dhruva G <goledhruva@gmail.com>, dsterba@suse.com,
 linux-kernel@vger.kernel.org, terrelln@fb.com, terrelln@meta.com,
 linux-crypto@vger.kernel.org, yosry@kernel.org, ebiggers@kernel.org,
 torvalds@linux-foundation.org
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 shakeel.butt@linux.dev, kernel-team@meta.com
References: <20260901110850.1805747-1-usama.arif@linux.dev>
 <20260901110850.1805747-3-usama.arif@linux.dev>
 <d1b78cdd-33f6-447c-8a0d-ce79fe1e6c28@gmail.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <d1b78cdd-33f6-447c-8a0d-ce79fe1e6c28@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 02/09/2026 18:40, Dhruva G wrote:
> Hi Usama,
> 
> On 01-09-2026 16:37, Usama Arif wrote:
>> Zstd's dynamic BMI2 implementation probes CPUID when a compression or
>> decompression context is initialized, stores the result in the context,
>> and tests that value at every dispatch site. In normal kernel builds this
>> bypasses the x86 feature policy and uses ordinary runtime branches instead
>> of allowing x86 alternatives to resolve the feature check at boot.
>>
>> Add ZSTD_USE_BMI2() and use it at every runtime BMI2/default selector. For
>> normal x86 kernel objects, the predicate expands directly to
>> cpu_feature_enabled(X86_FEATURE_BMI2). When dynamic BMI2 dispatch is not
>> available it is false; other builds retain the caller-provided flag. Keep
>> the existing HUF conditional layout because DYNAMIC_BMI2 also controls
>> whether target-attributed variants are emitted.
>>
>> Add the matching ZSTD_SET_BMI2() abstraction for context initialization.
>> Normal x86 kernel objects and builds without dynamic BMI2 do not cache CPU
>> state. Other builds with dynamic dispatch, including preboot, retain the
>> existing behavior. Keep the BMI2 members in the context structures so
>> their layouts do not change, and make the accessors return zero when
>> cached state is unused.
>>
>> Select the normal-kernel policy in zstd_deps.h. Builds which define
>> __DISABLE_EXPORTS, including the x86 preboot decompressor, retain the existing
>> CPUID-backed dispatch because the normal alternatives infrastructure is not
>> available there.
>>
>> A 4 KiB zstd-generic crypto_acomp benchmark in a one-vCPU KVM guest gave
>> these median results:
>>
>>                         Before      After     Change
>>   Compression      16,634 ns/op  13,394 ns/op  -19.5%
>>   Decompression     3,480 ns/op     963 ns/op  -72.3%
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
> 
> These comments still say BMI2 support is determined once per context:
> - lib/zstd/compress/zstd_compress_internal.h:473
> - lib/zstd/decompress/zstd_decompress_internal.h:159

Good catch! Thanks. I will change to:

Cached for per-context dispatch: 1 if the CPU supports BMI2, 0 otherwise.

> 
>>  lib/zstd/common/compiler.h                    | 12 ++++++++++++
>>  lib/zstd/common/entropy_common.c              | 12 ++++++------
>>  lib/zstd/common/fse_decompress.c              |  7 ++++---
>>  lib/zstd/common/zstd_deps.h                   |  5 +++++
>>  lib/zstd/compress/huf_compress.c              |  6 +++++-
>>  lib/zstd/compress/zstd_compress.c             | 12 ++++++------
>>  lib/zstd/compress/zstd_compress_internal.h    |  9 +++++++++
>>  lib/zstd/compress/zstd_compress_sequences.c   |  8 +++++---
>>  lib/zstd/compress/zstd_compress_superblock.c  |  2 +-
>>  lib/zstd/decompress/huf_decompress.c          | 18 +++++++++---------
>>  lib/zstd/decompress/zstd_decompress.c         |  4 +---
>>  lib/zstd/decompress/zstd_decompress_block.c   | 19 +++++++------------
>>  .../decompress/zstd_decompress_internal.h     |  2 +-
>>  13 files changed, 71 insertions(+), 45 deletions(-)
>>
>> diff --git a/lib/zstd/common/compiler.h b/lib/zstd/common/compiler.h
>> index dc9bd15e174e9..47f6c0372c58c 100644
>> --- a/lib/zstd/common/compiler.h
>> +++ b/lib/zstd/common/compiler.h
>> @@ -14,6 +14,7 @@
>>  
>>  #include <linux/types.h>
>>  
>> +#include "zstd_deps.h"
>>  #include "portability_macros.h"
>>  
>>  /*-*******************************************************
>> @@ -96,6 +97,17 @@
>>   */
>>  #define BMI2_TARGET_ATTRIBUTE TARGET_ATTRIBUTE("lzcnt,bmi,bmi2")
>>  
>> +#if !DYNAMIC_BMI2
>> +#  define ZSTD_USE_BMI2(bmi2) 0
>> +#  define ZSTD_SET_BMI2(state, value) do { } while (0)
>> +#elif defined(ZSTD_USE_KERNEL_CPU_FEATURES)
>> +#  define ZSTD_USE_BMI2(bmi2) cpu_feature_enabled(X86_FEATURE_BMI2)
> 
> Here, we do not include <asm/cpufeature.h>. Instead, every current .c user includes that header separately.
> This works today, but it maybe fragile: the next user of ZSTD_USE_BMI2() can fail to compile unless they know
> about this hidden requirement. 
> Do you think perhaps we should provide that here in this header itself?

I tried that, but compiler.h is included by unrelated zstd translation units.
On x86, <asm/cpufeature.h> eventually includes <asm/current.h>, which defines
current as get_current(). This breaks the existing local variable named current 
in zstd_double_fast.c.

I think the current apporach is ok?

> 
> With that, feel free to add
> 
> Reviewed-by: Dhruva Gole <goledhruva@gmail.com>

Thanks for the review!


