Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794898225;
	b=wI1UKMQQEI0HoTNrnjpHVw35LY84+fHxVJE/QafXcdTGApUyxPbM6hYEOdV1+bt8p3Ju
	 487sopTB/KY9k9kNJCsHgARCwTh7tSuSk7OXZn6AupGUOgOs1GEF+WNSMNvMj7/xIPzYX
	 1BJyDFq4Dqkub9NuZl+mrAInhBIbNvCT2PT2Q14Xf9z/B+CYc00ruodxlDNCyIh2NqZAQ
	 34tDx/vTkgD6dUl3hS5TeG6SlXcMQFBcLSdFF7GgcGfiYLvojLZNWLDUUHJxvkxd0FgkL
	 8UVVYl4kE1jP/Bic4u5sMUVSR9I64YmfsUfCmA1BtXbZi4yWVHKbRmD77Z9y2yGgdkg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794898225;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=w2ujTW8JKgVpi8GBaPpe+a6Vi5r6q/k7HuBea5FdHPY=;
	b=VjA0efGT0g3Epl3hO8H2Znu/OxSrHPduZU+FRpsCtiz11BlPDdAyMxBSYnBNhLPwkeHe
	 7qJowb/fn3iWghgn7qS+8YnCAWisGuwClhNpcNs/JJAu8w658B6BB3LLNcBhYkamth/Dv
	 cgl/YBJMdMDDFIdvYMV3kHUTDfSyjNAX/bcUqg8gVeKV0aUTaYNt3b69C2XQyzWsYlQAX
	 iXSEXcIv6RwtAIQzShC2rGpLdsJAl+VCrjrQIxevZ5I0rovnnOEf60rliElMXJv0bUlAw
	 DK2pD0wWx9JLjRyRbcLI1cvLE6TKmGu4kH8YCRyHDmxjN4jJMNKory6QDDklr+r/jHQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P1oVbfCH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992B7606A31C
	for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 06:50:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 992B7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P1oVbfCH
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4d28f75d62so833757766b.0
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 22:50:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794898223; cv=none;
        d=google.com; s=arc-20260327;
        b=UsrtKaZ9xpR2hg2Mf8VdheAnsDvbnOWuGEeJ4w1pLytGk15JanpZWiXeaCCIqeTuNL
         pZh/n1urpuUi4DA5DN45ABhFTQuLfCePQp5bZYp0A8zMDarMMMSrggJ1WieAYOaQ41x5
         KNHKN78bFhxgpUhjmLJnXErpmFYmOpdtSb+BFTw2ZGFWD2H1YZsn6BfEG8Nmc//Y1thq
         I4SnKZDoVGl7adtiCWVIyYOLZZOreE3K9pU2ok0KNL1+u5UYZ4ZMM3ccxNDsPf4k1CpQ
         EbEyLbRms7itNYBk1M8MCSUnH9VR+B5dQv7yKeJETLzzimYehG/ddZdrgvvWljRhaq2u
         Hclw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=w2ujTW8JKgVpi8GBaPpe+a6Vi5r6q/k7HuBea5FdHPY=;
        fh=1ATazT+q71u/unGTqkqYD6+7PYN8LNB/uvWUnkxwZL8=;
        b=oBhiDwW2v1Auo7HtjaBoOC0+GPxe2l8eZ7dIFsvdZUwauhIlKYBItZ5n77YWKgV7Xz
         GKTMPeayDQnHYd6CfoTN7aZjI9CfqoMZ3CficMkMk52BdXadTnQlEyWta12l5sXIfoKU
         SvDneB+/fjmkwiFFLtZ0LOMlQD4Y3k7OsgaoJGJrN3l2H8TZOomla+xWiMytYE0hNG2p
         /N9Gt1gnQIhIcddzsT86IhH/DrHrtfttFmXhM6P74QJ6dngGSJ09x2HU29jxdiNKAweD
         XgrKYw1DQrgfOBLRy5SUuNeAeodb9eW+39QeRX/1bYg21YwcqYe2pno0q70IM2NFXtLa
         F1yA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794898223; x=1795503023; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w2ujTW8JKgVpi8GBaPpe+a6Vi5r6q/k7HuBea5FdHPY=;
        b=P1oVbfCHWu7ZeOe6V6J+56WX4ByaVZbKr5AJjLMGW4YJg/tWNlf2I4SmHO+VyEkLQU
         F2z0P53N4ceMfOZyOBTUrtyPBNQcUD9cVj6vJyw7db3ULaD7Nanm6zEebtphadw6l7gt
         d79E9M+/KD6mo05ppncQAx1jqTcZmEvoZpSSxLEymXXdqv4eJn19pFv6BEDoO0sdE2YW
         yYsdgzP1jMc/Ljm+zOqFX4iNo6iDbRvrR2n211VGZ98/c5Gtd8PQDjDe3yrepLq9ME+G
         23la/HEWK5lovYS7EQtS8VxG7AXNELWGr6htTpKLUoWiSWBWjABsJPNrvNLPQ/uiwZ97
         KBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794898223; x=1795503023;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w2ujTW8JKgVpi8GBaPpe+a6Vi5r6q/k7HuBea5FdHPY=;
        b=vQkTSgBhGurKpZEFpJCUiJ28jLHEwVgGNIZ0pyjfmo8YQsXhrHivS+D5+UZTGmbgJ5
         pL1BxC34IMcyeRKSDw2UOITqEWza0Q743pZdq3RJr/hoMFhcOSSU3Ya5bq34fVJoMV/s
         f6YHs/pWC70drnV6op7YRHF8wiSgFRhx1774BkboV8SNU/fRhWMWEib/wt+KyS4iLHxv
         UPdxdsM2ACx2V1x+x9gVg2iucyjiC+PtwjYxjuiq03itIIPFvXDHT3R50/fzMEUQlRxY
         2l/iD/zha2NrVEdTuwoGCm/4j8I2eM2qjIi7SbDKHxVGw1fgi4zNa15HyGpWx87vjqHx
         E88A==
