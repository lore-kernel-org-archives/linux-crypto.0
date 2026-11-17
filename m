Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794876337;
	b=FuYiPRR7xSIpAgnK15xxPT8jhZx+MjdYBOzVGEjcyUqG98CTuPLrQZYgE1AjQDrny39g
	 u8HAmk7fVn+gJATPgE8zXP+YgzZS/rhpz+9y5KFbRn8UmNkNdCRkHLWMtVU2KjqvijLqG
	 q7CQf0Q3vlXODt83DGqqXRZqhogj5OsDTLimfBw6O28s7orbHlG8AJfUonq93fSKXrP/8
	 WF1ysTlIgeMWaGIutIe/gtdiGGYpktt29Jso2waROycygjBmb5qPVw3I7jN3/cMy5UhjG
	 xRHOF7rg4pfFXUTVQmQVlPVlG6Okd3lODac0s6UlollO9hJ0880bAiTRrCHwd+S7B7Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794876337;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=F6U8yDnaAKEsxN41i16ABdHINXflxp/mH+Yg0Frg3G8=;
	b=e5WVha7TtBw7fYmK9lJT/RN/IlTjGNj/uH63yKgFoUS1EfC3x2Ovhj5pgP4vNqUvnrmz
	 kf+mowGysx5xF8ElaGoJK4oNBUeU7U64Lyn5wM+bMFkaNd0aGlBVcYDe+lKG3KvqcOjW+
	 xAMn8PMmNEOQNoVV7cnzj4RZisCuh+ghOfPqbInXSuM9SWle1HMw2T2LWskeUyB4tibTI
	 IXCnAOfw3/9u8psBQBJ5Nc3r1U7O2lQiuG+KXAad3R0q6kpobQXDu0C/ZscAP25rmvc6M
	 rR5pFNpxHGLcJX3kyJWnLUm0B0HZvfQPS6KZLXqlhmCqiztYqNU4urak46O9OLBMdhQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bDoj8XDp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.47
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D16606A31C
	for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 00:45:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88D16606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bDoj8XDp
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1ae58d17cd9so3265464c88.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 16:45:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794876336; cv=none;
        d=google.com; s=arc-20260327;
        b=gKVtm5Bhdx92m2p8IzAug2+1xO750VziHb6o2c3tu3ONAJA9LesejoqL4WGYrN2Pt4
         zO16W8YvhrcXlh8oeafM7ELkgKx9WWl4zQ/5+oJ1NlpcUw0KYUNcdj1znslW02IE1nr0
         Xc4kTSrF+NqbHzKH/PBu+6SaEpJ9t59Ob/zEEZRLuyYAUn+en0chEXqho3bt4g3BSN5W
         iKgB4gr8R7+qDlEZhTtXWpTGpfxnqszCH1M1doSErQY5v0mK6mkuX/CyGlmFXvROBTpJ
         4WlSdj43SbjyLHaF/NZXEeH5TM0P5omIEOApzU05hzD95EFt5HmbtcrAY4fXRNtEbRv/
         NRsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=F6U8yDnaAKEsxN41i16ABdHINXflxp/mH+Yg0Frg3G8=;
        fh=mAM/Iav/CDOKZUTU6zzey3vWVwiLhnKpGPrh7b4tCY0=;
        b=Yw5VnOPo58ABGWdnKc05NgnmH2JwzofP69F2EZmDAfKz0RSDTK5fYwG+PP8EGt35+L
         7q2W9cKDMBuY1MO44K/C1lUaVyo1bi6h7nIlgKCz2USgunxqxSU2VGyqbqjJrkAR9TjH
         5CAnqAPpNq77GtSRA+Cz8gtNpGea66SHjUgWCf4tQO2GX1akr/vy7k4KrJHyY7+bF8ZT
         VL2SZurnCybS/SC7R+0DWaXctvOiaHcslH4jlVDh8h11QBwhgoTt3oZ3IWlePyqFEetU
         pgrD0myL2oLFGok0ECiIs4/mVEewow0O6RE0X44UXlHqxoRlQmvncX5ww5QOrEL87+OA
         DEcg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794876336; x=1795481136; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F6U8yDnaAKEsxN41i16ABdHINXflxp/mH+Yg0Frg3G8=;
        b=bDoj8XDpo5GOBvvaAwJRblzAbhqrHmnpM5A8sKalHmSXl9bPAYalpPgrnAlXltWc+W
         7yYiBAH/6trqk3w4HWjHXPKfLPw1lQnOmtYeJDej88Voo7W26cdPoSdY/kcUk1OwupaT
         Ws09/a8qP3jsqYLKXUgFhi0l+0IyanG6N16sPbJj0aqnn1tKyga3BIjpguRSKJhjNbI/
         5TAcxJ8sNEoxgBUcXjKeAI2lxkN3Xil+I7d7Bm1kaBkf+QxcKjNuzFgL+4gQLEOAiH+v
         I9NyJGuLQTUmzvGXtmDmIdGzfQm0BW3pdzvIUIdNXDXNhKswobNGMvbUjnilgjxyLe4e
         DmNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794876336; x=1795481136;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F6U8yDnaAKEsxN41i16ABdHINXflxp/mH+Yg0Frg3G8=;
        b=1NRW/coBL3bYD82QUkdGDdFZoCkFwlGE52FH+zazLafek/v59fJaaFqS//txLflY9L
         bmfycN3HXSQKythb2sl41toi13tfZ0uNDqx0mMDW9X3WixFVu8XY+xm9yS4qcmvaPfIP
         WczBO7+6x1eQ11iJ6yqUD3wLW2rUFV3OLBVafIimP0BczOJDk84dRKgMHjBFEfW/ZX9B
         xwIF6JOg6UPM1rP3fTGS73XgcHw70sQH8UStJl0WYpG6POi00NMrhLRTischKrKdPEv9
         4ZW7hRA8AHsUJt6chRoq2+VJj8xtOWXXEIcl7vzxPUuIATbEKYwfWlOJibLuOdv0v5mT
         0nsQ==
