Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794899224;
	b=jNWHvxBpl0Y/kX6PJ2dS3JTbg7TigjS0JlIwr1FD5ir/OFuJwfd4X6oVRjh4Bxu4qJZu
	 x5oK+fFntN+i45yoseJxbVvkDd6aapAqGYRvjWESrJpuPsTGCUlB8ZLzJy9hE/W7iU1bE
	 KQ/t3kSvnwUXTySHlYdiJ5+OMWLa6Gowq/wn375mIImiELp14jbXhlwhuq/Lpw7adHa0i
	 AtP/quH0wOj0Sasbo9j+ZNktGMtKwwvcN7MSj2619qyc7GBsL0EXzbTckLR8PbUezAD1Y
	 0AkakL2vhCxRUaZ25myM+p+CYb7S6ToJizeQ6l9kFbmydygWKJOkyi9HRONJMGCZk4g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794899224;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=nn4DZhfswO5NC6K4Ff5vMiO0SvmHz8HXjX82jlIR9nM=;
	b=UXsqiAxxO7bXkQB9fv/885AcWQrB/3xzcACy7rWcIu/SZOfr329OzrDJdVLJfr2/ZEIo
	 0zkuK3julmzYdQ9bVlqqrG62D4gYown5XT8dLOunPekYGp7KmBpCVqzrxedW3P4jdZY7O
	 P0fVVkmPBORFbR9e9uUZTKY+zfKmFUxA3vA1AnhoQnh6LPaH7VYFrzGXDYrB73f1h6Z9S
	 kKPPDmr0doqqMyDPOZwrPSMpycIFd9bhJ6t4sckhvMws1DqfkbFg0SHaRRc80CShKJAgq
	 DXL5bzQp/5Hvtz4W6rcPHzSeM9nuS35TrY0bz0FwTNhJfGR4eIG970uJEroJ75PUkyg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AoYSW9GE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65C4606A88B
	for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 07:07:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E65C4606A88B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AoYSW9GE
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b167ffd132so7263993a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 23:07:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794899222; cv=none;
        d=google.com; s=arc-20260327;
        b=LBERAhYjSQ+bVgVa92u8EC6+aDAdfXffXw2JmViSHjtMwLWGlDtBkmvu+8lO6JlMBC
         ZQqswV4bwXD9cX5ppiRgXfNprFcx/euouOI4s4Bf1XRzJVI9VO82vbEOVwahNfRO1fyJ
         UXBXDABndJ1L8E8fyEreJOfM/N24rNUwU5hYLz+Bhbat90V5nJ29+3W0/teG7OOyBI7/
         n1yTt6Rm+KUc9PvlfGQz5/ABZN+BOftXLFWVw961nMXwHV19KWv2CKeY8DxElUa2mWMb
         ljm9UBcOlzYHzPXudybxMgufg2B6xMeUTNVRrfMv4F5qhvhMRU1b4TZju61U0/d9HAlr
         JJuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nn4DZhfswO5NC6K4Ff5vMiO0SvmHz8HXjX82jlIR9nM=;
        fh=zjf2uMCSfSgxlVnvQ4WLvzhHMQTLKQg6nfV1ZnEuFaU=;
        b=mnlS0Hi7FmH1QZcN+QdAHTXH74257VJaRRAlVhAg2+DQkQLPwFXjSoCRPiAQkvX3T1
         b294JC8Hei6ig5959uAhOHHFXRArKYF8CoU+WV5ZCLSPrOZwFO274tjcmesRT2iRQX9j
         HjV5h4cSceXn3gJcDV1Bdffi1aqQtkBB2dnam2VyLZHW+eEW05JpPotM66/InBNriDci
         6PtJPvsStCEuw7DTZMfiMQO7TpVJkqRkPCpr/jCztX+LWOyGOJxBxMrDFXwe3qkyLcoh
         e0R56DTX8sr7kPMUSp4+Pv2szMX1oFFomUJwWBVSyu+1WQYIaNiwIfY9ecLeNE0U7UH1
         HeCw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794899222; x=1795504022; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nn4DZhfswO5NC6K4Ff5vMiO0SvmHz8HXjX82jlIR9nM=;
        b=AoYSW9GEm9RTHU1qX4O/c3I9Qu34+HcBvIOMsM67Olqf88Gh/SjDWCcJgvwduDE5Wt
         DYth9HLyAm1wpqTAV0V8CS4+gDVXzfOdpOeLGsA81HswxPC2B9eQ7a6ghdLXZeyo0GCZ
         iZIZ5EewZbJcnjoOkt+FtvNNMasgoFc2cQXpKiso2E3IbIlV8y9YtBZebRRiOh0lghCJ
         wzywbRBnPFpqgFnwAfW0yNtMpbWpHOalLBlDksDh43M3OGN8NjD6kFYeD5i1UGKYauAX
         EAmEtlUSGOTdu2tNdJZLnfBBtMjz9DIVb9x1lhU95ey51Rqa2FAnMl4o9Uw5bJ6tbBrB
         U2CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794899222; x=1795504022;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nn4DZhfswO5NC6K4Ff5vMiO0SvmHz8HXjX82jlIR9nM=;
        b=IJY5JaWoOgxqpCGd14wgHdXwwEWqeOoIzevWpj7R0bje2wC5Ktjk7nRllr0NwJcA5P
         QkWP4+HRkebgk6R2VfT2STHvCvd/Xm5mVtXiV+6fmSqpUr+rkl20A9654DwHXyNLiAtI
         lg1y2jHs1nJpgGh8aNozMI7tlh94L+W4h8mEyuRc3MMugFK0Loyo9uuOpJOWrYEj+Wl9
         3h4kcWAfljgP8af7LctTDyhpAdMbKB/h33h3+JSxsxILwoMbcu0vikmDD1xutTZD1Z86
         SvEt2pnDfwibmbiTin0mNrM9+jlWVvMEAMheqehszM/7w7MCQ2jWQx/TY9cDBeIvXXO2
         7FcA==
