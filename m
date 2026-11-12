Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794501902;
	b=bwQt853k72mAyQkcEz5/Lk9WOYNpLHpTPGa2IEm9KAEjnA3AA71QvNxjdWqYYOv6cBxO
	 30aC+t555eGauWwcm3ECCxeq3OGRl+mT7tyzm1b6zi2lf7Bc0iVzVo2Ku3u8XVIa4Sdr4
	 oKA9YfOj7blSFtZ6EW0Qdf2Nbj0bujrwB9yBIjAwic2m5RIcCGC91op38k3iaP1LkCxq8
	 vuHVMUKqH2bfjQcWu/hOQB79A62deoonrSaCHXp8PD0np/sv3GE1iejTWlzzJEibpXL+B
	 PVhwFe3tkvP3DPzzJYeSpUqC67WLQTg5kA8Q0/R/+7VrVVD4JSe+l2MHeX+qNnvO34Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794501902;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=8aQvohkJadEw6IMbc6hGb2fWlHEzcIWW9oqIwMeWmos=;
	b=noOOF5HIgHs9z5sT4MvYAxCPsTWfBbkvD24pnkDkj+gKT2c1ZADOPBffFqipLasvreqP
	 Qm1FEyNtXYWoQncWBOIltWXcOS7XrufgPvk5D8+nOngBI0qGUTF+2+yJOh5IKQerBf5Pj
	 SqVRhl/qq6GbvBKE2+EWpm4y1zHVBP9jDdYNB2QataKtOZBVRwRGzl6NOXlIvva5wyMOU
	 PGuq+xuiEDemmS6IZPIqJkuGEI4Pki3mVB138jhblxEfzptFivWAgk/m1QCldslxqBjM3
	 D/HLXvMnK9tJslxuqSYI1yPPFFNIB9alLmi/uiR/vzLp8OZ1DEZ8I/hSzkLkeXE5Vag==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zx2c4.com;
	spf=pass smtp.mailfrom=zx2c4.com;
	dkim=pass header.d=zx2c4.com header.i=@zx2c4.com header.a=rsa-sha256 header.s=20261015.g header.b=cUkBWRES;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CD3606A321
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 16:45:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3CD3606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=zx2c4.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zx2c4.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=zx2c4.com header.i=@zx2c4.com header.a=rsa-sha256 header.s=20261015.g header.b=cUkBWRES
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c4d58c50743so476090366b.1
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 08:45:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794501900; cv=none;
        d=google.com; s=arc-20260327;
        b=azJP9XMx2/9K/79gmJiiG87Z8OFIdmP8mmfdXs+i7tY73k4pFTEXTdy7q2Pk99rSYd
         l2UHQJHbR08iTFNYoBWZFJoVrFWNhZcDYQG6H6cY2I6PQXdyioJTMNcBOpxnlnHx5fy9
         IqtuSi6d5fR2CEKpWiYwVamz/bFhqwwZ0zHqXZXd/XWjpV5EAEGB86PNuTDnqi9PBTvy
         stMJmHYbqnaiiYNArM1OCnN3mjHMO4HrydmO/k8GpnR+o9VcApEjfsrqKvwcwwKW/ib4
         +zqCPf9whZawLbl/B/p1a059mUY+BLyRskUdUmNA9TnbtbPixqtk4XliQ/RyxVjnx0ax
         5qLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8aQvohkJadEw6IMbc6hGb2fWlHEzcIWW9oqIwMeWmos=;
        fh=BBr/Lqk0R+3525obsNuUTqR8MoH66E6dZyKVihDS6y4=;
        b=rA6RpUunNflz0B6kCK6AT9mX9oJM1v9LkzROW8lWjLfHYZV5XNzBUPqUJ9NVyEYOYS
         Fx8xofvMXDRxJRpfjf+6glp46GZUK/PNAovurLT0k/OjSthe5AkaWzVQigSuAzcBBDWf
         jITu0ByIY1BiDnqM/WoqD9f+BmfdEWoRR6E06+xW67QKZ+Q/XO3XNddMIoQ+EJ2mMvl8
         z9VdATbkM7KbSNkO8afzB6ibKMutE2Eh01Wqo73pY0QuUwTeo2U2AfAaaWgAxGgaNUfq
         VvYDRVFd/yawFydADxhPJ/Js7b/Hk+J1imajiJyOU+EClevngPxs0tsDg5THa04JmFOU
         faOA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zx2c4.com; s=20261015.g; t=1794501900; x=1795106700; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8aQvohkJadEw6IMbc6hGb2fWlHEzcIWW9oqIwMeWmos=;
        b=cUkBWRESqda9Tr++34ybMC47OvLCem7HXfoECMUruW9MWko2zVysiwoqS00BXX6Y+P
         mPlmoVvlbhcxSlUCC1KF47xvU6lydyRBjI4Dztn2X06VVGuLDDqGqtK0CU1yXZXdaOjk
         p2QB5DNlBNmj0AbQX71ejmzhXEW1/bA/2O50xONS82nmR8EJJy9zVslp79mXTqSQRtP3
         rbGEtZx9MmHGdP/wgXuEoosrwWfpuPz0+tjScAgs4j6uu1WCecEktRtUh+mgSeuGHgdP
         woJyd+r83lYycw6SC+8XHH/uIcqE7AyWim7yTIB5QRGX+2iBDOIFOjDPf84FG3vTPf4T
         3wyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794501900; x=1795106700;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8aQvohkJadEw6IMbc6hGb2fWlHEzcIWW9oqIwMeWmos=;
        b=in7EldZVkB5Vi1unb2q5CzyfGTEEtTkA6j5MdXbvTMVhZ4RZ7QRyF0xdXZYeujaLEI
         EOaIfM8hzgv3xCxY+QbO33t+GJpj6B+OMM4dKrJxD+o7orXiqoHNT+FiOfqLFpeL2xHO
         Tj4cy/IxjaOw/exbShInzAeeSBzdhNMyc+Ys+2ex1i6hYKwIk+IwPq9GQYzbWE+oMd9Z
         YwCdvPVo+pRnznZuZ2MzqOJ6ydrTlEwv3gT2CyoyvzgZkitQw8mSE80sRcRM2nf97N48
         0nbacvzWUpoCRDX0yOgJSi/+GYnsEP4KfU38Qd4EpdSvR8LDxuB9QyFPvz5+kONbdPEa
         /bEw==
