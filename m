Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A99DDBC
	for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 16:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749832581; cv=none; b=jPgheTzF2PIsdsqtlXpMBh90Yj2Fx11uW558amQ8xLL6+t/s1MQvVyUWQQqeosqbz+1vVjys9AMgO3O0KfiUQwjC25zSuTwQAyrgY85/P9CrF+IU1pcifL0/3HHaeitWIzoMB0BxU13v1hfA2vTg2rd5sFXD3X6tRMRQdJxQljo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749832581; c=relaxed/simple;
	bh=6IDK3mFK3aUcD6DqmEoL/rBAW6jbXc5FxEXCTke0bD8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sQIT1qw5lV6viHxNFEWChMvpskA3pZZJc2mjZwkj10AR3uvyBaK0MUSwAv7lF7nqq5cq2Uagw+mFzzln799YXVGfQ+E8hrtZsQuq+ckaY12LT52EKdE0Vc2xq+A9ljzyNIEn5X416jTAO9MJRs3sx1Yr65B29Qa38GAQ4e6ROWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EIHZ5bUg; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EIHZ5bUg"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-adf3b33f968so88227466b.0
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 09:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1749832577; x=1750437377; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=76g08zX1QgiOXgDWQ+4Q63FmolLqjqLzmJdnqen2jZI=;
        b=EIHZ5bUgn98VOQ0SUZbMdi544m1oiO9Fdp/dGsrOQJMZAuaS0UVCpkIRcQDiGEvnu5
         0eO4yTEGsIj3JG6dMk1OJWgm17yZ8nBtRXEpn6M+FpdDyZWLY3C7vXt8FGHWsuR4rQSc
         U/yBJgsJdXcY/9YtEsXcUbsQ1n/MXflsfkHBk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749832577; x=1750437377;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=76g08zX1QgiOXgDWQ+4Q63FmolLqjqLzmJdnqen2jZI=;
        b=PlNyJs7/dJ2FovFe5+QfJbnpfCv3099pSF+BrfBnO36ABQzdwcrZziPfIF6O6pRBCo
         Zbvz7bKuHaW1vOITY2tSr0vkvRKBYAlbBqdUfu+XFor+6bdm7Y2OWrycG7pO0Yu2Ullj
         QDUYseL6+Ddf5aJxd0SSXBdETdDXA5CbPioCnO0BSDz09FQe/NlPvQOqltAJKOP6fv73
         HAx5RqRDSiQhHhKcr4Fj5TbFPuqnzvArBFcWK5PusF2FdLqwafy7N7rY43v9AgfJqTaZ
         LanUxV6e8QvBVivshLnxoz/vnztstItkUaenvZ8DQ1eo+zrs+b4nZdw/836Fs1qJ02aV
         lkjA==
X-Forwarded-Encrypted: i=1; AJvYcCXYPakzIltsIsrQLelS1TJ6NxZwLlHAdI2pUeLVqvsagiFaSTSdySWGJ6HSp222mpFHjnEZuNjTeYa/Bpc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhrTkO/EOX1c5wehBjtIca+y6fzeTTpJLGrQCOabBOjsExysuq
	nEW+6VSffifn97YSJcb02fH3lSQUgpjU7NzTmTygmV60HsIn0XOz45iLnW/b1KTFMM7R2zkzzhm
	5WkRSR2vqMQ==
X-Gm-Gg: ASbGncs2lRxPefBr0xVk6pSuzgbSoC7nelirx4IFqjERN0LKuQfT0VKGsug13DxPWvo
	GB/njGCp5wiS4AdWqu4fcHUp90qGhOlXLVcr9KrOjIpmetif1Iq01+2vTLpjqXL9S/XQQxVmlSK
	bAG//4VLsoRWXpxG7Pjrmy8O5NFsW9YxSvqNDc4pnjt7ff9rsgTNZWybYptvIa4yzV5XqidmUMo
	x60RAXv8S2CNv+vXlUHYJe3SZQV1m2Uvbmsym9JauaxpVcXO8ujctBe+3FIn8exATj43NBTOUpN
	6Mnv+9E8qnrzSGQxcTApxy3heX5+QSaRGBTJ8xxBNsOxKPw6Bj0THq85diWGpxh3s7LhEVhymeB
	2Ji6fgX66VBvR6+M5uhJhEbH9arYjGP9HXpdz4yrU/vQNrMA=
