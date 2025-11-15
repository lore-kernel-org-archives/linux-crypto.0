Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C281758B
	for <linux-crypto@vger.kernel.org>; Sat, 15 Nov 2025 02:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763172973; cv=none; b=cQEsa+r+E3gQR204x5UXaKzmCOtK4N2Qc9eWmjaX3PRF7fHvhdQox+nEsqeZVxX5uInoK0cJtxNNICK/iiMkBNXM5qVT85UhX1VC7HjsHzqJPD9apo5Y4r1OKVyv1cQiJ6IsHWhUB2bH7cR701mpHvPRNSE4udwov7PSX9fpwxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763172973; c=relaxed/simple;
	bh=T+w0VXNtp5zZKUsqLWZdEqjjJiojdy0U/f2sjZ5jaLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hHNUNAhsVvSf58JcoJY8/QtY/uSDlqwXguKeCSC0TqCzV8a/npDWoWenl6Ki3WJ77Ts626pVxa/l4TnQUDzr1AoGwDbSqPjB3Br0HaHF3ws4Uo5YY6/ypDWOMSMebngYXGPc7yPM9dB8uwm/uliBdvRkNCtK41V+lm3KvYXebPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=isQ+YJze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="isQ+YJze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047D0C4CEF1;
	Sat, 15 Nov 2025 02:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763172972;
	bh=T+w0VXNtp5zZKUsqLWZdEqjjJiojdy0U/f2sjZ5jaLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=isQ+YJzeFU/NDSQMITCXJcGNacHnCVfR7JeSZU6LcPudBHSp1VQIGbmGxSzOMF61D
	 V7eqczHra1HWM6eq3m9iWKN1zzygaUdjkndcA8sI/lqEaX/xKlUiIWNG6Gmw6H+yA0
	 lJf/psPTCgzK+sTX2uy18D4Fj9u9fEAC/K4O6q1IIrPj0iqYX/V+/i7TRGlithYQYp
	 BdEAvtxwZqXwY8z2RPi1K2h/LW9JSXF3+icNlAX0GzhvsLRjZ+g2G4bSksod5hS1a6
	 t5UTcGnVbmpaf5Fk0w0WiWsnQdkCwlCSsAk/DVH0wn2ReOx/4shuKUYa4BzrGjYRPw
	 W4Atd9uGLSw2w==
Date: Fri, 14 Nov 2025 18:14:30 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb+git@google.com>, linux-crypto@vger.kernel.org,
	arnd@arndb.de, Linus Torvalds <torvalds@linux-foundation.org>,
	Kees Cook <kees@kernel.org>
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
Message-ID: <20251115021430.GA2148@sol>
References: <20251114180706.318152-2-ardb+git@google.com>
 <aRePu_IMV5G76kHK@zx2c4.com>
 <CAMj1kXG0RKOE4uQHfWnY1vU_FS+KUkZNNOLCrhC8dfbtf4PUjA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMj1kXG0RKOE4uQHfWnY1vU_FS+KUkZNNOLCrhC8dfbtf4PUjA@mail.gmail.com>

[+Linus and Kees]

