Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01AC2B9B7;
	Thu, 27 Feb 2025 03:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740625528; cv=none; b=D3m9aGtIbLyfj3E56HRL/JRu0V52asIL07L7lg346ieBR9FeclWisG7ziU+9nZdPLoclW9Re+m4Buc1gEhoyXEKJUSy+OctdG0in5fJJpQpce1atsnDq2/O7+CMJxiCzgUKYvgv+OHoyoFBO4RgtVN0p894/laSG1st/NguZfnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740625528; c=relaxed/simple;
	bh=7WtL4nedANVT2iqljZ7s77zwDOpB0DfKNNT/4bjqozA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YE77emM19vq82zWOIKT/9Pv5t12UZLHLHhgcf8Es4BlRoU2em7dBeIFBa/zJHMJcQI08rY2waPIrYf8y+jlo5H/5czFIGJJtcCYKbVRzasU2ZtulL2Q/DnMFrOA1ZJPRzvms60AY7HyzXayboLFAb4LTfZEXN3gtksAuAlXhtn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DjqkmrNx; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DjqkmrNx"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-869440f201eso379744241.3;
        Wed, 26 Feb 2025 19:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740625525; x=1741230325; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IXVx49eJQBLxbCrIlxbeeYi4KBlOK0BbrpMyI4DO0vk=;
        b=DjqkmrNxFaKt8dsM23JihGHZTQg7KqFSX6yH7ifGmfzWuTVjfpc0Ed6D5lLQGcgq+f
         SClY4Q3spGIx3nFocDMywIrigjHZD2gR1OZBz6L1bVXICvSeiq9oEwIyBXmoU/p2N9Mb
         wEi5xTDdolbuCDn31Y+gHFjWMF18r+cSyKqSC0bq0IEeO3iM1+fdzru98uwPknwiMOzM
         L9PCZeOd2OwtiJzrXSU6w5glWCh/bPYCrr87IFKuRI+ZuvR6pXFSCphC3QmQQgB7hbcO
         5pLbRiCI7wUvNpzdLu4dzCBs4eSFVUAjYkim6hvJM7Jc5LLKN0jFoN5rohs+n8x3nN+J
         rukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740625525; x=1741230325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IXVx49eJQBLxbCrIlxbeeYi4KBlOK0BbrpMyI4DO0vk=;
        b=QO4ITxiC53fOIjSgIUD5ZJrRXTpe0b1Ycj9397O4b5mS0RiMiAnGr+GgzuIXms8TIa
         DCaHRlFrngfLB9x8FbgkDhBo3GuO5fLb454DDSQj5z+RNJ2AgNzs0ytzgOeinxJ4eeod
         kZI4ZFcy5pesT2iu/9nuN/MJl+TwbhrrpxfLn2TAvhsbq9aBXhnMLWMOCofm8cTbaEWv
         ndFHqOrJlFeqru96btm2dZ1UeZ/nFEMsADP5WC9apEsEZZNr1JrB1bNwD+zt/IXKKrkE
         9HCXGBEaLSnn+ZaR96dHxROGbjVYmEWPYrna3P2QoaCqaVs5U5jh7p4gZBMiSBKwfHt/
         W1+A==
X-Forwarded-Encrypted: i=1; AJvYcCUAgz+DkcV7FYVusPt+vvTLAdUgw+erqF1MKfyrX10WASQYhwTTxlNY8kykslj3f1Ut6NcNVWYgQk9/dWv9@vger.kernel.org, AJvYcCUm4CQBa7pNFE/4OEQq6ffsZweeRvrA0rAv45iDI0izocO+OYeM7cxE4f2pX4/P+MmQNvHHEDACZEkaKX8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxYTWErltNpk+tJBVBq8Ogiyr2HgWMWzJixRhIAZK3p2wVvSXb
	RKjKTg67aexZb0PVO88GGPW/1VTyugqs9w8XNXBJAKQIHoyuj4NlK9YYAnYHTonekEv/LgYiQkf
	iivxRVLtYUdqJ9411prUkPKLWloo=
X-Gm-Gg: ASbGnct9Ec/DACfjcPl2x5b0fYimgQWtpSfdZamWgjitfQdQwKR0CT6kpzCzD8w9QD2
	YexsLtglUQJs7hUM0qLpEE0fCOw4puMiCnPL+IKMthHGm7aOYBrk12qS2PEk8id67fxqkczeTtv
	/AltuH3ew=
