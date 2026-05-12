Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA64526ED46
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 21:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778620737; cv=none; b=L+a2CPOLjEOrdr4bRBslCIXSn91m20F4dNLZIFSKX9FfUreOa4LIjMeb7rsIu96kIqpl130Ol4/2Ljc704OMbbPwwRUWypbvvcf85NQiQwuxfy/LTbXipU+WP4pWo/LbxVS7257nbDqW65DWgakolFokq8VWsKk1uLqHupCOFsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778620737; c=relaxed/simple;
	bh=ZF+m+ZjVtnGgRZxs8fykE/7UK37XkDux4yfRZUGOw5Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EoQR3iJ+3T8gg+6Fiz0Qow22mn/bKi593aeem1/Ph29SC/5IWY6dKQKSJuiGNnbtZqOzEGro6HfDo43QFT63CVoEjuVwCqjFPTDRqE+z+atPI0qZPthYr5mdnp3IyjcOeU8DPC3vdou57QMMJ8Uqqv5+tU0smRw1f1txfw4jbPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-bd24f466598so272302266b.3
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 14:18:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778620734; x=1779225534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ULDGSLAty8SEh/aPzQ3wMjjybANkPqfntQTcejrtbks=;
        b=AH3QeYChz9Vr16/LLbVB2odZE2SMvuLehcDQVANLul4IJ6Iw6+D8cqEDcYO8Sl/0hY
         nuEIfds9AUNmzy2zREY6NTenQ9mQTxWRBsEG3/0rKnyDjKCocqVxDyqwnfBXTIjKjtXW
         pnk4M7Ku5LWqfkEEfHlbc36hCHacJpA3VMiby7dcfeoep4yUVDyvSEnuU/4EhzQ3J9lO
         IYDi65LgFBjOruQDHdXJsI2a+ME6bMoYZURUBi36696OtZEB2ppTBsoDTv7g69zfSDig
         nZmsIrEKyqg1TyPSPI+42ibucLkxgaZdJ0gCC0qq3rOzvYFJGtFDgzvv7tdGWPolygaF
         o3Lw==
X-Forwarded-Encrypted: i=1; AFNElJ9GawGyWcwAMHuoDeu257kwcnjGBd8zNtz/kxC5bZ+dIBSVTDWS8iJkUmPog2c1TlGng30tInCdlQ6zLTk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHdzOU/HpQBZTwunr9XEQhTdeFRk0IOVa+O0VbKRlMo/yuUIrZ
	uEUZ0XQNAqS4+Lm9dtCwSGgtO67jYhpYMFWihFHmP12IrBKJVJ1U2NNqX2cRjFo6rik=
X-Gm-Gg: Acq92OEMpeS8AfE/idG0Qs2I/iJe8CC2dWkuM1z1FYWrS4oX33KOCXiNJntIKVc4Dyu
	GKQPj0WcSFS//Xerl0tPmtMmHhmYo+XS4FwExgmbYgdyyzWKp4r5DnFa4ct2AiKjfB4s4bmt8N+
	mmuiTG7HibpsSXJ+cYVA2WZz6kIWNU6rjDMDjkwCXYN73gxrPP0Lpz45fgE0OIHGuw3AGLkYWIV
	BcHOMWP447YaAgQ/JIlB3gJrsEuGLvICQZKejO4BjoS8TeUZG1ef+q+ylyVP1hpqiH9AC9r/Kqc
	V/eCF7uM+qTdXYySCsPNmXlV5XODkM/t7yGlGl2U3nBuMPPoy7n/7PiiS6VunOOYQV3J5wOqyjn
	jM81tuMn9aWtP2c0kXbZPOeIJmd2ykEE/GZ0Abqy2vI6S1P/Qmldnt63bU+N42c5xqLD3FxwS87
	foHLNgQAly8yoIIFrUBHk8TaFcvWKN+7TgYh5EqtGUfzYmih3OwWYXPQ==
