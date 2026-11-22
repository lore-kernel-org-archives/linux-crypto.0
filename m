Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795336328;
	b=Q3Wahtru8Y+vu5G0AUYPFennFi9syXKxcw8N8UiAuofDQZFjrfGaJHiZ05fT8qd5fIHi
	 wwf7PD4D8EKjguPc4UcaQOUYiU8aRXUxzdSxtc0/R6zqrZtn3OoC1kjIYuQaysDpKPiuX
	 apHvRrkEUgmTKMJH1MJ/la5utRhDhpuxK9ncRUINj7/NbIR6oUXaQIBjXR+JjWGz4ch7A
	 NcHtrTV/p9Y1VgwXgc8qMOJqyV7ozsjQMbT+WlrH+1eGayNkaVXgjXuDOLX72hKbHLq3x
	 LCo+TJXibb01J3bOXv54xkOg2yPyuMNLgIvzwi46NzEjiJMSBgOhQ10F2/rYNl6px4g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795336328;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=R45AhhYKsdhhZBr1KAdTobHjnFM6HdEky1mR4GL5Dyk=;
	b=qn38aiQy0ypDUfpxtJcnnz1xY/Y51yixCjvRptHBEcoS1eiILSuEoNizfpNV9uhWSQQ9
	 LU0ub7jzdqwgWOIulUVi+pZx4+XXyI0TG1Fm4mYbjZThezubfQF4c0imurN7FKnU4kJfb
	 qzeK7GsxEGlo8vfC2hwsh/f9ExbqC4LmphJuYAQzMeOuOHbSY5xY4Q7uf1ASmQMVISU1m
	 JGJNkowiC98B4Q5hGQpHwMuEfjMefzsF5eXOSqD9snkCuSP5f8d9gVZEUE9i+9sf5vJ01
	 FpnFL12jVeS6JAb5Mggxq8UIVjsSZ+ky9GrhD8+EInzpYfiZ/jpQWJYlBjKXXC1NxmQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rmg68O5O;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB730606A32A
	for <linux-crypto@vger.kernel.org>; Sun, 22 Nov 2026 08:32:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB730606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rmg68O5O
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4d2b741ed9so385592566b.2
        for <linux-crypto@vger.kernel.org>; Sun, 22 Nov 2026 00:32:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795336326; cv=none;
        d=google.com; s=arc-20260327;
        b=Cv0SHrApGe/s8cQwBOtaP52hHlZX+U+j+KyCOt/tSj7Nz6XH0yFfAc703+Tmqm6Q6U
         VPrKqSZxbuOK37beqRtjKF+qBEuJj2V4DOyoMLP/zl3XuF6PiUsePygt7Wa42pS2x6UL
         MrZsZdQ19ctVBnhtcodWOfLEQWABgB4Xay4zav6/K+H5ZrzNssgdei9JsYF0MtCy8JSP
         wqGRqiercHc8TJFWyKfl+7ZO58zCfgvtHL4Td/d7AcraQs8YjpJfVJ1/CXF906zy+Fla
         4XwSTxZqyPisDqPCuVxlG9rcX+vR/Gvvi+d4LzyWKmrF5XHlMJ+bS5KSIw82O4lcQIMk
         mHSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R45AhhYKsdhhZBr1KAdTobHjnFM6HdEky1mR4GL5Dyk=;
        fh=v1ZXujUT5EmRRUBALC+9XtkKPlXc+RYH1e0rvCJNnxY=;
        b=JBL/bzQz3i2oahq+g4zvGe+uBvJpFsiVOGjWnXKEbpASUZnNWocC3ElWiDalpYyqRW
         isLPwngO9kzJMCmDG0HSugam9XEb4NPTi6a01LadU1iYcXbWL5AjS2apjXVHt8wteYOT
         ODBA+9oZ5F2byDfjSphMeCIm7E2uBY+Y0WLcC2re2DAorUICaLx36OdrSlgjiaBNMFpa
         P8rEipovdoB3uN6vTkjefynN47oOsOwmXA+jnkCz6Sp8uif4xOI5T2Y2r3Pk17JPp8mf
         VSTjH/nRnapPQ3UFJ0TG1lawa8hJqLosrMG1E/TSg8L1gFKO0ZxkBlC9swIGV54UeSho
         6Pwg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795336326; x=1795941126; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R45AhhYKsdhhZBr1KAdTobHjnFM6HdEky1mR4GL5Dyk=;
        b=rmg68O5O7Yx5ZA9mkcLuoSNsCqGp2sETk8p/bYIMHm3KKojfUFYZSanfH4k4kWi8Zn
         /OiBtAl9pWIh8UeYQuWZ2dA0D55bsbWdmbRsedZbh1EboU+fLqCNvxPH71y6MnctuLA5
         I+iJwg21bcN2KCsYik6olvm+bInJ1Xta2RQ8uaJrPk539uLfyQ2mCL5MlRJZLAePJnwl
         5jfoCUroyyVbK5nrqducgiQbj/VPyIod/fkiW2s4TnhMuENdeaL1sITUEAXlgj9/Ifx+
         7HGVZd66jZEHNtD0roppwXvviBO9pnp8x9kHp6vCvdFC6Jv1w2uDQ/H76aYegYFrxAIU
         wtOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795336326; x=1795941126;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R45AhhYKsdhhZBr1KAdTobHjnFM6HdEky1mR4GL5Dyk=;
        b=02aqjxU+n2algsAZKhgJ4ra5wBEtnmULAqUqxAvs4BlNlu9qori2N2OKRzLZuC4yrC
         rBrvn0M4/Ihyg7eydpQZghxn3EE/XECyOK9k9AevHg1ouBN0HfEr/Zftk+K6fob1bcI5
         UoDSZedGnLh+MMOK+V+10YckIxuO9Kymfl34dPOEOU0yJsmYNySUvDJdf14VkfQ1zKaK
         F33XXoysbtTYwm68AURkAQquguweNIwCQUOZIzweJY0LJzd/kvVnyo7xZ11DzxNJctVc
         vIz/jpNhWpI7AYWUsH2P3g2A6ukLkpJaKGkUv0K0PM6J1GhHc1Nd91YYDewoFvpb/KYK
         qvsg==
