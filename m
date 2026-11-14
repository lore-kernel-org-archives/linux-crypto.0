Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794665006;
	b=o4JRHu4Ae15vpYugg6LY6JWJLMFvcosGEGaHZcplnv0vXp+PAaAVBO9gVPjpvZ9V9c+E
	 YZ9d90LOQ3PhUnnoOg3T4TS4g93LyRxROWylCy82TQXYhpC5nvpEa7Iw/kqeIKpuunQls
	 hrs5eAPycSmOyOVDFmcP+jHE6oRDc3zqxAcIMqp2Mcf89obGfikZstv2F0qufQQl13IoN
	 /juPRzAv9fl7anPwgv8rora8t7hllZAXq7c5KybMdHpyyK6TNK3sL/58E4MQL+zS5YNrY
	 VebRr2LzRGbmGKEMwD12IygaGV5dLjpgIWqyo8z30qh84N/IfwLdIfpYYG41jlcnx4A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794665006;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=OSOm1VnaNdiNsetCoXxjItFeFoAmwJ/tc+GsokdfVbA=;
	b=3ePPwlz2BsSh00CIHcyCjp5oFRKUvP2oRuU0Yo2iAxj+8OuqFd9kY0+I1IMigfG/FUJ5
	 iimbNcLBwb4ZImUYf1IBMAmQoo3V+uEV6dSBRb2u7RPzt0M0I9vjFr8dJDfzudIU3ahD9
	 P9AKvHN/NgvBzgEad/RLm3fRgxxRzQnQOJB+M/pnKSzts7HsGJlMA7NPi/m7P/CG+ynZl
	 3D+a3G2KqFgUlxrXJAGvWSSrGIIkcJVdHajJrfOl3evkB173C8hC/846K+16HMWBm/Y1r
	 5/IK7dt1Q3NZsMHinf6i0sHz1bA96Dwo0yMA8XQ7wHse+nFR03Xxp8adWpJNpuJXvog==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WJMc1EBs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.52
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C11606A327
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 14:03:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29C11606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WJMc1EBs
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1b50a4bd2f3so2154638c88.1
        for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 06:03:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794665005; cv=none;
        d=google.com; s=arc-20260327;
        b=evJPCMqX7c9u8W3wuOyHu1FQnogSQfYKGUsJix2Rmu4wl4Nc19PzSx8A4WhXmRN3FS
         U6+U0ao5aivjnysqovv/Xp2h4niB8v6dJZRSc1ETxydDmQatO5f9Tsi4iaeoA6dit97r
         Q7qYNFXT6vuHJrxDobRnic2yf0Q87W9Ob5+xFK02EeQb19jdzDvgpZWpCpa5jdE/n8e4
         l6ccsVUOf1ErhBZGVbIR4ayTsmBFe/56nRoa4S3B/UAuk4hjuJ1D+JqcwzuOrLxwLBH+
         Y3makvazE+6PVCtIqYG8XbnOX1hkYz+S0u3TwR+TttUpfYwO7JT3yzN/8d9Du8nC5W44
         k07w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OSOm1VnaNdiNsetCoXxjItFeFoAmwJ/tc+GsokdfVbA=;
        fh=/6dDeIM969jX2yRwD1G9BXyE85cLDzZ2PUsrRkk0T10=;
        b=DkjIwWznhfnOTLMBF6bdF9eMwXX1U5g+gweikYKiVwI5cuCpN0fa9L+ZUDnxSmpdux
         pTxkZRHuwhBvLdDi4GhpGtTh/0gpk4UC98LzzFv0Hnwwn+MYQMHquO4Q5GoiU/YrXUjd
         bbJhd2iR987W2DCD2HSR2qTF506McNjav5sUUGTKpE09Amj6p6MSTSuskG+4MDAl+TFo
         cpW6dd4bjbFYkuNzuJnF9Bi44j7/915YAJV+budYZLilQHojzImfLN1XmcGh06eCg1gm
         koqgYTD8OkMPf2AECKAEUeyIVSiBmsiMZiV0bbwwU7qSN3xFyylKXd+Pz9Jejxk8JETz
         QXhQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794665005; x=1795269805; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OSOm1VnaNdiNsetCoXxjItFeFoAmwJ/tc+GsokdfVbA=;
        b=WJMc1EBsFUP1PDerk2ZEdXZ2gqlC93hrWcWh2jIxSb6nMPLkCcgrpBdRYfMkS9Ojgl
         Im6cJwele/ak2ABAEbU2hKn/juSxmoKaZKl2HnhmF7Hdz3Yh64kQy/tL2ktCvg7aaroQ
         6SrwtCECpMoQxCDoqF7ZASytjzIiMCg72Y+JQl69jThDpEJ81q4xY4aPQ6Kihyu6KfWJ
         FlqveiaUEKRUSm8rsR8ioL06zR7JEvYRXaTC7npbNzX0gzMC+e17ABAUTNEmGZ5xdQN/
         RBtxxglH8f0skIgsx1JySuG5jsnzEN4jQ7HMCH2n9QwN0/6lw225JO1nh8vf1UtbAdFF
         SJbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794665005; x=1795269805;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OSOm1VnaNdiNsetCoXxjItFeFoAmwJ/tc+GsokdfVbA=;
        b=Qy71ZRSHKBISczAbRmbXxiVRqGK+KHYRmMoaV8cgf0qV/fBRy0m6s1/rATTBWIKcvZ
         lsL45/YzmZGAj8cFcCD08m9b0wLVtMbghyaefb5+Ti2xTSDZ50MNsXLHSAAygmgtgp0N
         ZzZGyEQQ3szEbI8y9j04ENQDn4zLuNubdG/gtzs8oVJx7i81ku6XM11ijqdX0rRZCQsa
         DUeuGFlC6laySlB6LMdKl9+cXwMl69kxnzbQy0dweRZO+W1Z9WqFzNUJWghcsCoWW3k9
         YEuIXd0fgzz+aLZevmtdDjMykpu++om6mqzxW8mFKVbDTHuX5E5Q+jYdiB27lpmgAewt
         NlFw==
