Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5CD194AD5
	for <linux-crypto@vger.kernel.org>; Thu, 26 Jun 2025 15:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750953579; cv=none; b=bsiHhdydNKR8JRbkN9Lx8fPl8I+7FfYpsVuwLmFoDkGyviro4rcEEoeyc63MgmIq1XcDcZNF7+aeeSPOkHsGZZTkNOgd3rgoGdK1R1aAJ3T0edI+XCeymKQ98EaruLkwgJHRJZNqSOi54/sYU1NcLc7+YhxvuY6/LKoBRu0/lP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750953579; c=relaxed/simple;
	bh=s/urzZAVgXLQm0eDwNQNL6qYDT4kOlPkVYQ0DqJYzJk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BNaeiN3l/r/L84DFG4kfCYCK6rpYdLCPEUuz/GvmAS8BMY9FmMpg8u8BSNEaHERhE2hCLCIjA+qOeEOj4l2qJGNjJCVYB1RG5/ormZ/n3pBcKJjOavV+SkIvrH49yd0NNM+JeqZvRmk5cWNv6G3B5m+BzrCHHntV1h0InwYwtlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e6we/+Aa; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e6we/+Aa"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-237f270513bso171735ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 Jun 2025 08:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750953577; x=1751558377; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WC/3R+pcAWBtvUeAyLoDHu4B6QWb/+D2sN3LBJqBV5s=;
        b=e6we/+AaCjAde4jm4+53wKe2IPXs29/4xhAFcr7M1IkPzV/D9SA0eTRTu1aiDwm2rq
         9F9rMLsjnQ6M+nQ0XQLM5pTVb1rsjAYyqkpjJ31isu9ttyNV/atKt/RBj0o4IuzGjx0X
         xZfKTcP0302crHTSu6TnnEjneJ3FLF3vvvPPO2Gn+v7ml0Ap9Z5llVvrzpgRV8F3SCZC
         8AGyOdYRpzGAdRFR3u2HuEicZ+GwNnJgtu4aZ20xXUdVWdjEPN4AKqlPrHMVV+lxh2uR
         1cWYbbAFKGvqVYd9S4pUE6NDlUzAZ/84n74YEET1Zd0HQ1Ru+FHp5uokWfHYMZKyjoao
         wQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750953577; x=1751558377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WC/3R+pcAWBtvUeAyLoDHu4B6QWb/+D2sN3LBJqBV5s=;
        b=BZl+0A8gVrR/Gl1B9u+XeJEQrCicn6jT2tiaraIGAsFKcHSHLVEcyxmEUO2JABd5hQ
         6hoOxrrkhcPwZP4h7mHxiEY7hYG16yMEG9ODB6xCD5sQGH+z/5GpFlBSETE8ZOxLZB59
         e6zQhdhfniQF20MAVioUEAzmo5aFcoyn+iUgft1xt9+bVIVb/i/9T940lm/c8iXlJc4R
         Bb8ZcuPh8t/WJnt3gYqmsUN30dyhTqnFY0xlweE+v4JISTorYCiWkU5gAisM5EVsBQKN
         h8XOizW5iWCBuiR5DJJnsxhqzTXRerowtXK1/6WdqF8xaWmOBDSIl5M2CMWJSe7tHq3M
         yKLw==
X-Forwarded-Encrypted: i=1; AJvYcCV3i4ptMpfOfPPf4cl0ZwLwwFE1gtEvYd4to0Pbbci1iO5UzxtkINLhV74mz+Zrth3HMeE+tFt2RtAMVeg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjyHjvyVEh6vTTJxpRlQFOcqwSTEHeUgW21s9CR8lZpscxSdiw
	J8bbJ0jFR2o4hrDO5tU7JvYAS2ibke2A8y4FK7iPuP0zl0YMhplIcR3C8sx/p5tS/KnbZm9tN7n
	8GfqLq3uZR9rOgnlRPZpyeX/NIMPoQ0UTsWN5q9Lh
