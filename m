Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B588B4A3D45
	for <linux-crypto@vger.kernel.org>; Thu,  3 Sep 2026 12:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788438931; cv=none; b=GCr7qjVEIIbx3q7NgVI6FG6H2lwnJi6uIXUuRaLeyQZE/DmV4AcSGFKcGBi2FaZkfeglt7SUwl9S6nZTUBOBbNsmEoyxNq6yQtUH9HWP1peec9ULrPgqd/2CGBSjEv3W5OOsxrg0CTgbjJFKGoVef1+r+P0ek0qUddRRx5fVI4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788438931; c=relaxed/simple;
	bh=geRfqETqvvA7A4bFc+csqFpMipf18j7uiUbtSAGPfZ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I3V3VBXZpSW263A2PrRa6EGz5FRIMx2nVHHU9I+ju/xoyIUL3vU7TwWvaAqGlJthTq1CxiVnuMajwTLznqjML138l/3pdFZH96goO2iUUy/i5ZGuwV9PJE5H4Km0ABpODgO2nMgIhlIxT/ihixbJfbvwo1mFzd6Nu9wphqwcIvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=USxOZUYn; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="USxOZUYn"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3964e76d0f4so2732615a91.3
        for <linux-crypto@vger.kernel.org>; Thu, 03 Sep 2026 05:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788438929; x=1789043729; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2uGa5V7yTrs241wbGx6ZtYSzWuI4KE2Z6GBbicY9WsY=;
        b=USxOZUYneLjvwKyAFAFIuZ76zjoT956YrPxnR/38AQSyXfqN1pNpNmNsFgrNtsEobm
         3KW7gR3w0aw2mCPqfvIK/2TkM1mhUfEkhoC5V01BZL9p8Um2EheB+cuAxpaEDOBXMF0U
         p70XLHK3Opl8SevI5VdLzoL6Qn4N8yUqOPe/Sfr/ny8lWfh2TRqykTqLfnDqt7meMBih
         /eLEpf9HbU4gPhMy7b1QePBAxCpUSUNaYNdTYNQk3bLpBD/9XM730pSz4Q1pBqTzCq0d
         0JAmH4I9F3lSm8XW/xytvfyJs0QhgArxLyfPpRCC5HSAKO+HkuGj+dBVepc/2Ay2Znm0
         XWrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788438929; x=1789043729;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2uGa5V7yTrs241wbGx6ZtYSzWuI4KE2Z6GBbicY9WsY=;
        b=reEhRTQSr/cVDGfTAfU6YI1hpcNS+k5D3mBHbeUNJrTifNTAhcugfIrpSwseMJZPtn
         vMjjctXJ3D60INaV2Y9VbXJ40ArvJ7JwiAlEucCUOHRcEyp22wC4h2KHlMlW3yQFovwZ
         xt/8egXW2Lm+9LI84FhZHKuDIiID6pPd1CVnPKa7ivgSpLAXExwyWJlnBQ90O1YFaeds
         GJpKm04+8x46bqy4/WwBZiWwPdhDbe4inyZnyvY8w5N7gKUdU6bb/6LG6A1FQuaORwoM
         XOj/z3s1FuiC+P4N9kBAOpOvkdgaWkyRkqXwgYmy3lrFxWf/qqMO5Cg25h4d8Yu/r3yp
         zVDg==
X-Forwarded-Encrypted: i=1; AKwUvBx0rmK4hQctX5zK06V/ib++tATA2Ts+k36vD3Eicu68M0bz6LDOTUrldmG1lXHEpaTJQyDUkZXhE9vHxBA=@vger.kernel.org
X-Gm-Message-State: AFuF++lBbYzkH8diVu/NT3r+xMUxfcDEpy1LcmX0R9s9mAeSysK81kuC
	X7cGFYs9Rb+fJJ2EIbiFqGdF7ISN7IFS0MuTx6ZCNlbA0jJ038jC33R3
X-Gm-Gg: AYBFou0aij5jJbqfKMAKQA5U8kHDKNjoE8AgAsubIyeQhoqoQnlYn5rqvaysPkQM2Wy
	wdPw6d11UNp+dHCpNXu4rf1VhugYx9Fnuqxr6cQc/0AJf+6FAAH6JdoNzKob7sBYcu3m+M9TUu/
	FtviYUGYVWFeIQYKtCmaAWJYPcKciEZglxruak5HifC0/c9vsRnCNtiCc0jMOv5RUM5iVp6X/qk
	zcFRri1gqkJeiNHzzrSbbXssv9yEvAn5zMFG2nG7VKaTgyL+GDqrYsWRHm2ZiDayuGy+RLA2FRX
	IvPwu6yOwsErODQALJMdw7FfzN7+k3hjy4uzwk6LuV5TkUswsc7PfmsxfdF2pubCT3MwFJ/mb1S
	fa94pgnzRPzp2poFBGGYRUiTJc10Abx/AKBRRFBnTI0y4fFGd4wFvCRrowrpjinbrBYP846c+9D
	V71HR7oq5uvNTbVBnrtGxJMS6mrwkns/gAFtneTnKG0Yz3cHfxIaeWC7hakYrEJzl8ejMY0WLvd
	QQ10MiCLXCxD0nzMpcsVq8G8+VCZdtb9/9LUBDpJ/pVOIaeVg==
