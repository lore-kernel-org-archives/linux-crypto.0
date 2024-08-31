Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D2A61FEB;
	Sat, 31 Aug 2024 07:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725088227; cv=none; b=H5px5Yar7Mhf2aOdz2SMsVtkJLlrEx66iw6ujG/szqSa1damNHUMwBJLYxz0nuDOkxQctC5JrwAcFB2di5NAa35hvjkKaK8ttrItTgsE+5IEU5rHVcA9lrIij9gf14f+KpEY/cIsFLoVo0RN0o2MHa0M+wPQqe4u5UwFSMd0hrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725088227; c=relaxed/simple;
	bh=JjmuznDsgL52e51ZMss8VK+Jg3V0DNmIcxtvDJAE104=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CVU7YVPwm6BmoEfSL0iA3AtRnvQ3d5ciAzzdkm3+sB/fuH4swH8a8WtU7UYcyn/cSRcxuxY3lTQrvHKltNF2ymtP4unJsEmlcD3FxkTe3z3gD76CH8Fgq86qKR96bgk+lx6ycVmaS6fCBkY4bMDUYklkygBXyHe2zVKJbpo4KEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dnvY+bde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dnvY+bde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3BEC4AF09;
	Sat, 31 Aug 2024 07:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725088227;
	bh=JjmuznDsgL52e51ZMss8VK+Jg3V0DNmIcxtvDJAE104=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dnvY+bdeOThEAt8vJjfUNKFpVui//2ogsCfeJgzkfuTXy1KaDBVmqpRn3nulkISxp
	 H5s1XdAr+WhZEtXiNPZuh+z87yCl3gyrEcaq5CPrY+KcouJhph+DLQFx1MsQ8dpqjB
	 GjeYEGUCkGBU1YDYmLy4utIZcHOoygh8ETE450wnKMYpklAn9GnFyLWrsmwBoP3buG
	 TivZF5LVQ1cECcXT646exuscZvmwhhsyXIu9wG9ihzwL55gMStZi0g+Xfwwu1Vt1ky
	 VlNpgG12pa78H9vJs5GEmsw0dKb5k/FQlQmAapargxWdYdAdQYTEsjciv3Y6MWzEVa
	 HPNU7B0UJAR7Q==
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2f43de7ad5eso32953481fa.1;
        Sat, 31 Aug 2024 00:10:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUJBMcAdj8mWotlmdLRpSCZN30lxoy8Oxmbs/bcs3+BGBajVgaFlhmYpzmMUvztOAJGB6q5aIhiNarV68E=@vger.kernel.org, AJvYcCVoyMDDF/zyBXJ8Dk+P6XxfhEM23dcwDMPMGbPf1ckZXPGFW8k+hqi4MZ0k+oi+1fkbzrRFCtFpXJ8haudS@vger.kernel.org
X-Gm-Message-State: AOJu0Ywj/E4cU+7e+h7mYQS4gle2I7uDrpZSETX6k7v/xUZAwwrjnuNo
	tDeXRg+1xJjh+ohHx3hTCIMZO8vDH2cX1pQrX4BA3tEsQLv7XiULb1xOZQTsszxW5ylK0WhoAkg
	4nfkDS3Td40wFydGkk7D5E8Cm6+A=
X-Google-Smtp-Source: AGHT+IHOolkMi+PHAJrfZLN0alPGdMCvNkKTYn1f+XXjL63ayviJWKcdcbSLPF1Bu+z94gxKxnYhIveaJpt4x4304t0=
X-Received: by 2002:a2e:a987:0:b0:2f3:ed84:9e66 with SMTP id
 38308e7fff4ca-2f626564f6fmr10851961fa.13.1725088225701; Sat, 31 Aug 2024
 00:10:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240829125656.19017-1-xry111@xry111.site> <CAAhV-H5Srpno_m+_dPS=Z-sdRrdXS3xEoG8tEaAB=8QqswTK9w@mail.gmail.com>
 <1bd7a61241f09331d27d8ad0df04726941c45f85.camel@xry111.site>
In-Reply-To: <1bd7a61241f09331d27d8ad0df04726941c45f85.camel@xry111.site>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 31 Aug 2024 15:10:13 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6es9x3rA5ZeSMjqYLQsTU3h-_QOa2siA770pY7Ju8rRw@mail.gmail.com>
Message-ID: <CAAhV-H6es9x3rA5ZeSMjqYLQsTU3h-_QOa2siA770pY7Ju8rRw@mail.gmail.com>
Subject: Re: [PATCH v5] LoongArch: vDSO: Wire up getrandom() vDSO implementation
To: Xi Ruoyao <xry111@xry111.site>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, WANG Xuerui <kernel@xen0n.name>, linux-crypto@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jinyang He <hejinyang@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, 
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 31, 2024 at 2:40=E2=80=AFPM Xi Ruoyao <xry111@xry111.site> wrot=
e:
>
> On Thu, 2024-08-29 at 21:18 +0800, Huacai Chen wrote:
> > > -obj-vdso-y :=3D elf.o vgetcpu.o vgettimeofday.o sigreturn.o
> > > +obj-vdso-y :=3D elf.o vgetcpu.o vgettimeofday.o sigreturn.o vgetrand=
om.o \
> > > +              vgetrandom-chacha.o
>
> Huacai: do you prefer to remove this line break as well, or Makefile
> still has a line width limit?
Also no limit, but Makefile is more or less different because there is
no "statement" and doesn't affect our understanding.

So, line break is fine here (but for my own preference I like to keep
sigreturn.o at last).

Huacai

>
> --
> Xi Ruoyao <xry111@xry111.site>
> School of Aerospace Science and Technology, Xidian University
