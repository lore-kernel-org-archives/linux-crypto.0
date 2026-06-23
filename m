Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C024229ACDD
	for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 19:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782241852; cv=pass; b=CYb9qhGunQIUfueN/p36gHFdzLDICg0evMfFV+muWv7IvohM5dvWeIaTEnu9IFlMzJ8MN+Ho02tnrdJDF6cX9lbzPp5ItvuAeyy5VVwbI/usqRTYLumKvKHOAKlc51aw65jFjTQCvByJ7ZfPUai+ePUzIamBHhNuats9fScTZyc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782241852; c=relaxed/simple;
	bh=LUGGbj143M3VA41hGocqSrjQtYcCxsOekYulyejn0Pg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MQ6w7G4iIoUkdvxVO1lITIrPYtHjVwHFmEwqcFYET+FgdMOWjx055IlFNpWHPxXIS6TE8IzNtt6iMBNRkdkyDe+nmWLeRyOCFTFZtMeK7ROhunA1GDOdPXK1jUL31yaSRnYdVOVsy2594qLEZbQwQhV6HDWGx4++NOwQ3WfygZo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HePxY8qn; arc=pass smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HePxY8qn"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-806449d108aso4185937b3.2
        for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 12:10:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782241850; cv=none;
        d=google.com; s=arc-20240605;
        b=Zb2ldVopX9xc6ms8QloW/YIi4qpX6/+rmp8UzD6UVTM+fVDO9/1MYQ58mcDrHGSv7f
         jCtiRiqS3SYZAdZ5ItE6M6s7u92ob3DESF6+hv9LabbGWy7ew5p7lqVCjxxGfhOXPwTc
         NAN0C/Gbsg+sHrMOTu6dKPtFwVsxV2zMzOO0D2FSDJwo7xSBhN348At1VQcFTWnq3+m0
         4RPSejRTDYb0zk0US9x0HiOZRPsdU5sxIluKB6tmrGUnNFL4uwwsU4m82c6vwZJYVIo8
         PTmz2BG610dE/5hHg1tUPbO3RMCXmf17m0nSGZLC2Jo0sKNMjpWV0M3CoJ+ht0O4/Cq9
         zUDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=c35v9iYTgkecbB9oUFFdNva+iOyBGB9UM54A5XzhJMA=;
        fh=OtC0NaSiMmmb1Ul9GlacK90FZihh9lhKgXapapz+x08=;
        b=WaB2EXwBW9mdHeoKfWytNzTgxmazYAaT60JS5+CNIHxLE9XKU17SQaDjx5bc8GbCH7
         6lrI6+zz/xgKDHz2y5sSsn+l8mlX18+Xg8Xpm7FvtMGBUX4A8qXJtCymwpNskZz8kl+w
         8KO7OLmOrw4eD8B1PCKUVlks5iqNLyNWlvr5ibbMOdj4nd9hiKfJybGg57gxzxfzMK81
         7bExJPYRhK2Z4Le/qfq+8KYPJJesQ5/cyQ8UI6s2VI4KyajqaxeDbraFlDW+sbxbo4af
         Ub37A2zkxyJeO+HU+4ifr/UPzA+GzX0ZDltdRgg4+QNNqW5qs6hu8ftbkPzTRgGjEohN
         qr5w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782241850; x=1782846650; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=c35v9iYTgkecbB9oUFFdNva+iOyBGB9UM54A5XzhJMA=;
        b=HePxY8qnfUYDGsEJm1Idyj9LWX5yRGbecuuVbi2wAri/dMGT+aAoCm3Zse+ei7/nhV
         ZPdFh6BFHEvBsSL2mbA5gQF334x4Xo5hXseObLZfCvGMNmajqEUA7yD8Ax8XXnXHnksZ
         2rXDxhkW3l+0AmHQrkCGY1xpcvRlOOVGA3pEsvU9p17pdqM6MVFSKkgzW/x9dDq5UT3a
         dKJhq2gd8lRmMvwmNNpFVOkoL/CtGP3i7S1amwTLza8QYy831eyGqdlULcSjLzRVWbEZ
         Hnzn+y/T/VTrP341zDtL2MSoxhqZCHeV3ROiP+UdKXUkyheitMHW/JP4Xt43H746CCYb
         GAYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782241850; x=1782846650;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c35v9iYTgkecbB9oUFFdNva+iOyBGB9UM54A5XzhJMA=;
        b=NOsbr5fJw/UNh0whapS7EY8wkCIG+nb+sBY6e08fHrUf6dAHRDu045Krfibhj6OfRS
         H7cTIecmipdiO/t+B35V8ztQL1egDqaO8VxBaHEP7m6ARjhEHtaNE0b5g2+ym2Jnmayg
         cTVxR4SGvetdVp0lRtwvPwYCEGNizc2Yp0c7om0tPdNZ9MlKEJUzlRv3cV2P60vTvmMl
         /NsEJBpl/6J5fGMtlbEwuYPjpYNI8Op4Tb7HcpkRlBF9wRCQXiuWH2+/9o1DhbD9AuRV
         mm16pj0R9jwzj8T5IyEvcI09/RiNALg3hAcC14bAjnVEu4itGFse5cXYHkkp2//KOGSz
         sv6w==
