Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4B33B1ECC
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 15:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778599652; cv=none; b=eiBkJOzAaXGbrbbl0z9XtKoDT3VLxQ9vBEI5Kd5PqYg4MZuJNDUFlVe2aMq4tB4IJ878EQWd82o4NsYPi7UypaJYzFR1iflpfZStGcZr5Hj58qjEphDi3spx1bmGlzy85g2H2sdBC6ysuQlXxUGESZ538hPr4R5aGgZkQYsnApE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778599652; c=relaxed/simple;
	bh=FPazZEp6GA5Hmo+4/6qfbStOMmXopx//Q6AmtwPstsc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KITF8x2SdDvFBw1/4YFQn4V0m2tgVLBgGqxnpxOIrtn3MkOd/Ay7/UgzCdl8Dh71Il53+4t18HISD+8nH7gr3MsAkoy91OQD9wVl7fRAatPPWJ39dmPLT+rl5gs6y4ceeDMaUEB8T24NOzzZg5wpENAbGJhc0q9AzwkaZL6z7Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NbOawvG5; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NbOawvG5"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4891f625344so53204675e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 08:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778599650; x=1779204450; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NM+uE6jwM63o6mhwLABZspTdPrtPWxx1VtWOVwLXmwk=;
        b=NbOawvG5xmfWjJk3zuoZrpd5Ec0iMkdS/lEGY5R4nUUlXMzRRBVxXnA/gdWkaUSr2R
         Fv74iFQB0YRQKAkpcqjBJKj0ZiT/587A6Uzz+VvU8cm2OdOUaOQZSeT1czmglkZVJmbI
         +YBPdxMatdM45+s+xKLcezzw9fsX9xfusPu3ZGfcZLCYcZZqQ+ADmugNpSo5vp2Z2fpV
         sV5un/U5IEJS3d/pc8dXiwVKSgc7Z1eSOWXalgaVYga8P92EwkIPsqPSm+ZW+QqJ0hYg
         ctrTBos3WOeCBlbT0Kh9oARlj7flkQbPZsEwhclVzcHG7RuxnszIvsN8pzdjMZ0J1sqP
         mSmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778599650; x=1779204450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NM+uE6jwM63o6mhwLABZspTdPrtPWxx1VtWOVwLXmwk=;
        b=oB23apAgp0lV2iC+AeitfNIlOHWI4NqC6WVD4T6wxcFKxJSvMruzTja1FFbzAxgOmO
         22UUW3TS7lgJMw7J0psSn/gnlJ6/5IS5/r7Kwu1v6HneFekvuzo/bO1SNqsE8puQXGjh
         Vlx1OKnENdIkRVpSbVGskPvv38RlrZsnQ5RvzP/tVve4iqhbH4lopIfF6A/HzJfc3HL5
         a60U5FkCtXYa2z+6xlF1hzuPD6S9wNu1xOEhV/BDyMcQIGSyCikuwzyBsAS7nHCV2nDq
         ibFapFdDVUZxUwVCJ7UhXiQJmCKVt6KEYElVQISIP5GTn9Jo7dSei9Dnx9LrosLh7zFZ
         MbBQ==
X-Forwarded-Encrypted: i=1; AFNElJ+xk2v4o9JydBwkHZff0XXQSkbTLm7iTuzpFsSzGa7yaw9I6sFNuSY+art0zbzUC3HUfAY/JxPvHEaGXjM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgQkUZ43fHkMQlyh8SZDVpKSxyPkoTdHaIUcBleT5jRQYMUsrK
	ejaL3ZvFjPhYvwY8d8YA2WfL1A5tuaJFBAkLZwUHQJ7zAIioQuHQ982b
