Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C22B37267A
	for <linux-crypto@vger.kernel.org>; Wed,  2 Sep 2026 17:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788370869; cv=none; b=UWa9E9GUDaCsVFvuj6wWJv0RGjd+YEA1KXYUoFh1gMcxKpJ49f9af4vPSFr90epDBcBPNCbJxBUELDQZ8ZJzHz8BDFnEKS0YaQefvMlKohoAtrMAqHgnKjjZfsTcXJYspHie7tpcAjPtWG/H7Op73BQ74l+ISb0KAEqI+4oEY7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788370869; c=relaxed/simple;
	bh=Gjd6wqZFnYQxpErR0uM1mtt2ckVzCfL5kzGfW7N3BnA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QwwuOe8c3w7pfZnIKNhC+AqCFKoyY/QahoLiZSSyIycOS0u/VK2rkmFoARd7BLRQ1i3rvsRqhgFio/YhyXPPCYu35KAohlFiXBmG80TbBXuMZVUL4ECYzKPLnYqNc9bIAIDxCLmJjJwK2EgV9NdYf11wK70FZ+HmT2YW+i/nK/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TJXqsQ2r; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TJXqsQ2r"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2d58efc7356so17771675ad.1
        for <linux-crypto@vger.kernel.org>; Wed, 02 Sep 2026 10:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788370867; x=1788975667; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5pJGPs1wZgHUHcoR+U13MU41ODhs6eu+XJDReixEG3Y=;
        b=TJXqsQ2rRvro0cMMbF1Dsd5JWpxH12bgMzIw8HhQwvRw1X3e9Gh5F60jwtxdCzBZ1+
         JXWjuMuxUQwmIWfZpcjxgJTYJiOGdK/CxXQw2lB95zEUKXhAtVwNx3EVjn3fNGttGxOb
         4GLP0rA0m+hmrr6CZ3PR6OOip6kLOxYGLi8REekugmePkRtB+2HvW70NlJbCSviLQ7GE
         xulbHyXkHPVSPHJa8x9krgYBXtars5UV0k4NFFgYlbdoiCjtGAeHqefgTnWKyaGLdmI+
         T7r3qEQ8rahcP03Pvoo0MEUaCY9sDfDUiFTrOq8Kd4+fUJEBxB52bRP+7gP7WX6iUEmc
         N5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788370867; x=1788975667;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5pJGPs1wZgHUHcoR+U13MU41ODhs6eu+XJDReixEG3Y=;
        b=Sv8aupa2873Z6LZ/qm4fk3es96wJRL4BySECfiuOo/kwKeGvZ/b1WdeetbAeCKQy6V
         w+ZSLGAynNLZ06BxjxME6z+MZkdAxssNMt84irwuUWBbsWjnxwwAQ1knae5LIZ+bWa8O
         wDGSMDi7LcStGORWDuoqdCdNoofepiwD28+6vBUFKB74zLyrW2JYc0lJLth9F6tF/rUz
         X3cTyuHxjAUAGNYGo2fKxLu3WTvDUFvZTqzz7j/g9pN7A65t4/xaXjSfvnXogOOlteb+
         KoRSXebH7VkN1WYiaslDxAeWSzMJnaqjfxAMPdhJQ4eoXXWv6d0R2IsAcyEDOeMfLLdf
         aIkQ==
X-Forwarded-Encrypted: i=1; AKwUvBzcdZaCaSvIDzk2jd3RjiiUPSKpPKG2V0541sPGE1YkgUxfTTu0UoRbqZPczTWymNbzPGetm4xsXO55H3s=@vger.kernel.org
X-Gm-Message-State: AFuF++mrWB5qsflfo+9fY/qayYTs5VJ+OuOKRS70pnLIcC9fcibbU4Yt
	fWCxeFQxAyMs2U7yGY5smK/+1w6+bi9TfITPGpMVvLDSXyI1l2PG+qNL
X-Gm-Gg: AYBFou0fyR3ZmeD9Tvvy2s8Odqzi+Q5W8qGSaqWPDehTM9VyBK/alwTQDfcNJ7MuH4+
	jX+dxlOtqQbf+QlufMZMCNdyCj7ZLxLya3HwcNfF6XJ7JV/XvMzUgXzJrnXnGOMnUJiZieFUFE/
	3ZsGhl+7OS//DVIWb4fpj7zeKeXnsk9pfxsjl7YHMldpu/j31PHgRrap2Pgrn089orwhqSAVz4h
	1U+pZdmm+uiLSWh4rmwyU/GyaQEAE11zwqon1pdaG5V50zEKCttMQSB+4dVBRIFCMv7yWbSrTe8
	ltiW/nl3z9A73QpTSjwmWvDoFJJKeBVs0H8zBdyI+JnbabS3VqAD/bBJXaY9d9ktToqZHx5JgGU
	Dde7sfsqtBjMTU7KCDTXheaSu4pe/tBZ2g03jDmrd2eluPOwso0bgHBQPrblmjmXwkfm8gl1deL
	GR3qy/9UpO6//SlkSEwRkgAtcjPsttlGZ8Ln+OvdfwRakw5/qCaQd1YV6tn9hPDQAar1foIXd0P
	cnQ8+07A1pPdPtdt7s09JFDh7UqG9FgsotR1sw=
X-Received: by 2002:a17:90b:46:b0:38e:ad9d:1161 with SMTP id 98e67ed59e1d1-39aedbfe60amr10524568a91.0.1788370866608;
        Wed, 02 Sep 2026 10:41:06 -0700 (PDT)
