Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AF02FABE3
	for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2025 20:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763152436; cv=none; b=T/iExT7gZtB6+y4CKchWOIbXPL36CaFnRdJNCz7wT2G0YnQYcwQv6x5flZ+YQQ9BJjjK3yqoaMocc8Rw8rpQYeRx15cbIQYoxqElFBrznmGtq1Itd1cZqbTufJccaXh8lp7BWsGzV5hRxWzSEw0qsigUYKqKWCP7h3OpuVKRi4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763152436; c=relaxed/simple;
	bh=LhaA9nPEsAzGsE8Myhg2I0EH0s1kuDU/fMxqhQvgOas=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dcy/9pSpE2Zhmv+nqxesoNivNBQ9BKeFuTrX8ceyQ5VSi5/uZfB2HwXD97+CXHmdN+6pv4GiM18E6no+Pw0CEIwMDn3uNoNXV+u/YF3CBR2aMYi3xUs+JC6Yf+dYHyhduJTgFHKaaY3gu/r15vjtXBvPCyHK8ostWCKLf8rJqwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Id6V7zFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Id6V7zFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA60C19422
	for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2025 20:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763152436;
	bh=LhaA9nPEsAzGsE8Myhg2I0EH0s1kuDU/fMxqhQvgOas=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Id6V7zFI3y8rH0kA9rC2sqXiILUg9LL6asGOP9azALAoi5verTH+xXLXeD2jMXw3g
	 SmZmADOz39YmOBw7sIs0naOYdj9LV0Nt9bg4fLLPYw1k1BSXEQpBYCrEI8G6fEfjfP
	 r9+DNW0wfQVmQIY0RjhISKmRmeVL07/1qRRrj1zLLD4lbgCBJqBqEaBG4F5LOrNy0j
	 szenle25iuYSlsRUKIDdndnWcY5BzR2NdSjztiCfUUP/zd71XPa45BZwrmKPcmzq5N
	 9IYD3SBIOU8ipqQjm4cCufgagvOySdT8MYWnfeKeE3HdnEuWdulVOB02pEFzY4BOg6
	 +Ye2Dpc5ECVDg==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-594516d941cso2251416e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2025 12:33:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVNbyIDBL400AHawG6wQ6/1raqy8Hvst1tgQZsD6Q9s3mYPs7Y2fgodWfBpuoTpFEQ9rF5zU7BNFwabpv0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFZMbMCXYwSmTUfjMNil903vkW4RMO16PU69rQzb9uv/tOrYpv
	q1+ythtsKVuPn0bMdO4inEdftQ65VAf+nuVg0EXhdhr6Pu1pPayib1SA6AHF8E2gyMgLMWx2EoG
	r7OHVl845YFHqQEl1V9ggdikQq0M8kiQ=
X-Google-Smtp-Source: AGHT+IGvF+VMNJkVJEG3/BZ2cDSEyZ9W+Lk4S/ygZqRuc5EpK80o29GIXyiCdmmlAAKe+Zhqlq5YqfJNEU+EDhgUClo=
X-Received: by 2002:a05:6512:e9d:b0:594:364b:821a with SMTP id
 2adb3069b0e04-59584208956mr1594092e87.52.1763152434350; Fri, 14 Nov 2025
 12:33:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251114180706.318152-2-ardb+git@google.com> <aRePu_IMV5G76kHK@zx2c4.com>
In-Reply-To: <aRePu_IMV5G76kHK@zx2c4.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 14 Nov 2025 21:33:43 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG0RKOE4uQHfWnY1vU_FS+KUkZNNOLCrhC8dfbtf4PUjA@mail.gmail.com>
X-Gm-Features: AWmQ_bn0RYFL_oOxZKO6bgy1Ui2gsJ4-kNK-CbPoPlTsaBQ1jFj9ZMW16yMWZ5Y
Message-ID: <CAMj1kXG0RKOE4uQHfWnY1vU_FS+KUkZNNOLCrhC8dfbtf4PUjA@mail.gmail.com>
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-crypto@vger.kernel.org, 
	Eric Biggers <ebiggers@kernel.org>, arnd@arndb.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 14 Nov 2025 at 21:23, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Fri, Nov 14, 2025 at 07:07:07PM +0100, Ard Biesheuvel wrote:
