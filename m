Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC31218591;
	Wed, 11 Jun 2025 16:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749659697; cv=none; b=pHMUBtjxAPWFbttpbhCYaHbqzl+AivQAR069yWZbIjNfVjEQ48mozOzFuIHEqBaZ2hxO/yUkxiPiU2TQTXjm0Y968XxcopFokzH+qTMM1KppGOIV5Jefb/nTB8r5h2cD7DQ7Q6on7+bfVWv2XKiDGeFk/T7zRUbH8WVVK/GWigY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749659697; c=relaxed/simple;
	bh=YnBjJCjZGkkrgSbru8fgRTSfROvOQq67aVGW6ZpVPgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MP/wI0hOM7COxBSajhZN4jX+WB8GjhWlK0LEA2krlKNbG3/wuQoAEEyUyreYDqQXTJ6HrgflE2ElCAv9d2NBhHheV0G3vQfdvC+suR8Jty0AZ2gk0fQdrexuiOKMfPzjZRGE/S54uvRrKw1DhHkQvd1ziCIX95iibAHN4TudoJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dB+LPFkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dB+LPFkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A1BC4CEE3;
	Wed, 11 Jun 2025 16:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749659695;
	bh=YnBjJCjZGkkrgSbru8fgRTSfROvOQq67aVGW6ZpVPgA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dB+LPFkpPB50dxO2SwKdjRyNRaC4GTJSF+jgfUyoydG4rqDU1/cAhbNfTSc4Zi6Df
	 cV8hG9u7FZ6UAF7suixSuRhW4+uJrn7i3DRvt3R0wPygCK3FUGNKhxalSjH8aXsUPd
	 pxWXAGsiEuQRHVLDEtNQkLeJJJu+Isfkoau6xj9RGtyfbdMSE9GH5KAjxfgOwqu/Oa
	 4hTDzIFuHtOcc8hbq1nVmumB6UOvemPyeCnkPO3/L89aimaVaFZt4DFf0+Oge2dYJF
	 k5oBFgO/bq0TEWR0qyGieLeOrCEvvx8lei1ZR18LWITEp/URmXPA/H89o8+Fsvy2UL
	 XG9XKd3xyk6TA==
Date: Wed, 11 Jun 2025 09:34:30 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Diederik de Haas <didi.debian@cknow.org>
Cc: linux-crypto@vger.kernel.org, linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 3/7] crypto: testmgr - replace
 CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS
Message-ID: <20250611163430.GA1254@sol>
References: <20250505203345.802740-1-ebiggers@kernel.org>
 <20250505203345.802740-4-ebiggers@kernel.org>
 <DAJOCL4UQWZ1.2CB0NH55US5EI@cknow.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DAJOCL4UQWZ1.2CB0NH55US5EI@cknow.org>

On Wed, Jun 11, 2025 at 01:41:06PM +0200, Diederik de Haas wrote:
> Hi Eric,
> 
> On Mon May 5, 2025 at 10:33 PM CEST, Eric Biggers wrote:
> > The negative-sense of CRYPTO_MANAGER_DISABLE_TESTS is a longstanding
> > mistake that regularly causes confusion.  Especially bad is that you can
> > have CRYPTO=n && CRYPTO_MANAGER_DISABLE_TESTS=n, which is ambiguous.
> >
> > Replace CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS which has the
> > expected behavior.
> >
> > The tests continue to be disabled by default.
> > ---
> >  <snip>
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > index da352f1984ea..8f1353bbba18 100644
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> >  <snip>
> > @@ -171,20 +171,26 @@ config CRYPTO_USER
> >  	select CRYPTO_MANAGER
> >  	help
> >  	  Userspace configuration for cryptographic instantiations such as
> >  	  cbc(aes).
> >  
> > -config CRYPTO_MANAGER_DISABLE_TESTS
> > -	bool "Disable run-time self tests"
> > -	default y
> > +config CRYPTO_SELFTESTS
> > +	bool "Enable cryptographic self-tests"
> > +	depends on DEBUG_KERNEL
> >  	help
> > -	  Disable run-time self tests that normally take place at
> > -	  algorithm registration.
> > +	  Enable the cryptographic self-tests.
> > +
> > +	  The cryptographic self-tests run at boot time, or at algorithm
> > +	  registration time if algorithms are dynamically loaded later.
> > +
> > +	  This is primarily intended for developer use.  It should not be
> > +	  enabled in production kernels, unless you are trying to use these
> > +	  tests to fulfill a FIPS testing requirement.
> 
> I built a 6.16-rc1 kernel [1] and its config is based upon Debian's and
> that has enabled CRYPTO_SELFTESTS [2] (due to Debian bug 599441 [3]).
> 
> I then installed it on 3 Rockchip based devices and booted into that.
> 1. Radxa Rock 5B (rk3588)
> 2. PINE64 Quartz64 Model B (rk3568)
> 3. PINE64 RockPro64 (rk3399)
> 
> The full dmesg output for level 0-4 can be found at [4], [5] and [6]
> 
> The filtered dmesg output for Rock 5B:
> ERROR:
> [    0.709822] basic hdkf test(hmac(sha256)): failed to allocate transform: -2
> WARNING:

https://lore.kernel.org/r/20250610191600.54994-1-ebiggers@kernel.org/ fixed the
HKDF failure.  It was caused by a patch that changed initcall levels.

> [    8.877288] alg: skcipher: skipping comparison tests for xctr-aes-ce because xctr(aes-generic) is unavailable

That's expected if you have CONFIG_CRYPTO_AES_ARM64_CE_BLK enabled but
CONFIG_CRYPTO_XCTR disabled.  Some tests are skipped in that case.

> [   14.172991] alg: ahash: rk-sha1 export() overran state buffer on test vector 0, cfg="import/export"
> [   14.202291] alg: ahash: rk-sha256 export() overran state buffer on test vector 0, cfg="import/export"
> [   14.230887] alg: ahash: rk-md5 export() overran state buffer on test vector 0, cfg="import/export"

That means the Rockchip crypto driver is broken.

It may have been broken for a long time.  Hardly anyone ever tests the hardware
crypto drivers, as they only work on very specific platforms and are often
useless anyway.  The software crypto is much better tested and often faster.

I don't think broken drivers like these should even be in the kernel at all.

For now, you should just disable CONFIG_CRYPTO_DEV_ROCKCHIP.

Anyway, the more interesting part of your email is that you pointed out that
Debian has the crypto self-tests enabled, precisely in order to automatically
disable buggy drivers like these.

And actually Fedora does this too.

This seems kind of crazy.  But unfortunately, the crypto/ philosophy seems to be
to enable as many untested and buggy drivers as possible, then rely on them
being (incompletely) self-tested in production.  So, aparently this is a thing.

But of course the distros won't want to enable the full set of tests, which
would slow down boot times significantly, but rather only the "fast" ones (as
they were doing before)...

So I'll send a patch that adds back a kconfig knob to run the fast tests only,
which I had removed in commit 698de822780f.

- Eric