X-Forwarded-Encrypted: i=1; AL+hErHgyneSZxKjHLYKbMLwNIl2RSmMKEY9Is9LWiG9710s1PC7lPxq8cbWEGHQTbGfuMTKy4j+Gl4J4z4NO9s=@vger.kernel.org
X-Gm-Message-State: APuU4Z9sEOzkybMtvASVoWvnZXpezLGRLDTypE64fkRLa5zKP+I+nlfs
	tr1zS0Q1WywublZ2RB4ahwOOftftG+fNXZvTRDgI+7EqbdqJF1oP5etpsZlOVy+s8rHRySJMZSI
	NiyrrrHKYq7n789uBUXlOx82ZJWVy/co=
X-Gm-Gg: AYBFou1GYnSdg4WdiQ+b7dBNFG6Mb0H59T5TMbraYr9SxjXiKWHK/XYzVCOeZxhFNI3
	/8e/4CgKwxQcHU3RwEFaY1aMhaIBhPlJh2GyPQ99q0z6wT40hwLFgjQ2BUUSzLL5LhIM1pwaUuI
	rKrQuO/i5QzC4Mwb6jy/uKJuUjDcyMhRdJHpzl6TlLWvHzC28A53wShSHnX3NfQlu4BhcKODJYs
	fZfY8G89eJDuUNMA6u9jjhrohmgALlK34bSk2eaYeA76L/pZ3UlKTgO87ioQpNHPr48G+Tx59bo
	oSOa5LfMotSJEdchifL49YVNU96hGenOGgMTYOAOgU248q6sIClvtaf4WJ/KfE3SfAY+cRcNq9s
	CsQmPdOjPwQIbLMYSMH1Z66Js/s01wylx3ESWbiMzC/GkUFwsjEArm+6F2MZbPwF9X3yR
X-Received: by 2002:a05:7022:f4e:b0:1a9:f3d2:6262 with SMTP id
 a92af1059eb24-1b5030ee522mr9770372c88.36.1794876335340; Mon, 16 Nov 2026
 16:45:35 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114172955.1598929-1-16567adigashreesh@gmail.com>
