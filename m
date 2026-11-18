Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795020528;
	b=hpcEKR3woi097szsarT6AAA6oo7WaE+gZuBt2meXDl20r/b113GVnC0eUzAYzW9Dyq4h
	 onNZTsfbLZ4CaTrJnABc186blQPjzIhSJvVynxVWEBi0TaShGG9z3hGPvq2NpBJk0t65e
	 ws59IaQ8+FdwCNoGHG668y9URbjOlR6s+JdQQCCov5ZeLuSWtjZXmp2taw3+VtlGtvJiv
	 RdJkTUbQiMq2DW8QDTQvbLpw3zm8O9fieg88NsWpEhQnomHxHmSJKnMd42nCnZ9X5K9Uv
	 JWTVohE9TU/IoaZ/oVzxg7JBQk3vaE8ZBk0iLYWO29gbyF2kRLOE95gFE+ACoPQE0Aw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020528;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Qu8TLkte6pCLHa9w5qlji6UWllu8nnaFEtrp1BCXQCM=;
	b=vtjcPneguQa1wk4EwTbzIsPuoLCZBosxogmtHmXk0SJ0gRcch/zK5OR+x97+wZu6/vnX
	 X1czWjKiWd5iJzsHW1NdlIwIymZjlx6VnL13rA+/FP0vueHpqj5QgPWJaB0yIGOejEr/4
	 wsEBpXi4/ne3whUCbjZLATFVBZzVQdpz3y+xO0M8RRfVcR1dVJfMH9NzLvmcTiAhCLBqh
	 M8TWmgBEyON/VTr2cokufwgOamBOEqHcE5rmNzQNSV9HGN+qeBrkifpLSfsBKvBUMn8IT
	 LTqUObG79ohOh30mr8Hq3Q9KeCBj13t7jGssKwmr84HgYR0QW9kVoTz8mtiCDj5Gm8g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="h0Mkv/g5";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9774E606A320
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 16:48:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9774E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h0Mkv/g5
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c5125a04ba7so12203666b.2
        for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 08:48:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795020527; cv=none;
        d=google.com; s=arc-20260327;
        b=M93ARX9ouqF976tOpCDXo4OKLEMxTfNdUna2EYF0YNe3bGMR3G08UJvhHkILAFSL2J
         QrrSFMhqPQ/xXTLnzkKbPlLfoIS1O1qnwjwte7hfY8CSOx/jK6Go70UqZdvBA6nwmnw3
         grBWRXlajVnUJl6h0RRVCBRXqUze8JbdruzAqxtIxnfYcxiN4LasFCaggmJOWjsLXxZr
         LWA67ncDF6dQQu2/YRiGg160FccH+3hkTEzH2Qx5CkpZrLCgE2cgIQPmsLHFlizkbfJG
         JvEQ56gm0nEfmj9ZqAP8CIReD9WjidrSXL2E3nHD4NwxFp6LfnmjYc8/lc5IfKYiZKIo
         v+zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Qu8TLkte6pCLHa9w5qlji6UWllu8nnaFEtrp1BCXQCM=;
        fh=VIQxTdtCbfOcvm5AGT+j+6mekmW/wZ93/LfHh4HHUMQ=;
        b=AoIMaZOtWsGU1o2tZ6+JkhZLOjOVug8UIxAK2//c5mf7aTIZxgd6N00gBf8kmKeHat
         TawT3NIDDIFJ6uTVNV5CcDKlYUeORpSQPQZhVF2mZ8xaQrthXGVcoOvO8aEsvL2j2w9z
         KbEHOzVeRQFPsyBOKgsGWBiSvThmAM5pkebZwcEsn0rcbITf1pR1G6QGsfxDDwdVFfcO
         9Lz6Ht1oI42QwRaUakXF+Qa0EMLBfDIyG4mrsPiDBxzgxSTi4+qoRF8qo6ixOlA1yqZo
         4bShE8wY7TSrEmtHfdrGbywDrjyA1KfTROMrEKen/cmu9rCsKG+Js03tnyHDpfbcmEGM
         nXAQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795020527; x=1795625327; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Qu8TLkte6pCLHa9w5qlji6UWllu8nnaFEtrp1BCXQCM=;
        b=h0Mkv/g5AehZDEfkr7FHuutdVMEl94YLzs4XcisvX15dFjoqbXgjKClyr1CMmn0Zde
         NprC8H7Jj+eoT+SuAlUcPc4Guu6xweOJ83FBHfBKQj7G5nE10Usvx8EnesfscsRUL7BY
         9qPCGW4IYmzUgOoVe9IBLBX9AJFVW/4OzlHnAphOWBoGzUzU6sn/ueFQQbYOoTPgSY16
         EZhbtMZBZXodUDJwPIVE3oroJrsZLybbTUauU65PLN/5Chs0uq/raZkXxHkkUrMFn4xS
         k1Wu3gxyJG9ztgCHuAior0mkHw6zu2rDyKsWUHXD8T73jZHz3jfwGpAE2Glhz60bSskM
         05iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795020527; x=1795625327;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qu8TLkte6pCLHa9w5qlji6UWllu8nnaFEtrp1BCXQCM=;
        b=OYTjl26tf2rxlvzCjbD3KVyog7fNvGK9aVtY3KWirucq4Hqo3KuN+v9MJDJciRZshj
         jR6XvtYKHusKe+d4S0aR/sDFupnHqy8Nxqj/InmcN+xIcApQ9KwcTCtlX8IL6f0wu6Kp
         IHB6/FKpdObLt0pltQzzK4BmBOhLIPmdqxkyc2RcFzg5YzCq3VAiWlHDY2MywHZ0+7NX
         q+PJTkULpxlmxtMBLEFLyg9eFN3SbS690QqGfHBsqzRs65GM4wVgWG6PQ4IMaz/4KYDm
         brSfmwu6+QNL9305Eah6t5jy/kroPSy76iMLFTzwUfhn1mCzsqDO+/2LN4cH07tYX0Gs
         RHIQ==
