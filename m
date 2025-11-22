Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7AD2F12BE
	for <linux-crypto@vger.kernel.org>; Sat, 22 Nov 2025 11:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763812451; cv=none; b=qeH6s73xiuk3nujUUEMXicLI5W/VPgc+onKAeghosUlojwCiTPbtPhEF8ZPvZQh+IvBiCtQY1jbSuie5MHzpH2XRThuVscEFPAtZK7tpA6N21WQZNMDiiCsvt8POdbSuIRj3L6GCWjME9tYLi8m2lT9uu60Jdy2DMIpVc8noICc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763812451; c=relaxed/simple;
	bh=pjMg2u3xhueVNGIWNUY5bAuinsXNwpxi0KkbDKYzaZo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MrO3Ms6I+8Cm68rg7XL4MV9b/DnRWcKFm/BiCoFlqFbdQ3/9VL5DErk5afoZn9VSb7BBKq7wSS31hoaQRAxvH7m34/CErIhBqVuyyi8pJ4rot4S7Dfdg5w55KZ8cfNUPnxHWreAL85fJ2PfxD91OniypUE4Aon90uWS8F2BHxNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QgIMH0QR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgIMH0QR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41434C19421
	for <linux-crypto@vger.kernel.org>; Sat, 22 Nov 2025 11:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763812451;
	bh=pjMg2u3xhueVNGIWNUY5bAuinsXNwpxi0KkbDKYzaZo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QgIMH0QRgFW5EnW0jCKO7KJgYEDNxWWNCMy1S+9EqQmvnCiGkxaNdWJUdHnXmfWKU
	 5JRLL377H/Zt7HMHJgkOAGLqqoFK2B+IU+Zxzx9Vxu75epSKx/UTOZhRWL1mzAPeek
	 xeo8Cyh3RM/CfG2Gz7geEmWYxsWzQ+07YbNmLhOJyX8bWvRQyPyxPCnTF2BrJBdXGE
	 vEVVjx8/Qu9c+nxA2+A0JLNEvw3ltHLeZhNByVoi42eF72+0uQgJRJivD+P6StitUt
	 FyC8WBCntGBAgtKHes+f7HyPdzD8rWJFHi7IYFq6P+HNe0QCTzk8CU/KklUp6PLqzd
	 UNCcgfZQGI07Q==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59428d2d975so3130736e87.3
        for <linux-crypto@vger.kernel.org>; Sat, 22 Nov 2025 03:54:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX6EkawDbGUsApg/gEhhRYdlXCQUuFqKh6iU6SwYgtNZJfgXyqDrDjx4X2GkSyYfqaZNsawkKQodSqaSZM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6KNypxkR48aotVX6bMleybfpnn0aZuX8k8zKS+n1fIraaWeKQ
	uhfm4TL+NTRteNYJJXu2OM9FAoc5naGgULFYu6WdYcOdBTn/e+OAExeA2dKceFVpX/jGDEE4TDM
	IyzlMmilaf6lmGIs+6GGVk0jZEeTf9zQ=
X-Google-Smtp-Source: AGHT+IGQaTRoLjVbMEnZ9ez1PaM2FkcrRnJ+q9woXxeGhKdX00Ry7s3tn/DV71vHU9cPmC2T1O3Sp4cw6pVMA62LmgQ=
X-Received: by 2002:a05:6512:3182:b0:595:91dc:727e with SMTP id
 2adb3069b0e04-596a3ebf4acmr1946395e87.22.1763812449612; Sat, 22 Nov 2025
 03:54:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251120011022.1558674-2-Jason@zx2c4.com> <aSEj0GvbFjwlDbVM@gondor.apana.org.au>
 <CAHmME9oukFd4=9J2AHOi3-4Axpw2M9-hwM6PSzRtvH_iCxaFaA@mail.gmail.com> <aSEpNYgrYRGOihxy@gondor.apana.org.au>
In-Reply-To: <aSEpNYgrYRGOihxy@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sat, 22 Nov 2025 12:53:58 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG0adfCkuM4f92csxF0bxxBo6sNe_iJ_szKNEcEfgFwqg@mail.gmail.com>
X-Gm-Features: AWmQ_blWl8qL63CrQX__zMoTiynpKfg5d-_yeHN2g2XLSWhSJbajhzQcOTVzVkE
Message-ID: <CAMj1kXG0adfCkuM4f92csxF0bxxBo6sNe_iJ_szKNEcEfgFwqg@mail.gmail.com>
Subject: Re: [PATCH libcrypto v2 2/3] compiler: introduce at_least parameter
 decoration pseudo keyword
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, torvalds@linux-foundation.org, ebiggers@kernel.org, 
	kees@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 22 Nov 2025 at 04:08, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Sat, Nov 22, 2025 at 03:46:38AM +0100, Jason A. Donenfeld wrote:
> >
> > Saw your reply to v1 and was thinking about that. Will do. Thanks for
> > pointing this out.
>
> It seems that we need to bring the brackets back, because sparse
> won't take this either:
>
> int foo(int n, int a[n])
> {
>         return a[0]++;
> }
>
> But this seems to work:
>
> #ifdef __CHECKER__
> #define at_least(x)
> #else
> #define at_least(x) static x
> #endif
>
> int foo(int n, int a[at_least(n)])
> {
>         return a[0]++;
> }
>

This is a different idiom: n is a function argument, not a compile
time constant.

Clang and GCC both appear to permit it, but only GCC [11 or newer]
emits a diagnostic when 'n' exceeds the size of a[]. There is also
work ongoing to support the counted_by variable attribute for formal
function parameters in both compilers.

So for the moment, I think we should limit this to compile time
constants only, in which case sparse is happy too, right?
