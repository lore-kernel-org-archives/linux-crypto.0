Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FF4F9CB;
	Sat, 28 Jun 2025 01:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751073516; cv=none; b=cxKgXSZ3zSpAfvKrARxPmHbTuDiYObulScPOhcm7I2kN13pphz5FWF5AjteXBvUnr5jGlKsAtNl2EbvssQUPaNicwe52GcMdIvHJTa39HngP5Y0p7K3CXhS3cALlmBFGrR7KJxN/tCxkRzL0uPYdeirrcG5VKNTougd/0ae3x78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751073516; c=relaxed/simple;
	bh=XBp2nVw7oLlR80SnXP5dJ44WwJwGF1aZnFfOGqWqA7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uOZVUpg16Nnt1wE2sZg73sloyzDZrdXUST9+hkDkcNhOKw6Lrv5hnb3IbZX0uXN+hdcUb4AsmoriWv0VT2UwtIKoJ1TOPV4dPkOgsnaAHMs7d1BaczFmJA4cv3aFULB0N7M/zbqcDIstH0PG6x5b+7rYm/iTpF6bvIgi7GkgZZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FCBSmpB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FCBSmpB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E20C4CEE3;
	Sat, 28 Jun 2025 01:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751073516;
	bh=XBp2nVw7oLlR80SnXP5dJ44WwJwGF1aZnFfOGqWqA7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FCBSmpB0dhuUEeX13/kVmI3Tg7oMoVEDoafu2xaEJ5WQ08XRfXz9lGmHR2P2t+wVj
	 1jPUA+3wxNUE8grrY7oDbrGihyXerpEIS7ciW1TTPxudzlMO7Mq9M4anug1PK9bFRu
	 00lPvXjOLsSfkSiDNl86T2h9yfm5qW5hke3Nu49YTuPr495rpy2dmXwISoMKN/g20j
	 lWhouimJiy9WZ0P2GBqA6dI06yxMyK3xncT3XK7wDW0ak78wX66IdaSgOpQYnxZzqQ
	 TFtHQebnurs934Vv+L8PMhWtgRd9gWTQZ78mxG5uRmqanPTaWoASlW2rFg3MvY2egm
	 MTxd35uCpgQAQ==
Date: Sat, 28 Jun 2025 01:18:34 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PULL] Crypto library fix for v6.16-rc4
Message-ID: <20250628011834.GA1246405@google.com>
References: <20250627181428.GA1234@sol>
 <CAHk-=wiT=UUcgCVVo5ui_2Xb9fdg4JrPK=ZqpPxDhCgq9vynDg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiT=UUcgCVVo5ui_2Xb9fdg4JrPK=ZqpPxDhCgq9vynDg@mail.gmail.com>

On Fri, Jun 27, 2025 at 05:54:05PM -0700, Linus Torvalds wrote:
> On Fri, 27 Jun 2025 at 11:15, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Fix a regression where the purgatory code sometimes fails to build.
> 
> Hmm. This is obviously a fine and simple fix, but at the same time it
> smells to me that the underlying problem here is  that the purgatory
> code is just too damn fragile, and is being very incestuous with the
> sha2 code.
> 
> The purgatory code tends to be really special in so many other ways
> too (if you care, just look at how it plays games with compiler flags
> because it also doesn't want tracing code etc).
> 
> And when it comes to the crypto code, it plays games with just
> re-building the sha256.c file inside the purgatory directory, and is
> just generallyt being pretty hacky.
> 
> Anyway, I've pulled this because as long as it fixes the issue and you
> are ok with dealing with this crazy code I think it's all good.
> 
> But I also get the feeling that this should be very much seen as a
> purgatory code problem, not a crypto library problem.
> 
> We seem to have the same hacks for risc-v, s390 and x86, and I wonder
> if the safe thing to do long-term from a maintenance sanity standpoint
> would be to just make the purgatory code hackery use the generic
> sha256 implementation.
> 
> I say that purely as a "maybe it's not a good idea to mix the crazy
> purgatory code with the special arch-specific optimized code that may
> need special infrastructure".
> 
> The fact that the x86 sha256 routines do that whole irq_fpu_usable()
> thing etc is a symptom of that kind of "the architecture code is
> special".
> 
> But as long as you are fine with maintaining that arch-optimized code
> knowing that it gets (mis-)used by the strange purgatory code, I
> certainly don't mind the status quo with that one-liner fix.
> 
> So I guess this email is just me saying "if this keeps triggering
> problems, just make the purgatory code use the slow generic routines".
> 
> Because it's not necessarily worth the pain to support arch-optimized
> versions for that case.
> 
> If there is pain, that is.

Purgatory actually gets the generic SHA-256 code already.  The way it works is
that for purgatory lib/crypto/sha256.c is built with __DISABLE_EXPORTS defined,
and that file detects that and disables the arch-optimized code.  The
arch-optimized assembly code is not built into purgatory.

This isn't particularly hard to continue supporting, versus the alternative of
duplicating the generic SHA-256 code into a special file that's just for
purgatory.  5b90a779bc547 just made it unnecessarily fragile by relying on
compiler inlining to avoid a call to the arch-optimized code (which isn't built
into purgatory) from being generated.

My series
https://lore.kernel.org/linux-crypto/20250625070819.1496119-1-ebiggers@kernel.org/
makes it simpler and less fragile.  The #include of sha256-generic.c from
sha256.c goes away, and the selection of sha256_blocks() becomes just:

    #if defined(CONFIG_CRYPTO_LIB_SHA256_ARCH) && !defined(__DISABLE_EXPORTS)
    #include "sha256.h" /* $(SRCARCH)/sha256.h */
    #else
    #define sha256_blocks sha256_blocks_generic
    #endif

That patchset is targeting 6.17, though.  So we had to do this separate fix for
6.16 which has the odd sha256_choose_blocks() thing.

- Eric