X-Gm-Gg: ASbGncuSiaMTHHZy3553kHbP5Pxx/9xMEei0iZfFrRRpdsKT4c4XOQYXm+GOWuQH39Q
	r4Yl58skpo8xjR0Bi65ZM4L3pmYvjHjq5pYB5AsliQjf/YysPbySYHMjvRSy8IQeWHYZXJZPw88
	bfxstE1YlFhd2ffQMhV3EEpY6uGl6WVkCcgoQUl5BC
X-Google-Smtp-Source: AGHT+IF2p1WE73jKvkXVXZWjWgFxpPCR6rlrCBZMmFy7FYCzSLm2RG/NI//tfCBmD/SuJcLL7aEhsEqWJ1Is9nWqPM4=
X-Received: by 2002:a17:902:f707:b0:237:e45b:4f45 with SMTP id
 d9443c01a7336-23ac11da2a2mr120275ad.1.1750953576332; Thu, 26 Jun 2025
 08:59:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611033150.396172-2-zhihang.shao.iscas@gmail.com>
 <20250624035057.GD7127@sol> <48de9a74-58e8-49c2-8d8a-fa9c71bf0092@cryptogams.org>
 <20250625035446.GC8962@sol>
In-Reply-To: <20250625035446.GC8962@sol>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 26 Jun 2025 08:58:58 -0700
X-Gm-Features: Ac12FXwsU4Wn8eArYOkWWdc99aXTmSYYqionP-IFhI0v3zXA_4B74OkFhGvuLvE
Message-ID: <CABCJKudbdWThfL71L-ccCpCeVZBW7Yhf3JXo9FvaPboRVaXOyg@mail.gmail.com>
Subject: Re: [PATCH v4] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS implementation
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andy Polyakov <appro@cryptogams.org>, Zhihang Shao <zhihang.shao.iscas@gmail.com>, 
	linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org, 
	herbert@gondor.apana.org.au, paul.walmsley@sifive.com, alex@ghiti.fr, 
	zhang.lyra@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2025 at 8:56=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Tue, Jun 24, 2025 at 11:13:49AM +0200, Andy Polyakov wrote:
> > > > +.globl   poly1305_init
> > > > +.type    poly1305_init,\@function
> > > > +poly1305_init:
> > > > +#ifdef   __riscv_zicfilp
> > > > + lpad    0
> > > > +#endif
> > >
> > > The 'lpad' instructions aren't present in the upstream CRYPTOGAMS sou=
rce.
> >
> > They are.
>
> I now see the latest version does have them.  However, the description of=
 this
> patch explicitly states it was taken from CRYPTOGAMS commit
> 33fe84bc21219a16825459b37c825bf4580a0a7b.  Which is of course the one I l=
ooked
> at, and it did not have them.  So the patch description is wrong.
>
> > > If they are necessary, this addition needs to be documented.
> > >
> > > But they appear to be unnecessary.
> >
> > They are better be there if Control Flow Integrity is on. It's the same=
 deal
> > as with endbranch instruction on Intel and hint #34 on ARM. It's possib=
le
> > that the kernel never engages CFI for itself, in which case all the
> > mentioned instructions are executed as nop-s. But note that here they a=
re
> > compiled conditionally, so that if you don't compile the kernel with
> > -march=3D..._zicfilp_..., then they won't be there.
>
> There appears to be no kernel-mode support for Zicfilp yet.  This would b=
e the
> very first occurrence of the lpad instruction in the kernel source.

Of course, if the kernel actually ends up calling these functions
indirectly at some point, lpad alone isn't sufficient, we would need
to use SYM_TYPED_FUNC_START to emit CFI type information for them. I
assume if RISC-V gains kernel-mode Zicfilp support later, we would
have an arch-specific override for the SYM_TYPED_FUNC_START macro that
includes the lpad instruction, similarly to arm64 and BTI.

Also, if the kernel decides to use type-based landing pad labels for
finer-grained CFI, "lpad 0" isn't going to work anyway. Perhaps it
would make sense to just drop the lpad instruction in kernel builds
for now to avoid confusion?

Sami