X-Forwarded-Encrypted: i=1; AL+hErFM0aHkc7Wu66r3L1aqgQlyAmi5/J3mYsp+PFOUSYk6o9aKAi4a8c/QrVlhrEhmvt7zHDvMMLpI+iR1b8I=@vger.kernel.org
X-Gm-Message-State: APuU4Z99wR4SnkyvlzesKTh0VSfHKY5MqsPGr5OL5qSxld0QBZRFTxUc
	Ha/sj20nguY5+hAZiL7aYwUELVMiB+vTmLpEF3GTYpa4A+mDrWgb8M0R+TGljgwAL+fDlcvAsR9
	Uo51VMNPAuwhw39LPVyWsJEWbJrboxI0=
X-Gm-Gg: AYBFou0Y48WQkW0dq8k1hoqw+yOuplWntbE24rS4UmqYQihO2Xz8/pTiTQAkmPTlyvP
	mp9nnSBTAAd4MC7VYgBoz7SYqdJc/ymQxywQFq5IyrCqBMopSsBJYPkjoiT9DRP9eVTlDpnXL11
	orxS+XOLerCfldg5yI4tMp+vT2nA3T17aLLEoc9QO8FT/TXYa+pCCehSqDSDB2JW1KKOS6lw7ha
	72IGDvjzT1hVtCQepq86YDjYGabUaPbsjihYZNr6Vj7NOKr1VR9rOFODaOFxPzVKQQ7GQUg7bNG
	qpi2aFWDcRQA7+rjYEDbaOXGrUNVRCm04EkH107b5iFPW0/4QrwIbUFsBQtbXoUcp6JbhKyBBhF
	zsxHAWyspJHNAsZfS1ASebQ2kaDbhoswzWM0=
X-Received: by 2002:a17:907:72c8:b0:c29:f5d5:5a97 with SMTP id
 a640c23a62f3a-c510e2ea712mr279108466b.33.1795020526796; Wed, 18 Nov 2026
 08:48:46 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261118160110.1662470-1-16567adigashreesh@gmail.com> <de1538b0-bb42-4a7f-af9d-f7311a452fe1@app.fastmail.com>
In-Reply-To: <de1538b0-bb42-4a7f-af9d-f7311a452fe1@app.fastmail.com>
From: Shreesh Adiga <16567adigashreesh@gmail.com>
Date: Wed, 18 Nov 2026 22:18:34 +0530
X-Gm-Features: AclHuK_DxzZQeXWKQ7-X4q_Hfz3O29RVrs44GltQeiHuXMYKXC6TlXfwil0GmAI
Message-ID: <CA+-x59Y51H6=ggZOTXJhqbEtfhZ2KypcwbSWVMGXeVKb3ha+EA@mail.gmail.com>
Subject: Re: [PATCH] lib/crc: Add 4-way folding in NEON crc64_nvme implementation
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Demian Shulhan <demyansh@gmail.com>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 9:59=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> wr=
ote:
>
>
> On Wed, 18 Nov 2026, at 17:01, Shreesh Adiga wrote:
> > Use 4-way folding in the shared NEON crc64_nvme for AArch64
> > as well as AArch32. This improves performance by about 2x for 512 byte
> > data size on Cortex-X925.
> >
> > Add similar optimizations from x86 implementation like reducing
> > the 4x to 2x and doing a tail (len >=3D 32) 2x fold as well as partial
> > block handling to process lengths which are not multiple of 16 bytes.
> >
> > The partial block stage is enabled only for AArch64 as it needs the
> > 128-bit TBL instruction not available in AArch32.
> > Modified the loop dispatch on AArch64 to allow any len >=3D 128 rather
> > than just multiple of 16 bytes.
> >
> > Modified the pmull intrinsics from crc64-neon.h to use inline
> > assembly as the intrinsic usage was causing the compiler to
> > generate the fold constants via mov+movk+fmov/dup which was about 10
> > instructions for 16-byte constant instead of expected adrp+ld1.
> >
>
> Why is that better?
Based on my counting, 10 instructions (mov + movk + movk + movk + dup;
mov + movk + movk + movk + fmov) for loading a single 16-byte fold
constant =3D 40 bytes. Whereas now it is 2 instructions =3D 8 bytes + 16
bytes rodata.
Since we have 4 such fold constants pairs (4x, 2x, 1x, barret) it
reduces the instruction count significantly as well.
So lesser read-only memory usage. Also for in-order cores I assume
that the instruction sequence has serial dependency as well.

Previous discussion with Demian who had highlighted this point and
suggested to use inline asm for PMULL rather than intrinsic:
"Scalar vmull_p64() makes compilers materialize the constants via
mov/movk + fmov (42/97 insns on Clang)."
Hopefully the above reasoning is sufficient justification for this change.

Thanks,
Shreesh