X-Forwarded-Encrypted: i=1; AL+hErFFNi7ulHScRhvjIInfjVJvq5plSE01IV+Js3oi+g/KT95JnbOp0bY1zibZJ/2t2bmjNW9HMVOJS8WzVm4=@vger.kernel.org
X-Gm-Message-State: APuU4Z+SB0lsNkvp2hUtDD/4q82vSoTLl09IWJ1FWot8Q7l/imE4iAhM
	uAZgieUfo7R7RqB7czG8FuHv1jHKvq7+Sckt+5OcfiAkVq5I7Vtrbpvr5r7P82zegUel1J55RUK
	LSpkUs9nZX5uC5RPDa1/i9eX++D8THgk=
X-Gm-Gg: AYBFou2C1cDUnL1JV8dYVhPb5nRWxFTA1dTMffvS+iBLXGoDtmBCja+D+NeJ2U6F7yZ
	gXoOXZlIrJwcD6znrRcuu2ASVGICObOQ3xyCRoi/QDCo+iXfd96xd6zJxeTnFS+B77EAgktl6Tv
	aD8rf3mAS9jUKIJg8+UVQ0S5BIkZV9PUsJoOzK+cwuLIhx9tmXXFyDKiLXfdC/3qCN934f/Q6PG
	02ajvZ0ZLUbigGsG+mNtPMQOo/E6k/+/1oxbvlduuTcWn/p59Wb6PlUJSuhRnZCVkOF2yDZcINF
	0ln+GHsn26/jl8sDhypYa8kaXyK1SYjoxiIkJax+U+7k2+b1VXZY55xPkE/eD/jrZ2XLTXe6XMT
	2yew8gPJehKPmvQ0WdDYnVxun39XOBR8on6M=
X-Received: by 2002:a17:907:868f:b0:c50:475d:980e with SMTP id
 a640c23a62f3a-c50963ced7cmr1066601266b.38.1794898222816; Mon, 16 Nov 2026
 22:50:22 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114172955.1598929-1-16567adigashreesh@gmail.com> <20261117000119.GH229817@google.com>
In-Reply-To: <20261117000119.GH229817@google.com>
From: Shreesh Adiga <16567adigashreesh@gmail.com>
Date: Tue, 17 Nov 2026 12:20:08 +0530
X-Gm-Features: AclHuK-4WgArdEcKAhaJtwM4CxSAsBuUG1yPsujVDm8kX8ujvzUg2VCGIExhdGw
Message-ID: <CA+-x59b-gUddP2cfHbzDrv9jupmeM1LeHkQnNXhE8_y6B+JC1A@mail.gmail.com>
Subject: Re: [PATCH v2] lib/crc: arm64: Add NEON PMULL+EOR3 crc64_nvme implementation
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Demian Shulhan <demyansh@gmail.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Tue, Nov 17, 2026 at 5:31=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
> Was crc_kunit run?  It already has a benchmark in it.
No, I have access to only one aarch64 device that is Android Mediatek
Dimensity 9400 SoC without root access.
Therefore I can't run crc_kunit on that, instead I have done userspace
comparisons for the same kernel with libbenchmark.
This is based on my earlier work for FFmpeg:
https://code.ffmpeg.org/FFmpeg/FFmpeg/pulls/21651
I also have Corporate MacOS M5 and did check inside Ubuntu VM but that
is not accurate due to virtualization.