Received: from ?IPV6:2406:7400:56:e503:ad72:fda5:83e8:be95? ([2406:7400:56:e503:ad72:fda5:83e8:be95])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1430e9ec994sm8476405c88.1.2026.09.02.10.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 10:41:06 -0700 (PDT)
Message-ID: <d1b78cdd-33f6-447c-8a0d-ce79fe1e6c28@gmail.com>
Date: Wed, 2 Sep 2026 23:10:57 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] zstd: use cpu_feature_enabled() for in-kernel BMI2
 dispatch
To: Usama Arif <usama.arif@linux.dev>, dsterba@suse.com,
 linux-kernel@vger.kernel.org, terrelln@fb.com, terrelln@meta.com,
 linux-crypto@vger.kernel.org, yosry@kernel.org, ebiggers@kernel.org,
 torvalds@linux-foundation.org
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 shakeel.butt@linux.dev, kernel-team@meta.com
References: <20260901110850.1805747-1-usama.arif@linux.dev>
 <20260901110850.1805747-3-usama.arif@linux.dev>
Content-Language: en-US
From: Dhruva G <goledhruva@gmail.com>
In-Reply-To: <20260901110850.1805747-3-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Usama,

On 01-09-2026 16:37, Usama Arif wrote:
> Zstd's dynamic BMI2 implementation probes CPUID when a compression or
> decompression context is initialized, stores the result in the context,
> and tests that value at every dispatch site. In normal kernel builds this
> bypasses the x86 feature policy and uses ordinary runtime branches instead
> of allowing x86 alternatives to resolve the feature check at boot.
> 
> Add ZSTD_USE_BMI2() and use it at every runtime BMI2/default selector. For
> normal x86 kernel objects, the predicate expands directly to
> cpu_feature_enabled(X86_FEATURE_BMI2). When dynamic BMI2 dispatch is not
> available it is false; other builds retain the caller-provided flag. Keep
> the existing HUF conditional layout because DYNAMIC_BMI2 also controls
> whether target-attributed variants are emitted.
> 
> Add the matching ZSTD_SET_BMI2() abstraction for context initialization.
> Normal x86 kernel objects and builds without dynamic BMI2 do not cache CPU
> state. Other builds with dynamic dispatch, including preboot, retain the
> existing behavior. Keep the BMI2 members in the context structures so
> their layouts do not change, and make the accessors return zero when
> cached state is unused.
> 
> Select the normal-kernel policy in zstd_deps.h. Builds which define
> __DISABLE_EXPORTS, including the x86 preboot decompressor, retain the existing
> CPUID-backed dispatch because the normal alternatives infrastructure is not
> available there.
> 
> A 4 KiB zstd-generic crypto_acomp benchmark in a one-vCPU KVM guest gave
> these median results:
> 
>                         Before      After     Change
>   Compression      16,634 ns/op  13,394 ns/op  -19.5%
>   Decompression     3,480 ns/op     963 ns/op  -72.3%
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---

These comments still say BMI2 support is determined once per context:
- lib/zstd/compress/zstd_compress_internal.h:473
- lib/zstd/decompress/zstd_decompress_internal.h:159

>  lib/zstd/common/compiler.h                    | 12 ++++++++++++
>  lib/zstd/common/entropy_common.c              | 12 ++++++------
>  lib/zstd/common/fse_decompress.c              |  7 ++++---
>  lib/zstd/common/zstd_deps.h                   |  5 +++++
>  lib/zstd/compress/huf_compress.c              |  6 +++++-
>  lib/zstd/compress/zstd_compress.c             | 12 ++++++------
>  lib/zstd/compress/zstd_compress_internal.h    |  9 +++++++++
>  lib/zstd/compress/zstd_compress_sequences.c   |  8 +++++---
>  lib/zstd/compress/zstd_compress_superblock.c  |  2 +-
>  lib/zstd/decompress/huf_decompress.c          | 18 +++++++++---------
>  lib/zstd/decompress/zstd_decompress.c         |  4 +---
>  lib/zstd/decompress/zstd_decompress_block.c   | 19 +++++++------------
>  .../decompress/zstd_decompress_internal.h     |  2 +-
>  13 files changed, 71 insertions(+), 45 deletions(-)
> 
> diff --git a/lib/zstd/common/compiler.h b/lib/zstd/common/compiler.h
> index dc9bd15e174e9..47f6c0372c58c 100644
> --- a/lib/zstd/common/compiler.h
> +++ b/lib/zstd/common/compiler.h
> @@ -14,6 +14,7 @@
>  
>  #include <linux/types.h>
>  
> +#include "zstd_deps.h"
>  #include "portability_macros.h"
>  
>  /*-*******************************************************
> @@ -96,6 +97,17 @@
>   */
>  #define BMI2_TARGET_ATTRIBUTE TARGET_ATTRIBUTE("lzcnt,bmi,bmi2")
>  
> +#if !DYNAMIC_BMI2
> +#  define ZSTD_USE_BMI2(bmi2) 0
> +#  define ZSTD_SET_BMI2(state, value) do { } while (0)
> +#elif defined(ZSTD_USE_KERNEL_CPU_FEATURES)
> +#  define ZSTD_USE_BMI2(bmi2) cpu_feature_enabled(X86_FEATURE_BMI2)

Here, we do not include <asm/cpufeature.h>. Instead, every current .c user includes that header separately.
This works today, but it maybe fragile: the next user of ZSTD_USE_BMI2() can fail to compile unless they know
about this hidden requirement. 
Do you think perhaps we should provide that here in this header itself?

With that, feel free to add

Reviewed-by: Dhruva Gole <goledhruva@gmail.com>