In-Reply-To: <20261114172955.1598929-1-16567adigashreesh@gmail.com>
From: Demian Shulhan <demyansh@gmail.com>
Date: Tue, 17 Nov 2026 02:45:25 +0200
X-Gm-Features: AclHuK8Hdqf0l41Oo8YCxxY3l_4qLeJNdLXkZijbeK6d0nAWuJkX5q1GXFBfDOU
Message-ID: <CAOLeWCtEMZrg74nrfCVfjo9ZqGAxXyNb3mZD+n8AqgxT5PvC7A@mail.gmail.com>
Subject: Re: [PATCH v2] lib/crc: arm64: Add NEON PMULL+EOR3 crc64_nvme implementation
To: Shreesh Adiga <16567adigashreesh@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Shreesh,

> +#define SHA3_TARGET __attribute__((target("arch=3Darmv8.2-a+crypto+sha3"=
)))
> +
> +SHA3_TARGET
> +static inline uint64x2_t fold_single_round(uint64x2_t fold,
> +   uint64x2_t temp,
> +   uint64x2_t consts)
> +{
> + uint64x2_t temp1 =3D pmull64(consts, fold);
> + uint64x2_t temp2 =3D pmull64_high(consts, fold);
> +
> + return veor3q_u64(temp, temp1, temp2);
> +}
> +
> +SHA3_TARGET
> +u64 crc64_nvme_neon_pmull_eor3(u64 crc, const u8 *p, size_t len)
> +{
> + /* Assumes len >=3D 64. */
> + uint64x2_t fold_consts =3D vld1q_u64(fold_consts_val);
> + uint64x2_t fold_consts_4x =3D vld1q_u64(fold_consts_4x_val);
> + uint64x2_t fold_consts_2x =3D vld1q_u64(fold_consts_2x_val);

Scalar vmull_p64() makes compilers materialize the constants via mov/movk +=
 fmov
(42/97 insns on Clang). SHA3_TARGET also makes codegen fragile: with
-march=3Darmv8.5-a+crypto, GCC stops inlining pmull64*(). On Neoverse-V2, E=
OR3
contends with PMULL on pipe V0, whereas regular EOR runs on all SIMD pipes.
Using inline-asm pmull/pmull2 and a clean 4x unroll in crc64_nvme_neon() wi=
thout
EOR3 should give better performance across all sizes and cleaner code.

/* clang -O2 */
      24: mov   x10, #0x45a
      28: movk  x10, #0xace5, lsl #16
      2c: movk  x10, #0x2240, lsl #32
      30: movk  x10, #0x6224, lsl #48
      34: dup   v4.2d, x10
      38: mov   x10, #0xa84a
      3c: movk  x10, #0x1e18, lsl #16
      40: movk  x10, #0xcdb3, lsl #32
      44: movk  x10, #0xc32, lsl #48
      48: fmov  d5, x10

Thanks,
Demian

=D1=81=D0=B1, 14 =D0=BB=D0=B8=D1=81=D1=82. 2026=E2=80=AF=D1=80. =D0=BE 18:3=
0 Shreesh Adiga <16567adigashreesh@gmail.com> =D0=BF=D0=B8=D1=88=D0=B5:
>
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
> -       if (len >=3D 128 && cpu_have_named_feature(PMULL) &&
> +       if (len >=3D 128 && static_branch_likely(&have_pmull) &&
>             likely(may_use_simd())) {
>                 size_t chunk =3D len & ~15;
>
> -               scoped_ksimd()
> -                       crc =3D crc64_nvme_neon(crc, p, chunk);
> +               scoped_ksimd() {
> +                       if (static_branch_likely(&have_eor3))
> +                               crc =3D crc64_nvme_neon_pmull_eor3(crc, p=
, chunk);
> +                       else
> +                               crc =3D crc64_nvme_neon(crc, p, chunk);
> +               }
>
>                 p +=3D chunk;
>                 len &=3D 15;
>         }
>         return crc64_nvme_generic(crc, p, len);
>  }
> +
> +#define crc64_mod_init_arch crc64_mod_init_arch
> +static void crc64_mod_init_arch(void)
> +{
> +       if (cpu_have_named_feature(PMULL)) {
> +               static_branch_enable(&have_pmull);
> +               if (cpu_have_named_feature(SHA3))
> +                       static_branch_enable(&have_eor3);
> +       }
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
> +static const u64 fold_consts_4x_val[2] =3D { 0x0c32cdb31e18a84aULL,
> +                                          0x62242240ace5045aULL };
> +/* x^319 mod G, x^255 mod G */
> +static const u64 fold_consts_2x_val[2] =3D { 0xb0bc2e589204f500ULL,
> +                                          0xe1e0bb9d45d7a44cULL };
> +#endif
> +
>  /* x^191 mod G, x^127 mod G */
>  static const u64 fold_consts_val[2] =3D { 0xeadc41fd2ba3d420ULL,
>                                         0x21e9761e252621acULL };
> @@ -45,3 +56,75 @@ u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len)
>
>         return vgetq_lane_u64(v0, 1);
>  }
> +
> +#ifdef CONFIG_ARM64
> +#define SHA3_TARGET __attribute__((target("arch=3Darmv8.2-a+crypto+sha3"=
)))
> +
> +SHA3_TARGET
> +static inline uint64x2_t fold_single_round(uint64x2_t fold,
> +                                          uint64x2_t temp,
> +                                          uint64x2_t consts)
> +{
> +       uint64x2_t temp1 =3D pmull64(consts, fold);
> +       uint64x2_t temp2 =3D pmull64_high(consts, fold);
> +
> +       return veor3q_u64(temp, temp1, temp2);
> +}
> +
> +SHA3_TARGET
> +u64 crc64_nvme_neon_pmull_eor3(u64 crc, const u8 *p, size_t len)
> +{
> +       /* Assumes len >=3D 64. */
> +       uint64x2_t fold_consts =3D vld1q_u64(fold_consts_val);
> +       uint64x2_t fold_consts_4x =3D vld1q_u64(fold_consts_4x_val);
> +       uint64x2_t fold_consts_2x =3D vld1q_u64(fold_consts_2x_val);
> +       uint64x2_t v0 =3D { crc, 0 };
> +       uint64x2_t zero =3D { };
> +       uint64x2_t v1, v2, v3;
> +
> +       v0 ^=3D vreinterpretq_u64_u8(vld1q_u8(p));
> +       v1  =3D vreinterpretq_u64_u8(vld1q_u8(p + 16));
> +       v2  =3D vreinterpretq_u64_u8(vld1q_u8(p + 32));
> +       v3  =3D vreinterpretq_u64_u8(vld1q_u8(p + 48));
> +
> +       p +=3D 64;
> +       len -=3D 64;
> +       while (len >=3D 64) {
> +               uint64x2_t t0 =3D vreinterpretq_u64_u8(vld1q_u8(p +  0));
> +               uint64x2_t t1 =3D vreinterpretq_u64_u8(vld1q_u8(p + 16));
> +               uint64x2_t t2 =3D vreinterpretq_u64_u8(vld1q_u8(p + 32));
> +               uint64x2_t t3 =3D vreinterpretq_u64_u8(vld1q_u8(p + 48));
> +
> +               v0 =3D fold_single_round(v0, t0, fold_consts_4x);
> +               v1 =3D fold_single_round(v1, t1, fold_consts_4x);
> +               v2 =3D fold_single_round(v2, t2, fold_consts_4x);
> +               v3 =3D fold_single_round(v3, t3, fold_consts_4x);
> +               p +=3D 64;
> +               len -=3D 64;
> +       }
> +
> +       v0 =3D fold_single_round(v0, v2, fold_consts_2x);
> +       v1 =3D fold_single_round(v1, v3, fold_consts_2x);
> +       v0 =3D fold_single_round(v0, v1, fold_consts);
> +
> +       while (len >=3D 16) {
> +               uint64x2_t t0 =3D vreinterpretq_u64_u8(vld1q_u8(p));
> +
> +               v0 =3D fold_single_round(v0, t0, fold_consts);
> +               p +=3D 16;
> +               len -=3D 16;
> +       }
> +
> +       /* Multiply the 128-bit value by x^64 and reduce it back to 128 b=
its. */
> +       v0 =3D vextq_u64(v0, zero, 1) ^ pmull64_hi_lo(fold_consts, v0);
> +
> +       /* Final Barrett reduction */
> +       uint64x2_t bconsts =3D vld1q_u64(bconsts_val);
> +       uint64x2_t final =3D pmull64(bconsts, v0);
> +
> +       v0 =3D veor3q_u64(v0, vextq_u64(zero, final, 1),
> +                       pmull64_hi_lo(bconsts, final));
> +
> +       return vgetq_lane_u64(v0, 1);
> +}
> +#endif
> --
> 2.56.1
>
