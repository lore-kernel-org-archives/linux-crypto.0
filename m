Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795799446;
	b=pflaoG6w/PtOJC4LUlSpvDD2LpR7uNCZPsEitw3jSIpXKv0ukeYhMYo6I9ms7gjiiMR6
	 apsiT8TVZa+YfgrZpVhL8MC1rrE5te+f7ttF3Z/l1dl1F1qnv0sbRlgW5MkprpVOfMuNn
	 8PQfojtSVv3Qgtx8iuRS6o6Vn9aJT+VfXJaAEKg0H6XU4atfTlFD9DMfzy89c6rsJcK9+
	 9LtddKIuwf9fad/YmbCMja6L8NI7vKNQNgqOTTSnALvwvaTG7PhDgyV07qptk8AmQ/HxG
	 ZFBodvo9wvmEJ6myHHM9O4+mL0/KHq2ZmwdJuSr2YHDAgrS8aZ7K0b5eGA1UsR5pGJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795799446;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OobuWDwPLwpxPZHGySsTYZ0nBfpDwhbsOy0WR2c3fKs=;
	b=mkjgBIHKtO4+MMKIDLYPTFVOvvxKUVyIUEQESQgGIZ/tcwQnXHQrSBx8oXYLmyOSbpIP
	 JyrbIgphyKgaZxXmsebDJm7HFWxlT6lftFyiDHupqK8MWyocEswk8WXiQ4g/3QbTrvi0F
	 iE4/zeDh1Z+lWbdjiv44V8qHKMToTTh5yT+hZTV5JMtgGWltoUN1ORE1bbWv1bq4xjez9
	 R4ZHs429HZqxN2VqqCrJeFAA6qnuy4VJdG6QUWDU84L1XCARGGy8qnP48daeBQnodbphW
	 Fo+Pa+79DE6cAKhczE1oNAkgs7iHY3W33NubEYw11EjhJczJJtZ8DvL7PqhxzlJHxMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bnWBdCTD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9446606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 17:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bnWBdCTD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715B21F00893;
	Fri, 27 Nov 2026 17:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795799446;
	bh=OobuWDwPLwpxPZHGySsTYZ0nBfpDwhbsOy0WR2c3fKs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bnWBdCTDlRlkOB+lJNKUa85ARh8wEaXL2f55DpQOmjgZx96jYGsL6773eke+MU69E
	 W41TjNwKRT5bzZMfr3BD1kXtmjB68kdgmhwfGjw3EO0DADSSqaLFZ3iM/bsBsS+wOn
	 ocLsQNj7dYR0NQFAzlcVvD7l1yFGuFrMu7yvOa072uaICzyZB0BLZOATw2oZhrtvxn
	 Tfn2uxedri5FfEWkGpSySBQhiDgTqvf8UJxW7DM/BvHZxwmZGgP87pDr1UESAcmn/Y
	 xmlUWigIqMobNyXO64P/Tf3Cd3V13s7Kk7FdacQNUIgMQ/HAz4hoiQnY+axB1VKJTT
	 r1cnmW/1L02Kw==
Message-ID: <sashiko-outbox-237967@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] lib/crc: arm64: Add NEON PMULL+EOR3 crc64_nvme
 implementation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shreesh Adiga" <16567adigashreesh@gmail.com>, "Eric Biggers" <ebiggers@kernel.org>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Demian Shulhan" <demyansh@gmail.com>
Cc: linux-crypto@vger.kernel.org
In-Reply-To: <20261127165747.512950-1-16567adigashreesh@gmail.com>
References: <20261127165747.512950-1-16567adigashreesh@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 17:10:46 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] lib/crc: arm64: eor3() fails to assemble on binutils 2.40 and
  earlier
--

commit 54e29282d614c667430bde2ef55715d4cb4f1a05
Author: Shreesh Adiga <16567adigashreesh@gmail.com>

lib/crc: arm64: Add NEON PMULL+EOR3 crc64_nvme implementation

This commit adds an arm64 NEON PMULL+EOR3 implementation of crc64_nvme for
processors with the SHA3 extension and dispatches to it via a static branch.

> diff --git a/lib/crc/arm64/crc64-neon.h b/lib/crc/arm64/crc64-neon.h
> index d872f4d4e2e78..40f37ff0407c8 100644
> --- a/lib/crc/arm64/crc64-neon.h
> +++ b/lib/crc/arm64/crc64-neon.h
> @@ -32,3 +32,18 @@ static inline uint64x2_t pmull64_hi_lo(uint64x2_t a, u=
int64x2_t b)
>  {
>  	return pmull64(vextq_u64(a, a, 1), b);
>  }
> +
> +/*
> + * Use inline asm instead of veor3q_u64() intrinsic: GCC 8.1 doesn't pro=
vide
> + * that, and the target("+sha3") attribute it needs prevents some GCC ve=
rsions
> + * from inlining the PMULL helpers. This follows lib/raid/xor/arm64/xor-=
eor3.c.
> + */
> +static inline uint64x2_t eor3(uint64x2_t p, uint64x2_t q, uint64x2_t r)
> +{
> +	uint64x2_t res;
> +
> +	asm(".arch_extension sha3\n"
> +	    "eor3 %0.16b, %1.16b, %2.16b, %3.16b"
> +	    : "=3Dw"(res) : "w"(p), "w"(q), "w"(r));
> +	return res;
> +}

[Severity: High]
Does eor3() fail to assemble on binutils 2.40 and earlier?

lib/crc/Makefile compiles crc64-neon.o with -march=3Darmv8-a+crypto, so the
compiler emits .arch armv8-a+crypto and sets the assembler base architecture
to armv8-a.  In GNU binutils 2.40 and earlier, the sha3 extension and eor3
require armv8.2-a or later, unlike lib/raid/xor/arm64/xor-eor3.c which
prefixes .arch_extension sha3 with ARM64_ASM_PREAMBLE:

lib/raid/xor/arm64/xor-eor3.c:eor3() {
	asm(ARM64_ASM_PREAMBLE ".arch_extension sha3\n"
	    "eor3 %0.16b, %1.16b, %2.16b, %3.16b"
	    : "=3Dw"(res) : "w"(p), "w"(q), "w"(r));
}

With the base architecture left at armv8-a, GNU as 2.40 and earlier reject
eor3 with "Error: selected processor does not support `eor3'".  Note that
selecting armv8.2-a or later via .arch (or ARM64_ASM_PREAMBLE) also resets
active extensions, so crypto must remain enabled (for example via
".arch armv8.2-a+crypto+sha3\n") for subsequent inlined pmull and pmull2
instructions in crc64_nvme_neon_pmull_eor3().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127165747.5129=
50-1-16567adigashreesh@gmail.com?part=3D1
