Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795347579;
	b=vduzgQH0RscVkgzIZvAVamiSq3lTDINtqYJaBIW45ajqqvOFIVmn9pXqSflXuOYyEgG8
	 ikJIT7r8lzbHAYJdim4I2+TW9MzucZ2J7gXXhfOU4Q0fLCPEEx7P5secfrQCTXmyiIpJ0
	 5tRZVk62x2Q/lSQZMBLwe11FXyJTC+/e9evE4+k52BQI8GC0Hf5NfUvYY4k+fcOHh8ygt
	 ZD1tfwx83m3Q9UDw66QAsSrb0JED0uKEkF7cCWcYOu60kiI4eMTEKRZ52gSltObZPozJP
	 NZMeOIOgzLJDJJZ2cxCbPnryxwfvYlDzW+oCqEwvFsLJMBPv5liXMebj6sA3f8ncOcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795347579;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:In-Reply-To:References:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=WT4yKkDAmncDHMj/7AEWMzPC9QUnbfloQV8RtbZ7Cvs=;
	b=D/wd1z5mxmz4kl8FUUiMggj4bQS1l15ci625AttN/cvoJek7ZOabPnD6j5wUiiZ4WNou
	 YGmcTwK/UeqMY/7QSkOQ6rQIx1cTKDPTbhpNhapI/0O01cHif1ObtUaHp8+tB9eDv5MdA
	 cI0sMtNa4GvZfzu+X18H7nwGNm2D5MXR+bY3YhwDO/2yEZKTRu7I86Ghpeo/DP9zvb7B+
	 j0zbggM1SvVJ9Vf+A13SR5LffSLYuu2IelvYsIH6NRDrhXMgjBph0mq+oEkdvuCFIP8hF
	 I4j5cbwEu34/SOajdfzWGasktqN7rY8FfpkIbYRfZmRaTXS3iER8EL8hNya+c38fwDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SJGi5kR5;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D820606A320
	for <linux-crypto@vger.kernel.org>; Sun, 22 Nov 2026 11:39:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D820606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SJGi5kR5
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4bb5b8ef642so18825015e9.1
        for <linux-crypto@vger.kernel.org>; Sun, 22 Nov 2026 03:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795347577; x=1795952377; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WT4yKkDAmncDHMj/7AEWMzPC9QUnbfloQV8RtbZ7Cvs=;
        b=SJGi5kR5gOJlMddQg0H8jvHUJ/YDmXSJyBAoUsvGf9ERLCMk1DZbJoxZgo7MeuCryb
         U2c/xKvKUONOenSzX8QGJzGEogXU1iF4tqINWM1WjbOLY5jrZ4KlvzEzrKTWxSbwkcyF
         /WzbqToCYgtDVE9YYoldCE70ojo4AcNG9ZruXDWZO+TQNEWj+GmwkSMcrfYJx89SvMBt
         YT77CBL9lJWHnsT+kZAlYqyplQaqMi5gjvY2Y1ycNF0fiXkLEjQRs6uBU59XKt9TZMB0
         dj5ILAlpFM1eKfjzn8E+8LKGTQASc46B95Ov07/YttpSqn5jiSosV444TNQb+BvU5ZDl
         Y4SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795347577; x=1795952377;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WT4yKkDAmncDHMj/7AEWMzPC9QUnbfloQV8RtbZ7Cvs=;
        b=YyiPJE1bJJt/jXhU8VKQ+wulRfiO9sY0lepZedygGi9QmlNvsHvrJIyOsaIa2hVxsI
         2+cePYKMxyVB6UPZmqjBnxO4ECx1Dh6H/hH51DwTDAOvtKSCrERLQRiKaZf915yYzMPf
         aRERpTvugZsQCqpC0EX3JkCHW1syjmtM3/JA7DlcGWsMvWKtidGbUwrdeZs9eFCqET9G
         alrzbiMTbUk93wzMGtE6DRmegLJiRkiaunieh3PeYyTnn34+y2HcyzkFy0gzFG1wGdQD
         KDxm2abZ7QlvFNAS3J5hcDLZcJ47kGYlExOxOZ21U4L0bmvrdhrdp8xzbUkeiUkF94pt
         S4bA==
X-Gm-Message-State: APuU4Z8UEXlF2ma80/v9MaU5tiJH0rZ5DBGQBP6BEQ9lS9te8UVCJmY6
	EW7xJ54nqL7NwadXuOqdc5dgU9pOos/SVjNzKdsTVm6ZMiIZJ7ksTQ3D
X-Gm-Gg: AZFdTZcg1wkbDSTgxswQYtUngJDxKIivBRpTdRVJ1bnhDIHGNNexIFTQZAlM5JosKKL
	vZLATHmSt0XrmaSDWFmx1dxaE8ymL/2LNyZQbcj4U96Lw3gDcnHkTmUpkMNoqqszkhSp0Vbd8tK
	rLU+mX3RqLZWJN5LB2LLKhGms/2dP5Hx9ceRDq+Vi70skrV961dTcKWilPkPvPhgLK4yoVqAJ1z
	Rp3T4P9naMIKxwnj6Rqbn3uDXEBGDbnX/81plTT+sve1qV3FmZAVee5XQWS8Ym2d9u4rPSDonTl
	4NQQQiDZnZVWLEeWU+jTpZeh9IMfxEI75NztkMcYA/gmjOdywjmK6vRwXho8iwSSIaQcQwQy/XX
	B1JZHBQPh3HrzSWj6p2J8gKWlU61SKy3DQ4BkMRqVj08K3NHwva4O2ktf2wIEdFBdn5FY+NZiDa
	Y/nx6ra9/K91OZA4+aFHrttTlaOmXRXGffeOKvckskvzh0kQFuFeeJc2i/KYoUGXFLjRriZSwpD
	HsOA2KzL6Nce1HBHg/okZzE3FZr77rkI2FrsF43eAwmb1+nZjSabtxLFIh0n5AXHgO2eowmyu5G
	TRiLzTnIfRkBPalJWiPiQtq7YwCD64n1U2i7M2gZHK8Irz8pTqZBaI9Flx3pj7LMhw==
