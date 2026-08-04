Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC834421254
	for <linux-crypto@vger.kernel.org>; Tue,  4 Aug 2026 07:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785827910; cv=pass; b=A+//4UodSj1aQnMEq4LbdH8xYvqmOxkZbkfkmSfkQYZgKBlDRfYpvWOh+3pr1vKejhwqRVeF6No5HvudRv0/dnyXujYxDtkw+/HMB47/mq13NwhO6EtyCRuQXM2CijUe0/OzPPh8R+fCS8ovJHSWosyCHhGbWc1Ouaq/anB8N2w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785827910; c=relaxed/simple;
	bh=rqtnprB3TwY2SwX5CbaCN7mRM1aXiVS85IYxZ0KL4c4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VlHyGawCgLhuW2ROkVw/clv5EWF6IpYR587JyA2DIfmhzMvTV8aWa+b9nmRRG9a0lvt+lA2pmAZebq7YL/znWUh61z66WV42J9fFpykUM9Kim8G+QKKlUXfS8RS+ME4NTrDS87TKmh5pNKXqAzA4vfF4VTaDTt8UWSYxGyUswNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=joUIEDdh; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="joUIEDdh"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-69fec980a30so4909515a12.3
        for <linux-crypto@vger.kernel.org>; Tue, 04 Aug 2026 00:18:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785827907; cv=none;
        d=google.com; s=arc-20260327;
        b=eKFQEB9bSphSnHvn82G/yNGA6A35ZX1BG/P9saAMIPq0LpPMlHIAe2DOlG2hJZD+rs
         yJfJuWIxfPVdPlKNvuWHj65PP/JTfMHEkqbXP/aWmqu7+wEjik35Azq6S9O1qPcUzEod
         hie4QalRicxbwo77y04zymNjqnv4JX0tzY1F/lWWhCHOaoCHkXnnp9iYEyDvsojbbWLW
         svMZDWcwaJoiKGazuy+ccsR2O5yhR/9cGRadH45LVqtJDb8Y0kP5tzwGGmgspVDB1uln
         NM6GH3yry+iOWrsQO7GPAbBv1QQ8H8s5P1ZEtUBc623yS8hl4OaGWV3qU3jkFtN0Ptit
         /Y5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eGvoGOn9SWtRvkFRvn488H1HdxPWlgF2Aq/wG0uOOX0=;
        fh=5K6/ghwykrH4po4NMcsMy4vch7JuwUzxT1Z2Z7gxVw4=;
        b=Y26DVrjzPcB2Xr4/H2aPyJ9inxOymltvMm+78+FPDn4Xj0NlOgSYH3Uv9ajLeOQbJp
         3Fn06GfLBYcCiqLs0iu4PKKgn0RboaYLe3t2AFzab6N5VYB6xPIEmMeArKBbuatEsuTH
         MVOuxPE8Bl5U1lLAq3m9H3IhF+x//v9zxS2TC84xrRBJGfDIqaYtQeAG9XAuW/Tggy+P
         wIskMTeReWlEEqL9rXXnSTquFsZX2eHRp69nnfWVU4/rYFK9YC4MJimFvzvis5WmvWM9
         g5ajvD/8ft1lEEAF5s6YHydC7SwPlhFNT4oOoGDuevByuPm7WYL4jCcxNfe+D7Z8wsRn
         v0nw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785827907; x=1786432707; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eGvoGOn9SWtRvkFRvn488H1HdxPWlgF2Aq/wG0uOOX0=;
        b=joUIEDdhyyD7EC9UNajnnMZiKh7bjyxqhqrnkUp/QxJNRKW/VUXUD856wtp4HAQgN5
         /FuVCD0UJmMwOAqpGpd8iuMW0k+2dwxUY4mcbOMDlHmIlYiMHRlGALKhse5vdoOGKZtF
         /EkL7wUndZDlXfciBLWp0GnEmkRdyXo65piwCTyqWhCCcj6A6opeQyg82rDzco6yvXpu
         rktlsWIWVfPqRWf9cSm1IS5kqyRfgUlKM5UMSqc8lzY9uYcd3WTWCKyHe0WrxNS0hBW6
         62Bkj3jRVUxHT/qN7byc9XN/3UJ17YMeWeS0FEL6wzMOG5r650Ep28fVI3J7xDGLVVPw
         4lgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785827907; x=1786432707;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eGvoGOn9SWtRvkFRvn488H1HdxPWlgF2Aq/wG0uOOX0=;
        b=SQSVdEmFb0WLi5GfntVZojnVjLB5bSDRl+o+p5/APJWTp7WV0XNQ7IjHEglVq1kgxo
         xtTtqULs+TL/0u2aimDeB1tP6YkkidW0gG4sl4pevCUlgK36ZRZOK2Ox1PNzAonao9oN
         ag+Ff2L6W815CiGOb+N/vUSwtqtIhz7dX4qSobuBw65PV0Hk0gVEuu++ZoEEbOwARBHn
         8UpVSTANenecZpH9zVCkoLFuRICnCYuSkvq9cdgaZvjkT0TLW5QK5d/onVX04ufQDBWs
         phBTuXGmQo1Kj849T+xFJj1dbR5oNnMDzgBtXqz6RF/NOtnGl8MkNxRqgMvXJTOWTNH2
         MoYw==
X-Gm-Message-State: AOJu0YwCReFouzwpS307fIceH2HRrLzO3LPUIbLRSTvilHo6s4qeYEEO
	ZcgjEgMTmVXGGRv1IS+6pA4qtf/6G6DvbxGGDE81zrv5i9y4SyhE61ws6Qw7rWdM5IwDEBshVMn
	Q05URF4Mi+sj73VOEBOxW1nm8yZUHaA4=