> > void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src=
_len,
> >                                const u8 *ad, const size_t ad_len,
> >                                const u8 (*nonce)[XCHACHA20POLY1305_NONC=
E_SIZE],
> >                                const u8 (*key)[CHACHA20POLY1305_KEY_SIZ=
E])
> >
> > However, this variant is checked more strictly by the compiler, and onl=
y
> > arrays of the correct size are accepted as plain arguments (using the &
> > operator), and so inadvertent mixing up of arguments or passing buffers
> > of an incorrect size will trigger an error at build time.
>
> Interesting idea! And codegen is the same, you say?
>

Well, the address values passed into the functions are the same.
Whether or not some compilers may behave differently as a result is a
different matter: I suppose some heuristics may produce different
results knowing the fixed sizes of the inputs.

> There's another variant of this that doesn't change callsites and keeps
> the single pointer, which more accurate reflects what the function does:
>
> void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_l=
en,
>                                const u8 *ad, const size_t ad_len,
>                                const u8 nonce[static XCHACHA20POLY1305_NO=
NCE_SIZE],
>                                const u8 key[static CHACHA20POLY1305_KEY_S=
IZE])
>

Whoah!

> An obscure use of the `static` keyword, but this is what it's used for -
> telling the compiler what size you expect the object to be. Last time I
> investigated this, only clang respected it, but now it looks like gcc
> does too:
>
>     zx2c4@thinkpad /tmp $ cat a.c
>
>     void blah(unsigned char herp[static 7]);
>
>     static void schma(void)
>     {
>         unsigned char good[] =3D { 1, 2, 3, 4, 5, 6, 7 };
>         unsigned char bad[] =3D { 1, 2, 3, 4, 5, 6 };
>         blah(good);
>         blah(bad);
>     }
>     zx2c4@thinkpad /tmp $ gcc -c a.c
>     a.c: In function =E2=80=98schma=E2=80=99:
>     a.c:9:9: warning: =E2=80=98blah=E2=80=99 accessing 7 bytes in a regio=
n of size 6 [-Wstringop-overflow=3D]
>         9 |         blah(bad);
>           |         ^~~~~~~~~
>     a.c:9:9: note: referencing argument 1 of type =E2=80=98unsigned char[=
7]=E2=80=99
>     a.c:2:6: note: in a call to function =E2=80=98blah=E2=80=99
>         2 | void blah(unsigned char herp[static 7]);
>           |      ^~~~
>     zx2c4@thinkpad /tmp $ clang -c a.c
>     a.c:9:2: warning: array argument is too small; contains 6 elements, c=
allee requires at least 7
>           [-Warray-bounds]
>         9 |         blah(bad);
>           |         ^    ~~~
>     a.c:2:25: note: callee declares array parameter as static here
>         2 | void blah(unsigned char herp[static 7]);
>           |                         ^   ~~~~~~~~~~
>     1 warning generated.
>
>
> This doesn't account for buffers that are oversize -- the less dangerous
> case -- but maybe that's fine, to keep "normal" semantics of function
> calls and still get some checking? And adding `static` a bunch of places
> is easy.

Yeah if that is as portable as you say it is, it is a much better
solution, given that the minimum size is the most important:
inadvertently swapping two arguments will still result in a
diagnostic, unless the buffers are the same size, in which case there
is still a bug but not a memory safety issue. And passing a buffer
that is too large is not a memory safety issue either.

> It could apply much wider than just chapoly.
>

Yes, that was always the intent. I used this as an example because it
is low hanging fruit, given that it only has a single user.

> This all makes me wish we had NT's SAL notations though...
>

(quotation needed)