X-Forwarded-Encrypted: i=1; AL+hErGxrAw02KsSG92sNjYi4REx0cR/IP3tv1vVd/3setO58UY87LALXXv3UnZ+va9Ll34D0BtVJQV+Vg5ABc0=@vger.kernel.org
X-Gm-Message-State: APuU4Z+J5ZrDzgF+wnFr5O3/DtGbROCASLHTDU3uTP8irjnTKzxE9BvF
	pUBrQnSVv4iUHsICKmdhPafV+eUJXm+sgKeockzImUbbT2hMcLOKHdUSob291Dkgqprztd+DM2w
	ceSmDqDzzSmATf1k0l57bTWUdaYRTaCryB1KUdxn/qj74/dQ8fB20KN6+JZw=
X-Gm-Gg: AYBFou0Q07f3Qx2ZWjfaXymPbHMCOYXJ+slmVSIQglV3NgkKgor5nl7AB3hAZdRAPRq
	QHfC/pVJlVbbZ7IlZnBk8I+fnTgRwvtISaWdxl7AgTLd4nDUdGcdmDmkZE5VtJyMJ/gU/dbsMbL
	0CRx+TrVDyZjOgF9x6ZfCBml/ernyR7oX/NNm55Sze42HHvLHXRyxiavdvdcc/kHxk8ohpxpFGq
	YOaqKGPU8m6Hn2PQyJmmQUE7zeusKPJpT7BPDFBz4TRxAIoN07cqBG4g15xsq1dWzN0yT9E4xqn
	d9R10MluJA6i4Jao0sKdvIsVX6gwmHGaOP7Fu30+w395SYZtpCNeTrE7U5EIymYbl564uoEJFSC
	gwWwgnEoNcf9XrLqUwY3OqieOQNoiQUx9nE3SJhNZ9armLMURBnLEUx6NnlnVYBQwW2hsKtNbJn
	DxffDYFLR1yHUMSfrhzew5teU3MtrjGw5lZDqIEuiSy4z0M96CqQ==
