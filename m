Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC9F1D14FF
	for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2025 21:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740778166; cv=none; b=qBSoj+b8i/eXmgWThte/EDcxmfdN8+k9GKlR1Xzf9/aY5T55RS9+lHmcrtFIExKw5l/clRs80uF688czasbPA1IucoVcGQPo7wIeMpdVyNSFiTHSqx8iVjew7Sb72OISucQH9Aavh+RaZ9aOltezcsaNujngVIoZ3eTDQqHfxP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740778166; c=relaxed/simple;
	bh=kJMrEkhqRpc6VjDVs3fPZ28tdnuiN4UBff7uK9dxTl0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FgYqfNZDFIJL3efavNAle74Lo1xRiVMqB+9SpY273wx5a15hgJfXzoVJSUHQo9XGjT2h6pLWzpYTeP3wSacVbWxIfekhIevw7KK2z2WiARkHMGd1fnzBSwvlG25ynAtzQsSTHfBwQRSmcsbTh9NrULT/oeYmijDZg2SVdUBk9TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LW8T6qVr; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LW8T6qVr"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-abb79af88afso476338966b.1
        for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2025 13:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740778163; x=1741382963; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SqzqyLpyoLT4MnMSiO5M/cbMqW2N1A2UktCSpw8Wecc=;
        b=LW8T6qVrn32s0lCon3/6zxOgPzHezH2SgpgRmnf9jKP1LhQ/QX6m9CaO1tPGYogrqq
         4sFkyEzqzC4jDo53TOIYHYdviHz4uNRrSbNaqa0EDyWDX3bq8Ggy8uI3MXz3H/9TAmjP
         qEVuykQed4WTuu+i1jJYO3DSKsZKVaq4zMZqZXSAswD7czkREyfWrTerYCdtFM9KHgV3
         sbkcMU6bzhI4xq1wV3fjv7TMby9Ie/hPVmiXyK/ZzMX72T6jsMQTWg5ZL9HiLUXdGPs8
         0QrqGPUJxZbx6w0UopmAdyWNszUkw/FgzuwKZkC55ZKYgn4uQUnPgQxcv/24msAbYAqS
         JmpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740778163; x=1741382963;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SqzqyLpyoLT4MnMSiO5M/cbMqW2N1A2UktCSpw8Wecc=;
        b=NTefM5NtYjRVp3aT+GWPFQBlBY8aoF1Ycbnzw/t8ujYciBW5IgNpKzoU1ajm6RBaRW
         yInOL0uRd7UU1O1OJUc3h1xLh34zIB5I2nG8IB0e+9fsDKSTYgMtTrU5ofyz5PnAWgOF
         /T4iS2lQRzTRf7MFCtk4haiXzNuNfiFqy4lpcTmypema56DEmMrTHRlNpQ6bgt9JCuIy
         mW5XmW/UneNrwfsvWwIsSu3cDcCiwb1P1EkN1YrRx16VxNNxnwkg6+oLjXQLn/WdSSoE
         VnUth6sotY12R3w23umu9Cv2nAS/fFD2tfDt/lLh1/SGP/vfMwqmFc0z2fBbHPZTzabk
         BX/w==
X-Forwarded-Encrypted: i=1; AJvYcCUOKGx3V6kweSPjktSBeIVTFeG9ivH3YgAbVvLoLQuIEsFqmp0bD/jBWTp2CMvOBQxassJf6WjTxpfGcsk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUXA7AUungYCkSy2BKJNRGMJWvPR2X9xjvsyyZwZfJ9O4voQ0S
	x1NPQn3PYQnbEpXCU+Lnnlj34DDhMQESQIK268+PjlbufOqXzL49Agnxlu/wHXJYtDA91zfn9/r
	IajeAN8jiyZ19NRtVBuImQn4Bn2ikeLtHMp8=
X-Gm-Gg: ASbGncvUNn+pSPJOK4O42jBva0C4YU8iMCDTegHsEoAuJK7d13BJsE+lZMGeqZirGiQ
	7MwESAXXNrLXzFK9wu50yJluELMzs9sUhGgEn0rRaKtkW9SfUzFYzTUJ4L6ddwU83rvwUDj7nrZ
	JRrAsG
X-Google-Smtp-Source: AGHT+IHelEGE+Ufz9+A2TmH66Wlq+3MH2jgktN1tokY0omf7FSH344duWOuLActep5LEcffLSDmvVh9lPxUEywsplNI=
X-Received: by 2002:a17:906:3097:b0:abf:489b:5c77 with SMTP id
 a640c23a62f3a-abf489b5ea3mr139416866b.31.1740778162964; Fri, 28 Feb 2025
 13:29:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGG=3QVi27WRYVxmsk9+HLpJw9ZJrpfLjU8G4exuXm-vUA-KqQ@mail.gmail.com>
 <CAGG=3QVkd9Vb9a=pQ=KwhKzGJXaS+6Mk5K+JtBqamj15MzT9mQ@mail.gmail.com> <20250228212048.GA2812743@google.com>
In-Reply-To: <20250228212048.GA2812743@google.com>
From: Bill Wendling <morbo@google.com>
Date: Fri, 28 Feb 2025 13:29:06 -0800
X-Gm-Features: AQ5f1JrI9-xg8yMWBknx8JPMjZcjjoD-wwtXnx_7ejGcNBpiyVaHSJIt4DfOzmM
Message-ID: <CAGG=3QXR8WNZhYTRT_cF76P+NkRNiK7Wd+8rpVc=2JVNrhXZEw@mail.gmail.com>
Subject: Re: [PATCH v2] x86/crc32: use builtins to improve code generation
To: Eric Biggers <ebiggers@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Justin Stitt <justinstitt@google.com>, LKML <linux-kernel@vger.kernel.org>, 
	linux-crypto@vger.kernel.org, clang-built-linux <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2025 at 1:20=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Thu, Feb 27, 2025 at 03:47:03PM -0800, Bill Wendling wrote:
> > For both gcc and clang, crc32 builtins generate better code than the
> > inline asm. GCC improves, removing unneeded "mov" instructions. Clang
> > does the same and unrolls the loops. GCC has no changes on i386, but
> > Clang's code generation is vastly improved, due to Clang's "rm"
> > constraint issue.
> >
> > The number of cycles improved by ~0.1% for GCC and ~1% for Clang, which
> > is expected because of the "rm" issue. However, Clang's performance is
> > better than GCC's by ~1.5%, most likely due to loop unrolling.
>
> Also note that the patch
> https://lore.kernel.org/r/20250210210741.471725-1-ebiggers@kernel.org/ (w=
hich is
> already enqueued in the crc tree for 6.15) changes "rm" to "r" when the c=
ompiler
> is clang, to improve clang's code generation.  The numbers you quote are =
against
> the original version, right?
>
Yeah, they were against top-of-tree.

-bw