X-Received: by 2002:a17:90a:c10e:b0:398:c3a3:dbd0 with SMTP id 98e67ed59e1d1-39aedfcc05dmr18826606a91.8.1788438928937;
        Thu, 03 Sep 2026 05:35:28 -0700 (PDT)
Received: from ?IPV6:2406:7400:56:e503:ad72:fda5:83e8:be95? ([2406:7400:56:e503:ad72:fda5:83e8:be95])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33255d39d21sm7358074eec.16.2026.09.03.05.35.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 05:35:27 -0700 (PDT)
Message-ID: <fc9c4270-6ebf-4e6f-b0ff-5126f95ea006@gmail.com>
Date: Thu, 3 Sep 2026 18:05:17 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] lib/zstd: add fallback aliases for disabled BMI2
 variants
To: Usama Arif <usama.arif@linux.dev>, dsterba@suse.com,
 linux-kernel@vger.kernel.org, terrelln@fb.com, terrelln@meta.com,
 linux-crypto@vger.kernel.org, yosry@kernel.org, ebiggers@kernel.org,
 torvalds@linux-foundation.org
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 shakeel.butt@linux.dev, kernel-team@meta.com
References: <20260901110850.1805747-1-usama.arif@linux.dev>
 <20260901110850.1805747-2-usama.arif@linux.dev>
Content-Language: en-US
From: Dhruva G <goledhruva@gmail.com>
In-Reply-To: <20260901110850.1805747-2-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01-09-2026 16:37, Usama Arif wrote:
> When dynamic BMI2 dispatch is disabled, the BMI2-specific functions are
> not compiled and each selector is conditionally compiled to avoid naming
> them.
> 
> The selector-level preprocessor guards will be replaced with a predicate
> that becomes constant false when dynamic BMI2 dispatch is disabled.
> Although the compiler eliminates an `if (0)` branch, it must still parse
> and resolve the BMI2 function referenced by it.
> 
> Add aliases from the unavailable BMI2 function names to their default
> implementations. These aliases make the names valid without emitting
> BMI2-specific code. The selectors remain unchanged in this patch, so the
> aliases are not used yet and there is no code-generation change.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---

Reviewed-by: Dhruva Gole <goledhruva@gmail.com>

