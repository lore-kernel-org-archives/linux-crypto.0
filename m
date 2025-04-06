Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4071C4A20;
	Sun,  6 Apr 2025 15:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743954279; cv=none; b=m1gczhwzNGC8a9ZDGDrfC5lchodmamfR9tBq6SKjetOlgZImBqsqgVQTy6Y2whaHFIO+SksxEeeKv8n82UbJZwcApuZMbTDQgHLwizjpb+ER4auZy+KbjR6vH+zbep1sNganTj++L6QEDfM/8L9VEXF4Xmvag6eGlvMdhClRe9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743954279; c=relaxed/simple;
	bh=mRuyL15+qfLzMNbTcIm5SD/CsOWjFFN4b1YWiNAxILM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=excJLIoBNG4dkOmPK/03T+J30suucl9EkUQ8EUp5bH1cwf/k3ZOchtJ5PuE6J8xOKWX4uJ9Czi7kkYyJ32n2WAb1t7bKDJWvnMTbRwWO2PXxakA/x/Yg8YBXCDaQxI2z2Ktp41pOEN7HmeeEBL0pwR9g/FIrniQ84MFvfkvWBN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i9J/9bKe; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i9J/9bKe"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-54af20849adso3483363e87.1;
        Sun, 06 Apr 2025 08:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743954276; x=1744559076; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mRuyL15+qfLzMNbTcIm5SD/CsOWjFFN4b1YWiNAxILM=;
        b=i9J/9bKe1WzgUejOYGUBjovCWgGkQ0AMNgkeEvAdfFJ1qr/h5EBFzv6uLInFaiEhI2
         J3IYMHwnTzxnRjAp6kWRy2TTHqX8q4TwggV5b1AUxelIogvR+Q9pBoNeiBlN/d4tw2xR
         Uq23ScMMh++B9RPUoJEutpXMHlHjnmzI0efdXC82DaR3WFHFnhlSSdAPTlM/dUZlFjw/
         TT0l9KJF35L8O4Np+dnTY9D98NJG+IZs+VSNeTq0jxviLnTdhx28dRnPXSeGmvqc7MFR
         Ag2QPX0Z0Pr0As7wPKNHXZSYSdNuzpZZAQRBQ/s+tlWymXm3zYFa+L5hdDNfc7XDwWnr
         6m3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743954276; x=1744559076;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mRuyL15+qfLzMNbTcIm5SD/CsOWjFFN4b1YWiNAxILM=;
        b=LgBZUydihFxyKJZobslcDCe+bBmgPsOJ4bbCscOUPCXF7kLQmsgRi5abuI31wXsUd9
         Rnx9m4heALytX6Q69cKCM2l4SkiBJmbJSU3D3gyQR/HqOUlL13uyy/rAMnA3kJ0jfILQ
         8+VrT4cqQZ3VDYlAsqEp9CUY+uliV4ylMz3z5O4w79B3mZEzWCDMUdx557yvgHTWZjK/
         WT7QBu0YCE8tWGdKU/eid7/hDnPew+H+eJilBz/Ma7a5NHtx/8pwANeTobL9ifaqQNEX
         kzZ6sU/Saone4mWj0A0JKHJH3cVsT3PCz6ur3cykx1l74taWy+JI3DwDGeibSwIdoFvL
         eJvA==
X-Forwarded-Encrypted: i=1; AJvYcCUSv5hX4aZ3RsjEcGUNypQdqAXvwifipfBYATfvUJcjQoJRmx4t41hs8qhPpj+CSEu7TXV0JTFi6eJWfFc=@vger.kernel.org, AJvYcCUbIP9InziR8AMl9bQFffuaBtE+AYFKZ8DjYNWcXHbIeg4JaUVD+1BBnKJ2HxpkWusFGkd5ngZ49M1qaQ==@vger.kernel.org, AJvYcCVWKNAUJnniNDGMEUp/7pFqGN73x1JOHjI4PwzCyyRi5/Md56tHcwldvrzgLbmIAGZAT5r9uozjOhkrviij@vger.kernel.org
X-Gm-Message-State: AOJu0Ywvk5AZJAL8rychwXr1yhAgx8fVBOEMbeX64DYJPCNnfSyvc+lP
	o3NhHP932W5s5cDNh2VwyPMp3gANXU4rl5t8zFIPyp4ucY0V+PrqoB7Wo/2mUtrU5rfJB5l82Gy
	AiG18Kw8I3HUtIjwf/tTOBSPRlH4=
X-Gm-Gg: ASbGnctCR7qDPPgoJ8SLKvVjRCjb4JorzBiR3Mw3T3cLk6oQ4SRcXu3BEY8YOLSQ4H4
	NNJX8VYXPv3nwpuR3raUYZkBwkwsRg7TW2X6yHpaANN5ECO+kkGWb6bcawBjbZs2zt1NvXO6Jux
	FPA/GYGpGZ4UCwihcc+WrRWxHhrw==
X-Google-Smtp-Source: AGHT+IFceSaAdyYufyeFbKbAvYTBtafKZvM8ofa1LVQWsEdrtJ87b3IMaK2a0PxNrLdT6TA2TJUO+eBJ49WTTNpdwjA=
X-Received: by 2002:a05:6512:2c06:b0:549:5dcf:a5b with SMTP id
 2adb3069b0e04-54c1ca56dcamr4757493e87.4.1743954275907; Sun, 06 Apr 2025
 08:44:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250403094527.349526-3-ubizjak@gmail.com> <202504040855.mr885Pz1-lkp@intel.com>
 <20250404015112.GA96368@sol.localdomain> <CAFULd4YrG-7DCXabke+uuLwLw2azciogG1nPGeAkMxLACw+0og@mail.gmail.com>
 <20250404190923.GB1622@sol.localdomain> <Z_CH8RAVeqTlPrDO@gondor.apana.org.au>
In-Reply-To: <Z_CH8RAVeqTlPrDO@gondor.apana.org.au>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Sun, 6 Apr 2025 17:44:24 +0200
X-Gm-Features: ATxdqUF4kX8kmgSXt_iaa2Q_MvGc0jI9rBv_l_3wHOV_WU6e8tFbrz1LjdqD1wI
Message-ID: <CAFULd4b838N-tkDH3Yiv4W1Jtee+wd1Ypgs6OC6o5PtnsVaFpg@mail.gmail.com>
Subject: Re: [PATCH 3/3] crypto: x86 - Remove CONFIG_AS_AVX512
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org, 
	kernel test robot <lkp@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	oe-kbuild-all@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 5, 2025 at 3:32=E2=80=AFAM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:
>
> On Fri, Apr 04, 2025 at 12:09:23PM -0700, Eric Biggers wrote:
> >
> > $ ./scripts/get_maintainer.pl lib/raid6/avx512.c
> > linux-kernel@vger.kernel.org (open list)
> >
> > Whee, more unmaintained code...
>
> I think it's maintained as a part of the software RAID code:

Thanks, let me repost the raid6 specific patch to listed addresses.

Uros.