On Fri, Nov 14, 2025 at 09:33:43PM +0100, Ard Biesheuvel wrote:
> On Fri, 14 Nov 2025 at 21:23, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On Fri, Nov 14, 2025 at 07:07:07PM +0100, Ard Biesheuvel wrote:
> > > void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
> > >                                const u8 *ad, const size_t ad_len,
> > >                                const u8 (*nonce)[XCHACHA20POLY1305_NONCE_SIZE],
> > >                                const u8 (*key)[CHACHA20POLY1305_KEY_SIZE])
> > >
> > > However, this variant is checked more strictly by the compiler, and only
> > > arrays of the correct size are accepted as plain arguments (using the &
> > > operator), and so inadvertent mixing up of arguments or passing buffers
> > > of an incorrect size will trigger an error at build time.
> >
> > Interesting idea! And codegen is the same, you say?
> >
> 
> Well, the address values passed into the functions are the same.
> Whether or not some compilers may behave differently as a result is a
> different matter: I suppose some heuristics may produce different
> results knowing the fixed sizes of the inputs.
> 
> > There's another variant of this that doesn't change callsites and keeps
> > the single pointer, which more accurate reflects what the function does:
> >
> > void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
> >                                const u8 *ad, const size_t ad_len,
> >                                const u8 nonce[static XCHACHA20POLY1305_NONCE_SIZE],
> >                                const u8 key[static CHACHA20POLY1305_KEY_SIZE])
> >
> 
> Whoah!
> 
> > An obscure use of the `static` keyword, but this is what it's used for -
> > telling the compiler what size you expect the object to be. Last time I
> > investigated this, only clang respected it, but now it looks like gcc
> > does too:
> >
> >     zx2c4@thinkpad /tmp $ cat a.c
> >
> >     void blah(unsigned char herp[static 7]);
> >
> >     static void schma(void)
> >     {
> >         unsigned char good[] = { 1, 2, 3, 4, 5, 6, 7 };
> >         unsigned char bad[] = { 1, 2, 3, 4, 5, 6 };
> >         blah(good);
> >         blah(bad);
> >     }
> >     zx2c4@thinkpad /tmp $ gcc -c a.c
> >     a.c: In function ‘schma’:
> >     a.c:9:9: warning: ‘blah’ accessing 7 bytes in a region of size 6 [-Wstringop-overflow=]
> >         9 |         blah(bad);
> >           |         ^~~~~~~~~
> >     a.c:9:9: note: referencing argument 1 of type ‘unsigned char[7]’
> >     a.c:2:6: note: in a call to function ‘blah’
> >         2 | void blah(unsigned char herp[static 7]);
> >           |      ^~~~
> >     zx2c4@thinkpad /tmp $ clang -c a.c
> >     a.c:9:2: warning: array argument is too small; contains 6 elements, callee requires at least 7
> >           [-Warray-bounds]
> >         9 |         blah(bad);
> >           |         ^    ~~~
> >     a.c:2:25: note: callee declares array parameter as static here
> >         2 | void blah(unsigned char herp[static 7]);
> >           |                         ^   ~~~~~~~~~~
> >     1 warning generated.
> >
> >
> > This doesn't account for buffers that are oversize -- the less dangerous
> > case -- but maybe that's fine, to keep "normal" semantics of function
> > calls and still get some checking? And adding `static` a bunch of places
> > is easy.
> 
> Yeah if that is as portable as you say it is, it is a much better
> solution, given that the minimum size is the most important:
> inadvertently swapping two arguments will still result in a
> diagnostic, unless the buffers are the same size, in which case there
> is still a bug but not a memory safety issue. And passing a buffer
> that is too large is not a memory safety issue either.
> 
> > It could apply much wider than just chapoly.
> >
> 
> Yes, that was always the intent. I used this as an example because it
> is low hanging fruit, given that it only has a single user.
> 
> > This all makes me wish we had NT's SAL notations though...
> >
> 
> (quotation needed)

Those are some interesting ideas to make C a bit less bad!

I knew about the 'static' trick with array parameters, and I used to use
it in other projects.  It's a bit obscure, but it's in the C standard,
and both gcc and clang support the syntax.  It indeed causes clang to
start warning about too-small arrays, via -Warray-bounds which is
enabled by default.  So if we e.g. change:

    void sha256(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE]);

to

    void sha256(const u8 *data, size_t len, u8 out[static SHA256_DIGEST_SIZE]);

... then clang warns if a caller passes an array smaller than
SHA256_DIGEST_SIZE as 'out' (if its size is statically known).

gcc can actually warn about the too-small array regardless of 'static'.
However, gcc's warning is under -Wstringop-overflow, which we never see
because the kernel build system disables -Wstringop-overflow with gcc.

So, for now the benefit of adding 'static' would be to get warnings
about too-small arrays with one of the two supported compilers (clang).
It's too bad 'static' isn't the default behavior for array parameters in
C, but oh well...

I think it's worthwhile adding it to get better warnings, though we
should check with Linus whether he'd be okay with kernel code starting
to use this relatively obscure feature of C.

I think the 'static' trick would be better than Ard's suggestion of:

    void sha256(const u8 *data, size_t len, u8 (*out)[SHA256_DIGEST_SIZE]);

... since the "pointer to array of N elements" type would make things
difficult for callers that have any other type.  For example callers
wouldn't be able to directly use 'u8 *a', 'u8 a[M]' with size M > N, or
even a function argument 'u8 a[N]' since C implicitly converts that to
'u8 *'.  They'd need to cast it first.

- Eric