>  lib/zstd/common/entropy_common.c            |  4 ++++
>  lib/zstd/common/fse_decompress.c            |  2 ++
>  lib/zstd/compress/zstd_compress_sequences.c |  4 ++++
>  lib/zstd/decompress/huf_decompress.c        |  4 ++++
>  lib/zstd/decompress/zstd_decompress_block.c | 12 ++++++++++++
>  5 files changed, 26 insertions(+)
> 
> diff --git a/lib/zstd/common/entropy_common.c b/lib/zstd/common/entropy_common.c
> index 6cdd82233fb59..15a7c14ae8040 100644
> --- a/lib/zstd/common/entropy_common.c
> +++ b/lib/zstd/common/entropy_common.c
> @@ -202,6 +202,8 @@ BMI2_TARGET_ATTRIBUTE static size_t FSE_readNCount_body_bmi2(
>  {
>      return FSE_readNCount_body(normalizedCounter, maxSVPtr, tableLogPtr, headerBuffer, hbSize);
>  }
> +#else
> +#define FSE_readNCount_body_bmi2 FSE_readNCount_body_default
>  #endif
>  
>  size_t FSE_readNCount_bmi2(
> @@ -323,6 +325,8 @@ static BMI2_TARGET_ATTRIBUTE size_t HUF_readStats_body_bmi2(BYTE* huffWeight, si
>  {
>      return HUF_readStats_body(huffWeight, hwSize, rankStats, nbSymbolsPtr, tableLogPtr, src, srcSize, workSpace, wkspSize, 1);
>  }
> +#else
> +#define HUF_readStats_body_bmi2 HUF_readStats_body_default
>  #endif
>  
>  size_t HUF_readStats_wksp(BYTE* huffWeight, size_t hwSize, U32* rankStats,
> diff --git a/lib/zstd/common/fse_decompress.c b/lib/zstd/common/fse_decompress.c
> index 15081d8dc607c..8d9c43b928833 100644
> --- a/lib/zstd/common/fse_decompress.c
> +++ b/lib/zstd/common/fse_decompress.c
> @@ -300,6 +300,8 @@ BMI2_TARGET_ATTRIBUTE static size_t FSE_decompress_wksp_body_bmi2(void* dst, siz
>  {
>      return FSE_decompress_wksp_body(dst, dstCapacity, cSrc, cSrcSize, maxLog, workSpace, wkspSize, 1);
>  }
> +#else
> +#define FSE_decompress_wksp_body_bmi2 FSE_decompress_wksp_body_default
>  #endif
>  
>  size_t FSE_decompress_wksp_bmi2(void* dst, size_t dstCapacity, const void* cSrc, size_t cSrcSize, unsigned maxLog, void* workSpace, size_t wkspSize, int bmi2)
> diff --git a/lib/zstd/compress/zstd_compress_sequences.c b/lib/zstd/compress/zstd_compress_sequences.c
> index 256980c9d85ad..64abcdf2c5714 100644
> --- a/lib/zstd/compress/zstd_compress_sequences.c
> +++ b/lib/zstd/compress/zstd_compress_sequences.c
> @@ -415,6 +415,10 @@ ZSTD_encodeSequences_bmi2(
>                                      sequences, nbSeq, longOffsets);
>  }
>  
> +#else
> +
> +#define ZSTD_encodeSequences_bmi2 ZSTD_encodeSequences_default
> +
>  #endif
>  
>  size_t ZSTD_encodeSequences(
> diff --git a/lib/zstd/decompress/huf_decompress.c b/lib/zstd/decompress/huf_decompress.c
> index ac8b87f48f847..5663ae524cd83 100644
> --- a/lib/zstd/decompress/huf_decompress.c
> +++ b/lib/zstd/decompress/huf_decompress.c
> @@ -700,6 +700,8 @@ size_t HUF_decompress4X1_usingDTable_internal_bmi2(void* dst, size_t dstSize, vo
>                      size_t cSrcSize, HUF_DTable const* DTable) {
>      return HUF_decompress4X1_usingDTable_internal_body(dst, dstSize, cSrc, cSrcSize, DTable);
>  }
> +#else
> +#define HUF_decompress4X1_usingDTable_internal_bmi2 HUF_decompress4X1_usingDTable_internal_default
>  #endif
>  
>  static
> @@ -1503,6 +1505,8 @@ size_t HUF_decompress4X2_usingDTable_internal_bmi2(void* dst, size_t dstSize, vo
>                      size_t cSrcSize, HUF_DTable const* DTable) {
>      return HUF_decompress4X2_usingDTable_internal_body(dst, dstSize, cSrc, cSrcSize, DTable);
>  }
> +#else
> +#define HUF_decompress4X2_usingDTable_internal_bmi2 HUF_decompress4X2_usingDTable_internal_default
>  #endif
>  
>  static
> diff --git a/lib/zstd/decompress/zstd_decompress_block.c b/lib/zstd/decompress/zstd_decompress_block.c
> index 710eb0ffd5a37..9c4215e435014 100644
> --- a/lib/zstd/decompress/zstd_decompress_block.c
> +++ b/lib/zstd/decompress/zstd_decompress_block.c
> @@ -622,6 +622,8 @@ BMI2_TARGET_ATTRIBUTE static void ZSTD_buildFSETable_body_bmi2(ZSTD_seqSymbol* d
>      ZSTD_buildFSETable_body(dt, normalizedCounter, maxSymbolValue,
>              baseValue, nbAdditionalBits, tableLog, wksp, wkspSize);
>  }
> +#else
> +#define ZSTD_buildFSETable_body_bmi2 ZSTD_buildFSETable_body_default
>  #endif
>  
>  void ZSTD_buildFSETable(ZSTD_seqSymbol* dt,
> @@ -1934,6 +1936,16 @@ ZSTD_decompressSequencesLong_bmi2(ZSTD_DCtx* dctx,
>  }
>  #endif /* ZSTD_FORCE_DECOMPRESS_SEQUENCES_SHORT */
>  
> +#else
> +
> +#ifndef ZSTD_FORCE_DECOMPRESS_SEQUENCES_LONG
> +#define ZSTD_decompressSequences_bmi2 ZSTD_decompressSequences_default
> +#define ZSTD_decompressSequencesSplitLitBuffer_bmi2 ZSTD_decompressSequencesSplitLitBuffer_default
> +#endif
> +#ifndef ZSTD_FORCE_DECOMPRESS_SEQUENCES_SHORT
> +#define ZSTD_decompressSequencesLong_bmi2 ZSTD_decompressSequencesLong_default
> +#endif
> +
>  #endif /* DYNAMIC_BMI2 */
>  
>  #ifndef ZSTD_FORCE_DECOMPRESS_SEQUENCES_LONG

