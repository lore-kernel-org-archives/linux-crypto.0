Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F6236AB71;
	Thu, 26 Feb 2026 18:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772129526; cv=none; b=LDbq3SEabfxs9A7632pKnxwxV/IyOKaS+NQGTQO6r0p+B8BzVCn2fwXkz7mgh2TkjdJbW9RAAQPxmBdqRT68Dp5vWQ/DgCRgqaglh5FAGhROLQzcsKeRFWlG9JKMSbtI2x8XyOTZm8SUa4nAqMZrLtqN6Hy6WXEda49sYzefM44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772129526; c=relaxed/simple;
	bh=8Cj4mVY38C6nhdFzrjSAka6RCIWO/rW2rKB3wTy3Mrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UXWvlQm4m3xsSftYP3TG8Q2Yk+i2XiCibztsfGFaHpZ19Zqq+/2ijFEXOu80ELye+J53YbW867f9kAVXPquOQkNVTIrzIG8D2Std+aYqfU8+Lw158GfTMVGQvr95HJlL6mQQst52yD+oDWIP+fZDhnpIcvsEV2mJYeLo2DmwQvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uorws0FB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uorws0FB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C8BC116C6;
	Thu, 26 Feb 2026 18:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772129525;
	bh=8Cj4mVY38C6nhdFzrjSAka6RCIWO/rW2rKB3wTy3Mrk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uorws0FBPDWAIpjNgZRvwPN30CfVU62ec1xMNL1dXXIixREopcQ7IA/snjB8enMNX
	 4M4DirIRgsvtXnogsIHu5KoLlilHDfujrSPV9lYQ49i+aFpDu4iAiOBA5V/dleIRNq
	 /lmx4vsKqbPgFMrjODdA20VP8LqrR+T2yyNXfhnd/Po3TNEFVkD8Ir+5nxFZ+9yBrE
	 0xk82X6+fhdbtZyFWRbLwIFXGA0S2SLkz8L1rzDYKSyjedMbbXnKwLd9xBRQ1tl0VS
	 80dTiyvlzr3/O/UZIB+K6Eldt1WeEFvlMr2dxBhsEFIQrUOTDJ+t9zlZext145mnF6
	 r+u2fReFBZuhg==
Date: Thu, 26 Feb 2026 10:11:14 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
	KUnit Development <kunit-dev@googlegroups.com>
Subject: Re: [PATCH 02/12] lib/crypto: tests: Add KUnit tests for NH
Message-ID: <20260226181114.GD2251@sol>
References: <20251211011846.8179-1-ebiggers@kernel.org>
 <20251211011846.8179-3-ebiggers@kernel.org>
 <CAMuHMdVFRQZXCKJBOBDJtpENvpVO39AxGMUFWVQdM6xKTpnYYw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVFRQZXCKJBOBDJtpENvpVO39AxGMUFWVQdM6xKTpnYYw@mail.gmail.com>

On Thu, Feb 26, 2026 at 02:12:38PM +0100, Geert Uytterhoeven wrote:
> Hi Eric,
> 
> On Thu, 11 Dec 2025 at 02:25, Eric Biggers <ebiggers@kernel.org> wrote:
> > Add some simple KUnit tests for the nh() function.
> >
> > These replace the test coverage which will be lost by removing the
> > nhpoly1305 crypto_shash.
> >
> > Note that the NH code also continues to be tested indirectly as well,
> > via the tests for the "adiantum(xchacha12,aes)" crypto_skcipher.
> >
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> 
> Thanks for your patch, which is now commit 7246fe6cd64475d8
> ("lib/crypto: tests: Add KUnit tests for NH") in v7.0-rc1.
> 
> > --- a/lib/crypto/tests/Kconfig
> > +++ b/lib/crypto/tests/Kconfig
> > @@ -45,10 +45,18 @@ config CRYPTO_LIB_MLDSA_KUNIT_TEST
> >         select CRYPTO_LIB_BENCHMARK_VISIBLE
> >         select CRYPTO_LIB_MLDSA
> >         help
> >           KUnit tests for the ML-DSA digital signature algorithm.
> >
> > +config CRYPTO_LIB_NH_KUNIT_TEST
> > +       tristate "KUnit tests for NH" if !KUNIT_ALL_TESTS
> > +       depends on KUNIT
> > +       default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
> > +       select CRYPTO_LIB_NH
> 
> This select means that enabling KUNIT_ALL_TESTS also enables
> extra functionality, which may not be desirable in a production system.
> Fortunately CRYPTO_LIB_NH is tristate, so in the modular case the
> extra functionality is a module, too, and not part of the running
> system by default.  Unfortunately CRYPTO_LIB_NH is invisible, so this
> cannot just be changed from "select" to "depends on".

I'll probably be changing this, pending the result of the discussion on
the similar thread about CRYPTO_LIB_MLDSA_KUNIT_TEST:
https://lore.kernel.org/linux-crypto/20260226180538.GC2251@sol/

- Eric