X-Forwarded-Encrypted: i=1; AL+hErFpI6uzj2DdoqD5DmaHmtixpxT3B9Enu+OEkSerlU2wWWeGB3HtU40GrGjDpDZd0G4bgo5cVXyoJFEEhiY=@vger.kernel.org
X-Gm-Message-State: APuU4Z+EKOqxV2zzYShzq5C4xWd7M4M1GfnnRjX+93VUAWZiwEXNBzz+
	XBgPbzVu+QrAkh5k8ZkW/+BfLOksPPa+1u9FlKGQCzy5z9/m5K0Dh1ZGfWLyuSdUfLdv8B6rxel
	cH8xRNyWb7K5XSRPfi2kgoUBk6Qmv9D4=
X-Gm-Gg: AZFdTZcWhXm+sWf29IuOF3aykKXtvcWNqMu417nIoz7LNK1QA3pv0OpO8EJJmRh+cby
	QKI3aGqPmelagyKtE8wyGZvEPfLP1QPLs2FP9StkZLPXo1A3iDI/Uul/KSijkblZiP6IwFSjZIN
	j84hBMqJGtjZDWS+YkAeswSiztjWhCw0Xze5xpkz4Z3mz320U2BoVnyX+27OWjgJef6065K7Nvi
	K+vlbQR0uMgKbK4i09it8TSn1xhVZii4R649mvJdATV9OeyTTom7hlFJ8zwEGuOIxnbh1xYQi+o
	w30b+d63feKxKeDMhlRkKbcVsS1ssGc9uSyVvRtZHTqbG5Eg6VAW8QiqFrv3HBKDs4JhXTo0TFU
	0OZfzFo25EOv61Re4IPBtCAQL9i0dibwTj9s=
X-Received: by 2002:a17:906:c59:b0:c46:5973:2a1d with SMTP id
 a640c23a62f3a-c513aad1251mr512825866b.43.1795336326015; Sun, 22 Nov 2026
 00:32:06 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261118160110.1662470-1-16567adigashreesh@gmail.com> <20261121204631.GA16190@quark>
In-Reply-To: <20261121204631.GA16190@quark>
From: Shreesh Adiga <16567adigashreesh@gmail.com>
Date: Sun, 22 Nov 2026 14:01:54 +0530
X-Gm-Features: Aa3M54rQd_6NUSqDXWAp7z8l8pGAgea7F6rXaZmgtEfaNgy86oat4_takKEwpVE
Message-ID: <CA+-x59aOh_W=0RdS56PZh85fhvKZ5ym2HSvML7OWzXyCFN8azA@mail.gmail.com>
Subject: Re: [PATCH] lib/crc: Add 4-way folding in NEON crc64_nvme implementation
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Demian Shulhan <demyansh@gmail.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 22, 2026 at 2:16=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
> Note that an AArch32 implementation of fold_partial_block() is possible,
> e.g. vqtbl1q_u8() could be replaced with two vtbl2_u8().  Normally I'd
> consider an AArch32 specific optimization not worth including, but it
> might be worthwhile here since it would avoid divergence in the code due
> to the following arch-specific precondition:
>
>     /* Assumes len >=3D 64. AArch32 also assumes len is multiple of 16. *=
/
>
> >  lib/crc/arm64/crc64-neon.h | 15 +++---
> >  lib/crc/arm64/crc64.h      | 18 ++++---
> >  lib/crc/crc64-neon.c       | 96 +++++++++++++++++++++++++++++++++++---
> >  3 files changed, 110 insertions(+), 19 deletions(-)
>
> Anyway, I've applied this patch to
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=
=3Dcrc-next
>
> In general I'd prefer better comments in the code though, especially
> documenting nonobvious decisions like why pmull and pmull2 are accessed
> using inline asm instead of intrinsics.
>
> So if you'd like to do a follow-up patch, it could be worthwhile to
> address the above two issues.

Okay have submitted follow-up patch for implementing the partial block
for AArch32 and include some more documentation and making it
consistent on both 64 and 32 bit.
Once this is merged then will start looking into EOR3 support. If you
have further suggestions, then do let me know!

Thanks,
Shreesh
