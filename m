Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793026628;
	b=iR5HmlcasrXKPWxhWyJ4HMxozwhVXPVPo5+rFMikJj50fGYxCNkU8/vV40FWmEsWoFsa
	 XNtN2117smLY7QgW0UtTxp5wLw0/Yj63akgVaRMXUL4uCxY+9EXPzaN1E4s63bKMXF6vc
	 ES8tRYtihOftIMNNY3IA+1pDBQW5pyzFBBcLQgRQeqEI+C2bCqo/miA7j+HjJlDmJ5EE4
	 hTua31J2HKbXm5QRyQ1X4kqpRXO5woA934EoDncBB4zV3yRAqCg6YfikGZcvkqUYDXLyw
	 MBoA6CNYwK4FbMmQW0qy8qPtUxijZKORwwFVjXNT+83KoyF8qg648rX5j5zJHa7ILiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793026628;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=r4TeSRrJfvEb9bXGYtvTmzKxtpAZeorrt+MbujrYaNo=;
	b=1lrlHtl6x2ho2W9gQENWB2PEEyHm87iXVQmDyW7gBZJv+LDlttw+aoqeE7vYR34T+oMx
	 zyLi6rEXe8YJ8ZaFb5WWn+HwvAT0WQ9oyOQAnKpOWG3+9eP+7ykKLYyH1sKdT99VbM3g6
	 CD3Pe8IFqnGwbZP/ogxQciQCrobawIRdU/NsbElqk0aVFyEeiwf4tDy3oApzd4CWlSRyF
	 H6eiLV2hBfJkD4KBexkBLFrnsg5rO9CBjBLrVc04xxY06fPjgq5wsm6Ac0jIPvVvJaOuk
	 gPWe3w+n51Gwh94ArqN8lBIU1Uv1mudayc0SfCXr3NvU4emxVjngJJI19F4PfbDm0SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iNVvKNRO;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2100606A31B
	for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2026 14:57:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2100606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iNVvKNRO
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4956869750eso20523075e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2026 07:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793026626; x=1793631426; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r4TeSRrJfvEb9bXGYtvTmzKxtpAZeorrt+MbujrYaNo=;
        b=iNVvKNROw0TJV/07MSUPeQWkiFUyo/r8Mun0JgwcYN1aZGEO0Sv9204nzc6yLc+hls
         lVDl0aZxytSZYw6BSeTenz/KJCMjoIb3xqnZcqJByX9Q1EVWAOI4/EPnmwvYoqYnj6dd
         x3IhiPjf9SGcxTw9rFWvRlZWALlhTOvZHCIyZSp43diZHDSMZ2IxvGB66IJT+IVb/U4T
         xUqg6QFK6dKmeVQ7PYbVwsYmJYaeHZg8gB7z8rmiLz9RLTzAgFaL21Re3C9M8ShTE0WW
         XGN8R0/rpsSwV0e9tmEqkvS8gli54EjPIrO8yhunGeG3DJ2Xh3hXiCO6wU93iVLhlOu3
         bZEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793026626; x=1793631426;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r4TeSRrJfvEb9bXGYtvTmzKxtpAZeorrt+MbujrYaNo=;
        b=AcL7U3i8+fRgynKzUTcuvcKxStowKzmOEmxexXoJblWIY29J/KnaroW4ux7F4Ddu2R
         UTroB11q/ymguf/qbuG+XKCCm0cPRGl9JtgRY43WOVOy0D1OScv64KJqx0OSC8JN+NzF
         49SHhwaOoUPzU+Ae3H0B0/dLnatF9Yu/vQRF2iFYB1OWDAIOWsXcQ6hlFLsRHQc99RNA
         DYL+RFBmnxZi2NjaSGUaRDlRuCJwD34XnCQyzYL+JKmnD6lOAmbdfcK+AmTGb2fjA0Iv
         cpXgWuuvyDHQOvZK7N9zvOklbFapmnwk95d/3iAohLPTwI4I5DPjWB42MDorlYMQsJNX
         Im/A==
X-Forwarded-Encrypted: i=1; AKwUvBxRCcMRLa0pDEaEJJa3KfGkoB1OTLdYus5l2IFw/wXB1dPPWpxBWDeF8tATp9Ekeo2Sexx8vHmKJCQhyoM=@vger.kernel.org
X-Gm-Message-State: AFq9FYLlGKmhSrnDzSx5bMwlJ0eHpts7P6DTNDMKyRb7dd2yARWYWGnU
	gHAPcAKgWzhuSsc1ylEqSiVm4hRrfJ8F9LNNxGuM3nLDCO7Wq3vPaWTY
