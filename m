Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4264F21C9EA;
	Fri, 29 Aug 2025 16:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756483556; cv=none; b=HzbgYS1uGnBVGgzQ33nL8a07y69yIy+q9Q12D9LNXJ93GGiHVShNtlRA6tNLOVlQwurht33m+leb7Xb32wCzQm37ZAGGA0DHI3AmHtj9L+WQ6gORV8GjjmT1s8V9JO6lsI56FODqubKMRL8qrGP1jnLYbU5Zgx230daevGnkMfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756483556; c=relaxed/simple;
	bh=/fsHhWsSiwyOtIj1bx5ospQQn0DoNIWn4soWO79/N2w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZyD0PNFjUBnop5zoQnGENt8xpwGpkvQ8ilPWJe6QK5CyWhVJi2KKWXSxSuxemdktsYRD1+MbjzHEHEZN0MO1CRluEnfep/O9Ou5c9tnIfjWh9kSP1QcAtGpYKimxdx/rG7vcJv+vmwH7Vho1gRHeedJgTYz7x1y2X75EcGqZ7NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jfz4Aw+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jfz4Aw+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC222C4CEF0;
	Fri, 29 Aug 2025 16:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756483555;
	bh=/fsHhWsSiwyOtIj1bx5ospQQn0DoNIWn4soWO79/N2w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jfz4Aw+9yPXZSWT653fxEvmaqhg0Jm/Rw/23+atTWeJchItG/g/xCc+ZD64y8uNUH
	 N04QbP+nGOn9qI4aKINXQTmKPrv369okma6ImAbEl2TXcOMOM2AqF37YxDcWPwCpRT
	 d/I/pQ2z3V1p/hgGZ+gaugnJ6Rfy82pVpifOn7DKVnto3XJqBylwyeNGJRqGRXK+G3
	 zz/Jj/sdegEkGtUSMEJNCP4Kzan2lEkv+G5lxKFpFuRdjAelr95/qQbla6xD7SJ78P
	 Y1YmntSMCD5sQicDuDV/eiproJINhm8zMJC2WXpmk5af9S3ypJ6a3+00rEI+z3sx7a
	 1BQXkAnnLF7UA==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-55f62f93d59so1397206e87.2;
        Fri, 29 Aug 2025 09:05:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVFO9xla5vV8ZiFRVS0aYk7ClSKuR3oL12zzphcc+XJ1WA4tZdRnkEUzh76uHzoNAcAv7cU7PiLO7O8pnBC@vger.kernel.org, AJvYcCVapsvvnjPNdlUHq8MpXQRMvupupvOBESkxJLZNF5TOUhn6j4BakwyA/DgtL1dZHYVh+wwd4PAXLvUvigY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPzYgkJDxq/U79r2UGi0LpqqQJu2h7ivAGbgFcYDBkGZgomF09
	5MUHfMN2XtjOZoG9+oafaPajEm4KVqB72PZu6/cIUtXxebifgRbbo7CXGYLa+tPiKUKOklUT0bH
	sTvSdTecfADa6PBY3UHADDJbaZKp07BI=
X-Google-Smtp-Source: AGHT+IFr1NtG4C9fVjhaQPBoAripXjdR2xqeXJjj9nx4cBrsKNR84LC16+0wpCvKQHW6CEe9RmZ3WfrgviBpAB8sh0o=
X-Received: by 2002:a05:6512:260d:b0:55f:4fb6:20af with SMTP id
 2adb3069b0e04-55f4fb6222emr3279688e87.51.1756483554053; Fri, 29 Aug 2025
 09:05:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250827151131.27733-1-ebiggers@kernel.org> <20250827151131.27733-10-ebiggers@kernel.org>
 <CAEH5pPY98CaSm+EXiuOzo6EuWzGu7rEQjGa3eojk18HP29Rs7w@mail.gmail.com> <20250829152912.GA91803@sol>
In-Reply-To: <20250829152912.GA91803@sol>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 29 Aug 2025 18:05:42 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGf+0b=6kPAzzxgesaOYSJtzoL1oQyNqT2VrUkWFzwJzA@mail.gmail.com>
X-Gm-Features: Ac12FXzLZacz-sBE8NRb_XQ7Tqv3u8sk7UD0Q2bdwjm9ftcJfH2QikBrdlO4YkM
Message-ID: <CAMj1kXGf+0b=6kPAzzxgesaOYSJtzoL1oQyNqT2VrUkWFzwJzA@mail.gmail.com>
Subject: Re: [PATCH 09/12] lib/crypto: blake2s: Always enable arch-optimized
 BLAKE2s code
To: Eric Biggers <ebiggers@kernel.org>
Cc: Honza Fikar <j.fikar@gmail.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Aug 2025 at 17:30, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, Aug 29, 2025 at 03:08:56PM +0200, Honza Fikar wrote:
> > On Fri, Aug 29, 2025 at 2:54=E2=80=AFPM Eric Biggers <ebiggers@kernel.o=
rg> wrote:
> >
> > > Currently, BLAKE2s support is always enabled ('obj-y'), since random.=
c
> > > uses it.  Therefore, the arch-optimized BLAKE2s code, which exists fo=
r
> > > ARM and x86_64, should be always enabled too.
> >
> > Maybe a stupid question: what about ARM64? The current NEON
> > implementation in kernel arch/arm/crypto/blake2s-core.S seems to be jus=
t
> > for ARM.
> >

That code is scalar not NEON, and is carefully tuned to make use of
the ARM barrel shifter, which does not exist on arm64.

> > While the upstream BLAKE2s with NEON is both for ARM and Aarch64 (ARM64=
):
> >
> > https://github.com/BLAKE2/BLAKE2/blob/master/neon
>
> There's no ARM64 optimized BLAKE2s code in the Linux kernel yet.  If
> it's useful, someone would need to contribute it.
>

NEON is cumbersome in the kernel so this only makes sense if it is
substantially more performant, and I'm skeptical that this is the
case, as you pointed out yourself in

commit 5172d322d34c30fb926b29aeb5a064e1fd8a5e13
Author: Eric Biggers <ebiggers@google.com>
Date:   Wed Dec 23 00:09:59 2020 -0800

    crypto: arm/blake2s - add ARM scalar optimized BLAKE2s

    Add an ARM scalar optimized implementation of BLAKE2s.

    NEON isn't very useful for BLAKE2s because the BLAKE2s block size
    is too small for NEON to help.  Each NEON instruction would depend
    on the previous one, resulting in poor performance.

Even if NEON code might be slightly faster on some cores, the fact
that it is sensitive to micro-architectural details makes it less
attractive.