X-Google-Smtp-Source: AGHT+IFyyL3QwKMRRIxrajlGaeKqkP2l4r4cTYgFE9XLJOhNICubo3hunk6zTvETFEecuXEDORjBfHeBIuyCQFpuRBM=
X-Received: by 2002:a05:6102:1614:b0:4bb:9b46:3f6f with SMTP id
 ada2fe7eead31-4bfc27aed9fmr12833741137.1.1740625525584; Wed, 26 Feb 2025
 19:05:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au> <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z7F1B_blIbByYBzz@gondor.apana.org.au> <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>
 <Z7lv6JLax4S8vTtD@gondor.apana.org.au> <CAGsJ_4yAQxjTnSALZHAJZDdUnXKAYFvQCcjQjHiQSUip6cJGKg@mail.gmail.com>
 <Z7l0Hf-CFFjeKaZY@gondor.apana.org.au> <CAGsJ_4zFdHUPELSYDkrN4ie2c73L6e=FEdQbDL3JckS4unKFpg@mail.gmail.com>
 <Z7zpZlWmSV15EUVV@google.com>
In-Reply-To: <Z7zpZlWmSV15EUVV@google.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 27 Feb 2025 16:05:14 +1300
X-Gm-Features: AQ5f1JqXTKth9otrpj1zvCFqiq4wqPtE2SBEWuDVtOaMhsKlJKNsoIq3Jx_5obQ
Message-ID: <CAGsJ_4wr3aT7zxn1MTjUjvQV9jeCGn=xi6VZz0qPm=xEBM6Qdg@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, 
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 25, 2025 at 10:49=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev=
> wrote:
>
> On Sat, Feb 22, 2025 at 08:13:13PM +1300, Barry Song wrote:
> > On Sat, Feb 22, 2025 at 7:52=E2=80=AFPM Herbert Xu <herbert@gondor.apan=
a.org.au> wrote:
> > >
> > > On Sat, Feb 22, 2025 at 07:41:54PM +1300, Barry Song wrote:
> > > >
> > > > probably no, as an incompressible page might become compressible
> > > > after changing an algorithm. This is possible, users may swith an
> > > > algorithm to compress an incompressible page in the background.
> > >
> > > I don't understand the difference.  If something is wrong with
> > > the system causing the compression algorithm to fail, shouldn't
> > > zswap just hobble along as if the page was incompressible?
> > >
> > > In fact it would be quite reasonble to try to recompress it if
> > > the admin did change the algorithm later because the error may
> > > have been specific to the previous algorithm implementation.
> > >
> >
> > Somehow, I find your comment reasonable. Another point I want
> > to mention is the semantic difference. For example, in a system
> > with only one algorithm, a dst_buf overflow still means a successful
> > swap-out. However, other errors actually indicate an I/O failure.
> > In such cases, vmscan.c will log the relevant error in pageout() to
> > notify the user.
> >
> > Anyway, I'm not an authority on this, so I=E2=80=99d like to see commen=
ts
> > from Minchan, Sergey, and Yosry.
>
> From a zswap perspective, things are a bit simpler. Currently zswap
> handles compression errors and pages compressing to above PAGE_SIZE in
> the same way (because zs_pool_malloc() will fail for sizes larger than
> PAGE_SIZE). In both cases, zswap_store() will err out, and the page will
> either go to the underlying swap disk or reclaim of that page will fail
> if writeback is disabled for this cgroup.
>
> Zswap currently does not do anything special about incompressible pages,
> it just passes them along to disk. So if the Crypto API can guarantee
> that compression nevers writes past PAGE_SIZE, the main benefit for
> zswap would be reducing the buffer size from PAGE_SIZE*2 to PAGE_SIZE.
>
> If/when zswap develops handling of incompressible memory (to avoid LRU
> inversion), I imagine we would handle compression errors and
> incompressible pages similarly. In both cases we'd store the page as-is
> and move th LRU along to write more pages to disk. There is no point to
> fail the reclaim operation in this case, because unlike zram we do have
> a choice :)

Yes. For zswap, I suppose we just need to wait until all driver issues are
resolved, such as:
crypto: lzo - Fix compression buffer overrun
https://lore.kernel.org/lkml/Z7_JOAgi-Ej3CCic@gondor.apana.org.au/

for zswap, we just need to address point 1, which is not the case yet.

"
> 1. All drivers must be capable of handling dst_buf overflow.

-Not the case.
"

Thanks
Barry
