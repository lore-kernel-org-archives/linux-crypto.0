Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6229B17F37F
	for <linux-crypto@vger.kernel.org>; Tue, 14 May 2024 17:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715706444; cv=none; b=sncobIx1bP70JDQoZ1ioUdHbGNoAH85S9vGIZ//v0rKONNX4oVt27EKJsIEXsxlTwjictQsv8RjBbumNMAN7LQoQVHgH+O1cxtZ9X/Mez6y/teX3YbkeEvK7+xCJ0li3Sr1MdIzeftkVBrt8K4+2knOCjPq8xchj90O1d2YUEpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715706444; c=relaxed/simple;
	bh=EVeLEj7Jswi8cg76AHCqyTRfsBAkt5bp4by2FNUmIwg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cy/q13un1DZ8DStzwUVrei3T+FYXA9T3r4Nx5TBu4ob3H647lkCTigR/zE17seQqSduX+e0bciQ+pRQW9pvbhakjT+LqCeOmnlI9BhylKQxy4q1deeBjar1x0Ow6JCrVGHUprt1X4hDDCReuFk97ro4dJnbVJVzhQu5wRx1pY2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W0ZSfUzf; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W0ZSfUzf"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a5a1054cf61so81419866b.1
        for <linux-crypto@vger.kernel.org>; Tue, 14 May 2024 10:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1715706440; x=1716311240; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3yZqNPwvXDORKPUW8oFHYhpNWnQ0WTMGBEW6etUKrK4=;
        b=W0ZSfUzfXXcRjz9699/BmTypgqAimzUMIXkvCdHDk5wH+2TX+kdf1NrJ6Z92Wp9ITx
         Z5EtC0PcoL97GKe++s4brT4oNXh1pl+I+JkTjvQgd1bf0sacquN6rBoG5TMCu9UiOf1O
         KL8vuWiiIOguVYk2DImIbKhHSz812eOsifouk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715706440; x=1716311240;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3yZqNPwvXDORKPUW8oFHYhpNWnQ0WTMGBEW6etUKrK4=;
        b=sM32eOeQiW0vtVSk+s4Ie0nV+L2GWDJhJvDqmhr4/WMIi6EzFA4pEu1H05kv75/WgP
         bvpuMrMPCLRjgsXI7r3rlp0Pn6s74bDAdlXQJK7nKWrYUQ2YMVXpMP94D93oMkWwahlM
         TwYMeg4lm5g2iTZEbRpZPuzdZ2O5VDPA+TVDoxRpi/SXylGG0zmnfISBD5J6qelZvtlt
         Tib4pHsubHqiI82NRC9iKB/j8vOOTVTIljxJDK0lDHPzn6hM6Dbu7i2K+zdiGN7njVrd
         yza0gF97QsrHCYrYhwD22OXGlaV38fW8s6cfKYolHYhvEQ4zRrB1L1Xcx1dh7zttgFTx
         G1mg==
X-Forwarded-Encrypted: i=1; AJvYcCVh3qzhz5ddMc3vb/IAlAH31QOCabd5TUqSnSABwUL7FNsfSoNtHXLlGQOhtkEYvt4brHCDAaZ26IIsTBfzJbSlMTG8BCLt2IAdSUNe
X-Gm-Message-State: AOJu0YwNwmxpxx2f0D5Z0xYrfDHXWKSqoySLj+lyDXattyCdBjnafx1C
	m011f6i9zwGpTFJCbzqXXhdaXS0s150W1znpmqbaTisJQP/z3Boyqy98mlphJ82vXL1rn8Ci3z2
	4N/pIFw==