X-Forwarded-Encrypted: i=1; AL+hErH6jdfiHfKG8jowtJoPg+YE1QuPiGfBBXiVfyn9IliHih+vD6RCQDir0E820q5Ej+Itno9DT7vBwZ+GsTo=@vger.kernel.org
X-Gm-Message-State: APuU4Z9PJbYNmCgH+QVaCD4qTjsZeNLCLZJDFlPmHCIqIzm5nG8AGRwj
	KXLmg29mp50a9bpTEUsYRYj+kQs9A14uMYeTepXx9R9O2aQSLJ/Bo1ayAYAJ3HHje5nj8spc57/
	gPV2C1ToqmenLI6bGCukwviGKHRk7wgY=
X-Gm-Gg: AYBFou3eG6b+bXpHA7kVlq8VMp9UGx2nSQUC17mkaowj9gVp57Zp89LQpG2wQ3DnlB/
	hNqcNolY20Ew30l45IlNl5fDUMdRN8twB6MHsiKs0qaA6vvSfJAsvYP1HbmgGoNeZBmsBUm3OSd
	Mq7bfHEcfheIlHMVUskoJTDKT/XoIHzjhuxWtVXK77ZsobLDJp8iLiNXu943LFPxyZaYXPPxHuK
	jWKU25DXeOxksL/i7L3k0KX0i+OLWCCUgymVf1ZG2ODBk7kyLXKrfrpBCt3Hr/sVFt850S3nnz0
	IJhboR8P0yMR4xQcR4LLzrEjfZJiNwp5/mjFXSzIa3wSB8ZJSY343gJ+T/Ez2ueuZFVPF5U78AQ
	5SEgPpA9bjxZjICRxdVGdfOM/2vp5TgX2bmWfoiRmQ167jFyUy8nbzqXbZ8193ZNho2n68Ko=
X-Received: by 2002:a05:701b:4208:10b0:1a7:979f:ecc0 with SMTP id
 a92af1059eb24-1b50311d009mr5819252c88.27.1794665004802; Sat, 14 Nov 2026
 06:03:24 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114115749.1061233-1-16567adigashreesh@gmail.com>
In-Reply-To: <20261114115749.1061233-1-16567adigashreesh@gmail.com>
From: Demian Shulhan <demyansh@gmail.com>
Date: Sat, 14 Nov 2026 16:03:14 +0200
X-Gm-Features: AclHuK9gEd2vLkYSuKbXY90F1i3WqtHAO8j3tGJYv9uq-Ye2rOWXIUnL9CGQyC4
Message-ID: <CAOLeWCudnTKsmK8cM8x=O8U_7FAd_M27bFLtR_hG1MCmoAadLw@mail.gmail.com>
Subject: Re: [PATCH] lib/crc: arm64: Add NEON PMULL+EOR3 crc64_nvme implementation
To: Shreesh Adiga <16567adigashreesh@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Shreesh,

