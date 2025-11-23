Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0880948CFC;
	Sun, 23 Nov 2025 20:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763931378; cv=none; b=qLmOQF1vcg5SAtLkBbxYiDrVCODRauJ94Z+lR9kNjOb8kqyT4dTx1lm0bT+MSlfL3KjWM5+6CR4ssqV93uiMJ7EhJWGIMyinKFtxO9yFkG02A5ciyz7lhNJTf4Z6Bm4IGI8AIbNrm71bjHSl71LM+WMgmC8mLTeWlifgMrrFAvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763931378; c=relaxed/simple;
	bh=dgVe8EaC5VYykgcEfL6g04/NjhlH8rd7bFUGrpgMkGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L+1f0DtsfA+V+38xQeYsYOXuZRcq2403ewgr3oqrybscsJqid5N3t9/g2z6aWxo1gPveliCiaKK3+VRXk1+iGMcEFVB10wt3JoUtFukCd3DU1aje+YYbDZ01aF1RrLHnbLUzPFzZIjIwppOIptYIaZR5MLThmdv0IADMqq/QBMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R8vETfzk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R8vETfzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C771C113D0;
	Sun, 23 Nov 2025 20:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763931377;
	bh=dgVe8EaC5VYykgcEfL6g04/NjhlH8rd7bFUGrpgMkGo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R8vETfzkIHui9Smwmsiio114xTfGsfNP1gsP+2w+Ul8fVYnz63th+iVY8mn7ERdZJ
	 5oxp6hpS1L5p+rIZB9Mbem+DXSTrmiA/rSO1Vz0DjwEk3LiELMUJTuLU4xH8QzPblP
	 7tYvfEEakkTvcF08mkzY8pB1TJ21BhpfAmhfMQSttmxczZ7X2hoIt9+g1Re8SQNMCs
	 jyHpQ73bP/sYqkt0tj/gIKf+lhialprry3ZPxBQdJHvHcLGHYQsqW2jtiPK7YNH//A
	 ok9Fp2VuGDAbaIFR2An5q0/Ip9ilPdsyNDfq0ZvqQGP8I1pSligLr16OJ7OtTg0lXV
	 TZ+D93uQY1m6Q==
Date: Sun, 23 Nov 2025 12:54:31 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH 0/6] lib/crypto: More at_least decorations
Message-ID: <20251123205431.GE49083@sol>
References: <20251122194206.31822-1-ebiggers@kernel.org>
 <CAMj1kXFSL9=TWzv35mSwVMVaKAQ=3n=w93=1+VSfKyDe+0A+Ow@mail.gmail.com>
 <20251123203558.GD49083@sol>
 <CAHmME9qm8Xo6ccUUBm=QJ4X9BfTc3WgkmWohHsi_+xaGsgY4rw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHmME9qm8Xo6ccUUBm=QJ4X9BfTc3WgkmWohHsi_+xaGsgY4rw@mail.gmail.com>

On Sun, Nov 23, 2025 at 09:38:49PM +0100, Jason A. Donenfeld wrote:
> On Sun, Nov 23, 2025 at 9:37 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Sun, Nov 23, 2025 at 09:31:19AM +0100, Ard Biesheuvel wrote:
> > > On Sat, 22 Nov 2025 at 20:42, Eric Biggers <ebiggers@kernel.org> wrote:
> > > >
> > > > This series depends on the 'at_least' macro added by
> > > > https://lore.kernel.org/r/20251122025510.1625066-4-Jason@zx2c4.com
> > > > It can also be retrieved from
> > > >
> > > >     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git more-at-least-decorations-v1
> > > >
> > > > Add the at_least (i.e. 'static') decoration to the fixed-size array
> > > > parameters of more of the crypto library functions.  This causes clang
> > > > to generate a warning if a too-small array of known size is passed.
> > > >
> > >
> > > FTR GCC does so too.
> >
> > See https://lore.kernel.org/linux-crypto/20251115021430.GA2148@sol/
> > Unfortunately gcc puts these warnings under -Wstringop-overflow which
> > the kernel disables, so we don't see them.  clang works, though.
> 
> Is that disabling new?

No.

> Look at the commit message in my chapoly patch... The warning shown
> there happened from a real live kernel build.

Oh, there's actually a difference between const and non-const
parameters.  A const parameter gives -Wstringop-overread, while a
non-const one gives -Wstringop-overflow.  Only the latter is disabled.

- Eric
