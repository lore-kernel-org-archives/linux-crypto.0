Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794906037;
	b=1em5wtJaCZnwNDSsCT+aq3v15VR8d/CQYhSEMvjxEq8yPm2DjEVh6qMpyfoDyzK05mh3
	 ESG0luwSrWFZ6QIBytLmEDPUt09lw2TWfS5QEy+yGVXK25SwCV6CglDLuDofboAD+Fvj0
	 +A6uJdmO20Z0aD/dPQ0RcilY2svnrnpp35YYswefIcLeisW1W77OFlwp4A6UwJ4UZU/IA
	 PAHUq/Z0XvQKZNkOKkcgnD9sehcV7OTK/gKih1uTOgAogE9UzCnGLp63s7jYbl9kZLvFE
	 1NCHBfSVceDE/XM+N81OZafNEzTp+qa3cYWnk3PyjbklV/OiTYN8HZig9ADFMl+4q1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794906037;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5u5bJSzXugShbfEp5UR1gFg7szWoYhbTfjqpcPqVFWA=;
	b=ZW0R9bJDpGMfgxZc2y726SPB203uL8Ky9gl3bJ/xvd5FnwlL3rrZM1z19BBU9qyYUo0j
	 QQE8nJb6G9aFIl9Hn2ZJOhUPvf2STMe9to6VtE9iCnWGzEdDtwS5qz4bLmMXORIwUEiCS
	 GiqAmJqbFdgWcan0NfQYav+mS92itpaWJlsHoZqQkrF9O7lDLaQtBaAZRD508vnwMGE55
	 1F6iMm9M11b/4eXV+j8oycKvP/CoIjUNmsrvzkAe1TgcH9S1IFk4onmx9YQ693b3qDBeK
	 G8MBQP3yeXSqfKBQkgDZqsZMW9LyXnzsGQlPAA67hHZOjHVIFSHbuWMQ72swXpWrlrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QAn7hM23;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB374606A32F
	for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 09:00:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB374606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QAn7hM23
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb72b44a97so12507635e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 01:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794906034; x=1795510834; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5u5bJSzXugShbfEp5UR1gFg7szWoYhbTfjqpcPqVFWA=;
        b=QAn7hM23baxfPhsDQ0jl0gZPWe5fEMGa6ZBQjqmz88PU18LSSpYy2ZYYf4UU4Kxw3U
         MJjdsLi68eBdm1OAxC5msfHNhlR+npmI5j5yrmtuPKbbVKJ8qsK7GfbJOiiuylMxOKMh
         3+g3VPyoIhWaZ4C9QXK4L67uKqIa1sDq+chZ42oomLTUL19MKjCDEqlAmwUN/Zc5Jl43
         J4nD3GrPUoEPzmifvNax4rIbSS7BEde0F4gdNc8mIxaMj3AUMsgoxcIji4eAXQdu6dSM
         edoOZwX13+K+D7PZ74LpqLtCXQYdeRwTjkQddJrQ8R+ns+fmAxPSRmZgTS4L3Oj2U1Z5
         w04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794906034; x=1795510834;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5u5bJSzXugShbfEp5UR1gFg7szWoYhbTfjqpcPqVFWA=;
        b=gJ5B8Uvi2IhFVWX8oBSVxTfl1ZklKQwGYRsFius6dAE/RlCOs/sKFGy4doYeIVsJA7
         05QwvbacBgmo4Mc2tZv/ai+rQgTHrcztWkoXgeR9OMc7ExsIhsPZWyJAigrDwPrfb3YT
         j2T2ba2BsNq7zuP1mtoZ8VpwYIMvyRqgKnTFTxEnT0i5asjSSJKXsspc64Uco4lR1LNU
         wEEvMl84y+nffuInokXcC1HDOVHzKw+ZRaBp0sBZA/rZuluss77XbhJ2h6BbbYNrxvdw
         dPK0dfBr0xItR6CKoLCqutGy9b43Ly6SiTaOK09ZKKQBozhMhARY58o0+3oMatYePrxE
         nSlg==
X-Forwarded-Encrypted: i=1; AL+hErHOLYSN2/rs9Nri6b2ST1Ixv/ezGltMS1x3z3UPQVLKD88CfZ4MtyHrIZP0iI0U8qCPNOGg9bWHmFt0fJQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z8lM/HXFmoxmkSbUXkRUb0JUxddfRWrmr5oxjIXxRCwDeIt5XaX
	pO65OVUzTGuYnXn2YKdmvPlFx8qAyIfS10Ya/51zuXRumk6dfSBwuXtk