X-Received: by 2002:a17:906:c10b:b0:c38:ee33:2931 with SMTP id
 a640c23a62f3a-c5066ce850cmr498197366b.37.1794501899705; Thu, 12 Nov 2026
 08:44:59 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112125432.3064939-1-antonio@openvpn.net> <1906b5ed-7650-484c-9eb0-a99c8e27c943@app.fastmail.com>
In-Reply-To: <1906b5ed-7650-484c-9eb0-a99c8e27c943@app.fastmail.com>
From: "Jason A. Donenfeld" <jason@zx2c4.com>
Date: Thu, 12 Nov 2026 17:44:47 +0100
X-Gm-Features: AclHuK9_Vfi1koQLi63-pyXx_SJHPERnevDsknEyXeUNfUTFttrORi09nSkRNWw
Message-ID: <CAHmME9qSPWDhrvoQH=QX2hj+Ei7mcTYFqy-M+kMnJhgzRuJ1dQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] lib/crypto: Add AEGIS-128X4
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Antonio Quartulli <antonio@openvpn.net>, linux-crypto@vger.kernel.org, 
	Antonio Quartulli <antonio@mandelbit.com>, Eric Biggers <ebiggers@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2026 at 5:20=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> wr=
ote:
> > This series adds AEGIS-128X4, the 4-way parallel variant of AEGIS-128L
> > specified in RFC 10032 (Informational, September 2026), as a crypto
> > library with an x86_64 VAES-AVX512 implementation, a KUnit test suite
> > and benchmark, and a crypto API wrapper.
> >
> > AEGIS-128X4 runs four AEGIS-128L instances, one per 128-bit lane of a
> > 512-bit vector, so that each state update is eight VAESENC instructions
> > on zmm registers.  On CPUs with VAES and AVX-512 it is very fast even f=
or
> > short messages, which is what makes it attractive for network protocols=
.
> >
> > The intended user is ovpn, the OpenVPN data channel offload driver. In
> > single-stream ovpn tests over a 100 Gbit/s link, with both ciphers used
> > through the crypto API, the sending CPU spent 1266 cycles per packet wi=
th
> > AEGIS-128X4 against 1448 with AES-GCM over TCP, and 1032 against 1122
> > with UDP GSO input. It is posted as an RFC because ovpn can't use it
> > yet.
> >
>
> We used to have implementations of aegis128l and aegis256 in the kernel a=
s
> well (along with morus), but we removed them on the basis that it was
> aegis128 that won the competition.
>
> As far as I know, nobody actually uses any of that code, though, so I am
> quite to surprised to see now that it was aegis128 that was dropped
> from the portfolio, and aegis128l and aegis256 have made a miraculous
> return, along with some other variants that appear to be tied to the
> register width. What happens when 8-way vector registers become
> commonplace? Create yet another aegis variant that case use them
> efficiently?
>
> So I'm struggling to see why we should take this RFC seriously, to be
> honest ...

I'm also not really sure what's going on. CAESAR competition selected
aegis128 and listed 128l and 256 as "additional finalists". And then
RFC10032 has written up 128L, 256, 128X, 256X, but not the original
128 that was selected. And then none of this has been picked up by
NIST. Meanwhile, NIST's light weight crypto competition selected
ASCON, which as the "lightweight" as opposed to "high performance"
pick in CAESAR. So I dunno! I've been waiting for the dust to settle
for a little bit.