X-Gm-Gg: Acq92OErCYBrdD/FeRz0g8j7+n0gqkcBxxwUB4upsW/15LQHm5fGobyf7O+acIQbhwn
	FsRYhknzqGHZB6QUUcdf8X7qWpRtpHl6UNTV4aw7rdXZgYyBEZCjvjMYLFX+wrn/A+GbpEWzQR+
	LCRC85AUeBXDfh3WGOkbKeM83Mpz58z+kNrAZ+QUfVg+BTGo1KYmAugUPX386fn3+1I7Zme/oRL
	yY6e6BuROnZG6ktwty93jNqfcLC9sGs0/uVNXNk5zbxOT4cAbBNjriw0hD0a/vpcW/fn0CAuZn5
	QostXA4srslRjjXM0j1rm/DoaagSJuT3uG72ft46JtAwUZCdIKSBWSkJF6TyzFk5WyKhEiEaubW
	XbDlYM3b6wIsqemzqCrFUt3Lykult4lskGRtYschkuRp7Iwa0mYCTSW9Uky5ZbaNCAFibe/HZKK
	KM0LseqsP8/SlDYWlgdXpWvXzcwGlMWQE4jZfnR4SuOmI3pAv0RhZ+ty8mQxT9
X-Received: by 2002:a05:600c:3488:b0:488:aa33:dc8f with SMTP id 5b1f17b1804b1-48e8decf95amr61589075e9.0.1778599649462;
        Tue, 12 May 2026 08:27:29 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fc8cccf90sm5334695e9.0.2026.05.12.08.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 08:27:29 -0700 (PDT)
Date: Tue, 12 May 2026 16:27:26 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Lukas Wunner <lukas@wunner.de>
Cc: Anastasia Tishchenko <sv3iry@gmail.com>, Ignat Korchagin
 <ignat@linux.win>, Stefan Berger <stefanb@linux.ibm.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto : ecc - Fix carry overflow in vli multiplication
Message-ID: <20260512162726.5a7a1b52@pumpkin>
In-Reply-To: <agMvm_bA-OcDWhbc@wunner.de>
References: <20260508114844.29694-1-sv3iry@gmail.com>
	<agMvm_bA-OcDWhbc@wunner.de>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 12 May 2026 15:48:11 +0200
Lukas Wunner <lukas@wunner.de> wrote:

> On Fri, May 08, 2026 at 02:48:44PM +0300, Anastasia Tishchenko wrote:
> > The carry flag calculation fails when r01.m_high is saturated
> > (0xFFFFFFFFFFFFFFFF) and addition of lower bits overflows.
> >=20
> > The condition (r01.m_high < product.m_high) doesn't handle the case
> > where r01.m_high =3D=3D product.m_high and an additional carry exists
> > from lower-bit overflow.
> >=20
> > Add proper handling for this boundary by accounting for the carry
> > from the lower addition. =20
> [...]
> > +++ b/crypto/ecc.c
> > @@ -427,7 +427,10 @@ static void vli_mult(u64 *result, const u64 *left,=
 const u64 *right,
> >  			product =3D mul_64_64(left[i], right[k - i]);
> > =20
> >  			r01 =3D add_128_128(r01, product);
> > -			r2 +=3D (r01.m_high < product.m_high);
> > +			if (r01.m_high !=3D product.m_high)
> > +				r2 +=3D (r01.m_high < product.m_high);
> > +			else
> > +				r2 +=3D (r01.m_low < product.m_low);
> >  		}
> > =20
> >  		result[k] =3D r01.m_low; =20
>=20
> ICYMI, sashiko's AI-generated review alleges that the if-else condition
> may cause a timing side channel vis-=C3=A0-vis binary arithmetic:
>=20
> https://sashiko.dev/#/patchset/20260508114844.29694-1-sv3iry%40gmail.com
>=20
> You may want to address this if/when respinning your patch.  If you do,
> a code comment is probably merited to explain this subtlety.

Something like:=09
	r2 +=3D (r01.m_high < product.m_high);
	r2 +=3D (r01.m_high =3D=3D product.m_high) & (r01.m_low < product.m_low);
would be constant time - but the compiler is very unlikely to generate
the object code you want on all (any?) architectures.

On x86 you want something like (pardon the pigeon assembler):
	xor %rax,%rax
	cmp r01.m_high, product.m_high
	setc %al
	lea r2, (r2, %rax)
	sete %al
	cmp r01.m_low, product.m_low
	cmovnc %al, %ah
	add r2, %rax
but I bet (two beers) you can't get it.

-- David

>=20
> Thanks,
>=20
> Lukas
>=20