X-Google-Smtp-Source: AGHT+IGydYzYrP2TuPwOEyqfcPsC09G/j5BuALLG7pCtnbxHELWmzZtS4xUM6lbZ3n+2chiwK6N8kQ==
X-Received: by 2002:a17:907:35d4:b0:a5a:7d28:54aa with SMTP id a640c23a62f3a-a5a7d285594mr320162266b.23.1715706440668;
        Tue, 14 May 2024 10:07:20 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a1781d342sm749277766b.6.2024.05.14.10.07.19
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 May 2024 10:07:19 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a59b81d087aso43731866b.3
        for <linux-crypto@vger.kernel.org>; Tue, 14 May 2024 10:07:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVq1CATgc6aw8j1hkcLeC4t3mLbCRQw+5lmyBz0UTxH1+dY5ZpfHrAzq/P559F7pAsyOqr/fJ6aTvHfqvi4AwaozEujknFJbuSU7z8I
X-Received: by 2002:a17:907:35d4:b0:a5a:7d28:54aa with SMTP id
 a640c23a62f3a-a5a7d285594mr320156966b.23.1715706439246; Tue, 14 May 2024
 10:07:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHk-=wi1T6wq1USBfU=NjdpSaTiKzV4H2gnUQfKa_mcXqOSk_w@mail.gmail.com>
 <CAHk-=wjmwmWv3sDCNq8c4VHWZUtZH72tDqR=TcgfpxTegL=aZw@mail.gmail.com> <ZkMKvAnyOR3_cJnS@wunner.de>
In-Reply-To: <ZkMKvAnyOR3_cJnS@wunner.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 May 2024 10:07:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=whRK3wdMoUd7UOL-R8GcfwYYLsy26ft-kHv5WaofyYe=Q@mail.gmail.com>
Message-ID: <CAHk-=whRK3wdMoUd7UOL-R8GcfwYYLsy26ft-kHv5WaofyYe=Q@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Update for 6.10
To: Lukas Wunner <lukas@wunner.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Julia Lawall <julia.lawall@inria.fr>, 
	Nicolas Palix <nicolas.palix@imag.fr>, cocci@inria.fr
Content-Type: text/plain; charset="UTF-8"

On Mon, 13 May 2024 at 23:54, Lukas Wunner <lukas@wunner.de> wrote:
>
> On Mon, May 13, 2024 at 03:12:53PM -0700, Linus Torvalds wrote:
> >
> > > https://lore.kernel.org/all/202404252210.KJE6Uw1h-lkp@intel.com/
> >
> > looks *very* much like the cases we've seen with clang in particular
> > where clang goes "this code isn't reachable, so I'll just drop
> > everything on the floor", and then it just becomes a fallthrough to
> > whatever else code happens to come next. Most of the time that's just
> > more (unrelated) code in the same function, but sometimes it causes
> > that "falls through to next function" instead, entirely randomly
> > depending on how the code was laid out.
>
> Curiously, this particular 0-day report is for gcc 13.2.0 though,
> not clang.

Hmm. I think all the previous reports of "falls through to next
function" that I have seen have been with clang, but that is probably
be selection bias: the gcc cases of this tend to be found so much more
quickly (because gcc is still more common at least on x86) that by the
time I see the reports, it's because of some clang issue.

And in fact, when I go test this theory by going to search on lore, I
do see several gcc reports.

So no, it was never just clang-only, it was just that the ones I had
looked at were about clang.

> The assume() macro had no effect with clang when I tested it.

I suspect that the issue is that with *normal* kernel configurations,
the code generation is simple and straightforward enough that gcc did
the right thing.

And then some more complicated setup with more debugging support
enabled (particularly things like UBSAN or KASAN) the code gets
complicated enough that gcc doesn't do the optimization any more, and
then the conditional in assume() doesn't get optimized away at an
early stage any more, and remains as a conditional branch to
la-la-land.

And you actually don't even see this as a warning unless the
la-la-land happens to be at the end of a function. IOW, the "branch to
nowhere" _could_ just branch to some label inside the function, and
the objtool sanity check would never even have triggered.

That's why "unreachable()" can be so dangerous. It tells the compiler
that code generation in one place no longer matters, and then the
compiler can decide to leave things just dangling in odd ways.

The code presumably still *works* - because the actual conditional
never triggers, so in that sense it's safe and fine. But it's still
just horrendous to try to figure out, which is why I was so down on
it.

              Linus