X-Received: by 2002:a17:907:6d29:b0:bc5:d77e:c0bc with SMTP id a640c23a62f3a-bd3bf987f9cmr31784766b.13.1778620733774;
        Tue, 12 May 2026 14:18:53 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bcf3226d77csm425043166b.26.2026.05.12.14.18.53
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 14:18:53 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bcd3c190f71so504588066b.0
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 14:18:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8nWYozSwGq64gYp9BRTZ3Ku/no0kShHssQ2xvdpzdg85cT/vkLjQ5ac6e/Di6btZ2OqjoAbOzfuBtj0Y0=@vger.kernel.org
X-Received: by 2002:a17:907:80a:b0:bd1:e36f:1ad7 with SMTP id
 a640c23a62f3a-bd3bf484689mr27989066b.9.1778620733204; Tue, 12 May 2026
 14:18:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALCETrVqG+1yErRJjkxvJrf=A+Vu84HTR4Bx1Pcd8G1C0PJcMA@mail.gmail.com>
 <14A441D8-5370-44BE-8732-99BF8107C3FD@getmailspring.com> <0b8bba44-f6bb-4d69-b9d4-5787c276d41a@inspirated.com>
 <20260510163204.GA2279@sol> <3bfcf406-fdde-4303-9bd6-0d8d21ddba37@linux.win> <20260511213829.GA316710@google.com>
In-Reply-To: <20260511213829.GA316710@google.com>
From: Ignat Korchagin <ignat@linux.win>
Date: Tue, 12 May 2026 22:18:42 +0100
X-Gmail-Original-Message-ID: <CAOs+rJUA+bz6Y2GKioHnFGFKX_uAP+4LaPRs=ZDgRQoUi4mWkg@mail.gmail.com>
X-Gm-Features: AVHnY4IXFsTsREC72LukcHqvk6gC-iS5eeOIEbsMsX37ajVDHN0xSqZ-iDLXxGU
Message-ID: <CAOs+rJUA+bz6Y2GKioHnFGFKX_uAP+4LaPRs=ZDgRQoUi4mWkg@mail.gmail.com>
Subject: Re: [PATCH] crypto: af_alg - Document the deprecation of AF_ALG
To: Eric Biggers <ebiggers@kernel.org>
Cc: Kamran Khan <kz@inspirated.com>, Jeff Barnes <jeffbarnes@linux.microsoft.com>, 
	Andy Lutomirski <luto@amacapital.net>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 11, 2026 at 10:38=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> On Mon, May 11, 2026 at 10:03:21PM +0100, Ignat Korchagin wrote:
> > I don't think fully discounting hardware offloading is beneficial here.=
 HW
> > accelerators will be produced and without a common interface vendors wo=
uld
> > start implementing their own "bespoke" drivers with bespoke userspace
> > interfaces (we already had such proposals), which in turn may introduce=
 more
> > attack surface. Yes, AF_ALG needs substantial improvement, but at least=
 it
> > can be a standardisation point.
>
> That isn't the best way to accelerate symmetric crypto anymore though,
> if it ever was.  This has been known for a long time.
>
> > > In any case, any hypothetical security benefit provided by AF_ALG wou=
ld
> > > have to be *very high* to outweigh the continuous stream of
> > > vulnerabilities in it.  I understand that people using AF_ALG might n=
ot
> > > be familiar with that continuous stream of vulnerabilities, but it wo=
uld
> >
> >
> > Is it actually that much compared to other features/subsystems, like eB=
PF or
> > user namespaces? But we don't rush to deprecate those - instead trying =
to
> > harden them and come up with better design.
>
> There are plenty of other kernel features with a large attack surface,
> of course.  But they tend to be much more useful than AF_ALG.  It's all
> about weighing benefits vs. risks.

If divide number of CVEs in such systems on imaginary units of
usefulness, I think the ratio is similar.

> When we get the point where a large number of Linux users *had* to
> disable AF_ALG as an emergency vulnerability response, and at the same
> time their systems weren't even using AF_ALG so nothing even broke and
> they could have just done that to begin with, I think we get a very

Well, there were: cryptsetup, RHEL fips check, so there are some...

> clear idea of which side is heavier for AF_ALG in the real world.

Same thing could be said for unprivileged user namespaces - distros
even put a custom sysctl to restrict it and no-one noticed.

> The main relevance of AF_ALG to the Linux community is that it allows
> their systems to be exploited.

To be clear I'm not arguing for the current AF_ALG implementation. I
agree, the splice zero-copy is... suboptimal (to be soft) and is
actually not-so-zero copy. But I think it was just added before we had
more modern approaches like io_uring (have their own can of worms, but
hey - people adopt it fast).

But I advocate for the usefulness of the concept itself - kernel/OS
providing crypto services to userspace. As mentioned in other threads,
other operating systems have it and Linux lags behind. There are use
cases: common interface for HW accelerators, embedded systems, which
don't have the space to bring a userspace lib etc. Even non-technical:
there are environments that just don't want to rely on third-party
userspace libraries like OpenSSL purely for licensing reasons. And I
agree, that it is hard to do it right, but we can piggy-back on other
subsystems (such as io_uring mentioned or other ideas).

> - Eric
>

Ignat