X-Forwarded-Encrypted: i=1; AL+hErF1i73PGv49BBRBVDLAZSo+a2XitE1hipv9tGnsxpD8y/6PtlJhGRvQe/PtlfYJ0wM2n5JgSin0dLs3Aic=@vger.kernel.org
X-Gm-Message-State: APuU4Z92I+bAGxE+ptIeeKimMA85Ws4ir8N2i5oOwbSWbQWbSn1vKo0b
	mcMTUuDXuaD+cpBKKnILEhfnwGR9YWu6cfs7YYfdhnz+sm9q41Za2OT2Rb6PWw04bmaCpOilBJ3
	qXjF0syi4BwaTDsL1YM9x9bTb0KqOK9Q=
X-Gm-Gg: AYBFou302+mkn/26L7iJwvil8qUYmPQNDQJRo2V8eQ+mlAgkqYOiUvW067NpTqgRSrl
	swiUjhOc3hJR1P8bgshoiuCqG5vYIiKmE6VWE0rYY4edv+ylRzQJ1m6TcLqMDcmXKXmE7IsV42/
	VXWoUQWKsvXi7AvuBeMFse3X9k8l1FWfHPGQx98vmbKRcDCrAZJaxlAb5FpVTaPUQV6TJO3euiC
	kY6L0I2FnWl6Mywkza40R8O/qfKyYWPq+OnmNV4Choha82sWl8iYV8TmcOvzl/6QcV9V4yieSpP
	vpDKQJvUanuJnYJgWCtTjvSAL2M3gMNYzHkKr51W+S3jK1zpvPGuUuaE0eH+oUnBqyzejjQWJ8u
	k7TB3e8mrz5Dk2REdz1HOmAgSbrufwn8gfOA=
X-Received: by 2002:a17:907:d01:b0:c2d:be57:f73a with SMTP id
 a640c23a62f3a-c50963963a2mr997790666b.13.1794899222311; Mon, 16 Nov 2026
 23:07:02 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114172955.1598929-1-16567adigashreesh@gmail.com> <CAOLeWCtEMZrg74nrfCVfjo9ZqGAxXyNb3mZD+n8AqgxT5PvC7A@mail.gmail.com>
In-Reply-To: <CAOLeWCtEMZrg74nrfCVfjo9ZqGAxXyNb3mZD+n8AqgxT5PvC7A@mail.gmail.com>
From: Shreesh Adiga <16567adigashreesh@gmail.com>
Date: Tue, 17 Nov 2026 12:36:51 +0530
X-Gm-Features: AclHuK89PYXtgxI2vxc3gGqZaCu78_x5VJgVWZfhvDFli4-iD1hB0YiHCnhJvd0
Message-ID: <CA+-x59aHR7pW6f1UMy2_Cd_JBVNwPA7Z2KYm3xmmC4JTF1DOPQ@mail.gmail.com>
Subject: Re: [PATCH v2] lib/crc: arm64: Add NEON PMULL+EOR3 crc64_nvme implementation
To: Demian Shulhan <demyansh@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Demian,

On Tue, Nov 17, 2026 at 6:15=E2=80=AFAM Demian Shulhan <demyansh@gmail.com>=
 wrote:

> Scalar vmull_p64() makes compilers materialize the constants via mov/movk=
 + fmov
> (42/97 insns on Clang). SHA3_TARGET also makes codegen fragile: with
> -march=3Darmv8.5-a+crypto, GCC stops inlining pmull64*(). On Neoverse-V2,=
 EOR3
> contends with PMULL on pipe V0, whereas regular EOR runs on all SIMD pipe=
s.
> Using inline-asm pmull/pmull2 and a clean 4x unroll in crc64_nvme_neon() =
without
> EOR3 should give better performance across all sizes and cleaner code.
>
> /* clang -O2 */
>       24: mov   x10, #0x45a
>       28: movk  x10, #0xace5, lsl #16
>       2c: movk  x10, #0x2240, lsl #32
>       30: movk  x10, #0x6224, lsl #48
>       34: dup   v4.2d, x10
>       38: mov   x10, #0xa84a
>       3c: movk  x10, #0x1e18, lsl #16
>       40: movk  x10, #0xcdb3, lsl #32
>       44: movk  x10, #0xc32, lsl #48
>       48: fmov  d5, x10

Can I assume we want to have the 16-byte constants loaded using LD1
and use inline assembly for PMULL/PMULL2 and have the codegen not
perform the mov+movk+fmov instantiation?
Will look into extending the existing PMULL routine with 4x unrolling
and adding the partial block handling as well similar to x86 version.
I'll assume that 128 byte threshold for invoking this SIMD routine
still holds though, even though this is probably core specific.

For EOR3 though I assume it is still useful for many cores like
Cortex-X925, Cortex-A720, Cortex-X4 that I checked has measurable
speedup at 512B/4KB.
Maybe we can have a CPU core check for special cases like Neoverse-N2
which at the crc64_mod_init_arch we can check and avoid enabling the
static_branch?
Kindly let me know if it is not worth having EOR3 for all cores. For
now I will try to submit the existing PMULL routine enhancement as per
your suggestion.

Thanks,
Shreesh