> @@ -19,7 +20,10 @@ static inline u64 crc64_nvme_arch(u64 crc, const u8 *p=
, size_t len)
>   size_t chunk =3D len & ~15;
>
>   scoped_ksimd()
> - crc =3D crc64_nvme_neon(crc, p, chunk);
> + if (cpu_have_named_feature(SHA3))
> + crc =3D crc64_nvme_neon_pmull_eor3(crc, p, chunk);
> + else
> + crc =3D crc64_nvme_neon(crc, p, chunk);

Please add braces around the multi-line if/else inside scoped_ksimd().

A few performance suggestions:

On arm64, cpu_have_named_feature() calls out-of-line cpu_have_feature()
and loads elf_hwcap. Doing that a second time inside scoped_ksimd() adds
overhead. Using static keys, like in arm64/crc-t10dif.h, avoids the
extra calls on the hot path.

> + v0 =3D fold_single_round(v0, v1, fold_consts);
> + v0 =3D fold_single_round(v0, v2, fold_consts);
> + v0 =3D fold_single_round(v0, v3, fold_consts);

Here all three folds are serialized on v0, so each pmull/pmull2 pair has
to wait for the previous eor3 to complete.

Could you try folding (v0, v2) and (v1, v3) in parallel using 2x constants
(x^319 mod G, x^255 mod G) and then folding v0 with v1?

/* x^319 mod G, x^255 mod G */
static const u64 fold_consts_2x_val[2] =3D { 0xb0bc2e589204f500ULL,
  0xe1e0bb9d45d7a44cULL };
...
v0 =3D fold_single_round(v0, v2, fold_consts_2x);
v1 =3D fold_single_round(v1, v3, fold_consts_2x);
v0 =3D fold_single_round(v0, v1, fold_consts);

This breaks the dependency chain between the first two folds and should
help shorter inputs it would be interesting to see how it behaves.

Thanks,
Demian

=D1=81=D0=B1, 14 =D0=BB=D0=B8=D1=81=D1=82. 2026=E2=80=AF=D1=80. =D0=BE 13:5=
7 Shreesh Adiga <16567adigashreesh@gmail.com> =D0=BF=D0=B8=D1=88=D0=B5:
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
>  lib/crc/arm64/crc64.h |  6 +++-
>  lib/crc/crc64-neon.c  | 79 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 84 insertions(+), 1 deletion(-)
>
> diff --git a/lib/crc/arm64/crc64.h b/lib/crc/arm64/crc64.h
> index c7a69e1f3d8f..003fd452aca3 100644
> --- a/lib/crc/arm64/crc64.h
> +++ b/lib/crc/arm64/crc64.h
> @@ -9,6 +9,7 @@
>  #include <linux/sizes.h>
>
>  u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
> +u64 crc64_nvme_neon_pmull_eor3(u64 crc, const u8 *p, size_t len);
>
>  #define crc64_be_arch crc64_be_generic
>
> @@ -19,7 +20,10 @@ static inline u64 crc64_nvme_arch(u64 crc, const u8 *p=
, size_t len)
>                 size_t chunk =3D len & ~15;
>
>                 scoped_ksimd()
> -                       crc =3D crc64_nvme_neon(crc, p, chunk);
> +                       if (cpu_have_named_feature(SHA3))
> +                               crc =3D crc64_nvme_neon_pmull_eor3(crc, p=
, chunk);
> +                       else
> +                               crc =3D crc64_nvme_neon(crc, p, chunk);
>
>                 p +=3D chunk;
>                 len &=3D 15;
> diff --git a/lib/crc/crc64-neon.c b/lib/crc/crc64-neon.c
> index 4753fb94a4be..6c589b23ed06 100644
> --- a/lib/crc/crc64-neon.c
> +++ b/lib/crc/crc64-neon.c
> @@ -10,6 +10,14 @@
>
>  u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
>
> +#ifdef CONFIG_ARM64
> +u64 crc64_nvme_neon_pmull_eor3(u64 crc, const u8 *p, size_t len);
> +
> +/* x^575 mod G, x^511 mod G */
> +static const u64 fold_consts_4x_val[2] =3D { 0x0c32cdb31e18a84aULL,
> +                                          0x62242240ace5045aULL };
> +#endif
> +
>  /* x^191 mod G, x^127 mod G */
>  static const u64 fold_consts_val[2] =3D { 0xeadc41fd2ba3d420ULL,
>                                         0x21e9761e252621acULL };
> @@ -45,3 +53,74 @@ u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len)
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
> +       v0 =3D fold_single_round(v0, v1, fold_consts);
> +       v0 =3D fold_single_round(v0, v2, fold_consts);
> +       v0 =3D fold_single_round(v0, v3, fold_consts);
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