> The commit message should also clarify that this benefits ARMv8.2 and
> later processors with the sha3 extension, not just ARMv9.  (E.g., Apple
> M1 is an example of an ARMv8.4 processor that benefits.)
Sure I will take care of it, but for now I am thinking of first
improving the existing PMULL to have 4x unrolling as per Demian's
suggestion.
Therefore I will revisit EOR3 addition later, will keep this in mind.

> > +#ifdef CONFIG_ARM64
> > +#define SHA3_TARGET __attribute__((target("arch=3Darmv8.2-a+crypto+sha=
3")))
>
> Doesn't this break the build with gcc 8.1?  The kernel supports gcc 8.1
> and later, but support for the sha3 target and intrinsics were added in
> gcc 9.1.  Either this code will need to check the gcc version, or inline
> assembly will need to be used for eor3 like lib/raid/xor/ does.
Yes it seems to be unsupported even on GCC 8.2 and works on GCC 8.5
onwards, I wasn't aware of older toolchain support.
Will keep this in mind. Unfortunately compiler explorer is missing
ARM64 GCC 8.1, will check 8.2 support which hopefully should be
accurate.
Will adopt the existing code in lib/raid/xor itself which should make
it compatible with GCC 8.1.

> > +     v0 =3D fold_single_round(v0, v2, fold_consts_2x);
> > +     v1 =3D fold_single_round(v1, v3, fold_consts_2x);
> > +     v0 =3D fold_single_round(v0, v1, fold_consts);
> > +
> > +     while (len >=3D 16) {
> > +             uint64x2_t t0 =3D vreinterpretq_u64_u8(vld1q_u8(p));
> > +
> > +             v0 =3D fold_single_round(v0, t0, fold_consts);
> > +             p +=3D 16;
> > +             len -=3D 16;
> > +     }
> > +
> > +     /* Multiply the 128-bit value by x^64 and reduce it back to 128 b=
its. */
> > +     v0 =3D vextq_u64(v0, zero, 1) ^ pmull64_hi_lo(fold_consts, v0);
> > +
> > +     /* Final Barrett reduction */
> > +     uint64x2_t bconsts =3D vld1q_u64(bconsts_val);
> > +     uint64x2_t final =3D pmull64(bconsts, v0);
> > +
> > +     v0 =3D veor3q_u64(v0, vextq_u64(zero, final, 1),
> > +                     pmull64_hi_lo(bconsts, final));
> > +
> > +     return vgetq_lane_u64(v0, 1);
>
> Note that this is missing several optimizations compared to the x86
> version (lib/crc/x86/crc-pclmul-template.S), including using
> fold_consts_2x for a tail of 'len & 32', efficiently handling lengths
> that aren't a multiple of 16 bytes, and reducing to the final CRC in two
> carryless multiplication instructions rather than three.
I was looking at the crc-pclmul-template.S code and I have a few queries.
In this aarch64 version we only dispatch to this SIMD routine only
when len>=3D128.
Since we have 128 bytes available, do we have to add the tail of `len
& 32` handling?
Handling len not a multiple of 16 bytes (partial block) I will add but
I am assuming that the dispatch will maintain 128 minimum len.

I was trying to understand your "reducing to the final CRC in two
carryless multiplications rather than three" statement.
From going through the code in crc-pclmul-template.S:
.Lreduce_128bits_to_crc tracing the logic below this label, I see
three clmul operations:
_pclmulqdq CONSTS_XMM, LO64_TERMS, %xmm0, HI64_TERMS, %xmm1

_cond_vex movdqa, OFFSETOF_BARRETT_REDUCTION_CONSTS(CONSTS_PTR), CONSTS_XMM
_pclmulqdq CONSTS_XMM, HI64_TERMS, %xmm0, HI64_TERMS, %xmm1

.if LSB_CRC && \n =3D=3D 64
_cond_vex punpcklqdq, %xmm1, %xmm2, %xmm2
_pclmulqdq CONSTS_XMM, LO64_TERMS, %xmm1, HI64_TERMS, %xmm1

I even checked the Intel Whitepaper and the reduction for 64-bit CRC
section "Final Reduction of 128-bits" also mentions 3 clmul.
One for using x^128 followed by xor, and then 2 more for final barrett
reduction with mu and poly.
Thus I am confused about accomplishing this with just 2 clmul. Could
you provide details on this?

Based on inputs I am thinking of only extending the PMULL version to
have unrolling with inline assembly for better codegen.
I will revisit EOR3 afterwards when the PMULL base version has
incorporated all the optimizations.
Mostly we can have always_inline function which can be instantiated
with/without EOR3 I think for approach.
Will submit new separate patch for just PMULL unrolling shortly in a
couple of days based on Demian's inputs.

Thanks,
Shreesh