X-Google-Smtp-Source: AGHT+IETaRzAStTSBs3VRXKY4R+0/tsWkWaMssu6jDsK9/mXmLbl6LdL3694RFmCy8i606HCoJOhNQ==
X-Received: by 2002:a17:907:d9f:b0:ad8:adf3:7d6d with SMTP id a640c23a62f3a-adf9eab3418mr37170666b.21.1749832577387;
        Fri, 13 Jun 2025 09:36:17 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec88ff249sm150227266b.82.2025.06.13.09.36.16
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 09:36:16 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-607873cc6c4so4726785a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 09:36:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWwHXlk4/IwSBEgntgqVHtagfYmWOUgfNWCDJly7bKMJOYSGBaClm/vhN4bm7cdK3CnphgOM8wYT4xZqi8=@vger.kernel.org
X-Received: by 2002:a05:6402:35cd:b0:602:427c:452b with SMTP id
 4fb4d7f45d1cf-608ce49d897mr365341a12.3.1749832576184; Fri, 13 Jun 2025
 09:36:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611020923.1482701-8-ebiggers@kernel.org> <aEjo6YZn59m5FnZ_@gondor.apana.org.au>
 <20250611033957.GA1484147@sol> <aEj8J3ZIYEFp_XT4@gondor.apana.org.au>
 <20250611035842.GB1484147@sol> <20250613053624.GA163131@sol>
 <aEu5cyDOMcKteW_b@gondor.apana.org.au> <20250613055439.GB163131@sol>
 <CAMj1kXEDCRfCgvtuhRc+a=m1kVt-zkcCqi_=_WOFTmt4Hz2gGg@mail.gmail.com> <aEvjrhkLnB_GEKnV@gondor.apana.org.au>
In-Reply-To: <aEvjrhkLnB_GEKnV@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jun 2025 09:35:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiewoOfhK=NVQT2uf+29Kngv9F9J6ObJRFUKi6n-=B06g@mail.gmail.com>
X-Gm-Features: AX0GCFu7lGsyyFJqLRh6z7a562txhJJOyTpVqIIzlie72BRGPF0wH2A3ccvLGV0
Message-ID: <CAHk-=wiewoOfhK=NVQT2uf+29Kngv9F9J6ObJRFUKi6n-=B06g@mail.gmail.com>
Subject: Re: [PATCH 07/16] crypto: sha512 - replace sha512_generic with
 wrapper around SHA-512 library
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org, 
	Jason@zx2c4.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Jun 2025 at 01:39, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> First of all the export format is being made consistent so that
> any hardware hash can switch over to a software fallback after
> it has started, e.g., in the event of a memory allocation failure.

Can we please instead aim to *simplify* the crypto thing?

Just say that hw accelerators that have this kind of issue shouldn't
be used. At all. And certainly not be catered to by generic code.

The whole hw acceleration is very dubious to begin with unless it's
directly tied to the source (or destination) of the data in the first
place, so that there isn't extra data movement.

And if there are any software fallbacks, that "dubious to begin with"
pretty much becomes "entirely pointless".

If the point is that there are existing stupid hw drivers that already
do that fallback internally, then please just *keep* that kind of
idiocy and workarounds in the drivers.

It's actually *better* to have a broken garbage hardware driver - that
you can easily just disable on its own - than having a broken garbage
generic crypto layer that people just don't want to use at all because
it's such a ess.

This whole "make the mess that is the crypto layer EVEN MORE OF A
MESS" model of development is completely broken in my opinion.

There's a reason people prefer to have just the sw library without any
of the indirection or complexity of the crypto layer.

           Linus