X-Gm-Gg: AR+sD11hN3F1vplW/aMJmZKVR751AdjgL6TYUCj3DppquyPJUJxQMP0ApB4XvHDpDy5
	SoCQHfZivjZUz9717yf119ehy3R0o/INJuhxIGuqs4NMvuosktxHoMxN3Tbv/2mWIUTrBwx4xke
	NWwQoVhGSntL4HzYZ4jeXIHVqXL42vvvwdiLZLJdGeSB68t9D4WKC/w7VltNQqXZ7USUM6yuPZh
	aFhr8Fj3J9zahYrRKBRv04UCTmcO3V3Ziz9E58Ebloby9CQVwK56qgb9G/F4g2qn4YZyuZXiDJM
	vNX7842ZgDfVj+H2KWP6kaSIh0vf9jD0qUUL2fmz4OQkJURfskIb2r3PGJUKvLiDtME2ECH1nx3
	UrM4NI+yBNntUyA21A7kwTx58CfhKw1A+M8l5lYNdDJfnr7EwlUniR4wDDuPj+1GP4rnxlD0fqZ
	GPWPyg+B85VVgGnMSok+eLlyqCFcRW9qk5a9VNNmApQHem3l9gG1nqPvQ=
X-Received: by 2002:a05:6402:a6ca:10b0:6a0:c9bf:2023 with SMTP id
 4fb4d7f45d1cf-6a0c9bf2172mr6056287a12.17.1785827906771; Tue, 04 Aug 2026
 00:18:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260803224028.87631-1-rosenp@gmail.com> <8e0dc8db-bfb7-40f4-b6f8-fc773e8b74f1@redhat.com>
In-Reply-To: <8e0dc8db-bfb7-40f4-b6f8-fc773e8b74f1@redhat.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Tue, 4 Aug 2026 00:18:14 -0700
X-Gm-Features: AUfX_mxnoYu3p9MGqs3pqtQ7Ps3_Y2Je_VfExHaXrEiFzqEFnuB3o-KFix9hx6A
Message-ID: <CAKxU2N9=qABcpCoQSJ+LeLu0nZj-XBdhetoecwsfRGky+Vgc9w@mail.gmail.com>
Subject: Re: [PATCH] crypto: eip93 - use struct_size() and flexible array for
 ring allocation
To: Thomas Huth <thuth@redhat.com>
Cc: linux-crypto@vger.kernel.org, Christian Marangi <ansuelsmth@gmail.com>, 
	Antoine Tenart <atenart@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 12:11=E2=80=AFAM Thomas Huth <thuth@redhat.com> wrot=
e:
>
> On 04/08/2026 00.40, Rosen Penev wrote:
> > Embed the single ring as a flexible array member in eip93_device
> > instead of allocating it separately. This simplifies the probe path
> > and uses struct_size() for a single allocation.
> >
> > Assisted-by: opencode:big-pickle
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > ---
> >   .../crypto/inside-secure/eip93/eip93-main.c   |  6 +----
> >   .../crypto/inside-secure/eip93/eip93-main.h   | 22 +++++++++---------=
-
> >   2 files changed, 12 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/=
crypto/inside-secure/eip93/eip93-main.c
> > index 1a8dabc4ada4..e62785952b0d 100644
> > --- a/drivers/crypto/inside-secure/eip93/eip93-main.c
> > +++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
> > @@ -415,7 +415,7 @@ static int eip93_crypto_probe(struct platform_devic=
e *pdev)
> >       u32 ver, algo_flags;
> >       int ret;
> >
> > -     eip93 =3D devm_kzalloc(dev, sizeof(*eip93), GFP_KERNEL);
> > +     eip93 =3D devm_kzalloc(dev, struct_size(eip93, ring, 1), GFP_KERN=
EL);
> >       if (!eip93)
> >               return -ENOMEM;
> >
> > @@ -436,10 +436,6 @@ static int eip93_crypto_probe(struct platform_devi=
ce *pdev)
> >       if (ret)
> >               return ret;
> >
> > -     eip93->ring =3D devm_kcalloc(eip93->dev, 1, sizeof(*eip93->ring),=
 GFP_KERNEL);
> > -     if (!eip93->ring)
> > -             return -ENOMEM;
> > -
> >       ret =3D eip93_desc_init(eip93);
> >       if (ret)
> >               return ret;
> > diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.h b/drivers/=
crypto/inside-secure/eip93/eip93-main.h
> > index 990c2401b7ce..5f0f51081743 100644
> > --- a/drivers/crypto/inside-secure/eip93/eip93-main.h
> > +++ b/drivers/crypto/inside-secure/eip93/eip93-main.h
> > @@ -92,17 +92,6 @@
> >                                                   EIP93_HASH_SHA224 | \
> >                                                   EIP93_HASH_SHA256))
> >
> > -/**
> > - * struct eip93_device - crypto engine device structure
> > - */
> > -struct eip93_device {
> > -     void __iomem            *base;
> > -     struct device           *dev;
> > -     struct clk              *clk;
> > -     int                     irq;
> > -     struct eip93_ring               *ring;
> > -};
> > -
> >   struct eip93_desc_ring {
> >       void                    *base;
> >       void                    *base_end;
> > @@ -131,6 +120,17 @@ struct eip93_ring {
> >       struct idr                      crypto_async_idr;
> >   };
> >
> > +/**
> > + * struct eip93_device - crypto engine device structure
> > + */
> > +struct eip93_device {
> > +     void __iomem            *base;
> > +     struct device           *dev;
> > +     struct clk              *clk;
> > +     int                     irq;
> > +     struct eip93_ring       ring[];
> > +};
> This looks weird, too. If there is always only one "ring", why don't you
> embed it without the "[]" into the struct eip93_device directly?
keeps all callers the same. -> vs .
>
>   Thomas
>