X-Received: by 2002:a05:600c:8b11:b0:4a1:dda8:eb73 with SMTP id 5b1f17b1804b1-4bb8881c630mr191892155e9.27.1795347576774;
        Sun, 22 Nov 2026 03:39:36 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853c9170sm310397175e9.14.2026.11.22.03.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 03:39:36 -0800 (PST)
Date: Sun, 22 Nov 2026 11:39:34 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A
 . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: x86/sha2: Drop one-off implementations for
 Sandy/Ivy Bridge
Message-ID: <20261122113934.48a9ac42@pumpkin>
In-Reply-To: <20261115080900.216434-1-ebiggers@kernel.org>
References: <20261115080900.216434-1-ebiggers@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 15 Nov 2026 00:09:00 -0800
Eric Biggers <ebiggers@kernel.org> wrote:

> [ This is proposed to supersede my patch
>   "lib/crypto: x86/sha512: Partially roll up sha512_transform_avx()"
>   which was starting to clean up one of the files being dropped. ]
>=20
> Currently, the kernel has SSSE3, AVX, and AVX2 implementations of each
> of SHA-256 and SHA-512.
>=20
> The AVX implementations of SHA-256 and SHA-512 run only on CPUs that
> have AVX but do *not* have AVX2.  These are all the ones I could find:
>=20
>     - Intel Sandy Bridge and Ivy Bridge
>     - AMD Bulldozer, Piledriver, Steamroller, Jaguar, and Puma
>     - Zhaoxin KX-5000 and KX-6000 (possibly SHA-512 only, as these CPUs
>       might be able to run the PHE optimized SHA-256 code)
>     - Maybe some oddly configured VMs
>=20
> Oddly enough, this "AVX" code doesn't actually have much to do with AVX.
> The only AVX capability it uses is support for 3-operand VEX-coded
> instructions, which is unlikely to make a huge difference.

Especially if they are the only VEX encoded instructions.
Switching back and forth is horribly expensive and the change isn't
'sticky' on some later Intel cpu and you get the 'hit' for every
instruction.
(kernel_fpu_begin() might need a vzeroupper to migitage this.)

>=20
> Its actual purpose is mostly unrelated to AVX: it replaces the 'ror'
> instruction with 'shld'.  This is entirely to work around a quirk
> specific to Sandy Bridge and Ivy Bridge where the 'ror' instruction was
> very slow for microarchitectural reasons, and 'shld' worked better.
>=20
> This is documented in the contemporaneous paper "Speeding up SHA-1,
> SHA-256 and SHA-512 on the 2nd Generation Intel Core Processors"
> (https://ieeexplore.ieee.org/document/6209073).  There, the 'shld'
> workaround was claimed to speed up SHA-256 and SHA-512 by about 20% on
> Sandy Bridge.
>=20
> However, that was a one-off quirk.  And even the paper itself warns
> about using the 'shld' approach on other microarchitectures.
>=20
> On AMD CPUs, and on Intel CPUs after Sandy and Ivy Bridge, the exact
> opposite applies: ror is a fast single-cycle and single =C2=B5op instruct=
ion,
> while shld is either a slow microcoded or multi-=C2=B5op instruction.
>=20
> From what I can find, this is true even on the older AMD CPUs mentioned
> above that run this code.  Thus this code has likely always been harmful
> on AMD.  (I don't have such a CPU available to test, but for what it's
> worth, on Zen 5 the AVX SHA-512 code is 58% as fast as the SSSE3 code.
> Clearly, the 'shld' hack can be quite slow on CPUs it wasn't meant for.)

I've got a bulldozer (or similar) I can run a test on.
I might just to a quick one for shld v ror.
I've rewritten my 'rep movs/stos' benchmark and plan to run it on the
older cpu I have.
(I need to get something newer than an i7-7 and older than a zen5.)

> We generally shouldn't be carrying asm files that are one-offs for
> single microarchitectures, as it's just not worth it.  This is
> especially true when the code has been mistakenly targeted to other CPUs
> on which it is likely harmful, and when it has other issues that would
> require maintenance, such as excessive loop unrolling and spilling the
> entire 640-byte SHA-512 message schedule to the stack.  (The SSSE3 code
> has the same issues, but it's easier to fix it in one place.)
>=20
> Therefore, let's drop sha256-avx-asm.S and sha512-avx-asm.S.
>=20
> The CPUs that could have run this code will instead run
> sha256-ssse3-asm.S and sha512-ssse3-asm.S.  SHA-256 and SHA-512 may get
> around 20% slower on Sandy and Ivy Bridge, but they likely get
> significantly faster on AMD CPUs from around the same time (2011-2014).
>=20
> Everything with AVX2 continues to run the newer code and is entirely
> unaffected by this cleanup.
>=20
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Seems reasonable to me.
I doubt anyone really cares - apart from benchmark data points.

David
