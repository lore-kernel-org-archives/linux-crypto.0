Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC532868BD
	for <linux-crypto@vger.kernel.org>; Sat, 22 Nov 2025 02:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763779613; cv=none; b=NraSrEZlTrRRB36h8nla1Rh5+gAkj3zhqpl+Swuw2vaDUfQbDXd8vzwpJqg8L59cNlep1BGwaJHuxeNtsemb5nyehPAy9Y/jfvtyd8avGj1gzlYrVK6I6MUhlAElos4nDb6P6tQ4qA5Ygc1u3PlCUBhirfDtcp9DvB5ZCGQt+k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763779613; c=relaxed/simple;
	bh=uM+y5Tehv7JkvEKlxB+AE/5KoXK8UFApqkERniYtmzo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gfd8s3l3oIhIvkrMCxBMeaqwo/t2c4CpZFNMUUi1xNSwU8UF6JiYMHQfJz2HKLSZ35hVbzMKF8M85z+jvoEXrLv3EyQe/nQrRPVh+sknhYJtdrCGSb12jrmsFhirLkVGr+AOx44GXgiuBbMX/nS5U+xVN2d1ojSfi6KiEmdzf0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=VglkjkJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VglkjkJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50965C4CEF1
	for <linux-crypto@vger.kernel.org>; Sat, 22 Nov 2025 02:46:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VglkjkJo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1763779608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gj01wpnLZZP02RemHt3/Ivz9MINVx92aFeQBiKntfuw=;
	b=VglkjkJoNj5YqOa2evw5gWvrf/m61siOKoXQQFvkUl3e/NyvSsJUmPi/Fkd80zHYNkKSB+
	BUAgEgHGqHI2SrPbUOcaEldh7zywjdBxgalMPP5I3L5t0Vm5Av74kgnCloQNNPp1axM8Xk
	uf14n8MbRfFPzDcYqOd3EGGcnwLLUqc=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2cf87782 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <linux-crypto@vger.kernel.org>;
	Sat, 22 Nov 2025 02:46:48 +0000 (UTC)
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-45085a4ab72so1188741b6e.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Nov 2025 18:46:48 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXsrJUKQmhdlm/I0g2K208OQx69Qw/QpAYU6MA5N04+wzKYC8zW3QmcQwRFeYKaWFCVSHTxzg47CF1/9+s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSy3VOWvr26bTIwZHNQJseMbEr2u0rBvoprzDsb1ZBUkdjTQy5
	Sw9XNq7K5r2PBzU9TdSdfa+6r/UyGYylJ2Gr8a44x0pp1S6i69jm97hxwZ7K1tMBDCzz+MCmn8P
	mfK/Yu+r12IPEx/8J53Xa7vvv/BQeOh8=
X-Google-Smtp-Source: AGHT+IFj698sKJKAt6lwD5Pe2vf/nRofiLig3m0xM3mdWYOc3ddpZA2R6KkiAnZ5NJZpVrR9D8sJ35DmzRjYcIFRjrQ=
X-Received: by 2002:a05:6808:1922:b0:450:760b:cc98 with SMTP id
 5614622812f47-451128c8842mr1921766b6e.14.1763779606729; Fri, 21 Nov 2025
 18:46:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251120011022.1558674-2-Jason@zx2c4.com> <aSEj0GvbFjwlDbVM@gondor.apana.org.au>
In-Reply-To: <aSEj0GvbFjwlDbVM@gondor.apana.org.au>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat, 22 Nov 2025 03:46:38 +0100
X-Gmail-Original-Message-ID: <CAHmME9oukFd4=9J2AHOi3-4Axpw2M9-hwM6PSzRtvH_iCxaFaA@mail.gmail.com>
X-Gm-Features: AWmQ_bkjF7RAJMK3frcXdf7NDDHs8CcB-P7nhGzIGgf2mzpHgTfoYr_1yugCe28
Message-ID: <CAHmME9oukFd4=9J2AHOi3-4Axpw2M9-hwM6PSzRtvH_iCxaFaA@mail.gmail.com>
Subject: Re: [PATCH libcrypto v2 2/3] compiler: introduce at_least parameter
 decoration pseudo keyword
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: torvalds@linux-foundation.org, ebiggers@kernel.org, ardb@kernel.org, 
	kees@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 22, 2025 at 3:45=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > +/*
> > + * This designates the minimum number of elements a passed array param=
eter must
> > + * have. For example:
> > + *
> > + *     void some_function(u8 param[at_least 7]);
> > + *
> > + * If a caller passes an array with fewer than 7 elements, the compile=
r will
> > + * emit a warning.
> > + */
> > +#define at_least static
>
> Please make this conditional on __CHECKER__ as sparse still chokes
> on the following which compiles fine with gcc and clang:
>
> int foo(int n, int a[static n])
> {
>         return a[0]++;
> }

Saw your reply to v1 and was thinking about that. Will do. Thanks for
pointing this out.

Jason