X-Forwarded-Encrypted: i=1; AHgh+RrzJg6bqyMo1xXcGpnH4amvI14kMJuW929CRE+tfnP4hfxUHiQI1t784YzPOx8cFlycJ6We1Fc5g1QWCdg=@vger.kernel.org
X-Gm-Message-State: AOJu0YycayAEL3viJhjCmqDOunSAht7+Hqlvyso7hWiz8tjhUeAYg4hJ
	LKT2i5IuXXBhlHbfNWGeh1H3dJe6UHiUDhHQlcuJpraRaGVrIl377dqI0f6EBhKw7Fu32wi0bPt
	WGVIin1QX7gTlZd59/7bC8y9vEpZ4E0g=
X-Gm-Gg: AfdE7cktnEdvx4WDwoRkxGfCmqKtQD9kO11bjpNpFrFtCopdBzRwr2blCxmw078uzWT
	0j3tLzkcRMrF2pXUmeqkHiy46h/AUaEVi6p6lFlriBXWTl598p52JAlWIJl4lPJiuWU5Z3Ck97t
	Q1gb1z5v6HGF8C7BnNDwjUw532yDEFlcI8Ui5AP9N+4gpULEH4IClNGBmRWmi+NPKnsw/pXkh3z
	XLBogE6atKaPlyhFQPCsUs+yhz083GMbG+I5fxAsverg7ap+czTe+oJ65Yhzk3Wr9zDKNNWddYO
	NKnF6UFlJt5nQifpzxpRYPXtd5IFqw4=
X-Received: by 2002:a05:690c:c52f:b0:806:a739:67e6 with SMTP id
 00721157ae682-807f504b9f1mr1537357b3.39.1782241849699; Tue, 23 Jun 2026
 12:10:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGtAT=nJOAxecN+eYVwkzQAUcr2BaBhAO=ni9hWqdRKUQ06=fA@mail.gmail.com>
 <20260607112435.42804-1-fabianblatter09@gmail.com> <ajqL_VMVA6n-gfQP@wunner.de>
In-Reply-To: <ajqL_VMVA6n-gfQP@wunner.de>
From: Fabian <fabianblatter09@gmail.com>
Date: Tue, 23 Jun 2026 21:10:38 +0200
X-Gm-Features: AVVi8Cd9wKHXsrQMTFhkkypwmdBGYlJgGJ_ikBu9pxoo0sF7IlMwMq5CLl5p5ss
Message-ID: <CAGtAT=mA-6=8R-PKUk3oz9fuJrX5eExM9Wu3KPtnaJJnE+OA_g@mail.gmail.com>
Subject: Re: [PATCH] crypto: ecc - Optimize vli additive operations using
 compiler builtins
To: Lukas Wunner <lukas@wunner.de>
Cc: ignat@linux.win, herbert@gondor.apana.org.au, davem@davemloft.net, 
	stefanb@linux.ibm.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Jun 2026 at 15:37, Lukas Wunner <lukas@wunner.de> wrote:

> The kernel is much less encumbered, the minimum compiler versions are
> apparent from Documentation/process/changes.rst.  If these compiler
> versions support the builtins you're using then everything should be
> alright.

Yes,  I have tested this for both the clang and gcc minimum
required versions.

> > This is quite interesting, since, as far as I know, the kernel compiles
> > with gcc and O2 by default, yet the macro-level benchmarks still show a
> > performance increase. The effect seems to be reversed when crypto/ecc.c
> > gets compiled. Or maybe the linux kernel uses some additional
> > optimization flags, I am unsure.
>
> You can compile the kernel with V=1 to see the full command line.

I did this and it seems the kernel does not add any optimization flags
that would seem to affect my code (other than of course -O2).

I have looked at the generated assembly again, and I've found the reason
my code is faster in the kernel, but not in the micro-benchmarks at gcc -O2.
The carry chains from the vli functions from my patched code are identical
in the kernel & micro-benchmarks. However, for some reason, the original
vli carry chains generate an extra cmov instruction in the kernel, but not in
the micro-benchmark, causing an additional dependency chain for each limb.
The original ecc.o object file is also ~10% bigger, which may be another
factor.

>
> > However, most of the time, the patched version outperforms the original
> > one by a wide margin:
> >  - On clang -O2 or -O3, vli_add and vli_uadd show a 4.074x and 5.384x
> >    speedup.
> >  - On gcc, vli_uadd shows a 74% performance increase at O2,
> >    and a 2.07x speedup at O3.
>
> There is precedent in the tree for overriding the default -O2 with -O3,
> see lib/lz4/Makefile and arch/mips/vdso/Makefile.
>
> It might be worth using that for crypto/ecc.c if it doesn't cause
> breakage and yields a significant speedup.
>

I believe this as well. The gcc -O2 code is still about ~3.5x slower
than the gcc -O3 version from the microbenchmarks. What
code gcc -O3 will actually generate in the kernel is another thing, but I'm
pretty certain it would improve performance further for the vli operations.

However, how this affects binary size, speed or even breakage in other
areas is something entirely different.

> Previously we discussed replacing the ECC point multiplication algorithm
> used by crypto/ecc.c with a newer constant time Montgomery ladder.
> If you are interested in continuing working on crypto/ecc.c,
> this might be a worthwhile topic:
>
> https://lore.kernel.org/r/aftFAexDFrYbIeBM@wunner.de/
>

I will for sure look into this in the future, however, that would definitely
take considerably more time.

Thanks for the reply,

Fabian