X-Gm-Gg: AYBFou1y7gtNYSMmF/k4TPFERFS+Tl2fWfQs8FC5lK5q8DrYIbBZWg4DPCAoCxx+fUv
	zCGcaMvzDC37TekwNAfUqEfm++RA9KlUPMkFIvrddcsxJDounZcR6Q1hrZxgVDC70s8PuQjcYXu
	NT3mUgQxb+ipBQDuF5PtCGSldxK48yDmpOWivQfmkZgNa9jBIVC7wG0z/WXLDZCe8fF/ZX5grwx
	yeIjmxifpuHJAQDey5TFo9FltVtrLlCYSc4zXzP838CUO151AYMVFI3h1Rdt8jdBKHpdRtx8xYj
	bN5LAMDwC5HkY/cJcMY0dI3DLodH2ycF1Y6GaGNMI0P34nBsxvXCUTPip+OjGCEtMa6PuEorIjk
	1z/YLJpa36Kt2lL0cV1qSiD6apvkq7KZKR51E3vm4WMDWwoE6hFmLbbh7AFbNdaTYQO/AvMwKCc
	sV5Sq9TjSy6+8Zt06H8mVXr34P5Qw+qagpDOPJ3IDkqTk6lVZKyRyhy6Cg3hSqgnE0cK4ZoCeR1
	WYeawV7GuY4ka77gkiVA1bwxpZE3azAqDws+ua/zslQzZWUMQoSFSfwY8FUw3NnySgSi348BU5+
	nA/wkKRnAMiZ3dhK
X-Received: by 2002:a05:600c:83c7:b0:4a2:c9b:9b98 with SMTP id 5b1f17b1804b1-4a35ac95f44mr128561225e9.17.1793026626028;
        Mon, 26 Oct 2026 07:57:06 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a07ebc0sm94940725e9.3.2026.10.26.07.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 07:57:05 -0700 (PDT)
Date: Mon, 26 Oct 2026 14:57:04 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] raid6: simplify CPU feature checks
Message-ID: <20261026145704.5601466f@pumpkin>
In-Reply-To: <20261025191207.86590-4-ebiggers@kernel.org>
References: <20261025191207.86590-1-ebiggers@kernel.org>
	<20261025191207.86590-4-ebiggers@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 25 Oct 2026 12:12:07 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> Remove unnecessary checks for features that are prerequisites for other
> features, such as AVX which is a prerequisite for AVX2.
> 
> (Note: in most cases arch/x86/kernel/cpu/cpuid-deps.c warns about
> missing prerequisites rather than enforcing them.  This is intentional,
> and it does not mean the prerequisites should be checked elsewhere.)
> 
> Then, move the raid6_recov_algo_add() lines into the appropriate places
> just above so that the same CPU features aren't checked multiple times.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/raid/raid6/x86/pq_arch.h | 51 ++++++++----------------------------
>  1 file changed, 11 insertions(+), 40 deletions(-)
> 
> diff --git a/lib/raid/raid6/x86/pq_arch.h b/lib/raid/raid6/x86/pq_arch.h
> index 4a863b253b909..418e4d4a2930f 100644
> --- a/lib/raid/raid6/x86/pq_arch.h
> +++ b/lib/raid/raid6/x86/pq_arch.h
> @@ -16,63 +16,34 @@ extern const struct raid6_recov_calls raid6_recov_ssse3;
>  extern const struct raid6_recov_calls raid6_recov_avx2;
>  extern const struct raid6_recov_calls raid6_recov_avx512;
>  
> ...
>  static __always_inline void __init arch_raid6_init(void)
>  {
> -	if (raid6_has_avx2()) {
> +	if (boot_cpu_has(X86_FEATURE_AVX2)) {
>  		raid6_algo_add(&raid6_avx2x1);
>  		raid6_algo_add(&raid6_avx2x2);
>  		if (IS_ENABLED(CONFIG_X86_64))
>  			raid6_algo_add(&raid6_avx2x4);
> -		if (raid6_has_avx512()) {
> +		if (boot_cpu_has(X86_FEATURE_AVX512BW) &&
> +		    boot_cpu_has(X86_FEATURE_AVX512VL) &&
> +		    boot_cpu_has(X86_FEATURE_AVX512DQ)) {
>  			raid6_algo_add(&raid6_avx512x1);
>  			raid6_algo_add(&raid6_avx512x2);
>  			if (IS_ENABLED(CONFIG_X86_64))
>  				raid6_algo_add(&raid6_avx512x4);
> +			raid6_recov_algo_add(&raid6_recov_avx512);
> +		} else {
> +			raid6_recov_algo_add(&raid6_recov_avx2);

Is that right (you haven't changed it)?
You get both the avx2 and axv512 normal algorithms, but only one
of the recov ones.

I presume these are added in addition to the generic C code and
some startup test decides which is fastest and so used?

David


>  		}
> -	} else if (IS_ENABLED(CONFIG_X86_64) || raid6_has_sse2()) {
> +	} else if (IS_ENABLED(CONFIG_X86_64) ||
> +		   boot_cpu_has(X86_FEATURE_XMM2)) {
>  		/* x86_64 can assume SSE2 as baseline */
>  		raid6_algo_add(&raid6_sse2x1);
>  		raid6_algo_add(&raid6_sse2x2);
>  		if (IS_ENABLED(CONFIG_X86_64))
>  			raid6_algo_add(&raid6_sse2x4);
> +		if (boot_cpu_has(X86_FEATURE_SSSE3))
> +			raid6_recov_algo_add(&raid6_recov_ssse3);
>  	} else {
>  		raid6_algo_add_default();
>  	}
> -
> -	if (raid6_has_avx512())
> -		raid6_recov_algo_add(&raid6_recov_avx512);
> -	else if (raid6_has_avx2())
> -		raid6_recov_algo_add(&raid6_recov_avx2);
> -	else if (raid6_has_ssse3())
> -		raid6_recov_algo_add(&raid6_recov_ssse3);
>  }