X-Gm-Gg: AYBFou1FjYw8il5RLzdCTh0OvvUeBfm+m8jdsle1HObhtQnBnrrSXqQ+K8kQMeMOk8s
	ZyZds4c9YfErAKnJAns7G2qLn/POMBD3g/yU/hXDgGsXtlZM4RYer1s9DXTZT0WGleh9/sTBI7t
	OAF5PNWTx7/2OVRY9RCa+65LC85JZN4nNcESZQdRZCpQ45CAnpVBHlPG0jCqImFJDvJOfBHkGc5
	1+q7qaBtyrdRujGeOatc217MgU1gy+siVBkuHIU2OaNcJ9XjT4/3ZGh6JvENMNWiGVqkwIYoC5B
	ELru45nVF4cgW4SjZgeF6rGmCZG8OEyX8AbKqO1CU2tKeVUcssZLQmnt/MJLHX0lwZoinGLhS6y
	o93uDJihw0nhAUN9gFSL+EulOagq8FPFvFi6T50brAfOUaBF/Ju17jrNsXcJspTxc8P25dxIicd
	vKF6MYp8UQvIZ6/U1bvjA55FpoG+3jV3+hPVmFTag3JhP50LaCn3M0AgfR3WvpiPi7CM18nLSVW
	d34MiYGFnVmDteNtO+L1tQNeqJpOf8Mp2mOgROvw3xSIK6+pajPWClG88I65rxAyB/wtNhZQeaf
	QzQa6TgKhEFMC8WAZYC2ijaRAV4YD0Chl/KgA/zSHAfXEL6yvOljc5QMZHqWnQViyw==
X-Received: by 2002:a05:600c:3b93:b0:4bb:6f67:ca0b with SMTP id 5b1f17b1804b1-4bb6f67caf0mr164847925e9.29.1794906033976;
        Tue, 17 Nov 2026 01:00:33 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb783862d6sm46768355e9.2.2026.11.17.01.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 01:00:33 -0800 (PST)
Date: Tue, 17 Nov 2026 09:00:32 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Shreesh Adiga <16567adigashreesh@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 Demian Shulhan <demyansh@gmail.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lib/crc: arm64: Add NEON PMULL+EOR3 crc64_nvme
 implementation
Message-ID: <20261117090032.0abf7198@pumpkin>
In-Reply-To: <20261114172955.1598929-1-16567adigashreesh@gmail.com>
References: <20261114172955.1598929-1-16567adigashreesh@gmail.com>
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

On Sat, 14 Nov 2026 22:59:51 +0530
Shreesh Adiga <16567adigashreesh@gmail.com> wrote:

> Add a 4x-folding implementation for CPUs with FEAT_SHA3 which benefits
> newer ARMv9 CPUs like Cortex-X925.
> Usage of EOR3 from SHA3 extension improves performance by 20% compared
> to the regular PMULL without EOR3 on Cortex-X925 measure in userspace
> application via libbenchmark for 512 byte input size.
> Measured about 3x speedup for 512 byte input compared with the existing
> NEON single fold implementation on Cortex-X925 in userspace.
> 
> Signed-off-by: Shreesh Adiga <16567adigashreesh@gmail.com>
> ---
> Changes in v2:
>   Improved the 4x to 1x reduction by using x^255 and x^319 x2 reduction.
>   Added static keys for the CPU feature checks instead of regular
>   branches.
> 
>  lib/crc/arm64/crc64.h | 24 +++++++++++--
>  lib/crc/crc64-neon.c  | 83 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 104 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/crc/arm64/crc64.h b/lib/crc/arm64/crc64.h
> index c7a69e1f3d8f..e5be0ef21140 100644
> --- a/lib/crc/arm64/crc64.h
> +++ b/lib/crc/arm64/crc64.h
> @@ -9,20 +9,38 @@
>  #include <linux/sizes.h>
>  
>  u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
> +u64 crc64_nvme_neon_pmull_eor3(u64 crc, const u8 *p, size_t len);
> +
> +static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_eor3);
> +static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_pmull);
>  
>  #define crc64_be_arch crc64_be_generic
>  
>  static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
>  {
> -	if (len >= 128 && cpu_have_named_feature(PMULL) &&
> +	if (len >= 128 && static_branch_likely(&have_pmull) &&

Would it be better to swap the order of the checks?
Otherwise I think you get the 'len >= 128' conditional branch
even when the static branch is false.

David

>  	    likely(may_use_simd())) {
>  		size_t chunk = len & ~15;
>  
> -		scoped_ksimd()
> -			crc = crc64_nvme_neon(crc, p, chunk);
> +		scoped_ksimd() {
> +			if (static_branch_likely(&have_eor3))
> +				crc = crc64_nvme_neon_pmull_eor3(crc, p, chunk);
> +			else
> +				crc = crc64_nvme_neon(crc, p, chunk);
> +		}
>  
>  		p += chunk;
>  		len &= 15;
>  	}
>  	return crc64_nvme_generic(crc, p, len);
>  }
> +
> +#define crc64_mod_init_arch crc64_mod_init_arch
> +static void crc64_mod_init_arch(void)
> +{
> +	if (cpu_have_named_feature(PMULL)) {
> +		static_branch_enable(&have_pmull);
> +		if (cpu_have_named_feature(SHA3))
> +			static_branch_enable(&have_eor3);
> +	}
> +}
> diff --git a/lib/crc/crc64-neon.c b/lib/crc/crc64-neon.c
> index 4753fb94a4be..767e55edc0e0 100644
> --- a/lib/crc/crc64-neon.c
> +++ b/lib/crc/crc64-neon.c
> @@ -10,6 +10,17 @@
>  
>  u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
>  
> +#ifdef CONFIG_ARM64
> +u64 crc64_nvme_neon_pmull_eor3(u64 crc, const u8 *p, size_t len);
> +
> +/* x^575 mod G, x^511 mod G */
> +static const u64 fold_consts_4x_val[2] = { 0x0c32cdb31e18a84aULL,
> +					   0x62242240ace5045aULL };
> +/* x^319 mod G, x^255 mod G */
> +static const u64 fold_consts_2x_val[2] = { 0xb0bc2e589204f500ULL,
> +					   0xe1e0bb9d45d7a44cULL };
> +#endif
> +
>  /* x^191 mod G, x^127 mod G */
>  static const u64 fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
>  					0x21e9761e252621acULL };
> @@ -45,3 +56,75 @@ u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len)
>  
>  	return vgetq_lane_u64(v0, 1);
>  }
> +
> +#ifdef CONFIG_ARM64
> +#define SHA3_TARGET __attribute__((target("arch=armv8.2-a+crypto+sha3")))
> +
> +SHA3_TARGET
> +static inline uint64x2_t fold_single_round(uint64x2_t fold,
> +					   uint64x2_t temp,
> +					   uint64x2_t consts)
> +{
> +	uint64x2_t temp1 = pmull64(consts, fold);
> +	uint64x2_t temp2 = pmull64_high(consts, fold);
> +
> +	return veor3q_u64(temp, temp1, temp2);
> +}
> +
> +SHA3_TARGET
> +u64 crc64_nvme_neon_pmull_eor3(u64 crc, const u8 *p, size_t len)
> +{
> +	/* Assumes len >= 64. */
> +	uint64x2_t fold_consts = vld1q_u64(fold_consts_val);
> +	uint64x2_t fold_consts_4x = vld1q_u64(fold_consts_4x_val);
> +	uint64x2_t fold_consts_2x = vld1q_u64(fold_consts_2x_val);
> +	uint64x2_t v0 = { crc, 0 };
> +	uint64x2_t zero = { };
> +	uint64x2_t v1, v2, v3;
> +
> +	v0 ^= vreinterpretq_u64_u8(vld1q_u8(p));
> +	v1  = vreinterpretq_u64_u8(vld1q_u8(p + 16));
> +	v2  = vreinterpretq_u64_u8(vld1q_u8(p + 32));
> +	v3  = vreinterpretq_u64_u8(vld1q_u8(p + 48));
> +
> +	p += 64;
> +	len -= 64;
> +	while (len >= 64) {
> +		uint64x2_t t0 = vreinterpretq_u64_u8(vld1q_u8(p +  0));
> +		uint64x2_t t1 = vreinterpretq_u64_u8(vld1q_u8(p + 16));
> +		uint64x2_t t2 = vreinterpretq_u64_u8(vld1q_u8(p + 32));
> +		uint64x2_t t3 = vreinterpretq_u64_u8(vld1q_u8(p + 48));
> +
> +		v0 = fold_single_round(v0, t0, fold_consts_4x);
> +		v1 = fold_single_round(v1, t1, fold_consts_4x);
> +		v2 = fold_single_round(v2, t2, fold_consts_4x);
> +		v3 = fold_single_round(v3, t3, fold_consts_4x);
> +		p += 64;
> +		len -= 64;
> +	}
> +
> +	v0 = fold_single_round(v0, v2, fold_consts_2x);
> +	v1 = fold_single_round(v1, v3, fold_consts_2x);
> +	v0 = fold_single_round(v0, v1, fold_consts);
> +
> +	while (len >= 16) {
> +		uint64x2_t t0 = vreinterpretq_u64_u8(vld1q_u8(p));
> +
> +		v0 = fold_single_round(v0, t0, fold_consts);
> +		p += 16;
> +		len -= 16;
> +	}
> +
> +	/* Multiply the 128-bit value by x^64 and reduce it back to 128 bits. */
> +	v0 = vextq_u64(v0, zero, 1) ^ pmull64_hi_lo(fold_consts, v0);
> +
> +	/* Final Barrett reduction */
> +	uint64x2_t bconsts = vld1q_u64(bconsts_val);
> +	uint64x2_t final = pmull64(bconsts, v0);
> +
> +	v0 = veor3q_u64(v0, vextq_u64(zero, final, 1),
> +			pmull64_hi_lo(bconsts, final));
> +
> +	return vgetq_lane_u64(v0, 1);
> +}
> +#endif

