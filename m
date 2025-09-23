Received: from mail-yb1-f195.google.com (mail-yb1-f195.google.com [209.85.219.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746E025A63D
	for <linux-crypto@vger.kernel.org>; Tue, 23 Sep 2025 12:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758629444; cv=none; b=MYM9OdqPp0h939fkCJEb7bRfn1disEd/6ccC9qjoqGP9bAIW8N3lX4+9Zs7/4mmgLDWGu5KGJ9Kvx5TDWmGtmrBhj0JfakszCvm9kOvQEwiQU7RO5zmTON+WhRVbFE4hlKlvxOxpWyVh2ZlG8Y5flUQn/LI+BbCSHWOKRA++Pdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758629444; c=relaxed/simple;
	bh=a9DTXpGqgVHh9jVLGJdvu05e2qjfyRCHTw524yeXfSw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OxlNBS+uvlLynTNff0JvWCQcPIJ74/zTzCbX4lsLRc5SbthzFAOG/NqPmd4nW4ShxEB75Om3IRvXTdUr4JQdw9vh7tznEJQ7o8UYlqfjdwHB59TqDnGrNYNi2yvUj/VoqMOpkqp6Qafhhp/OqcIzQzdmFt4fgqv/4cyRVwtmjDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f9lwHqiG; arc=none smtp.client-ip=209.85.219.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f9lwHqiG"
Received: by mail-yb1-f195.google.com with SMTP id 3f1490d57ef6-e96e1c82b01so3570485276.1
        for <linux-crypto@vger.kernel.org>; Tue, 23 Sep 2025 05:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758629441; x=1759234241; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zq6ksWyCEtjP7L0EnAqqm+GnNsIY/ENqD77Iipk6ZkA=;
        b=f9lwHqiGIvC1t0RL0A8FIfMY+yFFEv68o+GlOFdl+EB5W+Mu9iuBAV+DJLKXYmEBqu
         11m5luBGjPeEQRcm3nTslM6pXWIZuTLY2WiAsBwzhLXb2zdjxp2Vx03Ciyo6LYDPSPPS
         WDFcEcA4YjOWfYdoCORqYg9byx0H9LmWJ2P6QfvAt8IbKV7uc1EosJq/B0+l8DbhcUUl
         rF8VdVHpXiDOUyVha8xbG4e0xQX/gsq7J8Gt6IPHlAuDkTzGfWxcBzFna6VX4XHYClB2
         he0x1dmXQEXa2qOnxhZKbsPETcMN6Mu+j2+NZZlGetc2xFgvi57yppDEcL40qy4w/g0T
         RNLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758629441; x=1759234241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zq6ksWyCEtjP7L0EnAqqm+GnNsIY/ENqD77Iipk6ZkA=;
        b=IiFfM4n/xe8BEOw3GtsniVX2Djrzo4rqv3gzXHEUUJO9tEan/0UXUX2EU9cz0Rk4qH
         t56jAp/o3d7JlnbE1yI9sFP2yaxDRygljV6oPTrwyBKcn4d5P3Rv+a7VCVN9cCK+V5w/
         4J1FruDy2fIRbRGMvkCVdbiLPRCAyC3LwOk/TxD9P9V/g5HMFMlYPPhwYuWlGmEfnIEA
         uwnJUD1JjFDpuSiqPRMh6+vThWx0KtJm2qyQALLtSPjhzto3Ews8xLckBnoVko+bZrZw
         ei/Sa8QFPtjPXFIb+Yo8iT5dG1Qo0s/x2OkY7j6+VMIA81VqlP1hDr4Ff6QgEE0onFBm
         vldQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRnOE2ZjZPDHO6qmHgRxoFl2P6db4tklSkO7K4wiOpToJgtSgPt+4TETWoF7Gf2M9xa2ZbUwFN+odoLq4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGAZSWPLxOoejJ6ZRnaJFsYkovhv1t/o3FlGQZMkVMJgcgSSlz
	Plqv+70A3u/mSngCo6xy5eSx0xsTjJpFdjT5+70vZ0Vjx0TGtib+F1kPBPEvhH21B1NMcyq83fR
	b291amB24IVOjI8QOuuW8qjcnMLGugVHYEAWQxpfcJxzc
X-Gm-Gg: ASbGncvsVq83SiojxC6yv6d0IdU73W3yWuJEq9f206uLluT0XtCrbn9K/O0CmdXfVwp
	RTGoiaZiAOw+IEnPCh+Fm//FlmKXazuATTT+qgFHkPwGEFjNHhLR/99EbJdeCqxJQRRlyeikEsW
	xKhiBQbBYtbmf+r/Nrf7nHK0QEcnHmUyUoefMjDjdBtfCtYpbFigYpN6JrluJ7DMSdKvxW8tPKk
	Aj40Os=
X-Google-Smtp-Source: AGHT+IEijeUDqCQWWk3DlJFuTl+beAlJlJjPVnGvdVX80F2lyDoY1c1I4/gd8BqOlIERvjiXSGd/JYk9RF17BzK7I6E=
X-Received: by 2002:a05:6902:5408:b0:e93:48ae:fdaa with SMTP id
 3f1490d57ef6-eb32fab5916mr2161664276.28.1758629441199; Tue, 23 Sep 2025
 05:10:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250923060614.539789-1-dongml2@chinatelecom.cn>
 <aNI_-QHAzwrED-iX@gondor.apana.org.au> <CADxym3YMX063-9S7ZgdMH9PPjmRXj9WG0sesn_och5G+js-P9A@mail.gmail.com>
 <175862707333.1696783.11988392990379659217@noble.neil.brown.name>
In-Reply-To: <175862707333.1696783.11988392990379659217@noble.neil.brown.name>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Tue, 23 Sep 2025 20:10:30 +0800
X-Gm-Features: AS18NWCsSCb3go_4Vz04R9B0xSiDdbLE5rpM6dRGbXTaTxjX8nxOCkMEn9KQ16c
Message-ID: <CADxym3b=_gb6o7xyozXekF4RbUoFe4h=zfegFuARFWqeWaisaQ@mail.gmail.com>
Subject: Re: [PATCH] rhashtable: add likely() to __rht_ptr()
To: NeilBrown <neil@brown.name>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, tgraf@suug.ch, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2025 at 7:31=E2=80=AFPM NeilBrown <neilb@ownmail.net> wrote=
:
>
> On Tue, 23 Sep 2025, Menglong Dong wrote:
> > On Tue, Sep 23, 2025 at 2:36=E2=80=AFPM Herbert Xu <herbert@gondor.apan=
a.org.au> wrote:
> > >
> > > Menglong Dong <menglong8.dong@gmail.com> wrote:
> > > > In the fast path, the value of "p" in __rht_ptr() should be valid.
> > > > Therefore, wrap it with a "likely". The performance increasing is t=
iny,
> > > > but it's still worth to do it.
> > > >
> > > > Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
> > > > ---
> > > > include/linux/rhashtable.h | 5 +++--
> > > > 1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> > > It's not obvious that rht_ptr would be non-NULL.  It depends on the
> > > work load.  For example, if you're doing a lookup where most keys
> > > are non-existent then it would most likely be NULL.
> >
> > Yeah, I see. In my case, the usage of the rhashtable will be:
> > add -> lookup, and rht_ptr is alway non-NULL. You are right,
> > it can be NULL in other situations, and it's not a good idea to
> > use likely() here ;)
>
> Have you measured a performance increase?  How tiny is it?

Hi. It is a bit difficult to accurately measure the performance
improvement. I use it in the bpf global trampoline in [1], and
the performance of the bpf bench testing increases from
135M/s to 136M/s when I add the likely() to the __rht_ptr().

https://lore.kernel.org/bpf/20250703121521.1874196-2-dongml2@chinatelecom.c=
n/
[1]

>
> It might conceivably make sense to have a rhashtable_lookup_likely() and
> rhashtable_lookup_unlikely(), but concrete evidence of the benefit would
> be needed.

I think such rhashtable_lookup_likely/rhashtable_lookup_unlikely make
sense (to me at least), and I'm sure the evidence above is enough ;)

Thanks!
Menglong Dong

>
> Thanks,
> NeilBrown
