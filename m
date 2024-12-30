Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24BF199938;
	Mon, 30 Dec 2024 11:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735556782; cv=none; b=NC95TqOk3NE95V9Rynz3zlAKqK7FudHoWSu/sjrAv+q0URP0bejttOOtwEYSvESabNHmrZiZB2Ljpi58WquepFs0UDZPBmFwq/bL6NXw5inOm9rqUt6wckzkczufB6gepYH4e6lYxX/qByV8ZyTU0GzbRnIYyTjOx36TYtXdTGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735556782; c=relaxed/simple;
	bh=2iYIv18ijKDUGv8uh1C/MZk9A091ijfJE+ocxhBXBQM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NbUkWQlvX0i6QQImNivG56C3TGEX6KMLiRZR0HXgb8/n2XOlLqX+4s0x9Eme3advpB17F11ffoKEhkMpMHFFrkHsg/iWGNOiit0FcoZezWllJYLSgIjmK+R8Xx/QwB1xP2y2Hm8ZQiVKqpYi/8T/TTRgSYmaaEMvVxARk3nEHSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-85b83479f45so1351241241.0;
        Mon, 30 Dec 2024 03:06:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735556779; x=1736161579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MhPIHJhGTX+chh8YZp28/f3C2Jc7bJFpH5IbxnbICL0=;
        b=KkYXWZau0q2gV43YY2l40vp9k2Z/AmGZFwgoWY5TJ3WPKWzx43x7yOaR+C8H9LFahF
         xi+RxpHzLttzn814JYf+/31ZoCpIhOT+cP/2KNqEJ29QLbePsAxeEZHdigN/yAOzZRnH
         k9kgMF0wxAaW169wI+zSxRjo03Hltjwzv4msuf+tlqCvZRO+B2kOLfdJi0YErmGtV/X+
         EpOjMePoga+xOg9EUMMte161XLxhh48o7lxqZQsQhahojhADHd3FPStvgYixkeWnmKbl
         C8ll/VhJ0j++XJUrwrcSIWaLFh048G4k3/u8ICEwO2iOGBRuBXqa4mesJaVBlxbFvIZ2
         DhPw==
X-Forwarded-Encrypted: i=1; AJvYcCV/KB82YmR7F+wKKXj+sipBw+VF6IW0lLRw0rPSJ8efXlqPmK5bkgiEa0mrFrAQQwA9EOwQwgaYwhIdJJs=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu8FMBj/YhDLAqVqehJCeLzHa3sfGjS47Q2Sh/4mo80NFDg1JC
	0wMUsDsg7IpqkZ++ZY/O2fc59tveoHx5N3uHKNZiplfnDpvX9gG6YAwUu13u
X-Gm-Gg: ASbGncsKqYoPMHTtyL6RagesEmEBgOx7MSNVHCdRloBa8c1UOrPGX/DgcZy44TWsoxc
	chkq+Ut6dssUVKDX6yAxIQmmCJ3o7iR5Kte2AlFocNRjatlDVk9UlDSm4R+hJbw7N+pBT78vvfU
	kU2ZgfFjcI+hJjLGlgYs7TGDOOCx7cLusBxRffk+kQZ5auLssuTslyJyFZKnB7XPWi1rGyVX1Wt
	kY3sOSX/NYwObwLscZylErJM7ad14npej7l53bEMWY3SXKQ1AdLU2v5DLr6/EJ/EWgwn8p0eXI3
	WCAlf4t1LnyLYz/7Y8Q=
X-Google-Smtp-Source: AGHT+IFhO8vfiesUaDYAA4tdrD9D2mMVEpj/DqKcTpAgz6xGSJ42px1nvh+ot/gzFcZ8mVNcOGA/Ow==
X-Received: by 2002:a05:6102:3ed4:b0:4af:a98a:bd67 with SMTP id ada2fe7eead31-4b2cc313aaamr30271853137.3.1735556779116;
        Mon, 30 Dec 2024 03:06:19 -0800 (PST)
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com. [209.85.222.41])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-8610ac6bfc9sm3983290241.16.2024.12.30.03.06.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2024 03:06:18 -0800 (PST)
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-85c48f5e2c1so1088023241.3;
        Mon, 30 Dec 2024 03:06:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXokpkln/KMqF4GmjnbOMCZaACGSwHISaQQCTAxFeJLkXcU0aOU94lCNeORRYwOWh7hQBm3D2v5OmhFTCA=@vger.kernel.org
X-Received: by 2002:a05:6102:3a0b:b0:4b1:2894:1048 with SMTP id
 ada2fe7eead31-4b2cc351e2bmr28021284137.10.1735556778682; Mon, 30 Dec 2024
 03:06:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241227220802.92550-1-ebiggers@kernel.org>
In-Reply-To: <20241227220802.92550-1-ebiggers@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 30 Dec 2024 12:06:07 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWMCqXzDOKfywKaYvsz60zsdt6OTeUJGZNLotDb017FXA@mail.gmail.com>
Message-ID: <CAMuHMdWMCqXzDOKfywKaYvsz60zsdt6OTeUJGZNLotDb017FXA@mail.gmail.com>
Subject: Re: [PATCH] crypto: keywrap - remove unused keywrap algorithm
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stephan Mueller <smueller@chronox.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 27, 2024 at 11:10=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> The keywrap (kw) algorithm has no in-tree user.  It has never had an
> in-tree user, and the patch that added it provided no justification for
> its inclusion.  Even use of it via AF_ALG is impossible, as it uses a
> weird calling convention where part of the ciphertext is returned via
> the IV buffer, which is not returned to userspace in AF_ALG.
>
> It's also unclear whether any new code in the kernel that does key
> wrapping would actually use this algorithm.  It is controversial in the
> cryptographic community due to having no clearly stated security goal,
> no security proof, poor performance, and only a 64-bit auth tag.  Later
> work (https://eprint.iacr.org/2006/221) suggested that the goal is
> deterministic authenticated encryption.  But there are now more modern
> algorithms for this, and this is not the same as key wrapping, for which
> a regular AEAD such as AES-GCM usually can be (and is) used instead.
>
> Therefore, remove this unused code.
>
> There were several special cases for this algorithm in the self-tests,
> due to its weird calling convention.  Remove those too.
>
> Cc: Stephan Mueller <smueller@chronox.de>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

>  arch/m68k/configs/amiga_defconfig          |   1 -
>  arch/m68k/configs/apollo_defconfig         |   1 -
>  arch/m68k/configs/atari_defconfig          |   1 -
>  arch/m68k/configs/bvme6000_defconfig       |   1 -
>  arch/m68k/configs/hp300_defconfig          |   1 -
>  arch/m68k/configs/mac_defconfig            |   1 -
>  arch/m68k/configs/multi_defconfig          |   1 -
>  arch/m68k/configs/mvme147_defconfig        |   1 -
>  arch/m68k/configs/mvme16x_defconfig        |   1 -
>  arch/m68k/configs/q40_defconfig            |   1 -
>  arch/m68k/configs/sun3_defconfig           |   1 -
>  arch/m68k/configs/sun3x_defconfig          |   1 -

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
